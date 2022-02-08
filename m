Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0CC4AD6BA
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 12:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355795AbiBHL3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 06:29:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355707AbiBHJwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 04:52:46 -0500
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A732AC03FEC6;
        Tue,  8 Feb 2022 01:52:44 -0800 (PST)
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id DBA6B202A0; Tue,  8 Feb 2022 17:46:33 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, linux-doc@vger.kernel.org
Subject: [PATCH net-next 2/5] mctp: tests: Add key state tests
Date:   Tue,  8 Feb 2022 17:46:14 +0800
Message-Id: <20220208094617.3675511-3-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220208094617.3675511-1-jk@codeconstruct.com.au>
References: <20220208094617.3675511-1-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change adds a few more tests to check the key/tag lookups on route
input. We add a specific entry to the keys lists, route a packet with
specific header values, and check for key match/mismatch.

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
---
 net/mctp/test/route-test.c | 138 +++++++++++++++++++++++++++++++++++++
 1 file changed, 138 insertions(+)

diff --git a/net/mctp/test/route-test.c b/net/mctp/test/route-test.c
index 5862f7fea01f..044d59e81f89 100644
--- a/net/mctp/test/route-test.c
+++ b/net/mctp/test/route-test.c
@@ -370,6 +370,7 @@ static void mctp_test_route_input_sk(struct kunit *test)
 #define FL_S	(MCTP_HDR_FLAG_SOM)
 #define FL_E	(MCTP_HDR_FLAG_EOM)
 #define FL_TO	(MCTP_HDR_FLAG_TO)
+#define FL_T(t)	((t) & MCTP_HDR_TAG_MASK)
 
 static const struct mctp_route_input_sk_test mctp_route_input_sk_tests[] = {
 	{ .hdr = RX_HDR(1, 10, 8, FL_S | FL_E | FL_TO), .type = 0, .deliver = true },
@@ -522,12 +523,149 @@ static void mctp_route_input_sk_reasm_to_desc(
 KUNIT_ARRAY_PARAM(mctp_route_input_sk_reasm, mctp_route_input_sk_reasm_tests,
 		  mctp_route_input_sk_reasm_to_desc);
 
+struct mctp_route_input_sk_keys_test {
+	const char	*name;
+	mctp_eid_t	key_peer_addr;
+	mctp_eid_t	key_local_addr;
+	u8		key_tag;
+	struct mctp_hdr hdr;
+	bool		deliver;
+};
+
+/* test packet rx in the presence of various key configurations */
+static void mctp_test_route_input_sk_keys(struct kunit *test)
+{
+	const struct mctp_route_input_sk_keys_test *params;
+	struct mctp_test_route *rt;
+	struct sk_buff *skb, *skb2;
+	struct mctp_test_dev *dev;
+	struct mctp_sk_key *key;
+	struct netns_mctp *mns;
+	struct mctp_sock *msk;
+	struct socket *sock;
+	unsigned long flags;
+	int rc;
+	u8 c;
+
+	params = test->param_value;
+
+	dev = mctp_test_create_dev();
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dev);
+
+	rt = mctp_test_create_route(&init_net, dev->mdev, 8, 68);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, rt);
+
+	rc = sock_create_kern(&init_net, AF_MCTP, SOCK_DGRAM, 0, &sock);
+	KUNIT_ASSERT_EQ(test, rc, 0);
+
+	msk = container_of(sock->sk, struct mctp_sock, sk);
+	mns = &sock_net(sock->sk)->mctp;
+
+	/* set the incoming tag according to test params */
+	key = mctp_key_alloc(msk, params->key_local_addr, params->key_peer_addr,
+			     params->key_tag, GFP_KERNEL);
+
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, key);
+
+	spin_lock_irqsave(&mns->keys_lock, flags);
+	mctp_reserve_tag(&init_net, key, msk);
+	spin_unlock_irqrestore(&mns->keys_lock, flags);
+
+	/* create packet and route */
+	c = 0;
+	skb = mctp_test_create_skb_data(&params->hdr, &c);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, skb);
+
+	skb->dev = dev->ndev;
+	__mctp_cb(skb);
+
+	rc = mctp_route_input(&rt->rt, skb);
+
+	/* (potentially) receive message */
+	skb2 = skb_recv_datagram(sock->sk, 0, 1, &rc);
+
+	if (params->deliver) {
+		KUNIT_EXPECT_NOT_ERR_OR_NULL(test, skb2);
+	} else {
+		KUNIT_EXPECT_PTR_EQ(test, skb2, NULL);
+	}
+
+	if (skb2)
+		skb_free_datagram(sock->sk, skb2);
+
+	mctp_key_unref(key);
+	__mctp_route_test_fini(test, dev, rt, sock);
+}
+
+static const struct mctp_route_input_sk_keys_test mctp_route_input_sk_keys_tests[] = {
+	{
+		.name = "direct match",
+		.key_peer_addr = 9,
+		.key_local_addr = 8,
+		.key_tag = 1,
+		.hdr = RX_HDR(1, 9, 8, FL_S | FL_E | FL_T(1)),
+		.deliver = true,
+	},
+	{
+		.name = "flipped src/dest",
+		.key_peer_addr = 8,
+		.key_local_addr = 9,
+		.key_tag = 1,
+		.hdr = RX_HDR(1, 9, 8, FL_S | FL_E | FL_T(1)),
+		.deliver = false,
+	},
+	{
+		.name = "peer addr mismatch",
+		.key_peer_addr = 9,
+		.key_local_addr = 8,
+		.key_tag = 1,
+		.hdr = RX_HDR(1, 10, 8, FL_S | FL_E | FL_T(1)),
+		.deliver = false,
+	},
+	{
+		.name = "tag value mismatch",
+		.key_peer_addr = 9,
+		.key_local_addr = 8,
+		.key_tag = 1,
+		.hdr = RX_HDR(1, 9, 8, FL_S | FL_E | FL_T(2)),
+		.deliver = false,
+	},
+	{
+		.name = "TO mismatch",
+		.key_peer_addr = 9,
+		.key_local_addr = 8,
+		.key_tag = 1,
+		.hdr = RX_HDR(1, 9, 8, FL_S | FL_E | FL_T(1) | FL_TO),
+		.deliver = false,
+	},
+	{
+		.name = "broadcast response",
+		.key_peer_addr = MCTP_ADDR_ANY,
+		.key_local_addr = 8,
+		.key_tag = 1,
+		.hdr = RX_HDR(1, 11, 8, FL_S | FL_E | FL_T(1)),
+		.deliver = true,
+	},
+};
+
+static void mctp_route_input_sk_keys_to_desc(
+				const struct mctp_route_input_sk_keys_test *t,
+				char *desc)
+{
+	sprintf(desc, "%s", t->name);
+}
+
+KUNIT_ARRAY_PARAM(mctp_route_input_sk_keys, mctp_route_input_sk_keys_tests,
+		  mctp_route_input_sk_keys_to_desc);
+
 static struct kunit_case mctp_test_cases[] = {
 	KUNIT_CASE_PARAM(mctp_test_fragment, mctp_frag_gen_params),
 	KUNIT_CASE_PARAM(mctp_test_rx_input, mctp_rx_input_gen_params),
 	KUNIT_CASE_PARAM(mctp_test_route_input_sk, mctp_route_input_sk_gen_params),
 	KUNIT_CASE_PARAM(mctp_test_route_input_sk_reasm,
 			 mctp_route_input_sk_reasm_gen_params),
+	KUNIT_CASE_PARAM(mctp_test_route_input_sk_keys,
+			 mctp_route_input_sk_keys_gen_params),
 	{}
 };
 
-- 
2.34.1


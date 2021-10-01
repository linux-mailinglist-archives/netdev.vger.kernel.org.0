Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F48E41E8F7
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 10:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352646AbhJAIVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 04:21:10 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:33750 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352296AbhJAIVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 04:21:05 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id D17E121467; Fri,  1 Oct 2021 16:19:15 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net-next 4/5] mctp: Add route input to socket tests
Date:   Fri,  1 Oct 2021 16:18:43 +0800
Message-Id: <20211001081844.3408786-5-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211001081844.3408786-1-jk@codeconstruct.com.au>
References: <20211001081844.3408786-1-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a few tests for single-packet route inputs, testing the
mctp_route_input function.

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
---
 net/mctp/test/route-test.c | 131 +++++++++++++++++++++++++++++++++++++
 1 file changed, 131 insertions(+)

diff --git a/net/mctp/test/route-test.c b/net/mctp/test/route-test.c
index ee0422bf24ce..efb621317ec5 100644
--- a/net/mctp/test/route-test.c
+++ b/net/mctp/test/route-test.c
@@ -94,6 +94,26 @@ static struct sk_buff *mctp_test_create_skb(const struct mctp_hdr *hdr,
 	return skb;
 }
 
+static struct sk_buff *__mctp_test_create_skb_data(const struct mctp_hdr *hdr,
+						   const void *data,
+						   size_t data_len)
+{
+	size_t hdr_len = sizeof(*hdr);
+	struct sk_buff *skb;
+
+	skb = alloc_skb(hdr_len + data_len, GFP_KERNEL);
+	if (!skb)
+		return NULL;
+
+	memcpy(skb_put(skb, hdr_len), hdr, hdr_len);
+	memcpy(skb_put(skb, data_len), data, data_len);
+
+	return skb;
+}
+
+#define mctp_test_create_skb_data(h, d) \
+	__mctp_test_create_skb_data(h, d, sizeof(*d))
+
 struct mctp_frag_test {
 	unsigned int mtu;
 	unsigned int msgsize;
@@ -253,9 +273,120 @@ static void mctp_rx_input_test_to_desc(const struct mctp_rx_input_test *t,
 KUNIT_ARRAY_PARAM(mctp_rx_input, mctp_rx_input_tests,
 		  mctp_rx_input_test_to_desc);
 
+/* set up a local dev, route on EID 8, and a socket listening on type 0 */
+static void __mctp_route_test_init(struct kunit *test,
+				   struct mctp_test_dev **devp,
+				   struct mctp_test_route **rtp,
+				   struct socket **sockp)
+{
+	struct sockaddr_mctp addr;
+	struct mctp_test_route *rt;
+	struct mctp_test_dev *dev;
+	struct socket *sock;
+	int rc;
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
+	addr.smctp_family = AF_MCTP;
+	addr.smctp_network = MCTP_NET_ANY;
+	addr.smctp_addr.s_addr = 8;
+	addr.smctp_type = 0;
+	rc = kernel_bind(sock, (struct sockaddr *)&addr, sizeof(addr));
+	KUNIT_ASSERT_EQ(test, rc, 0);
+
+	*rtp = rt;
+	*devp = dev;
+	*sockp = sock;
+}
+
+static void __mctp_route_test_fini(struct mctp_test_dev *dev,
+				   struct mctp_test_route *rt,
+				   struct socket *sock)
+{
+	sock_release(sock);
+	mctp_test_route_destroy(rt);
+	mctp_test_destroy_dev(dev);
+}
+
+struct mctp_route_input_sk_test {
+	struct mctp_hdr hdr;
+	u8 type;
+	bool deliver;
+};
+
+static void mctp_test_route_input_sk(struct kunit *test)
+{
+	const struct mctp_route_input_sk_test *params;
+	struct sk_buff *skb, *skb2;
+	struct mctp_test_route *rt;
+	struct mctp_test_dev *dev;
+	struct socket *sock;
+	int rc;
+
+	params = test->param_value;
+
+	__mctp_route_test_init(test, &dev, &rt, &sock);
+
+	skb = mctp_test_create_skb_data(&params->hdr, &params->type);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, skb);
+
+	skb->dev = dev->ndev;
+	__mctp_cb(skb);
+
+	rc = mctp_route_input(&rt->rt, skb);
+
+	if (params->deliver) {
+		KUNIT_EXPECT_EQ(test, rc, 0);
+
+		skb2 = skb_recv_datagram(sock->sk, 0, 1, &rc);
+		KUNIT_EXPECT_NOT_ERR_OR_NULL(test, skb2);
+		KUNIT_EXPECT_EQ(test, skb->len, 1);
+
+		skb_free_datagram(sock->sk, skb2);
+
+	} else {
+		KUNIT_EXPECT_NE(test, rc, 0);
+		skb2 = skb_recv_datagram(sock->sk, 0, 1, &rc);
+		KUNIT_EXPECT_PTR_EQ(test, skb2, NULL);
+	}
+
+	__mctp_route_test_fini(dev, rt, sock);
+}
+
+#define FL_S	(MCTP_HDR_FLAG_SOM)
+#define FL_E	(MCTP_HDR_FLAG_EOM)
+#define FL_T	(MCTP_HDR_FLAG_TO)
+
+static const struct mctp_route_input_sk_test mctp_route_input_sk_tests[] = {
+	{ .hdr = RX_HDR(1, 10, 8, FL_S | FL_E | FL_T), .type = 0, .deliver = true },
+	{ .hdr = RX_HDR(1, 10, 8, FL_S | FL_E | FL_T), .type = 1, .deliver = false },
+	{ .hdr = RX_HDR(1, 10, 8, FL_S | FL_E), .type = 0, .deliver = false },
+	{ .hdr = RX_HDR(1, 10, 8, FL_E | FL_T), .type = 0, .deliver = false },
+	{ .hdr = RX_HDR(1, 10, 8, FL_T), .type = 0, .deliver = false },
+	{ .hdr = RX_HDR(1, 10, 8, 0), .type = 0, .deliver = false },
+};
+
+static void mctp_route_input_sk_to_desc(const struct mctp_route_input_sk_test *t,
+					char *desc)
+{
+	sprintf(desc, "{%x,%x,%x,%x} type %d", t->hdr.ver, t->hdr.src,
+		t->hdr.dest, t->hdr.flags_seq_tag, t->type);
+}
+
+KUNIT_ARRAY_PARAM(mctp_route_input_sk, mctp_route_input_sk_tests,
+		  mctp_route_input_sk_to_desc);
+
 static struct kunit_case mctp_test_cases[] = {
 	KUNIT_CASE_PARAM(mctp_test_fragment, mctp_frag_gen_params),
 	KUNIT_CASE_PARAM(mctp_test_rx_input, mctp_rx_input_gen_params),
+	KUNIT_CASE_PARAM(mctp_test_route_input_sk, mctp_route_input_sk_gen_params),
 	{}
 };
 
-- 
2.33.0


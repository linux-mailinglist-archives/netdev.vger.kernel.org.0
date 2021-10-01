Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA0441E8F4
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 10:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352462AbhJAIVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 04:21:07 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:33730 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbhJAIVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 04:21:05 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 76F4721465; Fri,  1 Oct 2021 16:19:15 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net-next 3/5] mctp: Add packet rx tests
Date:   Fri,  1 Oct 2021 16:18:42 +0800
Message-Id: <20211001081844.3408786-4-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211001081844.3408786-1-jk@codeconstruct.com.au>
References: <20211001081844.3408786-1-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a few tests for the initial packet ingress through
mctp_pkttype_receive function; mainly packet header sanity checks. Full
input routing checks will be added as a separate change.

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
---
 net/mctp/test/route-test.c | 67 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 64 insertions(+), 3 deletions(-)

diff --git a/net/mctp/test/route-test.c b/net/mctp/test/route-test.c
index cf3b51183613..ee0422bf24ce 100644
--- a/net/mctp/test/route-test.c
+++ b/net/mctp/test/route-test.c
@@ -2,6 +2,8 @@
 
 #include <kunit/test.h>
 
+#include "utils.h"
+
 struct mctp_test_route {
 	struct mctp_route	rt;
 	struct sk_buff_head	pkts;
@@ -35,6 +37,7 @@ static struct mctp_test_route *mctp_route_test_alloc(void)
 }
 
 static struct mctp_test_route *mctp_test_create_route(struct net *net,
+						      struct mctp_dev *dev,
 						      mctp_eid_t eid,
 						      unsigned int mtu)
 {
@@ -48,7 +51,9 @@ static struct mctp_test_route *mctp_test_create_route(struct net *net,
 	rt->rt.max = eid;
 	rt->rt.mtu = mtu;
 	rt->rt.type = RTN_UNSPEC;
-	rt->rt.dev = NULL; /* somewhat illegal, but fine for current tests */
+	if (dev)
+		mctp_dev_hold(dev);
+	rt->rt.dev = dev;
 
 	list_add_rcu(&rt->rt.list, &net->mctp.routes);
 
@@ -62,11 +67,13 @@ static void mctp_test_route_destroy(struct mctp_test_route *rt)
 	rtnl_unlock();
 
 	skb_queue_purge(&rt->pkts);
+	if (rt->rt.dev)
+		mctp_dev_put(rt->rt.dev);
 
 	kfree_rcu(&rt->rt, rcu);
 }
 
-static struct sk_buff *mctp_test_create_skb(struct mctp_hdr *hdr,
+static struct sk_buff *mctp_test_create_skb(const struct mctp_hdr *hdr,
 					    unsigned int data_len)
 {
 	size_t hdr_len = sizeof(*hdr);
@@ -114,7 +121,7 @@ static void mctp_test_fragment(struct kunit *test)
 	skb = mctp_test_create_skb(&hdr, msgsize);
 	KUNIT_ASSERT_TRUE(test, skb);
 
-	rt = mctp_test_create_route(&init_net, 10, mtu);
+	rt = mctp_test_create_route(&init_net, NULL, 10, mtu);
 	KUNIT_ASSERT_TRUE(test, rt);
 
 	rc = mctp_do_fragment_route(&rt->rt, skb, mtu, MCTP_TAG_OWNER);
@@ -193,8 +200,62 @@ static void mctp_frag_test_to_desc(const struct mctp_frag_test *t, char *desc)
 
 KUNIT_ARRAY_PARAM(mctp_frag, mctp_frag_tests, mctp_frag_test_to_desc);
 
+struct mctp_rx_input_test {
+	struct mctp_hdr hdr;
+	bool input;
+};
+
+static void mctp_test_rx_input(struct kunit *test)
+{
+	const struct mctp_rx_input_test *params;
+	struct mctp_test_route *rt;
+	struct mctp_test_dev *dev;
+	struct sk_buff *skb;
+
+	params = test->param_value;
+
+	dev = mctp_test_create_dev();
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dev);
+
+	rt = mctp_test_create_route(&init_net, dev->mdev, 8, 68);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, rt);
+
+	skb = mctp_test_create_skb(&params->hdr, 1);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, skb);
+
+	__mctp_cb(skb);
+
+	mctp_pkttype_receive(skb, dev->ndev, &mctp_packet_type, NULL);
+
+	KUNIT_EXPECT_EQ(test, !!rt->pkts.qlen, params->input);
+
+	mctp_test_route_destroy(rt);
+	mctp_test_destroy_dev(dev);
+}
+
+#define RX_HDR(_ver, _src, _dest, _fst) \
+	{ .ver = _ver, .src = _src, .dest = _dest, .flags_seq_tag = _fst }
+
+/* we have a route for EID 8 only */
+static const struct mctp_rx_input_test mctp_rx_input_tests[] = {
+	{ .hdr = RX_HDR(1, 10, 8, 0), .input = true },
+	{ .hdr = RX_HDR(1, 10, 9, 0), .input = false }, /* no input route */
+	{ .hdr = RX_HDR(2, 10, 8, 0), .input = false }, /* invalid version */
+};
+
+static void mctp_rx_input_test_to_desc(const struct mctp_rx_input_test *t,
+				       char *desc)
+{
+	sprintf(desc, "{%x,%x,%x,%x}", t->hdr.ver, t->hdr.src, t->hdr.dest,
+		t->hdr.flags_seq_tag);
+}
+
+KUNIT_ARRAY_PARAM(mctp_rx_input, mctp_rx_input_tests,
+		  mctp_rx_input_test_to_desc);
+
 static struct kunit_case mctp_test_cases[] = {
 	KUNIT_CASE_PARAM(mctp_test_fragment, mctp_frag_gen_params),
+	KUNIT_CASE_PARAM(mctp_test_rx_input, mctp_rx_input_gen_params),
 	{}
 };
 
-- 
2.33.0


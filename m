Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E147041E8F8
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 10:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352534AbhJAIVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 04:21:17 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:33762 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352423AbhJAIVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 04:21:06 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 380F021468; Fri,  1 Oct 2021 16:19:16 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net-next 5/5] mctp: Add input reassembly tests
Date:   Fri,  1 Oct 2021 16:18:44 +0800
Message-Id: <20211001081844.3408786-6-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211001081844.3408786-1-jk@codeconstruct.com.au>
References: <20211001081844.3408786-1-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add multi-packet route input tests, for message reassembly. These will
feed packets to be received by a bound socket, or dropped.

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
---
 net/mctp/test/route-test.c | 134 +++++++++++++++++++++++++++++++++++++
 1 file changed, 134 insertions(+)

diff --git a/net/mctp/test/route-test.c b/net/mctp/test/route-test.c
index efb621317ec5..2785a8ea554c 100644
--- a/net/mctp/test/route-test.c
+++ b/net/mctp/test/route-test.c
@@ -383,10 +383,144 @@ static void mctp_route_input_sk_to_desc(const struct mctp_route_input_sk_test *t
 KUNIT_ARRAY_PARAM(mctp_route_input_sk, mctp_route_input_sk_tests,
 		  mctp_route_input_sk_to_desc);
 
+struct mctp_route_input_sk_reasm_test {
+	const char *name;
+	struct mctp_hdr hdrs[4];
+	int n_hdrs;
+	int rx_len;
+};
+
+static void mctp_test_route_input_sk_reasm(struct kunit *test)
+{
+	const struct mctp_route_input_sk_reasm_test *params;
+	struct sk_buff *skb, *skb2;
+	struct mctp_test_route *rt;
+	struct mctp_test_dev *dev;
+	struct socket *sock;
+	int i, rc;
+	u8 c;
+
+	params = test->param_value;
+
+	__mctp_route_test_init(test, &dev, &rt, &sock);
+
+	for (i = 0; i < params->n_hdrs; i++) {
+		c = i;
+		skb = mctp_test_create_skb_data(&params->hdrs[i], &c);
+		KUNIT_ASSERT_NOT_ERR_OR_NULL(test, skb);
+
+		skb->dev = dev->ndev;
+		__mctp_cb(skb);
+
+		rc = mctp_route_input(&rt->rt, skb);
+	}
+
+	skb2 = skb_recv_datagram(sock->sk, 0, 1, &rc);
+
+	if (params->rx_len) {
+		KUNIT_EXPECT_NOT_ERR_OR_NULL(test, skb2);
+		KUNIT_EXPECT_EQ(test, skb2->len, params->rx_len);
+		skb_free_datagram(sock->sk, skb2);
+
+	} else {
+		KUNIT_EXPECT_PTR_EQ(test, skb2, NULL);
+	}
+
+	__mctp_route_test_fini(dev, rt, sock);
+}
+
+#define RX_FRAG(f, s) RX_HDR(1, 10, 8, FL_T | (f) | ((s) << MCTP_HDR_SEQ_SHIFT))
+
+static const struct mctp_route_input_sk_reasm_test mctp_route_input_sk_reasm_tests[] = {
+	{
+		.name = "single packet",
+		.hdrs = {
+			RX_FRAG(FL_S | FL_E, 0),
+		},
+		.n_hdrs = 1,
+		.rx_len = 1,
+	},
+	{
+		.name = "single packet, offset seq",
+		.hdrs = {
+			RX_FRAG(FL_S | FL_E, 1),
+		},
+		.n_hdrs = 1,
+		.rx_len = 1,
+	},
+	{
+		.name = "start & end packets",
+		.hdrs = {
+			RX_FRAG(FL_S, 0),
+			RX_FRAG(FL_E, 1),
+		},
+		.n_hdrs = 2,
+		.rx_len = 2,
+	},
+	{
+		.name = "start & end packets, offset seq",
+		.hdrs = {
+			RX_FRAG(FL_S, 1),
+			RX_FRAG(FL_E, 2),
+		},
+		.n_hdrs = 2,
+		.rx_len = 2,
+	},
+	{
+		.name = "start & end packets, out of order",
+		.hdrs = {
+			RX_FRAG(FL_E, 1),
+			RX_FRAG(FL_S, 0),
+		},
+		.n_hdrs = 2,
+		.rx_len = 0,
+	},
+	{
+		.name = "start, middle & end packets",
+		.hdrs = {
+			RX_FRAG(FL_S, 0),
+			RX_FRAG(0,    1),
+			RX_FRAG(FL_E, 2),
+		},
+		.n_hdrs = 3,
+		.rx_len = 3,
+	},
+	{
+		.name = "missing seq",
+		.hdrs = {
+			RX_FRAG(FL_S, 0),
+			RX_FRAG(FL_E, 2),
+		},
+		.n_hdrs = 2,
+		.rx_len = 0,
+	},
+	{
+		.name = "seq wrap",
+		.hdrs = {
+			RX_FRAG(FL_S, 3),
+			RX_FRAG(FL_E, 0),
+		},
+		.n_hdrs = 2,
+		.rx_len = 2,
+	},
+};
+
+static void mctp_route_input_sk_reasm_to_desc(
+				const struct mctp_route_input_sk_reasm_test *t,
+				char *desc)
+{
+	sprintf(desc, "%s", t->name);
+}
+
+KUNIT_ARRAY_PARAM(mctp_route_input_sk_reasm, mctp_route_input_sk_reasm_tests,
+		  mctp_route_input_sk_reasm_to_desc);
+
 static struct kunit_case mctp_test_cases[] = {
 	KUNIT_CASE_PARAM(mctp_test_fragment, mctp_frag_gen_params),
 	KUNIT_CASE_PARAM(mctp_test_rx_input, mctp_rx_input_gen_params),
 	KUNIT_CASE_PARAM(mctp_test_route_input_sk, mctp_route_input_sk_gen_params),
+	KUNIT_CASE_PARAM(mctp_test_route_input_sk_reasm,
+			 mctp_route_input_sk_reasm_gen_params),
 	{}
 };
 
-- 
2.33.0


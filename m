Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 850CE41FF6E
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 05:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbhJCDTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 23:19:12 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:34336 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbhJCDTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 23:19:06 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 94B972148D; Sun,  3 Oct 2021 11:17:18 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net-next v2 1/5] mctp: Add initial test structure and fragmentation test
Date:   Sun,  3 Oct 2021 11:17:04 +0800
Message-Id: <20211003031708.132096-2-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211003031708.132096-1-jk@codeconstruct.com.au>
References: <20211003031708.132096-1-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change adds the first kunit test for the mctp subsystem, and an
initial test for the fragmentation path.

We're adding tests under a new net/mctp/test/ directory.

Incorporates a fix for module configs:

Reported-by: kernel test robot <lkp@intel.com>

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>

---
v2:
 - only enable tests when MCTP=y
 - strict route ref checking
---
 net/mctp/Kconfig           |   5 +
 net/mctp/route.c           |   5 +
 net/mctp/test/route-test.c | 217 +++++++++++++++++++++++++++++++++++++
 3 files changed, 227 insertions(+)
 create mode 100644 net/mctp/test/route-test.c

diff --git a/net/mctp/Kconfig b/net/mctp/Kconfig
index 2cdf3d0a28c9..868c92272cbd 100644
--- a/net/mctp/Kconfig
+++ b/net/mctp/Kconfig
@@ -11,3 +11,8 @@ menuconfig MCTP
 	  This option enables core MCTP support. For communicating with other
 	  devices, you'll want to enable a driver for a specific hardware
 	  channel.
+
+config MCTP_TEST
+        bool "MCTP core tests" if !KUNIT_ALL_TESTS
+        depends on MCTP=y && KUNIT=y
+        default KUNIT_ALL_TESTS
diff --git a/net/mctp/route.c b/net/mctp/route.c
index e20f3096d067..04781459b2be 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/idr.h>
+#include <linux/kconfig.h>
 #include <linux/mctp.h>
 #include <linux/netdevice.h>
 #include <linux/rtnetlink.h>
@@ -1228,3 +1229,7 @@ void __exit mctp_routes_exit(void)
 	rtnl_unregister(PF_MCTP, RTM_GETROUTE);
 	dev_remove_pack(&mctp_packet_type);
 }
+
+#if IS_ENABLED(CONFIG_MCTP_TEST)
+#include "test/route-test.c"
+#endif
diff --git a/net/mctp/test/route-test.c b/net/mctp/test/route-test.c
new file mode 100644
index 000000000000..5e029592f556
--- /dev/null
+++ b/net/mctp/test/route-test.c
@@ -0,0 +1,217 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <kunit/test.h>
+
+struct mctp_test_route {
+	struct mctp_route	rt;
+	struct sk_buff_head	pkts;
+};
+
+static int mctp_test_route_output(struct mctp_route *rt, struct sk_buff *skb)
+{
+	struct mctp_test_route *test_rt = container_of(rt, struct mctp_test_route, rt);
+
+	skb_queue_tail(&test_rt->pkts, skb);
+
+	return 0;
+}
+
+/* local version of mctp_route_alloc() */
+static struct mctp_test_route *mctp_route_test_alloc(void)
+{
+	struct mctp_test_route *rt;
+
+	rt = kzalloc(sizeof(*rt), GFP_KERNEL);
+	if (!rt)
+		return NULL;
+
+	INIT_LIST_HEAD(&rt->rt.list);
+	refcount_set(&rt->rt.refs, 1);
+	rt->rt.output = mctp_test_route_output;
+
+	skb_queue_head_init(&rt->pkts);
+
+	return rt;
+}
+
+static struct mctp_test_route *mctp_test_create_route(struct net *net,
+						      mctp_eid_t eid,
+						      unsigned int mtu)
+{
+	struct mctp_test_route *rt;
+
+	rt = mctp_route_test_alloc();
+	if (!rt)
+		return NULL;
+
+	rt->rt.min = eid;
+	rt->rt.max = eid;
+	rt->rt.mtu = mtu;
+	rt->rt.type = RTN_UNSPEC;
+	rt->rt.dev = NULL; /* somewhat illegal, but fine for current tests */
+
+	list_add_rcu(&rt->rt.list, &net->mctp.routes);
+
+	return rt;
+}
+
+static void mctp_test_route_destroy(struct kunit *test,
+				    struct mctp_test_route *rt)
+{
+	unsigned int refs;
+
+	rtnl_lock();
+	list_del_rcu(&rt->rt.list);
+	rtnl_unlock();
+
+	skb_queue_purge(&rt->pkts);
+
+	refs = refcount_read(&rt->rt.refs);
+	KUNIT_ASSERT_EQ_MSG(test, refs, 1, "route ref imbalance");
+
+	kfree_rcu(&rt->rt, rcu);
+}
+
+static struct sk_buff *mctp_test_create_skb(struct mctp_hdr *hdr,
+					    unsigned int data_len)
+{
+	size_t hdr_len = sizeof(*hdr);
+	struct sk_buff *skb;
+	unsigned int i;
+	u8 *buf;
+
+	skb = alloc_skb(hdr_len + data_len, GFP_KERNEL);
+	if (!skb)
+		return NULL;
+
+	memcpy(skb_put(skb, hdr_len), hdr, hdr_len);
+
+	buf = skb_put(skb, data_len);
+	for (i = 0; i < data_len; i++)
+		buf[i] = i & 0xff;
+
+	return skb;
+}
+
+struct mctp_frag_test {
+	unsigned int mtu;
+	unsigned int msgsize;
+	unsigned int n_frags;
+};
+
+static void mctp_test_fragment(struct kunit *test)
+{
+	const struct mctp_frag_test *params;
+	int rc, i, n, mtu, msgsize;
+	struct mctp_test_route *rt;
+	struct sk_buff *skb;
+	struct mctp_hdr hdr;
+	u8 seq;
+
+	params = test->param_value;
+	mtu = params->mtu;
+	msgsize = params->msgsize;
+
+	hdr.ver = 1;
+	hdr.src = 8;
+	hdr.dest = 10;
+	hdr.flags_seq_tag = MCTP_HDR_FLAG_TO;
+
+	skb = mctp_test_create_skb(&hdr, msgsize);
+	KUNIT_ASSERT_TRUE(test, skb);
+
+	rt = mctp_test_create_route(&init_net, 10, mtu);
+	KUNIT_ASSERT_TRUE(test, rt);
+
+	/* The refcount would usually be incremented as part of a route lookup,
+	 * but we're setting the route directly here.
+	 */
+	refcount_inc(&rt->rt.refs);
+
+	rc = mctp_do_fragment_route(&rt->rt, skb, mtu, MCTP_TAG_OWNER);
+	KUNIT_EXPECT_FALSE(test, rc);
+
+	n = rt->pkts.qlen;
+
+	KUNIT_EXPECT_EQ(test, n, params->n_frags);
+
+	for (i = 0;; i++) {
+		struct mctp_hdr *hdr2;
+		struct sk_buff *skb2;
+		u8 tag_mask, seq2;
+		bool first, last;
+
+		first = i == 0;
+		last = i == (n - 1);
+
+		skb2 = skb_dequeue(&rt->pkts);
+
+		if (!skb2)
+			break;
+
+		hdr2 = mctp_hdr(skb2);
+
+		tag_mask = MCTP_HDR_TAG_MASK | MCTP_HDR_FLAG_TO;
+
+		KUNIT_EXPECT_EQ(test, hdr2->ver, hdr.ver);
+		KUNIT_EXPECT_EQ(test, hdr2->src, hdr.src);
+		KUNIT_EXPECT_EQ(test, hdr2->dest, hdr.dest);
+		KUNIT_EXPECT_EQ(test, hdr2->flags_seq_tag & tag_mask,
+				hdr.flags_seq_tag & tag_mask);
+
+		KUNIT_EXPECT_EQ(test,
+				!!(hdr2->flags_seq_tag & MCTP_HDR_FLAG_SOM), first);
+		KUNIT_EXPECT_EQ(test,
+				!!(hdr2->flags_seq_tag & MCTP_HDR_FLAG_EOM), last);
+
+		seq2 = (hdr2->flags_seq_tag >> MCTP_HDR_SEQ_SHIFT) &
+			MCTP_HDR_SEQ_MASK;
+
+		if (first) {
+			seq = seq2;
+		} else {
+			seq++;
+			KUNIT_EXPECT_EQ(test, seq2, seq & MCTP_HDR_SEQ_MASK);
+		}
+
+		if (!last)
+			KUNIT_EXPECT_EQ(test, skb2->len, mtu);
+		else
+			KUNIT_EXPECT_LE(test, skb2->len, mtu);
+
+		kfree_skb(skb2);
+	}
+
+	mctp_test_route_destroy(test, rt);
+}
+
+static const struct mctp_frag_test mctp_frag_tests[] = {
+	{.mtu = 68, .msgsize = 63, .n_frags = 1},
+	{.mtu = 68, .msgsize = 64, .n_frags = 1},
+	{.mtu = 68, .msgsize = 65, .n_frags = 2},
+	{.mtu = 68, .msgsize = 66, .n_frags = 2},
+	{.mtu = 68, .msgsize = 127, .n_frags = 2},
+	{.mtu = 68, .msgsize = 128, .n_frags = 2},
+	{.mtu = 68, .msgsize = 129, .n_frags = 3},
+	{.mtu = 68, .msgsize = 130, .n_frags = 3},
+};
+
+static void mctp_frag_test_to_desc(const struct mctp_frag_test *t, char *desc)
+{
+	sprintf(desc, "mtu %d len %d -> %d frags",
+		t->msgsize, t->mtu, t->n_frags);
+}
+
+KUNIT_ARRAY_PARAM(mctp_frag, mctp_frag_tests, mctp_frag_test_to_desc);
+
+static struct kunit_case mctp_test_cases[] = {
+	KUNIT_CASE_PARAM(mctp_test_fragment, mctp_frag_gen_params),
+	{}
+};
+
+static struct kunit_suite mctp_test_suite = {
+	.name = "mctp",
+	.test_cases = mctp_test_cases,
+};
+
+kunit_test_suite(mctp_test_suite);
-- 
2.33.0


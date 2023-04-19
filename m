Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1D96E7A0C
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 14:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233068AbjDSMxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 08:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232440AbjDSMxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 08:53:04 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71AD1E6E;
        Wed, 19 Apr 2023 05:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=27t540M/9xlv1Y13vJd9c01N+25NZMLlAGDknad7XFg=;
        t=1681908782; x=1683118382; b=sAhAgQ//Bjm1OqvEyBmwCmONf6RCCi6M2CjyqAMuYXmH+dC
        XHzcmdzlGVJs7TK+Veba3yITvjm2na8ls5H0bvW5fJHuCKamB+P54ids/p+lF/p2QUHuEfQgEfagr
        JRl07vQ1F8ZmUq/dJ/CT27rTEL4z7jBZ4ifjI0Gl5DRLk9S5RYR6OeG+OIyjvQ7A6N1YnHLNd4SbW
        +7peFNBrm6kkCCNAdXES64KWLJCu0CJQhOFTnDkYxLi046rkKYoYuJVetiGsXrBU0aEqmY6jZXpPe
        8fBv3rBKe6DZlocWx8pz1RARox0FRx9lvx0PV46T4Ax7zkE0fFhl7QHuFWdgfprQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pp7Ix-002YjR-10;
        Wed, 19 Apr 2023 14:52:59 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH net-next v4 2/3] net: extend drop reasons for multiple subsystems
Date:   Wed, 19 Apr 2023 14:52:53 +0200
Message-Id: <20230419125254.20789-2-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230419125254.20789-1-johannes@sipsolutions.net>
References: <20230419125254.20789-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Extend drop reasons to make them usable by subsystems
other than core by reserving the high 16 bits for a
new subsystem ID, of which 0 of course is used for the
existing reasons immediately.

To still be able to have string reasons, restructure
that code a bit to make the loopup under RCU, the only
user of this (right now) is drop_monitor.

Link: https://lore.kernel.org/netdev/00659771ed54353f92027702c5bbb84702da62ce.camel@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
v3:
 - new dropreason.h now that core codes are in dropreason-core.h
 - annotate RCU pointer init for sparse
v4:
 - fix kernel-doc, indentation
---
 include/net/dropreason-core.h | 14 ++++++---
 include/net/dropreason.h      | 31 ++++++++++++++++++
 net/core/drop_monitor.c       | 33 ++++++++++++++------
 net/core/skbuff.c             | 59 +++++++++++++++++++++++++++++++++--
 4 files changed, 121 insertions(+), 16 deletions(-)
 create mode 100644 include/net/dropreason.h

diff --git a/include/net/dropreason-core.h b/include/net/dropreason-core.h
index ade6d5b9186c..a2b953b57689 100644
--- a/include/net/dropreason-core.h
+++ b/include/net/dropreason-core.h
@@ -340,12 +340,20 @@ enum skb_drop_reason {
 	 */
 	SKB_DROP_REASON_IPV6_NDISC_NS_OTHERHOST,
 	/**
-	 * @SKB_DROP_REASON_MAX: the maximum of drop reason, which shouldn't be
-	 * used as a real 'reason'
+	 * @SKB_DROP_REASON_MAX: the maximum of core drop reasons, which
+	 * shouldn't be used as a real 'reason' - only for tracing code gen
 	 */
 	SKB_DROP_REASON_MAX,
+
+	/**
+	 * @SKB_DROP_REASON_SUBSYS_MASK: subsystem mask in drop reasons,
+	 * see &enum skb_drop_reason_subsys
+	 */
+	SKB_DROP_REASON_SUBSYS_MASK = 0xffff0000,
 };
 
+#define SKB_DROP_REASON_SUBSYS_SHIFT	16
+
 #define SKB_DR_INIT(name, reason)				\
 	enum skb_drop_reason name = SKB_DROP_REASON_##reason
 #define SKB_DR(name)						\
@@ -359,6 +367,4 @@ enum skb_drop_reason {
 			SKB_DR_SET(name, reason);		\
 	} while (0)
 
-extern const char * const drop_reasons[];
-
 #endif
diff --git a/include/net/dropreason.h b/include/net/dropreason.h
new file mode 100644
index 000000000000..f0f2378dbed0
--- /dev/null
+++ b/include/net/dropreason.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef _LINUX_DROPREASON_H
+#define _LINUX_DROPREASON_H
+#include <net/dropreason-core.h>
+
+/**
+ * enum skb_drop_reason_subsys - subsystem tag for (extended) drop reasons
+ */
+enum skb_drop_reason_subsys {
+	/** @SKB_DROP_REASON_SUBSYS_CORE: core drop reasons defined above */
+	SKB_DROP_REASON_SUBSYS_CORE,
+
+	/** @SKB_DROP_REASON_SUBSYS_NUM: number of subsystems defined */
+	SKB_DROP_REASON_SUBSYS_NUM
+};
+
+struct drop_reason_list {
+	const char * const *reasons;
+	size_t n_reasons;
+};
+
+/* Note: due to dynamic registrations, access must be under RCU */
+extern const struct drop_reason_list __rcu *
+drop_reasons_by_subsys[SKB_DROP_REASON_SUBSYS_NUM];
+
+void drop_reasons_register_subsys(enum skb_drop_reason_subsys subsys,
+				  const struct drop_reason_list *list);
+void drop_reasons_unregister_subsys(enum skb_drop_reason_subsys subsys);
+
+#endif
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 5a782d1d8fd3..aff31cd944c2 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -21,6 +21,7 @@
 #include <linux/workqueue.h>
 #include <linux/netlink.h>
 #include <linux/net_dropmon.h>
+#include <linux/bitfield.h>
 #include <linux/percpu.h>
 #include <linux/timer.h>
 #include <linux/bitops.h>
@@ -29,6 +30,7 @@
 #include <net/genetlink.h>
 #include <net/netevent.h>
 #include <net/flow_offload.h>
+#include <net/dropreason.h>
 #include <net/devlink.h>
 
 #include <trace/events/skb.h>
@@ -504,8 +506,6 @@ static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
 	if (!nskb)
 		return;
 
-	if (unlikely(reason >= SKB_DROP_REASON_MAX || reason <= 0))
-		reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	cb = NET_DM_SKB_CB(nskb);
 	cb->reason = reason;
 	cb->pc = location;
@@ -552,9 +552,9 @@ static size_t net_dm_in_port_size(void)
 }
 
 #define NET_DM_MAX_SYMBOL_LEN 40
+#define NET_DM_MAX_REASON_LEN 50
 
-static size_t net_dm_packet_report_size(size_t payload_len,
-					enum skb_drop_reason reason)
+static size_t net_dm_packet_report_size(size_t payload_len)
 {
 	size_t size;
 
@@ -576,7 +576,7 @@ static size_t net_dm_packet_report_size(size_t payload_len,
 	       /* NET_DM_ATTR_PROTO */
 	       nla_total_size(sizeof(u16)) +
 	       /* NET_DM_ATTR_REASON */
-	       nla_total_size(strlen(drop_reasons[reason]) + 1) +
+	       nla_total_size(NET_DM_MAX_REASON_LEN + 1) +
 	       /* NET_DM_ATTR_PAYLOAD */
 	       nla_total_size(payload_len);
 }
@@ -610,6 +610,8 @@ static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
 				     size_t payload_len)
 {
 	struct net_dm_skb_cb *cb = NET_DM_SKB_CB(skb);
+	const struct drop_reason_list *list = NULL;
+	unsigned int subsys, subsys_reason;
 	char buf[NET_DM_MAX_SYMBOL_LEN];
 	struct nlattr *attr;
 	void *hdr;
@@ -627,9 +629,24 @@ static int net_dm_packet_report_fill(struct sk_buff *msg, struct sk_buff *skb,
 			      NET_DM_ATTR_PAD))
 		goto nla_put_failure;
 
+	rcu_read_lock();
+	subsys = u32_get_bits(cb->reason, SKB_DROP_REASON_SUBSYS_MASK);
+	if (subsys < SKB_DROP_REASON_SUBSYS_NUM)
+		list = rcu_dereference(drop_reasons_by_subsys[subsys]);
+	subsys_reason = cb->reason & ~SKB_DROP_REASON_SUBSYS_MASK;
+	if (!list ||
+	    subsys_reason >= list->n_reasons ||
+	    !list->reasons[subsys_reason] ||
+	    strlen(list->reasons[subsys_reason]) > NET_DM_MAX_REASON_LEN) {
+		list = rcu_dereference(drop_reasons_by_subsys[SKB_DROP_REASON_SUBSYS_CORE]);
+		subsys_reason = SKB_DROP_REASON_NOT_SPECIFIED;
+	}
 	if (nla_put_string(msg, NET_DM_ATTR_REASON,
-			   drop_reasons[cb->reason]))
+			   list->reasons[subsys_reason])) {
+		rcu_read_unlock();
 		goto nla_put_failure;
+	}
+	rcu_read_unlock();
 
 	snprintf(buf, sizeof(buf), "%pS", cb->pc);
 	if (nla_put_string(msg, NET_DM_ATTR_SYMBOL, buf))
@@ -687,9 +704,7 @@ static void net_dm_packet_report(struct sk_buff *skb)
 	if (net_dm_trunc_len)
 		payload_len = min_t(size_t, net_dm_trunc_len, payload_len);
 
-	msg = nlmsg_new(net_dm_packet_report_size(payload_len,
-						  NET_DM_SKB_CB(skb)->reason),
-			GFP_KERNEL);
+	msg = nlmsg_new(net_dm_packet_report_size(payload_len), GFP_KERNEL);
 	if (!msg)
 		goto out;
 
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 050a875d09c5..cf3b6b5d0b50 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -58,6 +58,7 @@
 #include <linux/scatterlist.h>
 #include <linux/errqueue.h>
 #include <linux/prefetch.h>
+#include <linux/bitfield.h>
 #include <linux/if_vlan.h>
 #include <linux/mpls.h>
 #include <linux/kcov.h>
@@ -72,6 +73,7 @@
 #include <net/mptcp.h>
 #include <net/mctp.h>
 #include <net/page_pool.h>
+#include <net/dropreason.h>
 
 #include <linux/uaccess.h>
 #include <trace/events/skb.h>
@@ -122,11 +124,59 @@ EXPORT_SYMBOL(sysctl_max_skb_frags);
 
 #undef FN
 #define FN(reason) [SKB_DROP_REASON_##reason] = #reason,
-const char * const drop_reasons[] = {
+static const char * const drop_reasons[] = {
 	[SKB_CONSUMED] = "CONSUMED",
 	DEFINE_DROP_REASON(FN, FN)
 };
-EXPORT_SYMBOL(drop_reasons);
+
+static const struct drop_reason_list drop_reasons_core = {
+	.reasons = drop_reasons,
+	.n_reasons = ARRAY_SIZE(drop_reasons),
+};
+
+const struct drop_reason_list __rcu *
+drop_reasons_by_subsys[SKB_DROP_REASON_SUBSYS_NUM] = {
+	[SKB_DROP_REASON_SUBSYS_CORE] = RCU_INITIALIZER(&drop_reasons_core),
+};
+EXPORT_SYMBOL(drop_reasons_by_subsys);
+
+/**
+ * drop_reasons_register_subsys - register another drop reason subsystem
+ * @subsys: the subsystem to register, must not be the core
+ * @list: the list of drop reasons within the subsystem, must point to
+ *	a statically initialized list
+ */
+void drop_reasons_register_subsys(enum skb_drop_reason_subsys subsys,
+				  const struct drop_reason_list *list)
+{
+	if (WARN(subsys <= SKB_DROP_REASON_SUBSYS_CORE ||
+		 subsys >= ARRAY_SIZE(drop_reasons_by_subsys),
+		 "invalid subsystem %d\n", subsys))
+		return;
+
+	/* must point to statically allocated memory, so INIT is OK */
+	RCU_INIT_POINTER(drop_reasons_by_subsys[subsys], list);
+}
+EXPORT_SYMBOL_GPL(drop_reasons_register_subsys);
+
+/**
+ * drop_reasons_unregister_subsys - unregister a drop reason subsystem
+ * @subsys: the subsystem to remove, must not be the core
+ *
+ * Note: This will synchronize_rcu() to ensure no users when it returns.
+ */
+void drop_reasons_unregister_subsys(enum skb_drop_reason_subsys subsys)
+{
+	if (WARN(subsys <= SKB_DROP_REASON_SUBSYS_CORE ||
+		 subsys >= ARRAY_SIZE(drop_reasons_by_subsys),
+		 "invalid subsystem %d\n", subsys))
+		return;
+
+	RCU_INIT_POINTER(drop_reasons_by_subsys[subsys], NULL);
+
+	synchronize_rcu();
+}
+EXPORT_SYMBOL_GPL(drop_reasons_unregister_subsys);
 
 /**
  *	skb_panic - private function for out-of-line support
@@ -984,7 +1034,10 @@ bool __kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason)
 	if (unlikely(!skb_unref(skb)))
 		return false;
 
-	DEBUG_NET_WARN_ON_ONCE(reason <= 0 || reason >= SKB_DROP_REASON_MAX);
+	DEBUG_NET_WARN_ON_ONCE(reason == SKB_NOT_DROPPED_YET ||
+			       u32_get_bits(reason,
+					    SKB_DROP_REASON_SUBSYS_MASK) >=
+				SKB_DROP_REASON_SUBSYS_NUM);
 
 	if (reason == SKB_CONSUMED)
 		trace_consume_skb(skb, __builtin_return_address(0));
-- 
2.40.0


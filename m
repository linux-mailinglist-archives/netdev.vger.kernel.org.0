Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A65C05A5F1E
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 11:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbiH3JS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 05:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbiH3JSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 05:18:53 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91025D7411
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 02:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661851131; x=1693387131;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Fesw1W7SiY57DTFnFsjvyxOJeR2wyGZS2eK6hmRYpsc=;
  b=Ydu43wHRigAdzpqzcdF2BJ0k+Z3wOGZK0Ly2W5tkMpkqNRa/rrOJvOhP
   fI73dc/Tjc9tfnqeMKBVS/S0lVznpp39nSvMBLUOod0tHwMf9fdjosOHp
   Sn7+O6WWO6+znnDl9A0fovDJ0ObLxiNr3w47sPaqb+eEOAQHAl5HdmUvS
   KjA/s1SXQp5B4DPRCmU5OnMGZHfRe6ZR2nqy+H+hQEJ2ItEW/Pau09+KK
   g5zsv1Sg+ynwb94DZymZeHKSnrztQ7WjWjuDrdXbw2o2tmSa1yIZZAxAE
   9y18q9rWuhAyObTVD59f6MaIv9+mVEFh2AEPdb8NMgA42Mx7V6tqp7tL4
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="295129442"
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="295129442"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 02:18:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="611636995"
Received: from anambiarhost.jf.intel.com ([10.166.29.163])
  by orsmga002.jf.intel.com with ESMTP; 30 Aug 2022 02:18:50 -0700
Subject: [net-next PATCH 2/3] act_skbedit: Offload skbedit queue mapping for
 receive queue
From:   Amritha Nambiar <amritha.nambiar@intel.com>
To:     netdev@vger.kernel.org, kuba@kernel.org
Cc:     alexander.h.duyck@intel.com, jhs@mojatatu.com, jiri@resnulli.us,
        xiyou.wangcong@gmail.com, vinicius.gomes@intel.com,
        sridhar.samudrala@intel.com, amritha.nambiar@intel.com
Date:   Tue, 30 Aug 2022 02:28:49 -0700
Message-ID: <166185172977.65874.7720275131119808012.stgit@anambiarhost.jf.intel.com>
In-Reply-To: <166185158175.65874.17492440987811366231.stgit@anambiarhost.jf.intel.com>
References: <166185158175.65874.17492440987811366231.stgit@anambiarhost.jf.intel.com>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for offloading skbedit queue mapping action on
receive side. This enables offloading filters for receive
queue selection in the hardware using the skbedit action.
Traffic arrives on the Rx queue requested in the skbedit
action parameter. A new tc action flag TCA_ACT_FLAGS_AT_INGRESS
is introduced to identify the traffic direction the action
queue_mapping is requested on during filter addition.
This is used to disallow offloading the skbedit queue mapping
action on transmit side.

Example:
$tc filter add dev $IFACE ingress protocol ip flower dst_ip $DST_IP\
skip_sw action skbedit queue_mapping $rxq_id

Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Signed-off-by: Amritha Nambiar <amritha.nambiar@intel.com>
---
 include/net/act_api.h           |    1 +
 include/net/flow_offload.h      |    2 ++
 include/net/tc_act/tc_skbedit.h |   11 +++++++++++
 net/sched/act_skbedit.c         |   11 +++++++++--
 net/sched/cls_api.c             |    7 +++++++
 5 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 9cf6870b526e..7eb78519d579 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -67,6 +67,7 @@ struct tc_action {
 #define TCA_ACT_FLAGS_BIND	(1U << (TCA_ACT_FLAGS_USER_BITS + 1))
 #define TCA_ACT_FLAGS_REPLACE	(1U << (TCA_ACT_FLAGS_USER_BITS + 2))
 #define TCA_ACT_FLAGS_NO_RTNL	(1U << (TCA_ACT_FLAGS_USER_BITS + 3))
+#define TCA_ACT_FLAGS_AT_INGRESS	(1U << (TCA_ACT_FLAGS_USER_BITS + 4))
 
 /* Update lastuse only if needed, to avoid dirtying a cache line.
  * We use a temp variable to avoid fetching jiffies twice.
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 2a9a9e42e7fd..8b7786343a03 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -149,6 +149,7 @@ enum flow_action_id {
 	FLOW_ACTION_MARK,
 	FLOW_ACTION_PTYPE,
 	FLOW_ACTION_PRIORITY,
+	FLOW_ACTION_RX_QUEUE_MAPPING,
 	FLOW_ACTION_WAKE,
 	FLOW_ACTION_QUEUE,
 	FLOW_ACTION_SAMPLE,
@@ -241,6 +242,7 @@ struct flow_action_entry {
 		u32			csum_flags;	/* FLOW_ACTION_CSUM */
 		u32			mark;		/* FLOW_ACTION_MARK */
 		u16                     ptype;          /* FLOW_ACTION_PTYPE */
+		u16			rx_queue;	/* FLOW_ACTION_RX_QUEUE_MAPPING */
 		u32			priority;	/* FLOW_ACTION_PRIORITY */
 		struct {				/* FLOW_ACTION_QUEUE */
 			u32		ctx;
diff --git a/include/net/tc_act/tc_skbedit.h b/include/net/tc_act/tc_skbedit.h
index dc1079f28e13..07145aafb0f1 100644
--- a/include/net/tc_act/tc_skbedit.h
+++ b/include/net/tc_act/tc_skbedit.h
@@ -95,6 +95,17 @@ static inline u32 tcf_skbedit_priority(const struct tc_action *a)
 	return priority;
 }
 
+static inline u16 tcf_skbedit_rx_queue_mapping(const struct tc_action *a)
+{
+	u16 rx_queue;
+
+	rcu_read_lock();
+	rx_queue = rcu_dereference(to_skbedit(a)->params)->queue_mapping;
+	rcu_read_unlock();
+
+	return rx_queue;
+}
+
 /* Return true iff action is queue_mapping */
 static inline bool is_tcf_skbedit_queue_mapping(const struct tc_action *a)
 {
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index 9b8274d09117..f5d92ba916e6 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -410,8 +410,12 @@ static int tcf_skbedit_offload_act_setup(struct tc_action *act, void *entry_data
 			entry->id = FLOW_ACTION_PRIORITY;
 			entry->priority = tcf_skbedit_priority(act);
 		} else if (is_tcf_skbedit_queue_mapping(act)) {
-			NL_SET_ERR_MSG_MOD(extack, "Offload not supported when \"queue_mapping\" option is used");
-			return -EOPNOTSUPP;
+			if (!(act->tcfa_flags & TCA_ACT_FLAGS_AT_INGRESS)) {
+				NL_SET_ERR_MSG_MOD(extack, "Offload not supported when \"queue_mapping\" option is used on transmit side");
+				return -EOPNOTSUPP;
+			}
+			entry->id = FLOW_ACTION_RX_QUEUE_MAPPING;
+			entry->rx_queue = tcf_skbedit_rx_queue_mapping(act);
 		} else if (is_tcf_skbedit_inheritdsfield(act)) {
 			NL_SET_ERR_MSG_MOD(extack, "Offload not supported when \"inheritdsfield\" option is used");
 			return -EOPNOTSUPP;
@@ -429,6 +433,9 @@ static int tcf_skbedit_offload_act_setup(struct tc_action *act, void *entry_data
 			fl_action->id = FLOW_ACTION_PTYPE;
 		else if (is_tcf_skbedit_priority(act))
 			fl_action->id = FLOW_ACTION_PRIORITY;
+		else if (is_tcf_skbedit_queue_mapping(act) &&
+			 (act->tcfa_flags & TCA_ACT_FLAGS_AT_INGRESS))
+			fl_action->id = FLOW_ACTION_RX_QUEUE_MAPPING;
 		else
 			return -EOPNOTSUPP;
 	}
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 1ebab4b11262..9cc11395396b 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1953,6 +1953,11 @@ static void tfilter_put(struct tcf_proto *tp, void *fh)
 		tp->ops->put(tp, fh);
 }
 
+static bool is_qdisc_ingress(__u32 classid)
+{
+	return (TC_H_MIN(classid) == TC_H_MIN(TC_H_MIN_INGRESS));
+}
+
 static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 			  struct netlink_ext_ack *extack)
 {
@@ -2143,6 +2148,8 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 		flags |= TCA_ACT_FLAGS_REPLACE;
 	if (!rtnl_held)
 		flags |= TCA_ACT_FLAGS_NO_RTNL;
+	if (is_qdisc_ingress(parent))
+		flags |= TCA_ACT_FLAGS_AT_INGRESS;
 	err = tp->ops->change(net, skb, tp, cl, t->tcm_handle, tca, &fh,
 			      flags, extack);
 	if (err == 0) {


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4B0607161
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 09:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbiJUHrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 03:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiJUHrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 03:47:41 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA122248C9F
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 00:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666338460; x=1697874460;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5P0xm8DD5P6IFsYcjN90ab+pIslMmPoTxdRhxFguOWM=;
  b=Ll+7cy5BCSiuAzX8MOVIH5Jj3hF/lnX2zHkQqcuZ0qVbxn4fwfz8rUVN
   Np664QgfivNirpie9+6tdqOw8/tkYW+Lfpn/o3a65JihIKUGk5k6C/rHH
   Zg6MnBtEYHZFJbQnEztCft8QXezKuJZYgAfTanBoboU4VCcb9mIzFT8Bc
   gFqmVZvPOi6mtZ6VRbZzYFzqitkqhTDoZrNR0X8wqCbLTKhqt76H8WZoJ
   5nhsNcDhodvgMsmwTU5yM9q0abXTrqM8C+gdqTlIMNf4VjJbxySUleAIJ
   tqZBSUre0A/vrpHQbUYUlnXJ1oRyjNszwHt13zK+FBmWKsNvWohEDAmtr
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="306932862"
X-IronPort-AV: E=Sophos;i="5.95,200,1661842800"; 
   d="scan'208";a="306932862"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 00:47:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="699198864"
X-IronPort-AV: E=Sophos;i="5.95,200,1661842800"; 
   d="scan'208";a="699198864"
Received: from anambiarhost.jf.intel.com ([10.166.29.163])
  by fmsmga004.fm.intel.com with ESMTP; 21 Oct 2022 00:47:40 -0700
Subject: [net-next PATCH v3 1/3] act_skbedit: skbedit queue mapping for
 receive queue
From:   Amritha Nambiar <amritha.nambiar@intel.com>
To:     netdev@vger.kernel.org, kuba@kernel.org
Cc:     alexander.duyck@gmail.com, jhs@mojatatu.com, jiri@resnulli.us,
        xiyou.wangcong@gmail.com, vinicius.gomes@intel.com,
        sridhar.samudrala@intel.com, amritha.nambiar@intel.com
Date:   Fri, 21 Oct 2022 00:58:39 -0700
Message-ID: <166633911976.52141.3907831602027668289.stgit@anambiarhost.jf.intel.com>
In-Reply-To: <166633888716.52141.3425659377117969638.stgit@anambiarhost.jf.intel.com>
References: <166633888716.52141.3425659377117969638.stgit@anambiarhost.jf.intel.com>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for skbedit queue mapping action on receive
side. This is supported only in hardware, so the skip_sw
flag is enforced. This enables offloading filters for
receive queue selection in the hardware using the
skbedit action. Traffic arrives on the Rx queue requested
in the skbedit action parameter. A new tc action flag
TCA_ACT_FLAGS_AT_INGRESS is introduced to identify the
traffic direction the action queue_mapping is requested
on during filter addition. This is used to disallow
offloading the skbedit queue mapping action on transmit
side.

Example:
$tc filter add dev $IFACE ingress protocol ip flower dst_ip $DST_IP\
 action skbedit queue_mapping $rxq_id skip_sw

Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Signed-off-by: Amritha Nambiar <amritha.nambiar@intel.com>
---
 include/net/act_api.h           |    1 +
 include/net/flow_offload.h      |    2 ++
 include/net/tc_act/tc_skbedit.h |   29 +++++++++++++++++++++++++++++
 net/sched/act_skbedit.c         |   14 ++++++++++++--
 net/sched/cls_api.c             |    7 +++++++
 5 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 61f2ceb3939e..c94ea1a306e0 100644
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
index e343f9f8363e..7a60bc6d72c9 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -155,6 +155,7 @@ enum flow_action_id {
 	FLOW_ACTION_MARK,
 	FLOW_ACTION_PTYPE,
 	FLOW_ACTION_PRIORITY,
+	FLOW_ACTION_RX_QUEUE_MAPPING,
 	FLOW_ACTION_WAKE,
 	FLOW_ACTION_QUEUE,
 	FLOW_ACTION_SAMPLE,
@@ -247,6 +248,7 @@ struct flow_action_entry {
 		u32			csum_flags;	/* FLOW_ACTION_CSUM */
 		u32			mark;		/* FLOW_ACTION_MARK */
 		u16                     ptype;          /* FLOW_ACTION_PTYPE */
+		u16			rx_queue;	/* FLOW_ACTION_RX_QUEUE_MAPPING */
 		u32			priority;	/* FLOW_ACTION_PRIORITY */
 		struct {				/* FLOW_ACTION_QUEUE */
 			u32		ctx;
diff --git a/include/net/tc_act/tc_skbedit.h b/include/net/tc_act/tc_skbedit.h
index dc1079f28e13..9649600fb3dc 100644
--- a/include/net/tc_act/tc_skbedit.h
+++ b/include/net/tc_act/tc_skbedit.h
@@ -95,12 +95,41 @@ static inline u32 tcf_skbedit_priority(const struct tc_action *a)
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
 	return is_tcf_skbedit_with_flag(a, SKBEDIT_F_QUEUE_MAPPING);
 }
 
+/* Return true if action is on ingress traffic */
+static inline bool is_tcf_skbedit_ingress(u32 flags)
+{
+	return flags & TCA_ACT_FLAGS_AT_INGRESS;
+}
+
+static inline bool is_tcf_skbedit_tx_queue_mapping(const struct tc_action *a)
+{
+	return is_tcf_skbedit_queue_mapping(a) &&
+	       !is_tcf_skbedit_ingress(a->tcfa_flags);
+}
+
+static inline bool is_tcf_skbedit_rx_queue_mapping(const struct tc_action *a)
+{
+	return is_tcf_skbedit_queue_mapping(a) &&
+	       is_tcf_skbedit_ingress(a->tcfa_flags);
+}
+
 /* Return true iff action is inheritdsfield */
 static inline bool is_tcf_skbedit_inheritdsfield(const struct tc_action *a)
 {
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index 7f598784fd30..1710780c908a 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -148,6 +148,11 @@ static int tcf_skbedit_init(struct net *net, struct nlattr *nla,
 	}
 
 	if (tb[TCA_SKBEDIT_QUEUE_MAPPING] != NULL) {
+		if (is_tcf_skbedit_ingress(act_flags) &&
+		    !(act_flags & TCA_ACT_FLAGS_SKIP_SW)) {
+			NL_SET_ERR_MSG_MOD(extack, "\"queue_mapping\" option on receive side is hardware only, use skip_sw");
+			return -EOPNOTSUPP;
+		}
 		flags |= SKBEDIT_F_QUEUE_MAPPING;
 		queue_mapping = nla_data(tb[TCA_SKBEDIT_QUEUE_MAPPING]);
 	}
@@ -374,9 +379,12 @@ static int tcf_skbedit_offload_act_setup(struct tc_action *act, void *entry_data
 		} else if (is_tcf_skbedit_priority(act)) {
 			entry->id = FLOW_ACTION_PRIORITY;
 			entry->priority = tcf_skbedit_priority(act);
-		} else if (is_tcf_skbedit_queue_mapping(act)) {
-			NL_SET_ERR_MSG_MOD(extack, "Offload not supported when \"queue_mapping\" option is used");
+		} else if (is_tcf_skbedit_tx_queue_mapping(act)) {
+			NL_SET_ERR_MSG_MOD(extack, "Offload not supported when \"queue_mapping\" option is used on transmit side");
 			return -EOPNOTSUPP;
+		} else if (is_tcf_skbedit_rx_queue_mapping(act)) {
+			entry->id = FLOW_ACTION_RX_QUEUE_MAPPING;
+			entry->rx_queue = tcf_skbedit_rx_queue_mapping(act);
 		} else if (is_tcf_skbedit_inheritdsfield(act)) {
 			NL_SET_ERR_MSG_MOD(extack, "Offload not supported when \"inheritdsfield\" option is used");
 			return -EOPNOTSUPP;
@@ -394,6 +402,8 @@ static int tcf_skbedit_offload_act_setup(struct tc_action *act, void *entry_data
 			fl_action->id = FLOW_ACTION_PTYPE;
 		else if (is_tcf_skbedit_priority(act))
 			fl_action->id = FLOW_ACTION_PRIORITY;
+		else if (is_tcf_skbedit_rx_queue_mapping(act))
+			fl_action->id = FLOW_ACTION_RX_QUEUE_MAPPING;
 		else
 			return -EOPNOTSUPP;
 	}
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 50566db45949..23d1cfa4f58c 100644
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
@@ -2144,6 +2149,8 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 		flags |= TCA_ACT_FLAGS_REPLACE;
 	if (!rtnl_held)
 		flags |= TCA_ACT_FLAGS_NO_RTNL;
+	if (is_qdisc_ingress(parent))
+		flags |= TCA_ACT_FLAGS_AT_INGRESS;
 	err = tp->ops->change(net, skb, tp, cl, t->tcm_handle, tca, &fh,
 			      flags, extack);
 	if (err == 0) {


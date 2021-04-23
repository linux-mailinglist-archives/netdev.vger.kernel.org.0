Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E219369BE0
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 23:08:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244139AbhDWVJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 17:09:24 -0400
Received: from mga05.intel.com ([192.55.52.43]:21825 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244200AbhDWVIn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Apr 2021 17:08:43 -0400
IronPort-SDR: eulU1QiYBl/szX4YUVIAEuJ+WzOefaBmPmLuMx3cXYFpMSYOGXcsqSzUvgeWPRHfrNOwS1f4iW
 TgdIhsvU5AtA==
X-IronPort-AV: E=McAfee;i="6200,9189,9963"; a="281460835"
X-IronPort-AV: E=Sophos;i="5.82,246,1613462400"; 
   d="scan'208";a="281460835"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2021 14:08:04 -0700
IronPort-SDR: yPm0lIOLonxrifhNLdENq8XGXWGecfJMrP7ouK9MGO3au7SK1ugp0+bzK0lCNiJKJSdNJLuapH
 dwr6hgKyxMcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,246,1613462400"; 
   d="scan'208";a="446693712"
Received: from anambiarhost.jf.intel.com ([10.166.224.238])
  by fmsmga004.fm.intel.com with ESMTP; 23 Apr 2021 14:08:04 -0700
Subject: [net-next,RFC PATCH] net: Extend TC limit beyond 16 to 255
From:   Amritha Nambiar <amritha.nambiar@intel.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     jhs@mojatatu.com, jiri@resnulli.us, xiyou.wangcong@gmail.com,
        john.fastabend@gmail.com, alexander.duyck@gmail.com,
        vinicius.gomes@intel.com, vedang.patel@intel.com,
        sridhar.samudrala@intel.com, amritha.nambiar@intel.com
Date:   Fri, 23 Apr 2021 14:12:20 -0700
Message-ID: <161921234046.33211.14393307850365339307.stgit@anambiarhost.jf.intel.com>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend the max limit of TCs to 255 (max value of 8-bit num_tc)
from current max of 16. This would allow creating more than 16
queue-sets and offloading them on devices with large number of
queues using the mqprio scheduler.
Also, changed the static allocation of struct
tc_mqprio_qopt_offload mqprio to dynamic allocation on heap to
fit within frame size as the size of attributes increases
proportionally with the max number of TCs.

Signed-off-by: Amritha Nambiar <amritha.nambiar@intel.com>
---
 include/linux/netdevice.h      |    6 ++---
 include/uapi/linux/pkt_sched.h |    6 ++---
 net/core/dev.c                 |    2 +-
 net/sched/sch_mqprio.c         |   52 +++++++++++++++++++++++++++-------------
 net/sched/sch_taprio.c         |    6 ++---
 5 files changed, 45 insertions(+), 27 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 5cbc950b34df..676f245651d9 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -804,8 +804,8 @@ struct xps_dev_maps {
 
 #endif /* CONFIG_XPS */
 
-#define TC_MAX_QUEUE	16
-#define TC_BITMASK	15
+#define TC_MAX_QUEUE	255
+#define TC_BITMASK	255
 /* HW offloaded queuing disciplines txq count and offset maps */
 struct netdev_tc_txq {
 	u16 count;
@@ -2219,7 +2219,7 @@ struct net_device {
 #endif
 	s16			num_tc;
 	struct netdev_tc_txq	tc_to_txq[TC_MAX_QUEUE];
-	u8			prio_tc_map[TC_BITMASK + 1];
+	u8			prio_tc_map[TC_BITMASK];
 
 #if IS_ENABLED(CONFIG_FCOE)
 	unsigned int		fcoe_ddp_xid;
diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index 79a699f106b1..b5d733135900 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -692,8 +692,8 @@ struct tc_drr_stats {
 };
 
 /* MQPRIO */
-#define TC_QOPT_BITMASK 15
-#define TC_QOPT_MAX_QUEUE 16
+#define TC_QOPT_BITMASK 255
+#define TC_QOPT_MAX_QUEUE 255
 
 enum {
 	TC_MQPRIO_HW_OFFLOAD_NONE,	/* no offload requested */
@@ -721,7 +721,7 @@ enum {
 
 struct tc_mqprio_qopt {
 	__u8	num_tc;
-	__u8	prio_tc_map[TC_QOPT_BITMASK + 1];
+	__u8	prio_tc_map[TC_QOPT_BITMASK];
 	__u8	hw;
 	__u16	count[TC_QOPT_MAX_QUEUE];
 	__u16	offset[TC_QOPT_MAX_QUEUE];
diff --git a/net/core/dev.c b/net/core/dev.c
index d9bf63dbe4fd..fe1b0bd812a5 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2476,7 +2476,7 @@ static void netif_setup_tc(struct net_device *dev, unsigned int txq)
 	}
 
 	/* Invalidated prio to tc mappings set to TC0 */
-	for (i = 1; i < TC_BITMASK + 1; i++) {
+	for (i = 1; i < TC_BITMASK; i++) {
 		int q = netdev_get_prio_tc_map(dev, i);
 
 		tc = &dev->tc_to_txq[q];
diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 8766ab5b8788..70b1267ac92c 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -42,15 +42,21 @@ static void mqprio_destroy(struct Qdisc *sch)
 	}
 
 	if (priv->hw_offload && dev->netdev_ops->ndo_setup_tc) {
-		struct tc_mqprio_qopt_offload mqprio = { { 0 } };
-
 		switch (priv->mode) {
 		case TC_MQPRIO_MODE_DCB:
 		case TC_MQPRIO_MODE_CHANNEL:
+		{
+			struct tc_mqprio_qopt_offload *mqprio;
+
+			mqprio = kzalloc(sizeof(*mqprio), GFP_KERNEL);
+			if (!mqprio)
+				return;
 			dev->netdev_ops->ndo_setup_tc(dev,
 						      TC_SETUP_QDISC_MQPRIO,
-						      &mqprio);
+						      mqprio);
+			kfree(mqprio);
 			break;
+		}
 		default:
 			return;
 		}
@@ -68,7 +74,7 @@ static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt)
 		return -EINVAL;
 
 	/* Verify priority mapping uses valid tcs */
-	for (i = 0; i < TC_BITMASK + 1; i++) {
+	for (i = 0; i < TC_BITMASK; i++) {
 		if (qopt->prio_tc_map[i] >= qopt->num_tc)
 			return -EINVAL;
 	}
@@ -241,36 +247,48 @@ static int mqprio_init(struct Qdisc *sch, struct nlattr *opt,
 	 * supplied and verified mapping
 	 */
 	if (qopt->hw) {
-		struct tc_mqprio_qopt_offload mqprio = {.qopt = *qopt};
+		struct tc_mqprio_qopt_offload *mqprio;
+
+		mqprio = kzalloc(sizeof(*mqprio), GFP_KERNEL);
+		if (!mqprio)
+			return -ENOMEM;
+
+		mqprio->qopt = *qopt;
 
 		switch (priv->mode) {
 		case TC_MQPRIO_MODE_DCB:
-			if (priv->shaper != TC_MQPRIO_SHAPER_DCB)
+			if (priv->shaper != TC_MQPRIO_SHAPER_DCB) {
+				kfree(mqprio);
 				return -EINVAL;
+			}
 			break;
 		case TC_MQPRIO_MODE_CHANNEL:
-			mqprio.flags = priv->flags;
+			mqprio->flags = priv->flags;
 			if (priv->flags & TC_MQPRIO_F_MODE)
-				mqprio.mode = priv->mode;
+				mqprio->mode = priv->mode;
 			if (priv->flags & TC_MQPRIO_F_SHAPER)
-				mqprio.shaper = priv->shaper;
+				mqprio->shaper = priv->shaper;
 			if (priv->flags & TC_MQPRIO_F_MIN_RATE)
-				for (i = 0; i < mqprio.qopt.num_tc; i++)
-					mqprio.min_rate[i] = priv->min_rate[i];
+				for (i = 0; i < mqprio->qopt.num_tc; i++)
+					mqprio->min_rate[i] = priv->min_rate[i];
 			if (priv->flags & TC_MQPRIO_F_MAX_RATE)
-				for (i = 0; i < mqprio.qopt.num_tc; i++)
-					mqprio.max_rate[i] = priv->max_rate[i];
+				for (i = 0; i < mqprio->qopt.num_tc; i++)
+					mqprio->max_rate[i] = priv->max_rate[i];
 			break;
 		default:
+			kfree(mqprio);
 			return -EINVAL;
 		}
 		err = dev->netdev_ops->ndo_setup_tc(dev,
 						    TC_SETUP_QDISC_MQPRIO,
-						    &mqprio);
-		if (err)
+						    mqprio);
+		if (err) {
+			kfree(mqprio);
 			return err;
+		}
 
-		priv->hw_offload = mqprio.qopt.hw;
+		priv->hw_offload = mqprio->qopt.hw;
+		kfree(mqprio);
 	} else {
 		netdev_set_num_tc(dev, qopt->num_tc);
 		for (i = 0; i < qopt->num_tc; i++)
@@ -279,7 +297,7 @@ static int mqprio_init(struct Qdisc *sch, struct nlattr *opt,
 	}
 
 	/* Always use supplied priority mappings */
-	for (i = 0; i < TC_BITMASK + 1; i++)
+	for (i = 0; i < TC_BITMASK; i++)
 		netdev_set_prio_tc_map(dev, i, qopt->prio_tc_map[i]);
 
 	sch->flags |= TCQ_F_MQROOT;
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 922ed6b91abb..3878c77ce91d 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -982,7 +982,7 @@ static int taprio_parse_mqprio_opt(struct net_device *dev,
 	}
 
 	/* Verify priority mapping uses valid tcs */
-	for (i = 0; i <= TC_BITMASK; i++) {
+	for (i = 0; i < TC_BITMASK; i++) {
 		if (qopt->prio_tc_map[i] >= qopt->num_tc) {
 			NL_SET_ERR_MSG(extack, "Invalid traffic class in priority to traffic class mapping");
 			return -EINVAL;
@@ -1437,7 +1437,7 @@ static int taprio_mqprio_cmp(const struct net_device *dev,
 		    dev->tc_to_txq[i].offset != mqprio->offset[i])
 			return -1;
 
-	for (i = 0; i <= TC_BITMASK; i++)
+	for (i = 0; i < TC_BITMASK; i++)
 		if (dev->prio_tc_map[i] != mqprio->prio_tc_map[i])
 			return -1;
 
@@ -1548,7 +1548,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 					    mqprio->offset[i]);
 
 		/* Always use supplied priority mappings */
-		for (i = 0; i <= TC_BITMASK; i++)
+		for (i = 0; i < TC_BITMASK; i++)
 			netdev_set_prio_tc_map(dev, i,
 					       mqprio->prio_tc_map[i]);
 	}


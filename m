Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 760203B4B8C
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 02:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbhFZAgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 20:36:11 -0400
Received: from mga18.intel.com ([134.134.136.126]:48448 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229922AbhFZAgE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 20:36:04 -0400
IronPort-SDR: 1MnxyWSRRuv1IZZwo5ZDwgj68YdsTFKxhaRFSGtAdhMRUPNjK6kv7V24Sk4CFAlEHlYmGSyaPl
 g9/C/ue+A2HA==
X-IronPort-AV: E=McAfee;i="6200,9189,10026"; a="195054021"
X-IronPort-AV: E=Sophos;i="5.83,300,1616482800"; 
   d="scan'208";a="195054021"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 17:33:42 -0700
IronPort-SDR: /jLsiXYjJFYWokIPQC2hSdJBrS5ZQtMbuxp+QimkmN+gl2nRqIZwfpWE+L/1y8ilaWAh83Xzdy
 EsxGbWA8iMyA==
X-IronPort-AV: E=Sophos;i="5.83,300,1616482800"; 
   d="scan'208";a="557008609"
Received: from aschmalt-mobl1.amr.corp.intel.com (HELO localhost.localdomain) ([10.212.160.59])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2021 17:33:42 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuba@kernel.org,
        vladimir.oltean@nxp.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        mkubecek@suse.cz
Subject: [PATCH net-next v4 05/12] mqprio: Add support for frame preemption offload
Date:   Fri, 25 Jun 2021 17:33:07 -0700
Message-Id: <20210626003314.3159402-6-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210626003314.3159402-1-vinicius.gomes@intel.com>
References: <20210626003314.3159402-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds a way to configure which traffic classes are marked as
preemptible and which are marked as express.

Even if frame preemption is not a "real" offload, because it can't be
executed purely in software, having this information near where the
mapping of traffic classes to queues is specified, makes it,
hopefully, easier to use.

mqprio will receive the information of which traffic classes are
marked as express/preemptible, and when offloading frame preemption to
the driver will convert the information, so the driver receives which
queues are marked as express/preemptible.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 include/uapi/linux/pkt_sched.h |  1 +
 net/sched/sch_mqprio.c         | 41 ++++++++++++++++++++++++++++++++--
 2 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index 830ce9c9ec6f..06aa155e46f7 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -738,6 +738,7 @@ enum {
 	TCA_MQPRIO_SHAPER,
 	TCA_MQPRIO_MIN_RATE64,
 	TCA_MQPRIO_MAX_RATE64,
+	TCA_MQPRIO_PREEMPT_TCS,
 	__TCA_MQPRIO_MAX,
 };
 
diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 8766ab5b8788..86e6012f180a 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -23,6 +23,7 @@ struct mqprio_sched {
 	u16 shaper;
 	int hw_offload;
 	u32 flags;
+	u32 preemptible_tcs;
 	u64 min_rate[TC_QOPT_MAX_QUEUE];
 	u64 max_rate[TC_QOPT_MAX_QUEUE];
 };
@@ -33,6 +34,13 @@ static void mqprio_destroy(struct Qdisc *sch)
 	struct mqprio_sched *priv = qdisc_priv(sch);
 	unsigned int ntx;
 
+	if (priv->preemptible_tcs && dev->netdev_ops->ndo_setup_tc) {
+		struct tc_preempt_qopt_offload preempt = { };
+
+		dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_PREEMPT,
+						    &preempt);
+	}
+
 	if (priv->qdiscs) {
 		for (ntx = 0;
 		     ntx < dev->num_tx_queues && priv->qdiscs[ntx];
@@ -112,6 +120,7 @@ static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt)
 static const struct nla_policy mqprio_policy[TCA_MQPRIO_MAX + 1] = {
 	[TCA_MQPRIO_MODE]	= { .len = sizeof(u16) },
 	[TCA_MQPRIO_SHAPER]	= { .len = sizeof(u16) },
+	[TCA_MQPRIO_PREEMPT_TCS] = { .type = NLA_U32 },
 	[TCA_MQPRIO_MIN_RATE64]	= { .type = NLA_NESTED },
 	[TCA_MQPRIO_MAX_RATE64]	= { .type = NLA_NESTED },
 };
@@ -171,8 +180,17 @@ static int mqprio_init(struct Qdisc *sch, struct nlattr *opt,
 		if (err < 0)
 			return err;
 
-		if (!qopt->hw)
-			return -EINVAL;
+		if (tb[TCA_MQPRIO_PREEMPT_TCS]) {
+			u32 preempt = nla_get_u32(tb[TCA_MQPRIO_PREEMPT_TCS]);
+			u32 all_tcs_mask = GENMASK(qopt->num_tc, 0);
+
+			if ((preempt & all_tcs_mask) == all_tcs_mask) {
+				NL_SET_ERR_MSG(extack, "At least one traffic class must be not be preemptible");
+				return -EINVAL;
+			}
+
+			priv->preemptible_tcs = preempt;
+		}
 
 		if (tb[TCA_MQPRIO_MODE]) {
 			priv->flags |= TC_MQPRIO_F_MODE;
@@ -217,6 +235,9 @@ static int mqprio_init(struct Qdisc *sch, struct nlattr *opt,
 		}
 	}
 
+	if (!qopt->hw && priv->flags)
+		return -EINVAL;
+
 	/* pre-allocate qdisc, attachment can't fail */
 	priv->qdiscs = kcalloc(dev->num_tx_queues, sizeof(priv->qdiscs[0]),
 			       GFP_KERNEL);
@@ -282,6 +303,18 @@ static int mqprio_init(struct Qdisc *sch, struct nlattr *opt,
 	for (i = 0; i < TC_BITMASK + 1; i++)
 		netdev_set_prio_tc_map(dev, i, qopt->prio_tc_map[i]);
 
+	if (priv->preemptible_tcs) {
+		struct tc_preempt_qopt_offload preempt = { };
+
+		preempt.preemptible_queues =
+			netdev_tc_map_to_queue_mask(dev, priv->preemptible_tcs);
+
+		err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_PREEMPT,
+						    &preempt);
+		if (err)
+			return err;
+	}
+
 	sch->flags |= TCQ_F_MQROOT;
 	return 0;
 }
@@ -450,6 +483,10 @@ static int mqprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 	    (dump_rates(priv, &opt, skb) != 0))
 		goto nla_put_failure;
 
+	if (priv->preemptible_tcs &&
+	    nla_put_u32(skb, TCA_MQPRIO_PREEMPT_TCS, priv->preemptible_tcs))
+		goto nla_put_failure;
+
 	return nla_nest_end(skb, nla);
 nla_put_failure:
 	nlmsg_trim(skb, nla);
-- 
2.32.0


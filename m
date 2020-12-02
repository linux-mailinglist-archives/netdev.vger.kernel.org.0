Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77D572CB41F
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 05:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387490AbgLBEzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 23:55:18 -0500
Received: from mga04.intel.com ([192.55.52.120]:43301 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387474AbgLBEzR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 23:55:17 -0500
IronPort-SDR: svbAePoZHTac3XeWI+KHRwG+bRyP8mZzUgk9cuXkLTpZllLrnF/Md0rJbmlUfZ9i3qsWDP7CWI
 +OPSnVDlAI2g==
X-IronPort-AV: E=McAfee;i="6000,8403,9822"; a="170387533"
X-IronPort-AV: E=Sophos;i="5.78,385,1599548400"; 
   d="scan'208";a="170387533"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2020 20:53:48 -0800
IronPort-SDR: QEkx5IKF1j1R+3BDnUUL/jUyX8o95LQF8VDM9afyt12KFJPSFyEkSzORatRkF2P3XwvhlNywhO
 Ia4ZhhddrIng==
X-IronPort-AV: E=Sophos;i="5.78,385,1599548400"; 
   d="scan'208";a="549888366"
Received: from shivanif-mobl.amr.corp.intel.com (HELO localhost.localdomain) ([10.212.152.222])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2020 20:53:47 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuba@kernel.org,
        m-karicheri2@ti.com, vladimir.oltean@nxp.com,
        Jose.Abreu@synopsys.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com
Subject: [PATCH net-next v1 2/9] taprio: Add support for frame preemption offload
Date:   Tue,  1 Dec 2020 20:53:18 -0800
Message-Id: <20201202045325.3254757-3-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201202045325.3254757-1-vinicius.gomes@intel.com>
References: <20201202045325.3254757-1-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a way to configure which queues are marked as preemptible
and which are marked as express.

Even if this is not a "real" offload, because it can't be executed
purely in software, having this information near where the mapping of
queues is specified, makes it, hopefully, easier to understand.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 include/linux/netdevice.h      |  1 +
 include/net/pkt_sched.h        |  4 ++++
 include/uapi/linux/pkt_sched.h |  1 +
 net/sched/sch_taprio.c         | 41 ++++++++++++++++++++++++++++++----
 4 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 8eeb73ac58bd..d7a99e769e79 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -852,6 +852,7 @@ enum tc_setup_type {
 	TC_SETUP_QDISC_ETS,
 	TC_SETUP_QDISC_TBF,
 	TC_SETUP_QDISC_FIFO,
+	TC_SETUP_PREEMPT,
 };
 
 /* These structures hold the attributes of bpf state that are being passed
diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 15b1b30f454e..be5ff1535332 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -183,6 +183,10 @@ struct tc_taprio_qopt_offload {
 	struct tc_taprio_sched_entry entries[];
 };
 
+struct tc_preempt_qopt_offload {
+	u32 preemptible_queues;
+};
+
 /* Reference counting */
 struct tc_taprio_qopt_offload *taprio_offload_get(struct tc_taprio_qopt_offload
 						  *offload);
diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index 9e7c2c607845..f0240ddaeee3 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -1240,6 +1240,7 @@ enum {
 	TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION, /* s64 */
 	TCA_TAPRIO_ATTR_FLAGS, /* u32 */
 	TCA_TAPRIO_ATTR_TXTIME_DELAY, /* u32 */
+	TCA_TAPRIO_ATTR_PREEMPT_QUEUES, /* u32 */
 	__TCA_TAPRIO_ATTR_MAX,
 };
 
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 26fb8a62996b..c482c5d211bb 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -64,6 +64,7 @@ struct taprio_sched {
 	struct Qdisc **qdiscs;
 	struct Qdisc *root;
 	u32 flags;
+	u32 preemptible_queues;
 	enum tk_offsets tk_offset;
 	int clockid;
 	atomic64_t picos_per_byte; /* Using picoseconds because for 10Gbps+
@@ -776,6 +777,7 @@ static const struct nla_policy taprio_policy[TCA_TAPRIO_ATTR_MAX + 1] = {
 	[TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION] = { .type = NLA_S64 },
 	[TCA_TAPRIO_ATTR_FLAGS]                      = { .type = NLA_U32 },
 	[TCA_TAPRIO_ATTR_TXTIME_DELAY]		     = { .type = NLA_U32 },
+	[TCA_TAPRIO_ATTR_PREEMPT_QUEUES]	     = { .type = NLA_U32 },
 };
 
 static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
@@ -1268,6 +1270,7 @@ static int taprio_disable_offload(struct net_device *dev,
 				  struct netlink_ext_ack *extack)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
+	struct tc_preempt_qopt_offload preempt = { };
 	struct tc_taprio_qopt_offload *offload;
 	int err;
 
@@ -1286,13 +1289,15 @@ static int taprio_disable_offload(struct net_device *dev,
 	offload->enable = 0;
 
 	err = ops->ndo_setup_tc(dev, TC_SETUP_QDISC_TAPRIO, offload);
-	if (err < 0) {
+	if (err < 0)
+		NL_SET_ERR_MSG(extack,
+			       "Device failed to disable offload");
+
+	err = ops->ndo_setup_tc(dev, TC_SETUP_PREEMPT, &preempt);
+	if (err < 0)
 		NL_SET_ERR_MSG(extack,
 			       "Device failed to disable offload");
-		goto out;
-	}
 
-out:
 	taprio_offload_free(offload);
 
 	return err;
@@ -1509,6 +1514,29 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 					       mqprio->prio_tc_map[i]);
 	}
 
+	/* It's valid to enable frame preemption without any kind of
+	 * offloading being enabled, so keep it separated.
+	 */
+	if (tb[TCA_TAPRIO_ATTR_PREEMPT_QUEUES]) {
+		u32 preempt = nla_get_u32(tb[TCA_TAPRIO_ATTR_PREEMPT_QUEUES]);
+		struct tc_preempt_qopt_offload qopt = { };
+
+		if (preempt == U32_MAX) {
+			NL_SET_ERR_MSG(extack, "At least one queue must be not be preemptible");
+			err = -EINVAL;
+			goto free_sched;
+		}
+
+		qopt.preemptible_queues = preempt;
+
+		err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_PREEMPT,
+						    &qopt);
+		if (err)
+			goto free_sched;
+
+		q->preemptible_queues = preempt;
+	}
+
 	if (FULL_OFFLOAD_IS_ENABLED(q->flags))
 		err = taprio_enable_offload(dev, q, new_admin, extack);
 	else
@@ -1650,6 +1678,7 @@ static int taprio_init(struct Qdisc *sch, struct nlattr *opt,
 	 */
 	q->clockid = -1;
 	q->flags = TAPRIO_FLAGS_INVALID;
+	q->preemptible_queues = U32_MAX;
 
 	spin_lock(&taprio_list_lock);
 	list_add(&q->taprio_list, &taprio_list);
@@ -1833,6 +1862,10 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
 	if (q->flags && nla_put_u32(skb, TCA_TAPRIO_ATTR_FLAGS, q->flags))
 		goto options_error;
 
+	if (q->preemptible_queues != U32_MAX &&
+	    nla_put_u32(skb, TCA_TAPRIO_ATTR_PREEMPT_QUEUES, q->preemptible_queues))
+		goto options_error;
+
 	if (q->txtime_delay &&
 	    nla_put_u32(skb, TCA_TAPRIO_ATTR_TXTIME_DELAY, q->txtime_delay))
 		goto options_error;
-- 
2.29.2


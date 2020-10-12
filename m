Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A623B28C57C
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 01:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731149AbgJLX5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 19:57:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:19410 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731096AbgJLX47 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 19:56:59 -0400
IronPort-SDR: wE/Fy3KtcOgGlCShgoEQK/3YbxJu4tqjVVmvnSIGMd4yCkyuTUVgkJWUC7TboLExriID9Jlr3L
 vWXbCcfCCjqQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="152751184"
X-IronPort-AV: E=Sophos;i="5.77,368,1596524400"; 
   d="scan'208";a="152751184"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 16:56:59 -0700
IronPort-SDR: tulMRn3RX9K0+fxdXtUUjIig9buGWyywPYmBJ2pGz0xqwyV0M6/dLEXvdBkxboMS5gHW9hcjnj
 /1/DHEu9aqcg==
X-IronPort-AV: E=Sophos;i="5.77,368,1596524400"; 
   d="scan'208";a="520847738"
Received: from aravindh-mobl.amr.corp.intel.com (HELO localhost.localdomain) ([10.209.37.143])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 16:56:58 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuba@kernel.org,
        m-karicheri2@ti.com, vladimir.oltean@nxp.com,
        Jose.Abreu@synopsys.com, po.liu@nxp.com
Subject: [RFC net-next v2 2/2] taprio: Add support for frame preemption offload
Date:   Mon, 12 Oct 2020 16:56:42 -0700
Message-Id: <20201012235642.1384318-3-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012235642.1384318-1-vinicius.gomes@intel.com>
References: <20201012235642.1384318-1-vinicius.gomes@intel.com>
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
index a0df43b13839..99589945bb10 100644
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
index 4ed32e6b0201..71b50b644cfa 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -178,6 +178,10 @@ struct tc_taprio_qopt_offload {
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
index b0ad7687ee2c..f9aa3f26aad9 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -63,6 +63,7 @@ struct taprio_sched {
 	struct Qdisc **qdiscs;
 	struct Qdisc *root;
 	u32 flags;
+	u32 preemptible_queues;
 	enum tk_offsets tk_offset;
 	int clockid;
 	atomic64_t picos_per_byte; /* Using picoseconds because for 10Gbps+
@@ -775,6 +776,7 @@ static const struct nla_policy taprio_policy[TCA_TAPRIO_ATTR_MAX + 1] = {
 	[TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION] = { .type = NLA_S64 },
 	[TCA_TAPRIO_ATTR_FLAGS]                      = { .type = NLA_U32 },
 	[TCA_TAPRIO_ATTR_TXTIME_DELAY]		     = { .type = NLA_U32 },
+	[TCA_TAPRIO_ATTR_PREEMPT_QUEUES]	     = { .type = NLA_U32 },
 };
 
 static int fill_sched_entry(struct taprio_sched *q, struct nlattr **tb,
@@ -1267,6 +1269,7 @@ static int taprio_disable_offload(struct net_device *dev,
 				  struct netlink_ext_ack *extack)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
+	struct tc_preempt_qopt_offload preempt = { };
 	struct tc_taprio_qopt_offload *offload;
 	int err;
 
@@ -1285,13 +1288,15 @@ static int taprio_disable_offload(struct net_device *dev,
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
@@ -1508,6 +1513,29 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
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
@@ -1649,6 +1677,7 @@ static int taprio_init(struct Qdisc *sch, struct nlattr *opt,
 	 */
 	q->clockid = -1;
 	q->flags = TAPRIO_FLAGS_INVALID;
+	q->preemptible_queues = U32_MAX;
 
 	spin_lock(&taprio_list_lock);
 	list_add(&q->taprio_list, &taprio_list);
@@ -1832,6 +1861,10 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
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
2.28.0


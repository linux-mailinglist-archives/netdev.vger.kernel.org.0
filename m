Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFB43402A6
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 11:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbhCRKCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 06:02:48 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:36216 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229897AbhCRKCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 06:02:42 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12IA0YT4020129;
        Thu, 18 Mar 2021 03:02:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=hwvRrTchYh4uDbRCwBaGOHyUxF8e7WGf/7mt5F33Rik=;
 b=igu5o4ppd/09nRLcMvJRf1OGnwdRR/+RzLAKBsPng0loKab4f28qT0NPUz5NMFUwXeO6
 Svti8F0+140pdfJiQZ/qfOsZ/R+EhRnXexTJowVcfVG9J9aumV5A04lPmRIti/u6TsGU
 xELP/9b51fGJKI2fhFLuIqHFUXqqj3V9k8UiWjveTiG4GDCBBg1QgioBcpofAhHA27jS
 9i760rug8cye/0YyWZr5GP89UxEGPtihHCI6QlBBmWHsiFwz+dYbuRREGVQra4iCD1yI
 s0Gkrzf+UEx1+jZCO5iEYAKZmdzsbc8Mn6w2tSfwBQm5qizEf7LpygL9ccM4QFvwq4Vm hA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 378wsqyxwk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 18 Mar 2021 03:02:40 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 18 Mar
 2021 03:02:38 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 18 Mar 2021 03:02:38 -0700
Received: from #hyd1583.marvell.com (unknown [10.29.37.44])
        by maili.marvell.com (Postfix) with ESMTP id B70293F7040;
        Thu, 18 Mar 2021 03:02:34 -0700 (PDT)
From:   Naveen Mamindlapalli <naveenm@marvell.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <sgoutham@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>, <jerinj@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, "Naveen Mamindlapalli" <naveenm@marvell.com>
Subject: [PATCH net-next 4/4] octeontx2-pf: TC_MATCHALL egress ratelimiting offload
Date:   Thu, 18 Mar 2021 15:32:15 +0530
Message-ID: <20210318100215.15795-5-naveenm@marvell.com>
X-Mailer: git-send-email 2.16.5
In-Reply-To: <20210318100215.15795-1-naveenm@marvell.com>
References: <20210318100215.15795-1-naveenm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-18_04:2021-03-17,2021-03-18 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

Add TC_MATCHALL egress ratelimiting offload support with POLICE
action for entire traffic going out of the interface.

Eg: To ratelimit egress traffic to 100Mbps

$ ethtool -K eth0 hw-tc-offload on
$ tc qdisc add dev eth0 clsact
$ tc filter add dev eth0 egress matchall skip_sw \
                action police rate 100Mbit burst 16Kbit

HW supports a max burst size of ~128KB.
Only one ratelimiting filter can be installed at a time.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   1 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_reg.h  |   1 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_tc.c   | 238 ++++++++++++++++++++-
 3 files changed, 236 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 992aa93178e1..45730d0d92f2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -318,6 +318,7 @@ struct otx2_nic {
 #define OTX2_FLAG_RX_PAUSE_ENABLED		BIT_ULL(9)
 #define OTX2_FLAG_TX_PAUSE_ENABLED		BIT_ULL(10)
 #define OTX2_FLAG_TC_FLOWER_SUPPORT		BIT_ULL(11)
+#define OTX2_FLAG_TC_MATCHALL_EGRESS_ENABLED	BIT_ULL(12)
 	u64			flags;
 
 	struct otx2_qset	qset;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
index 21b811c6ee0f..f4fd72ee9a25 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
@@ -152,6 +152,7 @@
 #define NIX_AF_TL3X_SCHEDULE(a)		(0x1000 | (a) << 16)
 #define NIX_AF_TL4X_PARENT(a)		(0x1288 | (a) << 16)
 #define NIX_AF_TL4X_SCHEDULE(a)		(0x1200 | (a) << 16)
+#define NIX_AF_TL4X_PIR(a)		(0x1230 | (a) << 16)
 #define NIX_AF_MDQX_SCHEDULE(a)		(0x1400 | (a) << 16)
 #define NIX_AF_MDQX_PARENT(a)		(0x1480 | (a) << 16)
 #define NIX_AF_TL3_TL2X_LINKX_CFG(a, b)	(0x1700 | (a) << 16 | (b) << 3)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
index 43ef6303ed84..2f75cfc5a23a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
@@ -7,6 +7,7 @@
 #include <linux/etherdevice.h>
 #include <linux/inetdevice.h>
 #include <linux/rhashtable.h>
+#include <linux/bitfield.h>
 #include <net/flow_dissector.h>
 #include <net/pkt_cls.h>
 #include <net/tc_act/tc_gact.h>
@@ -16,6 +17,21 @@
 
 #include "otx2_common.h"
 
+/* Egress rate limiting definitions */
+#define MAX_BURST_EXPONENT		0x0FULL
+#define MAX_BURST_MANTISSA		0xFFULL
+#define MAX_BURST_SIZE			130816ULL
+#define MAX_RATE_DIVIDER_EXPONENT	12ULL
+#define MAX_RATE_EXPONENT		0x0FULL
+#define MAX_RATE_MANTISSA		0xFFULL
+
+/* Bitfields in NIX_TLX_PIR register */
+#define TLX_RATE_MANTISSA		GENMASK_ULL(8, 1)
+#define TLX_RATE_EXPONENT		GENMASK_ULL(12, 9)
+#define TLX_RATE_DIVIDER_EXPONENT	GENMASK_ULL(16, 13)
+#define TLX_BURST_MANTISSA		GENMASK_ULL(36, 29)
+#define TLX_BURST_EXPONENT		GENMASK_ULL(40, 37)
+
 struct otx2_tc_flow_stats {
 	u64 bytes;
 	u64 pkts;
@@ -32,6 +48,178 @@ struct otx2_tc_flow {
 	spinlock_t			lock; /* lock for stats */
 };
 
+static void otx2_get_egress_burst_cfg(u32 burst, u32 *burst_exp,
+				      u32 *burst_mantissa)
+{
+	unsigned int tmp;
+
+	/* Burst is calculated as
+	 * ((256 + BURST_MANTISSA) << (1 + BURST_EXPONENT)) / 256
+	 * Max supported burst size is 130,816 bytes.
+	 */
+	burst = min_t(u32, burst, MAX_BURST_SIZE);
+	if (burst) {
+		*burst_exp = ilog2(burst) ? ilog2(burst) - 1 : 0;
+		tmp = burst - rounddown_pow_of_two(burst);
+		if (burst < MAX_BURST_MANTISSA)
+			*burst_mantissa = tmp * 2;
+		else
+			*burst_mantissa = tmp / (1ULL << (*burst_exp - 7));
+	} else {
+		*burst_exp = MAX_BURST_EXPONENT;
+		*burst_mantissa = MAX_BURST_MANTISSA;
+	}
+}
+
+static void otx2_get_egress_rate_cfg(u32 maxrate, u32 *exp,
+				     u32 *mantissa, u32 *div_exp)
+{
+	unsigned int tmp;
+
+	/* Rate calculation by hardware
+	 *
+	 * PIR_ADD = ((256 + mantissa) << exp) / 256
+	 * rate = (2 * PIR_ADD) / ( 1 << div_exp)
+	 * The resultant rate is in Mbps.
+	 */
+
+	/* 2Mbps to 100Gbps can be expressed with div_exp = 0.
+	 * Setting this to '0' will ease the calculation of
+	 * exponent and mantissa.
+	 */
+	*div_exp = 0;
+
+	if (maxrate) {
+		*exp = ilog2(maxrate) ? ilog2(maxrate) - 1 : 0;
+		tmp = maxrate - rounddown_pow_of_two(maxrate);
+		if (maxrate < MAX_RATE_MANTISSA)
+			*mantissa = tmp * 2;
+		else
+			*mantissa = tmp / (1ULL << (*exp - 7));
+	} else {
+		/* Instead of disabling rate limiting, set all values to max */
+		*exp = MAX_RATE_EXPONENT;
+		*mantissa = MAX_RATE_MANTISSA;
+	}
+}
+
+static int otx2_set_matchall_egress_rate(struct otx2_nic *nic, u32 burst, u32 maxrate)
+{
+	struct otx2_hw *hw = &nic->hw;
+	struct nix_txschq_config *req;
+	u32 burst_exp, burst_mantissa;
+	u32 exp, mantissa, div_exp;
+	int txschq, err;
+
+	/* All SQs share the same TL4, so pick the first scheduler */
+	txschq = hw->txschq_list[NIX_TXSCH_LVL_TL4][0];
+
+	/* Get exponent and mantissa values from the desired rate */
+	otx2_get_egress_burst_cfg(burst, &burst_exp, &burst_mantissa);
+	otx2_get_egress_rate_cfg(maxrate, &exp, &mantissa, &div_exp);
+
+	mutex_lock(&nic->mbox.lock);
+	req = otx2_mbox_alloc_msg_nix_txschq_cfg(&nic->mbox);
+	if (!req) {
+		mutex_unlock(&nic->mbox.lock);
+		return -ENOMEM;
+	}
+
+	req->lvl = NIX_TXSCH_LVL_TL4;
+	req->num_regs = 1;
+	req->reg[0] = NIX_AF_TL4X_PIR(txschq);
+	req->regval[0] = FIELD_PREP(TLX_BURST_EXPONENT, burst_exp) |
+			 FIELD_PREP(TLX_BURST_MANTISSA, burst_mantissa) |
+			 FIELD_PREP(TLX_RATE_DIVIDER_EXPONENT, div_exp) |
+			 FIELD_PREP(TLX_RATE_EXPONENT, exp) |
+			 FIELD_PREP(TLX_RATE_MANTISSA, mantissa) | BIT_ULL(0);
+
+	err = otx2_sync_mbox_msg(&nic->mbox);
+	mutex_unlock(&nic->mbox.lock);
+	return err;
+}
+
+static int otx2_tc_validate_flow(struct otx2_nic *nic,
+				 struct flow_action *actions,
+				 struct netlink_ext_ack *extack)
+{
+	if (nic->flags & OTX2_FLAG_INTF_DOWN) {
+		NL_SET_ERR_MSG_MOD(extack, "Interface not initialized");
+		return -EINVAL;
+	}
+
+	if (!flow_action_has_entries(actions)) {
+		NL_SET_ERR_MSG_MOD(extack, "MATCHALL offload called with no action");
+		return -EINVAL;
+	}
+
+	if (!flow_offload_has_one_action(actions)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Egress MATCHALL offload supports only 1 policing action");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int otx2_tc_egress_matchall_install(struct otx2_nic *nic,
+					   struct tc_cls_matchall_offload *cls)
+{
+	struct netlink_ext_ack *extack = cls->common.extack;
+	struct flow_action *actions = &cls->rule->action;
+	struct flow_action_entry *entry;
+	u32 rate;
+	int err;
+
+	err = otx2_tc_validate_flow(nic, actions, extack);
+	if (err)
+		return err;
+
+	if (nic->flags & OTX2_FLAG_TC_MATCHALL_EGRESS_ENABLED) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Only one Egress MATCHALL ratelimitter can be offloaded");
+		return -ENOMEM;
+	}
+
+	entry = &cls->rule->action.entries[0];
+	switch (entry->id) {
+	case FLOW_ACTION_POLICE:
+		if (entry->police.rate_pkt_ps) {
+			NL_SET_ERR_MSG_MOD(extack, "QoS offload not support packets per second");
+			return -EOPNOTSUPP;
+		}
+		/* Convert bytes per second to Mbps */
+		rate = entry->police.rate_bytes_ps * 8;
+		rate = max_t(u32, rate / 1000000, 1);
+		err = otx2_set_matchall_egress_rate(nic, entry->police.burst, rate);
+		if (err)
+			return err;
+		nic->flags |= OTX2_FLAG_TC_MATCHALL_EGRESS_ENABLED;
+		break;
+	default:
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Only police action is supported with Egress MATCHALL offload");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int otx2_tc_egress_matchall_delete(struct otx2_nic *nic,
+					  struct tc_cls_matchall_offload *cls)
+{
+	struct netlink_ext_ack *extack = cls->common.extack;
+	int err;
+
+	if (nic->flags & OTX2_FLAG_INTF_DOWN) {
+		NL_SET_ERR_MSG_MOD(extack, "Interface not initialized");
+		return -EINVAL;
+	}
+
+	err = otx2_set_matchall_egress_rate(nic, 0, 0);
+	nic->flags &= ~OTX2_FLAG_TC_MATCHALL_EGRESS_ENABLED;
+	return err;
+}
+
 static int otx2_tc_parse_actions(struct otx2_nic *nic,
 				 struct flow_action *flow_action,
 				 struct npc_install_flow_req *req)
@@ -504,22 +692,64 @@ static int otx2_setup_tc_block_ingress_cb(enum tc_setup_type type,
 	return -EOPNOTSUPP;
 }
 
+static int otx2_setup_tc_egress_matchall(struct otx2_nic *nic,
+					 struct tc_cls_matchall_offload *cls_matchall)
+{
+	switch (cls_matchall->command) {
+	case TC_CLSMATCHALL_REPLACE:
+		return otx2_tc_egress_matchall_install(nic, cls_matchall);
+	case TC_CLSMATCHALL_DESTROY:
+		return otx2_tc_egress_matchall_delete(nic, cls_matchall);
+	case TC_CLSMATCHALL_STATS:
+	default:
+		break;
+	}
+
+	return -EOPNOTSUPP;
+}
+
+static int otx2_setup_tc_block_egress_cb(enum tc_setup_type type,
+					 void *type_data, void *cb_priv)
+{
+	struct otx2_nic *nic = cb_priv;
+
+	if (!tc_cls_can_offload_and_chain0(nic->netdev, type_data))
+		return -EOPNOTSUPP;
+
+	switch (type) {
+	case TC_SETUP_CLSMATCHALL:
+		return otx2_setup_tc_egress_matchall(nic, type_data);
+	default:
+		break;
+	}
+
+	return -EOPNOTSUPP;
+}
+
 static LIST_HEAD(otx2_block_cb_list);
 
 static int otx2_setup_tc_block(struct net_device *netdev,
 			       struct flow_block_offload *f)
 {
 	struct otx2_nic *nic = netdev_priv(netdev);
+	flow_setup_cb_t *cb;
+	bool ingress;
 
 	if (f->block_shared)
 		return -EOPNOTSUPP;
 
-	if (f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
+	if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS) {
+		cb = otx2_setup_tc_block_ingress_cb;
+		ingress = true;
+	} else if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS) {
+		cb = otx2_setup_tc_block_egress_cb;
+		ingress = false;
+	} else {
 		return -EOPNOTSUPP;
+	}
 
-	return flow_block_cb_setup_simple(f, &otx2_block_cb_list,
-					  otx2_setup_tc_block_ingress_cb,
-					  nic, nic, true);
+	return flow_block_cb_setup_simple(f, &otx2_block_cb_list, cb,
+					  nic, nic, ingress);
 }
 
 int otx2_setup_tc(struct net_device *netdev, enum tc_setup_type type,
-- 
2.16.5


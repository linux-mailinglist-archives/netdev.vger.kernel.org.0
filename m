Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2A9455881
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 11:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245441AbhKRKEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 05:04:25 -0500
Received: from inva021.nxp.com ([92.121.34.21]:59668 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245432AbhKRKC4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 05:02:56 -0500
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id B15962033C4;
        Thu, 18 Nov 2021 10:59:55 +0100 (CET)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 4B4A0200938;
        Thu, 18 Nov 2021 10:59:55 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id E7E4A183AD05;
        Thu, 18 Nov 2021 17:59:52 +0800 (+08)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     allan.nielsen@microchip.com, joergen.andreasen@microchip.com,
        UNGLinuxDriver@microchip.com, vinicius.gomes@intel.com,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, po.liu@nxp.com, leoyang.li@nxp.com,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, matthias.bgg@gmail.com,
        horatiu.vultur@microchip.com, vladimir.oltean@nxp.com,
        kuba@kernel.org, mingkai.hu@nxp.com
Subject: [PATCH v7 net-next 3/8] net: mscc: ocelot: add gate and police action offload to PSFP
Date:   Thu, 18 Nov 2021 18:11:59 +0800
Message-Id: <20211118101204.4338-4-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211118101204.4338-1-xiaoliang.yang_1@nxp.com>
References: <20211118101204.4338-1-xiaoliang.yang_1@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PSFP support gate and police action. This patch add the gate and police
action to flower parse action, check chain ID to determine which block
to offload. Adding psfp callback functions to add, delete and update gate
and police in PSFP table if hardware supports it.

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c        |  3 ++
 drivers/net/ethernet/mscc/ocelot_flower.c | 52 ++++++++++++++++++++++-
 include/soc/mscc/ocelot.h                 |  5 +++
 include/soc/mscc/ocelot_vcap.h            |  1 +
 4 files changed, 59 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 9e981913d6ba..95920668feb0 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2352,6 +2352,9 @@ int ocelot_init(struct ocelot *ocelot)
 	ocelot_vcap_init(ocelot);
 	ocelot_cpu_port_init(ocelot);
 
+	if (ocelot->ops->psfp_init)
+		ocelot->ops->psfp_init(ocelot);
+
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
 		/* Clear all counters (5 groups) */
 		ocelot_write(ocelot, SYS_STAT_CFG_STAT_VIEW(port) |
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index ed609bc4398e..b22966e15acf 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -280,10 +280,14 @@ static int ocelot_flower_parse_action(struct ocelot *ocelot, int port,
 			filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
 			break;
 		case FLOW_ACTION_POLICE:
+			if (filter->block_id == PSFP_BLOCK_ID) {
+				filter->type = OCELOT_PSFP_FILTER_OFFLOAD;
+				break;
+			}
 			if (filter->block_id != VCAP_IS2 ||
 			    filter->lookup != 0) {
 				NL_SET_ERR_MSG_MOD(extack,
-						   "Police action can only be offloaded to VCAP IS2 lookup 0");
+						   "Police action can only be offloaded to VCAP IS2 lookup 0 or PSFP");
 				return -EOPNOTSUPP;
 			}
 			if (filter->goto_target != -1) {
@@ -410,6 +414,14 @@ static int ocelot_flower_parse_action(struct ocelot *ocelot, int port,
 			filter->action.pcp_a_val = a->vlan.prio;
 			filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
 			break;
+		case FLOW_ACTION_GATE:
+			if (filter->block_id != PSFP_BLOCK_ID) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "Gate action can only be offloaded to PSFP chain");
+				return -EOPNOTSUPP;
+			}
+			filter->type = OCELOT_PSFP_FILTER_OFFLOAD;
+			break;
 		default:
 			NL_SET_ERR_MSG_MOD(extack, "Cannot offload action");
 			return -EOPNOTSUPP;
@@ -700,6 +712,10 @@ static int ocelot_flower_parse(struct ocelot *ocelot, int port, bool ingress,
 	if (ret)
 		return ret;
 
+	/* PSFP filter need to parse key by stream identification function. */
+	if (filter->type == OCELOT_PSFP_FILTER_OFFLOAD)
+		return 0;
+
 	return ocelot_flower_parse_key(ocelot, port, ingress, f, filter);
 }
 
@@ -803,6 +819,15 @@ int ocelot_cls_flower_replace(struct ocelot *ocelot, int port,
 	if (filter->type == OCELOT_VCAP_FILTER_DUMMY)
 		return ocelot_vcap_dummy_filter_add(ocelot, filter);
 
+	if (filter->type == OCELOT_PSFP_FILTER_OFFLOAD) {
+		kfree(filter);
+		if (ocelot->ops->psfp_filter_add)
+			return ocelot->ops->psfp_filter_add(ocelot, f);
+
+		NL_SET_ERR_MSG_MOD(extack, "PSFP chain is not supported in HW");
+		return -EOPNOTSUPP;
+	}
+
 	return ocelot_vcap_filter_add(ocelot, filter, f->common.extack);
 }
 EXPORT_SYMBOL_GPL(ocelot_cls_flower_replace);
@@ -818,6 +843,13 @@ int ocelot_cls_flower_destroy(struct ocelot *ocelot, int port,
 	if (block_id < 0)
 		return 0;
 
+	if (block_id == PSFP_BLOCK_ID) {
+		if (ocelot->ops->psfp_filter_del)
+			return ocelot->ops->psfp_filter_del(ocelot, f);
+
+		return -EOPNOTSUPP;
+	}
+
 	block = &ocelot->block[block_id];
 
 	filter = ocelot_vcap_block_find_filter_by_id(block, f->cookie, true);
@@ -836,12 +868,25 @@ int ocelot_cls_flower_stats(struct ocelot *ocelot, int port,
 {
 	struct ocelot_vcap_filter *filter;
 	struct ocelot_vcap_block *block;
+	struct flow_stats stats = {0};
 	int block_id, ret;
 
 	block_id = ocelot_chain_to_block(f->common.chain_index, ingress);
 	if (block_id < 0)
 		return 0;
 
+	if (block_id == PSFP_BLOCK_ID) {
+		if (ocelot->ops->psfp_stats_get) {
+			ret = ocelot->ops->psfp_stats_get(ocelot, f, &stats);
+			if (ret)
+				return ret;
+
+			goto stats_update;
+		}
+
+		return -EOPNOTSUPP;
+	}
+
 	block = &ocelot->block[block_id];
 
 	filter = ocelot_vcap_block_find_filter_by_id(block, f->cookie, true);
@@ -852,7 +897,10 @@ int ocelot_cls_flower_stats(struct ocelot *ocelot, int port,
 	if (ret)
 		return ret;
 
-	flow_stats_update(&f->stats, 0x0, filter->stats.pkts, 0, 0x0,
+	stats.pkts = filter->stats.pkts;
+
+stats_update:
+	flow_stats_update(&f->stats, 0x0, stats.pkts, stats.drops, 0x0,
 			  FLOW_ACTION_HW_STATS_IMMEDIATE);
 	return 0;
 }
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 1d5ff11e4100..e9985ace59c0 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -555,6 +555,11 @@ struct ocelot_ops {
 	u16 (*wm_enc)(u16 value);
 	u16 (*wm_dec)(u16 value);
 	void (*wm_stat)(u32 val, u32 *inuse, u32 *maxuse);
+	void (*psfp_init)(struct ocelot *ocelot);
+	int (*psfp_filter_add)(struct ocelot *ocelot, struct flow_cls_offload *f);
+	int (*psfp_filter_del)(struct ocelot *ocelot, struct flow_cls_offload *f);
+	int (*psfp_stats_get)(struct ocelot *ocelot, struct flow_cls_offload *f,
+			      struct flow_stats *stats);
 };
 
 struct ocelot_vcap_block {
diff --git a/include/soc/mscc/ocelot_vcap.h b/include/soc/mscc/ocelot_vcap.h
index eeb1142aa1b1..9cca2f8e61a2 100644
--- a/include/soc/mscc/ocelot_vcap.h
+++ b/include/soc/mscc/ocelot_vcap.h
@@ -656,6 +656,7 @@ enum ocelot_vcap_filter_type {
 	OCELOT_VCAP_FILTER_DUMMY,
 	OCELOT_VCAP_FILTER_PAG,
 	OCELOT_VCAP_FILTER_OFFLOAD,
+	OCELOT_PSFP_FILTER_OFFLOAD,
 };
 
 struct ocelot_vcap_id {
-- 
2.17.1


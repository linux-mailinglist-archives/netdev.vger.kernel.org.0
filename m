Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A29C841D4C7
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 09:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348947AbhI3Hwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 03:52:33 -0400
Received: from inva020.nxp.com ([92.121.34.13]:43976 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348870AbhI3HwD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 03:52:03 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 64B3B1A0B86;
        Thu, 30 Sep 2021 09:50:20 +0200 (CEST)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id EF1DD1A17BD;
        Thu, 30 Sep 2021 09:50:19 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id 41E81183ACDC;
        Thu, 30 Sep 2021 15:50:17 +0800 (+08)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     allan.nielsen@microchip.com, joergen.andreasen@microchip.com,
        UNGLinuxDriver@microchip.com, vinicius.gomes@intel.com,
        michael.chan@broadcom.com, vishal@chelsio.com, saeedm@mellanox.com,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, kuba@kernel.org,
        xiaoliang.yang_1@nxp.com, po.liu@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, claudiu.manoil@nxp.com,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, matthias.bgg@gmail.com,
        horatiu.vultur@microchip.com
Subject: [PATCH v6 net-next 4/8] net: mscc: ocelot: add gate and police action offload to PSFP
Date:   Thu, 30 Sep 2021 15:59:44 +0800
Message-Id: <20210930075948.36981-5-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210930075948.36981-1-xiaoliang.yang_1@nxp.com>
References: <20210930075948.36981-1-xiaoliang.yang_1@nxp.com>
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
index 0e07ea5f851c..36a28fbb7faa 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2203,6 +2203,9 @@ int ocelot_init(struct ocelot *ocelot)
 	ocelot_vcap_init(ocelot);
 	ocelot_cpu_port_init(ocelot);
 
+	if (ocelot->ops->psfp_init)
+		ocelot->ops->psfp_init(ocelot);
+
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
 		/* Clear all counters (5 groups) */
 		ocelot_write(ocelot, SYS_STAT_CFG_STAT_VIEW(port) |
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index ce812194e44c..daeaee99933d 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -220,10 +220,14 @@ static int ocelot_flower_parse_action(struct ocelot *ocelot, int port,
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
@@ -356,6 +360,14 @@ static int ocelot_flower_parse_action(struct ocelot *ocelot, int port,
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
@@ -646,6 +658,10 @@ static int ocelot_flower_parse(struct ocelot *ocelot, int port, bool ingress,
 	if (ret)
 		return ret;
 
+	/* PSFP filter need to parse key by stream identification function. */
+	if (filter->type == OCELOT_PSFP_FILTER_OFFLOAD)
+		return 0;
+
 	return ocelot_flower_parse_key(ocelot, port, ingress, f, filter);
 }
 
@@ -718,6 +734,15 @@ int ocelot_cls_flower_replace(struct ocelot *ocelot, int port,
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
@@ -733,6 +758,13 @@ int ocelot_cls_flower_destroy(struct ocelot *ocelot, int port,
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
@@ -751,12 +783,25 @@ int ocelot_cls_flower_stats(struct ocelot *ocelot, int port,
 {
 	struct ocelot_vcap_filter *filter;
 	struct ocelot_vcap_block *block;
+	struct flow_stats stats;
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
@@ -767,7 +812,10 @@ int ocelot_cls_flower_stats(struct ocelot *ocelot, int port,
 	if (ret)
 		return ret;
 
-	flow_stats_update(&f->stats, 0x0, filter->stats.pkts, 0, 0x0,
+	stats.pkts = filter->stats.pkts;
+
+stats_update:
+	flow_stats_update(&f->stats, 0x0, stats.pkts, 0, 0x0,
 			  FLOW_ACTION_HW_STATS_IMMEDIATE);
 	return 0;
 }
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index d9129b478c6a..a565abb49c32 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -564,6 +564,11 @@ struct ocelot_ops {
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
index 25fd525aaf92..24b495ce140c 100644
--- a/include/soc/mscc/ocelot_vcap.h
+++ b/include/soc/mscc/ocelot_vcap.h
@@ -646,6 +646,7 @@ enum ocelot_vcap_filter_type {
 	OCELOT_VCAP_FILTER_DUMMY,
 	OCELOT_VCAP_FILTER_PAG,
 	OCELOT_VCAP_FILTER_OFFLOAD,
+	OCELOT_PSFP_FILTER_OFFLOAD,
 };
 
 struct ocelot_vcap_id {
-- 
2.17.1


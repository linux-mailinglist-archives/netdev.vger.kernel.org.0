Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0E82935D4
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 09:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405240AbgJTHc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 03:32:59 -0400
Received: from inva020.nxp.com ([92.121.34.13]:36916 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405199AbgJTHcu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 03:32:50 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 750B91A0795;
        Tue, 20 Oct 2020 09:32:47 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 618F61A06F1;
        Tue, 20 Oct 2020 09:32:39 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id B9C15402FC;
        Tue, 20 Oct 2020 09:32:24 +0200 (CEST)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     allan.nielsen@microchip.com, joergen.andreasen@microchip.com,
        UNGLinuxDriver@microchip.com, vinicius.gomes@intel.com,
        michael.chan@broadcom.com, vishal@chelsio.com, saeedm@mellanox.com,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, kuba@kernel.org,
        xiaoliang.yang_1@nxp.com, po.liu@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, mingkai.hu@nxp.com
Subject: [PATCH v1 net-next 4/5] net: mscc: ocelot: use index to set vcap policer
Date:   Tue, 20 Oct 2020 15:23:20 +0800
Message-Id: <20201020072321.36921-5-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201020072321.36921-1-xiaoliang.yang_1@nxp.com>
References: <20201020072321.36921-1-xiaoliang.yang_1@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Police action of tc flower now uses index to set an entry. This patch
uses the police index to add or delete vcap policers, so that one
policer can be shared by several rules.

VCAP policers and PSFP policers share a same policer pool, so VCAP policer
add or delete operations can be exported and shared with PSFP set.

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c            |   2 +
 drivers/net/dsa/ocelot/felix.h            |   2 +
 drivers/net/dsa/ocelot/felix_vsc9959.c    |   4 +
 drivers/net/ethernet/mscc/ocelot_flower.c |   5 +
 drivers/net/ethernet/mscc/ocelot_vcap.c   | 107 ++++++++++++++--------
 include/soc/mscc/ocelot.h                 |  11 ++-
 6 files changed, 94 insertions(+), 37 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 42f972d10539..d2185ead36e1 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -435,6 +435,8 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	ocelot->shared_queue_sz	= felix->info->shared_queue_sz;
 	ocelot->num_mact_rows	= felix->info->num_mact_rows;
 	ocelot->vcap		= felix->info->vcap;
+	ocelot->vcap_pol.base	= felix->info->vcap_pol_base;
+	ocelot->vcap_pol.max	= felix->info->vcap_pol_max;
 	ocelot->ops		= felix->info->ops;
 	ocelot->inj_prefix	= OCELOT_TAG_PREFIX_SHORT;
 	ocelot->xtr_prefix	= OCELOT_TAG_PREFIX_SHORT;
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 9ea880deb2a0..41a147c978f4 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -22,6 +22,8 @@ struct felix_info {
 	int				num_ports;
 	int				num_tx_queues;
 	struct vcap_props		*vcap;
+	u16				vcap_pol_base;
+	u16				vcap_pol_max;
 	int				switch_pci_bar;
 	int				imdio_pci_bar;
 	const struct ptp_clock_info	*ptp_caps;
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index f171e6f3fc98..32c9b4f60575 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -17,6 +17,8 @@
 #include "felix.h"
 
 #define VSC9959_TAS_GCL_ENTRY_MAX	63
+#define VSC9959_VCAP_POLICER_BASE	63
+#define VSC9959_VCAP_POLICER_MAX	383
 
 static const u32 vsc9959_ana_regmap[] = {
 	REG(ANA_ADVLEARN,			0x0089a0),
@@ -1357,6 +1359,8 @@ static const struct felix_info felix_info_vsc9959 = {
 	.stats_layout		= vsc9959_stats_layout,
 	.num_stats		= ARRAY_SIZE(vsc9959_stats_layout),
 	.vcap			= vsc9959_vcap_props,
+	.vcap_pol_base		= VSC9959_VCAP_POLICER_BASE,
+	.vcap_pol_max		= VSC9959_VCAP_POLICER_MAX,
 	.shared_queue_sz	= 128 * 1024,
 	.num_mact_rows		= 2048,
 	.num_ports		= 6,
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 89f35aecbda7..4957016d503e 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -225,6 +225,11 @@ static int ocelot_flower_parse_action(struct ocelot *ocelot, int port,
 				return -EOPNOTSUPP;
 			}
 			filter->action.police_ena = true;
+			filter->action.pol_ix = a->police.index +
+						ocelot->vcap_pol.base;
+			if (filter->action.pol_ix > ocelot->vcap_pol.max)
+				return -EINVAL;
+
 			rate = a->police.rate_bytes_ps;
 			filter->action.pol.rate = div_u64(rate, 1000) * 8;
 			filter->action.pol.burst = a->police.burst;
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index d8c778ee6f1b..f68b5af591b1 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -886,10 +886,19 @@ static void vcap_entry_set(struct ocelot *ocelot, int ix,
 		return es0_entry_set(ocelot, ix, filter);
 }
 
-static int ocelot_vcap_policer_add(struct ocelot *ocelot, u32 pol_ix,
-				   struct ocelot_policer *pol)
+struct vcap_policer_entry {
+	struct list_head list;
+	refcount_t refcount;
+	u32 pol_ix;
+};
+
+int ocelot_vcap_policer_add(struct ocelot *ocelot, u32 pol_ix,
+			    struct ocelot_policer *pol)
 {
 	struct qos_policer_conf pp = { 0 };
+	struct vcap_policer_entry *tmp;
+	struct list_head *pos, *q;
+	int ret;
 
 	if (!pol)
 		return -EINVAL;
@@ -898,57 +907,79 @@ static int ocelot_vcap_policer_add(struct ocelot *ocelot, u32 pol_ix,
 	pp.pir = pol->rate;
 	pp.pbs = pol->burst;
 
-	return qos_policer_conf_set(ocelot, 0, pol_ix, &pp);
+	list_for_each_safe(pos, q, &ocelot->vcap_pol.pol_list) {
+		tmp = list_entry(pos, struct vcap_policer_entry, list);
+		if (tmp->pol_ix == pol_ix) {
+			refcount_inc(&tmp->refcount);
+			return 0;
+		}
+		if (tmp->pol_ix > pol_ix)
+			break;
+	}
+
+	ret = qos_policer_conf_set(ocelot, 0, pol_ix, &pp);
+	if (ret)
+		return ret;
+
+	tmp = kzalloc(sizeof(*tmp), GFP_KERNEL);
+	if (!tmp)
+		return -ENOMEM;
+
+	tmp->pol_ix = pol_ix;
+	refcount_set(&tmp->refcount, 1);
+	list_add(&tmp->list, pos->prev);
+
+	return 0;
 }
+EXPORT_SYMBOL(ocelot_vcap_policer_add);
 
-static void ocelot_vcap_policer_del(struct ocelot *ocelot,
-				    struct ocelot_vcap_block *block,
-				    u32 pol_ix)
+int ocelot_vcap_policer_del(struct ocelot *ocelot, u32 pol_ix)
 {
-	struct ocelot_vcap_filter *filter;
 	struct qos_policer_conf pp = {0};
-	int index = -1;
-
-	if (pol_ix < block->pol_lpr)
-		return;
-
-	list_for_each_entry(filter, &block->rules, list) {
-		index++;
-		if (filter->block_id == VCAP_IS2 &&
-		    filter->action.police_ena &&
-		    filter->action.pol_ix < pol_ix) {
-			filter->action.pol_ix += 1;
-			ocelot_vcap_policer_add(ocelot, filter->action.pol_ix,
-						&filter->action.pol);
-			is2_entry_set(ocelot, index, filter);
+	struct vcap_policer_entry *tmp;
+	struct list_head *pos, *q;
+	u8 z = 0;
+
+	list_for_each_safe(pos, q, &ocelot->vcap_pol.pol_list) {
+		tmp = list_entry(pos, struct vcap_policer_entry, list);
+		if (tmp->pol_ix == pol_ix) {
+			z = refcount_dec_and_test(&tmp->refcount);
+			if (z) {
+				list_del(pos);
+				kfree(tmp);
+			}
 		}
 	}
 
-	pp.mode = MSCC_QOS_RATE_MODE_DISABLED;
-	qos_policer_conf_set(ocelot, 0, pol_ix, &pp);
+	if (z) {
+		pp.mode = MSCC_QOS_RATE_MODE_DISABLED;
+		return qos_policer_conf_set(ocelot, 0, pol_ix, &pp);
+	}
 
-	block->pol_lpr++;
+	return 0;
 }
+EXPORT_SYMBOL(ocelot_vcap_policer_del);
 
-static void ocelot_vcap_filter_add_to_block(struct ocelot *ocelot,
-					    struct ocelot_vcap_block *block,
-					    struct ocelot_vcap_filter *filter)
+static int ocelot_vcap_filter_add_to_block(struct ocelot *ocelot,
+					   struct ocelot_vcap_block *block,
+					   struct ocelot_vcap_filter *filter)
 {
 	struct ocelot_vcap_filter *tmp;
 	struct list_head *pos, *n;
+	int ret;
 
 	if (filter->block_id == VCAP_IS2 && filter->action.police_ena) {
-		block->pol_lpr--;
-		filter->action.pol_ix = block->pol_lpr;
-		ocelot_vcap_policer_add(ocelot, filter->action.pol_ix,
-					&filter->action.pol);
+		ret = ocelot_vcap_policer_add(ocelot, filter->action.pol_ix,
+					      &filter->action.pol);
+		if (ret)
+			return ret;
 	}
 
 	block->count++;
 
 	if (list_empty(&block->rules)) {
 		list_add(&filter->list, &block->rules);
-		return;
+		return 0;
 	}
 
 	list_for_each_safe(pos, n, &block->rules) {
@@ -957,6 +988,8 @@ static void ocelot_vcap_filter_add_to_block(struct ocelot *ocelot,
 			break;
 	}
 	list_add(&filter->list, pos->prev);
+
+	return 0;
 }
 
 static int ocelot_vcap_block_get_filter_index(struct ocelot_vcap_block *block,
@@ -1122,7 +1155,7 @@ int ocelot_vcap_filter_add(struct ocelot *ocelot,
 			   struct netlink_ext_ack *extack)
 {
 	struct ocelot_vcap_block *block = &ocelot->block[filter->block_id];
-	int i, index;
+	int i, index, ret;
 
 	if (!ocelot_exclusive_mac_etype_filter_rules(ocelot, filter)) {
 		NL_SET_ERR_MSG_MOD(extack,
@@ -1131,7 +1164,9 @@ int ocelot_vcap_filter_add(struct ocelot *ocelot,
 	}
 
 	/* Add filter to the linked list */
-	ocelot_vcap_filter_add_to_block(ocelot, block, filter);
+	ret = ocelot_vcap_filter_add_to_block(ocelot, block, filter);
+	if (ret)
+		return ret;
 
 	/* Get the index of the inserted filter */
 	index = ocelot_vcap_block_get_filter_index(block, filter);
@@ -1163,7 +1198,7 @@ static void ocelot_vcap_block_remove_filter(struct ocelot *ocelot,
 		if (tmp->id == filter->id) {
 			if (tmp->block_id == VCAP_IS2 &&
 			    tmp->action.police_ena)
-				ocelot_vcap_policer_del(ocelot, block,
+				ocelot_vcap_policer_del(ocelot,
 							tmp->action.pol_ix);
 
 			list_del(pos);
@@ -1338,13 +1373,13 @@ int ocelot_vcap_init(struct ocelot *ocelot)
 		struct vcap_props *vcap = &ocelot->vcap[i];
 
 		INIT_LIST_HEAD(&block->rules);
-		block->pol_lpr = OCELOT_POLICER_DISCARD - 1;
 
 		ocelot_vcap_detect_constants(ocelot, vcap);
 		ocelot_vcap_init_one(ocelot, vcap);
 	}
 
 	INIT_LIST_HEAD(&ocelot->dummy_rules);
+	INIT_LIST_HEAD(&ocelot->vcap_pol.pol_list);
 
 	return 0;
 }
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 67e71d75fc97..71b69e58ece5 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -575,10 +575,15 @@ struct ocelot_ops {
 	u16 (*wm_enc)(u16 value);
 };
 
+struct ocelot_vcap_policer {
+	struct list_head pol_list;
+	u16 base;
+	u16 max;
+};
+
 struct ocelot_vcap_block {
 	struct list_head rules;
 	int count;
-	int pol_lpr;
 };
 
 struct ocelot_port {
@@ -645,6 +650,7 @@ struct ocelot {
 
 	struct list_head		dummy_rules;
 	struct ocelot_vcap_block	block[3];
+	struct ocelot_vcap_policer	vcap_pol;
 	struct vcap_props		*vcap;
 
 	/* Workqueue to check statistics for overflow with its lock */
@@ -798,5 +804,8 @@ int ocelot_port_mdb_add(struct ocelot *ocelot, int port,
 			const struct switchdev_obj_port_mdb *mdb);
 int ocelot_port_mdb_del(struct ocelot *ocelot, int port,
 			const struct switchdev_obj_port_mdb *mdb);
+int ocelot_vcap_policer_add(struct ocelot *ocelot, u32 pol_ix,
+			    struct ocelot_policer *pol);
+int ocelot_vcap_policer_del(struct ocelot *ocelot, u32 pol_ix);
 
 #endif
-- 
2.17.1


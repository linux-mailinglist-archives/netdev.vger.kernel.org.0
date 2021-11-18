Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE86455886
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 11:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245473AbhKRKEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 05:04:32 -0500
Received: from inva020.nxp.com ([92.121.34.13]:37708 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245439AbhKRKDC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 05:03:02 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 8A29F1A32CD;
        Thu, 18 Nov 2021 11:00:01 +0100 (CET)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 258341A32CC;
        Thu, 18 Nov 2021 11:00:01 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id BD9C2183AC96;
        Thu, 18 Nov 2021 17:59:58 +0800 (+08)
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
Subject: [PATCH v7 net-next 6/8] net: mscc: ocelot: use index to set vcap policer
Date:   Thu, 18 Nov 2021 18:12:02 +0800
Message-Id: <20211118101204.4338-7-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211118101204.4338-1-xiaoliang.yang_1@nxp.com>
References: <20211118101204.4338-1-xiaoliang.yang_1@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Policer was previously automatically assigned from the highest index to
the lowest index from policer pool. But police action of tc flower now
uses index to set an police entry. This patch uses the police index to
set vcap policers, so that one policer can be shared by multiple rules.

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c             |   4 +
 drivers/net/dsa/ocelot/felix.h             |   4 +
 drivers/net/dsa/ocelot/felix_vsc9959.c     |   6 ++
 drivers/net/dsa/ocelot/seville_vsc9953.c   |   8 ++
 drivers/net/ethernet/mscc/ocelot_flower.c  |  15 +++
 drivers/net/ethernet/mscc/ocelot_vcap.c    | 103 +++++++++++++--------
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |   7 ++
 include/soc/mscc/ocelot.h                  |  14 ++-
 8 files changed, 123 insertions(+), 38 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 327cc4654806..e487143709da 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -989,6 +989,10 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	ocelot->num_stats	= felix->info->num_stats;
 	ocelot->num_mact_rows	= felix->info->num_mact_rows;
 	ocelot->vcap		= felix->info->vcap;
+	ocelot->vcap_pol.base	= felix->info->vcap_pol_base;
+	ocelot->vcap_pol.max	= felix->info->vcap_pol_max;
+	ocelot->vcap_pol.base2	= felix->info->vcap_pol_base2;
+	ocelot->vcap_pol.max2	= felix->info->vcap_pol_max2;
 	ocelot->ops		= felix->info->ops;
 	ocelot->npi_inj_prefix	= OCELOT_TAG_PREFIX_SHORT;
 	ocelot->npi_xtr_prefix	= OCELOT_TAG_PREFIX_SHORT;
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index be3e42e135c0..dfe08dddd262 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -21,6 +21,10 @@ struct felix_info {
 	int				num_ports;
 	int				num_tx_queues;
 	struct vcap_props		*vcap;
+	u16				vcap_pol_base;
+	u16				vcap_pol_max;
+	u16				vcap_pol_base2;
+	u16				vcap_pol_max2;
 	int				switch_pci_bar;
 	int				imdio_pci_bar;
 	const struct ptp_clock_info	*ptp_caps;
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 18a2e538f573..f8d770384344 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -19,6 +19,8 @@
 #include "felix.h"
 
 #define VSC9959_TAS_GCL_ENTRY_MAX	63
+#define VSC9959_VCAP_POLICER_BASE	63
+#define VSC9959_VCAP_POLICER_MAX	383
 
 static const u32 vsc9959_ana_regmap[] = {
 	REG(ANA_ADVLEARN,			0x0089a0),
@@ -1986,6 +1988,10 @@ static const struct felix_info felix_info_vsc9959 = {
 	.stats_layout		= vsc9959_stats_layout,
 	.num_stats		= ARRAY_SIZE(vsc9959_stats_layout),
 	.vcap			= vsc9959_vcap_props,
+	.vcap_pol_base		= VSC9959_VCAP_POLICER_BASE,
+	.vcap_pol_max		= VSC9959_VCAP_POLICER_MAX,
+	.vcap_pol_base2		= 0,
+	.vcap_pol_max2		= 0,
 	.num_mact_rows		= 2048,
 	.num_ports		= 6,
 	.num_tx_queues		= OCELOT_NUM_TC,
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 92eae63150ea..899b98193b4a 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -18,6 +18,10 @@
 #define MSCC_MIIM_CMD_REGAD_SHIFT		20
 #define MSCC_MIIM_CMD_PHYAD_SHIFT		25
 #define MSCC_MIIM_CMD_VLD			BIT(31)
+#define VSC9953_VCAP_POLICER_BASE		11
+#define VSC9953_VCAP_POLICER_MAX		31
+#define VSC9953_VCAP_POLICER_BASE2		120
+#define VSC9953_VCAP_POLICER_MAX2		161
 
 static const u32 vsc9953_ana_regmap[] = {
 	REG(ANA_ADVLEARN,			0x00b500),
@@ -1172,6 +1176,10 @@ static const struct felix_info seville_info_vsc9953 = {
 	.stats_layout		= vsc9953_stats_layout,
 	.num_stats		= ARRAY_SIZE(vsc9953_stats_layout),
 	.vcap			= vsc9953_vcap_props,
+	.vcap_pol_base		= VSC9953_VCAP_POLICER_BASE,
+	.vcap_pol_max		= VSC9953_VCAP_POLICER_MAX,
+	.vcap_pol_base2		= VSC9953_VCAP_POLICER_BASE2,
+	.vcap_pol_max2		= VSC9953_VCAP_POLICER_MAX2,
 	.num_mact_rows		= 2048,
 	.num_ports		= 10,
 	.num_tx_queues		= OCELOT_NUM_TC,
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index b22966e15acf..b54b52fd9e1b 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -222,6 +222,7 @@ static int ocelot_flower_parse_action(struct ocelot *ocelot, int port,
 	const struct flow_action_entry *a;
 	enum ocelot_tag_tpid_sel tpid;
 	int i, chain, egress_port;
+	u32 pol_ix, pol_max;
 	u64 rate;
 	int err;
 
@@ -301,6 +302,20 @@ static int ocelot_flower_parse_action(struct ocelot *ocelot, int port,
 				return -EOPNOTSUPP;
 			}
 			filter->action.police_ena = true;
+
+			pol_ix = a->police.index + ocelot->vcap_pol.base;
+			pol_max = ocelot->vcap_pol.max;
+
+			if (ocelot->vcap_pol.max2 && pol_ix > pol_max) {
+				pol_ix += ocelot->vcap_pol.base2 - pol_max - 1;
+				pol_max = ocelot->vcap_pol.max2;
+			}
+
+			if (pol_ix >= pol_max)
+				return -EINVAL;
+
+			filter->action.pol_ix = pol_ix;
+
 			rate = a->police.rate_bytes_ps;
 			filter->action.pol.rate = div_u64(rate, 1000) * 8;
 			filter->action.pol.burst = a->police.burst;
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index 99d7376a70a7..18ab0fd303c8 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -887,10 +887,18 @@ static void vcap_entry_set(struct ocelot *ocelot, int ix,
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
+	int ret;
 
 	if (!pol)
 		return -EINVAL;
@@ -899,57 +907,74 @@ static int ocelot_vcap_policer_add(struct ocelot *ocelot, u32 pol_ix,
 	pp.pir = pol->rate;
 	pp.pbs = pol->burst;
 
-	return qos_policer_conf_set(ocelot, 0, pol_ix, &pp);
+	list_for_each_entry(tmp, &ocelot->vcap_pol.pol_list, list)
+		if (tmp->pol_ix == pol_ix) {
+			refcount_inc(&tmp->refcount);
+			return 0;
+		}
+
+	tmp = kzalloc(sizeof(*tmp), GFP_KERNEL);
+	if (!tmp)
+		return -ENOMEM;
+
+	ret = qos_policer_conf_set(ocelot, 0, pol_ix, &pp);
+	if (ret) {
+		kfree(tmp);
+		return ret;
+	}
+
+	tmp->pol_ix = pol_ix;
+	refcount_set(&tmp->refcount, 1);
+	list_add_tail(&tmp->list, &ocelot->vcap_pol.pol_list);
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
+	struct vcap_policer_entry *tmp, *n;
+	u8 z = 0;
+
+	list_for_each_entry_safe(tmp, n, &ocelot->vcap_pol.pol_list, list)
+		if (tmp->pol_ix == pol_ix) {
+			z = refcount_dec_and_test(&tmp->refcount);
+			if (z) {
+				list_del(&tmp->list);
+				kfree(tmp);
+			}
 		}
-	}
 
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
@@ -958,6 +983,8 @@ static void ocelot_vcap_filter_add_to_block(struct ocelot *ocelot,
 			break;
 	}
 	list_add(&filter->list, pos->prev);
+
+	return 0;
 }
 
 static bool ocelot_vcap_filter_equal(const struct ocelot_vcap_filter *a,
@@ -1132,7 +1159,7 @@ int ocelot_vcap_filter_add(struct ocelot *ocelot,
 			   struct netlink_ext_ack *extack)
 {
 	struct ocelot_vcap_block *block = &ocelot->block[filter->block_id];
-	int i, index;
+	int i, index, ret;
 
 	if (!ocelot_exclusive_mac_etype_filter_rules(ocelot, filter)) {
 		NL_SET_ERR_MSG_MOD(extack,
@@ -1141,7 +1168,9 @@ int ocelot_vcap_filter_add(struct ocelot *ocelot,
 	}
 
 	/* Add filter to the linked list */
-	ocelot_vcap_filter_add_to_block(ocelot, block, filter);
+	ret = ocelot_vcap_filter_add_to_block(ocelot, block, filter);
+	if (ret)
+		return ret;
 
 	/* Get the index of the inserted filter */
 	index = ocelot_vcap_block_get_filter_index(block, filter);
@@ -1174,7 +1203,7 @@ static void ocelot_vcap_block_remove_filter(struct ocelot *ocelot,
 		if (ocelot_vcap_filter_equal(filter, tmp)) {
 			if (tmp->block_id == VCAP_IS2 &&
 			    tmp->action.police_ena)
-				ocelot_vcap_policer_del(ocelot, block,
+				ocelot_vcap_policer_del(ocelot,
 							tmp->action.pol_ix);
 
 			list_del(pos);
@@ -1350,13 +1379,13 @@ int ocelot_vcap_init(struct ocelot *ocelot)
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
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 38103b0255b0..cd3eb101f159 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -20,6 +20,9 @@
 #include <soc/mscc/ocelot_hsio.h>
 #include "ocelot.h"
 
+#define VSC7514_VCAP_POLICER_BASE			128
+#define VSC7514_VCAP_POLICER_MAX			191
+
 static const u32 ocelot_ana_regmap[] = {
 	REG(ANA_ADVLEARN,				0x009000),
 	REG(ANA_VLANMASK,				0x009004),
@@ -1129,6 +1132,10 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	ocelot->num_flooding_pgids = 1;
 
 	ocelot->vcap = vsc7514_vcap_props;
+
+	ocelot->vcap_pol.base = VSC7514_VCAP_POLICER_BASE;
+	ocelot->vcap_pol.max = VSC7514_VCAP_POLICER_MAX;
+
 	ocelot->npi = -1;
 
 	err = ocelot_init(ocelot);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 5ea72d274d7f..2a41685b5c7d 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -562,10 +562,17 @@ struct ocelot_ops {
 			      struct flow_stats *stats);
 };
 
+struct ocelot_vcap_policer {
+	struct list_head pol_list;
+	u16 base;
+	u16 max;
+	u16 base2;
+	u16 max2;
+};
+
 struct ocelot_vcap_block {
 	struct list_head rules;
 	int count;
-	int pol_lpr;
 };
 
 struct ocelot_bridge_vlan {
@@ -691,6 +698,7 @@ struct ocelot {
 
 	struct list_head		dummy_rules;
 	struct ocelot_vcap_block	block[3];
+	struct ocelot_vcap_policer	vcap_pol;
 	struct vcap_props		*vcap;
 
 	struct ocelot_psfp_list		psfp;
@@ -905,6 +913,10 @@ int ocelot_mact_learn_streamdata(struct ocelot *ocelot, int dst_idx,
 				 enum macaccess_entry_type type,
 				 int sfid, int ssid);
 
+int ocelot_vcap_policer_add(struct ocelot *ocelot, u32 pol_ix,
+			    struct ocelot_policer *pol);
+int ocelot_vcap_policer_del(struct ocelot *ocelot, u32 pol_ix);
+
 #if IS_ENABLED(CONFIG_BRIDGE_MRP)
 int ocelot_mrp_add(struct ocelot *ocelot, int port,
 		   const struct switchdev_obj_mrp *mrp);
-- 
2.17.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC3244146D7
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 12:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235534AbhIVKoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 06:44:11 -0400
Received: from inva021.nxp.com ([92.121.34.21]:54684 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235380AbhIVKn4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 06:43:56 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 17EFD2013EB;
        Wed, 22 Sep 2021 12:42:25 +0200 (CEST)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id A298D2013F8;
        Wed, 22 Sep 2021 12:42:24 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id 30E34183AD2A;
        Wed, 22 Sep 2021 18:42:22 +0800 (+08)
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
        vivien.didelot@gmail.com, claudiu.manoil@nxp.com
Subject: [PATCH v4 net-next 7/8] net: mscc: ocelot: use index to set vcap policer
Date:   Wed, 22 Sep 2021 18:52:01 +0800
Message-Id: <20210922105202.12134-8-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210922105202.12134-1-xiaoliang.yang_1@nxp.com>
References: <20210922105202.12134-1-xiaoliang.yang_1@nxp.com>
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
 drivers/net/dsa/ocelot/felix.c             |   2 +
 drivers/net/dsa/ocelot/felix.h             |   2 +
 drivers/net/dsa/ocelot/felix_vsc9959.c     |   4 +
 drivers/net/ethernet/mscc/ocelot_flower.c  |   5 +
 drivers/net/ethernet/mscc/ocelot_vcap.c    | 103 +++++++++++++--------
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |   7 ++
 include/soc/mscc/ocelot.h                  |  11 ++-
 7 files changed, 96 insertions(+), 38 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 3656e67af789..1505ef2016da 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -984,6 +984,8 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	ocelot->num_stats	= felix->info->num_stats;
 	ocelot->num_mact_rows	= felix->info->num_mact_rows;
 	ocelot->vcap		= felix->info->vcap;
+	ocelot->vcap_pol.base	= felix->info->vcap_pol_base;
+	ocelot->vcap_pol.max	= felix->info->vcap_pol_max;
 	ocelot->ops		= felix->info->ops;
 	ocelot->npi_inj_prefix	= OCELOT_TAG_PREFIX_SHORT;
 	ocelot->npi_xtr_prefix	= OCELOT_TAG_PREFIX_SHORT;
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 5854bab43327..1a299717b8d1 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -21,6 +21,8 @@ struct felix_info {
 	int				num_ports;
 	int				num_tx_queues;
 	struct vcap_props		*vcap;
+	u16				vcap_pol_base;
+	u16				vcap_pol_max;
 	int				switch_pci_bar;
 	int				imdio_pci_bar;
 	const struct ptp_clock_info	*ptp_caps;
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 9264934631d7..1418d2a66bd6 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -19,6 +19,8 @@
 #include "felix.h"
 
 #define VSC9959_TAS_GCL_ENTRY_MAX	63
+#define VSC9959_VCAP_POLICER_BASE	63
+#define VSC9959_VCAP_POLICER_MAX	383
 
 static const u32 vsc9959_ana_regmap[] = {
 	REG(ANA_ADVLEARN,			0x0089a0),
@@ -1999,6 +2001,8 @@ static const struct felix_info felix_info_vsc9959 = {
 	.stats_layout		= vsc9959_stats_layout,
 	.num_stats		= ARRAY_SIZE(vsc9959_stats_layout),
 	.vcap			= vsc9959_vcap_props,
+	.vcap_pol_base		= VSC9959_VCAP_POLICER_BASE,
+	.vcap_pol_max		= VSC9959_VCAP_POLICER_MAX,
 	.num_mact_rows		= 2048,
 	.num_ports		= 6,
 	.num_tx_queues		= OCELOT_NUM_TC,
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index daeaee99933d..bc8a65c227ca 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -241,6 +241,11 @@ static int ocelot_flower_parse_action(struct ocelot *ocelot, int port,
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
index 7945393a0655..1639c2780343 100644
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
index 291ae6817c26..403c47d05304 100644
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
@@ -1128,6 +1131,10 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	ocelot->num_flooding_pgids = 1;
 
 	ocelot->vcap = vsc7514_vcap_props;
+
+	ocelot->vcap_pol.base = VSC7514_VCAP_POLICER_BASE;
+	ocelot->vcap_pol.max = VSC7514_VCAP_POLICER_MAX;
+
 	ocelot->npi = -1;
 
 	err = ocelot_init(ocelot);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index a611f9cd5935..fa006168e7fe 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -571,10 +571,15 @@ struct ocelot_ops {
 			      struct flow_stats *stats);
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
 
 struct ocelot_vlan {
@@ -677,6 +682,7 @@ struct ocelot {
 
 	struct list_head		dummy_rules;
 	struct ocelot_vcap_block	block[3];
+	struct ocelot_vcap_policer	vcap_pol;
 	struct vcap_props		*vcap;
 
 	struct ocelot_psfp_list		psfp;
@@ -941,6 +947,9 @@ int ocelot_mact_lookup(struct ocelot *ocelot, const unsigned char mac[ETH_ALEN],
 void ocelot_mact_write(struct ocelot *ocelot, int port,
 		       const struct ocelot_mact_entry *entry,
 		       int row, int col);
+int ocelot_vcap_policer_add(struct ocelot *ocelot, u32 pol_ix,
+			    struct ocelot_policer *pol);
+int ocelot_vcap_policer_del(struct ocelot *ocelot, u32 pol_ix);
 
 #if IS_ENABLED(CONFIG_BRIDGE_MRP)
 int ocelot_mrp_add(struct ocelot *ocelot, int port,
-- 
2.17.1


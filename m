Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 329F41EB52E
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 07:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728157AbgFBFYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 01:24:40 -0400
Received: from inva021.nxp.com ([92.121.34.21]:40730 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726825AbgFBFYP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 01:24:15 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 48FE8200944;
        Tue,  2 Jun 2020 07:24:10 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 6307A200948;
        Tue,  2 Jun 2020 07:24:00 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id C9F88402B1;
        Tue,  2 Jun 2020 13:23:48 +0800 (SGT)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     xiaoliang.yang_1@nxp.com, po.liu@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, mingkai.hu@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jiri@resnulli.us, idosch@idosch.org,
        kuba@kernel.org, vinicius.gomes@intel.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com, joergen.andreasen@microchip.com,
        UNGLinuxDriver@microchip.com, linux-devel@linux.nxdi.nxp.com
Subject: [PATCH v2 net-next 06/10] net: mscc: ocelot: VCAP ES0 support
Date:   Tue,  2 Jun 2020 13:18:24 +0800
Message-Id: <20200602051828.5734-7-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200602051828.5734-1-xiaoliang.yang_1@nxp.com>
References: <20200602051828.5734-1-xiaoliang.yang_1@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VCAP ES0 is an egress VCAP working on all outgoing frames.
This patch added ES0 driver to support vlan push action of tc filter.
Usage:
	tc filter add dev swp1 egress protocol 802.1Q flower skip_sw
	vlan_id 1 vlan_prio 1 action vlan push id 2 priority 2

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c    | 59 ++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot.c        |  4 ++
 drivers/net/ethernet/mscc/ocelot_ace.c    | 74 ++++++++++++++++++++++-
 drivers/net/ethernet/mscc/ocelot_ace.h    |  2 +
 drivers/net/ethernet/mscc/ocelot_flower.c | 29 ++++++---
 include/soc/mscc/ocelot.h                 |  1 +
 include/soc/mscc/ocelot_vcap.h            | 42 +++++++++++++
 7 files changed, 203 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index f08a5f1c61a5..fceba87509ba 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -18,6 +18,7 @@
 #define VSC9959_VCAP_PORT_CNT		6
 #define VSC9959_VCAP_IS1_CNT		256
 #define VSC9959_VCAP_IS1_ENTRY_WIDTH	376
+#define VSC9959_VCAP_ES0_CNT            1024
 
 /* TODO: should find a better place for these */
 #define USXGMII_BMCR_RESET		BIT(15)
@@ -339,6 +340,7 @@ static const u32 *vsc9959_regmap[] = {
 	[QSYS]	= vsc9959_qsys_regmap,
 	[REW]	= vsc9959_rew_regmap,
 	[SYS]	= vsc9959_sys_regmap,
+	[S0]	= vsc9959_vcap_regmap,
 	[S1]	= vsc9959_vcap_regmap,
 	[S2]	= vsc9959_vcap_regmap,
 	[PTP]	= vsc9959_ptp_regmap,
@@ -372,6 +374,11 @@ static const struct resource vsc9959_target_io_res[] = {
 		.end	= 0x001ffff,
 		.name	= "sys",
 	},
+	[S0] = {
+		.start	= 0x0040000,
+		.end	= 0x00403ff,
+		.name	= "s0",
+	},
 	[S1] = {
 		.start	= 0x0050000,
 		.end	= 0x00503ff,
@@ -567,6 +574,38 @@ static const struct ocelot_stat_layout vsc9959_stats_layout[] = {
 	{ .offset = 0x111,	.name = "drop_green_prio_7", },
 };
 
+struct vcap_field vsc9959_vcap_es0_keys[] = {
+	[VCAP_ES0_EGR_PORT]			= {  0,   3},
+	[VCAP_ES0_IGR_PORT]			= {  3,	  3},
+	[VCAP_ES0_RSV]				= {  6,	  2},
+	[VCAP_ES0_L2_MC]			= {  8,	  1},
+	[VCAP_ES0_L2_BC]			= {  9,	  1},
+	[VCAP_ES0_VID]				= { 10,	 12},
+	[VCAP_ES0_DP]				= { 22,	  1},
+	[VCAP_ES0_PCP]				= { 23,	  3},
+};
+
+struct vcap_field vsc9959_vcap_es0_actions[] = {
+	[VCAP_ES0_ACT_PUSH_OUTER_TAG]		= {  0,  2},
+	[VCAP_ES0_ACT_PUSH_INNER_TAG]		= {  2,  1},
+	[VCAP_ES0_ACT_TAG_A_TPID_SEL]		= {  3,  2},
+	[VCAP_ES0_ACT_TAG_A_VID_SEL]		= {  5,  1},
+	[VCAP_ES0_ACT_TAG_A_PCP_SEL]		= {  6,  2},
+	[VCAP_ES0_ACT_TAG_A_DEI_SEL]		= {  8,  2},
+	[VCAP_ES0_ACT_TAG_B_TPID_SEL]		= { 10,  2},
+	[VCAP_ES0_ACT_TAG_B_VID_SEL]		= { 12,  1},
+	[VCAP_ES0_ACT_TAG_B_PCP_SEL]		= { 13,  2},
+	[VCAP_ES0_ACT_TAG_B_DEI_SEL]		= { 15,  2},
+	[VCAP_ES0_ACT_VID_A_VAL]		= { 17, 12},
+	[VCAP_ES0_ACT_PCP_A_VAL]		= { 29,  3},
+	[VCAP_ES0_ACT_DEI_A_VAL]		= { 32,  1},
+	[VCAP_ES0_ACT_VID_B_VAL]		= { 33, 12},
+	[VCAP_ES0_ACT_PCP_B_VAL]		= { 45,  3},
+	[VCAP_ES0_ACT_DEI_B_VAL]		= { 48,  1},
+	[VCAP_ES0_ACT_RSV]			= { 49, 23},
+	[VCAP_ES0_ACT_HIT_STICKY]		= { 72,  1},
+};
+
 struct vcap_field vsc9959_vcap_is1_keys[] = {
 	[VCAP_IS1_HK_TYPE]			= {  0,   1},
 	[VCAP_IS1_HK_LOOKUP]			= {  1,   2},
@@ -740,6 +779,26 @@ struct vcap_field vsc9959_vcap_is2_actions[] = {
 };
 
 static const struct vcap_props vsc9959_vcap_props[] = {
+	[VCAP_ES0] = {
+		.tg_width = 1,
+		.sw_count = 1,
+		.entry_count = VSC9959_VCAP_ES0_CNT,
+		.entry_width = 29,
+		.action_count = VSC9959_VCAP_ES0_CNT + 6,
+		.action_width = 72,
+		.action_type_width = 0,
+		.action_table = {
+			[ES0_ACTION_TYPE_NORMAL] = {
+				.width = 72,
+				.count = 1
+			},
+		},
+		.counter_words = 1,
+		.counter_width = 1,
+		.target = S0,
+		.keys = vsc9959_vcap_es0_keys,
+		.actions = vsc9959_vcap_es0_actions,
+	},
 	[VCAP_IS1] = {
 		.tg_width = 2,
 		.sw_count = 4,
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 533e907af0e9..7556a43e2698 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -143,6 +143,10 @@ static void ocelot_vcap_enable(struct ocelot *ocelot, int port)
 			 ANA_PORT_VCAP_S1_KEY_CFG_S1_KEY_IP6_CFG(2) |
 			 ANA_PORT_VCAP_S1_KEY_CFG_S1_KEY_IP4_CFG(2),
 			 ANA_PORT_VCAP_S1_KEY_CFG, port);
+
+	ocelot_rmw_gix(ocelot, REW_PORT_CFG_ES0_EN,
+		       REW_PORT_CFG_ES0_EN,
+		       REW_PORT_CFG, port);
 }
 
 static inline u32 ocelot_vlant_read_vlanaccess(struct ocelot *ocelot)
diff --git a/drivers/net/ethernet/mscc/ocelot_ace.c b/drivers/net/ethernet/mscc/ocelot_ace.c
index bf21e4c5a9db..76d679b8d15e 100644
--- a/drivers/net/ethernet/mscc/ocelot_ace.c
+++ b/drivers/net/ethernet/mscc/ocelot_ace.c
@@ -836,6 +836,69 @@ static void is1_entry_set(struct ocelot *ocelot, int ix,
 	vcap_row_cmd(ocelot, vcap, row, VCAP_CMD_WRITE, VCAP_SEL_ALL);
 }
 
+static void es0_action_set(struct ocelot *ocelot, struct vcap_data *data,
+			   struct ocelot_ace_rule *ace)
+{
+	const struct vcap_props *vcap = &ocelot->vcap[VCAP_ES0];
+
+	switch (ace->action) {
+	case OCELOT_ACL_ACTION_VLAN_PUSH:
+		vcap_action_set(vcap, data, VCAP_ES0_ACT_PUSH_OUTER_TAG, 1);
+		vcap_action_set(vcap, data, VCAP_ES0_ACT_TAG_A_VID_SEL, 1);
+		vcap_action_set(vcap, data, VCAP_ES0_ACT_VID_A_VAL,
+				ace->vlan_modify.vid);
+		vcap_action_set(vcap, data, VCAP_ES0_ACT_TAG_A_PCP_SEL, 1);
+		vcap_action_set(vcap, data, VCAP_ES0_ACT_PCP_A_VAL,
+				ace->vlan_modify.pcp);
+		break;
+	default:
+		break;
+	}
+}
+
+static void es0_entry_set(struct ocelot *ocelot, int ix,
+			  struct ocelot_ace_rule *ace)
+{
+	const struct vcap_props *vcap = &ocelot->vcap[VCAP_ES0];
+	struct ocelot_ace_vlan *tag = &ace->vlan;
+	struct ocelot_vcap_u64 payload;
+	struct vcap_data data;
+	int row = ix;
+	u32 msk = 0x7;
+
+	memset(&payload, 0, sizeof(payload));
+	memset(&data, 0, sizeof(data));
+
+	/* Read row */
+	vcap_row_cmd(ocelot, vcap, row, VCAP_CMD_READ, VCAP_SEL_ALL);
+	vcap_cache2entry(ocelot, vcap, &data);
+	vcap_cache2action(ocelot, vcap, &data);
+
+	data.tg_sw = VCAP_TG_FULL;
+	data.type = ES0_ACTION_TYPE_NORMAL;
+	vcap_data_offset_get(vcap, &data, ix);
+	data.tg = (data.tg & ~data.tg_mask);
+	if (ace->prio != 0)
+		data.tg |= data.tg_value;
+
+	vcap_key_set(vcap, &data, VCAP_ES0_EGR_PORT, ace->egress_port, msk);
+	vcap_key_bit_set(vcap, &data, VCAP_ES0_L2_MC, ace->dmac_mc);
+	vcap_key_bit_set(vcap, &data, VCAP_ES0_L2_BC, ace->dmac_bc);
+	vcap_key_set(vcap, &data, VCAP_ES0_VID,
+		     tag->vid.value, tag->vid.mask);
+	vcap_key_set(vcap, &data, VCAP_ES0_PCP,
+		     tag->pcp.value[0], tag->pcp.mask[0]);
+
+	es0_action_set(ocelot, &data, ace);
+	vcap_data_set(data.counter, data.counter_offset,
+		      vcap->counter_width, ace->stats.pkts);
+
+	/* Write row */
+	vcap_entry2cache(ocelot, vcap, &data);
+	vcap_action2cache(ocelot, vcap, &data);
+	vcap_row_cmd(ocelot, vcap, row, VCAP_CMD_WRITE, VCAP_SEL_ALL);
+}
+
 static void vcap_entry_get(struct ocelot *ocelot, struct ocelot_ace_rule *rule,
 			   int ix, int block_id)
 {
@@ -844,7 +907,11 @@ static void vcap_entry_get(struct ocelot *ocelot, struct ocelot_ace_rule *rule,
 	int row, count;
 	u32 cnt;
 
-	data.tg_sw = VCAP_TG_HALF;
+	if (block_id == VCAP_ES0)
+		data.tg_sw = VCAP_TG_FULL;
+	else
+		data.tg_sw = VCAP_TG_HALF;
+
 	count = (1 << (data.tg_sw - 1));
 	row = (ix / count);
 	vcap_row_cmd(ocelot, vcap, row, VCAP_CMD_READ, VCAP_SEL_COUNTER);
@@ -867,6 +934,9 @@ static void vcap_entry_set(struct ocelot *ocelot, int ix,
 	case VCAP_IS2:
 		is2_entry_set(ocelot, ix, ace);
 		break;
+	case VCAP_ES0:
+		es0_entry_set(ocelot, ix, ace);
+		break;
 	default:
 		break;
 	}
@@ -1180,6 +1250,7 @@ int ocelot_ace_init(struct ocelot *ocelot)
 {
 	struct ocelot_acl_block *block;
 
+	vcap_init(ocelot, &ocelot->vcap[VCAP_ES0]);
 	vcap_init(ocelot, &ocelot->vcap[VCAP_IS1]);
 	vcap_init(ocelot, &ocelot->vcap[VCAP_IS2]);
 
@@ -1200,6 +1271,7 @@ int ocelot_ace_init(struct ocelot *ocelot)
 
 	block = &ocelot->acl_block[VCAP_IS2];
 	block->pol_lpr = OCELOT_POLICER_DISCARD - 1;
+	INIT_LIST_HEAD(&ocelot->acl_block[VCAP_ES0].rules);
 	INIT_LIST_HEAD(&ocelot->acl_block[VCAP_IS1].rules);
 	INIT_LIST_HEAD(&ocelot->acl_block[VCAP_IS2].rules);
 
diff --git a/drivers/net/ethernet/mscc/ocelot_ace.h b/drivers/net/ethernet/mscc/ocelot_ace.h
index bb2df6adaefd..70fe45d747fb 100644
--- a/drivers/net/ethernet/mscc/ocelot_ace.h
+++ b/drivers/net/ethernet/mscc/ocelot_ace.h
@@ -188,6 +188,7 @@ enum ocelot_ace_action {
 	OCELOT_ACL_ACTION_POLICE,
 	OCELOT_ACL_ACTION_VLAN_MODIFY,
 	OCELOT_ACL_ACTION_PRIORITY,
+	OCELOT_ACL_ACTION_VLAN_PUSH,
 };
 
 struct ocelot_ace_stats {
@@ -205,6 +206,7 @@ struct ocelot_ace_rule {
 	enum ocelot_ace_action action;
 	struct ocelot_ace_stats stats;
 	unsigned long ingress_port_mask;
+	u8 egress_port;
 
 	enum ocelot_vcap_bit dmac_mc;
 	enum ocelot_vcap_bit dmac_bc;
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 7f1a40ede652..d598e103c796 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -22,11 +22,13 @@ static int ocelot_block_id_get(int chain, bool ingress)
 }
 
 static int ocelot_flower_parse_action(struct flow_cls_offload *f,
-				      struct ocelot_ace_rule *ace)
+				      struct ocelot_ace_rule *ace,
+				      bool ingress)
 {
 	struct netlink_ext_ack *extack = f->common.extack;
 	const struct flow_action_entry *a;
 	int i, allowed_chain = 0;
+	bool allowed_ingress = 1;
 	s64 burst;
 	u64 rate;
 
@@ -74,10 +76,18 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f,
 			ace->qos_val = a->priority;
 			allowed_chain = 0;
 			break;
+		case FLOW_ACTION_VLAN_PUSH:
+			ace->action = OCELOT_ACL_ACTION_VLAN_PUSH;
+			ace->vlan_modify.vid = a->vlan.vid;
+			ace->vlan_modify.pcp = a->vlan.prio;
+			allowed_ingress = 0;
+			allowed_chain = 0;
+			break;
 		default:
 			return -EOPNOTSUPP;
 		}
-		if (f->common.chain_index != allowed_chain) {
+		if (f->common.chain_index != allowed_chain ||
+		    allowed_ingress != ingress) {
 			NL_SET_ERR_MSG_MOD(extack, "Action is not supported on this chain\n");
 			return -EOPNOTSUPP;
 		}
@@ -87,7 +97,8 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f,
 }
 
 static int ocelot_flower_parse(struct flow_cls_offload *f,
-			       struct ocelot_ace_rule *ace)
+			       struct ocelot_ace_rule *ace,
+			       bool ingress)
 {
 	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
 	struct flow_dissector *dissector = rule->match.dissector;
@@ -223,11 +234,12 @@ static int ocelot_flower_parse(struct flow_cls_offload *f,
 
 	ace->prio = f->common.prio;
 	ace->id = f->cookie;
-	return ocelot_flower_parse_action(f, ace);
+	return ocelot_flower_parse_action(f, ace, ingress);
 }
 
 static
 struct ocelot_ace_rule *ocelot_ace_rule_create(struct ocelot *ocelot, int port,
+					       bool ingress,
 					       struct flow_cls_offload *f)
 {
 	struct ocelot_ace_rule *ace;
@@ -236,7 +248,10 @@ struct ocelot_ace_rule *ocelot_ace_rule_create(struct ocelot *ocelot, int port,
 	if (!ace)
 		return NULL;
 
-	ace->ingress_port_mask = BIT(port);
+	if (ingress)
+		ace->ingress_port_mask = BIT(port);
+	else
+		ace->egress_port = port;
 	return ace;
 }
 
@@ -246,11 +261,11 @@ int ocelot_cls_flower_replace(struct ocelot *ocelot, int port,
 	struct ocelot_ace_rule *ace;
 	int ret, block_id;
 
-	ace = ocelot_ace_rule_create(ocelot, port, f);
+	ace = ocelot_ace_rule_create(ocelot, port, ingress, f);
 	if (!ace)
 		return -ENOMEM;
 
-	ret = ocelot_flower_parse(f, ace);
+	ret = ocelot_flower_parse(f, ace, ingress);
 	if (ret) {
 		kfree(ace);
 		return ret;
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 1768ad1ca4e6..4a86eb9c714e 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -107,6 +107,7 @@ enum ocelot_target {
 	QSYS,
 	REW,
 	SYS,
+	S0,
 	S1,
 	S2,
 	HSIO,
diff --git a/include/soc/mscc/ocelot_vcap.h b/include/soc/mscc/ocelot_vcap.h
index 9e83757f9b02..0c882c588629 100644
--- a/include/soc/mscc/ocelot_vcap.h
+++ b/include/soc/mscc/ocelot_vcap.h
@@ -355,4 +355,46 @@ enum vcap_is1_action_field {
 	VCAP_IS1_ACT_HIT_STICKY,
 };
 
+/* =================================================================
+ *  VCAP ES0
+ * =================================================================
+ */
+
+enum {
+	ES0_ACTION_TYPE_NORMAL,
+	ES0_ACTION_TYPE_MAX,
+};
+
+enum vcap_es0_key_field {
+	VCAP_ES0_EGR_PORT,
+	VCAP_ES0_IGR_PORT,
+	VCAP_ES0_RSV,
+	VCAP_ES0_L2_MC,
+	VCAP_ES0_L2_BC,
+	VCAP_ES0_VID,
+	VCAP_ES0_DP,
+	VCAP_ES0_PCP,
+};
+
+enum vcap_es0_action_field {
+	VCAP_ES0_ACT_PUSH_OUTER_TAG,
+	VCAP_ES0_ACT_PUSH_INNER_TAG,
+	VCAP_ES0_ACT_TAG_A_TPID_SEL,
+	VCAP_ES0_ACT_TAG_A_VID_SEL,
+	VCAP_ES0_ACT_TAG_A_PCP_SEL,
+	VCAP_ES0_ACT_TAG_A_DEI_SEL,
+	VCAP_ES0_ACT_TAG_B_TPID_SEL,
+	VCAP_ES0_ACT_TAG_B_VID_SEL,
+	VCAP_ES0_ACT_TAG_B_PCP_SEL,
+	VCAP_ES0_ACT_TAG_B_DEI_SEL,
+	VCAP_ES0_ACT_VID_A_VAL,
+	VCAP_ES0_ACT_PCP_A_VAL,
+	VCAP_ES0_ACT_DEI_A_VAL,
+	VCAP_ES0_ACT_VID_B_VAL,
+	VCAP_ES0_ACT_PCP_B_VAL,
+	VCAP_ES0_ACT_DEI_B_VAL,
+	VCAP_ES0_ACT_RSV,
+	VCAP_ES0_ACT_HIT_STICKY,
+};
+
 #endif /* _OCELOT_VCAP_H_ */
-- 
2.17.1


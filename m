Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B001EB52D
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 07:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbgFBFYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 01:24:39 -0400
Received: from inva020.nxp.com ([92.121.34.13]:44644 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726937AbgFBFYP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 01:24:15 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id C61431A0B7B;
        Tue,  2 Jun 2020 07:24:12 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id E2A091A0B7A;
        Tue,  2 Jun 2020 07:24:02 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id F28F440280;
        Tue,  2 Jun 2020 13:23:50 +0800 (SGT)
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
Subject: [PATCH v2 net-next 07/10] net: mscc: ocelot: multiple actions support
Date:   Tue,  2 Jun 2020 13:18:25 +0800
Message-Id: <20200602051828.5734-8-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200602051828.5734-1-xiaoliang.yang_1@nxp.com>
References: <20200602051828.5734-1-xiaoliang.yang_1@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support multiple actions for each flower rule, multiple actions can only
set on the same VCAP, and all actions can mix with action goto chain.
Action drop, trap, and police on VCAP IS2 could not be mixed.

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_ace.c    | 15 +++++++++------
 drivers/net/ethernet/mscc/ocelot_ace.h    |  8 +++++++-
 drivers/net/ethernet/mscc/ocelot_flower.c | 14 +++++++++-----
 3 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_ace.c b/drivers/net/ethernet/mscc/ocelot_ace.c
index 76d679b8d15e..bf2b7a03c832 100644
--- a/drivers/net/ethernet/mscc/ocelot_ace.c
+++ b/drivers/net/ethernet/mscc/ocelot_ace.c
@@ -651,20 +651,23 @@ static void is1_action_set(struct ocelot *ocelot, struct vcap_data *data,
 	const struct vcap_props *vcap = &ocelot->vcap[VCAP_IS1];
 
 	switch (ace->action) {
+	case OCELOT_ACL_ACTION_PRIORITY:
 	case OCELOT_ACL_ACTION_VLAN_MODIFY:
-		vcap_action_set(vcap, data, VCAP_IS1_ACT_VID_REPLACE_ENA, 1);
+		vcap_action_set(vcap, data, VCAP_IS1_ACT_VID_REPLACE_ENA,
+				ace->vlan_modify.ena);
 		vcap_action_set(vcap, data, VCAP_IS1_ACT_VID_ADD_VAL,
 				ace->vlan_modify.vid);
-		vcap_action_set(vcap, data, VCAP_IS1_ACT_PCP_DEI_ENA, 1);
+		vcap_action_set(vcap, data, VCAP_IS1_ACT_PCP_DEI_ENA,
+				ace->vlan_modify.ena);
 		vcap_action_set(vcap, data, VCAP_IS1_ACT_PCP_VAL,
 				ace->vlan_modify.pcp);
 		vcap_action_set(vcap, data, VCAP_IS1_ACT_DEI_VAL,
 				ace->vlan_modify.dei);
-		break;
-	case OCELOT_ACL_ACTION_PRIORITY:
-		vcap_action_set(vcap, data, VCAP_IS1_ACT_QOS_ENA, 1);
+
+		vcap_action_set(vcap, data, VCAP_IS1_ACT_QOS_ENA,
+				ace->qos_modify.ena);
 		vcap_action_set(vcap, data, VCAP_IS1_ACT_QOS_VAL,
-				ace->qos_val);
+				ace->qos_modify.qos_val);
 		break;
 	default:
 		break;
diff --git a/drivers/net/ethernet/mscc/ocelot_ace.h b/drivers/net/ethernet/mscc/ocelot_ace.h
index 70fe45d747fb..02fa81b3fe92 100644
--- a/drivers/net/ethernet/mscc/ocelot_ace.h
+++ b/drivers/net/ethernet/mscc/ocelot_ace.h
@@ -97,6 +97,12 @@ struct ocelot_ace_action_vlan {
 	u16 vid;
 	u8 pcp;
 	u8 dei;
+	u8 ena;
+};
+
+struct ocelot_ace_action_qos {
+	u8 qos_val;
+	u8 ena;
 };
 
 struct ocelot_ace_frame_etype {
@@ -212,6 +218,7 @@ struct ocelot_ace_rule {
 	enum ocelot_vcap_bit dmac_bc;
 	struct ocelot_ace_vlan vlan;
 	struct ocelot_ace_action_vlan vlan_modify;
+	struct ocelot_ace_action_qos qos_modify;
 
 	enum ocelot_ace_type type;
 	union {
@@ -225,7 +232,6 @@ struct ocelot_ace_rule {
 	} frame;
 	struct ocelot_policer pol;
 	u32 pol_ix;
-	u8 qos_val;
 };
 
 int ocelot_ace_rule_offload_add(struct ocelot *ocelot, int block_id,
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index d598e103c796..6ce37f152f12 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -32,9 +32,6 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f,
 	s64 burst;
 	u64 rate;
 
-	if (!flow_offload_has_one_action(&f->rule->action))
-		return -EOPNOTSUPP;
-
 	if (!flow_action_basic_hw_stats_check(&f->rule->action,
 					      f->common.extack))
 		return -EOPNOTSUPP;
@@ -42,14 +39,20 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f,
 	flow_action_for_each(i, a, &f->rule->action) {
 		switch (a->id) {
 		case FLOW_ACTION_DROP:
+			if (i)
+				return -EOPNOTSUPP;
 			ace->action = OCELOT_ACL_ACTION_DROP;
 			allowed_chain = 1;
 			break;
 		case FLOW_ACTION_TRAP:
+			if (i)
+				return -EOPNOTSUPP;
 			ace->action = OCELOT_ACL_ACTION_TRAP;
 			allowed_chain = 1;
 			break;
 		case FLOW_ACTION_POLICE:
+			if (i)
+				return -EOPNOTSUPP;
 			ace->action = OCELOT_ACL_ACTION_POLICE;
 			rate = a->police.rate_bytes_ps;
 			ace->pol.rate = div_u64(rate, 1000) * 8;
@@ -62,18 +65,19 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f,
 				NL_SET_ERR_MSG_MOD(extack, "HW only support goto next chain\n");
 				return -EOPNOTSUPP;
 			}
-			ace->action = OCELOT_ACL_ACTION_NULL;
 			allowed_chain = f->common.chain_index;
 			break;
 		case FLOW_ACTION_VLAN_MANGLE:
 			ace->action = OCELOT_ACL_ACTION_VLAN_MODIFY;
+			ace->vlan_modify.ena = 1;
 			ace->vlan_modify.vid = a->vlan.vid;
 			ace->vlan_modify.pcp = a->vlan.prio;
 			allowed_chain = 0;
 			break;
 		case FLOW_ACTION_PRIORITY:
 			ace->action = OCELOT_ACL_ACTION_PRIORITY;
-			ace->qos_val = a->priority;
+			ace->qos_modify.ena = 1;
+			ace->qos_modify.qos_val = a->priority;
 			allowed_chain = 0;
 			break;
 		case FLOW_ACTION_VLAN_PUSH:
-- 
2.17.1


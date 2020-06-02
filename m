Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 598CC1EB51C
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 07:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgFBFYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 01:24:08 -0400
Received: from inva020.nxp.com ([92.121.34.13]:44394 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726012AbgFBFYG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 01:24:06 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id F10931A0B82;
        Tue,  2 Jun 2020 07:24:03 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 360021A00EC;
        Tue,  2 Jun 2020 07:23:54 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 4721740285;
        Tue,  2 Jun 2020 13:23:42 +0800 (SGT)
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
Subject: [PATCH v2 net-next 03/10] net: mscc: ocelot: allocated rules to different hardware VCAP TCAMs by chain index
Date:   Tue,  2 Jun 2020 13:18:21 +0800
Message-Id: <20200602051828.5734-4-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200602051828.5734-1-xiaoliang.yang_1@nxp.com>
References: <20200602051828.5734-1-xiaoliang.yang_1@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are three hardware TCAMs for ocelot chips: IS1, IS2 and ES0. Each
one supports different actions. The hardware flow order is: IS1->IS2->ES0.

This patch add three blocks to store rules according to chain index.
chain 0 is offloaded to IS1, chain 1 is offloaded to IS2, and egress chain
0 is offloaded to ES0.

Using action goto chain to express flow order as follows:
	tc filter add dev swp0 chain 0 parent ffff: flower skip_sw \
	action goto chain 1

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_ace.c    | 51 +++++++++++++++--------
 drivers/net/ethernet/mscc/ocelot_ace.h    |  7 ++--
 drivers/net/ethernet/mscc/ocelot_flower.c | 46 +++++++++++++++++---
 include/soc/mscc/ocelot.h                 |  2 +-
 include/soc/mscc/ocelot_vcap.h            |  4 +-
 5 files changed, 81 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_ace.c b/drivers/net/ethernet/mscc/ocelot_ace.c
index 748c618db7d8..b76593b40097 100644
--- a/drivers/net/ethernet/mscc/ocelot_ace.c
+++ b/drivers/net/ethernet/mscc/ocelot_ace.c
@@ -341,6 +341,8 @@ static void is2_action_set(struct ocelot *ocelot, struct vcap_data *data,
 		vcap_action_set(vcap, data, VCAP_IS2_ACT_CPU_QU_NUM, 0);
 		vcap_action_set(vcap, data, VCAP_IS2_ACT_CPU_COPY_ENA, 0);
 		break;
+	default:
+		break;
 	}
 }
 
@@ -644,9 +646,9 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 }
 
 static void vcap_entry_get(struct ocelot *ocelot, struct ocelot_ace_rule *rule,
-			   int ix)
+			   int ix, int block_id)
 {
-	const struct vcap_props *vcap = &ocelot->vcap[VCAP_IS2];
+	const struct vcap_props *vcap = &ocelot->vcap[block_id];
 	struct vcap_data data;
 	int row, count;
 	u32 cnt;
@@ -663,6 +665,19 @@ static void vcap_entry_get(struct ocelot *ocelot, struct ocelot_ace_rule *rule,
 	rule->stats.pkts = cnt;
 }
 
+static void vcap_entry_set(struct ocelot *ocelot, int ix,
+			   struct ocelot_ace_rule *ace,
+			   int block_id)
+{
+	switch (block_id) {
+	case VCAP_IS2:
+		is2_entry_set(ocelot, ix, ace);
+		break;
+	default:
+		break;
+	}
+}
+
 static void ocelot_ace_rule_add(struct ocelot *ocelot,
 				struct ocelot_acl_block *block,
 				struct ocelot_ace_rule *rule)
@@ -790,7 +805,7 @@ static bool ocelot_ace_is_problematic_non_mac_etype(struct ocelot_ace_rule *ace)
 static bool ocelot_exclusive_mac_etype_ace_rules(struct ocelot *ocelot,
 						 struct ocelot_ace_rule *ace)
 {
-	struct ocelot_acl_block *block = &ocelot->acl_block;
+	struct ocelot_acl_block *block = &ocelot->acl_block[VCAP_IS2];
 	struct ocelot_ace_rule *tmp;
 	unsigned long port;
 	int i;
@@ -824,15 +839,16 @@ static bool ocelot_exclusive_mac_etype_ace_rules(struct ocelot *ocelot,
 	return true;
 }
 
-int ocelot_ace_rule_offload_add(struct ocelot *ocelot,
+int ocelot_ace_rule_offload_add(struct ocelot *ocelot, int block_id,
 				struct ocelot_ace_rule *rule,
 				struct netlink_ext_ack *extack)
 {
-	struct ocelot_acl_block *block = &ocelot->acl_block;
+	struct ocelot_acl_block *block = &ocelot->acl_block[block_id];
 	struct ocelot_ace_rule *ace;
 	int i, index;
 
-	if (!ocelot_exclusive_mac_etype_ace_rules(ocelot, rule)) {
+	if (block_id == VCAP_IS2 &&
+	    !ocelot_exclusive_mac_etype_ace_rules(ocelot, rule)) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Cannot mix MAC_ETYPE with non-MAC_ETYPE rules");
 		return -EBUSY;
@@ -847,11 +863,11 @@ int ocelot_ace_rule_offload_add(struct ocelot *ocelot,
 	/* Move down the rules to make place for the new rule */
 	for (i = block->count - 1; i > index; i--) {
 		ace = ocelot_ace_rule_get_rule_index(block, i);
-		is2_entry_set(ocelot, i, ace);
+		vcap_entry_set(ocelot, i, ace, block_id);
 	}
 
 	/* Now insert the new rule */
-	is2_entry_set(ocelot, index, rule);
+	vcap_entry_set(ocelot, index, rule, block_id);
 	return 0;
 }
 
@@ -902,10 +918,10 @@ static void ocelot_ace_rule_del(struct ocelot *ocelot,
 	block->count--;
 }
 
-int ocelot_ace_rule_offload_del(struct ocelot *ocelot,
+int ocelot_ace_rule_offload_del(struct ocelot *ocelot, int block_id,
 				struct ocelot_ace_rule *rule)
 {
-	struct ocelot_acl_block *block = &ocelot->acl_block;
+	struct ocelot_acl_block *block = &ocelot->acl_block[block_id];
 	struct ocelot_ace_rule del_ace;
 	struct ocelot_ace_rule *ace;
 	int i, index;
@@ -921,29 +937,29 @@ int ocelot_ace_rule_offload_del(struct ocelot *ocelot,
 	/* Move up all the blocks over the deleted rule */
 	for (i = index; i < block->count; i++) {
 		ace = ocelot_ace_rule_get_rule_index(block, i);
-		is2_entry_set(ocelot, i, ace);
+		vcap_entry_set(ocelot, i, ace, block_id);
 	}
 
 	/* Now delete the last rule, because it is duplicated */
-	is2_entry_set(ocelot, block->count, &del_ace);
+	vcap_entry_set(ocelot, block->count, &del_ace, block_id);
 
 	return 0;
 }
 
-int ocelot_ace_rule_stats_update(struct ocelot *ocelot,
+int ocelot_ace_rule_stats_update(struct ocelot *ocelot, int block_id,
 				 struct ocelot_ace_rule *rule)
 {
-	struct ocelot_acl_block *block = &ocelot->acl_block;
+	struct ocelot_acl_block *block = &ocelot->acl_block[block_id];
 	struct ocelot_ace_rule *tmp;
 	int index;
 
 	index = ocelot_ace_rule_get_index_id(block, rule);
-	vcap_entry_get(ocelot, rule, index);
+	vcap_entry_get(ocelot, rule, index, block_id);
 
 	/* After we get the result we need to clear the counters */
 	tmp = ocelot_ace_rule_get_rule_index(block, index);
 	tmp->stats.pkts = 0;
-	is2_entry_set(ocelot, index, tmp);
+	vcap_entry_set(ocelot, index, tmp, block_id);
 
 	return 0;
 }
@@ -968,7 +984,7 @@ static void vcap_init(struct ocelot *ocelot, const struct vcap_props *vcap)
 
 int ocelot_ace_init(struct ocelot *ocelot)
 {
-	struct ocelot_acl_block *block = &ocelot->acl_block;
+	struct ocelot_acl_block *block;
 
 	vcap_init(ocelot, &ocelot->vcap[VCAP_IS2]);
 
@@ -987,6 +1003,7 @@ int ocelot_ace_init(struct ocelot *ocelot)
 	ocelot_write_gix(ocelot, 0x3fffff, ANA_POL_CIR_STATE,
 			 OCELOT_POLICER_DISCARD);
 
+	block = &ocelot->acl_block[VCAP_IS2];
 	block->pol_lpr = OCELOT_POLICER_DISCARD - 1;
 	INIT_LIST_HEAD(&block->rules);
 
diff --git a/drivers/net/ethernet/mscc/ocelot_ace.h b/drivers/net/ethernet/mscc/ocelot_ace.h
index 099e177f2617..a9fd99401a65 100644
--- a/drivers/net/ethernet/mscc/ocelot_ace.h
+++ b/drivers/net/ethernet/mscc/ocelot_ace.h
@@ -175,6 +175,7 @@ struct ocelot_ace_frame_ipv6 {
 };
 
 enum ocelot_ace_action {
+	OCELOT_ACL_ACTION_NULL,
 	OCELOT_ACL_ACTION_DROP,
 	OCELOT_ACL_ACTION_TRAP,
 	OCELOT_ACL_ACTION_POLICE,
@@ -214,12 +215,12 @@ struct ocelot_ace_rule {
 	u32 pol_ix;
 };
 
-int ocelot_ace_rule_offload_add(struct ocelot *ocelot,
+int ocelot_ace_rule_offload_add(struct ocelot *ocelot, int block_id,
 				struct ocelot_ace_rule *rule,
 				struct netlink_ext_ack *extack);
-int ocelot_ace_rule_offload_del(struct ocelot *ocelot,
+int ocelot_ace_rule_offload_del(struct ocelot *ocelot, int block_id,
 				struct ocelot_ace_rule *rule);
-int ocelot_ace_rule_stats_update(struct ocelot *ocelot,
+int ocelot_ace_rule_stats_update(struct ocelot *ocelot, int block_id,
 				 struct ocelot_ace_rule *rule);
 
 int ocelot_ace_init(struct ocelot *ocelot);
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 891925f73cbc..a1f7b6b28170 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -9,13 +9,26 @@
 
 #include "ocelot_ace.h"
 
+static int ocelot_block_id_get(int chain, bool ingress)
+{
+	/* Select TCAM blocks by using chain index. Rules in chain 0 are
+	 * implemented on IS1, chain 1 are implemented on IS2, and egress
+	 * chain corresponds to ES0 block.
+	 */
+	if (ingress)
+		return chain ? VCAP_IS2 : VCAP_IS1;
+	else
+		return VCAP_ES0;
+}
+
 static int ocelot_flower_parse_action(struct flow_cls_offload *f,
 				      struct ocelot_ace_rule *ace)
 {
+	struct netlink_ext_ack *extack = f->common.extack;
 	const struct flow_action_entry *a;
+	int i, allowed_chain = 0;
 	s64 burst;
 	u64 rate;
-	int i;
 
 	if (!flow_offload_has_one_action(&f->rule->action))
 		return -EOPNOTSUPP;
@@ -28,9 +41,11 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f,
 		switch (a->id) {
 		case FLOW_ACTION_DROP:
 			ace->action = OCELOT_ACL_ACTION_DROP;
+			allowed_chain = 1;
 			break;
 		case FLOW_ACTION_TRAP:
 			ace->action = OCELOT_ACL_ACTION_TRAP;
+			allowed_chain = 1;
 			break;
 		case FLOW_ACTION_POLICE:
 			ace->action = OCELOT_ACL_ACTION_POLICE;
@@ -38,10 +53,23 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f,
 			ace->pol.rate = div_u64(rate, 1000) * 8;
 			burst = rate * PSCHED_NS2TICKS(a->police.burst);
 			ace->pol.burst = div_u64(burst, PSCHED_TICKS_PER_SEC);
+			allowed_chain = 1;
+			break;
+		case FLOW_ACTION_GOTO:
+			if (a->chain_index != f->common.chain_index + 1) {
+				NL_SET_ERR_MSG_MOD(extack, "HW only support goto next chain\n");
+				return -EOPNOTSUPP;
+			}
+			ace->action = OCELOT_ACL_ACTION_NULL;
+			allowed_chain = f->common.chain_index;
 			break;
 		default:
 			return -EOPNOTSUPP;
 		}
+		if (f->common.chain_index != allowed_chain) {
+			NL_SET_ERR_MSG_MOD(extack, "Action is not supported on this chain\n");
+			return -EOPNOTSUPP;
+		}
 	}
 
 	return 0;
@@ -205,7 +233,7 @@ int ocelot_cls_flower_replace(struct ocelot *ocelot, int port,
 			      struct flow_cls_offload *f, bool ingress)
 {
 	struct ocelot_ace_rule *ace;
-	int ret;
+	int ret, block_id;
 
 	ace = ocelot_ace_rule_create(ocelot, port, f);
 	if (!ace)
@@ -216,8 +244,10 @@ int ocelot_cls_flower_replace(struct ocelot *ocelot, int port,
 		kfree(ace);
 		return ret;
 	}
+	block_id = ocelot_block_id_get(f->common.chain_index, ingress);
 
-	return ocelot_ace_rule_offload_add(ocelot, ace, f->common.extack);
+	return ocelot_ace_rule_offload_add(ocelot, block_id, ace,
+					   f->common.extack);
 }
 EXPORT_SYMBOL_GPL(ocelot_cls_flower_replace);
 
@@ -225,11 +255,13 @@ int ocelot_cls_flower_destroy(struct ocelot *ocelot, int port,
 			      struct flow_cls_offload *f, bool ingress)
 {
 	struct ocelot_ace_rule ace;
+	int block_id;
 
 	ace.prio = f->common.prio;
 	ace.id = f->cookie;
+	block_id = ocelot_block_id_get(f->common.chain_index, ingress);
 
-	return ocelot_ace_rule_offload_del(ocelot, &ace);
+	return ocelot_ace_rule_offload_del(ocelot, block_id, &ace);
 }
 EXPORT_SYMBOL_GPL(ocelot_cls_flower_destroy);
 
@@ -237,11 +269,13 @@ int ocelot_cls_flower_stats(struct ocelot *ocelot, int port,
 			    struct flow_cls_offload *f, bool ingress)
 {
 	struct ocelot_ace_rule ace;
-	int ret;
+	int ret, block_id;
 
 	ace.prio = f->common.prio;
 	ace.id = f->cookie;
-	ret = ocelot_ace_rule_stats_update(ocelot, &ace);
+	block_id = ocelot_block_id_get(f->common.chain_index, ingress);
+
+	ret = ocelot_ace_rule_stats_update(ocelot, block_id, &ace);
 	if (ret)
 		return ret;
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 91357b1c8f31..4b2320bdc036 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -540,7 +540,7 @@ struct ocelot {
 
 	struct list_head		multicast;
 
-	struct ocelot_acl_block		acl_block;
+	struct ocelot_acl_block		acl_block[3];
 
 	const struct vcap_props		*vcap;
 
diff --git a/include/soc/mscc/ocelot_vcap.h b/include/soc/mscc/ocelot_vcap.h
index 26d9384b3657..495847a40490 100644
--- a/include/soc/mscc/ocelot_vcap.h
+++ b/include/soc/mscc/ocelot_vcap.h
@@ -14,9 +14,9 @@
  */
 
 enum {
-	/* VCAP_IS1, */
+	VCAP_IS1,
 	VCAP_IS2,
-	/* VCAP_ES0, */
+	VCAP_ES0,
 };
 
 struct vcap_props {
-- 
2.17.1


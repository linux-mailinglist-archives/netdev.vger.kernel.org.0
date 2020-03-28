Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B22D8196626
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 13:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbgC1Ml3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 08:41:29 -0400
Received: from inva020.nxp.com ([92.121.34.13]:39448 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726225AbgC1Ml3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Mar 2020 08:41:29 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 54F8B1A1353;
        Sat, 28 Mar 2020 13:41:26 +0100 (CET)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 2D8961A1351;
        Sat, 28 Mar 2020 13:41:15 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 1FBEB402A5;
        Sat, 28 Mar 2020 20:41:02 +0800 (SGT)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     xiaoliang.yang_1@nxp.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        olteanv@gmail.com, ivan.khoronzhuk@linaro.org,
        horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, allan.nielsen@microchip.com,
        vivien.didelot@gmail.com, joergen.andreasen@microchip.com,
        UNGLinuxDriver@microchip.com, natechancellor@gmail.com,
        yuehaibing@huawei.com, maowenan@huawei.com, yangbo.lu@nxp.com,
        alexandru.marginean@nxp.com, po.liu@nxp.com,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com, leoyang.li@nxp.com
Subject: [net-next,v1] net: mscc: ocelot: add action of police on vcap_is2
Date:   Sat, 28 Mar 2020 20:37:39 +0800
Message-Id: <20200328123739.45247-1-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ocelot has 384 policers that can be allocated to ingress ports,
QoS classes per port, and VCAP IS2 entries. ocelot_police.c
supports to set policers which can be allocated to police action
of VCAP IS2. We allocate policers from maximum pol_id, and
decrease the pol_id when add a new vcap_is2 entry which is
police action.

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_ace.c    | 62 ++++++++++++++++++++---
 drivers/net/ethernet/mscc/ocelot_ace.h    |  4 ++
 drivers/net/ethernet/mscc/ocelot_flower.c |  9 ++++
 drivers/net/ethernet/mscc/ocelot_police.c | 24 +++++++++
 drivers/net/ethernet/mscc/ocelot_police.h |  5 ++
 include/soc/mscc/ocelot.h                 |  1 +
 6 files changed, 98 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_ace.c b/drivers/net/ethernet/mscc/ocelot_ace.c
index 906b54025b17..159490212f4b 100644
--- a/drivers/net/ethernet/mscc/ocelot_ace.c
+++ b/drivers/net/ethernet/mscc/ocelot_ace.c
@@ -7,6 +7,7 @@
 #include <linux/proc_fs.h>
 
 #include <soc/mscc/ocelot_vcap.h>
+#include "ocelot_police.h"
 #include "ocelot_ace.h"
 #include "ocelot_s2.h"
 
@@ -299,9 +300,9 @@ static void vcap_action_set(struct ocelot *ocelot, struct vcap_data *data,
 }
 
 static void is2_action_set(struct ocelot *ocelot, struct vcap_data *data,
-			   enum ocelot_ace_action action)
+			   struct ocelot_ace_rule *ace)
 {
-	switch (action) {
+	switch (ace->action) {
 	case OCELOT_ACL_ACTION_DROP:
 		vcap_action_set(ocelot, data, VCAP_IS2_ACT_PORT_MASK, 0);
 		vcap_action_set(ocelot, data, VCAP_IS2_ACT_MASK_MODE, 1);
@@ -319,6 +320,14 @@ static void is2_action_set(struct ocelot *ocelot, struct vcap_data *data,
 		vcap_action_set(ocelot, data, VCAP_IS2_ACT_CPU_QU_NUM, 0);
 		vcap_action_set(ocelot, data, VCAP_IS2_ACT_CPU_COPY_ENA, 1);
 		break;
+	case OCELOT_ACL_ACTION_POLICE:
+		vcap_action_set(ocelot, data, VCAP_IS2_ACT_PORT_MASK, 0);
+		vcap_action_set(ocelot, data, VCAP_IS2_ACT_MASK_MODE, 0);
+		vcap_action_set(ocelot, data, VCAP_IS2_ACT_POLICE_ENA, 1);
+		vcap_action_set(ocelot, data, VCAP_IS2_ACT_POLICE_IDX, ace->pol_ix);
+		vcap_action_set(ocelot, data, VCAP_IS2_ACT_CPU_QU_NUM, 0);
+		vcap_action_set(ocelot, data, VCAP_IS2_ACT_CPU_COPY_ENA, 0);
+		break;
 	}
 }
 
@@ -611,7 +620,7 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 	}
 
 	vcap_key_set(ocelot, &data, VCAP_IS2_TYPE, type, type_mask);
-	is2_action_set(ocelot, &data, ace->action);
+	is2_action_set(ocelot, &data, ace);
 	vcap_data_set(data.counter, data.counter_offset,
 		      vcap_is2->counter_width, ace->stats.pkts);
 
@@ -639,12 +648,19 @@ static void is2_entry_get(struct ocelot *ocelot, struct ocelot_ace_rule *rule,
 	rule->stats.pkts = cnt;
 }
 
-static void ocelot_ace_rule_add(struct ocelot_acl_block *block,
+static void ocelot_ace_rule_add(struct ocelot *ocelot,
+				struct ocelot_acl_block *block,
 				struct ocelot_ace_rule *rule)
 {
 	struct ocelot_ace_rule *tmp;
 	struct list_head *pos, *n;
 
+	if (rule->action == OCELOT_ACL_ACTION_POLICE) {
+		block->pol_lpr--;
+		rule->pol_ix = block->pol_lpr;
+		ocelot_ace_policer_add(ocelot, rule->pol_ix, &rule->pol);
+	}
+
 	block->count++;
 
 	if (list_empty(&block->rules)) {
@@ -697,7 +713,7 @@ int ocelot_ace_rule_offload_add(struct ocelot *ocelot,
 	int i, index;
 
 	/* Add rule to the linked list */
-	ocelot_ace_rule_add(block, rule);
+	ocelot_ace_rule_add(ocelot, block, rule);
 
 	/* Get the index of the inserted rule */
 	index = ocelot_ace_rule_get_index_id(block, rule);
@@ -713,7 +729,33 @@ int ocelot_ace_rule_offload_add(struct ocelot *ocelot,
 	return 0;
 }
 
-static void ocelot_ace_rule_del(struct ocelot_acl_block *block,
+static void ocelot_ace_police_del(struct ocelot *ocelot,
+				  struct ocelot_acl_block *block,
+				  u32 ix)
+{
+	struct ocelot_ace_rule *tmp;
+	int index = -1;
+
+	if (ix < block->pol_lpr)
+		return;
+
+	list_for_each_entry(tmp, &block->rules, list) {
+		index++;
+		if (tmp->action == OCELOT_ACL_ACTION_POLICE &&
+		    tmp->pol_ix < ix) {
+			tmp->pol_ix += 1;
+			ocelot_ace_policer_add(ocelot, tmp->pol_ix,
+					       &rule->pol);
+			is2_entry_set(ocelot, index, tmp);
+		}
+	}
+
+	ocelot_ace_policer_del(ocelot, block->pol_lpr);
+	block->pol_lpr++;
+}
+
+static void ocelot_ace_rule_del(struct ocelot *ocelot,
+				struct ocelot_acl_block *block,
 				struct ocelot_ace_rule *rule)
 {
 	struct ocelot_ace_rule *tmp;
@@ -722,6 +764,9 @@ static void ocelot_ace_rule_del(struct ocelot_acl_block *block,
 	list_for_each_safe(pos, q, &block->rules) {
 		tmp = list_entry(pos, struct ocelot_ace_rule, list);
 		if (tmp->id == rule->id) {
+			if (tmp->action == OCELOT_ACL_ACTION_POLICE)
+				ocelot_ace_police_del(ocelot, block, tmp->pol_ix);
+
 			list_del(pos);
 			kfree(tmp);
 		}
@@ -744,7 +789,7 @@ int ocelot_ace_rule_offload_del(struct ocelot *ocelot,
 	index = ocelot_ace_rule_get_index_id(block, rule);
 
 	/* Delete rule */
-	ocelot_ace_rule_del(block, rule);
+	ocelot_ace_rule_del(ocelot, block, rule);
 
 	/* Move up all the blocks over the deleted rule */
 	for (i = index; i < block->count; i++) {
@@ -779,6 +824,7 @@ int ocelot_ace_rule_stats_update(struct ocelot *ocelot,
 int ocelot_ace_init(struct ocelot *ocelot)
 {
 	const struct vcap_props *vcap_is2 = &ocelot->vcap[VCAP_IS2];
+	struct ocelot_acl_block *block = &ocelot->acl_block;
 	struct vcap_data data;
 
 	memset(&data, 0, sizeof(data));
@@ -807,6 +853,8 @@ int ocelot_ace_init(struct ocelot *ocelot)
 	ocelot_write_gix(ocelot, 0x3fffff, ANA_POL_CIR_STATE,
 			 OCELOT_POLICER_DISCARD);
 
+	block->pol_lpr = OCELOT_POLICER_DISCARD - 1;
+
 	INIT_LIST_HEAD(&ocelot->acl_block.rules);
 
 	return 0;
diff --git a/drivers/net/ethernet/mscc/ocelot_ace.h b/drivers/net/ethernet/mscc/ocelot_ace.h
index b9a5868e3f15..29d22c566786 100644
--- a/drivers/net/ethernet/mscc/ocelot_ace.h
+++ b/drivers/net/ethernet/mscc/ocelot_ace.h
@@ -7,6 +7,7 @@
 #define _MSCC_OCELOT_ACE_H_
 
 #include "ocelot.h"
+#include "ocelot_police.h"
 #include <net/sch_generic.h>
 #include <net/pkt_cls.h>
 
@@ -176,6 +177,7 @@ struct ocelot_ace_frame_ipv6 {
 enum ocelot_ace_action {
 	OCELOT_ACL_ACTION_DROP,
 	OCELOT_ACL_ACTION_TRAP,
+	OCELOT_ACL_ACTION_POLICE,
 };
 
 struct ocelot_ace_stats {
@@ -208,6 +210,8 @@ struct ocelot_ace_rule {
 		struct ocelot_ace_frame_ipv4 ipv4;
 		struct ocelot_ace_frame_ipv6 ipv6;
 	} frame;
+	struct ocelot_policer pol;
+	u32 pol_ix;
 };
 
 int ocelot_ace_rule_offload_add(struct ocelot *ocelot,
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 873a9944fbfb..1af7968ad598 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -12,6 +12,8 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f,
 				      struct ocelot_ace_rule *ace)
 {
 	const struct flow_action_entry *a;
+	s64 burst;
+	u64 rate;
 	int i;
 
 	if (!flow_offload_has_one_action(&f->rule->action))
@@ -29,6 +31,13 @@ static int ocelot_flower_parse_action(struct flow_cls_offload *f,
 		case FLOW_ACTION_TRAP:
 			ace->action = OCELOT_ACL_ACTION_TRAP;
 			break;
+		case FLOW_ACTION_POLICE:
+			ace->action = OCELOT_ACL_ACTION_POLICE;
+			rate = a->police.rate_bytes_ps;
+			ace->pol.rate = (u32)div_u64(rate, 1000) * 8;
+			burst = rate * PSCHED_NS2TICKS(a->police.burst);
+			ace->pol.burst = (u32)div_u64(burst, PSCHED_TICKS_PER_SEC);
+			break;
 		default:
 			return -EOPNOTSUPP;
 		}
diff --git a/drivers/net/ethernet/mscc/ocelot_police.c b/drivers/net/ethernet/mscc/ocelot_police.c
index faddce43f2e3..8d25b2706ff0 100644
--- a/drivers/net/ethernet/mscc/ocelot_police.c
+++ b/drivers/net/ethernet/mscc/ocelot_police.c
@@ -225,3 +225,27 @@ int ocelot_port_policer_del(struct ocelot *ocelot, int port)
 
 	return 0;
 }
+
+int ocelot_ace_policer_add(struct ocelot *ocelot, u32 pol_ix,
+			   struct ocelot_policer *pol)
+{
+	struct qos_policer_conf pp = { 0 };
+
+	if (!pol)
+		return -EINVAL;
+
+	pp.mode = MSCC_QOS_RATE_MODE_DATA;
+	pp.pir = pol->rate;
+	pp.pbs = pol->burst;
+
+	return qos_policer_conf_set(ocelot, 0, pol_ix, &pp);
+}
+
+int ocelot_ace_policer_del(struct ocelot *ocelot, u32 pol_ix)
+{
+	struct qos_policer_conf pp = { 0 };
+
+	pp.mode = MSCC_QOS_RATE_MODE_DISABLED;
+
+	return qos_policer_conf_set(ocelot, 0, pol_ix, &pp);
+}
diff --git a/drivers/net/ethernet/mscc/ocelot_police.h b/drivers/net/ethernet/mscc/ocelot_police.h
index ae9509229463..22025cce0a6a 100644
--- a/drivers/net/ethernet/mscc/ocelot_police.h
+++ b/drivers/net/ethernet/mscc/ocelot_police.h
@@ -19,4 +19,9 @@ int ocelot_port_policer_add(struct ocelot *ocelot, int port,
 
 int ocelot_port_policer_del(struct ocelot *ocelot, int port);
 
+int ocelot_ace_policer_add(struct ocelot *ocelot, u32 pol_ix,
+			   struct ocelot_policer *pol);
+
+int ocelot_ace_policer_del(struct ocelot *ocelot, u32 pol_ix);
+
 #endif /* _MSCC_OCELOT_POLICE_H_ */
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 007b584cc431..388504c94f6e 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -468,6 +468,7 @@ struct ocelot_ops {
 struct ocelot_acl_block {
 	struct list_head rules;
 	int count;
+	int pol_lpr;
 };
 
 struct ocelot_port {
-- 
2.17.1


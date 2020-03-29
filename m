Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2756196A73
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 01:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgC2AxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 20:53:07 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52709 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727798AbgC2AxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 20:53:07 -0400
Received: by mail-wm1-f65.google.com with SMTP id z18so15863156wmk.2;
        Sat, 28 Mar 2020 17:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7CA04DVcaRuu0cj4b04sNTiZpj7HfknAlMcPZ547YQ8=;
        b=hAnh2bZ24AmfAYadaUbNIK6BeLzdK2sS/ALX4dsyZJ7nTAkWdAGEgotrYg6fwG5BAi
         CZNFNU06FR+ERIranyzlbph/3wq/xOHKjlcCGaygzcbcfD24rc4xKG5gS2585p1Izhio
         aGMIBLUxrS54HOJOhn3ob6oaS+P5CAHD5FtAQ6dWK1VZi8tb6A83Jr4hhwpN9lAXkvtC
         /JUk6LKREIKiUKC2Eug4FXRSKrXmJ3jibMxue5I+DBzgBT0ZtwXTMgjR85awspXBKqth
         10yHYvwzENdbDb8cv+a+aM3D5oBPnbFspGFfQ8wNxw/tV49fY5xscHdKjMNwXnnQKX9B
         orvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7CA04DVcaRuu0cj4b04sNTiZpj7HfknAlMcPZ547YQ8=;
        b=AX3Eu/97jcsSed6NAaSe4GPwYi0lqzCgRHYPilXWwEbiY3WxlMwixuxhjznGoQ4+oH
         8kS9yjdw579ov1i0df47FHxcwuR+8dIQWDX0ar0KsirLf4gZwrkF6LB8h9b6brNzZG1m
         UZhzk/3+habXPoEcS80wmGtQrWs0cgI6N/ZkBx+kXMv/ITLOQQVkN5xBuxj1cNNF253G
         tJCa83xVXflclLITAnnGy53OjADLf3OVS7jjG8bAsBtN/i5eusGKQiD7Mu5lbJ2QlyM3
         u8OldM1V7rqbrtHD9jzE32MEaJ4yaNr+dZcB0+iqW04hxE1KfN6F3HqrFKGoHHS+KNNI
         g6zA==
X-Gm-Message-State: ANhLgQ3Pc6uQTsUYgNs1M21XqUB9mlozxFYX6wnSGMirgjZDT+sP0A4/
        a3jpF+J6ep3Vyu1F0v7dkOY=
X-Google-Smtp-Source: ADFU+vvX69NVivqG9nam8N535F+zoQzJUQpKzDJhEyFBFwGEBXVN0gEwPYJMinbcfi+2l+xyNr2AIA==
X-Received: by 2002:a1c:5641:: with SMTP id k62mr6317904wmb.82.1585443182642;
        Sat, 28 Mar 2020 17:53:02 -0700 (PDT)
Received: from localhost.localdomain (5-12-96-237.residential.rdsnet.ro. [5.12.96.237])
        by smtp.gmail.com with ESMTPSA id l1sm8292652wme.14.2020.03.28.17.53.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2020 17:53:02 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        netdev@vger.kernel.org, xiaoliang.yang_1@nxp.com,
        linux-kernel@vger.kernel.org, horatiu.vultur@microchip.com,
        alexandre.belloni@bootlin.com, allan.nielsen@microchip.com,
        joergen.andreasen@microchip.com, UNGLinuxDriver@microchip.com,
        yangbo.lu@nxp.com, alexandru.marginean@nxp.com, po.liu@nxp.com,
        claudiu.manoil@nxp.com, leoyang.li@nxp.com
Subject: [PATCH net-next 1/6] net: mscc: ocelot: add action of police on vcap_is2
Date:   Sun, 29 Mar 2020 02:51:57 +0200
Message-Id: <20200329005202.17926-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200329005202.17926-1-olteanv@gmail.com>
References: <20200329005202.17926-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>

Ocelot has 384 policers that can be allocated to ingress ports,
QoS classes per port, and VCAP IS2 entries. ocelot_police.c
supports to set policers which can be allocated to police action
of VCAP IS2. We allocate policers from maximum pol_id, and
decrease the pol_id when add a new vcap_is2 entry which is
police action.

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Patch taken from Xiaoliang's submission here:
https://patchwork.ozlabs.org/patch/1263213/
with the compilation error fixed.

 drivers/net/ethernet/mscc/ocelot_ace.c    | 64 ++++++++++++++++++++---
 drivers/net/ethernet/mscc/ocelot_ace.h    |  4 ++
 drivers/net/ethernet/mscc/ocelot_flower.c |  9 ++++
 drivers/net/ethernet/mscc/ocelot_police.c | 24 +++++++++
 drivers/net/ethernet/mscc/ocelot_police.h |  5 ++
 include/soc/mscc/ocelot.h                 |  1 +
 6 files changed, 100 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_ace.c b/drivers/net/ethernet/mscc/ocelot_ace.c
index 906b54025b17..3bd286044480 100644
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
@@ -319,6 +320,15 @@ static void is2_action_set(struct ocelot *ocelot, struct vcap_data *data,
 		vcap_action_set(ocelot, data, VCAP_IS2_ACT_CPU_QU_NUM, 0);
 		vcap_action_set(ocelot, data, VCAP_IS2_ACT_CPU_COPY_ENA, 1);
 		break;
+	case OCELOT_ACL_ACTION_POLICE:
+		vcap_action_set(ocelot, data, VCAP_IS2_ACT_PORT_MASK, 0);
+		vcap_action_set(ocelot, data, VCAP_IS2_ACT_MASK_MODE, 0);
+		vcap_action_set(ocelot, data, VCAP_IS2_ACT_POLICE_ENA, 1);
+		vcap_action_set(ocelot, data, VCAP_IS2_ACT_POLICE_IDX,
+				ace->pol_ix);
+		vcap_action_set(ocelot, data, VCAP_IS2_ACT_CPU_QU_NUM, 0);
+		vcap_action_set(ocelot, data, VCAP_IS2_ACT_CPU_COPY_ENA, 0);
+		break;
 	}
 }
 
@@ -611,7 +621,7 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 	}
 
 	vcap_key_set(ocelot, &data, VCAP_IS2_TYPE, type, type_mask);
-	is2_action_set(ocelot, &data, ace->action);
+	is2_action_set(ocelot, &data, ace);
 	vcap_data_set(data.counter, data.counter_offset,
 		      vcap_is2->counter_width, ace->stats.pkts);
 
@@ -639,12 +649,19 @@ static void is2_entry_get(struct ocelot *ocelot, struct ocelot_ace_rule *rule,
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
@@ -697,7 +714,7 @@ int ocelot_ace_rule_offload_add(struct ocelot *ocelot,
 	int i, index;
 
 	/* Add rule to the linked list */
-	ocelot_ace_rule_add(block, rule);
+	ocelot_ace_rule_add(ocelot, block, rule);
 
 	/* Get the index of the inserted rule */
 	index = ocelot_ace_rule_get_index_id(block, rule);
@@ -713,7 +730,33 @@ int ocelot_ace_rule_offload_add(struct ocelot *ocelot,
 	return 0;
 }
 
-static void ocelot_ace_rule_del(struct ocelot_acl_block *block,
+static void ocelot_ace_police_del(struct ocelot *ocelot,
+				  struct ocelot_acl_block *block,
+				  u32 ix)
+{
+	struct ocelot_ace_rule *ace;
+	int index = -1;
+
+	if (ix < block->pol_lpr)
+		return;
+
+	list_for_each_entry(ace, &block->rules, list) {
+		index++;
+		if (ace->action == OCELOT_ACL_ACTION_POLICE &&
+		    ace->pol_ix < ix) {
+			ace->pol_ix += 1;
+			ocelot_ace_policer_add(ocelot, ace->pol_ix,
+					       &ace->pol);
+			is2_entry_set(ocelot, index, ace);
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
@@ -722,6 +765,10 @@ static void ocelot_ace_rule_del(struct ocelot_acl_block *block,
 	list_for_each_safe(pos, q, &block->rules) {
 		tmp = list_entry(pos, struct ocelot_ace_rule, list);
 		if (tmp->id == rule->id) {
+			if (tmp->action == OCELOT_ACL_ACTION_POLICE)
+				ocelot_ace_police_del(ocelot, block,
+						      tmp->pol_ix);
+
 			list_del(pos);
 			kfree(tmp);
 		}
@@ -744,7 +791,7 @@ int ocelot_ace_rule_offload_del(struct ocelot *ocelot,
 	index = ocelot_ace_rule_get_index_id(block, rule);
 
 	/* Delete rule */
-	ocelot_ace_rule_del(block, rule);
+	ocelot_ace_rule_del(ocelot, block, rule);
 
 	/* Move up all the blocks over the deleted rule */
 	for (i = index; i < block->count; i++) {
@@ -779,6 +826,7 @@ int ocelot_ace_rule_stats_update(struct ocelot *ocelot,
 int ocelot_ace_init(struct ocelot *ocelot)
 {
 	const struct vcap_props *vcap_is2 = &ocelot->vcap[VCAP_IS2];
+	struct ocelot_acl_block *block = &ocelot->acl_block;
 	struct vcap_data data;
 
 	memset(&data, 0, sizeof(data));
@@ -807,6 +855,8 @@ int ocelot_ace_init(struct ocelot *ocelot)
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
index 6cbca9b05520..bf0b04775dda 100644
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
+			ace->pol.rate = div_u64(rate, 1000) * 8;
+			burst = rate * PSCHED_NS2TICKS(a->police.burst);
+			ace->pol.burst = div_u64(burst, PSCHED_TICKS_PER_SEC);
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
index 23a78d927838..3db66638a3b2 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -473,6 +473,7 @@ struct ocelot_ops {
 struct ocelot_acl_block {
 	struct list_head rules;
 	int count;
+	int pol_lpr;
 };
 
 struct ocelot_port {
-- 
2.17.1


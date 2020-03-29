Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 830D9196D26
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 13:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbgC2LwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 07:52:21 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41549 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728056AbgC2LwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 07:52:20 -0400
Received: by mail-wr1-f65.google.com with SMTP id h9so17476222wrc.8;
        Sun, 29 Mar 2020 04:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kUBMJMW80WjF8u2cn5wtF1dHQOpS3M219W+AflDnPXk=;
        b=I0AIGwvza0v5WghcKzpYlmtVVlykp5CDqLaxgAybhu6eMHOLyEZndZTFQm1zbTN0UQ
         52aqGmYd8nL6YUhFAPSL4pW6HLNta0wyNXr2svuQWj9BbwWMUJgauiC5IOfXQH5R4arh
         nSjP3xgdZQfI+y9D6pC3F0ji57JShv2gq7I6JyFlkGdlDFb3e1o1YNg8hO2geLx7ZLxg
         hc7+ObbFU1CIp7yFzKkSXaMzbMZOaiscpL3ZK70x7Mk18V1nycShgiz4hsPeuvFFmTIH
         prDogzmE3J0Vo6ZyAflaEKGORWm53Y+kx70RljhKjcaF6V77kGckPQ7iZ7Wd8aW8d7iN
         1n5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kUBMJMW80WjF8u2cn5wtF1dHQOpS3M219W+AflDnPXk=;
        b=mnq4mcUmzm5+7UXkK74dsO5qpjfcwlO5bqFDspaFt5pGktUDMZvrx/zvDlspMIPpfz
         onTLq1Fg30KXiDekcro14kPBag+wbBI/ZLnY6nrUigVm5WsuhbwgVT8G0k4gZyim/1YI
         MLywI386FDsje1CrR4d8qrGxIItSZeS2pdPuCe0cYPMGC9w71QaagkB8Kv3q0CLEL3JR
         PhqfTK3AM2xnTVhEz5D7CbYTVe2ecWwToqPk/MDoA0ZXGBGgX94WiokyMFJLDwaBMwg+
         55itmd7UsXjFUO8MGRmonfO/y/nd0CbJyS5Abuy4dzzUegDJXRtdJG4t7z0IafaGcE5C
         0haw==
X-Gm-Message-State: ANhLgQ3TyBFWiU1IoOlUY7D5qzWLm43/uUwa9sAeV7Wx2YUI+PWSIrYw
        LgWJZJb1k51RfQMabPEDj+c=
X-Google-Smtp-Source: ADFU+vuDkfNq9WAK3B13vj3BLY5x5XH7aKBvK3C5LgXfymNiO1q7VL6Q6JhSI/D4R7wshXQkL7H0Tg==
X-Received: by 2002:a5d:460e:: with SMTP id t14mr9499886wrq.421.1585482737415;
        Sun, 29 Mar 2020 04:52:17 -0700 (PDT)
Received: from localhost.localdomain (5-12-96-237.residential.rdsnet.ro. [5.12.96.237])
        by smtp.gmail.com with ESMTPSA id 5sm14424108wrs.20.2020.03.29.04.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2020 04:52:16 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        netdev@vger.kernel.org, xiaoliang.yang_1@nxp.com,
        linux-kernel@vger.kernel.org, horatiu.vultur@microchip.com,
        alexandre.belloni@bootlin.com, allan.nielsen@microchip.com,
        joergen.andreasen@microchip.com, UNGLinuxDriver@microchip.com,
        yangbo.lu@nxp.com, alexandru.marginean@nxp.com, po.liu@nxp.com,
        claudiu.manoil@nxp.com, leoyang.li@nxp.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com
Subject: [PATCH v2 net-next 1/6] net: mscc: ocelot: add action of police on vcap_is2
Date:   Sun, 29 Mar 2020 14:51:57 +0300
Message-Id: <20200329115202.16348-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200329115202.16348-1-olteanv@gmail.com>
References: <20200329115202.16348-1-olteanv@gmail.com>
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
Changes in v2:
None.

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
index 873a9944fbfb..fb1abeca73b4 100644
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
index eadbc2ddfcb5..b5d61af9f743 100644
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65D11687A92
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 11:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232848AbjBBKpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 05:45:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232766AbjBBKpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 05:45:08 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E651089377;
        Thu,  2 Feb 2023 02:45:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675334702; x=1706870702;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0gVXlhkmgNS7VQV9qyN41NeNXauEIasDtyBiM8Dy+WM=;
  b=HI4YZLc3jcF+zoVOl2otzDWJonp3ci7U6RKSjQz9zyrqvj1lOmSFzKbc
   B7/0eaV+tdTgpA8xq33MBskUtBkafgdNjQE6DL1V/Xse60FGDtXJUlygP
   9AyTH78PmixjUhKAzLVbUDUPBBc3QxeLNedaKDBeWy0No+G1q7ijFMZGU
   iBDg/M9PIf4KsvfbZ8C/5lTjc5CCf2P0BRECfoRczRPoEMDraHIWdPvYU
   mwSqoCzBMXzXkX7Cx/lDs8ZcAGEdo1byf5pjPWyhfwy9n5sEZ8qeZZFrg
   5iK2gdeWh6XzRruXnzgv2xAhT2MSqvr4Z4Cm2BBGaL/AeFt2US7QUu2LL
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,267,1669100400"; 
   d="scan'208";a="195044170"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Feb 2023 03:45:01 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 03:44:56 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Thu, 2 Feb 2023 03:44:53 -0700
From:   Daniel Machon <daniel.machon@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <richardcochran@gmail.com>, <casper.casan@gmail.com>,
        <horatiu.vultur@microchip.com>, <shangxiaojing@huawei.com>,
        <rmk+kernel@armlinux.org.uk>, <nhuck@google.com>,
        <error27@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH net-next 10/10] sparx5: add support for configuring PSFP via tc
Date:   Thu, 2 Feb 2023 11:43:55 +0100
Message-ID: <20230202104355.1612823-11-daniel.machon@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230202104355.1612823-1-daniel.machon@microchip.com>
References: <20230202104355.1612823-1-daniel.machon@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for tc actions gate and police, in order to implement
support for configuring PSFP through tc.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 .../microchip/sparx5/sparx5_tc_flower.c       | 237 +++++++++++++++++-
 .../net/ethernet/microchip/vcap/vcap_api.c    |   3 +-
 .../ethernet/microchip/vcap/vcap_api_client.h |   3 +
 3 files changed, 240 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
index 217ff127e3c7..f962304272c2 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
@@ -4,6 +4,7 @@
  * Copyright (c) 2022 Microchip Technology Inc. and its subsidiaries.
  */
 
+#include <net/tc_act/tc_gate.h>
 #include <net/tcp.h>
 
 #include "sparx5_tc.h"
@@ -989,19 +990,156 @@ static int sparx5_tc_add_rule_link(struct vcap_control *vctrl,
 	return err;
 }
 
+static int sparx5_tc_flower_parse_act_gate(struct sparx5_psfp_sg *sg,
+					   struct flow_action_entry *act,
+					   struct netlink_ext_ack *extack)
+{
+	int i;
+
+	if (act->gate.prio < -1 || act->gate.prio > SPX5_PSFP_SG_MAX_IPV) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid gate priority");
+		return -EINVAL;
+	}
+
+	if (act->gate.cycletime < SPX5_PSFP_SG_MIN_CYCLE_TIME_NS ||
+	    act->gate.cycletime > SPX5_PSFP_SG_MAX_CYCLE_TIME_NS) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid gate cycletime");
+		return -EINVAL;
+	}
+
+	if (act->gate.cycletimeext > SPX5_PSFP_SG_MAX_CYCLE_TIME_NS) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid gate cycletimeext");
+		return -EINVAL;
+	}
+
+	if (act->gate.num_entries >= SPX5_PSFP_GCE_CNT) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid number of gate entries");
+		return -EINVAL;
+	}
+
+	sg->gate_state = true;
+	sg->ipv = act->gate.prio;
+	sg->num_entries = act->gate.num_entries;
+	sg->cycletime = act->gate.cycletime;
+	sg->cycletimeext = act->gate.cycletimeext;
+
+	for (i = 0; i < sg->num_entries; i++) {
+		sg->gce[i].gate_state = !!act->gate.entries[i].gate_state;
+		sg->gce[i].interval = act->gate.entries[i].interval;
+		sg->gce[i].ipv = act->gate.entries[i].ipv;
+		sg->gce[i].maxoctets = act->gate.entries[i].maxoctets;
+	}
+
+	return 0;
+}
+
+static int sparx5_tc_flower_parse_act_police(struct sparx5_policer *pol,
+					     struct flow_action_entry *act,
+					     struct netlink_ext_ack *extack)
+{
+	pol->type = SPX5_POL_SERVICE;
+	pol->rate = div_u64(act->police.rate_bytes_ps, 1000) * 8;
+	pol->burst = act->police.burst;
+	pol->idx = act->hw_index;
+
+	/* rate is now in kbit */
+	if (pol->rate > DIV_ROUND_UP(SPX5_SDLB_GROUP_RATE_MAX, 1000)) {
+		NL_SET_ERR_MSG_MOD(extack, "Maximum rate exceeded");
+		return -EINVAL;
+	}
+
+	if (act->police.exceed.act_id != FLOW_ACTION_DROP) {
+		NL_SET_ERR_MSG_MOD(extack, "Offload not supported when exceed action is not drop");
+		return -EOPNOTSUPP;
+	}
+
+	if (act->police.notexceed.act_id != FLOW_ACTION_PIPE &&
+	    act->police.notexceed.act_id != FLOW_ACTION_ACCEPT) {
+		NL_SET_ERR_MSG_MOD(extack, "Offload not supported when conform action is not pipe or ok");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int sparx5_tc_flower_psfp_setup(struct sparx5 *sparx5,
+				       struct vcap_rule *vrule, int sg_idx,
+				       int pol_idx, struct sparx5_psfp_sg *sg,
+				       struct sparx5_psfp_fm *fm,
+				       struct sparx5_psfp_sf *sf)
+{
+	u32 psfp_sfid = 0, psfp_fmid = 0, psfp_sgid = 0;
+	int ret;
+
+	/* Must always have a stream gate - max sdu (filter option) is evaluated
+	 * after frames have passed the gate, so in case of only a policer, we
+	 * allocate a stream gate that is always open.
+	 */
+	if (sg_idx < 0) {
+		sg_idx = sparx5_pool_idx_to_id(SPX5_PSFP_SG_OPEN);
+		sg->ipv = 0; /* Disabled */
+		sg->cycletime = SPX5_PSFP_SG_CYCLE_TIME_DEFAULT;
+		sg->num_entries = 1;
+		sg->gate_state = 1; /* Open */
+		sg->gate_enabled = 1;
+		sg->gce[0].gate_state = 1;
+		sg->gce[0].interval = SPX5_PSFP_SG_CYCLE_TIME_DEFAULT;
+		sg->gce[0].ipv = 0;
+		sg->gce[0].maxoctets = 0; /* Disabled */
+	}
+
+	ret = sparx5_psfp_sg_add(sparx5, sg_idx, sg, &psfp_sgid);
+	if (ret < 0)
+		return ret;
+
+	if (pol_idx >= 0) {
+		/* Add new flow-meter */
+		ret = sparx5_psfp_fm_add(sparx5, pol_idx, fm, &psfp_fmid);
+		if (ret < 0)
+			return ret;
+	}
+
+	/* Map stream filter to stream gate */
+	sf->sgid = psfp_sgid;
+
+	/* Add new stream-filter and map it to a steam gate */
+	ret = sparx5_psfp_sf_add(sparx5, sf, &psfp_sfid);
+	if (ret < 0)
+		return ret;
+
+	/* Streams are classified by ISDX - map ISDX 1:1 to sfid for now. */
+	sparx5_isdx_conf_set(sparx5, psfp_sfid, psfp_sfid, psfp_fmid);
+
+	ret = vcap_rule_add_action_bit(vrule, VCAP_AF_ISDX_ADD_REPLACE_SEL,
+				       VCAP_BIT_1);
+	if (ret)
+		return ret;
+
+	ret = vcap_rule_add_action_u32(vrule, VCAP_AF_ISDX_VAL, psfp_sfid);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 static int sparx5_tc_flower_replace(struct net_device *ndev,
 				    struct flow_cls_offload *fco,
 				    struct vcap_admin *admin,
 				    bool ingress)
 {
+	struct sparx5_psfp_sf sf = { .max_sdu = SPX5_PSFP_SF_MAX_SDU };
+	struct netlink_ext_ack *extack = fco->common.extack;
+	int err, idx, tc_sg_idx = -1, tc_pol_idx = -1;
 	struct sparx5_port *port = netdev_priv(ndev);
 	struct sparx5_multiple_rules multi = {};
+	struct sparx5 *sparx5 = port->sparx5;
+	struct sparx5_psfp_sg sg = { 0 };
+	struct sparx5_psfp_fm fm = { 0 };
 	struct flow_action_entry *act;
 	struct vcap_control *vctrl;
 	struct flow_rule *frule;
 	struct vcap_rule *vrule;
 	u16 l3_proto;
-	int err, idx;
 
 	vctrl = port->sparx5->vcap_ctrl;
 
@@ -1033,6 +1171,26 @@ static int sparx5_tc_flower_replace(struct net_device *ndev,
 	frule = flow_cls_offload_flow_rule(fco);
 	flow_action_for_each(idx, act, &frule->action) {
 		switch (act->id) {
+		case FLOW_ACTION_GATE: {
+			err = sparx5_tc_flower_parse_act_gate(&sg, act, extack);
+			if (err < 0)
+				goto out;
+
+			tc_sg_idx = act->hw_index;
+
+			break;
+		}
+		case FLOW_ACTION_POLICE: {
+			err = sparx5_tc_flower_parse_act_police(&fm.pol, act,
+								extack);
+			if (err < 0)
+				goto out;
+
+			tc_pol_idx = fm.pol.idx;
+			sf.max_sdu = act->police.mtu;
+
+			break;
+		}
 		case FLOW_ACTION_TRAP:
 			if (admin->vtype != VCAP_TYPE_IS2 &&
 			    admin->vtype != VCAP_TYPE_ES2) {
@@ -1079,6 +1237,14 @@ static int sparx5_tc_flower_replace(struct net_device *ndev,
 		}
 	}
 
+	/* Setup PSFP */
+	if (tc_sg_idx >= 0 || tc_pol_idx >= 0) {
+		err = sparx5_tc_flower_psfp_setup(sparx5, vrule, tc_sg_idx,
+						  tc_pol_idx, &sg, &fm, &sf);
+		if (err)
+			goto out;
+	}
+
 	err = sparx5_tc_select_protocol_keyset(ndev, vrule, admin, l3_proto,
 					       &multi);
 	if (err) {
@@ -1107,19 +1273,86 @@ static int sparx5_tc_flower_replace(struct net_device *ndev,
 	return err;
 }
 
+static void sparx5_tc_free_psfp_resources(struct sparx5 *sparx5,
+					  struct vcap_rule *vrule)
+{
+	struct vcap_client_actionfield *afield;
+	u32 isdx, sfid, sgid, fmid;
+
+	/* Check if VCAP_AF_ISDX_VAL action is set for this rule - and if
+	 * it is used for stream and/or flow-meter classification.
+	 */
+	afield = vcap_find_actionfield(vrule, VCAP_AF_ISDX_VAL);
+	if (!afield)
+		return;
+
+	isdx = afield->data.u32.value;
+	sfid = sparx5_psfp_isdx_get_sf(sparx5, isdx);
+
+	if (!sfid)
+		return;
+
+	fmid = sparx5_psfp_isdx_get_fm(sparx5, isdx);
+	sgid = sparx5_psfp_sf_get_sg(sparx5, sfid);
+
+	if (fmid && sparx5_psfp_fm_del(sparx5, fmid) < 0)
+		pr_err("%s:%d Could not delete invalid fmid: %d", __func__,
+		       __LINE__, fmid);
+
+	if (sgid && sparx5_psfp_sg_del(sparx5, sgid) < 0)
+		pr_err("%s:%d Could not delete invalid sgid: %d", __func__,
+		       __LINE__, sgid);
+
+	if (sparx5_psfp_sf_del(sparx5, sfid) < 0)
+		pr_err("%s:%d Could not delete invalid sfid: %d", __func__,
+		       __LINE__, sfid);
+
+	sparx5_isdx_conf_set(sparx5, isdx, 0, 0);
+}
+
+static int sparx5_tc_free_rule_resources(struct net_device *ndev,
+					 struct vcap_control *vctrl,
+					 int rule_id)
+{
+	struct sparx5_port *port = netdev_priv(ndev);
+	struct sparx5 *sparx5 = port->sparx5;
+	struct vcap_rule *vrule;
+	int ret = 0;
+
+	vrule = vcap_get_rule(vctrl, rule_id);
+	if (!vrule || IS_ERR(vrule))
+		return -EINVAL;
+
+	sparx5_tc_free_psfp_resources(sparx5, vrule);
+
+	vcap_free_rule(vrule);
+	return ret;
+}
+
 static int sparx5_tc_flower_destroy(struct net_device *ndev,
 				    struct flow_cls_offload *fco,
 				    struct vcap_admin *admin)
 {
 	struct sparx5_port *port = netdev_priv(ndev);
+	int err = -ENOENT, count = 0, rule_id;
 	struct vcap_control *vctrl;
-	int err = -ENOENT, rule_id;
 
 	vctrl = port->sparx5->vcap_ctrl;
 	while (true) {
 		rule_id = vcap_lookup_rule_by_cookie(vctrl, fco->cookie);
 		if (rule_id <= 0)
 			break;
+		if (count == 0) {
+			/* Resources are attached to the first rule of
+			 * a set of rules. Only works if the rules are
+			 * in the correct order.
+			 */
+			err = sparx5_tc_free_rule_resources(ndev, vctrl,
+							    rule_id);
+			if (err)
+				pr_err("%s:%d: could not free resources %d\n",
+				       __func__, __LINE__, rule_id);
+		}
 		err = vcap_del_rule(vctrl, ndev, rule_id);
 		if (err) {
 			pr_err("%s:%d: could not delete rule %d\n",
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index 660d7cd92fcc..6307d59f23da 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -2755,7 +2755,7 @@ int vcap_rule_get_key_u32(struct vcap_rule *rule, enum vcap_key_field key,
 EXPORT_SYMBOL_GPL(vcap_rule_get_key_u32);
 
 /* Find a client action field in a rule */
-static struct vcap_client_actionfield *
+struct vcap_client_actionfield *
 vcap_find_actionfield(struct vcap_rule *rule, enum vcap_action_field act)
 {
 	struct vcap_rule_internal *ri = (struct vcap_rule_internal *)rule;
@@ -2766,6 +2766,7 @@ vcap_find_actionfield(struct vcap_rule *rule, enum vcap_action_field act)
 			return caf;
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(vcap_find_actionfield);
 
 /* Check if the actionfield is already in the rule */
 static bool vcap_actionfield_unique(struct vcap_rule *rule,
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
index de29540fd190..417af9754bcc 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
@@ -268,4 +268,7 @@ int vcap_rule_mod_action_u32(struct vcap_rule *rule,
 /* Get a 32 bit key field value and mask from the rule */
 int vcap_rule_get_key_u32(struct vcap_rule *rule, enum vcap_key_field key,
 			  u32 *value, u32 *mask);
+
+struct vcap_client_actionfield *
+vcap_find_actionfield(struct vcap_rule *rule, enum vcap_action_field act);
 #endif /* __VCAP_API_CLIENT__ */
-- 
2.34.1


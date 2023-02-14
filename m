Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EAB869612E
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 11:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232729AbjBNKmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 05:42:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232753AbjBNKls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 05:41:48 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE5625E35;
        Tue, 14 Feb 2023 02:41:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676371295; x=1707907295;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+2QqiZfC3dvFtIOypbNgB+sgQ25PurQZJAl0r83TM3A=;
  b=ihK6Qds6VUgw//tHVUjOi/IcMz+LubrUV0eHfmhjaYVkj3Zy5QNBbZ08
   vuhH7+ndEZ2IBOJKFmlRCi53+zpRxIMCG9P1WTYjBfA+LeA91wyq0HDrd
   o3NiplyJC4r0xccYMfECe8Cz4FlcDgCP9EScXcfD+UNJ4ZprR9v8THXIA
   pHXNhc7Zo8DnpuhZMABBZProqSNQbKjEjNpyPNuwQ9eMT1Yi/FnV+sgyb
   ArVF1iRFVZZidtGdBiESBnfQjWjqkdeiq7EKI3x/Bsy92GGJAsB9vbtpn
   hexs4nxPFni68vmsbbgxdY3AIXuhWznqrfEv1Tmqz1fIaZqDpPI6+o5te
   A==;
X-IronPort-AV: E=Sophos;i="5.97,296,1669100400"; 
   d="scan'208";a="200417875"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Feb 2023 03:41:35 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 03:41:34 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 03:41:30 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Casper Andersson" <casper.casan@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        "Nathan Huckleberry" <nhuck@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Steen Hegelund" <Steen.Hegelund@microchip.com>,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Dan Carpenter <error27@gmail.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v2 10/10] net: microchip: sparx5: Add TC vlan action support for the ES0 VCAP
Date:   Tue, 14 Feb 2023 11:40:49 +0100
Message-ID: <20230214104049.1553059-11-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230214104049.1553059-1-steen.hegelund@microchip.com>
References: <20230214104049.1553059-1-steen.hegelund@microchip.com>
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

This provides these 3 actions for rule in the ES0 VCAP:

- action vlan pop
- action vlan modify id X priority Y
- action vlan push id X priority Y protocol Z

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../net/ethernet/microchip/sparx5/sparx5_tc.h |  66 +++++
 .../microchip/sparx5/sparx5_tc_flower.c       | 266 ++++++++++++++++--
 .../microchip/sparx5/sparx5_vcap_impl.c       |   3 +
 .../microchip/sparx5/sparx5_vcap_impl.h       |  12 +
 drivers/net/ethernet/microchip/vcap/vcap_tc.c |   3 +
 drivers/net/ethernet/microchip/vcap/vcap_tc.h |   1 +
 6 files changed, 327 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc.h b/drivers/net/ethernet/microchip/sparx5/sparx5_tc.h
index 01273db708ac..7ef470b28566 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc.h
@@ -29,6 +29,72 @@ enum SPX5_FORWARDING_SEL {
 	SPX5_FWSEL_DISCARD,
 };
 
+/* Controls tag A (outer tagging) */
+enum SPX5_OUTER_TAG_SEL {
+	SPX5_OTAG_PORT,
+	SPX5_OTAG_TAG_A,
+	SPX5_OTAG_FORCED_PORT,
+	SPX5_OTAG_UNTAG,
+};
+
+/* Selects TPID for ES0 tag A */
+enum SPX5_TPID_A_SEL {
+	SPX5_TPID_A_8100,
+	SPX5_TPID_A_88A8,
+	SPX5_TPID_A_CUST1,
+	SPX5_TPID_A_CUST2,
+	SPX5_TPID_A_CUST3,
+	SPX5_TPID_A_CLASSIFIED,
+};
+
+/* Selects VID for ES0 tag A */
+enum SPX5_VID_A_SEL {
+	SPX5_VID_A_CLASSIFIED,
+	SPX5_VID_A_VAL,
+	SPX5_VID_A_IFH,
+	SPX5_VID_A_RESERVED,
+};
+
+/* Select PCP source for ES0 tag A */
+enum SPX5_PCP_A_SEL {
+	SPX5_PCP_A_CLASSIFIED,
+	SPX5_PCP_A_VAL,
+	SPX5_PCP_A_RESERVED,
+	SPX5_PCP_A_POPPED,
+	SPX5_PCP_A_MAPPED_0,
+	SPX5_PCP_A_MAPPED_1,
+	SPX5_PCP_A_MAPPED_2,
+	SPX5_PCP_A_MAPPED_3,
+};
+
+/* Select DEI source for ES0 tag A */
+enum SPX5_DEI_A_SEL {
+	SPX5_DEI_A_CLASSIFIED,
+	SPX5_DEI_A_VAL,
+	SPX5_DEI_A_REW,
+	SPX5_DEI_A_POPPED,
+	SPX5_DEI_A_MAPPED_0,
+	SPX5_DEI_A_MAPPED_1,
+	SPX5_DEI_A_MAPPED_2,
+	SPX5_DEI_A_MAPPED_3,
+};
+
+/* Controls tag B (inner tagging) */
+enum SPX5_INNER_TAG_SEL {
+	SPX5_ITAG_NO_PUSH,
+	SPX5_ITAG_PUSH_B_TAG,
+};
+
+/* Selects TPID for ES0 tag B. */
+enum SPX5_TPID_B_SEL {
+	SPX5_TPID_B_8100,
+	SPX5_TPID_B_88A8,
+	SPX5_TPID_B_CUST1,
+	SPX5_TPID_B_CUST2,
+	SPX5_TPID_B_CUST3,
+	SPX5_TPID_B_CLASSIFIED,
+};
+
 int sparx5_port_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 			 void *type_data);
 
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
index 67b49ad6a8f9..b36819aafaca 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
@@ -28,6 +28,31 @@ struct sparx5_multiple_rules {
 	struct sparx5_wildcard_rule rule[SPX5_MAX_RULE_SIZE];
 };
 
+static int
+sparx5_tc_flower_es0_tpid(struct vcap_tc_flower_parse_usage *st)
+{
+	int err = 0;
+
+	switch (st->tpid) {
+	case ETH_P_8021Q:
+		err = vcap_rule_add_key_u32(st->vrule,
+					    VCAP_KF_8021Q_TPID,
+					    SPX5_TPID_SEL_8100, ~0);
+		break;
+	case ETH_P_8021AD:
+		err = vcap_rule_add_key_u32(st->vrule,
+					    VCAP_KF_8021Q_TPID,
+					    SPX5_TPID_SEL_88A8, ~0);
+		break;
+	default:
+		NL_SET_ERR_MSG_MOD(st->fco->common.extack,
+				   "Invalid vlan proto");
+		err = -EINVAL;
+		break;
+	}
+	return err;
+}
+
 static int
 sparx5_tc_flower_handler_basic_usage(struct vcap_tc_flower_parse_usage *st)
 {
@@ -168,13 +193,21 @@ sparx5_tc_flower_handler_vlan_usage(struct vcap_tc_flower_parse_usage *st)
 {
 	enum vcap_key_field vid_key = VCAP_KF_8021Q_VID_CLS;
 	enum vcap_key_field pcp_key = VCAP_KF_8021Q_PCP_CLS;
+	int err;
 
 	if (st->admin->vtype == VCAP_TYPE_IS0) {
 		vid_key = VCAP_KF_8021Q_VID0;
 		pcp_key = VCAP_KF_8021Q_PCP0;
 	}
 
-	return vcap_tc_flower_handler_vlan_usage(st, vid_key, pcp_key);
+	err = vcap_tc_flower_handler_vlan_usage(st, vid_key, pcp_key);
+	if (err)
+		return err;
+
+	if (st->admin->vtype == VCAP_TYPE_ES0 && st->tpid)
+		err = sparx5_tc_flower_es0_tpid(st);
+
+	return err;
 }
 
 static int (*sparx5_tc_flower_usage_handlers[])(struct vcap_tc_flower_parse_usage *st) = {
@@ -191,38 +224,28 @@ static int (*sparx5_tc_flower_usage_handlers[])(struct vcap_tc_flower_parse_usag
 	[FLOW_DISSECTOR_KEY_IP] = vcap_tc_flower_handler_ip_usage,
 };
 
-static int sparx5_tc_use_dissectors(struct flow_cls_offload *fco,
+static int sparx5_tc_use_dissectors(struct vcap_tc_flower_parse_usage *st,
 				    struct vcap_admin *admin,
-				    struct vcap_rule *vrule,
-				    u16 *l3_proto)
+				    struct vcap_rule *vrule)
 {
-	struct vcap_tc_flower_parse_usage state = {
-		.fco = fco,
-		.vrule = vrule,
-		.l3_proto = ETH_P_ALL,
-		.admin = admin,
-	};
 	int idx, err = 0;
 
-	state.frule = flow_cls_offload_flow_rule(fco);
 	for (idx = 0; idx < ARRAY_SIZE(sparx5_tc_flower_usage_handlers); ++idx) {
-		if (!flow_rule_match_key(state.frule, idx))
+		if (!flow_rule_match_key(st->frule, idx))
 			continue;
 		if (!sparx5_tc_flower_usage_handlers[idx])
 			continue;
-		err = sparx5_tc_flower_usage_handlers[idx](&state);
+		err = sparx5_tc_flower_usage_handlers[idx](st);
 		if (err)
 			return err;
 	}
 
-	if (state.frule->match.dissector->used_keys ^ state.used_keys) {
-		NL_SET_ERR_MSG_MOD(fco->common.extack,
+	if (st->frule->match.dissector->used_keys ^ st->used_keys) {
+		NL_SET_ERR_MSG_MOD(st->fco->common.extack,
 				   "Unsupported match item");
 		return -ENOENT;
 	}
 
-	if (l3_proto)
-		*l3_proto = state.l3_proto;
 	return err;
 }
 
@@ -281,6 +304,27 @@ static int sparx5_tc_flower_action_check(struct vcap_control *vctrl,
 		return -EOPNOTSUPP;
 	}
 
+	if (action_mask & BIT(FLOW_ACTION_VLAN_PUSH) &&
+	    action_mask & BIT(FLOW_ACTION_VLAN_POP)) {
+		NL_SET_ERR_MSG_MOD(fco->common.extack,
+				   "Cannot combine vlan push and pop action");
+		return -EOPNOTSUPP;
+	}
+
+	if (action_mask & BIT(FLOW_ACTION_VLAN_PUSH) &&
+	    action_mask & BIT(FLOW_ACTION_VLAN_MANGLE)) {
+		NL_SET_ERR_MSG_MOD(fco->common.extack,
+				   "Cannot combine vlan push and modify action");
+		return -EOPNOTSUPP;
+	}
+
+	if (action_mask & BIT(FLOW_ACTION_VLAN_POP) &&
+	    action_mask & BIT(FLOW_ACTION_VLAN_MANGLE)) {
+		NL_SET_ERR_MSG_MOD(fco->common.extack,
+				   "Cannot combine vlan pop and modify action");
+		return -EOPNOTSUPP;
+	}
+
 	return 0;
 }
 
@@ -801,6 +845,157 @@ static int sparx5_tc_action_trap(struct vcap_admin *admin,
 	return err;
 }
 
+static int sparx5_tc_action_vlan_pop(struct vcap_admin *admin,
+				     struct vcap_rule *vrule,
+				     struct flow_cls_offload *fco,
+				     u16 tpid)
+{
+	int err = 0;
+
+	switch (admin->vtype) {
+	case VCAP_TYPE_ES0:
+		break;
+	default:
+		NL_SET_ERR_MSG_MOD(fco->common.extack,
+				   "VLAN pop action not supported in this VCAP");
+		return -EOPNOTSUPP;
+	}
+
+	switch (tpid) {
+	case ETH_P_8021Q:
+	case ETH_P_8021AD:
+		err = vcap_rule_add_action_u32(vrule,
+					       VCAP_AF_PUSH_OUTER_TAG,
+					       SPX5_OTAG_UNTAG);
+		break;
+	default:
+		NL_SET_ERR_MSG_MOD(fco->common.extack,
+				   "Invalid vlan proto");
+		err = -EINVAL;
+	}
+	return err;
+}
+
+static int sparx5_tc_action_vlan_modify(struct vcap_admin *admin,
+					struct vcap_rule *vrule,
+					struct flow_cls_offload *fco,
+					struct flow_action_entry *act,
+					u16 tpid)
+{
+	int err = 0;
+
+	switch (admin->vtype) {
+	case VCAP_TYPE_ES0:
+		err = vcap_rule_add_action_u32(vrule,
+					       VCAP_AF_PUSH_OUTER_TAG,
+					       SPX5_OTAG_TAG_A);
+		if (err)
+			return err;
+		break;
+	default:
+		NL_SET_ERR_MSG_MOD(fco->common.extack,
+				   "VLAN modify action not supported in this VCAP");
+		return -EOPNOTSUPP;
+	}
+
+	switch (tpid) {
+	case ETH_P_8021Q:
+		err = vcap_rule_add_action_u32(vrule,
+					       VCAP_AF_TAG_A_TPID_SEL,
+					       SPX5_TPID_A_8100);
+		break;
+	case ETH_P_8021AD:
+		err = vcap_rule_add_action_u32(vrule,
+					       VCAP_AF_TAG_A_TPID_SEL,
+					       SPX5_TPID_A_88A8);
+		break;
+	default:
+		NL_SET_ERR_MSG_MOD(fco->common.extack,
+				   "Invalid vlan proto");
+		err = -EINVAL;
+	}
+	if (err)
+		return err;
+
+	err = vcap_rule_add_action_u32(vrule,
+				       VCAP_AF_TAG_A_VID_SEL,
+				       SPX5_VID_A_VAL);
+	if (err)
+		return err;
+
+	err = vcap_rule_add_action_u32(vrule,
+				       VCAP_AF_VID_A_VAL,
+				       act->vlan.vid);
+	if (err)
+		return err;
+
+	err = vcap_rule_add_action_u32(vrule,
+				       VCAP_AF_TAG_A_PCP_SEL,
+				       SPX5_PCP_A_VAL);
+	if (err)
+		return err;
+
+	err = vcap_rule_add_action_u32(vrule,
+				       VCAP_AF_PCP_A_VAL,
+				       act->vlan.prio);
+	if (err)
+		return err;
+
+	return vcap_rule_add_action_u32(vrule,
+					VCAP_AF_TAG_A_DEI_SEL,
+					SPX5_DEI_A_CLASSIFIED);
+}
+
+static int sparx5_tc_action_vlan_push(struct vcap_admin *admin,
+				      struct vcap_rule *vrule,
+				      struct flow_cls_offload *fco,
+				      struct flow_action_entry *act,
+				      u16 tpid)
+{
+	u16 act_tpid = be16_to_cpu(act->vlan.proto);
+	int err = 0;
+
+	switch (admin->vtype) {
+	case VCAP_TYPE_ES0:
+		break;
+	default:
+		NL_SET_ERR_MSG_MOD(fco->common.extack,
+				   "VLAN push action not supported in this VCAP");
+		return -EOPNOTSUPP;
+	}
+
+	if (tpid == ETH_P_8021AD) {
+		NL_SET_ERR_MSG_MOD(fco->common.extack,
+				   "Cannot push on double tagged frames");
+		return -EOPNOTSUPP;
+	}
+
+	err = sparx5_tc_action_vlan_modify(admin, vrule, fco, act, act_tpid);
+	if (err)
+		return err;
+
+	switch (act_tpid) {
+	case ETH_P_8021Q:
+		break;
+	case ETH_P_8021AD:
+		/* Push classified tag as inner tag */
+		err = vcap_rule_add_action_u32(vrule,
+					       VCAP_AF_PUSH_INNER_TAG,
+					       SPX5_ITAG_PUSH_B_TAG);
+		if (err)
+			break;
+		err = vcap_rule_add_action_u32(vrule,
+					       VCAP_AF_TAG_B_TPID_SEL,
+					       SPX5_TPID_B_CLASSIFIED);
+		break;
+	default:
+		NL_SET_ERR_MSG_MOD(fco->common.extack,
+				   "Invalid vlan proto");
+		err = -EINVAL;
+	}
+	return err;
+}
+
 static int sparx5_tc_flower_replace(struct net_device *ndev,
 				    struct flow_cls_offload *fco,
 				    struct vcap_admin *admin,
@@ -809,6 +1004,11 @@ static int sparx5_tc_flower_replace(struct net_device *ndev,
 	struct sparx5_psfp_sf sf = { .max_sdu = SPX5_PSFP_SF_MAX_SDU };
 	struct netlink_ext_ack *extack = fco->common.extack;
 	int err, idx, tc_sg_idx = -1, tc_pol_idx = -1;
+	struct vcap_tc_flower_parse_usage state = {
+		.fco = fco,
+		.l3_proto = ETH_P_ALL,
+		.admin = admin,
+	};
 	struct sparx5_port *port = netdev_priv(ndev);
 	struct sparx5_multiple_rules multi = {};
 	struct sparx5 *sparx5 = port->sparx5;
@@ -818,7 +1018,6 @@ static int sparx5_tc_flower_replace(struct net_device *ndev,
 	struct vcap_control *vctrl;
 	struct flow_rule *frule;
 	struct vcap_rule *vrule;
-	u16 l3_proto;
 
 	vctrl = port->sparx5->vcap_ctrl;
 
@@ -833,8 +1032,9 @@ static int sparx5_tc_flower_replace(struct net_device *ndev,
 
 	vrule->cookie = fco->cookie;
 
-	l3_proto = ETH_P_ALL;
-	err = sparx5_tc_use_dissectors(fco, admin, vrule, &l3_proto);
+	state.vrule = vrule;
+	state.frule = flow_cls_offload_flow_rule(fco);
+	err = sparx5_tc_use_dissectors(&state, admin, vrule);
 	if (err)
 		goto out;
 
@@ -888,6 +1088,24 @@ static int sparx5_tc_flower_replace(struct net_device *ndev,
 						fco->common.chain_index,
 						act->chain_index);
 			break;
+		case FLOW_ACTION_VLAN_POP:
+			err = sparx5_tc_action_vlan_pop(admin, vrule, fco,
+							state.tpid);
+			if (err)
+				goto out;
+			break;
+		case FLOW_ACTION_VLAN_PUSH:
+			err = sparx5_tc_action_vlan_push(admin, vrule, fco,
+							 act, state.tpid);
+			if (err)
+				goto out;
+			break;
+		case FLOW_ACTION_VLAN_MANGLE:
+			err = sparx5_tc_action_vlan_modify(admin, vrule, fco,
+							   act, state.tpid);
+			if (err)
+				goto out;
+			break;
 		default:
 			NL_SET_ERR_MSG_MOD(fco->common.extack,
 					   "Unsupported TC action");
@@ -904,8 +1122,8 @@ static int sparx5_tc_flower_replace(struct net_device *ndev,
 			goto out;
 	}
 
-	err = sparx5_tc_select_protocol_keyset(ndev, vrule, admin, l3_proto,
-					       &multi);
+	err = sparx5_tc_select_protocol_keyset(ndev, vrule, admin,
+					       state.l3_proto, &multi);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(fco->common.extack,
 				   "No matching port keyset for filter protocol and keys");
@@ -913,7 +1131,7 @@ static int sparx5_tc_flower_replace(struct net_device *ndev,
 	}
 
 	/* provide the l3 protocol to guide the keyset selection */
-	err = vcap_val_rule(vrule, l3_proto);
+	err = vcap_val_rule(vrule, state.l3_proto);
 	if (err) {
 		vcap_set_tc_exterr(fco, vrule);
 		goto out;
@@ -923,7 +1141,7 @@ static int sparx5_tc_flower_replace(struct net_device *ndev,
 		NL_SET_ERR_MSG_MOD(fco->common.extack,
 				   "Could not add the filter");
 
-	if (l3_proto == ETH_P_ALL)
+	if (state.l3_proto == ETH_P_ALL)
 		err = sparx5_tc_add_remaining_rules(vctrl, fco, vrule, admin,
 						    &multi);
 
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
index 208640627fcd..d0d4e0385ac7 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
@@ -852,6 +852,9 @@ static void sparx5_vcap_es0_add_default_fields(struct net_device *ndev,
 	struct sparx5_port *port = netdev_priv(ndev);
 
 	vcap_rule_add_key_u32(rule, VCAP_KF_IF_EGR_PORT_NO, port->portno, ~0);
+	/* Match untagged frames if there was no VLAN key */
+	vcap_rule_add_key_u32(rule, VCAP_KF_8021Q_TPID, SPX5_TPID_SEL_UNTAGGED,
+			      ~0);
 }
 
 static void sparx5_vcap_es2_add_default_fields(struct net_device *ndev,
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.h b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.h
index 4b0ad1aecec9..3260ab5e3a82 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.h
@@ -176,6 +176,18 @@ enum vcap_es2_port_sel_arp {
 	VCAP_ES2_PS_ARP_ARP,
 };
 
+/* Selects TPID for ES0 matching */
+enum SPX5_TPID_SEL {
+	SPX5_TPID_SEL_UNTAGGED,
+	SPX5_TPID_SEL_8100,
+	SPX5_TPID_SEL_UNUSED_0,
+	SPX5_TPID_SEL_UNUSED_1,
+	SPX5_TPID_SEL_88A8,
+	SPX5_TPID_SEL_TPIDCFG_1,
+	SPX5_TPID_SEL_TPIDCFG_2,
+	SPX5_TPID_SEL_TPIDCFG_3,
+};
+
 /* Get the port keyset for the vcap lookup */
 int sparx5_vcap_get_port_keyset(struct net_device *ndev,
 				struct vcap_admin *admin,
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_tc.c b/drivers/net/ethernet/microchip/vcap/vcap_tc.c
index 09a994a7cec2..09abe7944af6 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_tc.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_tc.c
@@ -235,6 +235,9 @@ int vcap_tc_flower_handler_vlan_usage(struct vcap_tc_flower_parse_usage *st,
 			goto out;
 	}
 
+	if (mt.mask->vlan_tpid)
+		st->tpid = be16_to_cpu(mt.key->vlan_tpid);
+
 	st->used_keys |= BIT(FLOW_DISSECTOR_KEY_VLAN);
 
 	return 0;
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_tc.h b/drivers/net/ethernet/microchip/vcap/vcap_tc.h
index 5c55ccbee175..071f892f9aa4 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_tc.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_tc.h
@@ -13,6 +13,7 @@ struct vcap_tc_flower_parse_usage {
 	struct vcap_admin *admin;
 	u16 l3_proto;
 	u8 l4_proto;
+	u16 tpid;
 	unsigned int used_keys;
 };
 
-- 
2.39.1


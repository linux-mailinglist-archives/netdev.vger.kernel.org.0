Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 105BA6AF849
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 23:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbjCGWKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 17:10:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbjCGWJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 17:09:53 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A1E99D67;
        Tue,  7 Mar 2023 14:09:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1678226991; x=1709762991;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jAosM2WbKrwDoxFF8ral/VHizqrcsWgxFxyrA7yJi8c=;
  b=kS8ks4CRa1ui/itA0pXDwx05jsC3zfbVMGDtuPwVgVxwTOiySstWgFds
   o80vaO1bUYYF+4ziZCj7OMmeFnigk+pBRNPdPTcZDSYWKXzClacs8SOTI
   NAPBaZ/Tnfu2tv0DyLE8s1quvrBrMA9dCbQyGA0dbDF8foST1ELlM+l+w
   SIAl2BcibTLwP/2v+DdtJHy1kwAI0MiIsDci/6wqo87UdbyDCwcA1o43i
   qfo0QFEWm/PxpY6LBcgSli4Jky3lYSnnJ1Qu9mby+TUod4zReewgm859n
   5PvvQRm3e6DoIuEK4HIHqR6IZH4wq2ZZ5kxLJyhjZiYTzhjmBqLxzcfdX
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,242,1673938800"; 
   d="scan'208";a="140824550"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Mar 2023 15:09:50 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Mar 2023 15:09:49 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 7 Mar 2023 15:09:47 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 3/5] net: lan966x: Add TC support for IS1 VCAP
Date:   Tue, 7 Mar 2023 23:09:27 +0100
Message-ID: <20230307220929.834219-4-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230307220929.834219-1-horatiu.vultur@microchip.com>
References: <20230307220929.834219-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable TC command to use IS1 VCAP

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../microchip/lan966x/lan966x_tc_flower.c     | 105 +++++++++++++++++-
 1 file changed, 102 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
index f960727ecaeec..8391652c1c45e 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
@@ -79,18 +79,61 @@ lan966x_tc_flower_handler_basic_usage(struct vcap_tc_flower_parse_usage *st)
 						    VCAP_BIT_1);
 			if (err)
 				goto out;
+		} else if (st->l3_proto == ETH_P_IPV6 &&
+			   st->admin->vtype == VCAP_TYPE_IS1) {
+			/* Don't set any keys in this case */
+		} else if (st->l3_proto == ETH_P_SNAP &&
+			   st->admin->vtype == VCAP_TYPE_IS1) {
+			err = vcap_rule_add_key_bit(st->vrule,
+						    VCAP_KF_ETYPE_LEN_IS,
+						    VCAP_BIT_0);
+			if (err)
+				goto out;
+
+			err = vcap_rule_add_key_bit(st->vrule,
+						    VCAP_KF_IP_SNAP_IS,
+						    VCAP_BIT_1);
+			if (err)
+				goto out;
+		} else if (st->admin->vtype == VCAP_TYPE_IS1) {
+			err = vcap_rule_add_key_bit(st->vrule,
+						    VCAP_KF_ETYPE_LEN_IS,
+						    VCAP_BIT_1);
+			if (err)
+				goto out;
+
+			err = vcap_rule_add_key_u32(st->vrule, VCAP_KF_ETYPE,
+						    st->l3_proto, ~0);
+			if (err)
+				goto out;
 		}
 	}
 	if (match.mask->ip_proto) {
 		st->l4_proto = match.key->ip_proto;
 
 		if (st->l4_proto == IPPROTO_TCP) {
+			if (st->admin->vtype == VCAP_TYPE_IS1) {
+				err = vcap_rule_add_key_bit(st->vrule,
+							    VCAP_KF_TCP_UDP_IS,
+							    VCAP_BIT_1);
+				if (err)
+					goto out;
+			}
+
 			err = vcap_rule_add_key_bit(st->vrule,
 						    VCAP_KF_TCP_IS,
 						    VCAP_BIT_1);
 			if (err)
 				goto out;
 		} else if (st->l4_proto == IPPROTO_UDP) {
+			if (st->admin->vtype == VCAP_TYPE_IS1) {
+				err = vcap_rule_add_key_bit(st->vrule,
+							    VCAP_KF_TCP_UDP_IS,
+							    VCAP_BIT_1);
+				if (err)
+					goto out;
+			}
+
 			err = vcap_rule_add_key_bit(st->vrule,
 						    VCAP_KF_TCP_IS,
 						    VCAP_BIT_0);
@@ -112,12 +155,30 @@ lan966x_tc_flower_handler_basic_usage(struct vcap_tc_flower_parse_usage *st)
 	return err;
 }
 
+static int
+lan966x_tc_flower_handler_cvlan_usage(struct vcap_tc_flower_parse_usage *st)
+{
+	if (st->admin->vtype != VCAP_TYPE_IS1) {
+		NL_SET_ERR_MSG_MOD(st->fco->common.extack,
+				   "cvlan not supported in this VCAP");
+		return -EINVAL;
+	}
+
+	return vcap_tc_flower_handler_cvlan_usage(st);
+}
+
 static int
 lan966x_tc_flower_handler_vlan_usage(struct vcap_tc_flower_parse_usage *st)
 {
-	return vcap_tc_flower_handler_vlan_usage(st,
-						 VCAP_KF_8021Q_VID_CLS,
-						 VCAP_KF_8021Q_PCP_CLS);
+	enum vcap_key_field vid_key = VCAP_KF_8021Q_VID_CLS;
+	enum vcap_key_field pcp_key = VCAP_KF_8021Q_PCP_CLS;
+
+	if (st->admin->vtype == VCAP_TYPE_IS1) {
+		vid_key = VCAP_KF_8021Q_VID0;
+		pcp_key = VCAP_KF_8021Q_PCP0;
+	}
+
+	return vcap_tc_flower_handler_vlan_usage(st, vid_key, pcp_key);
 }
 
 static int
@@ -128,6 +189,7 @@ static int
 	[FLOW_DISSECTOR_KEY_CONTROL] = lan966x_tc_flower_handler_control_usage,
 	[FLOW_DISSECTOR_KEY_PORTS] = vcap_tc_flower_handler_portnum_usage,
 	[FLOW_DISSECTOR_KEY_BASIC] = lan966x_tc_flower_handler_basic_usage,
+	[FLOW_DISSECTOR_KEY_CVLAN] = lan966x_tc_flower_handler_cvlan_usage,
 	[FLOW_DISSECTOR_KEY_VLAN] = lan966x_tc_flower_handler_vlan_usage,
 	[FLOW_DISSECTOR_KEY_TCP] = vcap_tc_flower_handler_tcp_usage,
 	[FLOW_DISSECTOR_KEY_ARP] = vcap_tc_flower_handler_arp_usage,
@@ -143,6 +205,7 @@ static int lan966x_tc_flower_use_dissectors(struct flow_cls_offload *f,
 		.fco = f,
 		.vrule = vrule,
 		.l3_proto = ETH_P_ALL,
+		.admin = admin,
 	};
 	int err = 0;
 
@@ -221,6 +284,31 @@ static int lan966x_tc_flower_action_check(struct vcap_control *vctrl,
 	return 0;
 }
 
+/* Add the actionset that is the default for the VCAP type */
+static int lan966x_tc_set_actionset(struct vcap_admin *admin,
+				    struct vcap_rule *vrule)
+{
+	enum vcap_actionfield_set aset;
+	int err = 0;
+
+	switch (admin->vtype) {
+	case VCAP_TYPE_IS1:
+		aset = VCAP_AFS_S1;
+		break;
+	case VCAP_TYPE_IS2:
+		aset = VCAP_AFS_BASE_TYPE;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/* Do not overwrite any current actionset */
+	if (vrule->actionset == VCAP_AFS_NO_VALUE)
+		err = vcap_set_rule_set_actionset(vrule, aset);
+
+	return err;
+}
+
 static int lan966x_tc_flower_add(struct lan966x_port *port,
 				 struct flow_cls_offload *f,
 				 struct vcap_admin *admin,
@@ -253,6 +341,13 @@ static int lan966x_tc_flower_add(struct lan966x_port *port,
 	flow_action_for_each(idx, act, &frule->action) {
 		switch (act->id) {
 		case FLOW_ACTION_TRAP:
+			if (admin->vtype != VCAP_TYPE_IS2) {
+				NL_SET_ERR_MSG_MOD(f->common.extack,
+						   "Trap action not supported in this VCAP");
+				err = -EOPNOTSUPP;
+				goto out;
+			}
+
 			err = vcap_rule_add_action_bit(vrule,
 						       VCAP_AF_CPU_COPY_ENA,
 						       VCAP_BIT_1);
@@ -266,6 +361,10 @@ static int lan966x_tc_flower_add(struct lan966x_port *port,
 
 			break;
 		case FLOW_ACTION_GOTO:
+			err = lan966x_tc_set_actionset(admin, vrule);
+			if (err)
+				goto out;
+
 			break;
 		default:
 			NL_SET_ERR_MSG_MOD(f->common.extack,
-- 
2.38.0


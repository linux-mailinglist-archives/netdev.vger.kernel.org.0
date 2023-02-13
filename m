Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC60E694110
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 10:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbjBMJ1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 04:27:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbjBMJ00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 04:26:26 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2065715566;
        Mon, 13 Feb 2023 01:25:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676280314; x=1707816314;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hNl9scPGdvFsBvlnEw41wGtSpnOpRPVbC7Kd9vJP6rk=;
  b=2iGyBE4rYTw7CXKjuQNlzjpVlRoBs+V6Dmm3yrfM7gWuNK82EOFmQWPf
   kWAxkwiMfOldJnGS22R1FKIgplhEU7itAZxCeLmzNkgS7Y1BWQWbnaMsO
   dbK8zA8Y1wQ0HRk7LkPOje8X1Fpwz2KbcUulm2V6Y+Wm58DQ70kqbUqmD
   zIqYKV9QfWJw7xeRjBKSRG1MM6L4H23jPQFVvRiOOg0txokdQM2yQZZMs
   cBgwXZQMOLspJJon8+gxxaNz5juGlpLSsii1T0ARMIgLWq8navXqzpfsV
   fPnmOamlgNvoYQX8ge971UFLIM9WkqTmluvShFg8uL61lmEiDjww15NUM
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,293,1669100400"; 
   d="scan'208";a="136853387"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Feb 2023 02:25:13 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 13 Feb 2023 02:25:10 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Mon, 13 Feb 2023 02:25:07 -0700
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
Subject: [PATCH net-next 09/10] net: microchip: sparx5: Add TC support for the ES0 VCAP
Date:   Mon, 13 Feb 2023 10:24:25 +0100
Message-ID: <20230213092426.1331379-10-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213092426.1331379-1-steen.hegelund@microchip.com>
References: <20230213092426.1331379-1-steen.hegelund@microchip.com>
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

This enables the TC command to use the Sparx5 ES0 VCAP, and handling of
rule links between IS0 and ES0.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../net/ethernet/microchip/sparx5/sparx5_tc.h |  8 ++
 .../microchip/sparx5/sparx5_tc_flower.c       | 77 +++++++++++++------
 .../microchip/sparx5/sparx5_vcap_impl.c       |  2 +
 3 files changed, 64 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc.h b/drivers/net/ethernet/microchip/sparx5/sparx5_tc.h
index adab88e6b21f..01273db708ac 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc.h
@@ -21,6 +21,14 @@ enum SPX5_PORT_MASK_MODE {
 	SPX5_PMM_OR_PGID_MASK,
 };
 
+/* Controls ES0 forwarding  */
+enum SPX5_FORWARDING_SEL {
+	SPX5_FWSEL_NO_ACTION,
+	SPX5_FWSEL_COPY_TO_LOOPBACK,
+	SPX5_FWSEL_REDIRECT_TO_LOOPBACK,
+	SPX5_FWSEL_DISCARD,
+};
+
 int sparx5_port_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 			 void *type_data);
 
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
index 3e29180b41a6..67b49ad6a8f9 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
@@ -508,10 +508,14 @@ static int sparx5_tc_set_actionset(struct vcap_admin *admin,
 	case VCAP_TYPE_IS2:
 		aset = VCAP_AFS_BASE_TYPE;
 		break;
+	case VCAP_TYPE_ES0:
+		aset = VCAP_AFS_ES0;
+		break;
 	case VCAP_TYPE_ES2:
 		aset = VCAP_AFS_BASE_TYPE;
 		break;
 	default:
+		pr_err("%s:%d: %s\n", __func__, __LINE__, "Invalid VCAP type");
 		return -EINVAL;
 	}
 	/* Do not overwrite any current actionset */
@@ -547,6 +551,7 @@ static int sparx5_tc_add_rule_link_target(struct vcap_admin *admin,
 		return vcap_rule_add_key_u32(vrule, VCAP_KF_LOOKUP_PAG,
 					     link_val, /* target */
 					     ~0);
+	case VCAP_TYPE_ES0:
 	case VCAP_TYPE_ES2:
 		/* Add ISDX key for chaining rules from IS0 */
 		return vcap_rule_add_key_u32(vrule, VCAP_KF_ISDX_CLS, link_val,
@@ -598,8 +603,9 @@ static int sparx5_tc_add_rule_link(struct vcap_control *vctrl,
 		if (err)
 			goto out;
 	} else if (admin->vtype == VCAP_TYPE_IS0 &&
-		   to_admin->vtype == VCAP_TYPE_ES2) {
-		/* Between IS0 and ES2 the ISDX value is used */
+		   (to_admin->vtype == VCAP_TYPE_ES0 ||
+		    to_admin->vtype == VCAP_TYPE_ES2)) {
+		/* Between IS0 and ES0/ES2 the ISDX value is used */
 		err = vcap_rule_add_action_u32(vrule, VCAP_AF_ISDX_VAL,
 					       diff);
 		if (err)
@@ -750,6 +756,51 @@ static int sparx5_tc_flower_psfp_setup(struct sparx5 *sparx5,
 	return 0;
 }
 
+/* Handle the action trap for a VCAP rule */
+static int sparx5_tc_action_trap(struct vcap_admin *admin,
+				 struct vcap_rule *vrule,
+				 struct flow_cls_offload *fco)
+{
+	int err = 0;
+
+	switch (admin->vtype) {
+	case VCAP_TYPE_IS2:
+		err = vcap_rule_add_action_bit(vrule,
+					       VCAP_AF_CPU_COPY_ENA,
+					       VCAP_BIT_1);
+		if (err)
+			break;
+		err = vcap_rule_add_action_u32(vrule,
+					       VCAP_AF_CPU_QUEUE_NUM, 0);
+		if (err)
+			break;
+		err = vcap_rule_add_action_u32(vrule,
+					       VCAP_AF_MASK_MODE,
+					       SPX5_PMM_REPLACE_ALL);
+		break;
+	case VCAP_TYPE_ES0:
+		err = vcap_rule_add_action_u32(vrule,
+					       VCAP_AF_FWD_SEL,
+					       SPX5_FWSEL_REDIRECT_TO_LOOPBACK);
+		break;
+	case VCAP_TYPE_ES2:
+		err = vcap_rule_add_action_bit(vrule,
+					       VCAP_AF_CPU_COPY_ENA,
+					       VCAP_BIT_1);
+		if (err)
+			break;
+		err = vcap_rule_add_action_u32(vrule,
+					       VCAP_AF_CPU_QUEUE_NUM, 0);
+		break;
+	default:
+		NL_SET_ERR_MSG_MOD(fco->common.extack,
+				   "Trap action not supported in this VCAP");
+		err = -EOPNOTSUPP;
+		break;
+	}
+	return err;
+}
+
 static int sparx5_tc_flower_replace(struct net_device *ndev,
 				    struct flow_cls_offload *fco,
 				    struct vcap_admin *admin,
@@ -820,27 +871,7 @@ static int sparx5_tc_flower_replace(struct net_device *ndev,
 			break;
 		}
 		case FLOW_ACTION_TRAP:
-			if (admin->vtype != VCAP_TYPE_IS2 &&
-			    admin->vtype != VCAP_TYPE_ES2) {
-				NL_SET_ERR_MSG_MOD(fco->common.extack,
-						   "Trap action not supported in this VCAP");
-				err = -EOPNOTSUPP;
-				goto out;
-			}
-			err = vcap_rule_add_action_bit(vrule,
-						       VCAP_AF_CPU_COPY_ENA,
-						       VCAP_BIT_1);
-			if (err)
-				goto out;
-			err = vcap_rule_add_action_u32(vrule,
-						       VCAP_AF_CPU_QUEUE_NUM, 0);
-			if (err)
-				goto out;
-			if (admin->vtype != VCAP_TYPE_IS2)
-				break;
-			err = vcap_rule_add_action_u32(vrule,
-						       VCAP_AF_MASK_MODE,
-				SPX5_PMM_REPLACE_ALL);
+			err = sparx5_tc_action_trap(admin, vrule, fco);
 			if (err)
 				goto out;
 			break;
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
index 72b563590873..208640627fcd 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
@@ -740,6 +740,8 @@ bool sparx5_vcap_is_known_etype(struct vcap_admin *admin, u16 etype)
 		known_etypes = sparx5_vcap_is2_known_etypes;
 		size = ARRAY_SIZE(sparx5_vcap_is2_known_etypes);
 		break;
+	case VCAP_TYPE_ES0:
+		return true;
 	case VCAP_TYPE_ES2:
 		known_etypes = sparx5_vcap_es2_known_etypes;
 		size = ARRAY_SIZE(sparx5_vcap_es2_known_etypes);
-- 
2.39.1


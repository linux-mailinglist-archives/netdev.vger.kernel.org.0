Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33A34675040
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 10:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbjATJJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 04:09:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbjATJJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 04:09:13 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41BA18BA8A;
        Fri, 20 Jan 2023 01:08:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674205737; x=1705741737;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3Gs4p5cR2Q8gbp6NOp0imI2YdlQl3cYP9ju7lgHKE9k=;
  b=fz8cot0H6y86Fj4PWv0GjjqIEgfxpQG+qpPdlkZuz3c43LBzbsb3AnIL
   Y6DA28e2HGhcH/GccHYfN256JvP5R1BkaX6COhYqlaLEQq3ZJs2JLvX7d
   eb87C45QLCN8s+vP2NqmYaRt4cPS1bd7bUbUZXLXxqjxbis52w1ei1waa
   jGa0wqbk0HdfaGd1ysOiUqrnXpWI7PZnsCj0vPukrhfOnh3Aure8bnhNe
   HWo3EZcA0rJG++rmrFxcnaLVwKcl8RGX9Rhld+/+8B+EDVColzr7U5ixZ
   2bHvR7whd8cS9j/xfz671YEFBmELmUi+lXJorNC6udH18JMxuVvG56IMs
   A==;
X-IronPort-AV: E=Sophos;i="5.97,231,1669100400"; 
   d="scan'208";a="196670256"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jan 2023 02:08:56 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 20 Jan 2023 02:08:55 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 20 Jan 2023 02:08:51 -0700
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
Subject: [PATCH net-next 4/8] net: microchip: sparx5: Add TC support for IS0 VCAP
Date:   Fri, 20 Jan 2023 10:08:27 +0100
Message-ID: <20230120090831.20032-5-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230120090831.20032-1-steen.hegelund@microchip.com>
References: <20230120090831.20032-1-steen.hegelund@microchip.com>
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

This enables the TC command to use the Sparx5 IS0 VCAP

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../microchip/sparx5/sparx5_tc_flower.c       | 54 +++++++++++++++----
 1 file changed, 45 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
index affaa1656710..e69b9a85f0f2 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
@@ -30,6 +30,7 @@ struct sparx5_tc_flower_parse_usage {
 	struct flow_cls_offload *fco;
 	struct flow_rule *frule;
 	struct vcap_rule *vrule;
+	struct vcap_admin *admin;
 	u16 l3_proto;
 	u8 l4_proto;
 	unsigned int used_keys;
@@ -304,6 +305,13 @@ sparx5_tc_flower_handler_basic_usage(struct sparx5_tc_flower_parse_usage *st)
 						    VCAP_BIT_0);
 			if (err)
 				goto out;
+			if (st->admin->vtype == VCAP_TYPE_IS0) {
+				err = vcap_rule_add_key_bit(st->vrule,
+							    VCAP_KF_TCP_UDP_IS,
+							    VCAP_BIT_1);
+				if (err)
+					goto out;
+			}
 		} else {
 			err = vcap_rule_add_key_u32(st->vrule,
 						    VCAP_KF_L3_IP_PROTO,
@@ -542,6 +550,7 @@ static int sparx5_tc_use_dissectors(struct flow_cls_offload *fco,
 		.fco = fco,
 		.vrule = vrule,
 		.l3_proto = ETH_P_ALL,
+		.admin = admin,
 	};
 	int idx, err = 0;
 
@@ -623,17 +632,20 @@ static int sparx5_tc_flower_action_check(struct vcap_control *vctrl,
 	return 0;
 }
 
-/* Add a rule counter action - only IS2 is considered for now */
+/* Add a rule counter action */
 static int sparx5_tc_add_rule_counter(struct vcap_admin *admin,
 				      struct vcap_rule *vrule)
 {
-	int err;
+	int err = 0;
 
-	err = vcap_rule_mod_action_u32(vrule, VCAP_AF_CNT_ID, vrule->id);
-	if (err)
-		return err;
+	if (admin->vtype == VCAP_TYPE_IS2) {
+		err = vcap_rule_mod_action_u32(vrule, VCAP_AF_CNT_ID,
+					       vrule->id);
+		if (err)
+			return err;
+		vcap_rule_set_counter_id(vrule, vrule->id);
+	}
 
-	vcap_rule_set_counter_id(vrule, vrule->id);
 	return err;
 }
 
@@ -815,6 +827,29 @@ static int sparx5_tc_add_remaining_rules(struct vcap_control *vctrl,
 	return err;
 }
 
+/* Add the actionset that is the default for the VCAP type */
+static int sparx5_tc_set_actionset(struct vcap_admin *admin,
+				   struct vcap_rule *vrule)
+{
+	enum vcap_actionfield_set aset;
+	int err = 0;
+
+	switch (admin->vtype) {
+	case VCAP_TYPE_IS0:
+		aset = VCAP_AFS_CLASSIFICATION;
+		break;
+	case VCAP_TYPE_IS2:
+		aset = VCAP_AFS_BASE_TYPE;
+		break;
+	default:
+		return -EINVAL;
+	}
+	/* Do not overwrite any current actionset */
+	if (vrule->actionset == VCAP_AFS_NO_VALUE)
+		err = vcap_set_rule_set_actionset(vrule, aset);
+	return err;
+}
+
 static int sparx5_tc_flower_replace(struct net_device *ndev,
 				    struct flow_cls_offload *fco,
 				    struct vcap_admin *admin)
@@ -874,13 +909,14 @@ static int sparx5_tc_flower_replace(struct net_device *ndev,
 				goto out;
 			break;
 		case FLOW_ACTION_ACCEPT:
-			/* For now the actionset is hardcoded */
-			err = vcap_set_rule_set_actionset(vrule,
-							  VCAP_AFS_BASE_TYPE);
+			err = sparx5_tc_set_actionset(admin, vrule);
 			if (err)
 				goto out;
 			break;
 		case FLOW_ACTION_GOTO:
+			err = sparx5_tc_set_actionset(admin, vrule);
+			if (err)
+				goto out;
 			/* Links between VCAPs will be added later */
 			break;
 		default:
-- 
2.39.1


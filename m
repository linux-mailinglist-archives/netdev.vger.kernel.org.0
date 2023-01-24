Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1495D679599
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 11:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233764AbjAXKp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 05:45:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233681AbjAXKpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 05:45:39 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02EFC42BEB;
        Tue, 24 Jan 2023 02:45:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674557137; x=1706093137;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NMT1v23LlceJBcDri8vzubqJYcUPHF9idJ28GFyW5mI=;
  b=x6Uynjn1pBynBkzGlqanve3hiaW8WGVg3xLOTdmyhTMN6fOT+XG17j4D
   5syxx0MV2W8s5BeO16LXjfWKXWUL6YBG2rNzsAv0sNyG3z3EZCeBJYUK7
   tY0tv295fBhtwpzLq/hPC9CGtvgYYwf43D3JdGemN4q//9S75pl2l1MSS
   S/NHgkEmCckQLQC44A1JRFd0VJrdSXctDRFqJ4mmIU2KbGlC7Qt7Qmkjw
   KCSsna+zq0R31yffX1MfgHRNEbwmN4vGlpI9ARHedyA5qaGnv/UIizCld
   KFNEw0jBt2UnsqMT/WjemU/cwFGEWP/jzHqKLVW1YUdBNTimYLfkNDRAD
   w==;
X-IronPort-AV: E=Sophos;i="5.97,242,1669100400"; 
   d="scan'208";a="193598311"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jan 2023 03:45:36 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 24 Jan 2023 03:45:33 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 24 Jan 2023 03:45:29 -0700
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
Subject: [PATCH net-next v2 4/8] net: microchip: sparx5: Add TC support for IS0 VCAP
Date:   Tue, 24 Jan 2023 11:45:07 +0100
Message-ID: <20230124104511.293938-5-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230124104511.293938-1-steen.hegelund@microchip.com>
References: <20230124104511.293938-1-steen.hegelund@microchip.com>
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
index affaa1656710..72bc2733b662 100644
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
 
@@ -623,18 +632,21 @@ static int sparx5_tc_flower_action_check(struct vcap_control *vctrl,
 	return 0;
 }
 
-/* Add a rule counter action - only IS2 is considered for now */
+/* Add a rule counter action */
 static int sparx5_tc_add_rule_counter(struct vcap_admin *admin,
 				      struct vcap_rule *vrule)
 {
 	int err;
 
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
-	return err;
+	return 0;
 }
 
 /* Collect all port keysets and apply the first of them, possibly wildcarded */
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4880767E634
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 14:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234692AbjA0NKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 08:10:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234676AbjA0NJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 08:09:58 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3AB27DBCB;
        Fri, 27 Jan 2023 05:09:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674824971; x=1706360971;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xHrT/SrM87HKl7hDzGFIUVsDLKyqSbnMEZ7a7+XDWds=;
  b=gMFasdV/iQTvxYFYhZzkzAZlbId187YCHA9YCKpVAuObc976FW5zNxm+
   niqE0wSS7Vbb9bkkMxkZPEEgBgtTmNy06ym7GSU6yZjGjMgSh7GmkdQ73
   BITE1W2obP4mCdTfYDGLb0LlHoqOF2Ug2g/6RQLHaIjATo2V5mxiXPhEJ
   pyIQ6irYK7aISCdLCNG0wK8XolDgddPSWz1TGZErM/Rl4bZF2N6wExqDR
   wFmjfSiDyXcnLczP2Yd7rf/t+5e63I/S5RVkoxha6U9IJe5csS/jXL6G4
   o+fTmBH78Cerkyb4kbqtf5stNels1sZAuIZJcAQbHeRDamtPxAwvYIAMB
   w==;
X-IronPort-AV: E=Sophos;i="5.97,251,1669100400"; 
   d="scan'208";a="194150636"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2023 06:09:29 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 27 Jan 2023 06:09:22 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 27 Jan 2023 06:09:15 -0700
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
Subject: [PATCH net-next 7/8] net: microchip: sparx5: Add TC support for the ES2 VCAP
Date:   Fri, 27 Jan 2023 14:08:29 +0100
Message-ID: <20230127130830.1481526-8-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230127130830.1481526-1-steen.hegelund@microchip.com>
References: <20230127130830.1481526-1-steen.hegelund@microchip.com>
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

This enables the TC command to use the Sparx5 ES2 VCAP, and provides a new
ES2 ethertype table and handling of rule links between IS0 and ES2.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../microchip/sparx5/sparx5_tc_flower.c       | 31 ++++++++++++++++---
 .../microchip/sparx5/sparx5_vcap_impl.c       | 12 +++++++
 2 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
index 96f82612cc4a..217ff127e3c7 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
@@ -680,7 +680,7 @@ static int sparx5_tc_add_rule_counter(struct vcap_admin *admin,
 {
 	int err;
 
-	if (admin->vtype == VCAP_TYPE_IS2) {
+	if (admin->vtype == VCAP_TYPE_IS2 || admin->vtype == VCAP_TYPE_ES2) {
 		err = vcap_rule_mod_action_u32(vrule, VCAP_AF_CNT_ID,
 					       vrule->id);
 		if (err)
@@ -883,6 +883,9 @@ static int sparx5_tc_set_actionset(struct vcap_admin *admin,
 	case VCAP_TYPE_IS2:
 		aset = VCAP_AFS_BASE_TYPE;
 		break;
+	case VCAP_TYPE_ES2:
+		aset = VCAP_AFS_BASE_TYPE;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -919,6 +922,10 @@ static int sparx5_tc_add_rule_link_target(struct vcap_admin *admin,
 		return vcap_rule_add_key_u32(vrule, VCAP_KF_LOOKUP_PAG,
 					     link_val, /* target */
 					     ~0);
+	case VCAP_TYPE_ES2:
+		/* Add ISDX key for chaining rules from IS0 */
+		return vcap_rule_add_key_u32(vrule, VCAP_KF_ISDX_CLS, link_val,
+					     ~0);
 	default:
 		break;
 	}
@@ -961,6 +968,18 @@ static int sparx5_tc_add_rule_link(struct vcap_control *vctrl,
 					       0xff);
 		if (err)
 			goto out;
+	} else if (admin->vtype == VCAP_TYPE_IS0 &&
+		   to_admin->vtype == VCAP_TYPE_ES2) {
+		/* Between IS0 and ES2 the ISDX value is used */
+		err = vcap_rule_add_action_u32(vrule, VCAP_AF_ISDX_VAL,
+					       diff);
+		if (err)
+			goto out;
+		err = vcap_rule_add_action_bit(vrule,
+					       VCAP_AF_ISDX_ADD_REPLACE_SEL,
+					       VCAP_BIT_1);
+		if (err)
+			goto out;
 	} else {
 		pr_err("%s:%d: unsupported chain destination: %d\n",
 		       __func__, __LINE__, to_cid);
@@ -1015,7 +1034,8 @@ static int sparx5_tc_flower_replace(struct net_device *ndev,
 	flow_action_for_each(idx, act, &frule->action) {
 		switch (act->id) {
 		case FLOW_ACTION_TRAP:
-			if (admin->vtype != VCAP_TYPE_IS2) {
+			if (admin->vtype != VCAP_TYPE_IS2 &&
+			    admin->vtype != VCAP_TYPE_ES2) {
 				NL_SET_ERR_MSG_MOD(fco->common.extack,
 						   "Trap action not supported in this VCAP");
 				err = -EOPNOTSUPP;
@@ -1030,8 +1050,11 @@ static int sparx5_tc_flower_replace(struct net_device *ndev,
 						       VCAP_AF_CPU_QUEUE_NUM, 0);
 			if (err)
 				goto out;
-			err = vcap_rule_add_action_u32(vrule, VCAP_AF_MASK_MODE,
-						       SPX5_PMM_REPLACE_ALL);
+			if (admin->vtype != VCAP_TYPE_IS2)
+				break;
+			err = vcap_rule_add_action_u32(vrule,
+						       VCAP_AF_MASK_MODE,
+				SPX5_PMM_REPLACE_ALL);
 			if (err)
 				goto out;
 			break;
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
index ccb993bbd614..cadc4926d550 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
@@ -143,6 +143,14 @@ static u16 sparx5_vcap_is2_known_etypes[] = {
 	ETH_P_IPV6,
 };
 
+/* These protocols have dedicated keysets in ES2 and a TC dissector */
+static u16 sparx5_vcap_es2_known_etypes[] = {
+	ETH_P_ALL,
+	ETH_P_ARP,
+	ETH_P_IP,
+	ETH_P_IPV6,
+};
+
 static void sparx5_vcap_type_err(struct sparx5 *sparx5,
 				 struct vcap_admin *admin,
 				 const char *fname)
@@ -667,6 +675,10 @@ bool sparx5_vcap_is_known_etype(struct vcap_admin *admin, u16 etype)
 		known_etypes = sparx5_vcap_is2_known_etypes;
 		size = ARRAY_SIZE(sparx5_vcap_is2_known_etypes);
 		break;
+	case VCAP_TYPE_ES2:
+		known_etypes = sparx5_vcap_es2_known_etypes;
+		size = ARRAY_SIZE(sparx5_vcap_es2_known_etypes);
+		break;
 	default:
 		return false;
 	}
-- 
2.39.1


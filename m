Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 700C3616251
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 12:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbiKBL6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 07:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbiKBL6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 07:58:05 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9901D2936E;
        Wed,  2 Nov 2022 04:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667390283; x=1698926283;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Y2CJi1tN6lz1iCJLrLmSwmuvqHGh1dbRcoXIX9/R8aU=;
  b=UWaeleQP2gZDvARk8011bSBVbYMfaPE8CQBLbG6+fzs0XGCxRnxaX72l
   qOllB86dCipd8ZRN6i35GsrXTXxWyQ78E4OCjXdfA2ObHyxYDV1j2m4ym
   Mp0d/w005p+Mc6ZdDSrSEP0FiQzErB92y+B02Urg7xpBiLrPiFuNVgC4z
   IZt+09wHIJbBPw7MDSGXYVA3NMFTu2Iyih6McsUZlfST+TAUhiTSqA+7C
   nPZQNQdrWbJjY6950T9AyAUOwW/NQsThgZCNHL+VEZE0ISuzExKDmah1m
   5Pb/Ra9/DewCEvUjL5tOES5RR10nmhedH6/x4KMJcDAgYpsa88H05FTq4
   A==;
X-IronPort-AV: E=Sophos;i="5.95,232,1661842800"; 
   d="scan'208";a="181583235"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Nov 2022 04:58:02 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 2 Nov 2022 04:57:59 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 2 Nov 2022 04:57:56 -0700
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
        "Daniel Machon" <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: [PATCH net-next v4 4/7] net: microchip: sparx5: Adding TC goto action and action checking
Date:   Wed, 2 Nov 2022 12:57:34 +0100
Message-ID: <20221102115737.4118808-5-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102115737.4118808-1-steen.hegelund@microchip.com>
References: <20221102115737.4118808-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for a goto action and ensure that a HW offloaded TC flower
filter has a valid goto action and that pass and trap actions are not both
used in the same filter.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../microchip/sparx5/sparx5_tc_flower.c       | 71 ++++++++++++++++---
 1 file changed, 63 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
index 13bc6bff4c1e..537a85edc954 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
@@ -464,6 +464,61 @@ static int sparx5_tc_use_dissectors(struct flow_cls_offload *fco,
 	return err;
 }
 
+static int sparx5_tc_flower_action_check(struct vcap_control *vctrl,
+					 struct flow_cls_offload *fco,
+					 struct vcap_admin *admin)
+{
+	struct flow_rule *rule = flow_cls_offload_flow_rule(fco);
+	struct flow_action_entry *actent, *last_actent = NULL;
+	struct flow_action *act = &rule->action;
+	u64 action_mask = 0;
+	int idx;
+
+	if (!flow_action_has_entries(act)) {
+		NL_SET_ERR_MSG_MOD(fco->common.extack, "No actions");
+		return -EINVAL;
+	}
+
+	if (!flow_action_basic_hw_stats_check(act, fco->common.extack))
+		return -EOPNOTSUPP;
+
+	flow_action_for_each(idx, actent, act) {
+		if (action_mask & BIT(actent->id)) {
+			NL_SET_ERR_MSG_MOD(fco->common.extack,
+					   "More actions of the same type");
+			return -EINVAL;
+		}
+		action_mask |= BIT(actent->id);
+		last_actent = actent; /* Save last action for later check */
+	}
+
+	/* Check that last action is a goto */
+	if (last_actent->id != FLOW_ACTION_GOTO) {
+		NL_SET_ERR_MSG_MOD(fco->common.extack,
+				   "Last action must be 'goto'");
+		return -EINVAL;
+	}
+
+	/* Check if the goto chain is in the same VCAP instance and lookup */
+	if (admin == vcap_find_admin(vctrl, last_actent->chain_index))
+		if (vcap_chain_id_to_lookup(admin, fco->common.chain_index) ==
+		    vcap_chain_id_to_lookup(admin, last_actent->chain_index)) {
+			NL_SET_ERR_MSG_MOD(fco->common.extack,
+					   "Invalid goto chain");
+			return -EINVAL;
+		}
+
+	/* Catch unsupported combinations of actions */
+	if (action_mask & BIT(FLOW_ACTION_TRAP) &&
+	    action_mask & BIT(FLOW_ACTION_ACCEPT)) {
+		NL_SET_ERR_MSG_MOD(fco->common.extack,
+				   "Cannot combine pass and trap action");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static int sparx5_tc_flower_replace(struct net_device *ndev,
 				    struct flow_cls_offload *fco,
 				    struct vcap_admin *admin)
@@ -475,16 +530,12 @@ static int sparx5_tc_flower_replace(struct net_device *ndev,
 	struct vcap_rule *vrule;
 	int err, idx;
 
-	frule = flow_cls_offload_flow_rule(fco);
-	if (!flow_action_has_entries(&frule->action)) {
-		NL_SET_ERR_MSG_MOD(fco->common.extack, "No actions");
-		return -EINVAL;
-	}
+	vctrl = port->sparx5->vcap_ctrl;
 
-	if (!flow_action_basic_hw_stats_check(&frule->action, fco->common.extack))
-		return -EOPNOTSUPP;
+	err = sparx5_tc_flower_action_check(vctrl, fco, admin);
+	if (err)
+		return err;
 
-	vctrl = port->sparx5->vcap_ctrl;
 	vrule = vcap_alloc_rule(vctrl, ndev, fco->common.chain_index, VCAP_USER_TC,
 				fco->common.prio, 0);
 	if (IS_ERR(vrule))
@@ -492,6 +543,7 @@ static int sparx5_tc_flower_replace(struct net_device *ndev,
 
 	vrule->cookie = fco->cookie;
 	sparx5_tc_use_dissectors(fco, admin, vrule);
+	frule = flow_cls_offload_flow_rule(fco);
 	flow_action_for_each(idx, act, &frule->action) {
 		switch (act->id) {
 		case FLOW_ACTION_TRAP:
@@ -521,6 +573,9 @@ static int sparx5_tc_flower_replace(struct net_device *ndev,
 			if (err)
 				goto out;
 			break;
+		case FLOW_ACTION_GOTO:
+			/* Links between VCAPs will be added later */
+			break;
 		default:
 			NL_SET_ERR_MSG_MOD(fco->common.extack,
 					   "Unsupported TC action");
-- 
2.38.1


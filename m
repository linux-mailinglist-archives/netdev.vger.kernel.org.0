Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1788E619941
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 15:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbiKDOTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 10:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231975AbiKDOS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 10:18:57 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 699882037F;
        Fri,  4 Nov 2022 07:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667571535; x=1699107535;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wBCOxA7WJXdt7G0lShoOFr9b7beloTsvHAdHql0j8SE=;
  b=UPoSzBdtUfaffzD3+dneUnMEiuThGrvSDDYq6N9a6i+5yL888BtZoeKo
   SYvDmL0gGYvUoHtZhejinnOAfc1UfwJH1ahz3jehvdRc/NDQQZEmrqdOQ
   EmDE5OEJr7CmbEO04Cz7n3KTndMNSovtBOkCT9/N5Hxby7GG09UBgKQ9g
   iPBP4AHPcE5zfuKZdFJsHCaaQD7JzbS2FtM1mDz179BC7sI7toKbjLz7d
   VT6zoBh7VJEoVbR89nRymvMlsU3sKOvQeXIKC3FwQIi0GNHOu/LOaAbv/
   bdxftQpnOkd3t5OywgIV2ighIiw03xPPAq+o14+uxDCUhPQX8FEwCpw1s
   w==;
X-IronPort-AV: E=Sophos;i="5.96,137,1665471600"; 
   d="scan'208";a="121853249"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Nov 2022 07:18:54 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 4 Nov 2022 07:18:52 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 4 Nov 2022 07:18:49 -0700
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
Subject: [PATCH net-next v5 4/8] net: microchip: sparx5: Adding TC goto action and action checking
Date:   Fri, 4 Nov 2022 15:18:26 +0100
Message-ID: <20221104141830.1527159-5-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221104141830.1527159-1-steen.hegelund@microchip.com>
References: <20221104141830.1527159-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 .../microchip/sparx5/sparx5_tc_flower.c       | 70 ++++++++++++++++---
 .../net/ethernet/microchip/vcap/vcap_api.c    | 36 ++++++++++
 .../ethernet/microchip/vcap/vcap_api_client.h |  2 +
 3 files changed, 100 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
index 13bc6bff4c1e..6cd29d3c9250 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
@@ -464,6 +464,60 @@ static int sparx5_tc_use_dissectors(struct flow_cls_offload *fco,
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
+	/* Check if the goto chain is in the next lookup */
+	if (!vcap_is_next_lookup(vctrl, fco->common.chain_index,
+				 last_actent->chain_index)) {
+		NL_SET_ERR_MSG_MOD(fco->common.extack,
+				   "Invalid goto chain");
+		return -EINVAL;
+	}
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
@@ -475,16 +529,12 @@ static int sparx5_tc_flower_replace(struct net_device *ndev,
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
@@ -492,6 +542,7 @@ static int sparx5_tc_flower_replace(struct net_device *ndev,
 
 	vrule->cookie = fco->cookie;
 	sparx5_tc_use_dissectors(fco, admin, vrule);
+	frule = flow_cls_offload_flow_rule(fco);
 	flow_action_for_each(idx, act, &frule->action) {
 		switch (act->id) {
 		case FLOW_ACTION_TRAP:
@@ -521,6 +572,9 @@ static int sparx5_tc_flower_replace(struct net_device *ndev,
 			if (err)
 				goto out;
 			break;
+		case FLOW_ACTION_GOTO:
+			/* Links between VCAPs will be added later */
+			break;
 		default:
 			NL_SET_ERR_MSG_MOD(fco->common.extack,
 					   "Unsupported TC action");
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index d5b62e43d83f..0dd9637933b2 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -677,6 +677,42 @@ struct vcap_admin *vcap_find_admin(struct vcap_control *vctrl, int cid)
 }
 EXPORT_SYMBOL_GPL(vcap_find_admin);
 
+/* Is the next chain id in the following lookup, possible in another VCAP */
+bool vcap_is_next_lookup(struct vcap_control *vctrl, int cur_cid, int next_cid)
+{
+	struct vcap_admin *admin, *next_admin;
+	int lookup, next_lookup;
+
+	/* The offset must be at least one lookup */
+	if (next_cid < cur_cid + VCAP_CID_LOOKUP_SIZE)
+		return false;
+
+	if (vcap_api_check(vctrl))
+		return false;
+
+	admin = vcap_find_admin(vctrl, cur_cid);
+	if (!admin)
+		return false;
+
+	/* If no VCAP contains the next chain, the next chain must be beyond
+	 * the last chain in the current VCAP
+	 */
+	next_admin = vcap_find_admin(vctrl, next_cid);
+	if (!next_admin)
+		return next_cid > admin->last_cid;
+
+	lookup = vcap_chain_id_to_lookup(admin, cur_cid);
+	next_lookup = vcap_chain_id_to_lookup(next_admin, next_cid);
+
+	/* Next lookup must be the following lookup */
+	if (admin == next_admin || admin->vtype == next_admin->vtype)
+		return next_lookup == lookup + 1;
+
+	/* Must be the first lookup in the next VCAP instance */
+	return next_lookup == 0;
+}
+EXPORT_SYMBOL_GPL(vcap_is_next_lookup);
+
 /* Check if there is room for a new rule */
 static int vcap_rule_space(struct vcap_admin *admin, int size)
 {
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
index 7d9a227ef834..5cecb12edec2 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
@@ -193,6 +193,8 @@ const struct vcap_field *vcap_lookup_keyfield(struct vcap_rule *rule,
 					      enum vcap_key_field key);
 /* Find a rule id with a provided cookie */
 int vcap_lookup_rule_by_cookie(struct vcap_control *vctrl, u64 cookie);
+/* Is the next chain id in the following lookup, possible in another VCAP */
+bool vcap_is_next_lookup(struct vcap_control *vctrl, int cur_cid, int next_cid);
 
 /* Copy to host byte order */
 void vcap_netbytes_copy(u8 *dst, u8 *src, int count);
-- 
2.38.1


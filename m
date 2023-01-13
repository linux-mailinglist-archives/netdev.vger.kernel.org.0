Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B27F3669076
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 09:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241044AbjAMIQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 03:16:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232913AbjAMIPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 03:15:53 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 752036B193;
        Fri, 13 Jan 2023 00:14:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673597698; x=1705133698;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HUxs7myYM1/33LqA8lbJVWFyfxefzrP59orf/XuptpE=;
  b=Y8UKKHYPYzOAIQNooqmbCCwSu10E7mIk1Pdc6n+sf1GwSYt/ABEjHKS0
   XeArWWX7ptAJvhQ+JFtzA2EAIsa1TE+xSKuHGvY8VOMR5J2OPlaGtqcI5
   XK4gHZ7YJEbyd1xb5hojoRKfkLhqN414wE6R/os/C/ZuHyZhI0WFxhpwO
   x/9SDnA6AQihQ9+mSSq6dPkpc9RlOA6tsx6Ejbn8drAkPcK18hR1UoeIT
   g+aTt9/BciOqfDPAp0+7gwOQaDYnjwp0bc/q+ceDEC4MJ6UKdGRstKT3N
   NwZUUGeR0qIKY4yTUPTu4DHlt9Ckzv3qShUeMLPS7zU+nfro4uSeAGWsz
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,213,1669100400"; 
   d="scan'208";a="207622624"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Jan 2023 01:14:57 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 13 Jan 2023 01:14:57 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 13 Jan 2023 01:14:53 -0700
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
Subject: [PATCH net-next v3 6/8] net: microchip: vcap api: Check chains when adding a tc flower filter
Date:   Fri, 13 Jan 2023 09:14:22 +0100
Message-ID: <20230113081424.3505035-7-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230113081424.3505035-1-steen.hegelund@microchip.com>
References: <20230113081424.3505035-1-steen.hegelund@microchip.com>
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

This changes the way the chain information verified when adding a new tc
flower filter.

When adding a flower filter it is now checked that the filter contains a
goto action to one of the IS2 VCAP lookups, except for the last lookup
which may omit this goto action.

It is also checked if you attempt to add multiple matchall filters to
enable the same VCAP lookup.  This will be rejected.

Fixes: 4426b78c626d ("net: lan966x: Add port keyset config and callback interface")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../microchip/lan966x/lan966x_tc_flower.c     | 30 +++++-----
 .../microchip/sparx5/sparx5_tc_flower.c       | 28 +++++----
 .../net/ethernet/microchip/vcap/vcap_api.c    | 59 +++++++++++--------
 .../ethernet/microchip/vcap/vcap_api_client.h |  2 +
 .../ethernet/microchip/vcap/vcap_api_kunit.c  |  8 +--
 5 files changed, 72 insertions(+), 55 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
index ba3fa917d6b7..b66a8725a071 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
@@ -82,8 +82,8 @@ static int lan966x_tc_flower_use_dissectors(struct flow_cls_offload *f,
 }
 
 static int lan966x_tc_flower_action_check(struct vcap_control *vctrl,
-					  struct flow_cls_offload *fco,
-					  struct vcap_admin *admin)
+					  struct net_device *dev,
+					  struct flow_cls_offload *fco)
 {
 	struct flow_rule *rule = flow_cls_offload_flow_rule(fco);
 	struct flow_action_entry *actent, *last_actent = NULL;
@@ -109,21 +109,23 @@ static int lan966x_tc_flower_action_check(struct vcap_control *vctrl,
 		last_actent = actent; /* Save last action for later check */
 	}
 
-	/* Check that last action is a goto */
-	if (last_actent->id != FLOW_ACTION_GOTO) {
+	/* Check that last action is a goto
+	 * The last chain/lookup does not need to have goto action
+	 */
+	if (last_actent->id == FLOW_ACTION_GOTO) {
+		/* Check if the destination chain is in one of the VCAPs */
+		if (!vcap_is_next_lookup(vctrl, fco->common.chain_index,
+					 last_actent->chain_index)) {
+			NL_SET_ERR_MSG_MOD(fco->common.extack,
+					   "Invalid goto chain");
+			return -EINVAL;
+		}
+	} else if (!vcap_is_last_chain(vctrl, fco->common.chain_index)) {
 		NL_SET_ERR_MSG_MOD(fco->common.extack,
 				   "Last action must be 'goto'");
 		return -EINVAL;
 	}
 
-	/* Check if the goto chain is in the next lookup */
-	if (!vcap_is_next_lookup(vctrl, fco->common.chain_index,
-				 last_actent->chain_index)) {
-		NL_SET_ERR_MSG_MOD(fco->common.extack,
-				   "Invalid goto chain");
-		return -EINVAL;
-	}
-
 	/* Catch unsupported combinations of actions */
 	if (action_mask & BIT(FLOW_ACTION_TRAP) &&
 	    action_mask & BIT(FLOW_ACTION_ACCEPT)) {
@@ -145,8 +147,8 @@ static int lan966x_tc_flower_add(struct lan966x_port *port,
 	struct vcap_rule *vrule;
 	int err, idx;
 
-	err = lan966x_tc_flower_action_check(port->lan966x->vcap_ctrl, f,
-					     admin);
+	err = lan966x_tc_flower_action_check(port->lan966x->vcap_ctrl,
+					     port->dev, f);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
index 1ed304a816cc..986e41d3bb28 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
@@ -573,8 +573,8 @@ static int sparx5_tc_use_dissectors(struct flow_cls_offload *fco,
 }
 
 static int sparx5_tc_flower_action_check(struct vcap_control *vctrl,
-					 struct flow_cls_offload *fco,
-					 struct vcap_admin *admin)
+					 struct net_device *ndev,
+					 struct flow_cls_offload *fco)
 {
 	struct flow_rule *rule = flow_cls_offload_flow_rule(fco);
 	struct flow_action_entry *actent, *last_actent = NULL;
@@ -600,21 +600,23 @@ static int sparx5_tc_flower_action_check(struct vcap_control *vctrl,
 		last_actent = actent; /* Save last action for later check */
 	}
 
-	/* Check that last action is a goto */
-	if (last_actent->id != FLOW_ACTION_GOTO) {
+	/* Check if last action is a goto
+	 * The last chain/lookup does not need to have a goto action
+	 */
+	if (last_actent->id == FLOW_ACTION_GOTO) {
+		/* Check if the destination chain is in one of the VCAPs */
+		if (!vcap_is_next_lookup(vctrl, fco->common.chain_index,
+					 last_actent->chain_index)) {
+			NL_SET_ERR_MSG_MOD(fco->common.extack,
+					   "Invalid goto chain");
+			return -EINVAL;
+		}
+	} else if (!vcap_is_last_chain(vctrl, fco->common.chain_index)) {
 		NL_SET_ERR_MSG_MOD(fco->common.extack,
 				   "Last action must be 'goto'");
 		return -EINVAL;
 	}
 
-	/* Check if the goto chain is in the next lookup */
-	if (!vcap_is_next_lookup(vctrl, fco->common.chain_index,
-				 last_actent->chain_index)) {
-		NL_SET_ERR_MSG_MOD(fco->common.extack,
-				   "Invalid goto chain");
-		return -EINVAL;
-	}
-
 	/* Catch unsupported combinations of actions */
 	if (action_mask & BIT(FLOW_ACTION_TRAP) &&
 	    action_mask & BIT(FLOW_ACTION_ACCEPT)) {
@@ -833,7 +835,7 @@ static int sparx5_tc_flower_replace(struct net_device *ndev,
 
 	vctrl = port->sparx5->vcap_ctrl;
 
-	err = sparx5_tc_flower_action_check(vctrl, fco, admin);
+	err = sparx5_tc_flower_action_check(vctrl, ndev, fco);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index a5572bcab8e6..2cc6e94077a4 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -1553,39 +1553,31 @@ struct vcap_admin *vcap_find_admin(struct vcap_control *vctrl, int cid)
 }
 EXPORT_SYMBOL_GPL(vcap_find_admin);
 
-/* Is the next chain id in the following lookup, possible in another VCAP */
-bool vcap_is_next_lookup(struct vcap_control *vctrl, int cur_cid, int next_cid)
+/* Is the next chain id in one of the following lookups
+ * For now this does not support filters linked to other filters using
+ * keys and actions. That will be added later.
+ */
+bool vcap_is_next_lookup(struct vcap_control *vctrl, int src_cid, int dst_cid)
 {
-	struct vcap_admin *admin, *next_admin;
-	int lookup, next_lookup;
+	struct vcap_admin *admin;
+	int next_cid;
 
-	/* The offset must be at least one lookup */
-	if (next_cid < cur_cid + VCAP_CID_LOOKUP_SIZE)
+	if (vcap_api_check(vctrl))
 		return false;
 
-	if (vcap_api_check(vctrl))
+	/* The offset must be at least one lookup, round up */
+	next_cid = src_cid + VCAP_CID_LOOKUP_SIZE;
+	next_cid /= VCAP_CID_LOOKUP_SIZE;
+	next_cid *= VCAP_CID_LOOKUP_SIZE;
+
+	if (dst_cid < next_cid)
 		return false;
 
-	admin = vcap_find_admin(vctrl, cur_cid);
+	admin = vcap_find_admin(vctrl, dst_cid);
 	if (!admin)
 		return false;
 
-	/* If no VCAP contains the next chain, the next chain must be beyond
-	 * the last chain in the current VCAP
-	 */
-	next_admin = vcap_find_admin(vctrl, next_cid);
-	if (!next_admin)
-		return next_cid > admin->last_cid;
-
-	lookup = vcap_chain_id_to_lookup(admin, cur_cid);
-	next_lookup = vcap_chain_id_to_lookup(next_admin, next_cid);
-
-	/* Next lookup must be the following lookup */
-	if (admin == next_admin || admin->vtype == next_admin->vtype)
-		return next_lookup == lookup + 1;
-
-	/* Must be the first lookup in the next VCAP instance */
-	return next_lookup == 0;
+	return true;
 }
 EXPORT_SYMBOL_GPL(vcap_is_next_lookup);
 
@@ -2718,6 +2710,25 @@ int vcap_enable_lookups(struct vcap_control *vctrl, struct net_device *ndev,
 }
 EXPORT_SYMBOL_GPL(vcap_enable_lookups);
 
+/* Is this chain id the last lookup of all VCAPs */
+bool vcap_is_last_chain(struct vcap_control *vctrl, int cid)
+{
+	struct vcap_admin *admin;
+	int lookup;
+
+	if (vcap_api_check(vctrl))
+		return false;
+
+	admin = vcap_find_admin(vctrl, cid);
+	if (!admin)
+		return false;
+
+	/* This must be the last lookup in this VCAP type */
+	lookup = vcap_chain_id_to_lookup(admin, cid);
+	return lookup == admin->lookups - 1;
+}
+EXPORT_SYMBOL_GPL(vcap_is_last_chain);
+
 /* Set a rule counter id (for certain vcaps only) */
 void vcap_rule_set_counter_id(struct vcap_rule *rule, u32 counter_id)
 {
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
index e07dc8d3c639..f44228436051 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
@@ -217,6 +217,8 @@ const struct vcap_field *vcap_lookup_keyfield(struct vcap_rule *rule,
 int vcap_lookup_rule_by_cookie(struct vcap_control *vctrl, u64 cookie);
 /* Is the next chain id in the following lookup, possible in another VCAP */
 bool vcap_is_next_lookup(struct vcap_control *vctrl, int cur_cid, int next_cid);
+/* Is this chain id the last lookup of all VCAPs */
+bool vcap_is_last_chain(struct vcap_control *vctrl, int cid);
 /* Provide all rules via a callback interface */
 int vcap_rule_iter(struct vcap_control *vctrl,
 		   int (*callback)(void *, struct vcap_rule *), void *arg);
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
index cc6a62338162..fdef9102a9b3 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
@@ -1865,7 +1865,7 @@ static void vcap_api_next_lookup_basic_test(struct kunit *test)
 	ret = vcap_is_next_lookup(&test_vctrl, 8300000, 8301000);
 	KUNIT_EXPECT_EQ(test, false, ret);
 	ret = vcap_is_next_lookup(&test_vctrl, 8300000, 8401000);
-	KUNIT_EXPECT_EQ(test, true, ret);
+	KUNIT_EXPECT_EQ(test, false, ret);
 }
 
 static void vcap_api_next_lookup_advanced_test(struct kunit *test)
@@ -1926,9 +1926,9 @@ static void vcap_api_next_lookup_advanced_test(struct kunit *test)
 	ret = vcap_is_next_lookup(&test_vctrl, 1100000, 1201000);
 	KUNIT_EXPECT_EQ(test, true, ret);
 	ret = vcap_is_next_lookup(&test_vctrl, 1100000, 1301000);
-	KUNIT_EXPECT_EQ(test, false, ret);
+	KUNIT_EXPECT_EQ(test, true, ret);
 	ret = vcap_is_next_lookup(&test_vctrl, 1100000, 8101000);
-	KUNIT_EXPECT_EQ(test, false, ret);
+	KUNIT_EXPECT_EQ(test, true, ret);
 	ret = vcap_is_next_lookup(&test_vctrl, 1300000, 1401000);
 	KUNIT_EXPECT_EQ(test, true, ret);
 	ret = vcap_is_next_lookup(&test_vctrl, 1400000, 1501000);
@@ -1944,7 +1944,7 @@ static void vcap_api_next_lookup_advanced_test(struct kunit *test)
 	ret = vcap_is_next_lookup(&test_vctrl, 8300000, 8301000);
 	KUNIT_EXPECT_EQ(test, false, ret);
 	ret = vcap_is_next_lookup(&test_vctrl, 8300000, 8401000);
-	KUNIT_EXPECT_EQ(test, true, ret);
+	KUNIT_EXPECT_EQ(test, false, ret);
 }
 
 static void vcap_api_filter_unsupported_keys_test(struct kunit *test)
-- 
2.39.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA6116531B6
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 14:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234352AbiLUN1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 08:27:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234411AbiLUN0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 08:26:25 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30DFC23EB0;
        Wed, 21 Dec 2022 05:26:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1671629161; x=1703165161;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bpHk6sTN8PVAmzAuUUvN2naSStnPanPMw4vOz0P3M/Y=;
  b=rpE+g3KS6YWLqnp8bIlqN1b2eG/7mEBofX/SVgp/x1g/3RCjXF4FHnUW
   Ld5nDA0ketkRgBIEdfVpDOiQlTObCFZQjcT06JTm2Zx7Ay+Sfp6x8ZYSh
   tNB30esOazOJ/JvdVuW3erO7+btjE53L5NrHqx+gyyJbNh/K88NzO4Nb9
   5fCfob4RYRjSOEYy0yc75/IOjVvStOnDRQ/79MuDr+hZG09dU02FzRJdo
   tSqIfHtSWcPxGdR4TgeTYJjpg50hTBTYYyRv6dAETOVsH75W5GVH2KGmw
   tMi2OTesBiN5wtpmZpDjmeCLUrG4f9GDEaKpe9v67D9eOQxpaOR/9QnUu
   A==;
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="192696044"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Dec 2022 06:25:59 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 21 Dec 2022 06:25:56 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Wed, 21 Dec 2022 06:25:53 -0700
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
        Dan Carpenter <error27@gmail.com>
Subject: [PATCH net 8/8] net: microchip: vcap api: Enable/Disable rules via chains in VCAP HW
Date:   Wed, 21 Dec 2022 14:25:17 +0100
Message-ID: <20221221132517.2699698-9-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221221132517.2699698-1-steen.hegelund@microchip.com>
References: <20221221132517.2699698-1-steen.hegelund@microchip.com>
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

This supports that individual rules are enabled and disabled via chain
information.
This is done by keeping disabled rules in the VCAP list (cached) until they
are enabled, and only at this time are the rules written to the VCAP HW.

Fixes: 4426b78c626d ("net: lan966x: Add port keyset config and callback interface")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../net/ethernet/microchip/vcap/vcap_api.c    | 195 +++++++++++++++++-
 .../ethernet/microchip/vcap/vcap_api_client.h |   1 -
 .../microchip/vcap/vcap_api_debugfs.c         |  11 +-
 .../ethernet/microchip/vcap/vcap_api_kunit.c  |  11 +-
 .../microchip/vcap/vcap_api_private.h         |   3 +
 5 files changed, 211 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index 94df0e7b58ea..7cb7086248c3 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -2025,8 +2025,6 @@ static void vcap_rule_set_state(struct vcap_rule_internal *ri)
 		ri->state = VCAP_RS_ENABLED;
 	else
 		ri->state = VCAP_RS_DISABLED;
-	/* For now always store directly in HW */
-	ri->state = VCAP_RS_PERMANENT;
 }
 
 /* Encode and write a validated rule to the VCAP */
@@ -2709,6 +2707,119 @@ void vcap_set_tc_exterr(struct flow_cls_offload *fco, struct vcap_rule *vrule)
 }
 EXPORT_SYMBOL_GPL(vcap_set_tc_exterr);
 
+/* Write a rule to VCAP HW to enable it */
+static int vcap_enable_rule(struct vcap_rule_internal *ri)
+{
+	struct vcap_client_actionfield *af, *naf;
+	struct vcap_client_keyfield *kf, *nkf;
+
+	vcap_erase_cache(ri);
+	vcap_encode_rule(ri);
+	vcap_write_rule(ri);
+
+	/* Deallocate the list of keys and actions */
+	list_for_each_entry_safe(kf, nkf, &ri->data.keyfields, ctrl.list) {
+		list_del(&kf->ctrl.list);
+		kfree(kf);
+	}
+	list_for_each_entry_safe(af, naf, &ri->data.actionfields, ctrl.list) {
+		list_del(&af->ctrl.list);
+		kfree(af);
+	}
+	ri->state = VCAP_RS_ENABLED;
+	return 0;
+}
+
+/* Enable all disabled rules for a specific chain/port in the VCAP HW */
+static int vcap_enable_rules(struct vcap_control *vctrl,
+			     struct net_device *ndev, int chain)
+{
+	struct vcap_rule_internal *ri;
+	struct vcap_admin *admin;
+	int err = 0;
+
+	list_for_each_entry(admin, &vctrl->list, list) {
+		if (!(chain >= admin->first_cid && chain <= admin->last_cid))
+			continue;
+
+		/* Found the admin, now find the offloadable rules */
+		mutex_lock(&admin->lock);
+		list_for_each_entry(ri, &admin->rules, list) {
+			if (ri->data.vcap_chain_id != chain)
+				continue;
+
+			if (ri->ndev != ndev)
+				continue;
+
+			if (ri->state != VCAP_RS_DISABLED)
+				continue;
+
+			err = vcap_enable_rule(ri);
+			if (err)
+				break;
+		}
+		mutex_unlock(&admin->lock);
+		if (err)
+			break;
+	}
+	return err;
+}
+
+/* Read and erase a rule from VCAP HW to disable it */
+static int vcap_disable_rule(struct vcap_rule_internal *ri)
+{
+	int err;
+
+	err = vcap_read_rule(ri);
+	if (err)
+		return err;
+	err = vcap_decode_keyset(ri);
+	if (err)
+		return err;
+	err = vcap_decode_actionset(ri);
+	if (err)
+		return err;
+
+	ri->state = VCAP_RS_DISABLED;
+	ri->vctrl->ops->init(ri->ndev, ri->admin, ri->addr, ri->size);
+	return 0;
+}
+
+/* Disable all enabled rules for a specific chain/port in the VCAP HW */
+static int vcap_disable_rules(struct vcap_control *vctrl,
+			      struct net_device *ndev, int chain)
+{
+	struct vcap_rule_internal *ri;
+	struct vcap_admin *admin;
+	int err = 0;
+
+	list_for_each_entry(admin, &vctrl->list, list) {
+		if (!(chain >= admin->first_cid && chain <= admin->last_cid))
+			continue;
+
+		/* Found the admin, now find the rules on the chain */
+		mutex_lock(&admin->lock);
+		list_for_each_entry(ri, &admin->rules, list) {
+			if (ri->data.vcap_chain_id != chain)
+				continue;
+
+			if (ri->ndev != ndev)
+				continue;
+
+			if (ri->state != VCAP_RS_ENABLED)
+				continue;
+
+			err = vcap_disable_rule(ri);
+			if (err)
+				break;
+		}
+		mutex_unlock(&admin->lock);
+		if (err)
+			break;
+	}
+	return err;
+}
+
 /* Check if this port is already enabled for this VCAP instance */
 static bool vcap_is_enabled(struct vcap_control *vctrl, struct net_device *ndev,
 			    int dst_cid)
@@ -2750,6 +2861,15 @@ static int vcap_enable(struct vcap_control *vctrl, struct net_device *ndev,
 	list_add_tail(&eport->list, &admin->enabled);
 	mutex_unlock(&admin->lock);
 
+	/* Enable chained lookups */
+	while (dst_cid) {
+		admin = vcap_find_admin(vctrl, dst_cid);
+		if (!admin)
+			return -ENOENT;
+
+		vcap_enable_rules(vctrl, ndev, dst_cid);
+		dst_cid = vcap_get_next_chain(vctrl, ndev, dst_cid);
+	}
 	return 0;
 }
 
@@ -2759,6 +2879,7 @@ static int vcap_disable(struct vcap_control *vctrl, struct net_device *ndev,
 {
 	struct vcap_enabled_port *elem, *eport = NULL;
 	struct vcap_admin *found = NULL, *admin;
+	int dst_cid;
 
 	list_for_each_entry(admin, &vctrl->list, list) {
 		list_for_each_entry(elem, &admin->enabled, list) {
@@ -2775,6 +2896,17 @@ static int vcap_disable(struct vcap_control *vctrl, struct net_device *ndev,
 	if (!eport)
 		return -ENOENT;
 
+	/* Disable chained lookups */
+	dst_cid = eport->dst_cid;
+	while (dst_cid) {
+		admin = vcap_find_admin(vctrl, dst_cid);
+		if (!admin)
+			return -ENOENT;
+
+		vcap_disable_rules(vctrl, ndev, dst_cid);
+		dst_cid = vcap_get_next_chain(vctrl, ndev, dst_cid);
+	}
+
 	mutex_lock(&found->lock);
 	list_del(&eport->list);
 	mutex_unlock(&found->lock);
@@ -2901,6 +3033,65 @@ int vcap_rule_get_counter(struct vcap_rule *rule, struct vcap_counter *ctr)
 }
 EXPORT_SYMBOL_GPL(vcap_rule_get_counter);
 
+/* Get a copy of a client key field */
+static int vcap_rule_get_key(struct vcap_rule *rule,
+			     enum vcap_key_field key,
+			     struct vcap_client_keyfield *ckf)
+{
+	struct vcap_client_keyfield *field;
+
+	field = vcap_find_keyfield(rule, key);
+	if (!field)
+		return -EINVAL;
+	memcpy(ckf, field, sizeof(*ckf));
+	INIT_LIST_HEAD(&ckf->ctrl.list);
+	return 0;
+}
+
+/* Get the keysets that matches the rule key type/mask */
+int vcap_rule_get_keysets(struct vcap_rule_internal *ri,
+			  struct vcap_keyset_list *matches)
+{
+	struct vcap_control *vctrl = ri->vctrl;
+	enum vcap_type vt = ri->admin->vtype;
+	const struct vcap_set *keyfield_set;
+	struct vcap_client_keyfield kf = {};
+	u32 value, mask;
+	int err, idx;
+
+	err = vcap_rule_get_key(&ri->data, VCAP_KF_TYPE, &kf);
+	if (err)
+		return err;
+
+	if (kf.ctrl.type == VCAP_FIELD_BIT) {
+		value = kf.data.u1.value;
+		mask = kf.data.u1.mask;
+	} else if (kf.ctrl.type == VCAP_FIELD_U32) {
+		value = kf.data.u32.value;
+		mask = kf.data.u32.mask;
+	} else {
+		return -EINVAL;
+	}
+
+	keyfield_set = vctrl->vcaps[vt].keyfield_set;
+	for (idx = 0; idx < vctrl->vcaps[vt].keyfield_set_size; ++idx) {
+		if (keyfield_set[idx].sw_per_item != ri->keyset_sw)
+			continue;
+
+		if (keyfield_set[idx].type_id == (u8)-1) {
+			vcap_keyset_list_add(matches, idx);
+			continue;
+		}
+
+		if ((keyfield_set[idx].type_id & mask) == value)
+			vcap_keyset_list_add(matches, idx);
+	}
+	if (matches->cnt > 0)
+		return 0;
+
+	return -EINVAL;
+}
+
 static int vcap_rule_mod_key(struct vcap_rule *rule,
 			     enum vcap_key_field key,
 			     enum vcap_field_type ftype,
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
index f44228436051..b8980b22352f 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
@@ -264,5 +264,4 @@ int vcap_rule_mod_action_u32(struct vcap_rule *rule,
 /* Get a 32 bit key field value and mask from the rule */
 int vcap_rule_get_key_u32(struct vcap_rule *rule, enum vcap_key_field key,
 			  u32 *value, u32 *mask);
-
 #endif /* __VCAP_API_CLIENT__ */
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
index d6a09ce75e4f..dc06f6d4f513 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
@@ -164,10 +164,13 @@ static int vcap_debugfs_show_keysets(struct vcap_rule_internal *ri,
 	matches.cnt = 0;
 	matches.max = ARRAY_SIZE(keysets);
 
-	err = vcap_find_keystream_keysets(ri->vctrl, admin->vtype,
-					  admin->cache.keystream,
-					  admin->cache.maskstream,
-					  false, 0, &matches);
+	if (ri->state == VCAP_RS_DISABLED)
+		err = vcap_rule_get_keysets(ri, &matches);
+	else
+		err = vcap_find_keystream_keysets(ri->vctrl, admin->vtype,
+						  admin->cache.keystream,
+						  admin->cache.maskstream,
+						  false, 0, &matches);
 	if (err) {
 		pr_err("%s:%d: could not find valid keysets: %d\n",
 		       __func__, __LINE__, err);
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
index fdef9102a9b3..22690c669028 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
@@ -1305,8 +1305,8 @@ static void vcap_api_encode_rule_test(struct kunit *test)
 
 	struct vcap_admin is2_admin = {
 		.vtype = VCAP_TYPE_IS2,
-		.first_cid = 10000,
-		.last_cid = 19999,
+		.first_cid = 8000000,
+		.last_cid = 8099999,
 		.lookups = 4,
 		.last_valid_addr = 3071,
 		.first_valid_addr = 0,
@@ -1319,7 +1319,7 @@ static void vcap_api_encode_rule_test(struct kunit *test)
 	};
 	struct vcap_rule *rule;
 	struct vcap_rule_internal *ri;
-	int vcap_chain_id = 10005;
+	int vcap_chain_id = 8000000;
 	enum vcap_user user = VCAP_USER_VCAP_UTIL;
 	u16 priority = 10;
 	int id = 100;
@@ -1391,6 +1391,11 @@ static void vcap_api_encode_rule_test(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, 2, ri->keyset_sw_regs);
 	KUNIT_EXPECT_EQ(test, 4, ri->actionset_sw_regs);
 
+	/* Enable lookup, so the rule will be written */
+	ret = vcap_enable_lookups(&test_vctrl, &test_netdev, 0,
+				  rule->vcap_chain_id, rule->cookie, true);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+
 	/* Add rule with write callback */
 	ret = vcap_add_rule(rule);
 	KUNIT_EXPECT_EQ(test, 0, ret);
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_private.h b/drivers/net/ethernet/microchip/vcap/vcap_api_private.h
index ce35af9a853d..86542accffe6 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_private.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_private.h
@@ -115,4 +115,7 @@ int vcap_find_keystream_keysets(struct vcap_control *vctrl, enum vcap_type vt,
 				u32 *keystream, u32 *mskstream, bool mask,
 				int sw_max, struct vcap_keyset_list *kslist);
 
+/* Get the keysets that matches the rule key type/mask */
+int vcap_rule_get_keysets(struct vcap_rule_internal *ri,
+			  struct vcap_keyset_list *matches);
 #endif /* __VCAP_API_PRIVATE__ */
-- 
2.39.0


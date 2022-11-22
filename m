Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78251633FB2
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 16:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234238AbiKVPBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 10:01:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234227AbiKVPAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 10:00:49 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8604371F03;
        Tue, 22 Nov 2022 06:59:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669129196; x=1700665196;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aOXQOQtlrELBIyuq9bhOlkOu6tSjScHBE2oELpwzY7g=;
  b=rlrVuUON1hVADZUlFbicRQWu3NLjeE0MsUmijYYLJO1v7ZkHAyvbXCBz
   aKOzXnq921SrFmVqJxkyvSQUL4H7ow9xExsWyvxdmbjQZ2RVQqmnUb8Dv
   EpUaMD2SziarEmYMaealscJyj3GMBk53OR2LnsepkspjGrcKudjW4QW8I
   ZwgbcUCfyA1MTYNr6oOu60LVRcfqBJxh+mWMFvbbxshFRRu0eN3vCxhiL
   fTyxCN4+GWiVi0Cjyik4zTvi7TKSQOJQyhvsiW9nDoPWJKuIMAluP/A2n
   6T7NDpKYM8Q3ZvNYpwZGaVgbno9fbP4qR21C6I+2c5fsOvTtU42EMIrE7
   w==;
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="184689541"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Nov 2022 07:59:55 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 22 Nov 2022 07:59:46 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 22 Nov 2022 07:59:43 -0700
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
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: [PATCH net-next 1/4] net: microchip: sparx5: Support for copying and modifying rules in the API
Date:   Tue, 22 Nov 2022 15:59:35 +0100
Message-ID: <20221122145938.1775954-2-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221122145938.1775954-1-steen.hegelund@microchip.com>
References: <20221122145938.1775954-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for making a copy of a rule and modify keys and actions
to differentiate the copy.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../net/ethernet/microchip/vcap/vcap_api.c    | 185 +++++++++++++++++-
 .../ethernet/microchip/vcap/vcap_api_client.h |  22 ++-
 .../ethernet/microchip/vcap/vcap_api_kunit.c  |   6 +-
 .../microchip/vcap/vcap_api_private.h         |   4 -
 4 files changed, 206 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index ac7a32ff755e..fd45d4bd7052 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -173,6 +173,7 @@ const struct vcap_set *vcap_keyfieldset(struct vcap_control *vctrl,
 		return NULL;
 	return kset;
 }
+EXPORT_SYMBOL_GPL(vcap_keyfieldset);
 
 /* Return the typegroup table for the matching keyset (using subword size) */
 const struct vcap_typegroup *
@@ -824,8 +825,8 @@ vcap_find_keyset_keyfield(struct vcap_control *vctrl,
 }
 
 /* Match a list of keys against the keysets available in a vcap type */
-static bool vcap_rule_find_keysets(struct vcap_rule_internal *ri,
-				   struct vcap_keyset_list *matches)
+static bool _vcap_rule_find_keysets(struct vcap_rule_internal *ri,
+				    struct vcap_keyset_list *matches)
 {
 	const struct vcap_client_keyfield *ckf;
 	int keyset, found, keycount, map_size;
@@ -864,6 +865,16 @@ static bool vcap_rule_find_keysets(struct vcap_rule_internal *ri,
 	return matches->cnt > 0;
 }
 
+/* Match a list of keys against the keysets available in a vcap type */
+bool vcap_rule_find_keysets(struct vcap_rule *rule,
+			    struct vcap_keyset_list *matches)
+{
+	struct vcap_rule_internal *ri = to_intrule(rule);
+
+	return _vcap_rule_find_keysets(ri, matches);
+}
+EXPORT_SYMBOL_GPL(vcap_rule_find_keysets);
+
 /* Validate a rule with respect to available port keys */
 int vcap_val_rule(struct vcap_rule *rule, u16 l3_proto)
 {
@@ -888,7 +899,7 @@ int vcap_val_rule(struct vcap_rule *rule, u16 l3_proto)
 	matches.max = ARRAY_SIZE(keysets);
 	if (ri->data.keyset == VCAP_KFS_NO_VALUE) {
 		/* Iterate over rule keyfields and select keysets that fits */
-		if (!vcap_rule_find_keysets(ri, &matches)) {
+		if (!_vcap_rule_find_keysets(ri, &matches)) {
 			ri->data.exterr = VCAP_ERR_NO_KEYSET_MATCH;
 			return -EINVAL;
 		}
@@ -1270,6 +1281,19 @@ int vcap_del_rules(struct vcap_control *vctrl, struct vcap_admin *admin)
 }
 EXPORT_SYMBOL_GPL(vcap_del_rules);
 
+/* Find a client key field in a rule */
+static struct vcap_client_keyfield *
+vcap_find_keyfield(struct vcap_rule *rule, enum vcap_key_field key)
+{
+	struct vcap_rule_internal *ri = to_intrule(rule);
+	struct vcap_client_keyfield *ckf;
+
+	list_for_each_entry(ckf, &ri->data.keyfields, ctrl.list)
+		if (ckf->ctrl.key == key)
+			return ckf;
+	return NULL;
+}
+
 /* Find information on a key field in a rule */
 const struct vcap_field *vcap_lookup_keyfield(struct vcap_rule *rule,
 					      enum vcap_key_field key)
@@ -1442,6 +1466,19 @@ static void vcap_copy_from_client_actionfield(struct vcap_rule *rule,
 	memcpy(&field->data, data, sizeof(field->data));
 }
 
+/* Find a client action field in a rule */
+static struct vcap_client_actionfield *
+vcap_find_actionfield(struct vcap_rule *rule, enum vcap_action_field act)
+{
+	struct vcap_rule_internal *ri = (struct vcap_rule_internal *)rule;
+	struct vcap_client_actionfield *caf;
+
+	list_for_each_entry(caf, &ri->data.actionfields, ctrl.list)
+		if (caf->ctrl.action == act)
+			return caf;
+	return 0;
+}
+
 /* Check if the actionfield is already in the rule */
 static bool vcap_actionfield_unique(struct vcap_rule *rule,
 				    enum vcap_action_field act)
@@ -1772,6 +1809,148 @@ int vcap_rule_get_counter(struct vcap_rule *rule, struct vcap_counter *ctr)
 }
 EXPORT_SYMBOL_GPL(vcap_rule_get_counter);
 
+static int vcap_rule_mod_key(struct vcap_rule *rule,
+			     enum vcap_key_field key,
+			     enum vcap_field_type ftype,
+			     struct vcap_client_keyfield_data *data)
+{
+	struct vcap_client_keyfield *field;
+
+	field = vcap_find_keyfield(rule, key);
+	if (!field)
+		return vcap_rule_add_key(rule, key, ftype, data);
+	vcap_copy_from_client_keyfield(rule, field, data);
+	return 0;
+}
+
+/* Modify a 32 bit key field with value and mask in the rule */
+int vcap_rule_mod_key_u32(struct vcap_rule *rule, enum vcap_key_field key,
+			  u32 value, u32 mask)
+{
+	struct vcap_client_keyfield_data data;
+
+	data.u32.value = value;
+	data.u32.mask = mask;
+	return vcap_rule_mod_key(rule, key, VCAP_FIELD_U32, &data);
+}
+EXPORT_SYMBOL_GPL(vcap_rule_mod_key_u32);
+
+static int vcap_rule_mod_action(struct vcap_rule *rule,
+				enum vcap_action_field action,
+				enum vcap_field_type ftype,
+				struct vcap_client_actionfield_data *data)
+{
+	struct vcap_client_actionfield *field;
+
+	field = vcap_find_actionfield(rule, action);
+	if (!field)
+		return vcap_rule_add_action(rule, action, ftype, data);
+	vcap_copy_from_client_actionfield(rule, field, data);
+	return 0;
+}
+
+/* Modify a 32 bit action field with value in the rule */
+int vcap_rule_mod_action_u32(struct vcap_rule *rule,
+			     enum vcap_action_field action,
+			     u32 value)
+{
+	struct vcap_client_actionfield_data data;
+
+	data.u32.value = value;
+	return vcap_rule_mod_action(rule, action, VCAP_FIELD_U32, &data);
+}
+EXPORT_SYMBOL_GPL(vcap_rule_mod_action_u32);
+
+/* Drop keys in a keylist and any keys that are not supported by the keyset */
+int vcap_filter_rule_keys(struct vcap_rule *rule,
+			  enum vcap_key_field keylist[], int length,
+			  bool drop_unsupported)
+{
+	struct vcap_rule_internal *ri = to_intrule(rule);
+	struct vcap_client_keyfield *ckf, *next_ckf;
+	const struct vcap_field *fields;
+	enum vcap_key_field key;
+	int err = 0;
+	int idx;
+
+	if (length > 0) {
+		err = -EEXIST;
+		list_for_each_entry_safe(ckf, next_ckf,
+					 &ri->data.keyfields, ctrl.list) {
+			key = ckf->ctrl.key;
+			for (idx = 0; idx < length; ++idx)
+				if (key == keylist[idx]) {
+					list_del(&ckf->ctrl.list);
+					kfree(ckf);
+					idx++;
+					err = 0;
+				}
+		}
+	}
+	if (drop_unsupported) {
+		err = -EEXIST;
+		fields = vcap_keyfields(ri->vctrl, ri->admin->vtype,
+					rule->keyset);
+		if (!fields)
+			return err;
+		list_for_each_entry_safe(ckf, next_ckf,
+					 &ri->data.keyfields, ctrl.list) {
+			key = ckf->ctrl.key;
+			if (fields[key].width == 0) {
+				list_del(&ckf->ctrl.list);
+				kfree(ckf);
+				err = 0;
+			}
+		}
+	}
+	return err;
+}
+EXPORT_SYMBOL_GPL(vcap_filter_rule_keys);
+
+/* Make a full copy of an existing rule with a new rule id */
+struct vcap_rule *vcap_copy_rule(struct vcap_rule *erule)
+{
+	struct vcap_rule_internal *ri = to_intrule(erule);
+	struct vcap_client_actionfield *caf;
+	struct vcap_client_keyfield *ckf;
+	struct vcap_rule *rule;
+	int err;
+
+	err = vcap_api_check(ri->vctrl);
+	if (err)
+		return ERR_PTR(err);
+
+	rule = vcap_alloc_rule(ri->vctrl, ri->ndev, ri->data.vcap_chain_id,
+			       ri->data.user, ri->data.priority, 0);
+	if (IS_ERR(rule))
+		return rule;
+
+	list_for_each_entry(ckf, &ri->data.keyfields, ctrl.list) {
+		/* Add a key duplicate in the new rule */
+		err = vcap_rule_add_key(rule,
+					ckf->ctrl.key,
+					ckf->ctrl.type,
+					&ckf->data);
+		if (err)
+			goto err;
+	}
+
+	list_for_each_entry(caf, &ri->data.actionfields, ctrl.list) {
+		/* Add a action duplicate in the new rule */
+		err = vcap_rule_add_action(rule,
+					   caf->ctrl.action,
+					   caf->ctrl.type,
+					   &caf->data);
+		if (err)
+			goto err;
+	}
+	return rule;
+err:
+	vcap_free_rule(rule);
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL_GPL(vcap_copy_rule);
+
 #ifdef CONFIG_VCAP_KUNIT_TEST
 #include "vcap_api_kunit.c"
 #endif
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
index 654ef8fa6d62..93a0fcb12a81 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_client.h
@@ -168,6 +168,8 @@ int vcap_val_rule(struct vcap_rule *rule, u16 l3_proto);
 int vcap_add_rule(struct vcap_rule *rule);
 /* Delete rule in a VCAP instance */
 int vcap_del_rule(struct vcap_control *vctrl, struct net_device *ndev, u32 id);
+/* Make a full copy of an existing rule with a new rule id */
+struct vcap_rule *vcap_copy_rule(struct vcap_rule *rule);
 
 /* Update the keyset for the rule */
 int vcap_set_rule_set_keyset(struct vcap_rule *rule,
@@ -213,7 +215,13 @@ bool vcap_is_next_lookup(struct vcap_control *vctrl, int cur_cid, int next_cid);
 /* Provide all rules via a callback interface */
 int vcap_rule_iter(struct vcap_control *vctrl,
 		   int (*callback)(void *, struct vcap_rule *), void *arg);
-
+/* Match a list of keys against the keysets available in a vcap type */
+bool vcap_rule_find_keysets(struct vcap_rule *rule,
+			    struct vcap_keyset_list *matches);
+/* Return the keyset information for the keyset */
+const struct vcap_set *vcap_keyfieldset(struct vcap_control *vctrl,
+					enum vcap_type vt,
+					enum vcap_keyfield_set keyset);
 /* Copy to host byte order */
 void vcap_netbytes_copy(u8 *dst, u8 *src, int count);
 
@@ -226,6 +234,10 @@ int vcap_del_rules(struct vcap_control *vctrl, struct vcap_admin *admin);
 /* Add a keyset to a keyset list */
 bool vcap_keyset_list_add(struct vcap_keyset_list *keysetlist,
 			  enum vcap_keyfield_set keyset);
+/* Drop keys in a keylist and any keys that are not supported by the keyset */
+int vcap_filter_rule_keys(struct vcap_rule *rule,
+			  enum vcap_key_field keylist[], int length,
+			  bool drop_unsupported);
 
 /* map keyset id to a string with the keyset name */
 const char *vcap_keyset_name(struct vcap_control *vctrl,
@@ -234,4 +246,12 @@ const char *vcap_keyset_name(struct vcap_control *vctrl,
 const char *vcap_keyfield_name(struct vcap_control *vctrl,
 			       enum vcap_key_field key);
 
+/* Modify a 32 bit key field with value and mask in the rule */
+int vcap_rule_mod_key_u32(struct vcap_rule *rule, enum vcap_key_field key,
+			  u32 value, u32 mask);
+/* Modify a 32 bit action field with value in the rule */
+int vcap_rule_mod_action_u32(struct vcap_rule *rule,
+			     enum vcap_action_field action,
+			     u32 value);
+
 #endif /* __VCAP_API_CLIENT__ */
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
index f48d93f374af..875068e484c9 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
@@ -1197,7 +1197,7 @@ static void vcap_api_rule_find_keyset_basic_test(struct kunit *test)
 	for (idx = 0; idx < ARRAY_SIZE(ckf); idx++)
 		list_add_tail(&ckf[idx].ctrl.list, &ri.data.keyfields);
 
-	ret = vcap_rule_find_keysets(&ri, &matches);
+	ret = vcap_rule_find_keysets(&ri.data, &matches);
 
 	KUNIT_EXPECT_EQ(test, true, ret);
 	KUNIT_EXPECT_EQ(test, 1, matches.cnt);
@@ -1244,7 +1244,7 @@ static void vcap_api_rule_find_keyset_failed_test(struct kunit *test)
 	for (idx = 0; idx < ARRAY_SIZE(ckf); idx++)
 		list_add_tail(&ckf[idx].ctrl.list, &ri.data.keyfields);
 
-	ret = vcap_rule_find_keysets(&ri, &matches);
+	ret = vcap_rule_find_keysets(&ri.data, &matches);
 
 	KUNIT_EXPECT_EQ(test, false, ret);
 	KUNIT_EXPECT_EQ(test, 0, matches.cnt);
@@ -1291,7 +1291,7 @@ static void vcap_api_rule_find_keyset_many_test(struct kunit *test)
 	for (idx = 0; idx < ARRAY_SIZE(ckf); idx++)
 		list_add_tail(&ckf[idx].ctrl.list, &ri.data.keyfields);
 
-	ret = vcap_rule_find_keysets(&ri, &matches);
+	ret = vcap_rule_find_keysets(&ri.data, &matches);
 
 	KUNIT_EXPECT_EQ(test, true, ret);
 	KUNIT_EXPECT_EQ(test, 6, matches.cnt);
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_private.h b/drivers/net/ethernet/microchip/vcap/vcap_api_private.h
index 18a9a0cd9606..9ac1b1d55f22 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api_private.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_private.h
@@ -59,10 +59,6 @@ void vcap_iter_update(struct vcap_stream_iter *itr);
 
 /* Keyset and keyfield functionality */
 
-/* Return the keyset information for the keyset */
-const struct vcap_set *vcap_keyfieldset(struct vcap_control *vctrl,
-					enum vcap_type vt,
-					enum vcap_keyfield_set keyset);
 /* Return the number of keyfields in the keyset */
 int vcap_keyfield_count(struct vcap_control *vctrl,
 			enum vcap_type vt, enum vcap_keyfield_set keyset);
-- 
2.38.1


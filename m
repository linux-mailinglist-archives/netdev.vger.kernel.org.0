Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFD26531A8
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 14:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234519AbiLUN0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 08:26:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233998AbiLUN0E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 08:26:04 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E74716542;
        Wed, 21 Dec 2022 05:25:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1671629144; x=1703165144;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0Ai3AdOaVUKkeG8sPdg+HtDttdNe05yjc952xrLqJl0=;
  b=SV/Lsoc/SPjrc8uz5jqnxLXg1bz6dFWzKpDR7QUexkHxY6xPdFTXNoio
   0imP3a0mprg46e86IL6ACL0pPc9nNXAVlol7BRtJ/oI8eO/bqa9xRbFD1
   wtcaP1HyZfRdaxfXQeCuAHIKqfRVUCQpJwAt9xQiWD072+p5gkrLhQ/7g
   i4V4q28QuWx450wo0z42oTi70ILMaSY5Qp1DVsLtdFrwAZFfqZK+UmeS5
   /RwegsJS1EFFcJ2uTrDcHJroFeA9MYY8Cp66hwe8hm2y+tCEqG9Kyi7ZA
   SyXxTDmMbHFCXz89w6hadQEQQF+temL/Nx5VjtDKkiGFetMK9M81Gp5kC
   A==;
X-IronPort-AV: E=Sophos;i="5.96,262,1665471600"; 
   d="scan'208";a="193965102"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Dec 2022 06:25:42 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 21 Dec 2022 06:25:42 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Wed, 21 Dec 2022 06:25:38 -0700
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
Subject: [PATCH net 4/8] net: microchip: vcap api: Convert multi-word keys/actions when encoding
Date:   Wed, 21 Dec 2022 14:25:13 +0100
Message-ID: <20221221132517.2699698-5-steen.hegelund@microchip.com>
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

The conversion to the platform specific multi-word format is moved from the
key/action add functions to the encoding key/action.
This allows rules that are disabled (not in VCAP HW) to use the same format
for keys/actions as rules that have just been read from VCAP HW.

Fixes: 4426b78c626d ("net: lan966x: Add port keyset config and callback interface")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../net/ethernet/microchip/vcap/vcap_api.c    | 243 ++++++++++--------
 1 file changed, 134 insertions(+), 109 deletions(-)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index 9de5367fde42..486ab2c2baaa 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -508,10 +508,133 @@ static void vcap_encode_keyfield_typegroups(struct vcap_control *vctrl,
 	vcap_encode_typegroups(cache->maskstream, sw_width, tgt, true);
 }
 
+/* Copy data from src to dst but reverse the data in chunks of 32bits.
+ * For example if src is 00:11:22:33:44:55 where 55 is LSB the dst will
+ * have the value 22:33:44:55:00:11.
+ */
+static void vcap_copy_to_w32be(u8 *dst, const u8 *src, int size)
+{
+	for (int idx = 0; idx < size; ++idx) {
+		int first_byte_index = 0;
+		int nidx;
+
+		first_byte_index = size - (((idx >> 2) + 1) << 2);
+		if (first_byte_index < 0)
+			first_byte_index = 0;
+		nidx = idx + first_byte_index - (idx & ~0x3);
+		dst[nidx] = src[idx];
+	}
+}
+
+static void
+vcap_copy_from_client_keyfield(struct vcap_rule *rule,
+			       struct vcap_client_keyfield *dst,
+			       const struct vcap_client_keyfield *src)
+{
+	struct vcap_rule_internal *ri = to_intrule(rule);
+	const struct vcap_client_keyfield_data *sdata;
+	struct vcap_client_keyfield_data *ddata;
+	int size;
+
+	dst->ctrl.type = src->ctrl.type;
+	dst->ctrl.key = src->ctrl.key;
+	INIT_LIST_HEAD(&dst->ctrl.list);
+	sdata = &src->data;
+	ddata = &dst->data;
+
+	if (!ri->admin->w32be) {
+		memcpy(ddata, sdata, sizeof(dst->data));
+		return;
+	}
+
+	size = keyfield_size_table[dst->ctrl.type] / 2;
+
+	switch (dst->ctrl.type) {
+	case VCAP_FIELD_BIT:
+	case VCAP_FIELD_U32:
+		memcpy(ddata, sdata, sizeof(dst->data));
+		break;
+	case VCAP_FIELD_U48:
+		vcap_copy_to_w32be(ddata->u48.value, src->data.u48.value, size);
+		vcap_copy_to_w32be(ddata->u48.mask,  src->data.u48.mask, size);
+		break;
+	case VCAP_FIELD_U56:
+		vcap_copy_to_w32be(ddata->u56.value, sdata->u56.value, size);
+		vcap_copy_to_w32be(ddata->u56.mask,  sdata->u56.mask, size);
+		break;
+	case VCAP_FIELD_U64:
+		vcap_copy_to_w32be(ddata->u64.value, sdata->u64.value, size);
+		vcap_copy_to_w32be(ddata->u64.mask,  sdata->u64.mask, size);
+		break;
+	case VCAP_FIELD_U72:
+		vcap_copy_to_w32be(ddata->u72.value, sdata->u72.value, size);
+		vcap_copy_to_w32be(ddata->u72.mask,  sdata->u72.mask, size);
+		break;
+	case VCAP_FIELD_U112:
+		vcap_copy_to_w32be(ddata->u112.value, sdata->u112.value, size);
+		vcap_copy_to_w32be(ddata->u112.mask,  sdata->u112.mask, size);
+		break;
+	case VCAP_FIELD_U128:
+		vcap_copy_to_w32be(ddata->u128.value, sdata->u128.value, size);
+		vcap_copy_to_w32be(ddata->u128.mask,  sdata->u128.mask, size);
+		break;
+	}
+}
+
+static void
+vcap_copy_from_client_actionfield(struct vcap_rule *rule,
+				  struct vcap_client_actionfield *dst,
+				  const struct vcap_client_actionfield *src)
+{
+	struct vcap_rule_internal *ri = to_intrule(rule);
+	const struct vcap_client_actionfield_data *sdata;
+	struct vcap_client_actionfield_data *ddata;
+	int size;
+
+	dst->ctrl.type = src->ctrl.type;
+	dst->ctrl.action = src->ctrl.action;
+	INIT_LIST_HEAD(&dst->ctrl.list);
+	sdata = &src->data;
+	ddata = &dst->data;
+
+	if (!ri->admin->w32be) {
+		memcpy(ddata, sdata, sizeof(dst->data));
+		return;
+	}
+
+	size = actionfield_size_table[dst->ctrl.type];
+
+	switch (dst->ctrl.type) {
+	case VCAP_FIELD_BIT:
+	case VCAP_FIELD_U32:
+		memcpy(ddata, sdata, sizeof(dst->data));
+		break;
+	case VCAP_FIELD_U48:
+		vcap_copy_to_w32be(ddata->u48.value, sdata->u48.value, size);
+		break;
+	case VCAP_FIELD_U56:
+		vcap_copy_to_w32be(ddata->u56.value, sdata->u56.value, size);
+		break;
+	case VCAP_FIELD_U64:
+		vcap_copy_to_w32be(ddata->u64.value, sdata->u64.value, size);
+		break;
+	case VCAP_FIELD_U72:
+		vcap_copy_to_w32be(ddata->u72.value, sdata->u72.value, size);
+		break;
+	case VCAP_FIELD_U112:
+		vcap_copy_to_w32be(ddata->u112.value, sdata->u112.value, size);
+		break;
+	case VCAP_FIELD_U128:
+		vcap_copy_to_w32be(ddata->u128.value, sdata->u128.value, size);
+		break;
+	}
+}
+
 static int vcap_encode_rule_keyset(struct vcap_rule_internal *ri)
 {
 	const struct vcap_client_keyfield *ckf;
 	const struct vcap_typegroup *tg_table;
+	struct vcap_client_keyfield tempkf;
 	const struct vcap_field *kf_table;
 	int keyset_size;
 
@@ -552,7 +675,9 @@ static int vcap_encode_rule_keyset(struct vcap_rule_internal *ri)
 			       __func__, __LINE__, ckf->ctrl.key);
 			return -EINVAL;
 		}
-		vcap_encode_keyfield(ri, ckf, &kf_table[ckf->ctrl.key], tg_table);
+		vcap_copy_from_client_keyfield(&ri->data, &tempkf, ckf);
+		vcap_encode_keyfield(ri, &tempkf, &kf_table[ckf->ctrl.key],
+				     tg_table);
 	}
 	/* Add typegroup bits to the key/mask bitstreams */
 	vcap_encode_keyfield_typegroups(ri->vctrl, ri, tg_table);
@@ -667,6 +792,7 @@ static int vcap_encode_rule_actionset(struct vcap_rule_internal *ri)
 {
 	const struct vcap_client_actionfield *caf;
 	const struct vcap_typegroup *tg_table;
+	struct vcap_client_actionfield tempaf;
 	const struct vcap_field *af_table;
 	int actionset_size;
 
@@ -707,8 +833,9 @@ static int vcap_encode_rule_actionset(struct vcap_rule_internal *ri)
 			       __func__, __LINE__, caf->ctrl.action);
 			return -EINVAL;
 		}
-		vcap_encode_actionfield(ri, caf, &af_table[caf->ctrl.action],
-					tg_table);
+		vcap_copy_from_client_actionfield(&ri->data, &tempaf, caf);
+		vcap_encode_actionfield(ri, &tempaf,
+					&af_table[caf->ctrl.action], tg_table);
 	}
 	/* Add typegroup bits to the entry bitstreams */
 	vcap_encode_actionfield_typegroups(ri, tg_table);
@@ -2140,69 +2267,6 @@ const struct vcap_field *vcap_lookup_keyfield(struct vcap_rule *rule,
 }
 EXPORT_SYMBOL_GPL(vcap_lookup_keyfield);
 
-/* Copy data from src to dst but reverse the data in chunks of 32bits.
- * For example if src is 00:11:22:33:44:55 where 55 is LSB the dst will
- * have the value 22:33:44:55:00:11.
- */
-static void vcap_copy_to_w32be(u8 *dst, u8 *src, int size)
-{
-	for (int idx = 0; idx < size; ++idx) {
-		int first_byte_index = 0;
-		int nidx;
-
-		first_byte_index = size - (((idx >> 2) + 1) << 2);
-		if (first_byte_index < 0)
-			first_byte_index = 0;
-		nidx = idx + first_byte_index - (idx & ~0x3);
-		dst[nidx] = src[idx];
-	}
-}
-
-static void vcap_copy_from_client_keyfield(struct vcap_rule *rule,
-					   struct vcap_client_keyfield *field,
-					   struct vcap_client_keyfield_data *data)
-{
-	struct vcap_rule_internal *ri = to_intrule(rule);
-	int size;
-
-	if (!ri->admin->w32be) {
-		memcpy(&field->data, data, sizeof(field->data));
-		return;
-	}
-
-	size = keyfield_size_table[field->ctrl.type] / 2;
-	switch (field->ctrl.type) {
-	case VCAP_FIELD_BIT:
-	case VCAP_FIELD_U32:
-		memcpy(&field->data, data, sizeof(field->data));
-		break;
-	case VCAP_FIELD_U48:
-		vcap_copy_to_w32be(field->data.u48.value, data->u48.value, size);
-		vcap_copy_to_w32be(field->data.u48.mask,  data->u48.mask, size);
-		break;
-	case VCAP_FIELD_U56:
-		vcap_copy_to_w32be(field->data.u56.value, data->u56.value, size);
-		vcap_copy_to_w32be(field->data.u56.mask,  data->u56.mask, size);
-		break;
-	case VCAP_FIELD_U64:
-		vcap_copy_to_w32be(field->data.u64.value, data->u64.value, size);
-		vcap_copy_to_w32be(field->data.u64.mask,  data->u64.mask, size);
-		break;
-	case VCAP_FIELD_U72:
-		vcap_copy_to_w32be(field->data.u72.value, data->u72.value, size);
-		vcap_copy_to_w32be(field->data.u72.mask,  data->u72.mask, size);
-		break;
-	case VCAP_FIELD_U112:
-		vcap_copy_to_w32be(field->data.u112.value, data->u112.value, size);
-		vcap_copy_to_w32be(field->data.u112.mask,  data->u112.mask, size);
-		break;
-	case VCAP_FIELD_U128:
-		vcap_copy_to_w32be(field->data.u128.value, data->u128.value, size);
-		vcap_copy_to_w32be(field->data.u128.mask,  data->u128.mask, size);
-		break;
-	}
-}
-
 /* Check if the keyfield is already in the rule */
 static bool vcap_keyfield_unique(struct vcap_rule *rule,
 				 enum vcap_key_field key)
@@ -2260,9 +2324,9 @@ static int vcap_rule_add_key(struct vcap_rule *rule,
 	field = kzalloc(sizeof(*field), GFP_KERNEL);
 	if (!field)
 		return -ENOMEM;
+	memcpy(&field->data, data, sizeof(field->data));
 	field->ctrl.key = key;
 	field->ctrl.type = ftype;
-	vcap_copy_from_client_keyfield(rule, field, data);
 	list_add_tail(&field->ctrl.list, &rule->keyfields);
 	return 0;
 }
@@ -2370,45 +2434,6 @@ vcap_find_actionfield(struct vcap_rule *rule, enum vcap_action_field act)
 	return NULL;
 }
 
-static void vcap_copy_from_client_actionfield(struct vcap_rule *rule,
-					      struct vcap_client_actionfield *field,
-					      struct vcap_client_actionfield_data *data)
-{
-	struct vcap_rule_internal *ri = to_intrule(rule);
-	int size;
-
-	if (!ri->admin->w32be) {
-		memcpy(&field->data, data, sizeof(field->data));
-		return;
-	}
-
-	size = actionfield_size_table[field->ctrl.type];
-	switch (field->ctrl.type) {
-	case VCAP_FIELD_BIT:
-	case VCAP_FIELD_U32:
-		memcpy(&field->data, data, sizeof(field->data));
-		break;
-	case VCAP_FIELD_U48:
-		vcap_copy_to_w32be(field->data.u48.value, data->u48.value, size);
-		break;
-	case VCAP_FIELD_U56:
-		vcap_copy_to_w32be(field->data.u56.value, data->u56.value, size);
-		break;
-	case VCAP_FIELD_U64:
-		vcap_copy_to_w32be(field->data.u64.value, data->u64.value, size);
-		break;
-	case VCAP_FIELD_U72:
-		vcap_copy_to_w32be(field->data.u72.value, data->u72.value, size);
-		break;
-	case VCAP_FIELD_U112:
-		vcap_copy_to_w32be(field->data.u112.value, data->u112.value, size);
-		break;
-	case VCAP_FIELD_U128:
-		vcap_copy_to_w32be(field->data.u128.value, data->u128.value, size);
-		break;
-	}
-}
-
 /* Check if the actionfield is already in the rule */
 static bool vcap_actionfield_unique(struct vcap_rule *rule,
 				    enum vcap_action_field act)
@@ -2466,9 +2491,9 @@ static int vcap_rule_add_action(struct vcap_rule *rule,
 	field = kzalloc(sizeof(*field), GFP_KERNEL);
 	if (!field)
 		return -ENOMEM;
+	memcpy(&field->data, data, sizeof(field->data));
 	field->ctrl.action = action;
 	field->ctrl.type = ftype;
-	vcap_copy_from_client_actionfield(rule, field, data);
 	list_add_tail(&field->ctrl.list, &rule->actionfields);
 	return 0;
 }
@@ -2745,7 +2770,7 @@ static int vcap_rule_mod_key(struct vcap_rule *rule,
 	field = vcap_find_keyfield(rule, key);
 	if (!field)
 		return vcap_rule_add_key(rule, key, ftype, data);
-	vcap_copy_from_client_keyfield(rule, field, data);
+	memcpy(&field->data, data, sizeof(field->data));
 	return 0;
 }
 
@@ -2771,7 +2796,7 @@ static int vcap_rule_mod_action(struct vcap_rule *rule,
 	field = vcap_find_actionfield(rule, action);
 	if (!field)
 		return vcap_rule_add_action(rule, action, ftype, data);
-	vcap_copy_from_client_actionfield(rule, field, data);
+	memcpy(&field->data, data, sizeof(field->data));
 	return 0;
 }
 
-- 
2.39.0


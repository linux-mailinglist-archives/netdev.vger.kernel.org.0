Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F45A6386A3
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 10:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbiKYJta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 04:49:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbiKYJsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 04:48:11 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 134DF2CE20;
        Fri, 25 Nov 2022 01:46:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669369590; x=1700905590;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NkSgy6KZu41L14O9ETqPOz+JPk/OypBvYcM4fdIOt4g=;
  b=AIJnvEDkt/o3kF7NJKZRWWa4f+mAYGm+hTezQJiBVNm+HdI052jp6at4
   2M8O2KxQSbZorS27FxUjQkPbRdEgXD9hadmW10DeCt8SRsQHJvZ3QnvoG
   gxvhB27a0/fJCjrWKM8CNCRDNKGbj12GLvwNhbBwI78QQ1gdK2pNyYi44
   GZBpG5KSTDzmgj7vjEfUzILnUscNPC1b3h3wa5RroFdHqTJU6m2+OOEBs
   uiTlECw0LtEHHzy9wZ+9Ecdj1QGBXqa8wf1IyfTepgompsh60F5U79Ojv
   mzG6AI74nFvQjvoj8uutivGynAwNL1ynH83pg47K767kcyUzNhzKACpMY
   A==;
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="201371062"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Nov 2022 02:46:30 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 25 Nov 2022 02:46:29 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 25 Nov 2022 02:46:27 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 9/9] net: microchip: vcap: Implement w32be
Date:   Fri, 25 Nov 2022 10:50:10 +0100
Message-ID: <20221125095010.124458-10-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221125095010.124458-1-horatiu.vultur@microchip.com>
References: <20221125095010.124458-1-horatiu.vultur@microchip.com>
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

On lan966x the layout of the vcap memory is different than on sparx5.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/ethernet/microchip/vcap/vcap_api.c    | 116 +++++++++++++++++-
 1 file changed, 112 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index ac7a32ff755ea..cd4f1fa2fb8e6 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -8,6 +8,28 @@
 
 #include "vcap_api_private.h"
 
+static int keyfield_size_table[] = {
+	[VCAP_FIELD_BIT]  = sizeof(struct vcap_u1_key),
+	[VCAP_FIELD_U32]  = sizeof(struct vcap_u32_key),
+	[VCAP_FIELD_U48]  = sizeof(struct vcap_u48_key),
+	[VCAP_FIELD_U56]  = sizeof(struct vcap_u56_key),
+	[VCAP_FIELD_U64]  = sizeof(struct vcap_u64_key),
+	[VCAP_FIELD_U72]  = sizeof(struct vcap_u72_key),
+	[VCAP_FIELD_U112] = sizeof(struct vcap_u112_key),
+	[VCAP_FIELD_U128] = sizeof(struct vcap_u128_key),
+};
+
+static int actionfield_size_table[] = {
+	[VCAP_FIELD_BIT]  = sizeof(struct vcap_u1_action),
+	[VCAP_FIELD_U32]  = sizeof(struct vcap_u32_action),
+	[VCAP_FIELD_U48]  = sizeof(struct vcap_u48_action),
+	[VCAP_FIELD_U56]  = sizeof(struct vcap_u56_action),
+	[VCAP_FIELD_U64]  = sizeof(struct vcap_u64_action),
+	[VCAP_FIELD_U72]  = sizeof(struct vcap_u72_action),
+	[VCAP_FIELD_U112] = sizeof(struct vcap_u112_action),
+	[VCAP_FIELD_U128] = sizeof(struct vcap_u128_action),
+};
+
 /* Moving a rule in the VCAP address space */
 struct vcap_rule_move {
 	int addr; /* address to move */
@@ -1288,12 +1310,67 @@ const struct vcap_field *vcap_lookup_keyfield(struct vcap_rule *rule,
 }
 EXPORT_SYMBOL_GPL(vcap_lookup_keyfield);
 
+/* Copy data from src to dst but reverse the data in chunks of 32bits.
+ * For example if src is 00:11:22:33:44:55 where 55 is LSB the dst will
+ * have the value 22:33:44:55:00:11.
+ */
+static void vcap_copy_to_w32be(u8 *dst, u8 *src, int size)
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
 static void vcap_copy_from_client_keyfield(struct vcap_rule *rule,
 					   struct vcap_client_keyfield *field,
 					   struct vcap_client_keyfield_data *data)
 {
-	/* This will be expanded later to handle different vcap memory layouts */
-	memcpy(&field->data, data, sizeof(field->data));
+	struct vcap_rule_internal *ri = to_intrule(rule);
+	int size;
+
+	if (!ri->admin->w32be) {
+		memcpy(&field->data, data, sizeof(field->data));
+		return;
+	}
+
+	size = keyfield_size_table[field->ctrl.type] / 2;
+	switch (field->ctrl.type) {
+	case VCAP_FIELD_BIT:
+	case VCAP_FIELD_U32:
+		memcpy(&field->data, data, sizeof(field->data));
+		break;
+	case VCAP_FIELD_U48:
+		vcap_copy_to_w32be(field->data.u48.value, data->u48.value, size);
+		vcap_copy_to_w32be(field->data.u48.mask,  data->u48.mask, size);
+		break;
+	case VCAP_FIELD_U56:
+		vcap_copy_to_w32be(field->data.u56.value, data->u56.value, size);
+		vcap_copy_to_w32be(field->data.u56.mask,  data->u56.mask, size);
+		break;
+	case VCAP_FIELD_U64:
+		vcap_copy_to_w32be(field->data.u64.value, data->u64.value, size);
+		vcap_copy_to_w32be(field->data.u64.mask,  data->u64.mask, size);
+		break;
+	case VCAP_FIELD_U72:
+		vcap_copy_to_w32be(field->data.u72.value, data->u72.value, size);
+		vcap_copy_to_w32be(field->data.u72.mask,  data->u72.mask, size);
+		break;
+	case VCAP_FIELD_U112:
+		vcap_copy_to_w32be(field->data.u112.value, data->u112.value, size);
+		vcap_copy_to_w32be(field->data.u112.mask,  data->u112.mask, size);
+		break;
+	case VCAP_FIELD_U128:
+		vcap_copy_to_w32be(field->data.u128.value, data->u128.value, size);
+		vcap_copy_to_w32be(field->data.u128.mask,  data->u128.mask, size);
+		break;
+	};
 }
 
 /* Check if the keyfield is already in the rule */
@@ -1438,8 +1515,39 @@ static void vcap_copy_from_client_actionfield(struct vcap_rule *rule,
 					      struct vcap_client_actionfield *field,
 					      struct vcap_client_actionfield_data *data)
 {
-	/* This will be expanded later to handle different vcap memory layouts */
-	memcpy(&field->data, data, sizeof(field->data));
+	struct vcap_rule_internal *ri = to_intrule(rule);
+	int size;
+
+	if (!ri->admin->w32be) {
+		memcpy(&field->data, data, sizeof(field->data));
+		return;
+	}
+
+	size = actionfield_size_table[field->ctrl.type];
+	switch (field->ctrl.type) {
+	case VCAP_FIELD_BIT:
+	case VCAP_FIELD_U32:
+		memcpy(&field->data, data, sizeof(field->data));
+		break;
+	case VCAP_FIELD_U48:
+		vcap_copy_to_w32be(field->data.u48.value, data->u48.value, size);
+		break;
+	case VCAP_FIELD_U56:
+		vcap_copy_to_w32be(field->data.u56.value, data->u56.value, size);
+		break;
+	case VCAP_FIELD_U64:
+		vcap_copy_to_w32be(field->data.u64.value, data->u64.value, size);
+		break;
+	case VCAP_FIELD_U72:
+		vcap_copy_to_w32be(field->data.u72.value, data->u72.value, size);
+		break;
+	case VCAP_FIELD_U112:
+		vcap_copy_to_w32be(field->data.u112.value, data->u112.value, size);
+		break;
+	case VCAP_FIELD_U128:
+		vcap_copy_to_w32be(field->data.u128.value, data->u128.value, size);
+		break;
+	};
 }
 
 /* Check if the actionfield is already in the rule */
-- 
2.38.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C10C5616255
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 12:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbiKBL6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 07:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbiKBL6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 07:58:22 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D3D29C9F;
        Wed,  2 Nov 2022 04:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667390288; x=1698926288;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q+DRYLqO8Qm9/qgajBouA7uY0lt3Yh5wsitHuwEhXC8=;
  b=PraI+VWpeK1NPb3nklhJjX7C6BXm7Gt/r2A5sbMUEecmRzYqdyc2jszi
   Q2Y38I5R7//HFd7F/ZAM2bdQ+01Tid/cymYb1aKuYuVUtQja723LA0jKY
   RLA6+pG4kiUAEto1+ftIT7KEo8l1urlMWsCsWuctY/TdFUF59+k9Rvzxy
   YYdAeOEGvcMkNjCT2RBv6aOXpfDwai3ehYg8FbwT8OcqY+eYsAr5fQcd8
   ftUko0lQ6t+dsahV0pOw35fow992/KAWBI7OA74F4VwM/l7ha3vJcykvf
   GaGetdndGaFsXFmSfLmdRwNgZg0Kz4QewlDYRLFKnNK+yCC+BebSXxoz2
   w==;
X-IronPort-AV: E=Sophos;i="5.95,232,1661842800"; 
   d="scan'208";a="187269778"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Nov 2022 04:58:08 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 2 Nov 2022 04:58:06 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 2 Nov 2022 04:58:03 -0700
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
Subject: [PATCH net-next v4 6/7] net: microchip: sparx5: Let VCAP API validate added key- and actionfields
Date:   Wed, 2 Nov 2022 12:57:36 +0100
Message-ID: <20221102115737.4118808-7-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102115737.4118808-1-steen.hegelund@microchip.com>
References: <20221102115737.4118808-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for validating keyfields and actionfields when they are added
to a VCAP rule.
We need to ensure that the field is not already present and that the field
is in the key- or actionset, if the client has added a key- or actionset to
the rule at this point.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../net/ethernet/microchip/vcap/vcap_api.c    | 103 +++++++++++++++++-
 1 file changed, 101 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index 96da8a59d8f0..603dfc62bfca 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -754,6 +754,13 @@ const char *vcap_keyfield_name(struct vcap_control *vctrl,
 }
 EXPORT_SYMBOL_GPL(vcap_keyfield_name);
 
+/* map action field id to a string with the action name */
+static const char *vcap_actionfield_name(struct vcap_control *vctrl,
+					 enum vcap_action_field action)
+{
+	return vctrl->stats->actionfield_names[action];
+}
+
 /* Return the keyfield that matches a key in a keyset */
 static const struct vcap_field *
 vcap_find_keyset_keyfield(struct vcap_control *vctrl,
@@ -1126,14 +1133,60 @@ static void vcap_copy_from_client_keyfield(struct vcap_rule *rule,
 	memcpy(&field->data, data, sizeof(field->data));
 }
 
+/* Check if the keyfield is already in the rule */
+static bool vcap_keyfield_unique(struct vcap_rule *rule,
+				 enum vcap_key_field key)
+{
+	struct vcap_rule_internal *ri = to_intrule(rule);
+	const struct vcap_client_keyfield *ckf;
+
+	list_for_each_entry(ckf, &ri->data.keyfields, ctrl.list)
+		if (ckf->ctrl.key == key)
+			return false;
+	return true;
+}
+
+/* Check if the keyfield is in the keyset */
+static bool vcap_keyfield_match_keyset(struct vcap_rule *rule,
+				       enum vcap_key_field key)
+{
+	struct vcap_rule_internal *ri = to_intrule(rule);
+	enum vcap_keyfield_set keyset = rule->keyset;
+	enum vcap_type vt = ri->admin->vtype;
+	const struct vcap_field *fields;
+
+	/* the field is accepted if the rule has no keyset yet */
+	if (keyset == VCAP_KFS_NO_VALUE)
+		return true;
+	fields = vcap_keyfields(ri->vctrl, vt, keyset);
+	if (!fields)
+		return false;
+	/* if there is a width there is a way */
+	return fields[key].width > 0;
+}
+
 static int vcap_rule_add_key(struct vcap_rule *rule,
 			     enum vcap_key_field key,
 			     enum vcap_field_type ftype,
 			     struct vcap_client_keyfield_data *data)
 {
+	struct vcap_rule_internal *ri = to_intrule(rule);
 	struct vcap_client_keyfield *field;
 
-	/* More validation will be added here later */
+	if (!vcap_keyfield_unique(rule, key)) {
+		pr_warn("%s:%d: keyfield %s is already in the rule\n",
+			__func__, __LINE__,
+			vcap_keyfield_name(ri->vctrl, key));
+		return -EINVAL;
+	}
+
+	if (!vcap_keyfield_match_keyset(rule, key)) {
+		pr_err("%s:%d: keyfield %s does not belong in the rule keyset\n",
+		       __func__, __LINE__,
+		       vcap_keyfield_name(ri->vctrl, key));
+		return -EINVAL;
+	}
+
 	field = kzalloc(sizeof(*field), GFP_KERNEL);
 	if (!field)
 		return -ENOMEM;
@@ -1226,14 +1279,60 @@ static void vcap_copy_from_client_actionfield(struct vcap_rule *rule,
 	memcpy(&field->data, data, sizeof(field->data));
 }
 
+/* Check if the actionfield is already in the rule */
+static bool vcap_actionfield_unique(struct vcap_rule *rule,
+				    enum vcap_action_field act)
+{
+	struct vcap_rule_internal *ri = to_intrule(rule);
+	const struct vcap_client_actionfield *caf;
+
+	list_for_each_entry(caf, &ri->data.actionfields, ctrl.list)
+		if (caf->ctrl.action == act)
+			return false;
+	return true;
+}
+
+/* Check if the actionfield is in the actionset */
+static bool vcap_actionfield_match_actionset(struct vcap_rule *rule,
+					     enum vcap_action_field action)
+{
+	enum vcap_actionfield_set actionset = rule->actionset;
+	struct vcap_rule_internal *ri = to_intrule(rule);
+	enum vcap_type vt = ri->admin->vtype;
+	const struct vcap_field *fields;
+
+	/* the field is accepted if the rule has no actionset yet */
+	if (actionset == VCAP_AFS_NO_VALUE)
+		return true;
+	fields = vcap_actionfields(ri->vctrl, vt, actionset);
+	if (!fields)
+		return false;
+	/* if there is a width there is a way */
+	return fields[action].width > 0;
+}
+
 static int vcap_rule_add_action(struct vcap_rule *rule,
 				enum vcap_action_field action,
 				enum vcap_field_type ftype,
 				struct vcap_client_actionfield_data *data)
 {
+	struct vcap_rule_internal *ri = to_intrule(rule);
 	struct vcap_client_actionfield *field;
 
-	/* More validation will be added here later */
+	if (!vcap_actionfield_unique(rule, action)) {
+		pr_warn("%s:%d: actionfield %s is already in the rule\n",
+			__func__, __LINE__,
+			vcap_actionfield_name(ri->vctrl, action));
+		return -EINVAL;
+	}
+
+	if (!vcap_actionfield_match_actionset(rule, action)) {
+		pr_err("%s:%d: actionfield %s does not belong in the rule actionset\n",
+		       __func__, __LINE__,
+		       vcap_actionfield_name(ri->vctrl, action));
+		return -EINVAL;
+	}
+
 	field = kzalloc(sizeof(*field), GFP_KERNEL);
 	if (!field)
 		return -ENOMEM;
-- 
2.38.1


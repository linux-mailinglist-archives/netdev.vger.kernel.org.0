Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8D8A613AD5
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 16:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbiJaP4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 11:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbiJaP4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 11:56:38 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92448120B9;
        Mon, 31 Oct 2022 08:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667231789; x=1698767789;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ra82adO9Ytf2Ct9J6Xvwy+xgtwmL2sMtcOWSaz42kuw=;
  b=IVjMaXAY8uNmj+cgWI8mG3PPgEZFsWBLSRTyFlMKNBTaKxOK64ssQ86n
   OtLr4bQnXZ7CbOD6d5Dw3+gGYl/ROa+0qqy9mdzER2r0G25W3BdMW8DeA
   XIlGapNZdWRxESmgywe1aIK5qWWmGX6r/STakBvVqsq+Oi2D7VgAT1LVH
   dZ57Ji6QWX84L5uI/KbDskSX64AAPrvsYurJVc3bUsaW/P0E9nIEh7PXY
   3zQE0AQjfHI3OzwEvmU2SjmRqwXYMFcbUMjfPRpmCVUob1VZNUQnCZ+Xm
   Ry6LYLL0DFb58ffWVXRqB2tdDTBd+0s5o/S5cPcvj8ZUhmvpw4YNrikHV
   A==;
X-IronPort-AV: E=Sophos;i="5.95,228,1661842800"; 
   d="scan'208";a="121107677"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 31 Oct 2022 08:56:28 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 31 Oct 2022 08:56:28 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 31 Oct 2022 08:56:24 -0700
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
Subject: [PATCH net-next v3 4/5] net: microchip: sparx5: Let VCAP API validate added key- and actionfields
Date:   Mon, 31 Oct 2022 16:56:06 +0100
Message-ID: <20221031155607.3615381-5-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221031155607.3615381-1-steen.hegelund@microchip.com>
References: <20221031155607.3615381-1-steen.hegelund@microchip.com>
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
index 9e67ea814768..69ee34bb392a 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -737,6 +737,13 @@ const char *vcap_keyfield_name(struct vcap_control *vctrl,
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
@@ -1109,14 +1116,60 @@ static void vcap_copy_from_client_keyfield(struct vcap_rule *rule,
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
@@ -1209,14 +1262,60 @@ static void vcap_copy_from_client_actionfield(struct vcap_rule *rule,
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E16B3679597
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 11:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbjAXKp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 05:45:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233676AbjAXKpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 05:45:38 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CBB040BDA;
        Tue, 24 Jan 2023 02:45:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674557136; x=1706093136;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aZMAlgP6nBnYPAUjm/Vj6hj+JH1m5itO01x/ZOmSgZw=;
  b=Umzy7dOMbOqULuFvnqknzMDN5fhzfwMdPrNZpShooooaCU/xqGgEFTz8
   EKlXmHPXj6IPFqM2bIXcw+x7m2M9mRAriZ2U8sVZP/piiFiVAJfpOJf05
   J8+qdyHvwWH4kQfSdQo/0+yyZPqjf/MikGED8nhuIrAY0LFJhxc4o+8G9
   5vPB6eiv4U7z1gO0CPNeVuw+THCi2rt8m84YbN1N+1gdZh6V3ttEeBI07
   b3hrCbQEH/pbhHg+CtqyDUfRW8Jz5k+gJKdfth753roSSZye+UGT/D5ZU
   yZ4z7txSJHqYHxHCVr3m5fGH+Sp01jEuSSEvFC2n8SVedyeH7OkU5s+Ub
   g==;
X-IronPort-AV: E=Sophos;i="5.97,242,1669100400"; 
   d="scan'208";a="193598302"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jan 2023 03:45:35 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 24 Jan 2023 03:45:29 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 24 Jan 2023 03:45:25 -0700
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
Subject: [PATCH net-next v2 3/8] net: microchip: sparx5: Add actionset type id information to rule
Date:   Tue, 24 Jan 2023 11:45:06 +0100
Message-ID: <20230124104511.293938-4-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230124104511.293938-1-steen.hegelund@microchip.com>
References: <20230124104511.293938-1-steen.hegelund@microchip.com>
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

This adds the actionset type id to the rule information.  This is needed as
we now have more than one actionset in a VCAP instance (IS0).

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../net/ethernet/microchip/vcap/vcap_api.c    | 34 +++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index 2eaa857d8c1a..c740e83d9c20 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -1673,6 +1673,39 @@ static int vcap_add_type_keyfield(struct vcap_rule *rule)
 	return 0;
 }
 
+/* Add the actionset typefield to the list of rule actionfields */
+static int vcap_add_type_actionfield(struct vcap_rule *rule)
+{
+	enum vcap_actionfield_set actionset = rule->actionset;
+	struct vcap_rule_internal *ri = to_intrule(rule);
+	enum vcap_type vt = ri->admin->vtype;
+	const struct vcap_field *fields;
+	const struct vcap_set *aset;
+	int ret = -EINVAL;
+
+	aset = vcap_actionfieldset(ri->vctrl, vt, actionset);
+	if (!aset)
+		return ret;
+	if (aset->type_id == (u8)-1)  /* No type field is needed */
+		return 0;
+
+	fields = vcap_actionfields(ri->vctrl, vt, actionset);
+	if (!fields)
+		return -EINVAL;
+	if (fields[VCAP_AF_TYPE].width > 1) {
+		ret = vcap_rule_add_action_u32(rule, VCAP_AF_TYPE,
+					       aset->type_id);
+	} else {
+		if (aset->type_id)
+			ret = vcap_rule_add_action_bit(rule, VCAP_AF_TYPE,
+						       VCAP_BIT_1);
+		else
+			ret = vcap_rule_add_action_bit(rule, VCAP_AF_TYPE,
+						       VCAP_BIT_0);
+	}
+	return ret;
+}
+
 /* Add a keyset to a keyset list */
 bool vcap_keyset_list_add(struct vcap_keyset_list *keysetlist,
 			  enum vcap_keyfield_set keyset)
@@ -1856,6 +1889,7 @@ int vcap_val_rule(struct vcap_rule *rule, u16 l3_proto)
 		return -EINVAL;
 	}
 	vcap_add_type_keyfield(rule);
+	vcap_add_type_actionfield(rule);
 	/* Add default fields to this rule */
 	ri->vctrl->ops->add_default_fields(ri->ndev, ri->admin, rule);
 
-- 
2.39.1


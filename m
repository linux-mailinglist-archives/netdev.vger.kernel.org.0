Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19DEC67503E
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 10:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbjATJJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 04:09:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbjATJI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 04:08:57 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D116069B14;
        Fri, 20 Jan 2023 01:08:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674205733; x=1705741733;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8jLoDyoa4lILFvDnjI3K/TQTi2Daf4y+tiN3pIiYJlw=;
  b=Fl3M2VPjP3AAWQGRIR7d/i3xlIQ9UjXLLz3MOqKY0sajZowWfo0pnFBn
   a4jdKNx9OvBGxuCYB4x1XnsuszUHl7AOmHL2cZOBM8THrHo/hTtjwvqEh
   I6JhCRPaB5dSGuMEpci2zenk3hcXEHlOfsieiq9h2w+g6YFQbTY+WBBiA
   cnwyI9RCvpRFZLxQ0jvGEVYv+JvTW0SyGmgV9MyYMN4PSzfQGoEFr0STp
   RJtP/DHARKGJkx4yMuNBKJoYjjoCAhSVrUmml48e2r3P0DLDxd8cYcoMc
   wU17uChWO5ZV1DvpoGHUbBDUBa3viC+x6B2WjcEBRMum8msgLYckBgj6Z
   g==;
X-IronPort-AV: E=Sophos;i="5.97,231,1669100400"; 
   d="scan'208";a="196670237"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jan 2023 02:08:52 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 20 Jan 2023 02:08:51 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 20 Jan 2023 02:08:47 -0700
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
Subject: [PATCH net-next 3/8] net: microchip: sparx5: Add actionset type id information to rule
Date:   Fri, 20 Jan 2023 10:08:26 +0100
Message-ID: <20230120090831.20032-4-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230120090831.20032-1-steen.hegelund@microchip.com>
References: <20230120090831.20032-1-steen.hegelund@microchip.com>
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
index 71f787a78295..26fa58d4a0cd 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -1675,6 +1675,39 @@ static int vcap_add_type_keyfield(struct vcap_rule *rule)
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
+	return 0;
+}
+
 /* Add a keyset to a keyset list */
 bool vcap_keyset_list_add(struct vcap_keyset_list *keysetlist,
 			  enum vcap_keyfield_set keyset)
@@ -1858,6 +1891,7 @@ int vcap_val_rule(struct vcap_rule *rule, u16 l3_proto)
 		return -EINVAL;
 	}
 	vcap_add_type_keyfield(rule);
+	vcap_add_type_actionfield(rule);
 	/* Add default fields to this rule */
 	ri->vctrl->ops->add_default_fields(ri->ndev, ri->admin, rule);
 
-- 
2.39.1


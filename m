Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36A206AF846
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 23:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbjCGWKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 17:10:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbjCGWJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 17:09:54 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECBCB9C998;
        Tue,  7 Mar 2023 14:09:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1678226994; x=1709762994;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=12JHxrPzv/f6k5ckDTyBdLhvzNmSxLmgFKztRU+fPaE=;
  b=NSmxj4swhvHKBmAXBn+bmL+0fjgisXhppiXLFt84OP9xQDHKuaNsF5HK
   vcISSPbN4Cw4M16DQvJMGBe0GasinZdhMW0ErMo471qUY8FVO7CF0qp2l
   dJTZRgWTtZ4exfp5+WyyQmyOySjdNVUlkXbF0Ni41oKVKg9DGHTrqvDA0
   bhb3CL0VuIzX6E5wrTA4DT6KlxwPwBakn6l9ZSKhAsA7CYhD28lQU+Elp
   a86cXbhg0wIyBfjrPRl7pk5qx1zFCF3XlIL+bz7npdT+/s8LiPt/C9nWc
   XRWxQOHbUqYbEq9UN4AiYnuiCSjvyRDz1sLtO8va0WrH0BwQpIFHacyhw
   Q==;
X-IronPort-AV: E=Sophos;i="5.98,242,1673938800"; 
   d="scan'208";a="204082665"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Mar 2023 15:09:53 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Mar 2023 15:09:51 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 7 Mar 2023 15:09:49 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 4/5] net: lan966x: Add TC filter chaining support for IS1 and IS2 VCAPs
Date:   Tue, 7 Mar 2023 23:09:28 +0100
Message-ID: <20230307220929.834219-5-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230307220929.834219-1-horatiu.vultur@microchip.com>
References: <20230307220929.834219-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow rules to be chained between IS1 VCAP and IS2 VCAP. Chaining
between IS1 lookups or between IS2 lookups are not supported by the
hardware.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../microchip/lan966x/lan966x_tc_flower.c     | 80 +++++++++++++++++++
 1 file changed, 80 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
index 8391652c1c45e..570ac28736e03 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
@@ -309,6 +309,75 @@ static int lan966x_tc_set_actionset(struct vcap_admin *admin,
 	return err;
 }
 
+static int lan966x_tc_add_rule_link_target(struct vcap_admin *admin,
+					   struct vcap_rule *vrule,
+					   int target_cid)
+{
+	int link_val = target_cid % VCAP_CID_LOOKUP_SIZE;
+	int err;
+
+	if (!link_val)
+		return 0;
+
+	switch (admin->vtype) {
+	case VCAP_TYPE_IS1:
+		/* Choose IS1 specific NXT_IDX key (for chaining rules from IS1) */
+		err = vcap_rule_add_key_u32(vrule, VCAP_KF_LOOKUP_GEN_IDX_SEL,
+					    1, ~0);
+		if (err)
+			return err;
+
+		return vcap_rule_add_key_u32(vrule, VCAP_KF_LOOKUP_GEN_IDX,
+					     link_val, ~0);
+	case VCAP_TYPE_IS2:
+		/* Add IS2 specific PAG key (for chaining rules from IS1) */
+		return vcap_rule_add_key_u32(vrule, VCAP_KF_LOOKUP_PAG,
+					     link_val, ~0);
+	default:
+		break;
+	}
+	return 0;
+}
+
+static int lan966x_tc_add_rule_link(struct vcap_control *vctrl,
+				    struct vcap_admin *admin,
+				    struct vcap_rule *vrule,
+				    struct flow_cls_offload *f,
+				    int to_cid)
+{
+	struct vcap_admin *to_admin = vcap_find_admin(vctrl, to_cid);
+	int diff, err = 0;
+
+	if (!to_admin) {
+		NL_SET_ERR_MSG_MOD(f->common.extack,
+				   "Unknown destination chain");
+		return -EINVAL;
+	}
+
+	diff = vcap_chain_offset(vctrl, f->common.chain_index, to_cid);
+	if (!diff)
+		return 0;
+
+	/* Between IS1 and IS2 the PAG value is used */
+	if (admin->vtype == VCAP_TYPE_IS1 && to_admin->vtype == VCAP_TYPE_IS2) {
+		/* This works for IS1->IS2 */
+		err = vcap_rule_add_action_u32(vrule, VCAP_AF_PAG_VAL, diff);
+		if (err)
+			return err;
+
+		err = vcap_rule_add_action_u32(vrule, VCAP_AF_PAG_OVERRIDE_MASK,
+					       0xff);
+		if (err)
+			return err;
+	} else {
+		NL_SET_ERR_MSG_MOD(f->common.extack,
+				   "Unsupported chain destination");
+		return -EOPNOTSUPP;
+	}
+
+	return err;
+}
+
 static int lan966x_tc_flower_add(struct lan966x_port *port,
 				 struct flow_cls_offload *f,
 				 struct vcap_admin *admin,
@@ -336,6 +405,11 @@ static int lan966x_tc_flower_add(struct lan966x_port *port,
 	if (err)
 		goto out;
 
+	err = lan966x_tc_add_rule_link_target(admin, vrule,
+					      f->common.chain_index);
+	if (err)
+		goto out;
+
 	frule = flow_cls_offload_flow_rule(f);
 
 	flow_action_for_each(idx, act, &frule->action) {
@@ -365,6 +439,12 @@ static int lan966x_tc_flower_add(struct lan966x_port *port,
 			if (err)
 				goto out;
 
+			err = lan966x_tc_add_rule_link(port->lan966x->vcap_ctrl,
+						       admin, vrule,
+						       f, act->chain_index);
+			if (err)
+				goto out;
+
 			break;
 		default:
 			NL_SET_ERR_MSG_MOD(f->common.extack,
-- 
2.38.0


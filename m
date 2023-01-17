Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9526666D8DA
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 09:56:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235491AbjAQI4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 03:56:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236103AbjAQI4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 03:56:01 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958213C10;
        Tue, 17 Jan 2023 00:55:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673945759; x=1705481759;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=snZiNtmGLv9PnppTNGgB75z+Rsn5YVgjz5NEqqogGM4=;
  b=TMUOmg1rwgCBOzYQULr5aJB7tseJwtL5+yQrfYUfV6vDh4p4GJIVRugG
   w0M8SsHpCp/x4PjsFDZL1y1sXcpSEeMOcwlioLYkAZE2+C7X0m+C1xz97
   uURIubqIqECCgLS0cZP6STmEm9xAout1ZogMTi5VqeHdqhwviYzfVqXZR
   WqMxuHQUcXds8r1ld61Y1PuyL4ilhH/uvvMRNHawToOC9caGsyq2b5yCK
   PjqsFGQ8IVEm1n8I/FY6tMfF4Mp+f/nOJbg/N4FZdF7yhYFcFhehLHVQu
   SIe57LMhz0vGV6q1Eoe04SFDE3c1uaLcHyp9zz9gzTy/NkL3IjAnovBWJ
   w==;
X-IronPort-AV: E=Sophos;i="5.97,222,1669100400"; 
   d="scan'208";a="208096687"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jan 2023 01:55:59 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 17 Jan 2023 01:55:58 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Tue, 17 Jan 2023 01:55:55 -0700
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
Subject: [PATCH net-next 2/5] net: microchip: sparx5: Add support to check for existing VCAP rule id
Date:   Tue, 17 Jan 2023 09:55:41 +0100
Message-ID: <20230117085544.591523-3-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230117085544.591523-1-steen.hegelund@microchip.com>
References: <20230117085544.591523-1-steen.hegelund@microchip.com>
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

Add a new function that just checks if the VCAP rule id is already used by
an existing rule.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 drivers/net/ethernet/microchip/vcap/vcap_api.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index 4e038f96a131..f1dc4fd6bb96 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -920,6 +920,20 @@ int vcap_set_rule_set_actionset(struct vcap_rule *rule,
 }
 EXPORT_SYMBOL_GPL(vcap_set_rule_set_actionset);
 
+/* Check if a rule with this id exists */
+static bool vcap_rule_exists(struct vcap_control *vctrl, u32 id)
+{
+	struct vcap_rule_internal *ri;
+	struct vcap_admin *admin;
+
+	/* Look for the rule id in all vcaps */
+	list_for_each_entry(admin, &vctrl->list, list)
+		list_for_each_entry(ri, &admin->rules, list)
+			if (ri->data.id == id)
+				return true;
+	return false;
+}
+
 /* Find a rule with a provided rule id */
 static struct vcap_rule_internal *vcap_lookup_rule(struct vcap_control *vctrl,
 						   u32 id)
@@ -1866,7 +1880,7 @@ static u32 vcap_set_rule_id(struct vcap_rule_internal *ri)
 		return ri->data.id;
 
 	for (u32 next_id = 1; next_id < ~0; ++next_id) {
-		if (!vcap_lookup_rule(ri->vctrl, next_id)) {
+		if (!vcap_rule_exists(ri->vctrl, next_id)) {
 			ri->data.id = next_id;
 			break;
 		}
@@ -2103,7 +2117,7 @@ struct vcap_rule *vcap_alloc_rule(struct vcap_control *vctrl,
 	if (vctrl->vcaps[admin->vtype].rows == 0)
 		return ERR_PTR(-EINVAL);
 	/* Check if a rule with this id already exists */
-	if (vcap_lookup_rule(vctrl, id))
+	if (vcap_rule_exists(vctrl, id))
 		return ERR_PTR(-EEXIST);
 	/* Check if there is room for the rule in the block(s) of the VCAP */
 	maxsize = vctrl->vcaps[admin->vtype].sw_count; /* worst case rule size */
-- 
2.39.0


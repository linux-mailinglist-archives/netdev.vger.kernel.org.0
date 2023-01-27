Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97F6767E626
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 14:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234145AbjA0NJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 08:09:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234608AbjA0NJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 08:09:27 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E077FA3F;
        Fri, 27 Jan 2023 05:09:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674824948; x=1706360948;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WfnXdvKd8SLNPMKYGLsi6cE62K7v8BTPiks1N6rWvHI=;
  b=T2u+sod/0+zic1DtudCd6GWbAMHBcBUQ+J9Ga/lUBLipQ53YYZdJZ0cl
   0B7bRd73zASFMjztTXRyKg3UUDYf1V1ztaptIBmafUvX2YJ3IvHZf42li
   2czdQpbLBoXeZvSL2NFHQHlsxwrubKo/ABEOQC9cKLGeuInzEGqXneVtt
   8OE+acA3tmi1OadaHF1RlrsUjCresDjKicVwlKYMz7DWqtiABLfHBN/LV
   FQbbNedIhHhweNbgdAvKr9Q8LwpiMyZrNSjKzMFLTpYSU3ZSiwC3FqOuW
   H8TpMGcnZeLnRc9eIZIzxf/iHtUmSukI/qL6EUiHco+pNp2gDT+wCiy5V
   g==;
X-IronPort-AV: E=Sophos;i="5.97,251,1669100400"; 
   d="scan'208";a="197691351"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2023 06:08:49 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 27 Jan 2023 06:08:47 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Fri, 27 Jan 2023 06:08:41 -0700
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
Subject: [PATCH net-next 1/8] net: microchip: sparx5: Add support for getting keysets without a type id
Date:   Fri, 27 Jan 2023 14:08:23 +0100
Message-ID: <20230127130830.1481526-2-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230127130830.1481526-1-steen.hegelund@microchip.com>
References: <20230127130830.1481526-1-steen.hegelund@microchip.com>
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

When there is only one keyset available for a certain VCAP rule size, the
particular keyset does not need a type id when encoded in the VCAP
Hardware.

This provides support for getting a keyset from a rule, when this is the
case: only one keyset fits this rule size.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 .../net/ethernet/microchip/vcap/vcap_api.c    | 24 ++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index 83223c4770f2..2402126d87c2 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -3264,6 +3264,28 @@ static int vcap_rule_get_key(struct vcap_rule *rule,
 	return 0;
 }
 
+/* Find a keyset having the same size as the provided rule, where the keyset
+ * does not have a type id.
+ */
+static int vcap_rule_get_untyped_keyset(struct vcap_rule_internal *ri,
+					struct vcap_keyset_list *matches)
+{
+	struct vcap_control *vctrl = ri->vctrl;
+	enum vcap_type vt = ri->admin->vtype;
+	const struct vcap_set *keyfield_set;
+	int idx;
+
+	keyfield_set = vctrl->vcaps[vt].keyfield_set;
+	for (idx = 0; idx < vctrl->vcaps[vt].keyfield_set_size; ++idx) {
+		if (keyfield_set[idx].sw_per_item == ri->keyset_sw &&
+		    keyfield_set[idx].type_id == (u8)-1) {
+			vcap_keyset_list_add(matches, idx);
+			return 0;
+		}
+	}
+	return -EINVAL;
+}
+
 /* Get the keysets that matches the rule key type/mask */
 int vcap_rule_get_keysets(struct vcap_rule_internal *ri,
 			  struct vcap_keyset_list *matches)
@@ -3277,7 +3299,7 @@ int vcap_rule_get_keysets(struct vcap_rule_internal *ri,
 
 	err = vcap_rule_get_key(&ri->data, VCAP_KF_TYPE, &kf);
 	if (err)
-		return err;
+		return vcap_rule_get_untyped_keyset(ri, matches);
 
 	if (kf.ctrl.type == VCAP_FIELD_BIT) {
 		value = kf.data.u1.value;
-- 
2.39.1


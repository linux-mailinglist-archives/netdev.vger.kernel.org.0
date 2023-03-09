Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAA0B6B2932
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 16:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbjCIP5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 10:57:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbjCIP5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 10:57:17 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B04FE9CCC
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 07:57:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=py0XSkWzC08N5GFVxO0iHzbzhj2Tc1QPLx9OWpR2e4Y=; b=fPJZzAesa/jWRxOpvI3lmUn57C
        CAakSCTv/FEAue53Sk4ZSL3j5aQtRrQ9fps9Z9aBPArkwXRNDZI2sqPxuQ9mlzGV8hCuYK0tvQRBr
        NG4CtvzZRM+dgdxLMM4YPm8g3XJdKVI2KMDNguahI6DwMjYRIIF4AHoPcX0iwgdm7JyJDN0ij9Nk9
        TUbti/O1K5WAHyya6NK2tIq1HLVn58TgxwAiT4Q/CcFPq7myPCPJdQjm3bLzWtLSU0fwc5V/Bh/UM
        j/kfYaD5THHguux0QvKezjOQgMYWd1N6YOJ/YRoQAj4iU0ouRAdv9JsNqKnluU6vly4w+aHnbvZyY
        dOHwvDxg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:60366 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1paIdj-0004zB-SN; Thu, 09 Mar 2023 15:57:11 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1paIdj-00DUP1-4r; Thu, 09 Mar 2023 15:57:11 +0000
In-Reply-To: <ZAoBnqGBnIZzLwpV@shell.armlinux.org.uk>
References: <ZAoBnqGBnIZzLwpV@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 1/2] net: sfp: add A2h presence flag
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1paIdj-00DUP1-4r@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 09 Mar 2023 15:57:11 +0000
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hwmon code wants to know when it is safe to access the A2h data
stored in a separate address. We indicate that this is present when
we have SFF-8472 compliance and the lack of an address-change
sequence.,

The same conditions are also true if we want to access other controls
and status in the A2h address. So let's make a flag to indicate whether
we can access it, instead of repeating the conditions throughout the
code.

For now, only convert the hwmon code.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 42 ++++++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index c02cad6478a8..4ff07b5a5590 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -255,6 +255,8 @@ struct sfp {
 	unsigned int module_power_mW;
 	unsigned int module_t_start_up;
 	unsigned int module_t_wait;
+
+	bool have_a2;
 	bool tx_fault_ignore;
 
 	const struct sfp_quirk *quirk;
@@ -1453,20 +1455,10 @@ static void sfp_hwmon_probe(struct work_struct *work)
 
 static int sfp_hwmon_insert(struct sfp *sfp)
 {
-	if (sfp->id.ext.sff8472_compliance == SFP_SFF8472_COMPLIANCE_NONE)
-		return 0;
-
-	if (!(sfp->id.ext.diagmon & SFP_DIAGMON_DDM))
-		return 0;
-
-	if (sfp->id.ext.diagmon & SFP_DIAGMON_ADDRMODE)
-		/* This driver in general does not support address
-		 * change.
-		 */
-		return 0;
-
-	mod_delayed_work(system_wq, &sfp->hwmon_probe, 1);
-	sfp->hwmon_tries = R_PROBE_RETRY_SLOW;
+	if (sfp->have_a2 && sfp->id.ext.diagmon & SFP_DIAGMON_DDM) {
+		mod_delayed_work(system_wq, &sfp->hwmon_probe, 1);
+		sfp->hwmon_tries = R_PROBE_RETRY_SLOW;
+	}
 
 	return 0;
 }
@@ -1916,6 +1908,18 @@ static int sfp_cotsworks_fixup_check(struct sfp *sfp, struct sfp_eeprom_id *id)
 	return 0;
 }
 
+static int sfp_module_parse_sff8472(struct sfp *sfp)
+{
+	/* If the module requires address swap mode, warn about it */
+	if (sfp->id.ext.diagmon & SFP_DIAGMON_ADDRMODE)
+		dev_warn(sfp->dev,
+			 "module address swap to access page 0xA2 is not supported.\n");
+	else
+		sfp->have_a2 = true;
+
+	return 0;
+}
+
 static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 {
 	/* SFP module inserted - read I2C data */
@@ -2053,10 +2057,11 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 		return -EINVAL;
 	}
 
-	/* If the module requires address swap mode, warn about it */
-	if (sfp->id.ext.diagmon & SFP_DIAGMON_ADDRMODE)
-		dev_warn(sfp->dev,
-			 "module address swap to access page 0xA2 is not supported.\n");
+	if (sfp->id.ext.sff8472_compliance != SFP_SFF8472_COMPLIANCE_NONE) {
+		ret = sfp_module_parse_sff8472(sfp);
+		if (ret < 0)
+			return ret;
+	}
 
 	/* Parse the module power requirement */
 	ret = sfp_module_parse_power(sfp);
@@ -2103,6 +2108,7 @@ static void sfp_sm_mod_remove(struct sfp *sfp)
 
 	memset(&sfp->id, 0, sizeof(sfp->id));
 	sfp->module_power_mW = 0;
+	sfp->have_a2 = false;
 
 	dev_info(sfp->dev, "module removed\n");
 }
-- 
2.30.2


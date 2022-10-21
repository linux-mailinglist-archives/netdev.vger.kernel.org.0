Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9BD607A26
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 17:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbiJUPJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 11:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbiJUPJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 11:09:50 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B67A43319;
        Fri, 21 Oct 2022 08:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=LEl2O/fI7GvSyP25iwbDuIU3/zvLVWEHPnzAHERTI6M=; b=NliNnMbxGK6oeMCZgtbOGYi7T5
        +dKGRfdcOSTWjbsNOlepsImxp4RkioVKNr31nRMmdy47Kvel0hirgHXP8Iz3UaG/0ABNVczodZg3K
        Uk5NaQ1KE52d8PVOnPofTWcINSMh1CzSL7PskrHnmjq8AA8YNdKbP/xrJOO49XJv7ptfFQUjfKsa1
        /5wXILPXHftMWg60wBMB9kAQi1BudnUUcTlwZmoHb7lPaAB215Hsu7ZmTl7yCNJM/KTMjWH2Nhy3A
        eGzY5CpRI79hR6Qnms2OibyQCETBN5U3CQZeRN+zzmcRO5k4DoCtZBJxanUnxXWhztdSHcWmFfyai
        3FyqqAuQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:60356 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1oltea-0000MG-Kf; Fri, 21 Oct 2022 16:09:44 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1olteZ-00Fwwo-UC; Fri, 21 Oct 2022 16:09:44 +0100
In-Reply-To: <Y1K17UtfFopACIi2@shell.armlinux.org.uk>
References: <Y1K17UtfFopACIi2@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, devicetree@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH net-next 2/7] net: sfp: check firmware provided max power
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1olteZ-00Fwwo-UC@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 21 Oct 2022 16:09:43 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check that the firmware provided maximum power is at least 1W, which
iis the minimum power level for any SFP module.

Now that we enforce the minimum of 1W, we can exit early from
sfp_module_parse_power() if the module power is 1W or less.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 40c9a64c5e30..f7ad4d5d9041 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1766,6 +1766,12 @@ static int sfp_module_parse_power(struct sfp *sfp)
 	if (sfp->id.ext.options & cpu_to_be16(SFP_OPTIONS_HIGH_POWER_LEVEL))
 		power_mW = 2000;
 
+	/* Power level 1 modules (max. 1W) are always supported. */
+	if (power_mW <= 1000) {
+		sfp->module_power_mW = power_mW;
+		return 0;
+	}
+
 	supports_a2 = sfp->id.ext.sff8472_compliance !=
 				SFP_SFF8472_COMPLIANCE_NONE ||
 		      sfp->id.ext.diagmon & SFP_DIAGMON_DDM;
@@ -1789,12 +1795,6 @@ static int sfp_module_parse_power(struct sfp *sfp)
 		}
 	}
 
-	if (power_mW <= 1000) {
-		/* Modules below 1W do not require a power change sequence */
-		sfp->module_power_mW = power_mW;
-		return 0;
-	}
-
 	if (!supports_a2) {
 		/* The module power level is below the host maximum and the
 		 * module appears not to implement bus address 0xa2, so assume
@@ -2729,8 +2729,12 @@ static int sfp_probe(struct platform_device *pdev)
 
 	device_property_read_u32(&pdev->dev, "maximum-power-milliwatt",
 				 &sfp->max_power_mW);
-	if (!sfp->max_power_mW)
+	if (sfp->max_power_mW < 1000) {
+		if (sfp->max_power_mW)
+			dev_warn(sfp->dev,
+				 "Firmware bug: host maximum power should be at least 1W\n");
 		sfp->max_power_mW = 1000;
+	}
 
 	dev_info(sfp->dev, "Host maximum power %u.%uW\n",
 		 sfp->max_power_mW / 1000, (sfp->max_power_mW / 100) % 10);
-- 
2.30.2


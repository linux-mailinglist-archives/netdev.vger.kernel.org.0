Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4021C6047A3
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 15:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232245AbiJSNmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 09:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbiJSNl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 09:41:56 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D2F627C
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 06:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=LEl2O/fI7GvSyP25iwbDuIU3/zvLVWEHPnzAHERTI6M=; b=C12ECMfluhZ2Euj4kyuh7oDmwN
        VqAgCBD7s1CtR+e8OE56BnSgBgV4VAB5yR+as4rUfmN9U8kQStPdiJh6EWo5J7Vd8icDK2XqSNd0h
        NXe8r+wi43kSVYaxM442u9ZGAdLjWxEJNqO8GQzoOpuKGISGwLQpXwKNRBaGFkObbnweb27oHRJgz
        M+Iv1SiHIUbDqGdb9Sq5lZ6CfOaw2aDlZELaKTJM4tigGNEKWe7nVaa+K77xvpXHYJT9wje9E5qZg
        EDv+XoOWD/VnhcoKy4z03knxaGrmzN8et/BRxrKEih5+Xyq1gzJmt/kWPtRlxPNvrBz2HcoDtdvwt
        DuqoWFcQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:55780 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ol97r-0005jE-RR; Wed, 19 Oct 2022 14:28:51 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1ol97r-00EDSX-8Z; Wed, 19 Oct 2022 14:28:51 +0100
In-Reply-To: <Y0/7dAB8OU3jrbz6@shell.armlinux.org.uk>
References: <Y0/7dAB8OU3jrbz6@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 2/7] net: sfp: check firmware provided max power
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ol97r-00EDSX-8Z@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 19 Oct 2022 14:28:51 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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


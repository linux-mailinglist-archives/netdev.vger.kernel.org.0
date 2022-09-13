Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40FE65B7A8B
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 21:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbiIMTHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 15:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbiIMTG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 15:06:59 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 739BF402F2
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 12:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=9rT1Tgvz6TxW1DvAMjcRhrvxPgqjbnSYXA4Va4DdTrs=; b=dirr/eppHeJLTjpODcBel7Uosk
        XwOSexsjoklh/bceqe/3zzwvYGbyyICTK3gjH+DGoSa8EvyemLFQdWen0rVVvprB9Gt8CUGkHt60c
        r1eY0HlQSZ8ODAFHYdfJz89dvESosSU2CvxZ+hxQL+F9SAZydamAnsuywPPD3ehzqlmZUY/8kurgc
        /hCxXSxyOsXS+643r8HMVKYu1+gI7WAMU91+MJbRjnuz/Vxu7oZKCp9m6pZ+K9MW87+eX0WTdVHBi
        E5C35gtaxdU8Y1HLwQe28bOFU7/Fd3xJlhdn4tH27InLOXbtPhp46LUiX3mHpZhZNKv2PtKYJhXvC
        Km42r3QA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:51750 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1oYBFA-0003RS-Ll; Tue, 13 Sep 2022 20:06:48 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1oYBFA-006kCQ-15; Tue, 13 Sep 2022 20:06:48 +0100
In-Reply-To: <YyDUnvM1b0dZPmmd@shell.armlinux.org.uk>
References: <YyDUnvM1b0dZPmmd@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Josef Schlehofer <pepe.schlehofer@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 5/5] net: sfp: add support for HALNy GPON SFP
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1oYBFA-006kCQ-15@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 13 Sep 2022 20:06:48 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a quirk for the HALNy HL-GSFP module, which appears to have an
inverted RX_LOS signal, and maybe uses TX_FAULT as a serial port
transmit pin. Rather than use these hardware signals, switch to
using software polling for these status signals.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp-bus.c |  2 +-
 drivers/net/phy/sfp.c     | 21 ++++++++++++++++++---
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index 82216c7bb470..0a9099c77694 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -283,7 +283,7 @@ void sfp_parse_support(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
 			phylink_set(modes, 2500baseX_Full);
 	}
 
-	if (bus->sfp_quirk)
+	if (bus->sfp_quirk && bus->sfp_quirk->modes)
 		bus->sfp_quirk->modes(id, modes);
 
 	linkmode_or(support, support, modes);
diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index d2d66c691f97..cb1dbd0d9701 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -321,6 +321,15 @@ static void sfp_fixup_ignore_tx_fault(struct sfp *sfp)
 	sfp->tx_fault_ignore = true;
 }
 
+static void sfp_fixup_halny_gsfp(struct sfp *sfp)
+{
+	/* Ignore the TX_FAULT and LOS signals on this module.
+	 * these are possibly used for other purposes on this
+	 * module, e.g. a serial port.
+	 */
+	sfp->state_hw_mask &= ~(SFP_F_TX_FAULT | SFP_F_LOS);
+}
+
 static void sfp_quirk_2500basex(const struct sfp_eeprom_id *id,
 				unsigned long *modes)
 {
@@ -352,6 +361,10 @@ static const struct sfp_quirk sfp_quirks[] = {
 		.part = "3FE46541AA",
 		.modes = sfp_quirk_2500basex,
 		.fixup = sfp_fixup_long_startup,
+	}, {
+		.vendor = "HALNy",
+		.part = "HL-GSFP",
+		.fixup = sfp_fixup_halny_gsfp,
 	}, {
 		// Huawei MA5671A can operate at 2500base-X, but report 1.2GBd
 		// NRZ in their EEPROM
@@ -369,16 +382,18 @@ static const struct sfp_quirk sfp_quirks[] = {
 		.vendor = "UBNT",
 		.part = "UF-INSTANT",
 		.modes = sfp_quirk_ubnt_uf_instant,
-	},
+	}
 };
 
 static size_t sfp_strlen(const char *str, size_t maxlen)
 {
 	size_t size, i;
 
-	/* Trailing characters should be filled with space chars */
+	/* Trailing characters should be filled with space chars, but
+	 * some manufacturers can't read SFF-8472 and use NUL.
+	 */
 	for (i = 0, size = 0; i < maxlen; i++)
-		if (str[i] != ' ')
+		if (str[i] != ' ' && str[i] != '\0')
 			size = i + 1;
 
 	return size;
-- 
2.30.2


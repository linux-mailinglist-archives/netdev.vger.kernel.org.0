Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5CF76C3785
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 17:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbjCUQ7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 12:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbjCUQ65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 12:58:57 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54A0E29E2D
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 09:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=QMQAHEdXtPGdD8ReCxGqpglaylXFVcfOIh8ovrgV3dQ=; b=LqYvwAcOCld+GcGHZnmceFhN6x
        UFvEw0ZdlOaldG1cnzvXRToFbrqM0ZyXfUd5uJeFOB1M1DJGs5wLyKLAxomr5Zpao+6BDjVrz/gqL
        g3Us2uyi8wEgEjKU2gCtH67Kr0T8EY8LT7N/LTZBabnSFFrNh5uGdsNqi02qhV2tnGMXv1bCAKipQ
        rggH/CdttrUp6xZPF0Ptroswt4WR8eAM8eHi8FLlt5MXYEJkCCwQRW2qbQfZTrXmaqj1OPIM5U/Lq
        jpMaeWU8hxlEeLuEbNnuoCH8irq3qHfzcOSlM50BB6CcHw58pCyvEz3oUPsmo8CMvBupQ0XJMRlEI
        Y1GTcDkw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:55156 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1pefK0-0001aT-Dt; Tue, 21 Mar 2023 16:58:52 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1pefJz-00Dn4V-Oc; Tue, 21 Mar 2023 16:58:51 +0000
In-Reply-To: <ZBniMlTDZJQ242DP@shell.armlinux.org.uk>
References: <ZBniMlTDZJQ242DP@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 2/2] net: sfp: add quirk for 2.5G copper SFP
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1pefJz-00Dn4V-Oc@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 21 Mar 2023 16:58:51 +0000
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a quirk for a copper SFP that identifies itself as "OEM"
"SFP-2.5G-T". This module's PHY is inaccessible, and can only run
at 2500base-X with the host without negotiation. Add a quirk to
enable the 2500base-X interface mode with 2500base-T support, and
disable autonegotiation.

Reported-by: Frank Wunderlich <frank-w@public-files.de>
Tested-by: Frank Wunderlich <frank-w@public-files.de>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 39e3095796d0..9c1fa0b1737f 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -360,6 +360,23 @@ static void sfp_quirk_2500basex(const struct sfp_eeprom_id *id,
 	__set_bit(PHY_INTERFACE_MODE_2500BASEX, interfaces);
 }
 
+static void sfp_quirk_disable_autoneg(const struct sfp_eeprom_id *id,
+				      unsigned long *modes,
+				      unsigned long *interfaces)
+{
+	linkmode_clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, modes);
+}
+
+static void sfp_quirk_oem_2_5g(const struct sfp_eeprom_id *id,
+			       unsigned long *modes,
+			       unsigned long *interfaces)
+{
+	/* Copper 2.5G SFP */
+	linkmode_set_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT, modes);
+	__set_bit(PHY_INTERFACE_MODE_2500BASEX, interfaces);
+	sfp_quirk_disable_autoneg(id, modes, interfaces);
+}
+
 static void sfp_quirk_ubnt_uf_instant(const struct sfp_eeprom_id *id,
 				      unsigned long *modes,
 				      unsigned long *interfaces)
@@ -401,6 +418,7 @@ static const struct sfp_quirk sfp_quirks[] = {
 	SFP_QUIRK_M("UBNT", "UF-INSTANT", sfp_quirk_ubnt_uf_instant),
 
 	SFP_QUIRK_F("OEM", "SFP-10G-T", sfp_fixup_rollball_cc),
+	SFP_QUIRK_M("OEM", "SFP-2.5G-T", sfp_quirk_oem_2_5g),
 	SFP_QUIRK_F("OEM", "RTSFP-10", sfp_fixup_rollball_cc),
 	SFP_QUIRK_F("OEM", "RTSFP-10G", sfp_fixup_rollball_cc),
 	SFP_QUIRK_F("Turris", "RTSFP-10", sfp_fixup_rollball),
-- 
2.30.2


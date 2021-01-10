Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9619E2F0686
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 12:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbhAJK7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 05:59:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbhAJK7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 05:59:34 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE908C06179F
        for <netdev@vger.kernel.org>; Sun, 10 Jan 2021 02:58:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=c1hRthT9Qdvy627OWItLpImU4re/agKR/kznKDtpav8=; b=GI/EK5/Jp1u4uxwTl+HpJmt9Yv
        nSEJfyX264Kh2givLQmKbxDGYoGDZhi/gh+AjoQpg8zPZhLnJgcs27FzN9O0GHrtWdrptickiPKRU
        1uTVy6tTNxFZv3ueQbzCmDYAHhZcaJmYnneYu7fWkQmKCglitrVZXFCD3TgAGe9lhI9LtZ5ZlZvwv
        xMPTTs9CDaJwnSlTUyVSwbMl8o7YW/bsoDZwr5/UKXNFzVPr54QRUVDyTnD2VRzUCYugP+2S0Td4U
        1bxh5qufcY9Tunp0uJYIvqB2X6WyECFMQUzJ7/98VIfsdyCx4YQ/3Pk8HXRGhg5R74JeLx19WWZWt
        +kq5MKtA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:52390 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kyYQf-0005mN-Mp; Sun, 10 Jan 2021 10:58:37 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kyYQf-0004iY-Gh; Sun, 10 Jan 2021 10:58:37 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: sfp: extend bitrate-derived mode for 2500BASE-X
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1kyYQf-0004iY-Gh@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Sun, 10 Jan 2021 10:58:37 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend the bitrate-derived support to include 2500BASE-X for modules
that report a bitrate of 2500Mbaud.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp-bus.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index 20b91f5dfc6e..cdfa0a190962 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -337,11 +337,16 @@ void sfp_parse_support(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
 	 * the bitrate to determine supported modes. Some BiDi modules (eg,
 	 * 1310nm/1550nm) are not 1000BASE-BX compliant due to the differing
 	 * wavelengths, so do not set any transceiver bits.
+	 *
+	 * Do the same for modules supporting 2500BASE-X. Note that some
+	 * modules use 2500Mbaud rather than 3100 or 3200Mbaud for
+	 * 2500BASE-X, so we allow some slack here.
 	 */
-	if (bitmap_empty(modes, __ETHTOOL_LINK_MODE_MASK_NBITS)) {
-		/* If the bit rate allows 1000baseX */
-		if (br_nom && br_min <= 1300 && br_max >= 1200)
+	if (bitmap_empty(modes, __ETHTOOL_LINK_MODE_MASK_NBITS) && br_nom) {
+		if (br_min <= 1300 && br_max >= 1200)
 			phylink_set(modes, 1000baseX_Full);
+		if (br_min <= 3200 && br_max >= 2500)
+			phylink_set(modes, 2500baseX_Full);
 	}
 
 	if (bus->sfp_quirk)
-- 
2.20.1


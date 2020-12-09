Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D102C2D4106
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 12:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730619AbgLILYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 06:24:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730603AbgLILXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 06:23:51 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D34C6C0613D6
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 03:22:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OEDVDE/xEL05ovSB3PfOug8zkNZummDynkLO9O8MuXA=; b=0UARzHKcbzo4JdPTZeh+oMcBLa
        YIl0uwXOG7OD3AlixNhwnxlKj/hWonQWwSpO/fOtk3eeli99dPIR78oNkefY3KHEPXmEweQE+DywC
        BTZrVcDGwl9U90i16u/vTD6SuOaQolfruvjiA7FxnKo2bHOv1Nre/MDHbRNSOCZbnZUqYpom82Pvs
        Ld6OzMTIr33+i/U6OM5R4fTo30frR0eh3WZoOU0V/geNPQwMNtT7idBaZJJUAGqEYA+VROC0RDcJF
        g/WISotCaZjzfSHGkcTgrSSlpFhur1/grkgG6cYr6pVQKmAoEUBAlgUc9kjSHTa/l+SPxX0Xp2GzO
        0jmk9m3g==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:52478 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kmxYc-0002Ja-JK; Wed, 09 Dec 2020 11:22:54 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kmxYc-0001cd-Bt; Wed, 09 Dec 2020 11:22:54 +0000
In-Reply-To: <20201209112152.GT1551@shell.armlinux.org.uk>
References: <20201209112152.GT1551@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Pali Rohar <pali@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 2/2] net: sfp: relax bitrate-derived mode check
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1kmxYc-0001cd-Bt@rmk-PC.armlinux.org.uk>
Sender: "Russell King,,," <rmk@armlinux.org.uk>
Date:   Wed, 09 Dec 2020 11:22:54 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not check the encoding when deriving 1000BASE-X from the bitrate
when no other modes are discovered. Some GPON modules (VSOL V2801F
and CarlitoxxPro CPGOS03-0490 v2.0) indicate NRZ encoding with a
1200Mbaud bitrate, but should be driven with 1000BASE-X on the host
side.

Tested-by: Pali Rohár <pali@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp-bus.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index 58014feedf6c..20b91f5dfc6e 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -334,14 +334,13 @@ void sfp_parse_support(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
 	}
 
 	/* If we haven't discovered any modes that this module supports, try
-	 * the encoding and bitrate to determine supported modes. Some BiDi
-	 * modules (eg, 1310nm/1550nm) are not 1000BASE-BX compliant due to
-	 * the differing wavelengths, so do not set any transceiver bits.
+	 * the bitrate to determine supported modes. Some BiDi modules (eg,
+	 * 1310nm/1550nm) are not 1000BASE-BX compliant due to the differing
+	 * wavelengths, so do not set any transceiver bits.
 	 */
 	if (bitmap_empty(modes, __ETHTOOL_LINK_MODE_MASK_NBITS)) {
-		/* If the encoding and bit rate allows 1000baseX */
-		if (id->base.encoding == SFF8024_ENCODING_8B10B && br_nom &&
-		    br_min <= 1300 && br_max >= 1200)
+		/* If the bit rate allows 1000baseX */
+		if (br_nom && br_min <= 1300 && br_max >= 1200)
 			phylink_set(modes, 1000baseX_Full);
 	}
 
-- 
2.20.1


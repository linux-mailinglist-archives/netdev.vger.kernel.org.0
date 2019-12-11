Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F99411A961
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 11:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728962AbfLKK5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 05:57:15 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39610 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728128AbfLKK5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 05:57:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=06q9jwP3+FgUh4vFeDEfGmurYWhjIb9617vtGtXRFSI=; b=1B95BP2hjStX7S30KttTleXort
        QQtCZV4QQqKerod2pZzHPWZd0O4F/KHUQFZw+ESFA5wO9nhAey3iHZi8nslEwf7KKm5XXK1kj2rpx
        LcrCXz8qd9ZzHBcfenNcQSNpXnyW9PxYUfwnpPo2YRmtpbVp146Zkl3dBRG0dN1ELdzKa2tl9sIop
        VYnBtRMpdX6ngmVXg8hCvJQm8pWIOvPGmbib3tkna6PiDqU6W0rO4a5IICZHvP4yTRE1lRoJugzGS
        9ocFIvptuNc3kqmYXkvSDEV6XrmZuRsq3nKrGoybB14rFJduswWqce90Lk8jRv1opnCp9M77CfQPb
        jY+8DQ3A==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:56752 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iezfp-0007vg-JD; Wed, 11 Dec 2019 10:56:53 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iezfm-0002yu-SG; Wed, 11 Dec 2019 10:56:50 +0000
In-Reply-To: <20191211104821.GB25745@shell.armlinux.org.uk>
References: <20191211104821.GB25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next v3 12/14] net: phylink: make Broadcom BCM84881 based
 SFPs work
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iezfm-0002yu-SG@rmk-PC.armlinux.org.uk>
Date:   Wed, 11 Dec 2019 10:56:50 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Broadcom BCM84881 does not appear to send the SGMII control word
when operating in SGMII mode, which causes network adapters to fail
to link with the PHY, or decide to operate at fixed 1G speed, even if
the PHY negotiated 100M.

Work around this by detecting the Broadcom BCM84881 and switch to phy
mode rather than inband mode.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 6e166449736a..e49232266c79 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1840,10 +1840,20 @@ static void phylink_sfp_link_up(void *upstream)
 	phylink_run_resolve(pl);
 }
 
+/* The Broadcom BCM84881 in the Methode DM7052 is unable to provide a SGMII
+ * or 802.3z control word, so inband will not work.
+ */
+static bool phylink_phy_no_inband(struct phy_device *phy)
+{
+	return phy->is_c45 &&
+		(phy->c45_ids.device_ids[1] & 0xfffffff0) == 0xae025150;
+}
+
 static int phylink_sfp_connect_phy(void *upstream, struct phy_device *phy)
 {
 	struct phylink *pl = upstream;
 	phy_interface_t interface;
+	u8 mode;
 	int ret;
 
 	/*
@@ -1855,9 +1865,13 @@ static int phylink_sfp_connect_phy(void *upstream, struct phy_device *phy)
 	 */
 	phy_support_asym_pause(phy);
 
+	if (phylink_phy_no_inband(phy))
+		mode = MLO_AN_PHY;
+	else
+		mode = MLO_AN_INBAND;
+
 	/* Do the initial configuration */
-	ret = phylink_sfp_config(pl, MLO_AN_INBAND, phy->supported,
-				 phy->advertising);
+	ret = phylink_sfp_config(pl, mode, phy->supported, phy->advertising);
 	if (ret < 0)
 		return ret;
 
-- 
2.20.1


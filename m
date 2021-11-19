Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE904572E7
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 17:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236466AbhKSQbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 11:31:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234030AbhKSQbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 11:31:17 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FB6C061574
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 08:28:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=wyd4TNfIBWVoNo7dirLwTej1yW+sxkv2tuHYN6Fd29w=; b=wg0rzuRAEOcAxuw66E3FB0P8+/
        g/x7kImgOPI35cpCMRQmy83BsHgS5i7siGyt3opnJo07orfoiVLgCrAkZmwTuUE3rzbWRgIUgEWC8
        dIi7W+mgcjcuyhUxvmYEi9pqMPToHo+i5F1M1I2oYYDtehgs5FfQuX+mGa1aa/hG34k9j53U4bxK5
        5UvH1F1XN2J+8FFTmndAQfUQDLdBS9j1ueNXipaK5f0KlrjiJBSeKa8+Pox0MGfsp6cjpOtk3BQ8Z
        SJC9jx0HrJLJZU5A0xwtx5VRwj2i5HSl42W9S+wVF3Za2PP5/ZFBGftxb2gzYnXhQzb2jV4/Pp/Vv
        IAYI6hsg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:34182 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mo6kB-0004Ah-Cn; Fri, 19 Nov 2021 16:28:07 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mo6kA-008ZGa-Ut; Fri, 19 Nov 2021 16:28:06 +0000
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next] net: phylink: handle NA interface mode in
 phylink_fwnode_phy_connect()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mo6kA-008ZGa-Ut@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 19 Nov 2021 16:28:06 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 4904b6ea1f9db ("net: phy: phylink: Use PHY device interface if
N/A") introduced handling for the phy interface mode where this is not
known at phylink creation time. This was never added to the OF/fwnode
paths, but is necessary when the phy is present in DT, but the phy-mode
is not specified.

Add this handling.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
Hi Florian,

It owuld be useful to have your ACK for this since you were the original
author for the above referenced commit. Thanks!

 drivers/net/phy/phylink.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index da17b874a5e7..f34550c8e90d 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1325,7 +1325,8 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 	mutex_unlock(&phy->lock);
 
 	phylink_dbg(pl,
-		    "phy: setting supported %*pb advertising %*pb\n",
+		    "phy: %s setting supported %*pb advertising %*pb\n",
+		    phy_modes(interface),
 		    __ETHTOOL_LINK_MODE_MASK_NBITS, pl->supported,
 		    __ETHTOOL_LINK_MODE_MASK_NBITS, phy->advertising);
 
@@ -1443,6 +1444,12 @@ int phylink_fwnode_phy_connect(struct phylink *pl,
 	if (!phy_dev)
 		return -ENODEV;
 
+	/* Use PHY device/driver interface */
+	if (pl->link_interface == PHY_INTERFACE_MODE_NA) {
+		pl->link_interface = phy_dev->interface;
+		pl->link_config.interface = pl->link_interface;
+	}
+
 	ret = phy_attach_direct(pl->netdev, phy_dev, flags,
 				pl->link_interface);
 	if (ret) {
-- 
2.30.2


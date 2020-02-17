Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8C841616C0
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 16:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729657AbgBQPyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 10:54:39 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:38442 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729403AbgBQPyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 10:54:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Lf24WDbhc+25UU592c5vJ/TsmajLG4PU4lv/sweCPu4=; b=En4e4eDrpnx3UpY1PJ45A7S/Sp
        brpRknun24bgrfs3WIg3Iqqg/qSEt5Mu2OvAGpIm8ewB03BKh6uhjPUcn7knFFnu8ihsHu//gV6zZ
        xl/aJRZAx9sCMeUVVDjVUilck+bnlqSu/ds20AhroyCOxz5YUtU8FIdz8LI7GQBmRbRmIhC79wpd9
        T8nQRSBoagQXnl5z3ttMqfmLj4XZ7yOS4h9OiL4VAoKmJB2s06/eNulzZobOyeKk/a7TZp07uVdVH
        Qb8HX8YM+pxsNWoJLPnzZW0QYaHYXNLeQzoVBszLKihMlRe1V8+cRWrKIvtDfRhH8Lz6ZpPIvsJJ1
        bhQkh11g==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:40676 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j3ijA-0001i4-1z; Mon, 17 Feb 2020 15:54:32 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j3ij8-0006Ee-Lk; Mon, 17 Feb 2020 15:54:30 +0000
In-Reply-To: <20200217155346.GW25745@shell.armlinux.org.uk>
References: <20200217155346.GW25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 3/4] net: phy: add resolved pause support
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j3ij8-0006Ee-Lk@rmk-PC.armlinux.org.uk>
Date:   Mon, 17 Feb 2020 15:54:30 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow phylib drivers to pass the hardware-resolved pause state to MAC
drivers, rather than using the software-based pause resolution code.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phy_device.c | 6 ++++++
 include/linux/phy.h          | 9 +++++++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 2a973265de80..6e1b50defd62 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2414,6 +2414,12 @@ void phy_get_pause(struct phy_device *phydev, bool *tx_pause, bool *rx_pause)
 		return;
 	}
 
+	if (phydev->resolved_pause_valid) {
+		*tx_pause = phydev->resolved_tx_pause;
+		*rx_pause = phydev->resolved_rx_pause;
+		return;
+	}
+
 	return linkmode_resolve_pause(phydev->advertising,
 				      phydev->lp_advertising,
 				      tx_pause, rx_pause);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 80f8b2158271..fda23d95e640 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -422,6 +422,15 @@ struct phy_device {
 	int pause;
 	int asym_pause;
 
+	/*
+	 * private to phylib: the resolved pause state - only valid if
+	 * resolved_pause_valid is true. only phy drivers and phylib
+	 * should touch this.
+	 */
+	bool resolved_pause_valid;
+	bool resolved_tx_pause;
+	bool resolved_rx_pause;
+
 	/* Union of PHY and Attached devices' supported link modes */
 	/* See ethtool.h for more info */
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported);
-- 
2.20.1


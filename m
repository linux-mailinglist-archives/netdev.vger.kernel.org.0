Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACA60116E9B
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 15:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbfLIOIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 09:08:14 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34378 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727540AbfLIOIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 09:08:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=s6T459SnT95vLOb60Er94Do1O4ZqrTnavwtfrNVVSyM=; b=tB6XM5MN8N2vgBS4t2N9ko0aMI
        slphVqZnYvNk64GqBpe7s2r0bADB+5WYVFjJ0PV1mJ7aaufzL9VEzVdnzlyBQZ4WGxag0DKSjRtW5
        LLa3ODdKGCeMloTyXA22X1P2fNwApmPuo48DpcINrBLh+5eOhkxFH2K+bTiKto0dNgNl52eKrFIr5
        h9nSHXvwAs7YxvDE5MLKVnRnGknvDKqlwAfb8eznC7C/uWdMzmlK2lpiVi2V0l/j+RxSIGSxaG4cq
        RJpbPao2lEBg9WMzNZf66GXnLAjf7qVSpWkAh5xZLoBMTCAs2VvVKgDY/zxZp/76nC64Az8TQcWZQ
        huFRwv8w==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:54428 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ieJhT-0003R4-4h; Mon, 09 Dec 2019 14:07:47 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ieJhP-0004Pc-8e; Mon, 09 Dec 2019 14:07:43 +0000
In-Reply-To: <20191209140258.GI25745@shell.armlinux.org.uk>
References: <20191209140258.GI25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net-next 12/14] net: phylink: make Broadcom BCM84881 based
 SFPs work
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ieJhP-0004Pc-8e@rmk-PC.armlinux.org.uk>
Date:   Mon, 09 Dec 2019 14:07:43 +0000
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

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index c3eda3800357..66b4357ccbda 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1842,10 +1842,20 @@ static void phylink_sfp_link_up(void *upstream)
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
@@ -1857,9 +1867,13 @@ static int phylink_sfp_connect_phy(void *upstream, struct phy_device *phy)
 	 */
 	phy_support_asym_pause(phy);
 
+	if (phylink_phy_no_inband(phy))
+		mode = MLO_AN_PHY;
+	else
+		mode = MLO_AN_INBAND;
+
 	/* Do the initial configuration */
-	ret = phylink_sfp_config(pl, ML_AN_INBAND, phy->supported,
-				 phy->advertising);
+	ret = phylink_sfp_config(pl, mode, phy->supported, phy->advertising);
 	if (ret < 0)
 		return ret;
 
-- 
2.20.1


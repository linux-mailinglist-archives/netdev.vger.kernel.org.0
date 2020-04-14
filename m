Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99E7D1A8B7F
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 21:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391495AbgDNTvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 15:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2505217AbgDNTtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 15:49:11 -0400
X-Greylist: delayed 4727 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 14 Apr 2020 12:49:11 PDT
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D3DDC061A10
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 12:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=EMZ/WXw28A7im/4Ev+3I3YTLD3dosgkfIs0QZPb9/JA=; b=r+D23KpgZwu/9NTTI5ZUZRg7ks
        cvnu1fDn/ewXN2Qx5bZ4QtK3Z3mMMft3XO0s16fW4s9dN0a9fHr6/DveLRzCZQ6MVe266Y89m0WDI
        A74/4n8h71oIp4UGmhCltmUTTTeaAK+GXOFrCUJs3UklxjtpLy/vw/2sXZ8QYly314tsUouTQr5lN
        5HF7aCi6G5LoE6EHiYlT8bsOMFcs4XEcGHZXZpuQUEd3jrN7xaJF++xIGXJNNsZrErxf8eZK/kwgV
        Yeb7rghpvhoefqo8OfkmxsFXAKB0WUNOWELkDhi9nCc/dCAtRrJi6SqWaMY8HIrO/ReALygCkmQE2
        LQqt5w8g==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:54214 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jORYO-0001lR-0t; Tue, 14 Apr 2020 20:49:04 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jORYN-000401-3U; Tue, 14 Apr 2020 20:49:03 +0100
In-Reply-To: <20200414194753.GB25745@shell.armlinux.org.uk>
References: <20200414194753.GB25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Matteo Croce <mcroce@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH net v2 1/2] net: marvell10g: report firmware version
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jORYN-000401-3U@rmk-PC.armlinux.org.uk>
Date:   Tue, 14 Apr 2020 20:49:03 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Report the firmware version when probing the PHY to allow issues
attributable to firmware to be diagnosed.

Tested-by: Matteo Croce <mcroce@redhat.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/marvell10g.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 7621badae64d..748532d9e1ae 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -33,6 +33,8 @@
 #define MV_PHY_ALASKA_NBT_QUIRK_REV	(MARVELL_PHY_ID_88X3310 | 0xa)
 
 enum {
+	MV_PMA_FW_VER0		= 0xc011,
+	MV_PMA_FW_VER1		= 0xc012,
 	MV_PMA_BOOT		= 0xc050,
 	MV_PMA_BOOT_FATAL	= BIT(0),
 
@@ -83,6 +85,8 @@ enum {
 };
 
 struct mv3310_priv {
+	u32 firmware_ver;
+
 	struct device *hwmon_dev;
 	char *hwmon_name;
 };
@@ -355,6 +359,22 @@ static int mv3310_probe(struct phy_device *phydev)
 
 	dev_set_drvdata(&phydev->mdio.dev, priv);
 
+	ret = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MV_PMA_FW_VER0);
+	if (ret < 0)
+		return ret;
+
+	priv->firmware_ver = ret << 16;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MV_PMA_FW_VER1);
+	if (ret < 0)
+		return ret;
+
+	priv->firmware_ver |= ret;
+
+	phydev_info(phydev, "Firmware version %u.%u.%u.%u\n",
+		    priv->firmware_ver >> 24, (priv->firmware_ver >> 16) & 255,
+		    (priv->firmware_ver >> 8) & 255, priv->firmware_ver & 255);
+
 	/* Powering down the port when not in use saves about 600mW */
 	ret = mv3310_power_down(phydev);
 	if (ret)
-- 
2.20.1


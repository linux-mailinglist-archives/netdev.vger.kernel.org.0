Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3AB2B426A
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 12:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729404AbgKPLP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 06:15:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:55620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726353AbgKPLP1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 06:15:27 -0500
Received: from dellmb.labs.office.nic.cz (nat-1.nic.cz [217.31.205.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6840822263;
        Mon, 16 Nov 2020 11:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605525326;
        bh=C0AJ+ZLPZUyrlH7UNBZgTfeflDN7cswS0QlQC5XiO4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JpVE4rJNjbLuJBgYPH7upTfAfhTJnBJFKPKyZnIefTNIPURiCH4Y8uAbSmi7ioxc/
         +s85YOShrLYitzevngxMH9nppup2FqvyKmNPpjNAhRVLG2keYN1h3PlsfDwtJqEDFT
         wuNAzYE1Ki+vscFaCcIDAJgTkWzpHeUnDUnG2vNg=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Russell King <rmk+kernel@armlinux.org.uk>, netdev@vger.kernel.org,
        davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v3 4/5] net: phy: marvell10g: change MACTYPE if underlying MAC does not support it
Date:   Mon, 16 Nov 2020 12:15:10 +0100
Message-Id: <20201116111511.5061-5-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201116111511.5061-1-kabel@kernel.org>
References: <20201116111511.5061-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RollBall SFPs contain a Marvell 88X3310 PHY, but by default the MACTYPE
is set to 10GBASE-R with Rate Matching.

Some devices (for example those based on Armada 38x) only support up to
2500base-x SerDes modes.

Change the PHY's MACTYPE to 4 (which means changing between 10gbase-r,
5gbase-r, 2500base-x ans SGMII depending on copper speed) if this is the
case (which is infered from phydev->interface).

Signed-off-by: Marek Behún <kabel@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/marvell10g.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 1901ba277413..9e8e9aa66972 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -453,6 +453,33 @@ static bool mv3310_has_pma_ngbaset_quirk(struct phy_device *phydev)
 		MV_PHY_ALASKA_NBT_QUIRK_MASK) == MV_PHY_ALASKA_NBT_QUIRK_REV;
 }
 
+static int mv3310_select_mactype(struct phy_device *phydev)
+{
+	int mac_type, ret;
+
+	/* On some devices the MAC does not support 10G mode, but may support
+	 * lower modes, such as SGMII or 2500base-x.
+	 * By changing MACTYPE of the PHY to 4 in this case, we ensure that
+	 * the MAC will link with the PHY at least for these lower speeds.
+	 */
+	switch (phydev->interface) {
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_2500BASEX:
+		mac_type = 4;
+		break;
+	default:
+		return 0;
+	}
+
+	ret = phy_modify_mmd_changed(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL,
+				     MV_V2_PORT_MAC_TYPE_MASK, mac_type);
+	if (ret <= 0)
+		return ret;
+
+	return phy_modify_mmd(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL,
+			      MV_V2_PORT_CTRL_SWRST, MV_V2_PORT_CTRL_SWRST);
+}
+
 static int mv3310_config_init(struct phy_device *phydev)
 {
 	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
@@ -474,6 +501,10 @@ static int mv3310_config_init(struct phy_device *phydev)
 	if (err)
 		return err;
 
+	err = mv3310_select_mactype(phydev);
+	if (err)
+		return err;
+
 	val = phy_read_mmd(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL);
 	if (val < 0)
 		return val;
-- 
2.26.2


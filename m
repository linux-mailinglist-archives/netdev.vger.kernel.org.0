Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8FF13492E9
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 14:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbhCYNOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 09:14:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:52788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230476AbhCYNNo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 09:13:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8D23619FE;
        Thu, 25 Mar 2021 13:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616678024;
        bh=AGy39mxpzO9YbDrFrYnmmSNBQlvEaq72+Rxn1faWq4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D0pke2gqmttyIwotCSWXB2zIg/GSXGezlItEzpigjbRpobDZENbF77ysZQqqkBoSC
         FNgNP9zYU6nb4qfdlC8Lvu1XYt2viRfMPpXwp8VNNdmPsjSOiKOgQxZHH8HPSl0qme
         qZMsWp0w/l4ZNXy8q1pMdEU1sYaMCcrtNZmjoGm0pZUt4tPS1KFM+w0NGdZeMU6BIA
         20okar+ghQv6UMebBFBTLk+jvkaRW+bRZrbzEmE/GHWPELUtCwbmXyM0DMxH+2k/1p
         cF7MPKb75K8kOQmyB2n0ifyH+wXqtqzl3/Mx+f1F5XXhYa0Wu86s9Idh3T5GYXLZh0
         gAGxwdV+R26dg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>, kuba@kernel.org
Cc:     =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v2 11/12] net: phy: marvell10g: print exact model
Date:   Thu, 25 Mar 2021 14:12:49 +0100
Message-Id: <20210325131250.15901-12-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210325131250.15901-1-kabel@kernel.org>
References: <20210325131250.15901-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Print exact mode, one of
  88E2110
  88E2111
  88E2180
  88E2181
  88X3310
  88X3310P
  88X3340
  88X3340P

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/marvell10g.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 6df67c12f012..84f24fcb832c 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -33,6 +33,8 @@
 #define MV_PHY_ALASKA_NBT_QUIRK_REV	(MARVELL_PHY_ID_88X3310 | 0xa)
 
 enum {
+	MV_PMA_XGSTAT		= 0xc001,
+	MV_PMA_XGSTAT_NO_MACSEC	= BIT(12),
 	MV_PMA_FW_VER0		= 0xc011,
 	MV_PMA_FW_VER1		= 0xc012,
 	MV_PMA_21X0_PORT_CTRL	= 0xc04a,
@@ -397,6 +399,7 @@ static int mv3310_probe(struct phy_device *phydev)
 {
 	struct mv3310_priv *priv;
 	u32 mmd_mask = MDIO_DEVS_PMAPMD | MDIO_DEVS_AN;
+	bool has_5g, has_macsec;
 	int ret, nports;
 
 	if (!phydev->is_c45 ||
@@ -443,12 +446,24 @@ static int mv3310_probe(struct phy_device *phydev)
 
 	switch (phydev->drv->phy_id) {
 	case MARVELL_PHY_ID_88X3310:
+		ret = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MV_PMA_XGSTAT);
+		if (ret < 0)
+			return ret;
+
+		has_macsec = !(ret & MV_PMA_XGSTAT_NO_MACSEC);
+
 		if (nports == 4)
 			priv->model = MV_MODEL_88X3340;
 		else if (nports == 1)
 			priv->model = MV_MODEL_88X3310;
 		break;
 	case MARVELL_PHY_ID_88E2110:
+		ret = phy_read_mmd(phydev, MDIO_MMD_PCS, MDIO_SPEED);
+		if (ret < 0)
+			return ret;
+
+		has_5g = ret & MDIO_PCS_SPEED_5G;
+
 		if (nports == 8)
 			priv->model = MV_MODEL_88E218X;
 		else if (nports == 1)
@@ -458,7 +473,17 @@ static int mv3310_probe(struct phy_device *phydev)
 		unreachable();
 	}
 
-	if (!priv->model) {
+	switch (priv->model) {
+	case MV_MODEL_88E211X:
+	case MV_MODEL_88E218X:
+		phydev_info(phydev, "model 88E21%d%d\n", nports, !has_5g);
+		break;
+	case MV_MODEL_88X3310:
+	case MV_MODEL_88X3340:
+		phydev_info(phydev, "model 88X33%d0%s\n", nports,
+			    has_macsec ? "P" : "");
+		break;
+	default:
 		phydev_err(phydev, "unknown PHY model (nports = %i)\n", nports);
 		return -ENODEV;
 	}
-- 
2.26.2


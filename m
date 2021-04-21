Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 592B2367430
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 22:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245650AbhDUUfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 16:35:09 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:37894 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243645AbhDUUfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 16:35:03 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 416231F42694
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     netdev@vger.kernel.org, linux-rockchip@lists.infradead.org
Cc:     Jose Abreu <joabreu@synopsys.com>,
        Heiko Stuebner <heiko@sntech.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Peter Geis <pgwipeout@gmail.com>,
        Kever Yang <kever.yang@rock-chips.com>,
        David Wu <david.wu@rock-chips.com>, kernel@collabora.com,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v2 2/3] net: stmmac: dwmac-rk: Check platform-specific ops
Date:   Wed, 21 Apr 2021 17:34:08 -0300
Message-Id: <20210421203409.40717-3-ezequiel@collabora.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210421203409.40717-1-ezequiel@collabora.com>
References: <20210421203409.40717-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Wu <david.wu@rock-chips.com>

Add a check for non-null struct rk_gmac_ops for the
configured PHY interface mode, failing if unsupported.

Signed-off-by: David Wu <david.wu@rock-chips.com>
[Ezequiel: Refactor so it fails if unsupported]
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-rk.c    | 31 +++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
index c432a9592489..d2637d83899e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -1294,11 +1294,36 @@ static struct rk_priv_data *rk_gmac_setup(struct platform_device *pdev,
 	return bsp_priv;
 }
 
+static int rk_gmac_check_ops(struct rk_priv_data *bsp_priv)
+{
+	switch (bsp_priv->phy_iface) {
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+		if (!bsp_priv->ops->set_to_rgmii)
+			return -EINVAL;
+		break;
+	case PHY_INTERFACE_MODE_RMII:
+		if (!bsp_priv->ops->set_to_rmii)
+			return -EINVAL;
+		break;
+	default:
+		dev_err(&bsp_priv->pdev->dev,
+			"unsupported interface %d", bsp_priv->phy_iface);
+	}
+	return 0;
+}
+
 static int rk_gmac_powerup(struct rk_priv_data *bsp_priv)
 {
 	int ret;
 	struct device *dev = &bsp_priv->pdev->dev;
 
+	ret = rk_gmac_check_ops(bsp_priv);
+	if (ret)
+		return ret;
+
 	ret = gmac_clk_enable(bsp_priv, true);
 	if (ret)
 		return ret;
@@ -1369,10 +1394,12 @@ static void rk_fix_speed(void *priv, unsigned int speed)
 	case PHY_INTERFACE_MODE_RGMII_ID:
 	case PHY_INTERFACE_MODE_RGMII_RXID:
 	case PHY_INTERFACE_MODE_RGMII_TXID:
-		bsp_priv->ops->set_rgmii_speed(bsp_priv, speed);
+		if (bsp_priv->ops->set_rgmii_speed)
+			bsp_priv->ops->set_rgmii_speed(bsp_priv, speed);
 		break;
 	case PHY_INTERFACE_MODE_RMII:
-		bsp_priv->ops->set_rmii_speed(bsp_priv, speed);
+		if (bsp_priv->ops->set_rmii_speed)
+			bsp_priv->ops->set_rmii_speed(bsp_priv, speed);
 		break;
 	default:
 		dev_err(dev, "unsupported interface %d", bsp_priv->phy_iface);
-- 
2.30.0


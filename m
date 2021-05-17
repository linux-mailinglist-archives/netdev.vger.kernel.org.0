Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 677133837C9
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 17:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244751AbhEQPrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 11:47:06 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:53000 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244167AbhEQPmS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 11:42:18 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 8D5C71F40323
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     netdev@vger.kernel.org, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org
Cc:     Jose Abreu <joabreu@synopsys.com>,
        Heiko Stuebner <heiko@sntech.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Peter Geis <pgwipeout@gmail.com>,
        Kever Yang <kever.yang@rock-chips.com>,
        David Wu <david.wu@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>,
        Johan Jonker <jbx6244@gmail.com>,
        Chen-Yu Tsai <wens213@gmail.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v3 net-next 2/4] net: stmmac: dwmac-rk: Check platform-specific ops
Date:   Mon, 17 May 2021 12:40:35 -0300
Message-Id: <20210517154037.37946-3-ezequiel@collabora.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210517154037.37946-1-ezequiel@collabora.com>
References: <20210517154037.37946-1-ezequiel@collabora.com>
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
index 56034f21fcef..791c13d47a35 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
@@ -1342,11 +1342,36 @@ static struct rk_priv_data *rk_gmac_setup(struct platform_device *pdev,
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
@@ -1417,10 +1442,12 @@ static void rk_fix_speed(void *priv, unsigned int speed)
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


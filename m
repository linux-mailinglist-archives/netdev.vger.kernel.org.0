Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84189FF2D5
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732081AbfKPQVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 11:21:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:47500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728750AbfKPPna (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:43:30 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 977D32072D;
        Sat, 16 Nov 2019 15:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919009;
        bh=9bch6VTDVZgwC2rRZU7Zqnz8hEruZA8tajpvcVynNb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lugkCPPQuZi/h79ebvk+Iy2gYUhyR17jZqbOHyu0ooEC748c7E45A0uNUN6fRxCCr
         K6cxl5L6a0rl2or2sOzak87uE98iO5LXyx0AG7awloFID0KjmHo0Qenxe1WzVA4E+i
         q2CPHA5ww2I2XvKVMeKuoTV1Axl8rhSF6oABYkv8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahisa Kojima <masahisa.kojima@linaro.org>,
        Yoshitoyo Osaki <osaki.yoshitoyo@socionext.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 113/237] net: socionext: Stop PHY before resetting netsec
Date:   Sat, 16 Nov 2019 10:39:08 -0500
Message-Id: <20191116154113.7417-113-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Masahisa Kojima <masahisa.kojima@linaro.org>

[ Upstream commit 8e850f25b5812aefedec6732732eb10e7b47cb5c ]

In ndo_stop, driver resets the netsec ethernet controller IP.
When the netsec IP is reset, HW running mode turns to NRM mode
and driver has to wait until this mode transition completes.

But mode transition to NRM will not complete if the PHY is
in normal operation state. Netsec IP requires PHY is in
power down state when it is reset.

This modification stops the PHY before resetting netsec.

Together with this modification, phy_addr is stored in netsec_priv
structure because ndev->phydev is not yet ready in ndo_init.

Fixes: 533dd11a12f6 ("net: socionext: Add Synquacer NetSec driver")
Signed-off-by: Masahisa Kojima <masahisa.kojima@linaro.org>
Signed-off-by: Yoshitoyo Osaki <osaki.yoshitoyo@socionext.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/socionext/netsec.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index d2caeb9edc044..28d582c18afb9 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -274,6 +274,7 @@ struct netsec_priv {
 	struct clk *clk;
 	u32 msg_enable;
 	u32 freq;
+	u32 phy_addr;
 	bool rx_cksum_offload_flag;
 };
 
@@ -1346,11 +1347,11 @@ static int netsec_netdev_stop(struct net_device *ndev)
 	netsec_uninit_pkt_dring(priv, NETSEC_RING_TX);
 	netsec_uninit_pkt_dring(priv, NETSEC_RING_RX);
 
-	ret = netsec_reset_hardware(priv, false);
-
 	phy_stop(ndev->phydev);
 	phy_disconnect(ndev->phydev);
 
+	ret = netsec_reset_hardware(priv, false);
+
 	pm_runtime_put_sync(priv->dev);
 
 	return ret;
@@ -1360,6 +1361,7 @@ static int netsec_netdev_init(struct net_device *ndev)
 {
 	struct netsec_priv *priv = netdev_priv(ndev);
 	int ret;
+	u16 data;
 
 	ret = netsec_alloc_dring(priv, NETSEC_RING_TX);
 	if (ret)
@@ -1369,6 +1371,11 @@ static int netsec_netdev_init(struct net_device *ndev)
 	if (ret)
 		goto err1;
 
+	/* set phy power down */
+	data = netsec_phy_read(priv->mii_bus, priv->phy_addr, MII_BMCR) |
+		BMCR_PDOWN;
+	netsec_phy_write(priv->mii_bus, priv->phy_addr, MII_BMCR, data);
+
 	ret = netsec_reset_hardware(priv, true);
 	if (ret)
 		goto err2;
@@ -1418,7 +1425,7 @@ static const struct net_device_ops netsec_netdev_ops = {
 };
 
 static int netsec_of_probe(struct platform_device *pdev,
-			   struct netsec_priv *priv)
+			   struct netsec_priv *priv, u32 *phy_addr)
 {
 	priv->phy_np = of_parse_phandle(pdev->dev.of_node, "phy-handle", 0);
 	if (!priv->phy_np) {
@@ -1426,6 +1433,8 @@ static int netsec_of_probe(struct platform_device *pdev,
 		return -EINVAL;
 	}
 
+	*phy_addr = of_mdio_parse_addr(&pdev->dev, priv->phy_np);
+
 	priv->clk = devm_clk_get(&pdev->dev, NULL); /* get by 'phy_ref_clk' */
 	if (IS_ERR(priv->clk)) {
 		dev_err(&pdev->dev, "phy_ref_clk not found\n");
@@ -1626,12 +1635,14 @@ static int netsec_probe(struct platform_device *pdev)
 	}
 
 	if (dev_of_node(&pdev->dev))
-		ret = netsec_of_probe(pdev, priv);
+		ret = netsec_of_probe(pdev, priv, &phy_addr);
 	else
 		ret = netsec_acpi_probe(pdev, priv, &phy_addr);
 	if (ret)
 		goto free_ndev;
 
+	priv->phy_addr = phy_addr;
+
 	if (!priv->freq) {
 		dev_err(&pdev->dev, "missing PHY reference clock frequency\n");
 		ret = -ENODEV;
-- 
2.20.1


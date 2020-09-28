Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B80827ABA5
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 12:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgI1KOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 06:14:55 -0400
Received: from mx.socionext.com ([202.248.49.38]:34120 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726497AbgI1KOy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 06:14:54 -0400
X-Greylist: delayed 579 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Sep 2020 06:14:54 EDT
Received: from unknown (HELO kinkan-ex.css.socionext.com) ([172.31.9.52])
  by mx.socionext.com with ESMTP; 28 Sep 2020 19:05:14 +0900
Received: from mail.mfilter.local (m-filter-2 [10.213.24.62])
        by kinkan-ex.css.socionext.com (Postfix) with ESMTP id 1464918020F;
        Mon, 28 Sep 2020 19:05:15 +0900 (JST)
Received: from 172.31.9.51 (172.31.9.51) by m-FILTER with ESMTP; Mon, 28 Sep 2020 19:05:15 +0900
Received: from plum.e01.socionext.com (unknown [10.213.132.32])
        by kinkan.css.socionext.com (Postfix) with ESMTP id C9EED1A0507;
        Mon, 28 Sep 2020 19:05:14 +0900 (JST)
From:   Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Subject: [PATCH net] net: ethernet: ave: Replace alloc_etherdev() with devm_alloc_etherdev()
Date:   Mon, 28 Sep 2020 19:04:53 +0900
Message-Id: <1601287493-4077-1-git-send-email-hayashi.kunihiko@socionext.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use devm_alloc_etherdev() to simplify the code instead of alloc_etherdev().

Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
---
 drivers/net/ethernet/socionext/sni_ave.c | 32 +++++++++++---------------------
 1 file changed, 11 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/socionext/sni_ave.c b/drivers/net/ethernet/socionext/sni_ave.c
index eedccff..4f459b2 100644
--- a/drivers/net/ethernet/socionext/sni_ave.c
+++ b/drivers/net/ethernet/socionext/sni_ave.c
@@ -1629,7 +1629,7 @@ static int ave_probe(struct platform_device *pdev)
 	if (IS_ERR(base))
 		return PTR_ERR(base);
 
-	ndev = alloc_etherdev(sizeof(struct ave_private));
+	ndev = devm_alloc_etherdev(dev, sizeof(struct ave_private));
 	if (!ndev) {
 		dev_err(dev, "can't allocate ethernet device\n");
 		return -ENOMEM;
@@ -1679,7 +1679,7 @@ static int ave_probe(struct platform_device *pdev)
 	}
 	ret = dma_set_mask(dev, dma_mask);
 	if (ret)
-		goto out_free_netdev;
+		return ret;
 
 	priv->tx.ndesc = AVE_NR_TXDESC;
 	priv->rx.ndesc = AVE_NR_RXDESC;
@@ -1692,10 +1692,8 @@ static int ave_probe(struct platform_device *pdev)
 		if (!name)
 			break;
 		priv->clk[i] = devm_clk_get(dev, name);
-		if (IS_ERR(priv->clk[i])) {
-			ret = PTR_ERR(priv->clk[i]);
-			goto out_free_netdev;
-		}
+		if (IS_ERR(priv->clk[i]))
+			return PTR_ERR(priv->clk[i]);
 		priv->nclks++;
 	}
 
@@ -1704,10 +1702,8 @@ static int ave_probe(struct platform_device *pdev)
 		if (!name)
 			break;
 		priv->rst[i] = devm_reset_control_get_shared(dev, name);
-		if (IS_ERR(priv->rst[i])) {
-			ret = PTR_ERR(priv->rst[i]);
-			goto out_free_netdev;
-		}
+		if (IS_ERR(priv->rst[i]))
+			return PTR_ERR(priv->rst[i]);
 		priv->nrsts++;
 	}
 
@@ -1716,26 +1712,23 @@ static int ave_probe(struct platform_device *pdev)
 					       1, 0, &args);
 	if (ret) {
 		dev_err(dev, "can't get syscon-phy-mode property\n");
-		goto out_free_netdev;
+		return ret;
 	}
 	priv->regmap = syscon_node_to_regmap(args.np);
 	of_node_put(args.np);
 	if (IS_ERR(priv->regmap)) {
 		dev_err(dev, "can't map syscon-phy-mode\n");
-		ret = PTR_ERR(priv->regmap);
-		goto out_free_netdev;
+		return PTR_ERR(priv->regmap);
 	}
 	ret = priv->data->get_pinmode(priv, phy_mode, args.args[0]);
 	if (ret) {
 		dev_err(dev, "invalid phy-mode setting\n");
-		goto out_free_netdev;
+		return ret;
 	}
 
 	priv->mdio = devm_mdiobus_alloc(dev);
-	if (!priv->mdio) {
-		ret = -ENOMEM;
-		goto out_free_netdev;
-	}
+	if (!priv->mdio)
+		return -ENOMEM;
 	priv->mdio->priv = ndev;
 	priv->mdio->parent = dev;
 	priv->mdio->read = ave_mdiobus_read;
@@ -1772,8 +1765,6 @@ static int ave_probe(struct platform_device *pdev)
 out_del_napi:
 	netif_napi_del(&priv->napi_rx);
 	netif_napi_del(&priv->napi_tx);
-out_free_netdev:
-	free_netdev(ndev);
 
 	return ret;
 }
@@ -1786,7 +1777,6 @@ static int ave_remove(struct platform_device *pdev)
 	unregister_netdev(ndev);
 	netif_napi_del(&priv->napi_rx);
 	netif_napi_del(&priv->napi_tx);
-	free_netdev(ndev);
 
 	return 0;
 }
-- 
2.7.4


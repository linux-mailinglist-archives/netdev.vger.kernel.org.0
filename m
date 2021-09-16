Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F280640D3EC
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 09:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234885AbhIPHi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 03:38:59 -0400
Received: from mx22.baidu.com ([220.181.50.185]:44108 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234805AbhIPHi5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 03:38:57 -0400
Received: from BC-Mail-EX04.internal.baidu.com (unknown [172.31.51.44])
        by Forcepoint Email with ESMTPS id 4C345FC8EE4795362158;
        Thu, 16 Sep 2021 15:37:35 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-EX04.internal.baidu.com (172.31.51.44) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Thu, 16 Sep 2021 15:37:34 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Thu, 16 Sep 2021 15:37:34 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <caihuoqing@baidu.com>
CC:     Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: netsec: Make use of the helper function dev_err_probe()
Date:   Thu, 16 Sep 2021 15:37:29 +0800
Message-ID: <20210916073729.9163-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-Ex09.internal.baidu.com (172.31.51.49) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When possible use dev_err_probe help to properly deal with the
PROBE_DEFER error, the benefit is that DEFER issue will be logged
in the devices_deferred debugfs file.
And using dev_err_probe() can reduce code size, and the error value
gets printed.

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/net/ethernet/socionext/netsec.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 1f46af136aa8..f80a2aef9972 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -1860,10 +1860,9 @@ static int netsec_of_probe(struct platform_device *pdev,
 	*phy_addr = of_mdio_parse_addr(&pdev->dev, priv->phy_np);
 
 	priv->clk = devm_clk_get(&pdev->dev, NULL); /* get by 'phy_ref_clk' */
-	if (IS_ERR(priv->clk)) {
-		dev_err(&pdev->dev, "phy_ref_clk not found\n");
-		return PTR_ERR(priv->clk);
-	}
+	if (IS_ERR(priv->clk))
+		return dev_err_probe(&pdev->dev, PTR_ERR(priv->clk),
+				     "phy_ref_clk not found\n");
 	priv->freq = clk_get_rate(priv->clk);
 
 	return 0;
@@ -1886,19 +1885,17 @@ static int netsec_acpi_probe(struct platform_device *pdev,
 	priv->phy_interface = PHY_INTERFACE_MODE_NA;
 
 	ret = device_property_read_u32(&pdev->dev, "phy-channel", phy_addr);
-	if (ret) {
-		dev_err(&pdev->dev,
-			"missing required property 'phy-channel'\n");
-		return ret;
-	}
+	if (ret)
+		return dev_err_probe(&pdev->dev, ret,
+				     "missing required property 'phy-channel'\n");
 
 	ret = device_property_read_u32(&pdev->dev,
 				       "socionext,phy-clock-frequency",
 				       &priv->freq);
 	if (ret)
-		dev_err(&pdev->dev,
-			"missing required property 'socionext,phy-clock-frequency'\n");
-	return ret;
+		return dev_err_probe(&pdev->dev, ret,
+				     "missing required property 'socionext,phy-clock-frequency'\n");
+	return 0;
 }
 
 static void netsec_unregister_mdio(struct netsec_priv *priv)
-- 
2.25.1


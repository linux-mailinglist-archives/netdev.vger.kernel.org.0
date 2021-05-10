Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33DDB3780FC
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 12:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhEJKPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 06:15:39 -0400
Received: from fgw20-7.mail.saunalahti.fi ([62.142.5.81]:32509 "EHLO
        fgw20-7.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230145AbhEJKPe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 06:15:34 -0400
Received: from localhost (88-115-248-186.elisa-laajakaista.fi [88.115.248.186])
        by fgw20.mail.saunalahti.fi (Halon) with ESMTP
        id 3bc0de96-b176-11eb-ba24-005056bd6ce9;
        Mon, 10 May 2021 12:58:13 +0300 (EEST)
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH net-next v1 3/4] net: mvpp2: Use devm_clk_get_optional()
Date:   Mon, 10 May 2021 12:58:07 +0300
Message-Id: <20210510095808.3302997-3-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510095808.3302997-1-andy.shevchenko@gmail.com>
References: <20210510095808.3302997-1-andy.shevchenko@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Replace open coded variants of devm_clk_get_optional().

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 34 ++++++++-----------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 6bfad75c4087..b6b7ba891e71 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -7435,28 +7435,27 @@ static int mvpp2_probe(struct platform_device *pdev)
 			if (err < 0)
 				goto err_gop_clk;
 
-			priv->mg_core_clk = devm_clk_get(&pdev->dev, "mg_core_clk");
+			priv->mg_core_clk = devm_clk_get_optional(&pdev->dev, "mg_core_clk");
 			if (IS_ERR(priv->mg_core_clk)) {
-				priv->mg_core_clk = NULL;
-			} else {
-				err = clk_prepare_enable(priv->mg_core_clk);
-				if (err < 0)
-					goto err_mg_clk;
+				err = PTR_ERR(priv->mg_core_clk);
+				goto err_mg_clk;
 			}
+
+			err = clk_prepare_enable(priv->mg_core_clk);
+			if (err < 0)
+				goto err_mg_clk;
 		}
 
-		priv->axi_clk = devm_clk_get(&pdev->dev, "axi_clk");
+		priv->axi_clk = devm_clk_get_optional(&pdev->dev, "axi_clk");
 		if (IS_ERR(priv->axi_clk)) {
 			err = PTR_ERR(priv->axi_clk);
-			if (err == -EPROBE_DEFER)
-				goto err_mg_core_clk;
-			priv->axi_clk = NULL;
-		} else {
-			err = clk_prepare_enable(priv->axi_clk);
-			if (err < 0)
-				goto err_mg_core_clk;
+			goto err_mg_core_clk;
 		}
 
+		err = clk_prepare_enable(priv->axi_clk);
+		if (err < 0)
+			goto err_mg_core_clk;
+
 		/* Get system's tclk rate */
 		priv->tclk = clk_get_rate(priv->pp_clk);
 	} else if (device_property_read_u32(&pdev->dev, "clock-frequency",
@@ -7552,13 +7551,10 @@ static int mvpp2_probe(struct platform_device *pdev)
 	}
 err_axi_clk:
 	clk_disable_unprepare(priv->axi_clk);
-
 err_mg_core_clk:
-	if (priv->hw_version >= MVPP22)
-		clk_disable_unprepare(priv->mg_core_clk);
+	clk_disable_unprepare(priv->mg_core_clk);
 err_mg_clk:
-	if (priv->hw_version >= MVPP22)
-		clk_disable_unprepare(priv->mg_clk);
+	clk_disable_unprepare(priv->mg_clk);
 err_gop_clk:
 	clk_disable_unprepare(priv->gop_clk);
 err_pp_clk:
-- 
2.31.1


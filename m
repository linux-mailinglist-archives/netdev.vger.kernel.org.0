Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE7CE2DA174
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 21:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503233AbgLNUXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 15:23:20 -0500
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:48519 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503219AbgLNUXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 15:23:06 -0500
Received: from localhost.localdomain ([93.22.36.105])
        by mwinf5d56 with ME
        id 4LMJ240012G6YR103LMJPn; Mon, 14 Dec 2020 21:21:22 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 14 Dec 2020 21:21:22 +0100
X-ME-IP: 93.22.36.105
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     davem@davemloft.net, kuba@kernel.org, mripard@kernel.org,
        wens@csie.org, jernej.skrabec@siol.net, timur@kernel.org,
        song.bao.hua@hisilicon.com, f.fainelli@gmail.com, leon@kernel.org,
        hkallweit1@gmail.com, wangyunjian@huawei.com, sr@denx.de
Cc:     linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: allwinner: Fix some resources leak in the error handling path of the probe and in the remove function
Date:   Mon, 14 Dec 2020 21:21:17 +0100
Message-Id: <20201214202117.146293-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'irq_of_parse_and_map()' should be balanced by a corresponding
'irq_dispose_mapping()' call. Otherwise, there is some resources leaks.

Add such a call in the error handling path of the probe function and in the
remove function.

Fixes: 492205050d77 ("net: Add EMAC ethernet driver found on Allwinner A10 SoC's")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Please, carefully check the remove function, I'm not always confident by
the correct order when releasing resources. This is sometimes tricky.
---
 drivers/net/ethernet/allwinner/sun4i-emac.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.c b/drivers/net/ethernet/allwinner/sun4i-emac.c
index 862ea44beea7..5ed80d9a6b9f 100644
--- a/drivers/net/ethernet/allwinner/sun4i-emac.c
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
@@ -828,13 +828,13 @@ static int emac_probe(struct platform_device *pdev)
 	db->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(db->clk)) {
 		ret = PTR_ERR(db->clk);
-		goto out_iounmap;
+		goto out_dispose_mapping;
 	}
 
 	ret = clk_prepare_enable(db->clk);
 	if (ret) {
 		dev_err(&pdev->dev, "Error couldn't enable clock (%d)\n", ret);
-		goto out_iounmap;
+		goto out_dispose_mapping;
 	}
 
 	ret = sunxi_sram_claim(&pdev->dev);
@@ -893,6 +893,8 @@ static int emac_probe(struct platform_device *pdev)
 	sunxi_sram_release(&pdev->dev);
 out_clk_disable_unprepare:
 	clk_disable_unprepare(db->clk);
+out_dispose_mapping:
+	irq_dispose_mapping(ndev->irq);
 out_iounmap:
 	iounmap(db->membase);
 out:
@@ -911,6 +913,7 @@ static int emac_remove(struct platform_device *pdev)
 	unregister_netdev(ndev);
 	sunxi_sram_release(&pdev->dev);
 	clk_disable_unprepare(db->clk);
+	irq_dispose_mapping(ndev->irq);
 	iounmap(db->membase);
 	free_netdev(ndev);
 
-- 
2.27.0


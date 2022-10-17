Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD0256005D4
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 05:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232828AbiJQDws (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Oct 2022 23:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232833AbiJQDwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Oct 2022 23:52:47 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FBF05209A
        for <netdev@vger.kernel.org>; Sun, 16 Oct 2022 20:52:45 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MrNP26TWKzHw4b;
        Mon, 17 Oct 2022 11:52:38 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 17 Oct 2022 11:52:37 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 17 Oct
 2022 11:52:37 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-mediatek@lists.infradead.org>, <netdev@vger.kernel.org>
CC:     <nbd@nbd.name>, <davem@davemloft.net>
Subject: [PATCH net 1/3] net: ethernet: mtk_eth_soc: fix possible memory leak in mtk_probe()
Date:   Mon, 17 Oct 2022 11:51:54 +0800
Message-ID: <20221017035156.2497448-2-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221017035156.2497448-1-yangyingliang@huawei.com>
References: <20221017035156.2497448-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If mtk_wed_add_hw() has been called, mtk_wed_exit() needs be called
in error path or removing module to free the memory allocated in
mtk_wed_add_hw().

Fixes: 804775dfc288 ("net: ethernet: mtk_eth_soc: add support for Wireless Ethernet Dispatch (WED)")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 4fba7cb0144b..7cd381530aa4 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -4060,19 +4060,23 @@ static int mtk_probe(struct platform_device *pdev)
 			eth->irq[i] = platform_get_irq(pdev, i);
 		if (eth->irq[i] < 0) {
 			dev_err(&pdev->dev, "no IRQ%d resource found\n", i);
-			return -ENXIO;
+			err = -ENXIO;
+			goto err_wed_exit;
 		}
 	}
 	for (i = 0; i < ARRAY_SIZE(eth->clks); i++) {
 		eth->clks[i] = devm_clk_get(eth->dev,
 					    mtk_clks_source_name[i]);
 		if (IS_ERR(eth->clks[i])) {
-			if (PTR_ERR(eth->clks[i]) == -EPROBE_DEFER)
-				return -EPROBE_DEFER;
+			if (PTR_ERR(eth->clks[i]) == -EPROBE_DEFER) {
+				err = -EPROBE_DEFER;
+				goto err_wed_exit;
+			}
 			if (eth->soc->required_clks & BIT(i)) {
 				dev_err(&pdev->dev, "clock %s not found\n",
 					mtk_clks_source_name[i]);
-				return -EINVAL;
+				err = -EINVAL;
+				goto err_wed_exit;
 			}
 			eth->clks[i] = NULL;
 		}
@@ -4083,7 +4087,7 @@ static int mtk_probe(struct platform_device *pdev)
 
 	err = mtk_hw_init(eth);
 	if (err)
-		return err;
+		goto err_wed_exit;
 
 	eth->hwlro = MTK_HAS_CAPS(eth->soc->caps, MTK_HWLRO);
 
@@ -4179,6 +4183,8 @@ static int mtk_probe(struct platform_device *pdev)
 	mtk_free_dev(eth);
 err_deinit_hw:
 	mtk_hw_deinit(eth);
+err_wed_exit:
+	mtk_wed_exit();
 
 	return err;
 }
@@ -4198,6 +4204,7 @@ static int mtk_remove(struct platform_device *pdev)
 		phylink_disconnect_phy(mac->phylink);
 	}
 
+	mtk_wed_exit();
 	mtk_hw_deinit(eth);
 
 	netif_napi_del(&eth->tx_napi);
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8768A6005D6
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 05:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232837AbiJQDwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Oct 2022 23:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232834AbiJQDwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Oct 2022 23:52:47 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1CBD5209D
        for <netdev@vger.kernel.org>; Sun, 16 Oct 2022 20:52:45 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MrNP269VfzHvy4;
        Mon, 17 Oct 2022 11:52:38 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 17 Oct 2022 11:52:38 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 17 Oct
 2022 11:52:38 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-mediatek@lists.infradead.org>, <netdev@vger.kernel.org>
CC:     <nbd@nbd.name>, <davem@davemloft.net>
Subject: [PATCH net 3/3] net: ethernet: mtk_eth_wed: add missing of_node_put()
Date:   Mon, 17 Oct 2022 11:51:56 +0800
Message-ID: <20221017035156.2497448-4-yangyingliang@huawei.com>
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

The device_node pointer returned by of_parse_phandle() with refcount
incremented, when finish using it, the refcount need be decreased.

Fixes: 804775dfc288 ("net: ethernet: mtk_eth_soc: add support for Wireless Ethernet Dispatch (WED)")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/mediatek/mtk_wed.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index 09bbd05bd83c..65e01bf4b4d2 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -1072,7 +1072,7 @@ void mtk_wed_add_hw(struct device_node *np, struct mtk_eth *eth,
 
 	pdev = of_find_device_by_node(np);
 	if (!pdev)
-		return;
+		goto err_of_node_put;
 
 	get_device(&pdev->dev);
 	irq = platform_get_irq(pdev, 0);
@@ -1132,6 +1132,8 @@ void mtk_wed_add_hw(struct device_node *np, struct mtk_eth *eth,
 	mutex_unlock(&hw_lock);
 err_put_device:
 	put_device(&pdev->dev);
+err_of_node_put:
+	of_node_put(np);
 }
 
 void mtk_wed_exit(void)
@@ -1152,6 +1154,7 @@ void mtk_wed_exit(void)
 		hw_list[i] = NULL;
 		debugfs_remove(hw->debugfs_dir);
 		put_device(hw->dev);
+		of_node_put(hw->node);
 		kfree(hw);
 	}
 }
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC476005D8
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 05:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232846AbiJQDw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Oct 2022 23:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232838AbiJQDwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Oct 2022 23:52:51 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6463F520AC
        for <netdev@vger.kernel.org>; Sun, 16 Oct 2022 20:52:50 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MrNP24sXLzHvxv;
        Mon, 17 Oct 2022 11:52:38 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 17 Oct 2022 11:52:38 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 17 Oct
 2022 11:52:37 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-mediatek@lists.infradead.org>, <netdev@vger.kernel.org>
CC:     <nbd@nbd.name>, <davem@davemloft.net>
Subject: [PATCH net 2/3] net: ethernet: mtk_eth_wed: add missing put_device() in mtk_wed_add_hw()
Date:   Mon, 17 Oct 2022 11:51:55 +0800
Message-ID: <20221017035156.2497448-3-yangyingliang@huawei.com>
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

After calling get_device() in mtk_wed_add_hw(), in error path, put_device()
needs be called.

Fixes: 804775dfc288 ("net: ethernet: mtk_eth_soc: add support for Wireless Ethernet Dispatch (WED)")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/mediatek/mtk_wed.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index 099b6e0df619..09bbd05bd83c 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -1077,11 +1077,11 @@ void mtk_wed_add_hw(struct device_node *np, struct mtk_eth *eth,
 	get_device(&pdev->dev);
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
-		return;
+		goto err_put_device;
 
 	regs = syscon_regmap_lookup_by_phandle(np, NULL);
 	if (IS_ERR(regs))
-		return;
+		goto err_put_device;
 
 	rcu_assign_pointer(mtk_soc_wed_ops, &wed_ops);
 
@@ -1124,8 +1124,14 @@ void mtk_wed_add_hw(struct device_node *np, struct mtk_eth *eth,
 
 	hw_list[index] = hw;
 
+	mutex_unlock(&hw_lock);
+
+	return;
+
 unlock:
 	mutex_unlock(&hw_lock);
+err_put_device:
+	put_device(&pdev->dev);
 }
 
 void mtk_wed_exit(void)
-- 
2.25.1


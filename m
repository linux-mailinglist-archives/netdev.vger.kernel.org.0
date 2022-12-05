Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B37EC642151
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 03:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbiLECBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 21:01:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbiLECBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 21:01:13 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2E5A13D44
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 18:01:11 -0800 (PST)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NQRW23QRLzqStR;
        Mon,  5 Dec 2022 09:57:02 +0800 (CST)
Received: from huawei.com (10.175.112.208) by dggpeml500024.china.huawei.com
 (7.185.36.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 5 Dec
 2022 10:01:09 +0800
From:   Yuan Can <yuancan@huawei.com>
To:     <nbd@nbd.name>, <john@phrozen.org>, <sean.wang@mediatek.com>,
        <Mark-MC.Lee@mediatek.com>, <lorenzo@kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <matthias.bgg@gmail.com>,
        <sujuan.chen@mediatek.com>, <leon@kernel.org>,
        <netdev@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>
CC:     <yuancan@huawei.com>
Subject: [PATCH] net: ethernet: mtk_wed: Fix missing of_node_put() in mtk_wed_wo_hardware_init()
Date:   Mon, 5 Dec 2022 01:58:47 +0000
Message-ID: <20221205015847.27356-1-yuancan@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.208]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The np needs to be released through of_node_put() in the error handling
path of mtk_wed_wo_hardware_init().

Fixes: 799684448e3e ("net: ethernet: mtk_wed: introduce wed wo support")
Signed-off-by: Yuan Can <yuancan@huawei.com>
---
 drivers/net/ethernet/mediatek/mtk_wed_wo.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed_wo.c b/drivers/net/ethernet/mediatek/mtk_wed_wo.c
index 4754b6db009e..fcc4b3206d2d 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_wo.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed_wo.c
@@ -407,8 +407,10 @@ mtk_wed_wo_hardware_init(struct mtk_wed_wo *wo)
 		return -ENODEV;
 
 	wo->mmio.regs = syscon_regmap_lookup_by_phandle(np, NULL);
-	if (IS_ERR_OR_NULL(wo->mmio.regs))
-		return PTR_ERR(wo->mmio.regs);
+	if (IS_ERR(wo->mmio.regs)) {
+		ret = PTR_ERR(wo->mmio.regs);
+		goto error_put;
+	}
 
 	wo->mmio.irq = irq_of_parse_and_map(np, 0);
 	wo->mmio.irq_mask = MTK_WED_WO_ALL_INT_MASK;
@@ -456,7 +458,8 @@ mtk_wed_wo_hardware_init(struct mtk_wed_wo *wo)
 
 error:
 	devm_free_irq(wo->hw->dev, wo->mmio.irq, wo);
-
+error_put:
+	of_node_put(np);
 	return ret;
 }
 
-- 
2.17.1


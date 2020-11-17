Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06ECD2B579C
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 04:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgKQDAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 22:00:35 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8100 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbgKQDAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 22:00:34 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CZrK90R5WzLpf8;
        Tue, 17 Nov 2020 11:00:13 +0800 (CST)
Received: from compute.localdomain (10.175.112.70) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Tue, 17 Nov 2020 11:00:29 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <michael.chan@broadcom.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <Larry.Finger@lwfinger.net>,
        <akpm@linux-foundation.org>, <fujita.tomonori@lab.ntt.co.jp>,
        <linville@tuxdriver.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net] net: b44: fix error return code in b44_init_one()
Date:   Tue, 17 Nov 2020 11:02:11 +0800
Message-ID: <1605582131-36735-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 39a6f4bce6b4 ("b44: replace the ssb_dma API with the generic DMA API")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/ethernet/broadcom/b44.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/broadcom/b44.c
index 74c1778..b455b60 100644
--- a/drivers/net/ethernet/broadcom/b44.c
+++ b/drivers/net/ethernet/broadcom/b44.c
@@ -2383,7 +2383,8 @@ static int b44_init_one(struct ssb_device *sdev,
 		goto err_out_free_dev;
 	}
 
-	if (dma_set_mask_and_coherent(sdev->dma_dev, DMA_BIT_MASK(30))) {
+	err = dma_set_mask_and_coherent(sdev->dma_dev, DMA_BIT_MASK(30));
+	if (err) {
 		dev_err(sdev->dev,
 			"Required 30BIT DMA mask unsupported by the system\n");
 		goto err_out_powerdown;
-- 
2.9.5


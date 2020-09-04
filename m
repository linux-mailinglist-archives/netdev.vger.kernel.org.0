Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB47C25CF77
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 04:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729626AbgIDCuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 22:50:12 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:46740 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728697AbgIDCuL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 22:50:11 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 9A66135D80B6BACB1C51;
        Fri,  4 Sep 2020 10:50:05 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Fri, 4 Sep 2020 10:49:56 +0800
From:   Jing Xiangfeng <jingxiangfeng@huawei.com>
To:     <3chas3@gmail.com>, <davem@davemloft.net>
CC:     <linux-atm-general@lists.sourceforge.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jingxiangfeng@huawei.com>
Subject: [PATCH] atm: eni: fix the missed pci_disable_device() for eni_init_one()
Date:   Fri, 4 Sep 2020 10:51:03 +0800
Message-ID: <20200904025103.39405-1-jingxiangfeng@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

eni_init_one() misses to call pci_disable_device() in an error path.
Jump to err_disable to fix it.

Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
---
 drivers/atm/eni.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/atm/eni.c b/drivers/atm/eni.c
index 39be444534d0..316a9947541f 100644
--- a/drivers/atm/eni.c
+++ b/drivers/atm/eni.c
@@ -2224,7 +2224,7 @@ static int eni_init_one(struct pci_dev *pci_dev,
 
 	rc = dma_set_mask_and_coherent(&pci_dev->dev, DMA_BIT_MASK(32));
 	if (rc < 0)
-		goto out;
+		goto err_disable;
 
 	rc = -ENOMEM;
 	eni_dev = kmalloc(sizeof(struct eni_dev), GFP_KERNEL);
-- 
2.17.1


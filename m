Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3F747EB80
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 06:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236414AbhLXFNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 00:13:21 -0500
Received: from smtp21.cstnet.cn ([159.226.251.21]:53086 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229946AbhLXFNV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Dec 2021 00:13:21 -0500
Received: from localhost.localdomain (unknown [124.16.138.126])
        by APP-01 (Coremail) with SMTP id qwCowACnrZ3XVsVh5R4BBQ--.5214S2;
        Fri, 24 Dec 2021 13:12:55 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     davem@davemloft.net, kuba@kernel.org, colin.king@intel.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH] drivers: net: smc911x: Fix wrong check for irq
Date:   Fri, 24 Dec 2021 13:12:54 +0800
Message-Id: <20211224051254.1565040-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: qwCowACnrZ3XVsVh5R4BBQ--.5214S2
X-Coremail-Antispam: 1UD129KBjvdXoWrKr4rKrWxAF17Zw1kZF1rCrg_yoWDGFg_Kr
        4FvFsxJF4kXrs09w18Jr1SyrySvFn8XF4ruF1qqFWYq34DAryUXr4Dur1fAw4Uu34DCFyD
        G343WFW3C343KjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbcxFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
        Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
        jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr
        1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkIecxEwVAFwVW8WwCF
        04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r
        18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vI
        r41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr
        1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAI
        cVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUjFks3UUUUU==
X-Originating-IP: [124.16.138.126]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Because ndev->irq is unsigned, the check is useless.
Therefore, we need to correct the check by using error variable.

Fixes: cb93b3e11d40 ("drivers: net: smc911x: Check for error irq")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
 drivers/net/ethernet/smsc/smc911x.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smc911x.c b/drivers/net/ethernet/smsc/smc911x.c
index dd6f69ced4ee..3118c8b7a8c3 100644
--- a/drivers/net/ethernet/smsc/smc911x.c
+++ b/drivers/net/ethernet/smsc/smc911x.c
@@ -2071,11 +2071,11 @@ static int smc911x_drv_probe(struct platform_device *pdev)
 	SET_NETDEV_DEV(ndev, &pdev->dev);
 
 	ndev->dma = (unsigned char)-1;
-	ndev->irq = platform_get_irq(pdev, 0);
-	if (ndev->irq < 0) {
-		ret = ndev->irq;
+
+	ret = platform_get_irq(pdev, 0);
+	if (ret < 0)
 		goto release_both;
-	}
+	ndev->irq = ret;
 
 	lp = netdev_priv(ndev);
 	lp->netdev = ndev;
-- 
2.25.1


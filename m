Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A48466F14
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 02:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350068AbhLCBaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 20:30:09 -0500
Received: from smtp25.cstnet.cn ([159.226.251.25]:46886 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1356785AbhLCBaI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 20:30:08 -0500
Received: from localhost.localdomain (unknown [124.16.138.128])
        by APP-05 (Coremail) with SMTP id zQCowACXeRY6cqlhWmQDAQ--.63145S2;
        Fri, 03 Dec 2021 09:26:18 +0800 (CST)
From:   Jiasheng Jiang <jiasheng@iscas.ac.cn>
To:     rafal@milecki.pl, bcm-kernel-feedback-list@broadcom.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
Subject: [PATCH] net: broadcom: Catch the Exception
Date:   Fri,  3 Dec 2021 09:26:15 +0800
Message-Id: <20211203012615.1512601-1-jiasheng@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: zQCowACXeRY6cqlhWmQDAQ--.63145S2
X-Coremail-Antispam: 1UD129KBjvdXoWrur43Jw1rJr15CF4fJryxXwb_yoWDWrg_KF
        y7Z3s2g395CryY9w4Skw43Zry0k3yqvr1ruFy09rZaqryDuryUtayvyFyFyw1UWrW8JFyf
        GrnIyFZxA340gjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbckFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
        Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxVW8Jr
        0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
        6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
        0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkIecxEwVAFwVWk
        MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr
        0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0E
        wIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJV
        W8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI
        42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUHpB-UUUUU=
X-Originating-IP: [124.16.138.128]
X-CM-SenderInfo: pmld2xxhqjqxpvfd2hldfou0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The return value of dma_set_coherent_mask() is not always 0.
To catch the exception in case that dma is not support the mask.

Fixes: 9d61d138ab30 ("net: broadcom: rename BCM4908 driver & update DT
binding")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
---
 drivers/net/ethernet/broadcom/bcm4908_enet.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bcm4908_enet.c b/drivers/net/ethernet/broadcom/bcm4908_enet.c
index 02a569500234..376f81796a29 100644
--- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
@@ -708,7 +708,9 @@ static int bcm4908_enet_probe(struct platform_device *pdev)
 
 	enet->irq_tx = platform_get_irq_byname(pdev, "tx");
 
-	dma_set_coherent_mask(dev, DMA_BIT_MASK(32));
+	err = dma_set_coherent_mask(dev, DMA_BIT_MASK(32));
+	if (err)
+		return err;
 
 	err = bcm4908_enet_dma_alloc(enet);
 	if (err)
-- 
2.25.1


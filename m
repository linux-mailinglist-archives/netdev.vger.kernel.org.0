Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E82B21E5B5
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 04:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgGNCdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 22:33:45 -0400
Received: from smtp23.cstnet.cn ([159.226.251.23]:42736 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726150AbgGNCdp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 22:33:45 -0400
Received: from localhost (unknown [159.226.5.99])
        by APP-03 (Coremail) with SMTP id rQCowAC3vwMJFw1fLmaPAA--.28728S2;
        Tue, 14 Jul 2020 10:23:06 +0800 (CST)
From:   Xu Wang <vulab@iscas.ac.cn>
To:     davem@davemloft.net, kuba@kernel.org, michal.simek@xilinx.com,
        esben@geanix.com, hkallweit1@gmail.com, f.fainelli@gmail.com,
        vulab@iscas.ac.cn, weiyongjun1@huawei.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH] net: xilinx: fix potential NULL dereference in temac_probe()
Date:   Tue, 14 Jul 2020 02:23:04 +0000
Message-Id: <20200714022304.4003-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: rQCowAC3vwMJFw1fLmaPAA--.28728S2
X-Coremail-Antispam: 1UD129KBjvdXoW7GFy7Jr4kAr48AFW7Wr47XFb_yoWkZFgEq3
        Wj9r4fGrs5ur1FkF48Kr13AayY9Fs29r97Ww47KFWavaykWw1293yUuw4fXFy7Ww1xCFyD
        JrnrJr4fua4UZjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUba8FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
        6F4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26F
        4UJVW0owAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
        7VC0I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7
        v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF
        7I0E8cxan2IY04v7MxkIecxEwVAFwVW8JwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
        kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
        67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
        CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E
        3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcS
        sGvfC2KfnxnUUI43ZEXa7VUbZ2-5UUUUU==
X-Originating-IP: [159.226.5.99]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCAsQA18J9fBAqAABsq
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

platform_get_resource() may return NULL, add proper
check to avoid potential NULL dereferencing.

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 929244064abd..85a767fa2ecf 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1408,6 +1408,8 @@ static int temac_probe(struct platform_device *pdev)
 
 	/* map device registers */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -EINVAL;
 	lp->regs = devm_ioremap(&pdev->dev, res->start,
 					resource_size(res));
 	if (!lp->regs) {
@@ -1503,6 +1505,8 @@ static int temac_probe(struct platform_device *pdev)
 	} else if (pdata) {
 		/* 2nd memory resource specifies DMA registers */
 		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+		if (!res)
+			return -EINVAL;
 		lp->sdma_regs = devm_ioremap(&pdev->dev, res->start,
 						     resource_size(res));
 		if (!lp->sdma_regs) {
-- 
2.17.1


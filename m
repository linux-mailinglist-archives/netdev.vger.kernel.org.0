Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB069431F5F
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 16:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbhJROXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 10:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbhJROW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 10:22:59 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECDF6C061745;
        Mon, 18 Oct 2021 07:20:48 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id 75so16412804pga.3;
        Mon, 18 Oct 2021 07:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=tqPEuv+z7q3xf5nLhQ/VFkVuHp0TxBQmCl34U+Nug4k=;
        b=jy/GTsZmKvAPJO0DfXr7o5QjSuOoPLw7MMJUXAbUfoW/fcZtokoSQyRady8LYkIUj2
         eRPfkZgSy93cPS/XYLFif9DotjuylHx0eiTvb384vLRHkNBI+pH+95fv+B2wLwAsRyz3
         4eFCHocoeuTUKbu3IXo61BlD+/EB2u2tGPP7Z3yhUKOW3l9ciRcdLfSm4aKEsmDzTwtt
         ocA5fjoMAJgwvV7UFClN/sdIkUb8ILm/eA5NzB9Di0jpETbYigWYQdnatHuJiWjfs2Ay
         EC0q9IaUigYXQ4IZxcwdxX3gZGRev/ZcOl3cvCKSi57yGMbeRD2gCb6RSMEKsxH7EG7e
         H7cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=tqPEuv+z7q3xf5nLhQ/VFkVuHp0TxBQmCl34U+Nug4k=;
        b=7gl7mAKZ3IqJJnYdS3lBO0xSDCYN8pBpqV9+NkqfPlgefS8xbXp7h7UhMUPECqnr/+
         bAZPodtmmQAzd6Q6ZJ5cukVknYy/KQBrLK24uRSWys8TeM9kQ3Cl1sVl2ddWnjYQ5VzU
         7gB88c59GKKTNqxfXnyxXStHqiq/75if2TZhHbGC+LwprBfQietiqZXH4ph/L+GlYCuy
         pU//GUGmf+B8ZHuK3BtaxmmzoSmfOMeF3SXSzIgQNKsfH+nARPx+912pog/VArVHdstL
         NBNkgBfNMAp/3iztqAoOAecBAcAA3jRuzWZDYO6fmeN2s5VyJCtOQfZVJPqIeRlZhG0J
         b8zQ==
X-Gm-Message-State: AOAM532iQTz1v3oYG6Z51ZR4GbZ6qSKG6AlJROjpq/QBBdbLtrr7vL9D
        hhPAQLomAtzo7pgJPdu5Bw==
X-Google-Smtp-Source: ABdhPJy4lCCdmxEN/jW/r6FqXCSkYi64akE7ickWP77dWcUUj5pRMKXiUr5bs8fXaKz2c0RPF9djRQ==
X-Received: by 2002:aa7:86d9:0:b0:44d:a354:b803 with SMTP id h25-20020aa786d9000000b0044da354b803mr17907701pfo.21.1634566848463;
        Mon, 18 Oct 2021 07:20:48 -0700 (PDT)
Received: from vultr.guest ([107.191.53.97])
        by smtp.gmail.com with ESMTPSA id q35sm19727366pjk.41.2021.10.18.07.20.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Oct 2021 07:20:48 -0700 (PDT)
From:   Zheyu Ma <zheyuma97@gmail.com>
To:     isdn@linux-pingi.de, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zheyu Ma <zheyuma97@gmail.com>
Subject: [PATCH] mISDN: Fix return values of the probe function
Date:   Mon, 18 Oct 2021 14:20:38 +0000
Message-Id: <1634566838-3804-1-git-send-email-zheyuma97@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During the process of driver probing, the probe function should return < 0
for failure, otherwise, the kernel will treat value > 0 as success.

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
---
 drivers/isdn/hardware/mISDN/hfcpci.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
index e501cb03f211..bd087cca1c1d 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -1994,14 +1994,14 @@ setup_hw(struct hfc_pci *hc)
 	pci_set_master(hc->pdev);
 	if (!hc->irq) {
 		printk(KERN_WARNING "HFC-PCI: No IRQ for PCI card found\n");
-		return 1;
+		return -EINVAL;
 	}
 	hc->hw.pci_io =
 		(char __iomem *)(unsigned long)hc->pdev->resource[1].start;
 
 	if (!hc->hw.pci_io) {
 		printk(KERN_WARNING "HFC-PCI: No IO-Mem for PCI card found\n");
-		return 1;
+		return -ENOMEM;
 	}
 	/* Allocate memory for FIFOS */
 	/* the memory needs to be on a 32k boundary within the first 4G */
@@ -2012,7 +2012,7 @@ setup_hw(struct hfc_pci *hc)
 	if (!buffer) {
 		printk(KERN_WARNING
 		       "HFC-PCI: Error allocating memory for FIFO!\n");
-		return 1;
+		return -ENOMEM;
 	}
 	hc->hw.fifos = buffer;
 	pci_write_config_dword(hc->pdev, 0x80, hc->hw.dmahandle);
@@ -2022,7 +2022,7 @@ setup_hw(struct hfc_pci *hc)
 		       "HFC-PCI: Error in ioremap for PCI!\n");
 		dma_free_coherent(&hc->pdev->dev, 0x8000, hc->hw.fifos,
 				  hc->hw.dmahandle);
-		return 1;
+		return -ENOMEM;
 	}
 
 	printk(KERN_INFO
-- 
2.17.6


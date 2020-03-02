Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20E4E17545E
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 08:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgCBHUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 02:20:22 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:56213 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbgCBHUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 02:20:21 -0500
Received: by mail-pj1-f68.google.com with SMTP id a18so4044077pjs.5
        for <netdev@vger.kernel.org>; Sun, 01 Mar 2020 23:20:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=51gksHnSMHUTNXg1pvXY6xOdNms3IBzKbjyRJgUF5pQ=;
        b=poO5lco6AmmU7p+kd2GIUyGkQTJ8+CK0L/97DCYjOb8jsnA34DcUeeqjxl5nNazTUX
         JhaBOxBy2Y05ITp8/NxDY/3LMkrFB8yXFH7hVzsmIwZK1G17l5A63Oq5Q8AUB0DHrvwK
         P67WRY1tUbhOWlsXRPzaLBIAcRYHFaDmjYnmzEh18tl/vPVd0/g+IvTgoi841A2kgzVq
         cMvi32SPge3R1yrjdEZwD8JgujkTjPh/KJU79mU6IFvQi7PQaIdGSv682X1BvlHabwdu
         /J7LxdeR8839dEQWtqf2ifLZ6zzwv9mSnxTxWhCg19iDbHnSGwfxLnfWH7Kl37Gh/w8N
         mN3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=51gksHnSMHUTNXg1pvXY6xOdNms3IBzKbjyRJgUF5pQ=;
        b=Pbz1Z8yAtR+eYRCO/KBZZa4ZIVR1YURFMEXr+E/xUMBwwP9RykdFJAHczc3kaY7ruw
         3Ch2Px5eRQadnGS5zHcAjtOKAoxQ2XCGiXl/1H9Ex/SxhP3DlAKEFzuqEk/TObPii2Fo
         HR3rTs0L2YHOVc1w8V7mDo5zN0wNKn77Og7Ht3gYpedWml1yL/4ADKAt6MzSNY2O4Hm5
         AsEeuGalUVTIDC9YoyNPdM1z43qR9agz1LOynJpyq/+cPEE4nu7FOCtyLvrsx1uHDxja
         QL89voIStZQO3xGWqrFtb/DrMAHW2yHzbMawvSVf0ddhWiw0Bzu9XeUwHsK4oGYDJ1Nb
         UUew==
X-Gm-Message-State: APjAAAVDHIE6ZzhA+pAiLcU5CkyXe0X8hFvr7WMrKMmNFZdJOLmLUP5k
        BcRNn6Jij38XtM6ZA86kWdsBzOKSpn0=
X-Google-Smtp-Source: APXvYqxgIO3Vs4TR7tiA4MiTHVIy0RHXI5BAQG/BS0RETVE+zxByRW+MpZB17zyuhV3q3PsxLqV7VQ==
X-Received: by 2002:a17:902:6b48:: with SMTP id g8mr16463762plt.149.1583133620849;
        Sun, 01 Mar 2020 23:20:20 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id j4sm19835042pfh.152.2020.03.01.23.20.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 01 Mar 2020 23:20:20 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH 6/7] octeontx2-af: Enable PCI master
Date:   Mon,  2 Mar 2020 12:49:27 +0530
Message-Id: <1583133568-5674-7-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1583133568-5674-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1583133568-5674-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

Bus mastering is enabled by firmware, but when this driver
is unbinded bus mastering gets disabled by the PCI subsystem
which results interrupts not working when driver is reloaded.
Hence set bus mastering everytime in probe().

Also
- Converted pci_set_dma_mask() and pci_set_consistent_dma_mask()
  to dma_set_mask_and_coherent().
- Cleared transaction pending bit which gets set during
  driver unbind due to clearing of bus mastering (ME bit).

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index e851477..3b794df 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -2243,6 +2243,9 @@ static int rvu_register_interrupts(struct rvu *rvu)
 	}
 	rvu->irq_allocated[RVU_AF_INT_VEC_PFME] = true;
 
+	/* Clear TRPEND bit for all PF */
+	rvu_write64(rvu, BLKADDR_RVUM,
+		    RVU_AF_PFTRPEND, INTR_MASK(rvu->hw->total_pfs));
 	/* Enable ME interrupt for all PFs*/
 	rvu_write64(rvu, BLKADDR_RVUM,
 		    RVU_AF_PFME_INT, INTR_MASK(rvu->hw->total_pfs));
@@ -2554,17 +2557,13 @@ static int rvu_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_disable_device;
 	}
 
-	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(48));
+	err = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(48));
 	if (err) {
-		dev_err(dev, "Unable to set DMA mask\n");
+		dev_err(dev, "DMA mask config failed, abort\n");
 		goto err_release_regions;
 	}
 
-	err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(48));
-	if (err) {
-		dev_err(dev, "Unable to set consistent DMA mask\n");
-		goto err_release_regions;
-	}
+	pci_set_master(pdev);
 
 	/* Map Admin function CSRs */
 	rvu->afreg_base = pcim_iomap(pdev, PCI_AF_REG_BAR_NUM, 0);
-- 
2.7.4


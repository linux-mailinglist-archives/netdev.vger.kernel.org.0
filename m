Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81BF1368C8B
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 07:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240981AbhDWFW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 01:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240634AbhDWFWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 01:22:07 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C24C061756;
        Thu, 22 Apr 2021 22:21:27 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id v13so11081985ple.9;
        Thu, 22 Apr 2021 22:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WjE5MA7+4ZwCbbfRd+W09i2u6oXOwprynyvP1BlKeH0=;
        b=rvrdXEYt3aYj+BQSLJgMTnmz3tc0r1wUQy6VEvCfqjFf7givy59PpsJmNcNr0zDT69
         Zv+4YNmRpL0ykgP/b256UnnKlEAQDaTIfyDFYJRIHn6wj/wooGmQyh7hXrA21H9lRECh
         fIwPLNvfyBEUcZvLofKnUNGNVwrr4TkigBMx9kB2Z65/uE1cph+JPJR8lXB0CG8ZS1Vu
         X0dJwoux8RrqrLUqQPTTXUOCV+BQ/MAssjz3u/XTAp9sRTXqDHbMNOmOGid1a5ehh8PJ
         afEC1GSVr9sN94utHBWywVaTOLwFi8hhnzB/nwUj4vj1NjC0X6s3RIVaJWd86or/6/du
         KnUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WjE5MA7+4ZwCbbfRd+W09i2u6oXOwprynyvP1BlKeH0=;
        b=hhXR6twsKIVFLNGB0S+tdAIZSVQY0oYA3SdIXbx2XLRni63K99ohVyz9AQskasd6fm
         uZdRat2HKgWIwAb6S9RIXe4XmSmcQ4EVGUXC20mwJgItyips2sBNqpsZkZZVHpLdT4a+
         sxhKGoc7jUIT8sSzVB/9v8nVU4qA+CJGNmF7cTgFd4CfFoXRABn1YrdBz2+SDd2gRQ4Y
         tsaln6mqo1SX0/vnYCLuJmYlErBm/6vnUpAn6d6rSkSyUNQHJNim/z6r14wq/0Wu/WqB
         57Rsa3oovGTMB7MN0zHg3ffdV2nbrOfRefo99GPhCmVfxKusg1uIKR18L5JYkvMJBSl/
         jdtw==
X-Gm-Message-State: AOAM532KYk0NfQlAG1pbPRiRJhiR5mwv1QDj6/5mxFKRAMV1jahdiIWf
        szlvU6Jlu1zmt3JGfT9xnE8=
X-Google-Smtp-Source: ABdhPJyCaNlZckAPemEXQ82FX6NwJGUY7Fgm5nHIx1qKilOw/gQY1vokrG4/l7E6695NagFitzHsTw==
X-Received: by 2002:a17:90b:2482:: with SMTP id nt2mr3805572pjb.13.1619155287083;
        Thu, 22 Apr 2021 22:21:27 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id y24sm6238825pjp.26.2021.04.22.22.21.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 22:21:26 -0700 (PDT)
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Subject: [PATCH net-next v2 10/15] net: ethernet: mtk_eth_soc: cache HW pointer of last freed TX descriptor
Date:   Thu, 22 Apr 2021 22:21:03 -0700
Message-Id: <20210423052108.423853-11-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210423052108.423853-1-ilya.lipnitskiy@gmail.com>
References: <20210423052108.423853-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

The value is only updated by the CPU, so it is cheaper to access from the
ring data structure than from a hardware register.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 8 ++++----
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 2 ++
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 762e985fa294..6d23118b7a6c 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1364,7 +1364,7 @@ static int mtk_poll_tx_qdma(struct mtk_eth *eth, int budget,
 	struct mtk_tx_buf *tx_buf;
 	u32 cpu, dma;
 
-	cpu = mtk_r32(eth, MTK_QTX_CRX_PTR);
+	cpu = ring->last_free_ptr;
 	dma = mtk_r32(eth, MTK_QTX_DRX_PTR);
 
 	desc = mtk_qdma_phys_to_virt(ring, cpu);
@@ -1398,6 +1398,7 @@ static int mtk_poll_tx_qdma(struct mtk_eth *eth, int budget,
 		cpu = next_cpu;
 	}
 
+	ring->last_free_ptr = cpu;
 	mtk_w32(eth, cpu, MTK_QTX_CRX_PTR);
 
 	return budget;
@@ -1598,6 +1599,7 @@ static int mtk_tx_alloc(struct mtk_eth *eth)
 	atomic_set(&ring->free_count, MTK_DMA_SIZE - 2);
 	ring->next_free = &ring->dma[0];
 	ring->last_free = &ring->dma[MTK_DMA_SIZE - 1];
+	ring->last_free_ptr = (u32)(ring->phys + ((MTK_DMA_SIZE - 1) * sz));
 	ring->thresh = MAX_SKB_FRAGS;
 
 	/* make sure that all changes to the dma ring are flushed before we
@@ -1611,9 +1613,7 @@ static int mtk_tx_alloc(struct mtk_eth *eth)
 		mtk_w32(eth,
 			ring->phys + ((MTK_DMA_SIZE - 1) * sz),
 			MTK_QTX_CRX_PTR);
-		mtk_w32(eth,
-			ring->phys + ((MTK_DMA_SIZE - 1) * sz),
-			MTK_QTX_DRX_PTR);
+		mtk_w32(eth, ring->last_free_ptr, MTK_QTX_DRX_PTR);
 		mtk_w32(eth, (QDMA_RES_THRES << 8) | QDMA_RES_THRES,
 			MTK_QTX_CFG(0));
 	} else {
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index ceb5a4a661e6..6b92dd6c2cda 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -642,6 +642,7 @@ struct mtk_tx_buf {
  * @phys:		The physical addr of tx_buf
  * @next_free:		Pointer to the next free descriptor
  * @last_free:		Pointer to the last free descriptor
+ * @last_free_ptr:	Hardware pointer value of the last free descriptor
  * @thresh:		The threshold of minimum amount of free descriptors
  * @free_count:		QDMA uses a linked list. Track how many free descriptors
  *			are present
@@ -652,6 +653,7 @@ struct mtk_tx_ring {
 	dma_addr_t phys;
 	struct mtk_tx_dma *next_free;
 	struct mtk_tx_dma *last_free;
+	u32 last_free_ptr;
 	u16 thresh;
 	atomic_t free_count;
 	int dma_size;
-- 
2.31.1


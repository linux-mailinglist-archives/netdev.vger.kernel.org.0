Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69D323C73CB
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 18:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbhGMQKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 12:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbhGMQKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 12:10:42 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2DD0C0613E9;
        Tue, 13 Jul 2021 09:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=AdrJCYtnw/cIlb0o00U3MkZlWlJ5tSgHOHXdIcxONhs=; b=j/b1T3CdFPMK2xsbs5/1md+78s
        e/e5X2jWg0dXxZI5CgvlaEj8qElOQy7tFWP60zGncg4wtpQtmyO5cmvnaaZvC3Ar8h8fDXhuOzmjD
        hxBhHS8ahSD8NxBuDivB2LbTidLqP0RAJd8fc+qY1sbpOitEVTfnccBdCpFZik76PJhY=;
Received: from p54ae93f7.dip0.t-ipconnect.de ([84.174.147.247] helo=localhost.localdomain)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1m3Kwn-0008TX-5I; Tue, 13 Jul 2021 18:07:49 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, pablo@netfilter.org, ryder.lee@mediatek.com
Subject: [RFC 4/7] mt76: dma: add wrapper macro for accessing queue registers
Date:   Tue, 13 Jul 2021 18:07:42 +0200
Message-Id: <20210713160745.59707-5-nbd@nbd.name>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210713160745.59707-1-nbd@nbd.name>
References: <20210713160745.59707-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Preparation for adding indirection used for Wireless Ethernet Dispatch support

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 5e1c1506a4c6..ccdc020f72e5 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -7,6 +7,10 @@
 #include "mt76.h"
 #include "dma.h"
 
+#define Q_READ(_dev, _q, _field)		readl(&(_q)->regs->_field)
+#define Q_WRITE(_dev, _q, _field, _val)		writel(_val, &(_q)->regs->_field)
+
+
 static struct mt76_txwi_cache *
 mt76_alloc_txwi(struct mt76_dev *dev)
 {
@@ -82,9 +86,9 @@ mt76_free_pending_txwi(struct mt76_dev *dev)
 static void
 mt76_dma_sync_idx(struct mt76_dev *dev, struct mt76_queue *q)
 {
-	writel(q->desc_dma, &q->regs->desc_base);
-	writel(q->ndesc, &q->regs->ring_size);
-	q->head = readl(&q->regs->dma_idx);
+	Q_WRITE(dev, q, desc_base, q->desc_dma);
+	Q_WRITE(dev, q, ring_size, q->ndesc);
+	q->head = Q_READ(dev, q, dma_idx);
 	q->tail = q->head;
 }
 
@@ -100,8 +104,8 @@ mt76_dma_queue_reset(struct mt76_dev *dev, struct mt76_queue *q)
 	for (i = 0; i < q->ndesc; i++)
 		q->desc[i].ctrl = cpu_to_le32(MT_DMA_CTL_DMA_DONE);
 
-	writel(0, &q->regs->cpu_idx);
-	writel(0, &q->regs->dma_idx);
+	Q_WRITE(dev, q, cpu_idx, 0);
+	Q_WRITE(dev, q, dma_idx, 0);
 	mt76_dma_sync_idx(dev, q);
 }
 
@@ -224,7 +228,7 @@ static void
 mt76_dma_kick_queue(struct mt76_dev *dev, struct mt76_queue *q)
 {
 	wmb();
-	writel(q->head, &q->regs->cpu_idx);
+	Q_WRITE(dev, q, cpu_idx, q->head);
 }
 
 static void
@@ -240,7 +244,7 @@ mt76_dma_tx_cleanup(struct mt76_dev *dev, struct mt76_queue *q, bool flush)
 	if (flush)
 		last = -1;
 	else
-		last = readl(&q->regs->dma_idx);
+		last = Q_READ(dev, q, dma_idx);
 
 	while (q->queued > 0 && q->tail != last) {
 		mt76_dma_tx_cleanup_idx(dev, q, q->tail, &entry);
@@ -252,7 +256,7 @@ mt76_dma_tx_cleanup(struct mt76_dev *dev, struct mt76_queue *q, bool flush)
 		}
 
 		if (!flush && q->tail == last)
-			last = readl(&q->regs->dma_idx);
+			last = Q_READ(dev, q, dma_idx);
 
 	}
 	spin_unlock_bh(&q->cleanup_lock);
-- 
2.30.1


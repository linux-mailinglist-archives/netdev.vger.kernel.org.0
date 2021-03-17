Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6096533E3A3
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 01:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbhCQA5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 20:57:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231343AbhCQA44 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 20:56:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D67A64F9E;
        Wed, 17 Mar 2021 00:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942616;
        bh=8r7ZKpUpT54YHKo9ljUDkHxXozt3eNq1dGm1nOVyAfw=;
        h=From:To:Cc:Subject:Date:From;
        b=hFo/AoAJzbKRdNX87aC9pO52CXaAteqwDMeWCrhlEHMyj4xHLP8OiQcYSiNxIKFno
         bk36ifEH6h+k32ZrHihU7HDIp7sIMjSaCFDqZ7rcymlG+0glpgkQV1MNZ2D6vg/hVa
         5DcryYJxgu1B4ZwS5Ok2IFt3PWXWTvkRLsocWZOvvIIvXeED6KKc5kpW7G8xCCDSO9
         K9a4Rkq7Kd9CHVg1/xzRa0tjvW3AII3NA/kcme8pPvuUjIzCqeIT2Mv7N6pAdM9eDg
         czc9DLEavjHc58hFtugQh5U433Sen2l2Xl2Y1sEXloRrHkPnvaR8AcNpnZYGFnnZR8
         Dcxs/7b1cGhJQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 01/54] mt76: fix tx skb error handling in mt76_dma_tx_queue_skb
Date:   Tue, 16 Mar 2021 20:56:00 -0400
Message-Id: <20210317005654.724862-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit ae064fc0e32a4d28389086d9f4b260a0c157cfee ]

When running out of room in the tx queue after calling drv->tx_prepare_skb,
the buffer list will already have been modified on MT7615 and newer drivers.
This can leak a DMA mapping and will show up as swiotlb allocation failures
on x86.

Fix this by moving the queue length check further up. This is less accurate,
since it can overestimate the needed room in the queue on MT7615 and newer,
but the difference is small enough to not matter in practice.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210216135119.23809-1-nbd@nbd.name
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 917617aad8d3..3857761c9619 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -355,7 +355,6 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
 	};
 	struct ieee80211_hw *hw;
 	int len, n = 0, ret = -ENOMEM;
-	struct mt76_queue_entry e;
 	struct mt76_txwi_cache *t;
 	struct sk_buff *iter;
 	dma_addr_t addr;
@@ -397,6 +396,11 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
 	}
 	tx_info.nbuf = n;
 
+	if (q->queued + (tx_info.nbuf + 1) / 2 >= q->ndesc - 1) {
+		ret = -ENOMEM;
+		goto unmap;
+	}
+
 	dma_sync_single_for_cpu(dev->dev, t->dma_addr, dev->drv->txwi_size,
 				DMA_TO_DEVICE);
 	ret = dev->drv->tx_prepare_skb(dev, txwi, qid, wcid, sta, &tx_info);
@@ -405,11 +409,6 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
 	if (ret < 0)
 		goto unmap;
 
-	if (q->queued + (tx_info.nbuf + 1) / 2 >= q->ndesc - 1) {
-		ret = -ENOMEM;
-		goto unmap;
-	}
-
 	return mt76_dma_add_buf(dev, q, tx_info.buf, tx_info.nbuf,
 				tx_info.info, tx_info.skb, t);
 
@@ -425,9 +424,7 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
 		dev->test.tx_done--;
 #endif
 
-	e.skb = tx_info.skb;
-	e.txwi = t;
-	dev->drv->tx_complete_skb(dev, &e);
+	dev_kfree_skb(tx_info.skb);
 	mt76_put_txwi(dev, t);
 	return ret;
 }
-- 
2.30.1


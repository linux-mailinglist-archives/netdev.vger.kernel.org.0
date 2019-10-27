Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA072E6524
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 20:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727488AbfJ0Txj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 15:53:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726444AbfJ0Txi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Oct 2019 15:53:38 -0400
Received: from localhost.localdomain (unknown [151.66.57.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 714B820873;
        Sun, 27 Oct 2019 19:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572206018;
        bh=N4c146QPl39kJoKg4OtifqGseychqFfgprLDU7S1gvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rT7MsNPENnigWEuwqbDRj8pTsj6BzubD9T+31gPAhxF3wuf1UW9ixG1Vil5dfeWA8
         3rOzkZpWNThynpggshHxDSeUgCQQafJ49Ah86JfBZ8ZkYgl8VqCVSbxNBGjdsSU6G5
         aj6M/wRIwM0VqBUQ9O48XB6Tdn3JbXUC+cMNeK40=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, nbd@nbd.name, hkallweit1@gmail.com,
        sgruszka@redhat.com, lorenzo.bianconi@redhat.com,
        oleksandr@natalenko.name, netdev@vger.kernel.org
Subject: [PATCH v3 wireless-drivers 2/2] mt76: dma: fix buffer unmap with non-linear skbs
Date:   Sun, 27 Oct 2019 20:53:09 +0100
Message-Id: <b9c87448d9e5f3cf9cd5de5050f5c62e42c3de31.1572204430.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1572204430.git.lorenzo@kernel.org>
References: <cover.1572204430.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mt76 dma layer is supposed to unmap skb data buffers while keep txwi
mapped on hw dma ring. At the moment mt76 wrongly unmap txwi or does
not unmap data fragments in even positions for non-linear skbs. This
issue may result in hw hangs with A-MSDU if the system relies on IOMMU
or SWIOTLB. Fix this behaviour properly unmapping data fragments on
non-linear skbs.

Fixes: 17f1de56df05 ("mt76: add common code shared between multiple chipsets")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c  | 6 ++++--
 drivers/net/wireless/mediatek/mt76/mt76.h | 5 +++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index c747eb24581c..8f69d00bd940 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -53,8 +53,10 @@ mt76_dma_add_buf(struct mt76_dev *dev, struct mt76_queue *q,
 	u32 ctrl;
 	int i, idx = -1;
 
-	if (txwi)
+	if (txwi) {
 		q->entry[q->head].txwi = DMA_DUMMY_DATA;
+		q->entry[q->head].skip_buf0 = true;
+	}
 
 	for (i = 0; i < nbufs; i += 2, buf += 2) {
 		u32 buf0 = buf[0].addr, buf1 = 0;
@@ -97,7 +99,7 @@ mt76_dma_tx_cleanup_idx(struct mt76_dev *dev, struct mt76_queue *q, int idx,
 	__le32 __ctrl = READ_ONCE(q->desc[idx].ctrl);
 	u32 ctrl = le32_to_cpu(__ctrl);
 
-	if (!e->txwi || !e->skb) {
+	if (!e->skip_buf0) {
 		__le32 addr = READ_ONCE(q->desc[idx].buf0);
 		u32 len = FIELD_GET(MT_DMA_CTL_SD_LEN0, ctrl);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index dc468ed9434a..8aec7ccf2d79 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -93,8 +93,9 @@ struct mt76_queue_entry {
 		struct urb *urb;
 	};
 	enum mt76_txq_id qid;
-	bool schedule;
-	bool done;
+	bool skip_buf0:1;
+	bool schedule:1;
+	bool done:1;
 };
 
 struct mt76_queue_regs {
-- 
2.21.0


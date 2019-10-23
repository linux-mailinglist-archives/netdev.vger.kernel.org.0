Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31403E265A
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 00:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436786AbfJWWYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 18:24:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436651AbfJWWYc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 18:24:32 -0400
Received: from lore-desk.lan (unknown [151.66.11.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3A412173B;
        Wed, 23 Oct 2019 22:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571869471;
        bh=mRzuMXKMhF/cUZKhXc6fkszUgY7R3oT+oL8NgDG8tLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H6u7Wm0xCvMJIQZ/zb6/F/J5fuosGNlelku980iIFAA6gaDKqX4JLZZCFKUNYsjje
         +ML14CXt/lrRvGho8lrZTiFjV8+4ilyYvmxPxbmSOkIjGM+XkuPx7inwfSjpQwtyem
         NqSG1P0OGCzwjYoHcwauaXgHZuQB5CZUOrxK3b70=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, nbd@nbd.name, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com, oleksandr@natalenko.name,
        netdev@vger.kernel.org
Subject: [PATCH wireless-drivers 2/2] mt76: dma: fix buffer unmap with non-linear skbs
Date:   Thu, 24 Oct 2019 00:23:16 +0200
Message-Id: <1f7560e10edd517bfd9d3c0dd9820e6f420726b6.1571868221.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1571868221.git.lorenzo@kernel.org>
References: <cover.1571868221.git.lorenzo@kernel.org>
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
 drivers/net/wireless/mediatek/mt76/dma.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index c747eb24581c..8c27956875e7 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -93,11 +93,14 @@ static void
 mt76_dma_tx_cleanup_idx(struct mt76_dev *dev, struct mt76_queue *q, int idx,
 			struct mt76_queue_entry *prev_e)
 {
-	struct mt76_queue_entry *e = &q->entry[idx];
 	__le32 __ctrl = READ_ONCE(q->desc[idx].ctrl);
+	struct mt76_queue_entry *e = &q->entry[idx];
 	u32 ctrl = le32_to_cpu(__ctrl);
+	bool mcu = e->skb && !e->txwi;
+	bool first = e->skb == DMA_DUMMY_DATA || e->txwi == DMA_DUMMY_DATA ||
+		     (e->skb && !skb_is_nonlinear(e->skb));
 
-	if (!e->txwi || !e->skb) {
+	if (!first || mcu) {
 		__le32 addr = READ_ONCE(q->desc[idx].buf0);
 		u32 len = FIELD_GET(MT_DMA_CTL_SD_LEN0, ctrl);
 
@@ -105,7 +108,8 @@ mt76_dma_tx_cleanup_idx(struct mt76_dev *dev, struct mt76_queue *q, int idx,
 				 DMA_TO_DEVICE);
 	}
 
-	if (!(ctrl & MT_DMA_CTL_LAST_SEC0)) {
+	if (!(ctrl & MT_DMA_CTL_LAST_SEC0) ||
+	    e->txwi == DMA_DUMMY_DATA) {
 		__le32 addr = READ_ONCE(q->desc[idx].buf1);
 		u32 len = FIELD_GET(MT_DMA_CTL_SD_LEN1, ctrl);
 
-- 
2.21.0


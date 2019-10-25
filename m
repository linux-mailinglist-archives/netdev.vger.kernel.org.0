Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBD9E5401
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 20:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728920AbfJYSyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 14:54:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:36996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726155AbfJYSyp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 14:54:45 -0400
Received: from localhost.localdomain (unknown [151.66.57.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BE1921D81;
        Fri, 25 Oct 2019 18:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572029685;
        bh=ZRFCROFldmoJ7yk2MYx2AN/m78lliLIrcOCY+zfuVKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xjYviiSEodXVkb4Ol9lJnsv0oqHVid3cwHET8Ui5CJ52ztgyscNOSqNbO65N7QQq4
         Pr/ax85ijbgz9cG0FeMAxWyNt0vAGEeYfYD67pbjQaXcBV78Nb0+aziFOn1Kg0ra9s
         q8CwuoBUwswaEsZeC8XI5207/v5DkZR1ORCUq+C8=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, nbd@nbd.name, hkallweit1@gmail.com,
        sgruszka@redhat.com, lorenzo.bianconi@redhat.com,
        oleksandr@natalenko.name, netdev@vger.kernel.org
Subject: [PATCH v2 wireless-drivers 2/2] mt76: dma: fix buffer unmap with non-linear skbs
Date:   Fri, 25 Oct 2019 20:54:14 +0200
Message-Id: <f7488aa3b2944493afbc8ae76c897578ecf93b7b.1572029407.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1572029407.git.lorenzo@kernel.org>
References: <cover.1572029407.git.lorenzo@kernel.org>
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
index 962812b6247d..67a1515583fa 100644
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


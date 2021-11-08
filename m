Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03DDE44A1AA
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 02:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242332AbhKIBLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 20:11:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:60628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242016AbhKIBIv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 20:08:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2013761A71;
        Tue,  9 Nov 2021 01:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419845;
        bh=7aameh29KZ7F4eWJbvaEzI58laStKlQ9gTUJIFvTU8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u6l8jHbZ0i6o2NB24E5iIiXxIUFAi2dkVnz0QTfmH3iHqYiLbnIqez9UEWCSl7JGh
         5CMbT9CNHH8rcnCp6ENp7+huQCsrTMCzq45LULY0Dqgki87BnD5t3tcxRcZBrybH2q
         p0PUvawY6u+BtTWFqrqCdPsB/NsWEzpD6o62x1ycaVdy6miaiMoV+dYkUoP8YPSeWL
         DHUUCrs7a2UnTn5jFmt9evF2pv5h1QWLsr7evaGuiXGmmqF6bvVBGQCbTmyKqCcTzn
         nKuF+L8orQXHBA5+faMuzyQYfHcUBtk2VoijUrruwCIDwAA5JhF+U9sGyqNCkBX1lp
         wj9AjoBoZsyrg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Baochen Qiang <bqiang@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 025/101] ath11k: Change DMA_FROM_DEVICE to DMA_TO_DEVICE when map reinjected packets
Date:   Mon,  8 Nov 2021 12:47:15 -0500
Message-Id: <20211108174832.1189312-25-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174832.1189312-1-sashal@kernel.org>
References: <20211108174832.1189312-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baochen Qiang <bqiang@codeaurora.org>

[ Upstream commit 86a03dad0f5ad8182ed5fcf7bf3eec71cd96577c ]

For fragmented packets, ath11k reassembles each fragment as a normal
packet and then reinjects it into HW ring. In this case, the DMA
direction should be DMA_TO_DEVICE, not DMA_FROM_DEVICE, otherwise
invalid payload will be reinjected to HW and then delivered to host.
What is more, since arbitrary memory could be allocated to the frame, we
don't know what kind of data is contained in the buffer reinjected.
Thus, as a bad result, private info may be leaked.

Note that this issue is only found on Intel platform.

Tested-on: QCA6390 hw2.0 PCI WLAN.HST.1.0.1-01740-QCAHSTSWPLZ_V2_TO_X86-1
Signed-off-by: Baochen Qiang <bqiang@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210916064617.20006-1-bqiang@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 2bff8eb507d4d..7d6fd8155bb22 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -3273,7 +3273,7 @@ static int ath11k_dp_rx_h_defrag_reo_reinject(struct ath11k *ar, struct dp_rx_ti
 
 	paddr = dma_map_single(ab->dev, defrag_skb->data,
 			       defrag_skb->len + skb_tailroom(defrag_skb),
-			       DMA_FROM_DEVICE);
+			       DMA_TO_DEVICE);
 	if (dma_mapping_error(ab->dev, paddr))
 		return -ENOMEM;
 
@@ -3338,7 +3338,7 @@ static int ath11k_dp_rx_h_defrag_reo_reinject(struct ath11k *ar, struct dp_rx_ti
 	spin_unlock_bh(&rx_refill_ring->idr_lock);
 err_unmap_dma:
 	dma_unmap_single(ab->dev, paddr, defrag_skb->len + skb_tailroom(defrag_skb),
-			 DMA_FROM_DEVICE);
+			 DMA_TO_DEVICE);
 	return ret;
 }
 
-- 
2.33.0


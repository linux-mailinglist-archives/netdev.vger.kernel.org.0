Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4265A4914C2
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244795AbiARCYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:24:05 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39554 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244793AbiARCW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:22:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5326B60010;
        Tue, 18 Jan 2022 02:22:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8982CC36AF3;
        Tue, 18 Jan 2022 02:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472575;
        bh=rgstYFf8hJAZN1nCGJnttGKltvu+7dKK7FEZnsJpvbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mIyYZ169DicBzkRx/GXxWMH5Br/CckeiwNZ+Sr27N195r65M1iJNPTxQ7K1FyxjTq
         vb5KEIhF/eK0igHUIsTaETF5Bwa+GD4xW4KfYkLg/6xST+hnoEtziHSlMMh7eOq5yA
         G6EqjNaEAM8NJp2GO7AO6KGLVI+TdZNHRfjpnJiUhBUJJnXfaalfIz54O+ywFGnUgj
         ZpFvfz83BjgH3XWzQbq+H3ptdunY4kaEnmKGQBsGP0435QBIQFqupfZbBkRkoPd2Gh
         ado/go28tgIT+FFVDXUzKvbWq8tgVC+tjwU+s32z/pO5ijcPM9T62sWNVXdS7Z/MYt
         27obUWmZsMojQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anilkumar Kolli <akolli@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 059/217] ath11k: Fix mon status ring rx tlv processing
Date:   Mon, 17 Jan 2022 21:17:02 -0500
Message-Id: <20220118021940.1942199-59-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anilkumar Kolli <akolli@codeaurora.org>

[ Upstream commit 09f16f7390f302937409738d6cb6ce99b265f455 ]

In HE monitor capture, HAL_TLV_STATUS_PPDU_DONE is received
on processing multiple skb. Do not clear the ppdu_info
till the HAL_TLV_STATUS_PPDU_DONE is received.

This fixes below warning and packet drops in monitor mode.
 "Rate marked as an HE rate but data is invalid: MCS: 6, NSS: 0"
 WARNING: at
 PC is at ieee80211_rx_napi+0x624/0x840 [mac80211]

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.4.0.1-01693-QCAHKSWPL_SILICONZ-1

Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1637249433-10316-1-git-send-email-akolli@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index c5320847b80a7..f7968aefaabc5 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -3064,10 +3064,10 @@ int ath11k_dp_rx_process_mon_status(struct ath11k_base *ab, int mac_id,
 	if (!num_buffs_reaped)
 		goto exit;
 
-	while ((skb = __skb_dequeue(&skb_list))) {
-		memset(&ppdu_info, 0, sizeof(ppdu_info));
-		ppdu_info.peer_id = HAL_INVALID_PEERID;
+	memset(&ppdu_info, 0, sizeof(ppdu_info));
+	ppdu_info.peer_id = HAL_INVALID_PEERID;
 
+	while ((skb = __skb_dequeue(&skb_list))) {
 		if (ath11k_debugfs_is_pktlog_lite_mode_enabled(ar)) {
 			log_type = ATH11K_PKTLOG_TYPE_LITE_RX;
 			rx_buf_sz = DP_RX_BUFFER_SIZE_LITE;
@@ -3095,10 +3095,7 @@ int ath11k_dp_rx_process_mon_status(struct ath11k_base *ab, int mac_id,
 			ath11k_dbg(ab, ATH11K_DBG_DATA,
 				   "failed to find the peer with peer_id %d\n",
 				   ppdu_info.peer_id);
-			spin_unlock_bh(&ab->base_lock);
-			rcu_read_unlock();
-			dev_kfree_skb_any(skb);
-			continue;
+			goto next_skb;
 		}
 
 		arsta = (struct ath11k_sta *)peer->sta->drv_priv;
@@ -3107,10 +3104,13 @@ int ath11k_dp_rx_process_mon_status(struct ath11k_base *ab, int mac_id,
 		if (ath11k_debugfs_is_pktlog_peer_valid(ar, peer->addr))
 			trace_ath11k_htt_rxdesc(ar, skb->data, log_type, rx_buf_sz);
 
+next_skb:
 		spin_unlock_bh(&ab->base_lock);
 		rcu_read_unlock();
 
 		dev_kfree_skb_any(skb);
+		memset(&ppdu_info, 0, sizeof(ppdu_info));
+		ppdu_info.peer_id = HAL_INVALID_PEERID;
 	}
 exit:
 	return num_buffs_reaped;
-- 
2.34.1


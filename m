Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C62EA4919F9
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244942AbiARC5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:57:37 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58570 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349800AbiARCuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:50:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 165C5B8123F;
        Tue, 18 Jan 2022 02:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7A0C36AF5;
        Tue, 18 Jan 2022 02:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474219;
        bh=9oG4xj9ttTijGI2JUk52wdOZci4nJijHpeKVd81ia/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Re3cMTzOn9SRADsMWQ7Xncaviwk+Yb6k5Wjs2CZPqiLL8dAal/voIgk3SxgK9Vp0g
         FI/5IGo5usIfvW6wPmxjsR9QOg6FbcSsOXAjOiWqF6i0P5uZfNlOGkiPteOLFmgE/h
         m3wX0cbCxMVrNxb/bNUN97HFOSB9UDiEX8oLv1EWiJJZtoQI1ZpKUYkX4fSVCE8zWP
         dMzvi7M7xuIYB+TtJXcsfZPSDEB5pCmIpo0OLaA6Ml1QNm+6DznPaSq53qLEHDPevJ
         rvVTqqKWiwfqXpULIK8wMEsTXxbqQmrSeeaMN2LTINPXvBlpEnL9S6IrSnAk2Clg5G
         pQpgGOWfzc6yA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 28/56] ath10k: Fix tx hanging
Date:   Mon, 17 Jan 2022 21:48:40 -0500
Message-Id: <20220118024908.1953673-28-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024908.1953673-1-sashal@kernel.org>
References: <20220118024908.1953673-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Gottschall <s.gottschall@dd-wrt.com>

[ Upstream commit e8a91863eba3966a447d2daa1526082d52b5db2a ]

While running stress tests in roaming scenarios (switching ap's every 5
seconds, we discovered a issue which leads to tx hangings of exactly 5
seconds while or after scanning for new accesspoints. We found out that
this hanging is triggered by ath10k_mac_wait_tx_complete since the
empty_tx_wq was not wake when the num_tx_pending counter reaches zero.
To fix this, we simply move the wake_up call to htt_tx_dec_pending,
since this call was missed on several locations within the ath10k code.

Signed-off-by: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20210505085806.11474-1-s.gottschall@dd-wrt.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/htt_tx.c | 3 +++
 drivers/net/wireless/ath/ath10k/txrx.c   | 2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 685faac1368fd..21f5fb68b2046 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -158,6 +158,9 @@ void ath10k_htt_tx_dec_pending(struct ath10k_htt *htt)
 	htt->num_pending_tx--;
 	if (htt->num_pending_tx == htt->max_num_pending_tx - 1)
 		ath10k_mac_tx_unlock(htt->ar, ATH10K_TX_PAUSE_Q_FULL);
+
+	if (htt->num_pending_tx == 0)
+		wake_up(&htt->empty_tx_wq);
 }
 
 int ath10k_htt_tx_inc_pending(struct ath10k_htt *htt)
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 9999c8c40269d..e6705a30f3799 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -90,8 +90,6 @@ int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 
 	ath10k_htt_tx_free_msdu_id(htt, tx_done->msdu_id);
 	ath10k_htt_tx_dec_pending(htt);
-	if (htt->num_pending_tx == 0)
-		wake_up(&htt->empty_tx_wq);
 	spin_unlock_bh(&htt->tx_lock);
 
 	dma_unmap_single(dev, skb_cb->paddr, msdu->len, DMA_TO_DEVICE);
-- 
2.34.1


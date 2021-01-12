Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 596B32F3136
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389229AbhALM47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 07:56:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:53814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388644AbhALM46 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 07:56:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 927E02311C;
        Tue, 12 Jan 2021 12:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456142;
        bh=NjnX7vpBdEObQj3DwhFQMHbnPeyqEPEVzfFPPN/J79E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LrZFA5NkW+JrBdZU//FW5B0aGq5yuKD0m2yGiIl+bPnXXeBlVSh4DPzuu8T5qA8Qu
         L6fPmmnPDXyUn/GawuskNvm/N7m2xzrehC/Y3nXpDEEl4PLa4+aDEQFUQW8uVA1Jmc
         QGSPs3bqGUISiuBjSauKo4VuXk90n0eprd2jxOCutlYuvWfsNM+ENxyYG6oXeE/TbM
         PzVqnWS+4LaQCof4gz0ra7hOZXctz228xmJXBIdQn6/uq2RaXRoJbILLFyXApw6wUT
         tmTbqxFVrzRoKFnDZu8TXQt1sJ1FGfcMdGsYzD0bWZtLlENTSo0JC77kgDAdUrr0ty
         bit2IEIrWGEwg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Carl Huang <cjhuang@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 06/51] ath11k: fix crash caused by NULL rx_channel
Date:   Tue, 12 Jan 2021 07:54:48 -0500
Message-Id: <20210112125534.70280-6-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125534.70280-1-sashal@kernel.org>
References: <20210112125534.70280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Carl Huang <cjhuang@codeaurora.org>

[ Upstream commit 3597010630d0aa96f5778901e691c6068bb86318 ]

During connect and disconnect stress test, crashed happened
because ar->rx_channel is NULL. Fix it by checking whether
ar->rx_channel is NULL.

Crash stack is as below:
RIP: 0010:ath11k_dp_rx_h_ppdu+0x110/0x230 [ath11k]
[ 5028.808963]  ath11k_dp_rx_wbm_err+0x14a/0x360 [ath11k]
[ 5028.808970]  ath11k_dp_rx_process_wbm_err+0x41c/0x520 [ath11k]
[ 5028.808978]  ath11k_dp_service_srng+0x25e/0x2d0 [ath11k]
[ 5028.808982]  ath11k_pci_ext_grp_napi_poll+0x23/0x80 [ath11k_pci]
[ 5028.808986]  net_rx_action+0x27e/0x400
[ 5028.808990]  __do_softirq+0xfd/0x2bb
[ 5028.808993]  irq_exit+0xa6/0xb0
[ 5028.808995]  do_IRQ+0x56/0xe0
[ 5028.808997]  common_interrupt+0xf/0xf

Tested-on: QCA6390 hw2.0 PCI WLAN.HST.1.0.1-01740-QCAHSTSWPLZ_V2_TO_X86-1

Signed-off-by: Carl Huang <cjhuang@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20201211055613.9310-1-cjhuang@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 01625327eef7c..3638501a09593 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -2272,6 +2272,7 @@ static void ath11k_dp_rx_h_ppdu(struct ath11k *ar, struct hal_rx_desc *rx_desc,
 {
 	u8 channel_num;
 	u32 center_freq;
+	struct ieee80211_channel *channel;
 
 	rx_status->freq = 0;
 	rx_status->rate_idx = 0;
@@ -2292,9 +2293,12 @@ static void ath11k_dp_rx_h_ppdu(struct ath11k *ar, struct hal_rx_desc *rx_desc,
 		rx_status->band = NL80211_BAND_5GHZ;
 	} else {
 		spin_lock_bh(&ar->data_lock);
-		rx_status->band = ar->rx_channel->band;
-		channel_num =
-			ieee80211_frequency_to_channel(ar->rx_channel->center_freq);
+		channel = ar->rx_channel;
+		if (channel) {
+			rx_status->band = channel->band;
+			channel_num =
+				ieee80211_frequency_to_channel(channel->center_freq);
+		}
 		spin_unlock_bh(&ar->data_lock);
 		ath11k_dbg_dump(ar->ab, ATH11K_DBG_DATA, NULL, "rx_desc: ",
 				rx_desc, sizeof(struct hal_rx_desc));
-- 
2.27.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFE9644A107
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 02:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239167AbhKIBHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 20:07:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:60366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237348AbhKIBFP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 20:05:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9579A619A6;
        Tue,  9 Nov 2021 01:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419720;
        bh=qT2SY6fv46Gn9/Bc1mnjMQbsZb5EuuRuEpMBD50gTC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MD9SouZIMACddRu9W8hlyo2tuOJdqzhideu7kNo1o9MgQ3aMgatusjkDd8M9alWdr
         Fid6szhIfNiuX1JC60bbrXAC5OqB+XDxXLjCwGe4ra8r3WHLFmHnBe4RIlgYHwl6JO
         /V0XpNTNSxOW0Cg+1sjOzafmIVznUJzsjuh/eyWFqCAs8TTCzcYZttHPLSXRXK+4pJ
         n0j6LtqvCRBOliwg9rmk9qBRWzuPI3HUm4W7O4HyCW0qyopL5vuVaNEnL3WKkfIOPj
         9qJ5/xNmx61qIyi3ox0AdrhuFYtV4S78wEjGgtFgMbgvQnAKMmg+m2XK6+HA0XgSU7
         hx1bms7D9nzqg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Seevalamuthu Mariappan <seevalam@codeaurora.org>,
        Ritesh Singh <ritesi@codeaurora.org>,
        Jouni Malinen <jouni@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 017/138] ath11k: Align bss_chan_info structure with firmware
Date:   Mon,  8 Nov 2021 12:44:43 -0500
Message-Id: <20211108174644.1187889-17-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174644.1187889-1-sashal@kernel.org>
References: <20211108174644.1187889-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Seevalamuthu Mariappan <seevalam@codeaurora.org>

[ Upstream commit feab5bb8f1d4621025dceae7eef62d5f92de34ac ]

pdev_id in structure 'wmi_pdev_bss_chan_info_event' is wrongly placed
at the beginning. This causes invalid values in survey dump. Hence, align
the structure with the firmware.

Note: The firmware releases follow this order since the feature was
implemented. Also, it is not changing across the branches including
QCA6390.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.1.0.1-01228-QCAHKSWPL_SILICONZ-1

Signed-off-by: Ritesh Singh <ritesi@codeaurora.org>
Signed-off-by: Seevalamuthu Mariappan <seevalam@codeaurora.org>
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210720214922.118078-3-jouni@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 1 +
 drivers/net/wireless/ath/ath11k/wmi.h | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 6c253eae9d069..27c060dd3fb47 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -1339,6 +1339,7 @@ int ath11k_wmi_pdev_bss_chan_info_request(struct ath11k *ar,
 				     WMI_TAG_PDEV_BSS_CHAN_INFO_REQUEST) |
 			  FIELD_PREP(WMI_TLV_LEN, sizeof(*cmd) - TLV_HDR_SIZE);
 	cmd->req_type = type;
+	cmd->pdev_id = ar->pdev->pdev_id;
 
 	ath11k_dbg(ar->ab, ATH11K_DBG_WMI,
 		   "WMI bss chan info req type %d\n", type);
diff --git a/drivers/net/wireless/ath/ath11k/wmi.h b/drivers/net/wireless/ath/ath11k/wmi.h
index d35c47e0b19d4..0b7d337b36930 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.h
+++ b/drivers/net/wireless/ath/ath11k/wmi.h
@@ -2960,6 +2960,7 @@ struct wmi_pdev_bss_chan_info_req_cmd {
 	u32 tlv_header;
 	/* ref wmi_bss_chan_info_req_type */
 	u32 req_type;
+	u32 pdev_id;
 } __packed;
 
 struct wmi_ap_ps_peer_cmd {
@@ -4056,7 +4057,6 @@ struct wmi_vdev_stopped_event {
 } __packed;
 
 struct wmi_pdev_bss_chan_info_event {
-	u32 pdev_id;
 	u32 freq;	/* Units in MHz */
 	u32 noise_floor;	/* units are dBm */
 	/* rx clear - how often the channel was unused */
@@ -4074,6 +4074,7 @@ struct wmi_pdev_bss_chan_info_event {
 	/*rx_cycle cnt for my bss in 64bits format */
 	u32 rx_bss_cycle_count_low;
 	u32 rx_bss_cycle_count_high;
+	u32 pdev_id;
 } __packed;
 
 #define WMI_VDEV_INSTALL_KEY_COMPL_STATUS_SUCCESS 0
-- 
2.33.0


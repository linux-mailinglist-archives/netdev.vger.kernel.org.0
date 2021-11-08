Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF3FC44A189
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 02:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241644AbhKIBKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 20:10:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:33040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241944AbhKIBIm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 20:08:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF5D5619E9;
        Tue,  9 Nov 2021 01:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419825;
        bh=taL6sC6kBQ0kKIFnBN+DUqd0qu3vrvgE0qU8fkPqiAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E86Q6Q2/qa69RyGG6/x8KUJ74z1v2IgdqjOb464r0WUyps4dyuxsgxP2pMCzxqRYZ
         baFTLFuArMelYAFuCMG4Ptp6WJTXyBhPXwBLsdWo4uf50uFqeQ0Y3EXhXSFvB7cMPi
         m/1mYizYq9gw64biWScYhVGgexwdE78Kvzq1xF0q+EOyfuvU6JmV6YPFSvqr9WOXyG
         SfbwRVlNNVyEB3OvGh8IZ3tZoG4jW+xANUqZaUg+1MN2KvWQNJmxfZH7o5Ng55e/ae
         wODPVS6+PtkxEh/IwDxGWf1DkhA5o5Z4bEhso8ZD1SgtZvovHJR7oNVVCXh4g3oWMk
         P1yvF9xG/4GpQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Seevalamuthu Mariappan <seevalam@codeaurora.org>,
        Ritesh Singh <ritesi@codeaurora.org>,
        Jouni Malinen <jouni@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 016/101] ath11k: Align bss_chan_info structure with firmware
Date:   Mon,  8 Nov 2021 12:47:06 -0500
Message-Id: <20211108174832.1189312-16-sashal@kernel.org>
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
index eca86225a3413..fca71e00123d9 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -1333,6 +1333,7 @@ int ath11k_wmi_pdev_bss_chan_info_request(struct ath11k *ar,
 				     WMI_TAG_PDEV_BSS_CHAN_INFO_REQUEST) |
 			  FIELD_PREP(WMI_TLV_LEN, sizeof(*cmd) - TLV_HDR_SIZE);
 	cmd->req_type = type;
+	cmd->pdev_id = ar->pdev->pdev_id;
 
 	ath11k_dbg(ar->ab, ATH11K_DBG_WMI,
 		   "WMI bss chan info req type %d\n", type);
diff --git a/drivers/net/wireless/ath/ath11k/wmi.h b/drivers/net/wireless/ath/ath11k/wmi.h
index 5a32ba0eb4f57..c47adaab7918b 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.h
+++ b/drivers/net/wireless/ath/ath11k/wmi.h
@@ -2935,6 +2935,7 @@ struct wmi_pdev_bss_chan_info_req_cmd {
 	u32 tlv_header;
 	/* ref wmi_bss_chan_info_req_type */
 	u32 req_type;
+	u32 pdev_id;
 } __packed;
 
 struct wmi_ap_ps_peer_cmd {
@@ -4028,7 +4029,6 @@ struct wmi_vdev_stopped_event {
 } __packed;
 
 struct wmi_pdev_bss_chan_info_event {
-	u32 pdev_id;
 	u32 freq;	/* Units in MHz */
 	u32 noise_floor;	/* units are dBm */
 	/* rx clear - how often the channel was unused */
@@ -4046,6 +4046,7 @@ struct wmi_pdev_bss_chan_info_event {
 	/*rx_cycle cnt for my bss in 64bits format */
 	u32 rx_bss_cycle_count_low;
 	u32 rx_bss_cycle_count_high;
+	u32 pdev_id;
 } __packed;
 
 #define WMI_VDEV_INSTALL_KEY_COMPL_STATUS_SUCCESS 0
-- 
2.33.0


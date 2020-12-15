Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5372DB27E
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 18:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730599AbgLORZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 12:25:16 -0500
Received: from alexa-out.qualcomm.com ([129.46.98.28]:7628 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730884AbgLORY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 12:24:59 -0500
Received: from ironmsg-lv-alpha.qualcomm.com ([10.47.202.13])
  by alexa-out.qualcomm.com with ESMTP; 15 Dec 2020 09:24:43 -0800
X-QCInternal: smtphost
Received: from ironmsg02-blr.qualcomm.com ([10.86.208.131])
  by ironmsg-lv-alpha.qualcomm.com with ESMTP/TLS/AES256-SHA; 15 Dec 2020 09:24:41 -0800
X-QCInternal: smtphost
Received: from youghand-linux.qualcomm.com ([10.206.66.115])
  by ironmsg02-blr.qualcomm.com with ESMTP; 15 Dec 2020 22:54:38 +0530
Received: by youghand-linux.qualcomm.com (Postfix, from userid 2370257)
        id 9161820F1A; Tue, 15 Dec 2020 22:54:37 +0530 (IST)
From:   Youghandhar Chintala <youghand@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuabhs@chromium.org,
        dianders@chromium.org, briannorris@chromium.org,
        Rakesh Pillai <pillair@codeaurora.org>,
        Youghandhar Chintala <youghand@codeaurora.org>
Subject: [PATCH 3/3] ath10k: Set wiphy flag to trigger sta disconnect on hardware restart
Date:   Tue, 15 Dec 2020 22:54:35 +0530
Message-Id: <20201215172435.5388-1-youghand@codeaurora.org>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rakesh Pillai <pillair@codeaurora.org>

Currently after the hardware restart triggered from the driver,
the station interface connection remains intact, since a disconnect
trigger is not sent to userspace. This can lead to a problem in
hardwares where the wifi mac sequence is added by the firmware.

After the firmware restart, during subsytem recovery, the firmware
restarts its wifi mac sequence number. Hence AP to which our device
is connected will receive frames with a  wifi mac sequence number jump
to the past, thereby resulting in the AP dropping all these frames,
until the frame arrives with a wifi mac sequence number which AP was
expecting.

To avoid such frame drops, its better to trigger a station disconnect
upon the  hardware restart. Indicate this support via a WIPHY flag
to mac80211, if the hardware params flag mentions the support to
add wifi mac sequence numbers for TX frames in the firmware.

All the other hardwares, except WCN3990, are not affected by this
change, since the hardware params flag is not set for any hardware
except for WCN3990

Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.1-01040-QCAHLSWMTPLZ-1
Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00110-QCARMSWP-1
Tested-on: QCA6174 hw3.2 SDIO WLAN.RMH.4.4.1-00048

Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
Signed-off-by: Youghandhar Chintala <youghand@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.c | 15 +++++++++++++++
 drivers/net/wireless/ath/ath10k/hw.h   |  3 +++
 drivers/net/wireless/ath/ath10k/mac.c  |  3 +++
 3 files changed, 21 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 796107b..4155f94 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -90,6 +90,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.hw_filter_reset_required = true,
 		.fw_diag_ce_download = false,
 		.tx_stats_over_pktlog = true,
+		.tx_mac_seq_by_fw = false,
 	},
 	{
 		.id = QCA988X_HW_2_0_VERSION,
@@ -124,6 +125,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.hw_filter_reset_required = true,
 		.fw_diag_ce_download = false,
 		.tx_stats_over_pktlog = true,
+		.tx_mac_seq_by_fw = false,
 	},
 	{
 		.id = QCA9887_HW_1_0_VERSION,
@@ -159,6 +161,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.hw_filter_reset_required = true,
 		.fw_diag_ce_download = false,
 		.tx_stats_over_pktlog = false,
+		.tx_mac_seq_by_fw = false,
 	},
 	{
 		.id = QCA6174_HW_3_2_VERSION,
@@ -187,6 +190,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.num_wds_entries = 0x20,
 		.uart_pin_workaround = true,
 		.tx_stats_over_pktlog = false,
+		.tx_mac_seq_by_fw = false,
 		.bmi_large_size_download = true,
 		.supports_peer_stats_info = true,
 	},
@@ -223,6 +227,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.hw_filter_reset_required = true,
 		.fw_diag_ce_download = false,
 		.tx_stats_over_pktlog = false,
+		.tx_mac_seq_by_fw = false,
 	},
 	{
 		.id = QCA6174_HW_2_1_VERSION,
@@ -257,6 +262,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.hw_filter_reset_required = true,
 		.fw_diag_ce_download = false,
 		.tx_stats_over_pktlog = false,
+		.tx_mac_seq_by_fw = false,
 	},
 	{
 		.id = QCA6174_HW_3_0_VERSION,
@@ -291,6 +297,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.hw_filter_reset_required = true,
 		.fw_diag_ce_download = false,
 		.tx_stats_over_pktlog = false,
+		.tx_mac_seq_by_fw = false,
 	},
 	{
 		.id = QCA6174_HW_3_2_VERSION,
@@ -328,6 +335,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.hw_filter_reset_required = true,
 		.fw_diag_ce_download = true,
 		.tx_stats_over_pktlog = false,
+		.tx_mac_seq_by_fw = false,
 		.supports_peer_stats_info = true,
 	},
 	{
@@ -369,6 +377,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.hw_filter_reset_required = true,
 		.fw_diag_ce_download = false,
 		.tx_stats_over_pktlog = false,
+		.tx_mac_seq_by_fw = false,
 	},
 	{
 		.id = QCA9984_HW_1_0_DEV_VERSION,
@@ -416,6 +425,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.hw_filter_reset_required = true,
 		.fw_diag_ce_download = false,
 		.tx_stats_over_pktlog = false,
+		.tx_mac_seq_by_fw = false,
 	},
 	{
 		.id = QCA9888_HW_2_0_DEV_VERSION,
@@ -460,6 +470,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.hw_filter_reset_required = true,
 		.fw_diag_ce_download = false,
 		.tx_stats_over_pktlog = false,
+		.tx_mac_seq_by_fw = false,
 	},
 	{
 		.id = QCA9377_HW_1_0_DEV_VERSION,
@@ -494,6 +505,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.hw_filter_reset_required = true,
 		.fw_diag_ce_download = false,
 		.tx_stats_over_pktlog = false,
+		.tx_mac_seq_by_fw = false,
 	},
 	{
 		.id = QCA9377_HW_1_1_DEV_VERSION,
@@ -530,6 +542,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.hw_filter_reset_required = true,
 		.fw_diag_ce_download = true,
 		.tx_stats_over_pktlog = false,
+		.tx_mac_seq_by_fw = false,
 	},
 	{
 		.id = QCA9377_HW_1_1_DEV_VERSION,
@@ -598,6 +611,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.hw_filter_reset_required = true,
 		.fw_diag_ce_download = false,
 		.tx_stats_over_pktlog = false,
+		.tx_mac_seq_by_fw = false,
 	},
 	{
 		.id = WCN3990_HW_1_0_DEV_VERSION,
@@ -625,6 +639,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.hw_filter_reset_required = false,
 		.fw_diag_ce_download = false,
 		.tx_stats_over_pktlog = false,
+		.tx_mac_seq_by_fw = true,
 	},
 };
 
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index c6ded21..c146d02 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -623,6 +623,9 @@ struct ath10k_hw_params {
 
 	/* provides bitrates for sta_statistics using WMI_TLV_PEER_STATS_INFO_EVENTID */
 	bool supports_peer_stats_info;
+
+	/* tx mac seq num is added by FW */
+	bool tx_mac_seq_by_fw;
 };
 
 struct htt_rx_desc;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index dc32c78..6fe9cd6 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -9890,6 +9890,9 @@ int ath10k_mac_register(struct ath10k *ar)
 	if (test_bit(WMI_SERVICE_TDLS_UAPSD_BUFFER_STA, ar->wmi.svc_map))
 		ieee80211_hw_set(ar->hw, SUPPORTS_TDLS_BUFFER_STA);
 
+	if (ar->hw_params.tx_mac_seq_by_fw)
+		ar->hw->wiphy->flags |= WIPHY_FLAG_STA_DISCONNECT_ON_HW_RESTART;
+
 	ar->hw->wiphy->flags |= WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
 	ar->hw->wiphy->flags |= WIPHY_FLAG_HAS_CHANNEL_SWITCH;
 	ar->hw->wiphy->max_remain_on_channel_duration = 5000;
-- 
2.7.4


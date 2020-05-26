Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 489A51C93A8
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 17:07:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726904AbgEGPG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 11:06:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:34494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbgEGPG4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 11:06:56 -0400
Received: from embeddedor (unknown [189.207.59.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 712132083B;
        Thu,  7 May 2020 15:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588864015;
        bh=tqHtCFNv3Uxs5iZjbx/jxHewq1k5bIs9RcOdNxzxAX0=;
        h=Date:From:To:Cc:Subject:From;
        b=a7KgI51ZaEnUDuqBvprVpHXmmAQrUGPYH5WEOe0a1pyfbe3lIHQLEJ2V5Xn38dbUx
         pK01LK6O458oeytFqViifID+gqUf+3LjCur9c+gtA6Yzr1UFsY2ayt/qKyQkQIy4Pt
         rY/sDaYVl2YOwfWvKPq2MoJvo1IKTNg7SRGTF6ME=
Date:   Thu, 7 May 2020 10:11:20 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] wil6210: Replace zero-length array with flexible-array
Message-ID: <20200507151120.GA4469@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current codebase makes use of the zero-length array language
extension to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by
this change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied. As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

sizeof(flexible-array-member) triggers a warning because flexible array
members have incomplete type[1]. There are some instances of code in
which the sizeof operator is being incorrectly/erroneously applied to
zero-length arrays and the result is zero. Such instances may be hiding
some bugs. So, this work (flexible-array member conversions) will also
help to get completely rid of those sorts of issues.

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/ath/wil6210/fw.h  | 16 ++++----
 drivers/net/wireless/ath/wil6210/wmi.c |  2 +-
 drivers/net/wireless/ath/wil6210/wmi.h | 56 +++++++++++++-------------
 3 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/fw.h b/drivers/net/wireless/ath/wil6210/fw.h
index 540fa1607794..440614d61156 100644
--- a/drivers/net/wireless/ath/wil6210/fw.h
+++ b/drivers/net/wireless/ath/wil6210/fw.h
@@ -33,7 +33,7 @@ struct wil_fw_record_head {
  */
 struct wil_fw_record_data { /* type == wil_fw_type_data */
 	__le32 addr;
-	__le32 data[0]; /* [data_size], see above */
+	__le32 data[]; /* [data_size], see above */
 } __packed;
 
 /* fill with constant @value, @size bytes starting from @addr */
@@ -61,7 +61,7 @@ struct wil_fw_record_capabilities { /* type == wil_fw_type_comment */
 	/* identifies capabilities record */
 	struct wil_fw_record_comment_hdr hdr;
 	/* capabilities (variable size), see enum wmi_fw_capability */
-	u8 capabilities[0];
+	u8 capabilities[];
 } __packed;
 
 /* FW VIF concurrency encoded inside a comment record
@@ -80,7 +80,7 @@ struct wil_fw_concurrency_combo {
 	u8 n_diff_channels; /* total number of different channels allowed */
 	u8 same_bi; /* for APs, 1 if all APs must have same BI */
 	/* keep last - concurrency limits, variable size by n_limits */
-	struct wil_fw_concurrency_limit limits[0];
+	struct wil_fw_concurrency_limit limits[];
 } __packed;
 
 struct wil_fw_record_concurrency { /* type == wil_fw_type_comment */
@@ -93,7 +93,7 @@ struct wil_fw_record_concurrency { /* type == wil_fw_type_comment */
 	/* number of concurrency combinations that follow */
 	__le16 n_combos;
 	/* keep last - combinations, variable size by n_combos */
-	struct wil_fw_concurrency_combo combos[0];
+	struct wil_fw_concurrency_combo combos[];
 } __packed;
 
 /* brd file info encoded inside a comment record */
@@ -108,7 +108,7 @@ struct wil_fw_record_brd_file { /* type == wil_fw_type_comment */
 	/* identifies brd file record */
 	struct wil_fw_record_comment_hdr hdr;
 	__le32 version;
-	struct brd_info brd_info[0];
+	struct brd_info brd_info[];
 } __packed;
 
 /* perform action
@@ -116,7 +116,7 @@ struct wil_fw_record_brd_file { /* type == wil_fw_type_comment */
  */
 struct wil_fw_record_action { /* type == wil_fw_type_action */
 	__le32 action; /* action to perform: reset, wait for fw ready etc. */
-	__le32 data[0]; /* action specific, [data_size], see above */
+	__le32 data[]; /* action specific, [data_size], see above */
 } __packed;
 
 /* data block for struct wil_fw_record_direct_write */
@@ -179,7 +179,7 @@ struct wil_fw_record_gateway_data { /* type == wil_fw_type_gateway_data */
 #define WIL_FW_GW_CTL_BUSY	BIT(29) /* gateway busy performing operation */
 #define WIL_FW_GW_CTL_RUN	BIT(30) /* start gateway operation */
 	__le32 command;
-	struct wil_fw_data_gw data[0]; /* total size [data_size], see above */
+	struct wil_fw_data_gw data[]; /* total size [data_size], see above */
 } __packed;
 
 /* 4-dword gateway */
@@ -201,7 +201,7 @@ struct wil_fw_record_gateway_data4 { /* type == wil_fw_type_gateway_data4 */
 	__le32 gateway_cmd_addr;
 	__le32 gateway_ctrl_address; /* same logic as for 1-dword gw */
 	__le32 command;
-	struct wil_fw_data_gw4 data[0]; /* total size [data_size], see above */
+	struct wil_fw_data_gw4 data[]; /* total size [data_size], see above */
 } __packed;
 
 #endif /* __WIL_FW_H__ */
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 23e1ed6a9d6d..c7136ce567ee 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -222,7 +222,7 @@ struct auth_no_hdr {
 	__le16 auth_transaction;
 	__le16 status_code;
 	/* possibly followed by Challenge text */
-	u8 variable[0];
+	u8 variable[];
 } __packed;
 
 u8 led_polarity = LED_POLARITY_LOW_ACTIVE;
diff --git a/drivers/net/wireless/ath/wil6210/wmi.h b/drivers/net/wireless/ath/wil6210/wmi.h
index e3558136e0c4..4044890b036d 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.h
+++ b/drivers/net/wireless/ath/wil6210/wmi.h
@@ -530,7 +530,7 @@ struct wmi_update_ft_ies_cmd {
 	/* Length of the FT IEs */
 	__le16 ie_len;
 	u8 reserved[2];
-	u8 ie_info[0];
+	u8 ie_info[];
 } __packed;
 
 /* WMI_SET_PROBED_SSID_CMDID */
@@ -575,7 +575,7 @@ struct wmi_set_appie_cmd {
 	u8 reserved;
 	/* Length of the IE to be added to MGMT frame */
 	__le16 ie_len;
-	u8 ie_info[0];
+	u8 ie_info[];
 } __packed;
 
 /* WMI_PXMT_RANGE_CFG_CMDID */
@@ -850,7 +850,7 @@ struct wmi_pcp_start_cmd {
 struct wmi_sw_tx_req_cmd {
 	u8 dst_mac[WMI_MAC_LEN];
 	__le16 len;
-	u8 payload[0];
+	u8 payload[];
 } __packed;
 
 /* WMI_SW_TX_REQ_EXT_CMDID */
@@ -861,7 +861,7 @@ struct wmi_sw_tx_req_ext_cmd {
 	/* Channel to use, 0xFF for currently active channel */
 	u8 channel;
 	u8 reserved[5];
-	u8 payload[0];
+	u8 payload[];
 } __packed;
 
 /* WMI_VRING_SWITCH_TIMING_CONFIG_CMDID */
@@ -1423,7 +1423,7 @@ struct wmi_rf_xpm_write_cmd {
 	u8 verify;
 	u8 reserved1[3];
 	/* actual size=num_bytes */
-	u8 data_bytes[0];
+	u8 data_bytes[];
 } __packed;
 
 /* Possible modes for temperature measurement */
@@ -1572,7 +1572,7 @@ struct wmi_tof_session_start_cmd {
 	u8 aoa_type;
 	__le16 num_of_dest;
 	u8 reserved[4];
-	struct wmi_ftm_dest_info ftm_dest_info[0];
+	struct wmi_ftm_dest_info ftm_dest_info[];
 } __packed;
 
 /* WMI_TOF_CFG_RESPONDER_CMDID */
@@ -1766,7 +1766,7 @@ struct wmi_internal_fw_ioctl_cmd {
 	/* payload max size is WMI_MAX_IOCTL_PAYLOAD_SIZE
 	 * Must be the last member of the struct
 	 */
-	__le32 payload[0];
+	__le32 payload[];
 } __packed;
 
 /* WMI_INTERNAL_FW_IOCTL_EVENTID */
@@ -1778,7 +1778,7 @@ struct wmi_internal_fw_ioctl_event {
 	/* payload max size is WMI_MAX_IOCTL_REPLY_PAYLOAD_SIZE
 	 * Must be the last member of the struct
 	 */
-	__le32 payload[0];
+	__le32 payload[];
 } __packed;
 
 /* WMI_INTERNAL_FW_EVENT_EVENTID */
@@ -1788,7 +1788,7 @@ struct wmi_internal_fw_event_event {
 	/* payload max size is WMI_MAX_INTERNAL_EVENT_PAYLOAD_SIZE
 	 * Must be the last member of the struct
 	 */
-	__le32 payload[0];
+	__le32 payload[];
 } __packed;
 
 /* WMI_SET_VRING_PRIORITY_WEIGHT_CMDID */
@@ -1818,7 +1818,7 @@ struct wmi_set_vring_priority_cmd {
 	 */
 	u8 num_of_vrings;
 	u8 reserved[3];
-	struct wmi_vring_priority vring_priority[0];
+	struct wmi_vring_priority vring_priority[];
 } __packed;
 
 /* WMI_BF_CONTROL_CMDID - deprecated */
@@ -1910,7 +1910,7 @@ struct wmi_bf_control_ex_cmd {
 	u8 each_mcs_cfg_size;
 	u8 reserved1;
 	/* Configuration for each MCS */
-	struct wmi_bf_control_ex_mcs each_mcs_cfg[0];
+	struct wmi_bf_control_ex_mcs each_mcs_cfg[];
 } __packed;
 
 /* WMI_LINK_STATS_CMD */
@@ -2192,7 +2192,7 @@ struct wmi_fw_ver_event {
 	/* FW capabilities info
 	 * Must be the last member of the struct
 	 */
-	__le32 fw_capabilities[0];
+	__le32 fw_capabilities[];
 } __packed;
 
 /* WMI_GET_RF_STATUS_EVENTID */
@@ -2270,7 +2270,7 @@ struct wmi_mac_addr_resp_event {
 struct wmi_eapol_rx_event {
 	u8 src_mac[WMI_MAC_LEN];
 	__le16 eapol_len;
-	u8 eapol[0];
+	u8 eapol[];
 } __packed;
 
 /* WMI_READY_EVENTID */
@@ -2343,7 +2343,7 @@ struct wmi_connect_event {
 	u8 aid;
 	u8 reserved2[2];
 	/* not in use */
-	u8 assoc_info[0];
+	u8 assoc_info[];
 } __packed;
 
 /* disconnect_reason */
@@ -2376,7 +2376,7 @@ struct wmi_disconnect_event {
 	/* last assoc req may passed to host - not in used */
 	u8 assoc_resp_len;
 	/* last assoc req may passed to host - not in used */
-	u8 assoc_info[0];
+	u8 assoc_info[];
 } __packed;
 
 /* WMI_SCAN_COMPLETE_EVENTID */
@@ -2400,7 +2400,7 @@ struct wmi_ft_auth_status_event {
 	u8 reserved[3];
 	u8 mac_addr[WMI_MAC_LEN];
 	__le16 ie_len;
-	u8 ie_info[0];
+	u8 ie_info[];
 } __packed;
 
 /* WMI_FT_REASSOC_STATUS_EVENTID */
@@ -2418,7 +2418,7 @@ struct wmi_ft_reassoc_status_event {
 	__le16 reassoc_req_ie_len;
 	__le16 reassoc_resp_ie_len;
 	u8 reserved[4];
-	u8 ie_info[0];
+	u8 ie_info[];
 } __packed;
 
 /* wmi_rx_mgmt_info */
@@ -2461,7 +2461,7 @@ struct wmi_stop_sched_scan_event {
 
 struct wmi_sched_scan_result_event {
 	struct wmi_rx_mgmt_info info;
-	u8 payload[0];
+	u8 payload[];
 } __packed;
 
 /* WMI_ACS_PASSIVE_SCAN_COMPLETE_EVENT */
@@ -2492,7 +2492,7 @@ struct wmi_acs_passive_scan_complete_event {
 	__le16 filled;
 	u8 num_scanned_channels;
 	u8 reserved;
-	struct scan_acs_info scan_info_list[0];
+	struct scan_acs_info scan_info_list[];
 } __packed;
 
 /* WMI_BA_STATUS_EVENTID */
@@ -2751,7 +2751,7 @@ struct wmi_rf_xpm_read_result_event {
 	u8 status;
 	u8 reserved[3];
 	/* requested num_bytes of data */
-	u8 data_bytes[0];
+	u8 data_bytes[];
 } __packed;
 
 /* EVENT: WMI_RF_XPM_WRITE_RESULT_EVENTID */
@@ -2769,7 +2769,7 @@ struct wmi_tx_mgmt_packet_event {
 /* WMI_RX_MGMT_PACKET_EVENTID */
 struct wmi_rx_mgmt_packet_event {
 	struct wmi_rx_mgmt_info info;
-	u8 payload[0];
+	u8 payload[];
 } __packed;
 
 /* WMI_ECHO_RSP_EVENTID */
@@ -2969,7 +2969,7 @@ struct wmi_rs_cfg_ex_cmd {
 	u8 each_mcs_cfg_size;
 	u8 reserved[3];
 	/* Configuration for each MCS */
-	struct wmi_rs_cfg_ex_mcs each_mcs_cfg[0];
+	struct wmi_rs_cfg_ex_mcs each_mcs_cfg[];
 } __packed;
 
 /* WMI_RS_CFG_EX_EVENTID */
@@ -3178,7 +3178,7 @@ struct wmi_get_detailed_rs_res_ex_event {
 	u8 each_mcs_results_size;
 	u8 reserved1[3];
 	/* Results for each MCS */
-	struct wmi_rs_results_ex_mcs each_mcs_results[0];
+	struct wmi_rs_results_ex_mcs each_mcs_results[];
 } __packed;
 
 /* BRP antenna limit mode */
@@ -3320,7 +3320,7 @@ struct wmi_set_link_monitor_cmd {
 	u8 rssi_hyst;
 	u8 reserved[12];
 	u8 rssi_thresholds_list_size;
-	s8 rssi_thresholds_list[0];
+	s8 rssi_thresholds_list[];
 } __packed;
 
 /* wmi_link_monitor_event_type */
@@ -3637,7 +3637,7 @@ struct wmi_tof_ftm_per_dest_res_event {
 	/* Measurments are from RFs, defined by the mask */
 	__le32 meas_rf_mask;
 	u8 reserved0[3];
-	struct wmi_responder_ftm_res responder_ftm_res[0];
+	struct wmi_responder_ftm_res responder_ftm_res[];
 } __packed;
 
 /* WMI_TOF_CFG_RESPONDER_EVENTID */
@@ -3669,7 +3669,7 @@ struct wmi_tof_channel_info_event {
 	/* data report length */
 	u8 len;
 	/* data report payload */
-	u8 report[0];
+	u8 report[];
 } __packed;
 
 /* WMI_TOF_SET_TX_RX_OFFSET_EVENTID */
@@ -4085,7 +4085,7 @@ struct wmi_link_stats_event {
 	u8 has_next;
 	u8 reserved[5];
 	/* a stream of wmi_link_stats_record_s */
-	u8 payload[0];
+	u8 payload[];
 } __packed;
 
 /* WMI_LINK_STATS_EVENT */
@@ -4094,7 +4094,7 @@ struct wmi_link_stats_record {
 	u8 record_type_id;
 	u8 reserved;
 	__le16 record_size;
-	u8 record[0];
+	u8 record[];
 } __packed;
 
 /* WMI_LINK_STATS_TYPE_BASIC */
-- 
2.26.2


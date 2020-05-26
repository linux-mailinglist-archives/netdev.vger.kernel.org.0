Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAEDF1C80B7
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 06:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725969AbgEGEHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 00:07:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725446AbgEGEHD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 00:07:03 -0400
Received: from embeddedor (unknown [189.207.59.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA7D6207DD;
        Thu,  7 May 2020 04:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588824421;
        bh=Qjl8q9KeSlSSJb0tTmYm79fxfUlJdsATja9wRx6HapQ=;
        h=Date:From:To:Cc:Subject:From;
        b=ulpARn45Rv6frJPNPpCwYT9hJE5QbtKTZ+/us7eVD8B0AJby+5t3Vj1q8OYBvcIO0
         kX1NaiacVGtOf06XfjwFmIL58+PfnWSgPUOU0osDVhWg1OXy+Ik4reToorMxEqtoMs
         NGDLpTqtZi6OanYF1qWggpZGZwiHJVaY87iOECmU=
Date:   Wed, 6 May 2020 23:11:27 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH v2] ath10k: Replace zero-length array with flexible-array
Message-ID: <20200507041127.GA31587@embeddedor>
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

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
Changes in v2:
 - Rebase on top of ath.git master branch.

 drivers/net/wireless/ath/ath10k/ce.h       |  2 +-
 drivers/net/wireless/ath/ath10k/core.h     |  2 +-
 drivers/net/wireless/ath/ath10k/coredump.h |  4 +--
 drivers/net/wireless/ath/ath10k/debug.h    |  2 +-
 drivers/net/wireless/ath/ath10k/htt.h      | 42 +++++++++++-----------
 drivers/net/wireless/ath/ath10k/hw.h       |  2 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h  |  6 ++--
 drivers/net/wireless/ath/ath10k/wmi.h      | 42 +++++++++++-----------
 8 files changed, 51 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
index 9711f0eb9117..75df79d43120 100644
--- a/drivers/net/wireless/ath/ath10k/ce.h
+++ b/drivers/net/wireless/ath/ath10k/ce.h
@@ -110,7 +110,7 @@ struct ath10k_ce_ring {
 	struct ce_desc_64 *shadow_base;
 
 	/* keep last */
-	void *per_transfer_context[0];
+	void *per_transfer_context[];
 };
 
 struct ath10k_ce_pipe {
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index ceac76553b8f..5c18f6c20462 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -1262,7 +1262,7 @@ struct ath10k {
 	int coex_gpio_pin;
 
 	/* must be last */
-	u8 drv_priv[0] __aligned(sizeof(void *));
+	u8 drv_priv[] __aligned(sizeof(void *));
 };
 
 static inline bool ath10k_peer_stats_enabled(struct ath10k *ar)
diff --git a/drivers/net/wireless/ath/ath10k/coredump.h b/drivers/net/wireless/ath/ath10k/coredump.h
index 8bf03e8c1d3a..e760ce1a5f1e 100644
--- a/drivers/net/wireless/ath/ath10k/coredump.h
+++ b/drivers/net/wireless/ath/ath10k/coredump.h
@@ -88,7 +88,7 @@ struct ath10k_dump_file_data {
 	u8 unused[128];
 
 	/* struct ath10k_tlv_dump_data + more */
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 struct ath10k_dump_ram_data_hdr {
@@ -100,7 +100,7 @@ struct ath10k_dump_ram_data_hdr {
 	/* length of payload data, not including this header */
 	__le32 length;
 
-	u8 data[0];
+	u8 data[];
 };
 
 /* magic number to fill the holes not copied due to sections in regions */
diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 4cbfd9279d6f..997c1c80aba7 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -65,7 +65,7 @@ struct ath10k_pktlog_hdr {
 	__le16 log_type; /* Type of log information foll this header */
 	__le16 size; /* Size of variable length log information in bytes */
 	__le32 timestamp;
-	u8 payload[0];
+	u8 payload[];
 } __packed;
 
 /* FIXME: How to calculate the buffer size sanely? */
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 8f3710cf28f4..e504be63173a 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -289,12 +289,12 @@ struct htt_rx_ring_setup_hdr {
 
 struct htt_rx_ring_setup_32 {
 	struct htt_rx_ring_setup_hdr hdr;
-	struct htt_rx_ring_setup_ring32 rings[0];
+	struct htt_rx_ring_setup_ring32 rings[];
 } __packed;
 
 struct htt_rx_ring_setup_64 {
 	struct htt_rx_ring_setup_hdr hdr;
-	struct htt_rx_ring_setup_ring64 rings[0];
+	struct htt_rx_ring_setup_ring64 rings[];
 } __packed;
 
 /*
@@ -732,7 +732,7 @@ struct htt_rx_indication {
 	 * %mpdu_ranges starts after &%prefix + roundup(%fw_rx_desc_bytes, 4)
 	 * and has %num_mpdu_ranges elements.
 	 */
-	struct htt_rx_indication_mpdu_range mpdu_ranges[0];
+	struct htt_rx_indication_mpdu_range mpdu_ranges[];
 } __packed;
 
 /* High latency version of the RX indication */
@@ -741,7 +741,7 @@ struct htt_rx_indication_hl {
 	struct htt_rx_indication_ppdu ppdu;
 	struct htt_rx_indication_prefix prefix;
 	struct fw_rx_desc_hl fw_desc;
-	struct htt_rx_indication_mpdu_range mpdu_ranges[0];
+	struct htt_rx_indication_mpdu_range mpdu_ranges[];
 } __packed;
 
 struct htt_hl_rx_desc {
@@ -908,7 +908,7 @@ struct htt_append_retries {
 struct htt_data_tx_completion_ext {
 	struct htt_append_retries a_retries;
 	__le32 t_stamp;
-	__le16 msdus_rssi[0];
+	__le16 msdus_rssi[];
 } __packed;
 
 /**
@@ -992,7 +992,7 @@ struct htt_data_tx_completion {
 	} __packed;
 	u8 num_msdus;
 	u8 flags2; /* HTT_TX_CMPL_FLAG_DATA_RSSI */
-	__le16 msdus[0]; /* variable length based on %num_msdus */
+	__le16 msdus[]; /* variable length based on %num_msdus */
 } __packed;
 
 #define HTT_TX_PPDU_DUR_INFO0_PEER_ID_MASK	GENMASK(15, 0)
@@ -1007,7 +1007,7 @@ struct htt_data_tx_ppdu_dur {
 
 struct htt_data_tx_compl_ppdu_dur {
 	__le32 info0; /* HTT_TX_COMPL_PPDU_DUR_INFO0_ */
-	struct htt_data_tx_ppdu_dur ppdu_dur[0];
+	struct htt_data_tx_ppdu_dur ppdu_dur[];
 } __packed;
 
 struct htt_tx_compl_ind_base {
@@ -1033,7 +1033,7 @@ struct htt_rc_update {
 	u8 addr[6];
 	u8 num_elems;
 	u8 rsvd0;
-	struct htt_rc_tx_done_params params[0]; /* variable length %num_elems */
+	struct htt_rc_tx_done_params params[]; /* variable length %num_elems */
 } __packed;
 
 /* see htt_rx_indication for similar fields and descriptions */
@@ -1050,7 +1050,7 @@ struct htt_rx_fragment_indication {
 	__le16 fw_rx_desc_bytes;
 	__le16 rsvd0;
 
-	u8 fw_msdu_rx_desc[0];
+	u8 fw_msdu_rx_desc[];
 } __packed;
 
 #define ATH10K_IEEE80211_EXTIV               BIT(5)
@@ -1075,7 +1075,7 @@ struct htt_rx_pn_ind {
 	u8 seqno_end;
 	u8 pn_ie_count;
 	u8 reserved;
-	u8 pn_ies[0];
+	u8 pn_ies[];
 } __packed;
 
 struct htt_rx_offload_msdu {
@@ -1084,7 +1084,7 @@ struct htt_rx_offload_msdu {
 	u8 vdev_id;
 	u8 tid;
 	u8 fw_desc;
-	u8 payload[0];
+	u8 payload[];
 } __packed;
 
 struct htt_rx_offload_ind {
@@ -1167,7 +1167,7 @@ struct htt_rx_test {
 	 *  a) num_ints * sizeof(__le32)
 	 *  b) num_chars * sizeof(u8) aligned to 4bytes
 	 */
-	u8 payload[0];
+	u8 payload[];
 } __packed;
 
 static inline __le32 *htt_rx_test_get_ints(struct htt_rx_test *rx_test)
@@ -1201,7 +1201,7 @@ static inline u8 *htt_rx_test_get_chars(struct htt_rx_test *rx_test)
  */
 struct htt_pktlog_msg {
 	u8 pad[3];
-	u8 payload[0];
+	u8 payload[];
 } __packed;
 
 struct htt_dbg_stats_rx_reorder_stats {
@@ -1490,7 +1490,7 @@ struct htt_stats_conf_item {
 	} __packed;
 	u8 pad;
 	__le16 length;
-	u8 payload[0]; /* roundup(length, 4) long */
+	u8 payload[]; /* roundup(length, 4) long */
 } __packed;
 
 struct htt_stats_conf {
@@ -1499,7 +1499,7 @@ struct htt_stats_conf {
 	__le32 cookie_msb;
 
 	/* each item has variable length! */
-	struct htt_stats_conf_item items[0];
+	struct htt_stats_conf_item items[];
 } __packed;
 
 static inline struct htt_stats_conf_item *htt_stats_conf_next_item(
@@ -1674,7 +1674,7 @@ struct htt_tx_fetch_ind {
 	__le16 num_resp_ids;
 	__le16 num_records;
 	struct htt_tx_fetch_record records[0];
-	__le32 resp_ids[0]; /* ath10k_htt_get_tx_fetch_ind_resp_ids() */
+	__le32 resp_ids[]; /* ath10k_htt_get_tx_fetch_ind_resp_ids() */
 } __packed;
 
 static inline void *
@@ -1689,13 +1689,13 @@ struct htt_tx_fetch_resp {
 	__le16 fetch_seq_num;
 	__le16 num_records;
 	__le32 token;
-	struct htt_tx_fetch_record records[0];
+	struct htt_tx_fetch_record records[];
 } __packed;
 
 struct htt_tx_fetch_confirm {
 	u8 pad0;
 	__le16 num_resp_ids;
-	__le32 resp_ids[0];
+	__le32 resp_ids[];
 } __packed;
 
 enum htt_tx_mode_switch_mode {
@@ -1727,7 +1727,7 @@ struct htt_tx_mode_switch_ind {
 	__le16 info0; /* HTT_TX_MODE_SWITCH_IND_INFO0_ */
 	__le16 info1; /* HTT_TX_MODE_SWITCH_IND_INFO1_ */
 	u8 pad1[2];
-	struct htt_tx_mode_switch_record records[0];
+	struct htt_tx_mode_switch_record records[];
 } __packed;
 
 struct htt_channel_change {
@@ -1757,7 +1757,7 @@ struct htt_peer_tx_stats {
 	u8 num_ppdu;
 	u8 ppdu_len;
 	u8 version;
-	u8 payload[0];
+	u8 payload[];
 } __packed;
 
 #define ATH10K_10_2_TX_STATS_OFFSET	136
@@ -2206,7 +2206,7 @@ struct htt_rx_desc {
 		struct rx_ppdu_end ppdu_end;
 	} __packed;
 	u8 rx_hdr_status[RX_HTT_HDR_STATUS_LEN];
-	u8 msdu_payload[0];
+	u8 msdu_payload[];
 };
 
 #define HTT_RX_DESC_HL_INFO_SEQ_NUM_MASK           0x00000fff
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index d9907a4648a8..f16edcb9f326 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -165,7 +165,7 @@ enum qca9377_chip_id_rev {
 struct ath10k_fw_ie {
 	__le32 id;
 	__le32 len;
-	u8 data[0];
+	u8 data[];
 };
 
 enum ath10k_fw_ie_type {
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.h b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
index 6e0537dabd1d..e77b97ca5c7f 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.h
@@ -1637,7 +1637,7 @@ wmi_tlv_svc_map_ext(const __le32 *in, unsigned long *out, size_t len)
 struct wmi_tlv {
 	__le16 len;
 	__le16 tag;
-	u8 value[0];
+	u8 value[];
 } __packed;
 
 struct ath10k_mgmt_tx_pkt_addr {
@@ -2037,7 +2037,7 @@ struct wmi_tlv_bcn_tx_status_ev {
 struct wmi_tlv_bcn_prb_info {
 	__le32 caps;
 	__le32 erp;
-	u8 ies[0];
+	u8 ies[];
 } __packed;
 
 struct wmi_tlv_bcn_tmpl_cmd {
@@ -2068,7 +2068,7 @@ struct wmi_tlv_diag_item {
 	__le16 len;
 	__le32 timestamp;
 	__le32 code;
-	u8 payload[0];
+	u8 payload[];
 } __packed;
 
 struct wmi_tlv_diag_data_ev {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 0f05405bebc0..511144b36231 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -2292,7 +2292,7 @@ struct wmi_service_ready_event {
 	 * where FW can access this memory directly (or) by DMA.
 	 */
 	__le32 num_mem_reqs;
-	struct wlan_host_mem_req mem_reqs[0];
+	struct wlan_host_mem_req mem_reqs[];
 } __packed;
 
 /* This is the definition from 10.X firmware branch */
@@ -2331,7 +2331,7 @@ struct wmi_10x_service_ready_event {
 	 */
 	__le32 num_mem_reqs;
 
-	struct wlan_host_mem_req mem_reqs[0];
+	struct wlan_host_mem_req mem_reqs[];
 } __packed;
 
 #define WMI_SERVICE_READY_TIMEOUT_HZ (5 * HZ)
@@ -3086,19 +3086,19 @@ struct wmi_chan_list_entry {
 struct wmi_chan_list {
 	__le32 tag; /* WMI_CHAN_LIST_TAG */
 	__le32 num_chan;
-	struct wmi_chan_list_entry channel_list[0];
+	struct wmi_chan_list_entry channel_list[];
 } __packed;
 
 struct wmi_bssid_list {
 	__le32 tag; /* WMI_BSSID_LIST_TAG */
 	__le32 num_bssid;
-	struct wmi_mac_addr bssid_list[0];
+	struct wmi_mac_addr bssid_list[];
 } __packed;
 
 struct wmi_ie_data {
 	__le32 tag; /* WMI_IE_TAG */
 	__le32 ie_len;
-	u8 ie_data[0];
+	u8 ie_data[];
 } __packed;
 
 struct wmi_ssid {
@@ -3109,7 +3109,7 @@ struct wmi_ssid {
 struct wmi_ssid_list {
 	__le32 tag; /* WMI_SSID_LIST_TAG */
 	__le32 num_ssids;
-	struct wmi_ssid ssids[0];
+	struct wmi_ssid ssids[];
 } __packed;
 
 /* prefix used by scan requestor ids on the host */
@@ -3311,7 +3311,7 @@ struct wmi_stop_scan_arg {
 
 struct wmi_scan_chan_list_cmd {
 	__le32 num_scan_chans;
-	struct wmi_channel chan_info[0];
+	struct wmi_channel chan_info[];
 } __packed;
 
 struct wmi_scan_chan_list_arg {
@@ -3395,12 +3395,12 @@ struct wmi_mgmt_rx_hdr_v2 {
 
 struct wmi_mgmt_rx_event_v1 {
 	struct wmi_mgmt_rx_hdr_v1 hdr;
-	u8 buf[0];
+	u8 buf[];
 } __packed;
 
 struct wmi_mgmt_rx_event_v2 {
 	struct wmi_mgmt_rx_hdr_v2 hdr;
-	u8 buf[0];
+	u8 buf[];
 } __packed;
 
 struct wmi_10_4_mgmt_rx_hdr {
@@ -3415,7 +3415,7 @@ struct wmi_10_4_mgmt_rx_hdr {
 
 struct wmi_10_4_mgmt_rx_event {
 	struct wmi_10_4_mgmt_rx_hdr hdr;
-	u8 buf[0];
+	u8 buf[];
 } __packed;
 
 struct wmi_mgmt_rx_ext_info {
@@ -3455,14 +3455,14 @@ struct wmi_phyerr {
 	__le32 rssi_chains[4];
 	__le16 nf_chains[4];
 	__le32 buf_len;
-	u8 buf[0];
+	u8 buf[];
 } __packed;
 
 struct wmi_phyerr_event {
 	__le32 num_phyerrs;
 	__le32 tsf_l32;
 	__le32 tsf_u32;
-	struct wmi_phyerr phyerrs[0];
+	struct wmi_phyerr phyerrs[];
 } __packed;
 
 struct wmi_10_4_phyerr_event {
@@ -3479,7 +3479,7 @@ struct wmi_10_4_phyerr_event {
 	__le32 phy_err_mask[2];
 	__le32 tsf_timestamp;
 	__le32 buf_len;
-	u8 buf[0];
+	u8 buf[];
 } __packed;
 
 struct wmi_radar_found_info {
@@ -3592,7 +3592,7 @@ struct wmi_mgmt_tx_hdr {
 
 struct wmi_mgmt_tx_cmd {
 	struct wmi_mgmt_tx_hdr hdr;
-	u8 buf[0];
+	u8 buf[];
 } __packed;
 
 struct wmi_echo_event {
@@ -4628,7 +4628,7 @@ struct wmi_stats_event {
 	 *  By having a zero sized array, the pointer to data area
 	 *  becomes available without increasing the struct size
 	 */
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 struct wmi_10_2_stats_event {
@@ -4638,7 +4638,7 @@ struct wmi_10_2_stats_event {
 	__le32 num_vdev_stats;
 	__le32 num_peer_stats;
 	__le32 num_bcnflt_stats;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 /*
@@ -5033,7 +5033,7 @@ struct wmi_vdev_install_key_cmd {
 	__le32 key_rxmic_len;
 
 	/* contains key followed by tx mic followed by rx mic */
-	u8 key_data[0];
+	u8 key_data[];
 } __packed;
 
 struct wmi_vdev_install_key_arg {
@@ -5703,7 +5703,7 @@ struct wmi_bcn_tx_hdr {
 
 struct wmi_bcn_tx_cmd {
 	struct wmi_bcn_tx_hdr hdr;
-	u8 *bcn[0];
+	u8 *bcn[];
 } __packed;
 
 struct wmi_bcn_tx_arg {
@@ -6120,7 +6120,7 @@ struct wmi_bcn_info {
 
 struct wmi_host_swba_event {
 	__le32 vdev_map;
-	struct wmi_bcn_info bcn_info[0];
+	struct wmi_bcn_info bcn_info[];
 } __packed;
 
 struct wmi_10_2_4_bcn_info {
@@ -6130,7 +6130,7 @@ struct wmi_10_2_4_bcn_info {
 
 struct wmi_10_2_4_host_swba_event {
 	__le32 vdev_map;
-	struct wmi_10_2_4_bcn_info bcn_info[0];
+	struct wmi_10_2_4_bcn_info bcn_info[];
 } __packed;
 
 /* 16 words = 512 client + 1 word = for guard */
@@ -6171,7 +6171,7 @@ struct wmi_10_4_bcn_info {
 
 struct wmi_10_4_host_swba_event {
 	__le32 vdev_map;
-	struct wmi_10_4_bcn_info bcn_info[0];
+	struct wmi_10_4_bcn_info bcn_info[];
 } __packed;
 
 #define WMI_MAX_AP_VDEV 16
-- 
2.26.2


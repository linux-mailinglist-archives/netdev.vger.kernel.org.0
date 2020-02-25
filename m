Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2033C16B77A
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 03:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728725AbgBYCBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 21:01:30 -0500
Received: from gateway23.websitewelcome.com ([192.185.50.129]:15153 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726962AbgBYCB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 21:01:29 -0500
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 7FDED3679
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 20:01:28 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 6PXMjjLdcRP4z6PXMj8S0P; Mon, 24 Feb 2020 20:01:28 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=CAn5pDJV+AMTxsAdNdv7kJ+v+KzqRtAypQ/6vJnaxYE=; b=m/153pWvdVNLv1zr5ddardWVm0
        tuQ0DfFixZxbnmEfvh6CrgntJWM1xsleuJWAvdFXXoqb5CRsf59OJcUFJNM9SLHHkHnYapFPHdt2b
        CSTAdeooKq7voKjhGPr6BxNYrqrTitLzDEtpoz0G/5+fLQ5CEIBm+65Wo6gdWzQTcl8pybFbeeIl9
        AmT5M6TcbBJAf/JWs2+5EitCap4fAI1c1bMPUUYilV1UARxXDfxRQwhw2yOAibN42zLXGS/7BMFZX
        wgfuJyYGzTviXWuBf9F4YQS/Lvd+0xdbiKKzMDiFXWofyW/+0M0tEBcMpZJdDvfj8OiBueVMpCPSz
        /ra9HvKg==;
Received: from [201.166.191.17] (port=60526 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j6PXI-003Ffv-5c; Mon, 24 Feb 2020 20:01:25 -0600
Date:   Mon, 24 Feb 2020 20:04:13 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] wireless: marvell: Replace zero-length array with
 flexible-array member
Message-ID: <20200225020413.GA8057@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 201.166.191.17
X-Source-L: No
X-Exim-ID: 1j6PXI-003Ffv-5c
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [201.166.191.17]:60526
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 8
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
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

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 .../net/wireless/marvell/libertas_tf/if_usb.h |  2 +-
 drivers/net/wireless/marvell/mwifiex/fw.h     | 40 +++++++++----------
 drivers/net/wireless/marvell/mwl8k.c          |  6 +--
 3 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas_tf/if_usb.h b/drivers/net/wireless/marvell/libertas_tf/if_usb.h
index 585ad36f9055..f6dd7373b09e 100644
--- a/drivers/net/wireless/marvell/libertas_tf/if_usb.h
+++ b/drivers/net/wireless/marvell/libertas_tf/if_usb.h
@@ -81,7 +81,7 @@ struct fwheader {
 struct fwdata {
 	struct fwheader hdr;
 	__le32 seqnum;
-	uint8_t data[0];
+	uint8_t data[];
 };
 
 /** fwsyncheader */
diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index 4dfdf928f705..a415d73a73e6 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -846,7 +846,7 @@ struct mwifiex_ie_types_random_mac {
 
 struct mwifiex_ietypes_chanstats {
 	struct mwifiex_ie_types_header header;
-	struct mwifiex_fw_chan_stats chanstats[0];
+	struct mwifiex_fw_chan_stats chanstats[];
 } __packed;
 
 struct mwifiex_ie_types_wildcard_ssid_params {
@@ -1082,7 +1082,7 @@ struct host_cmd_ds_get_hw_spec {
 	__le32 reserved_6;
 	__le32 dot_11ac_dev_cap;
 	__le32 dot_11ac_mcs_support;
-	u8 tlvs[0];
+	u8 tlvs[];
 } __packed;
 
 struct host_cmd_ds_802_11_rssi_info {
@@ -1140,7 +1140,7 @@ struct ieee_types_assoc_rsp {
 	__le16 cap_info_bitmap;
 	__le16 status_code;
 	__le16 a_id;
-	u8 ie_buffer[0];
+	u8 ie_buffer[];
 } __packed;
 
 struct host_cmd_ds_802_11_associate_rsp {
@@ -1455,7 +1455,7 @@ struct host_cmd_ds_chan_rpt_event {
 	__le32 result;
 	__le64 start_tsf;
 	__le32 duration;
-	u8 tlvbuf[0];
+	u8 tlvbuf[];
 } __packed;
 
 struct host_cmd_sdio_sp_rx_aggr_cfg {
@@ -1625,7 +1625,7 @@ struct host_cmd_ds_802_11_bg_scan_config {
 	__le32 reserved2;
 	__le32 report_condition;
 	__le16 reserved3;
-	u8 tlv[0];
+	u8 tlv[];
 } __packed;
 
 struct host_cmd_ds_802_11_bg_scan_query {
@@ -1720,7 +1720,7 @@ struct mwifiex_ie_types_sta_info {
 
 struct host_cmd_ds_sta_list {
 	__le16 sta_count;
-	u8 tlv[0];
+	u8 tlv[];
 } __packed;
 
 struct mwifiex_ie_types_pwr_capability {
@@ -1743,7 +1743,7 @@ struct mwifiex_ie_types_wmm_param_set {
 struct mwifiex_ie_types_mgmt_frame {
 	struct mwifiex_ie_types_header header;
 	__le16 frame_control;
-	u8 frame_contents[0];
+	u8 frame_contents[];
 };
 
 struct mwifiex_ie_types_wmm_queue_status {
@@ -1861,7 +1861,7 @@ struct mwifiex_ie_types_2040bssco {
 
 struct mwifiex_ie_types_extcap {
 	struct mwifiex_ie_types_header header;
-	u8 ext_capab[0];
+	u8 ext_capab[];
 } __packed;
 
 struct host_cmd_ds_mem_access {
@@ -1918,12 +1918,12 @@ struct mwifiex_assoc_event {
 	__le16 frame_control;
 	__le16 cap_info;
 	__le16 listen_interval;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 struct host_cmd_ds_sys_config {
 	__le16 action;
-	u8 tlv[0];
+	u8 tlv[];
 };
 
 struct host_cmd_11ac_vht_cfg {
@@ -1956,7 +1956,7 @@ struct host_cmd_tlv_gwk_cipher {
 
 struct host_cmd_tlv_passphrase {
 	struct mwifiex_ie_types_header header;
-	u8 passphrase[0];
+	u8 passphrase[];
 } __packed;
 
 struct host_cmd_tlv_wep_key {
@@ -1978,12 +1978,12 @@ struct host_cmd_tlv_encrypt_protocol {
 
 struct host_cmd_tlv_ssid {
 	struct mwifiex_ie_types_header header;
-	u8 ssid[0];
+	u8 ssid[];
 } __packed;
 
 struct host_cmd_tlv_rates {
 	struct mwifiex_ie_types_header header;
-	u8 rates[0];
+	u8 rates[];
 } __packed;
 
 struct mwifiex_ie_types_bssid_list {
@@ -2100,13 +2100,13 @@ struct mwifiex_fw_mef_entry {
 	u8 mode;
 	u8 action;
 	__le16 exprsize;
-	u8 expr[0];
+	u8 expr[];
 } __packed;
 
 struct host_cmd_ds_mef_cfg {
 	__le32 criteria;
 	__le16 num_entries;
-	struct mwifiex_fw_mef_entry mef_entry[0];
+	struct mwifiex_fw_mef_entry mef_entry[];
 } __packed;
 
 #define CONNECTION_TYPE_INFRA   0
@@ -2169,7 +2169,7 @@ struct mwifiex_radar_det_event {
 struct mwifiex_ie_types_multi_chan_info {
 	struct mwifiex_ie_types_header header;
 	__le16 status;
-	u8 tlv_buffer[0];
+	u8 tlv_buffer[];
 } __packed;
 
 struct mwifiex_ie_types_mc_group_info {
@@ -2185,7 +2185,7 @@ struct mwifiex_ie_types_mc_group_info {
 		u8 usb_ep_num;
 	} hid_num;
 	u8 intf_num;
-	u8 bss_type_numlist[0];
+	u8 bss_type_numlist[];
 } __packed;
 
 struct meas_rpt_map {
@@ -2250,13 +2250,13 @@ struct coalesce_receive_filt_rule {
 	u8 num_of_fields;
 	u8 pkt_type;
 	__le16 max_coalescing_delay;
-	struct coalesce_filt_field_param params[0];
+	struct coalesce_filt_field_param params[];
 } __packed;
 
 struct host_cmd_ds_coalesce_cfg {
 	__le16 action;
 	__le16 num_of_rules;
-	struct coalesce_receive_filt_rule rule[0];
+	struct coalesce_receive_filt_rule rule[];
 } __packed;
 
 struct host_cmd_ds_multi_chan_policy {
@@ -2295,7 +2295,7 @@ struct host_cmd_ds_pkt_aggr_ctrl {
 
 struct host_cmd_ds_sta_configure {
 	__le16 action;
-	u8 tlv_buffer[0];
+	u8 tlv_buffer[];
 } __packed;
 
 struct host_cmd_ds_command {
diff --git a/drivers/net/wireless/marvell/mwl8k.c b/drivers/net/wireless/marvell/mwl8k.c
index d55f229abeea..47fb4b3ea004 100644
--- a/drivers/net/wireless/marvell/mwl8k.c
+++ b/drivers/net/wireless/marvell/mwl8k.c
@@ -592,7 +592,7 @@ struct mwl8k_cmd_pkt {
 	__u8	seq_num;
 	__u8	macid;
 	__le16	result;
-	char	payload[0];
+	char	payload[];
 } __packed;
 
 /*
@@ -806,7 +806,7 @@ static int mwl8k_load_firmware(struct ieee80211_hw *hw)
 struct mwl8k_dma_data {
 	__le16 fwlen;
 	struct ieee80211_hdr wh;
-	char data[0];
+	char data[];
 } __packed;
 
 /* Routines to add/remove DMA header from skb.  */
@@ -2955,7 +2955,7 @@ mwl8k_cmd_rf_antenna(struct ieee80211_hw *hw, int antenna, int mask)
 struct mwl8k_cmd_set_beacon {
 	struct mwl8k_cmd_pkt header;
 	__le16 beacon_len;
-	__u8 beacon[0];
+	__u8 beacon[];
 };
 
 static int mwl8k_cmd_set_beacon(struct ieee80211_hw *hw,
-- 
2.25.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2831C47B1
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 22:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgEDUIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 16:08:00 -0400
Received: from gateway23.websitewelcome.com ([192.185.49.177]:13077 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726334AbgEDUH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 16:07:59 -0400
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 5603D37F1
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 15:07:58 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id VhNejQQz4EfyqVhNejEOsl; Mon, 04 May 2020 15:07:58 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=QQwjaZedmAfrFU0rWpB+oFfnyoC2Vh8dMVpNEp+/1a8=; b=YvBiONp6QYSQAI1G8z08SM7g/Z
        B1dlFOOIF+orc6+l7/Ci3y/6MAJXtWyEM+aX8APnapsdo/7pjDIgs/wXikNBb4r6j62iTrQJbfJrU
        kPmAp/Xd3Kqd3hIxiLrnOMjZkJfPOxw+3gtGMsXh3Dr5wPi+95QmHtFjJ0HrlsWdTuJW0OLvHPdyV
        3qGUbetw4jTRK/I0JuP75NMN7XUzMRhlvsLQYVIwLXy5klCeJRO4l13ND/MZfSBLgS7I/7N3t28zs
        wdCwdqBUiFIo0noLla95CJrJ4qZLw4/SBUscQrxJ0Bi5DXdH+V6I6eA4ZKUvJMWU7wIxbJ9ykgjhZ
        h3xqyYHQ==;
Received: from [189.207.59.248] (port=58770 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1jVhNd-002HS1-SC; Mon, 04 May 2020 15:07:57 -0500
Date:   Mon, 4 May 2020 15:12:24 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] ath11k: Replace zero-length array with flexible-array
Message-ID: <20200504201224.GA32282@embeddedor>
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
X-Source-IP: 189.207.59.248
X-Source-L: No
X-Exim-ID: 1jVhNd-002HS1-SC
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [189.207.59.248]:58770
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 16
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
 drivers/net/wireless/ath/ath11k/debug.h           | 4 ++--
 drivers/net/wireless/ath/ath11k/debug_htt_stats.h | 8 ++++----
 drivers/net/wireless/ath/ath11k/hal_desc.h        | 4 ++--
 drivers/net/wireless/ath/ath11k/hal_rx.h          | 2 +-
 drivers/net/wireless/ath/ath11k/hw.h              | 2 +-
 drivers/net/wireless/ath/ath11k/wmi.h             | 2 +-
 6 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/debug.h b/drivers/net/wireless/ath/ath11k/debug.h
index 97e7306c506d..c7edf946ff5c 100644
--- a/drivers/net/wireless/ath/ath11k/debug.h
+++ b/drivers/net/wireless/ath/ath11k/debug.h
@@ -67,7 +67,7 @@ struct debug_htt_stats_req {
 	u8 peer_addr[ETH_ALEN];
 	struct completion cmpln;
 	u32 buf_len;
-	u8 buf[0];
+	u8 buf[];
 };
 
 struct ath_pktlog_hdr {
@@ -77,7 +77,7 @@ struct ath_pktlog_hdr {
 	u16 size;
 	u32 timestamp;
 	u32 type_specific_data;
-	u8 payload[0];
+	u8 payload[];
 };
 
 #define ATH11K_HTT_STATS_BUF_SIZE (1024 * 512)
diff --git a/drivers/net/wireless/ath/ath11k/debug_htt_stats.h b/drivers/net/wireless/ath/ath11k/debug_htt_stats.h
index 23a6baa9e95a..682a6ff222bd 100644
--- a/drivers/net/wireless/ath/ath11k/debug_htt_stats.h
+++ b/drivers/net/wireless/ath/ath11k/debug_htt_stats.h
@@ -239,7 +239,7 @@ struct htt_tx_pdev_stats_tx_ppdu_stats_tlv_v {
  */
 struct htt_tx_pdev_stats_tried_mpdu_cnt_hist_tlv_v {
 	u32 hist_bin_size;
-	u32 tried_mpdu_cnt_hist[0]; /* HTT_TX_PDEV_TRIED_MPDU_CNT_HIST */
+	u32 tried_mpdu_cnt_hist[]; /* HTT_TX_PDEV_TRIED_MPDU_CNT_HIST */
 };
 
 /* == SOC ERROR STATS == */
@@ -550,7 +550,7 @@ struct htt_tx_hwq_stats_cmn_tlv {
 struct htt_tx_hwq_difs_latency_stats_tlv_v {
 	u32 hist_intvl;
 	/* histogram of ppdu post to hwsch - > cmd status received */
-	u32 difs_latency_hist[0]; /* HTT_TX_HWQ_MAX_DIFS_LATENCY_BINS */
+	u32 difs_latency_hist[]; /* HTT_TX_HWQ_MAX_DIFS_LATENCY_BINS */
 };
 
 /* NOTE: Variable length TLV, use length spec to infer array size */
@@ -586,7 +586,7 @@ struct htt_tx_hwq_fes_result_stats_tlv_v {
 struct htt_tx_hwq_tried_mpdu_cnt_hist_tlv_v {
 	u32 hist_bin_size;
 	/* Histogram of number of mpdus on tried mpdu */
-	u32 tried_mpdu_cnt_hist[0]; /* HTT_TX_HWQ_TRIED_MPDU_CNT_HIST */
+	u32 tried_mpdu_cnt_hist[]; /* HTT_TX_HWQ_TRIED_MPDU_CNT_HIST */
 };
 
 /* NOTE: Variable length TLV, use length spec to infer array size
@@ -1584,7 +1584,7 @@ struct htt_pdev_stats_twt_session_tlv {
 struct htt_pdev_stats_twt_sessions_tlv {
 	u32 pdev_id;
 	u32 num_sessions;
-	struct htt_pdev_stats_twt_session_tlv twt_session[0];
+	struct htt_pdev_stats_twt_session_tlv twt_session[];
 };
 
 enum htt_rx_reo_resource_sample_id_enum {
diff --git a/drivers/net/wireless/ath/ath11k/hal_desc.h b/drivers/net/wireless/ath/ath11k/hal_desc.h
index 5e200380cca4..a1f747c1c44d 100644
--- a/drivers/net/wireless/ath/ath11k/hal_desc.h
+++ b/drivers/net/wireless/ath/ath11k/hal_desc.h
@@ -477,7 +477,7 @@ enum hal_tlv_tag {
 
 struct hal_tlv_hdr {
 	u32 tl;
-	u8 value[0];
+	u8 value[];
 } __packed;
 
 #define RX_MPDU_DESC_INFO0_MSDU_COUNT		GENMASK(7, 0)
@@ -1972,7 +1972,7 @@ struct hal_rx_reo_queue {
 	u32 processed_total_bytes;
 	u32 info5;
 	u32 rsvd[3];
-	struct hal_rx_reo_queue_ext ext_desc[0];
+	struct hal_rx_reo_queue_ext ext_desc[];
 } __packed;
 
 /* hal_rx_reo_queue
diff --git a/drivers/net/wireless/ath/ath11k/hal_rx.h b/drivers/net/wireless/ath/ath11k/hal_rx.h
index e863e4abfcc1..c436191ae1e8 100644
--- a/drivers/net/wireless/ath/ath11k/hal_rx.h
+++ b/drivers/net/wireless/ath/ath11k/hal_rx.h
@@ -23,7 +23,7 @@ struct hal_rx_wbm_rel_info {
 
 struct hal_rx_mon_status_tlv_hdr {
 	u32 hdr;
-	u8 value[0];
+	u8 value[];
 };
 
 enum hal_rx_su_mu_coding {
diff --git a/drivers/net/wireless/ath/ath11k/hw.h b/drivers/net/wireless/ath/ath11k/hw.h
index 9973477ae373..cdec95644758 100644
--- a/drivers/net/wireless/ath/ath11k/hw.h
+++ b/drivers/net/wireless/ath/ath11k/hw.h
@@ -111,7 +111,7 @@ struct ath11k_hw_params {
 struct ath11k_fw_ie {
 	__le32 id;
 	__le32 len;
-	u8 data[0];
+	u8 data[];
 };
 
 enum ath11k_bd_ie_board_type {
diff --git a/drivers/net/wireless/ath/ath11k/wmi.h b/drivers/net/wireless/ath/ath11k/wmi.h
index 510f9c6bc1d7..717e87db91cb 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.h
+++ b/drivers/net/wireless/ath/ath11k/wmi.h
@@ -39,7 +39,7 @@ struct wmi_cmd_hdr {
 
 struct wmi_tlv {
 	u32 header;
-	u8 value[0];
+	u8 value[];
 } __packed;
 
 #define WMI_TLV_LEN	GENMASK(15, 0)
-- 
2.26.2


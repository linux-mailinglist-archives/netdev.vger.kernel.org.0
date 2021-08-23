Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B03A93F4F61
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 19:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbhHWRTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 13:19:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:50414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229755AbhHWRTe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 13:19:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6ED961501;
        Mon, 23 Aug 2021 17:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629739131;
        bh=sXFez6GCJcIUZP7DNnqylGtMEnOm11ZhHcPII95H6rg=;
        h=Date:From:To:Cc:Subject:From;
        b=KcM68az9xJ3QqQDGOGi8XcXdovAC7wHrbTtBKPeji1izXq1+0xpCvg8MZ231KbKYK
         XQ3E1fbYdVsTlL+Hd1leFAKj2lo90mgEbk0UT3Wb2indGHOlcIKJ6fA+SWQAoVNO0e
         9T2kve/00ustILUHoVFMozWEMSRKw26OSnxWuULf1qnJBUxze1bmWnRVnUT+RGJlt3
         MPETqjS3NbwMKnXhDVy52QbpHJ00mJmlJzzZhOoxRxxRcDMtepK1xPWSaw71v73u7X
         s0MCLiyjHGqel7QpDxZQYCFfNj7q8WWg72hNkZinheYS3ktpv7iTAnYe7OGiRvfvlh
         x40hX50jvUd0A==
Date:   Mon, 23 Aug 2021 12:21:59 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] ath11k: Replace one-element array with flexible-array
 member
Message-ID: <20210823172159.GA25800@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a regular need in the kernel to provide a way to declare having a
dynamically sized set of trailing elements in a structure. Kernel code
should always use "flexible array members"[1] for these cases. The older
style of one-element or zero-length arrays should no longer be used[2].

Refactor the code a bit according to the use of a flexible-array member in
struct scan_chan_list_params instead of a one-element array, and use the
struct_size() helper.

Also, save 25 (too many) bytes that were being allocated:

$ pahole -C channel_param drivers/net/wireless/ath/ath11k/reg.o
struct channel_param {
	u8                         chan_id;              /*     0     1 */
	u8                         pwr;                  /*     1     1 */
	u32                        mhz;                  /*     2     4 */

	/* Bitfield combined with next fields */

	u32                        half_rate:1;          /*     4:16  4 */
	u32                        quarter_rate:1;       /*     4:17  4 */
	u32                        dfs_set:1;            /*     4:18  4 */
	u32                        dfs_set_cfreq2:1;     /*     4:19  4 */
	u32                        is_chan_passive:1;    /*     4:20  4 */
	u32                        allow_ht:1;           /*     4:21  4 */
	u32                        allow_vht:1;          /*     4:22  4 */
	u32                        allow_he:1;           /*     4:23  4 */
	u32                        set_agile:1;          /*     4:24  4 */
	u32                        psc_channel:1;        /*     4:25  4 */

	/* XXX 6 bits hole, try to pack */

	u32                        phy_mode;             /*     8     4 */
	u32                        cfreq1;               /*    12     4 */
	u32                        cfreq2;               /*    16     4 */
	char                       maxpower;             /*    20     1 */
	char                       minpower;             /*    21     1 */
	char                       maxregpower;          /*    22     1 */
	u8                         antennamax;           /*    23     1 */
	u8                         reg_class_id;         /*    24     1 */

	/* size: 25, cachelines: 1, members: 21 */
	/* sum members: 23 */
	/* sum bitfield members: 10 bits, bit holes: 1, sum bit holes: 6 bits */
	/* last cacheline: 25 bytes */
} __attribute__((__packed__));

as previously, sizeof(struct scan_chan_list_params) was 32 bytes:

$ pahole -C scan_chan_list_params drivers/net/wireless/ath/ath11k/reg.o
struct scan_chan_list_params {
	u32                        pdev_id;              /*     0     4 */
	u16                        nallchans;            /*     4     2 */
	struct channel_param       ch_param[1];          /*     6    25 */

	/* size: 32, cachelines: 1, members: 3 */
	/* padding: 1 */
	/* last cacheline: 32 bytes */
};

and now with the flexible array transformation it is just 8 bytes:

$ pahole -C scan_chan_list_params drivers/net/wireless/ath/ath11k/reg.o
struct scan_chan_list_params {
	u32                        pdev_id;              /*     0     4 */
	u16                        nallchans;            /*     4     2 */
	struct channel_param       ch_param[];           /*     6     0 */

	/* size: 8, cachelines: 1, members: 3 */
	/* padding: 2 */
	/* last cacheline: 8 bytes */
};

This helps with the ongoing efforts to globally enable -Warray-bounds and
get us closer to being able to tighten the FORTIFY_SOURCE routines on
memcpy().

This issue was found with the help of Coccinelle and audited and fixed,
manually.

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.10/process/deprecated.html#zero-length-and-one-element-arrays

Link: https://github.com/KSPP/linux/issues/79
Link: https://github.com/KSPP/linux/issues/109
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/ath/ath11k/reg.c | 7 ++-----
 drivers/net/wireless/ath/ath11k/wmi.c | 2 +-
 drivers/net/wireless/ath/ath11k/wmi.h | 2 +-
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/reg.c b/drivers/net/wireless/ath/ath11k/reg.c
index e1a1df169034..c83d265185f1 100644
--- a/drivers/net/wireless/ath/ath11k/reg.c
+++ b/drivers/net/wireless/ath/ath11k/reg.c
@@ -97,7 +97,6 @@ int ath11k_reg_update_chan_list(struct ath11k *ar)
 	struct channel_param *ch;
 	enum nl80211_band band;
 	int num_channels = 0;
-	int params_len;
 	int i, ret;
 
 	bands = hw->wiphy->bands;
@@ -117,10 +116,8 @@ int ath11k_reg_update_chan_list(struct ath11k *ar)
 	if (WARN_ON(!num_channels))
 		return -EINVAL;
 
-	params_len = sizeof(struct scan_chan_list_params) +
-			num_channels * sizeof(struct channel_param);
-	params = kzalloc(params_len, GFP_KERNEL);
-
+	params = kzalloc(struct_size(params, ch_param, num_channels),
+			 GFP_KERNEL);
 	if (!params)
 		return -ENOMEM;
 
diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 6c253eae9d06..0a634ba04509 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -2285,7 +2285,7 @@ int ath11k_wmi_send_scan_chan_list_cmd(struct ath11k *ar,
 	u16 num_send_chans, num_sends = 0, max_chan_limit = 0;
 	u32 *reg1, *reg2;
 
-	tchan_info = &chan_list->ch_param[0];
+	tchan_info = chan_list->ch_param;
 	while (chan_list->nallchans) {
 		len = sizeof(*cmd) + TLV_HDR_SIZE;
 		max_chan_limit = (wmi->wmi_ab->max_msg_len[ar->pdev_idx] - len) /
diff --git a/drivers/net/wireless/ath/ath11k/wmi.h b/drivers/net/wireless/ath/ath11k/wmi.h
index d35c47e0b19d..d9c83726f65d 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.h
+++ b/drivers/net/wireless/ath/ath11k/wmi.h
@@ -3608,7 +3608,7 @@ struct wmi_stop_scan_cmd {
 struct scan_chan_list_params {
 	u32 pdev_id;
 	u16 nallchans;
-	struct channel_param ch_param[1];
+	struct channel_param ch_param[];
 };
 
 struct wmi_scan_chan_list_cmd {
-- 
2.27.0


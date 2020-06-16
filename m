Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492701FC1D7
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 00:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgFPWqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 18:46:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:59280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725941AbgFPWqO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jun 2020 18:46:14 -0400
Received: from embeddedor (unknown [189.207.59.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7327C207E8;
        Tue, 16 Jun 2020 22:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592347573;
        bh=ZAs7GT5Hxz71cY/X1yUf6UmpNbaDaFyhGT9dvQA8WSg=;
        h=Date:From:To:Cc:Subject:From;
        b=tOtTUn6i9JsmvvjEEcLkyE+BYqlTRTvJf4uHci8yqejVU0er62cLvJj2gbUOPAzfJ
         up5vztwPIEe0amz4UFOILuMoruoFTt4kWOB+2IIa/cvjIXlldniAsFFGvq04+wnYVS
         XN6RxJJynwG497vXF3GeNuZyE8Of68agP6gaGGiI=
Date:   Tue, 16 Jun 2020 17:51:32 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] ath10k: wmi: Use struct_size() helper in
 ath10k_wmi_alloc_skb()
Message-ID: <20200616225132.GA19873@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes. Also, remove unnecessary
variable _len_.

This code was detected with the help of Coccinelle and, audited and
fixed manually.

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 32 +++++++--------------------
 1 file changed, 8 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index a81a1ab2de19..b89681394a15 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -6551,7 +6551,7 @@ static struct sk_buff *ath10k_wmi_op_gen_init(struct ath10k *ar)
 	struct wmi_init_cmd *cmd;
 	struct sk_buff *buf;
 	struct wmi_resource_config config = {};
-	u32 len, val;
+	u32 val;
 
 	config.num_vdevs = __cpu_to_le32(TARGET_NUM_VDEVS);
 	config.num_peers = __cpu_to_le32(TARGET_NUM_PEERS);
@@ -6603,10 +6603,7 @@ static struct sk_buff *ath10k_wmi_op_gen_init(struct ath10k *ar)
 	config.num_msdu_desc = __cpu_to_le32(TARGET_NUM_MSDU_DESC);
 	config.max_frag_entries = __cpu_to_le32(TARGET_MAX_FRAG_ENTRIES);
 
-	len = sizeof(*cmd) +
-	      (sizeof(struct host_memory_chunk) * ar->wmi.num_mem_chunks);
-
-	buf = ath10k_wmi_alloc_skb(ar, len);
+	buf = ath10k_wmi_alloc_skb(ar, struct_size(cmd, mem_chunks.items, ar->wmi.num_mem_chunks));
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
 
@@ -6624,7 +6621,7 @@ static struct sk_buff *ath10k_wmi_10_1_op_gen_init(struct ath10k *ar)
 	struct wmi_init_cmd_10x *cmd;
 	struct sk_buff *buf;
 	struct wmi_resource_config_10x config = {};
-	u32 len, val;
+	u32 val;
 
 	config.num_vdevs = __cpu_to_le32(TARGET_10X_NUM_VDEVS);
 	config.num_peers = __cpu_to_le32(TARGET_10X_NUM_PEERS);
@@ -6668,10 +6665,7 @@ static struct sk_buff *ath10k_wmi_10_1_op_gen_init(struct ath10k *ar)
 	config.num_msdu_desc = __cpu_to_le32(TARGET_10X_NUM_MSDU_DESC);
 	config.max_frag_entries = __cpu_to_le32(TARGET_10X_MAX_FRAG_ENTRIES);
 
-	len = sizeof(*cmd) +
-	      (sizeof(struct host_memory_chunk) * ar->wmi.num_mem_chunks);
-
-	buf = ath10k_wmi_alloc_skb(ar, len);
+	buf = ath10k_wmi_alloc_skb(ar, struct_size(cmd, mem_chunks.items, ar->wmi.num_mem_chunks));
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
 
@@ -6689,7 +6683,7 @@ static struct sk_buff *ath10k_wmi_10_2_op_gen_init(struct ath10k *ar)
 	struct wmi_init_cmd_10_2 *cmd;
 	struct sk_buff *buf;
 	struct wmi_resource_config_10x config = {};
-	u32 len, val, features;
+	u32 val, features;
 
 	config.num_vdevs = __cpu_to_le32(TARGET_10X_NUM_VDEVS);
 	config.num_peer_keys = __cpu_to_le32(TARGET_10X_NUM_PEER_KEYS);
@@ -6741,10 +6735,7 @@ static struct sk_buff *ath10k_wmi_10_2_op_gen_init(struct ath10k *ar)
 	config.num_msdu_desc = __cpu_to_le32(TARGET_10X_NUM_MSDU_DESC);
 	config.max_frag_entries = __cpu_to_le32(TARGET_10X_MAX_FRAG_ENTRIES);
 
-	len = sizeof(*cmd) +
-	      (sizeof(struct host_memory_chunk) * ar->wmi.num_mem_chunks);
-
-	buf = ath10k_wmi_alloc_skb(ar, len);
+	buf = ath10k_wmi_alloc_skb(ar, struct_size(cmd, mem_chunks.items, ar->wmi.num_mem_chunks));
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
 
@@ -6776,7 +6767,6 @@ static struct sk_buff *ath10k_wmi_10_4_op_gen_init(struct ath10k *ar)
 	struct wmi_init_cmd_10_4 *cmd;
 	struct sk_buff *buf;
 	struct wmi_resource_config_10_4 config = {};
-	u32 len;
 
 	config.num_vdevs = __cpu_to_le32(ar->max_num_vdevs);
 	config.num_peers = __cpu_to_le32(ar->max_num_peers);
@@ -6838,10 +6828,7 @@ static struct sk_buff *ath10k_wmi_10_4_op_gen_init(struct ath10k *ar)
 	config.iphdr_pad_config = __cpu_to_le32(TARGET_10_4_IPHDR_PAD_CONFIG);
 	config.qwrap_config = __cpu_to_le32(TARGET_10_4_QWRAP_CONFIG);
 
-	len = sizeof(*cmd) +
-	      (sizeof(struct host_memory_chunk) * ar->wmi.num_mem_chunks);
-
-	buf = ath10k_wmi_alloc_skb(ar, len);
+	buf = ath10k_wmi_alloc_skb(ar, struct_size(cmd, mem_chunks.items, ar->wmi.num_mem_chunks));
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
 
@@ -7549,12 +7536,9 @@ ath10k_wmi_op_gen_scan_chan_list(struct ath10k *ar,
 	struct sk_buff *skb;
 	struct wmi_channel_arg *ch;
 	struct wmi_channel *ci;
-	int len;
 	int i;
 
-	len = sizeof(*cmd) + arg->n_channels * sizeof(struct wmi_channel);
-
-	skb = ath10k_wmi_alloc_skb(ar, len);
+	skb = ath10k_wmi_alloc_skb(ar, struct_size(cmd, chan_info, arg->n_channels));
 	if (!skb)
 		return ERR_PTR(-EINVAL);
 
-- 
2.27.0


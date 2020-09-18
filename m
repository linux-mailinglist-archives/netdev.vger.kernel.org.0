Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA1D26F47C
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 05:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgIRCBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:01:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:45656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726361AbgIRCB0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 22:01:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52F2D21707;
        Fri, 18 Sep 2020 02:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394485;
        bh=Fm6jXLSpDYVGejFkqBr0le1Cr0+VQzM/yBzIoueAvII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Whn9GkInu9XWX5D2p5PhRVuMCsSVdAMSsPl8jSviLSWX26C2YrSEpyTLifhLAKu6o
         QylfaY0eto928kXUfmpQva/JvyKjwmFJRAtnn4uurEFjPUu/GJkuAnSZXcfPNJbx3L
         is2aDAv16Ia0h2Y0/41Mi77GRH4rgm9KgQRK645E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miaoqing Pan <miaoqing@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 011/330] ath10k: fix array out-of-bounds access
Date:   Thu, 17 Sep 2020 21:55:51 -0400
Message-Id: <20200918020110.2063155-11-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miaoqing Pan <miaoqing@codeaurora.org>

[ Upstream commit c5329b2d5b8b4e41be14d31ee8505b4f5607bf9b ]

If firmware reports rate_max > WMI_TPC_RATE_MAX(WMI_TPC_FINAL_RATE_MAX)
or num_tx_chain > WMI_TPC_TX_N_CHAIN, it will cause array out-of-bounds
access, so print a warning and reset to avoid memory corruption.

Tested HW: QCA9984
Tested FW: 10.4-3.9.0.2-00035

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/debug.c |  2 +-
 drivers/net/wireless/ath/ath10k/wmi.c   | 49 ++++++++++++++++---------
 2 files changed, 32 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index bd2b5628f850b..40baf25ac99f3 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -1516,7 +1516,7 @@ static void ath10k_tpc_stats_print(struct ath10k_tpc_stats *tpc_stats,
 	*len += scnprintf(buf + *len, buf_len - *len,
 			  "No.  Preamble Rate_code ");
 
-	for (i = 0; i < WMI_TPC_TX_N_CHAIN; i++)
+	for (i = 0; i < tpc_stats->num_tx_chain; i++)
 		*len += scnprintf(buf + *len, buf_len - *len,
 				  "tpc_value%d ", i);
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 90f1197a6ad84..2675174cc4fec 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4668,16 +4668,13 @@ static void ath10k_tpc_config_disp_tables(struct ath10k *ar,
 	}
 
 	pream_idx = 0;
-	for (i = 0; i < __le32_to_cpu(ev->rate_max); i++) {
+	for (i = 0; i < tpc_stats->rate_max; i++) {
 		memset(tpc_value, 0, sizeof(tpc_value));
 		memset(buff, 0, sizeof(buff));
 		if (i == pream_table[pream_idx])
 			pream_idx++;
 
-		for (j = 0; j < WMI_TPC_TX_N_CHAIN; j++) {
-			if (j >= __le32_to_cpu(ev->num_tx_chain))
-				break;
-
+		for (j = 0; j < tpc_stats->num_tx_chain; j++) {
 			tpc[j] = ath10k_tpc_config_get_rate(ar, ev, i, j + 1,
 							    rate_code[i],
 							    type);
@@ -4790,7 +4787,7 @@ void ath10k_wmi_tpc_config_get_rate_code(u8 *rate_code, u16 *pream_table,
 
 void ath10k_wmi_event_pdev_tpc_config(struct ath10k *ar, struct sk_buff *skb)
 {
-	u32 num_tx_chain;
+	u32 num_tx_chain, rate_max;
 	u8 rate_code[WMI_TPC_RATE_MAX];
 	u16 pream_table[WMI_TPC_PREAM_TABLE_MAX];
 	struct wmi_pdev_tpc_config_event *ev;
@@ -4806,6 +4803,13 @@ void ath10k_wmi_event_pdev_tpc_config(struct ath10k *ar, struct sk_buff *skb)
 		return;
 	}
 
+	rate_max = __le32_to_cpu(ev->rate_max);
+	if (rate_max > WMI_TPC_RATE_MAX) {
+		ath10k_warn(ar, "number of rate is %d greater than TPC configured rate %d\n",
+			    rate_max, WMI_TPC_RATE_MAX);
+		rate_max = WMI_TPC_RATE_MAX;
+	}
+
 	tpc_stats = kzalloc(sizeof(*tpc_stats), GFP_ATOMIC);
 	if (!tpc_stats)
 		return;
@@ -4822,8 +4826,8 @@ void ath10k_wmi_event_pdev_tpc_config(struct ath10k *ar, struct sk_buff *skb)
 		__le32_to_cpu(ev->twice_antenna_reduction);
 	tpc_stats->power_limit = __le32_to_cpu(ev->power_limit);
 	tpc_stats->twice_max_rd_power = __le32_to_cpu(ev->twice_max_rd_power);
-	tpc_stats->num_tx_chain = __le32_to_cpu(ev->num_tx_chain);
-	tpc_stats->rate_max = __le32_to_cpu(ev->rate_max);
+	tpc_stats->num_tx_chain = num_tx_chain;
+	tpc_stats->rate_max = rate_max;
 
 	ath10k_tpc_config_disp_tables(ar, ev, tpc_stats,
 				      rate_code, pream_table,
@@ -5018,16 +5022,13 @@ ath10k_wmi_tpc_stats_final_disp_tables(struct ath10k *ar,
 	}
 
 	pream_idx = 0;
-	for (i = 0; i < __le32_to_cpu(ev->rate_max); i++) {
+	for (i = 0; i < tpc_stats->rate_max; i++) {
 		memset(tpc_value, 0, sizeof(tpc_value));
 		memset(buff, 0, sizeof(buff));
 		if (i == pream_table[pream_idx])
 			pream_idx++;
 
-		for (j = 0; j < WMI_TPC_TX_N_CHAIN; j++) {
-			if (j >= __le32_to_cpu(ev->num_tx_chain))
-				break;
-
+		for (j = 0; j < tpc_stats->num_tx_chain; j++) {
 			tpc[j] = ath10k_wmi_tpc_final_get_rate(ar, ev, i, j + 1,
 							       rate_code[i],
 							       type, pream_idx);
@@ -5043,7 +5044,7 @@ ath10k_wmi_tpc_stats_final_disp_tables(struct ath10k *ar,
 
 void ath10k_wmi_event_tpc_final_table(struct ath10k *ar, struct sk_buff *skb)
 {
-	u32 num_tx_chain;
+	u32 num_tx_chain, rate_max;
 	u8 rate_code[WMI_TPC_FINAL_RATE_MAX];
 	u16 pream_table[WMI_TPC_PREAM_TABLE_MAX];
 	struct wmi_pdev_tpc_final_table_event *ev;
@@ -5051,12 +5052,24 @@ void ath10k_wmi_event_tpc_final_table(struct ath10k *ar, struct sk_buff *skb)
 
 	ev = (struct wmi_pdev_tpc_final_table_event *)skb->data;
 
+	num_tx_chain = __le32_to_cpu(ev->num_tx_chain);
+	if (num_tx_chain > WMI_TPC_TX_N_CHAIN) {
+		ath10k_warn(ar, "number of tx chain is %d greater than TPC final configured tx chain %d\n",
+			    num_tx_chain, WMI_TPC_TX_N_CHAIN);
+		return;
+	}
+
+	rate_max = __le32_to_cpu(ev->rate_max);
+	if (rate_max > WMI_TPC_FINAL_RATE_MAX) {
+		ath10k_warn(ar, "number of rate is %d greater than TPC final configured rate %d\n",
+			    rate_max, WMI_TPC_FINAL_RATE_MAX);
+		rate_max = WMI_TPC_FINAL_RATE_MAX;
+	}
+
 	tpc_stats = kzalloc(sizeof(*tpc_stats), GFP_ATOMIC);
 	if (!tpc_stats)
 		return;
 
-	num_tx_chain = __le32_to_cpu(ev->num_tx_chain);
-
 	ath10k_wmi_tpc_config_get_rate_code(rate_code, pream_table,
 					    num_tx_chain);
 
@@ -5069,8 +5082,8 @@ void ath10k_wmi_event_tpc_final_table(struct ath10k *ar, struct sk_buff *skb)
 		__le32_to_cpu(ev->twice_antenna_reduction);
 	tpc_stats->power_limit = __le32_to_cpu(ev->power_limit);
 	tpc_stats->twice_max_rd_power = __le32_to_cpu(ev->twice_max_rd_power);
-	tpc_stats->num_tx_chain = __le32_to_cpu(ev->num_tx_chain);
-	tpc_stats->rate_max = __le32_to_cpu(ev->rate_max);
+	tpc_stats->num_tx_chain = num_tx_chain;
+	tpc_stats->rate_max = rate_max;
 
 	ath10k_wmi_tpc_stats_final_disp_tables(ar, ev, tpc_stats,
 					       rate_code, pream_table,
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A737E5F8F66
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbiJIWIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiJIWIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:08:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED5227CC5;
        Sun,  9 Oct 2022 15:08:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D067B80DC9;
        Sun,  9 Oct 2022 22:08:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D72ABC4347C;
        Sun,  9 Oct 2022 22:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353283;
        bh=SPnS4RxeMss5OWB1xg87Hkm/hyPZcVIEgTqLConj15s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O90VbxmaQN859IIVYpATEBZ7OklilfRbYDj4Jjtgavvl+jukRiSJEnYltDIhF8foO
         6TjmjzOfmuNYSHfgaB7ku/NJj3XcjVb8rc/hIACytD3VO5ooitbhCP01D0903qMgnf
         a2YAdS//yqlH5eEuZSRepffC3e0EQZaYu27VANenMFHegW8Oy3p3PXARzmar+QDUgI
         S6V4R28eRXVEPd2LYxo8mklxenLgqQG/xFuqLKiFRTG/fAsiw73VPa0CUWZRF9yljt
         Ay/6cPvLIROpSK0K7z05QIWoGkL+Huc2nRJNiKnWFD0MJjPmtw1SIrOVw7XE5Dx/m6
         0/b0Nd1nJTivg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Youghandhar Chintala <quic_youghand@quicinc.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 04/77] wifi: ath10k: Set tx credit to one for WCN3990 snoc based devices
Date:   Sun,  9 Oct 2022 18:06:41 -0400
Message-Id: <20221009220754.1214186-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009220754.1214186-1-sashal@kernel.org>
References: <20221009220754.1214186-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Youghandhar Chintala <quic_youghand@quicinc.com>

[ Upstream commit d81bbb684c250a637186d9286d75b1cb04d2986c ]

Currently host can send two WMI commands at once. There is possibility to
cause SMMU issues or corruption, if host wants to initiate 2 DMA
transfers, it is possible when copy complete interrupt for first DMA
reaches host, CE has already updated SRRI (Source ring read index) for
both DMA transfers and is in the middle of 2nd DMA. Host uses SRRI
(Source ring read index) to interpret how many DMA’s have been completed
and tries to unmap/free both the DMA entries. Hence now it is limiting to
one.Because CE is  still in the middle of 2nd DMA which can cause these
issues when handling two DMA transfers.

This change will not impact other targets, as it is only for WCN3990.

Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.2.0-01387-QCAHLSWMTPLZ-1

Signed-off-by: Youghandhar Chintala <quic_youghand@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220801134941.15216-1-quic_youghand@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/core.c | 16 ++++++++++++++++
 drivers/net/wireless/ath/ath10k/htc.c  | 11 ++++++++---
 drivers/net/wireless/ath/ath10k/hw.h   |  2 ++
 3 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 276954b70d63..d1ac64026cb3 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -98,6 +98,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.tx_stats_over_pktlog = true,
 		.dynamic_sar_support = false,
 		.hw_restart_disconnect = false,
+		.use_fw_tx_credits = true,
 	},
 	{
 		.id = QCA988X_HW_2_0_VERSION,
@@ -136,6 +137,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.tx_stats_over_pktlog = true,
 		.dynamic_sar_support = false,
 		.hw_restart_disconnect = false,
+		.use_fw_tx_credits = true,
 	},
 	{
 		.id = QCA9887_HW_1_0_VERSION,
@@ -175,6 +177,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.tx_stats_over_pktlog = false,
 		.dynamic_sar_support = false,
 		.hw_restart_disconnect = false,
+		.use_fw_tx_credits = true,
 	},
 	{
 		.id = QCA6174_HW_3_2_VERSION,
@@ -209,6 +212,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.supports_peer_stats_info = true,
 		.dynamic_sar_support = true,
 		.hw_restart_disconnect = false,
+		.use_fw_tx_credits = true,
 	},
 	{
 		.id = QCA6174_HW_2_1_VERSION,
@@ -247,6 +251,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.tx_stats_over_pktlog = false,
 		.dynamic_sar_support = false,
 		.hw_restart_disconnect = false,
+		.use_fw_tx_credits = true,
 	},
 	{
 		.id = QCA6174_HW_2_1_VERSION,
@@ -285,6 +290,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.tx_stats_over_pktlog = false,
 		.dynamic_sar_support = false,
 		.hw_restart_disconnect = false,
+		.use_fw_tx_credits = true,
 	},
 	{
 		.id = QCA6174_HW_3_0_VERSION,
@@ -323,6 +329,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.tx_stats_over_pktlog = false,
 		.dynamic_sar_support = false,
 		.hw_restart_disconnect = false,
+		.use_fw_tx_credits = true,
 	},
 	{
 		.id = QCA6174_HW_3_2_VERSION,
@@ -365,6 +372,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.supports_peer_stats_info = true,
 		.dynamic_sar_support = true,
 		.hw_restart_disconnect = false,
+		.use_fw_tx_credits = true,
 	},
 	{
 		.id = QCA99X0_HW_2_0_DEV_VERSION,
@@ -409,6 +417,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.tx_stats_over_pktlog = false,
 		.dynamic_sar_support = false,
 		.hw_restart_disconnect = false,
+		.use_fw_tx_credits = true,
 	},
 	{
 		.id = QCA9984_HW_1_0_DEV_VERSION,
@@ -460,6 +469,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.tx_stats_over_pktlog = false,
 		.dynamic_sar_support = false,
 		.hw_restart_disconnect = false,
+		.use_fw_tx_credits = true,
 	},
 	{
 		.id = QCA9888_HW_2_0_DEV_VERSION,
@@ -508,6 +518,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.tx_stats_over_pktlog = false,
 		.dynamic_sar_support = false,
 		.hw_restart_disconnect = false,
+		.use_fw_tx_credits = true,
 	},
 	{
 		.id = QCA9377_HW_1_0_DEV_VERSION,
@@ -546,6 +557,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.tx_stats_over_pktlog = false,
 		.dynamic_sar_support = false,
 		.hw_restart_disconnect = false,
+		.use_fw_tx_credits = true,
 	},
 	{
 		.id = QCA9377_HW_1_1_DEV_VERSION,
@@ -586,6 +598,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.tx_stats_over_pktlog = false,
 		.dynamic_sar_support = false,
 		.hw_restart_disconnect = false,
+		.use_fw_tx_credits = true,
 	},
 	{
 		.id = QCA9377_HW_1_1_DEV_VERSION,
@@ -617,6 +630,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.credit_size_workaround = true,
 		.dynamic_sar_support = false,
 		.hw_restart_disconnect = false,
+		.use_fw_tx_credits = true,
 	},
 	{
 		.id = QCA4019_HW_1_0_DEV_VERSION,
@@ -662,6 +676,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.tx_stats_over_pktlog = false,
 		.dynamic_sar_support = false,
 		.hw_restart_disconnect = false,
+		.use_fw_tx_credits = true,
 	},
 	{
 		.id = WCN3990_HW_1_0_DEV_VERSION,
@@ -693,6 +708,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.tx_stats_over_pktlog = false,
 		.dynamic_sar_support = true,
 		.hw_restart_disconnect = true,
+		.use_fw_tx_credits = false,
 	},
 };
 
diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index fab398046a3f..6d1784f74bea 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -947,13 +947,18 @@ int ath10k_htc_wait_target(struct ath10k_htc *htc)
 		return -ECOMM;
 	}
 
-	htc->total_transmit_credits = __le16_to_cpu(msg->ready.credit_count);
+	if (ar->hw_params.use_fw_tx_credits)
+		htc->total_transmit_credits = __le16_to_cpu(msg->ready.credit_count);
+	else
+		htc->total_transmit_credits = 1;
+
 	htc->target_credit_size = __le16_to_cpu(msg->ready.credit_size);
 
 	ath10k_dbg(ar, ATH10K_DBG_HTC,
-		   "Target ready! transmit resources: %d size:%d\n",
+		   "Target ready! transmit resources: %d size:%d actual credits:%d\n",
 		   htc->total_transmit_credits,
-		   htc->target_credit_size);
+		   htc->target_credit_size,
+		   msg->ready.credit_count);
 
 	if ((htc->total_transmit_credits == 0) ||
 	    (htc->target_credit_size == 0)) {
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 93acf0dd580a..1b99f3a39a11 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -635,6 +635,8 @@ struct ath10k_hw_params {
 	bool dynamic_sar_support;
 
 	bool hw_restart_disconnect;
+
+	bool use_fw_tx_credits;
 };
 
 struct htt_resp;
-- 
2.35.1


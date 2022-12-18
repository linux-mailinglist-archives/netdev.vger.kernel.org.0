Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBCD6500FB
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 17:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbiLRQXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 11:23:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbiLRQWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 11:22:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D8913D68;
        Sun, 18 Dec 2022 08:09:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D035F60C58;
        Sun, 18 Dec 2022 16:08:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65D5C433EF;
        Sun, 18 Dec 2022 16:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379702;
        bh=lYeqhZTVdxlXHUF1Ro3QXXxj16GCd6F402Y0YWB+ewA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NZ8iUBxzaaPe9/zx1D7uViQM5/68HD6JrYPQLLpDq6ceTRWhngrRtO8isK1YewXw8
         nYe/lEsqvxBTyrsBVhZxFtKpMbJble4iKN43k6Ft/uAqNERVpts5V1/55NQuaO3WoC
         P2501SgC+A8w+ID79fbyXVfOMeoBpyDbBBUwbIQduFkY5lUIczJpxinJ0r0b8mle7H
         JfPsBDUYCHlml6iCV93PFflMmTL9hQXgsvn1+eEdwrLKL+k+x3129dKfv+eecriaDG
         oicvbIDYa6YEE58PUK84y80j3tmu57MN/3humvnmJ3FhqIV/YIyShfpb8Ut847Vmco
         M0wE9WjjQM36Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Youghandhar Chintala <quic_youghand@quicinc.com>,
        Douglas Anderson <dianders@chromium.org>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 09/73] wifi: ath10k: Delay the unmapping of the buffer
Date:   Sun, 18 Dec 2022 11:06:37 -0500
Message-Id: <20221218160741.927862-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160741.927862-1-sashal@kernel.org>
References: <20221218160741.927862-1-sashal@kernel.org>
MIME-Version: 1.0
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

[ Upstream commit acd4324e5f1f11351630234297f95076f0ac9a2f ]

On WCN3990, we are seeing a rare scenario where copy engine hardware is
sending a copy complete interrupt to the host driver while still
processing the buffer that the driver has sent, this is leading into an
SMMU fault triggering kernel panic. This is happening on copy engine
channel 3 (CE3) where the driver normally enqueues WMI commands to the
firmware. Upon receiving a copy complete interrupt, host driver will
immediately unmap and frees the buffer presuming that hardware has
processed the buffer. In the issue case, upon receiving copy complete
interrupt, host driver will unmap and free the buffer but since hardware
is still accessing the buffer (which in this case got unmapped in
parallel), SMMU hardware will trigger an SMMU fault resulting in a
kernel panic.

In order to avoid this, as a work around, add a delay before unmapping
the copy engine source DMA buffer. This is conditionally done for
WCN3990 and only for the CE3 channel where issue is seen.

Below is the crash signature:

wifi smmu error: kernel: [ 10.120965] arm-smmu 15000000.iommu: Unhandled
context fault: fsr=0x402, iova=0x7fdfd8ac0,
fsynr=0x500003,cbfrsynra=0xc1, cb=6 arm-smmu 15000000.iommu: Unhandled
context fault:fsr=0x402, iova=0x7fe06fdc0, fsynr=0x710003,
cbfrsynra=0xc1, cb=6 qcom-q6v5-mss 4080000.remoteproc: fatal error
received: err_qdi.c:1040:EF:wlan_process:0x1:WLAN RT:0x2091:
cmnos_thread.c:3998:Asserted in copy_engine.c:AXI_ERROR_DETECTED:2149
remoteproc remoteproc0: crash detected in
4080000.remoteproc: type fatal error <3> remoteproc remoteproc0:
handling crash #1 in 4080000.remoteproc

pc : __arm_lpae_unmap+0x500/0x514
lr : __arm_lpae_unmap+0x4bc/0x514
sp : ffffffc011ffb530
x29: ffffffc011ffb590 x28: 0000000000000000
x27: 0000000000000000 x26: 0000000000000004
x25: 0000000000000003 x24: ffffffc011ffb890
x23: ffffffa762ef9be0 x22: ffffffa77244ef00
x21: 0000000000000009 x20: 00000007fff7c000
x19: 0000000000000003 x18: 0000000000000000
x17: 0000000000000004 x16: ffffffd7a357d9f0
x15: 0000000000000000 x14: 00fd5d4fa7ffffff
x13: 000000000000000e x12: 0000000000000000
x11: 00000000ffffffff x10: 00000000fffffe00
x9 : 000000000000017c x8 : 000000000000000c
x7 : 0000000000000000 x6 : ffffffa762ef9000
x5 : 0000000000000003 x4 : 0000000000000004
x3 : 0000000000001000 x2 : 00000007fff7c000
x1 : ffffffc011ffb890 x0 : 0000000000000000 Call trace:
__arm_lpae_unmap+0x500/0x514
__arm_lpae_unmap+0x4bc/0x514
__arm_lpae_unmap+0x4bc/0x514
arm_lpae_unmap_pages+0x78/0xa4
arm_smmu_unmap_pages+0x78/0x104
__iommu_unmap+0xc8/0x1e4
iommu_unmap_fast+0x38/0x48
__iommu_dma_unmap+0x84/0x104
iommu_dma_free+0x34/0x50
dma_free_attrs+0xa4/0xd0
ath10k_htt_rx_free+0xc4/0xf4 [ath10k_core] ath10k_core_stop+0x64/0x7c
[ath10k_core]
ath10k_halt+0x11c/0x180 [ath10k_core]
ath10k_stop+0x54/0x94 [ath10k_core]
drv_stop+0x48/0x1c8 [mac80211]
ieee80211_do_open+0x638/0x77c [mac80211] ieee80211_open+0x48/0x5c
[mac80211]
__dev_open+0xb4/0x174
__dev_change_flags+0xc4/0x1dc
dev_change_flags+0x3c/0x7c
devinet_ioctl+0x2b4/0x580
inet_ioctl+0xb0/0x1b4
sock_do_ioctl+0x4c/0x16c
compat_ifreq_ioctl+0x1cc/0x35c
compat_sock_ioctl+0x110/0x2ac
__arm64_compat_sys_ioctl+0xf4/0x3e0
el0_svc_common+0xb4/0x17c
el0_svc_compat_handler+0x2c/0x58
el0_svc_compat+0x8/0x2c

Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.2.0-01387-QCAHLSWMTPLZ-1

Tested-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Youghandhar Chintala <quic_youghand@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20221012142733.32420-1-quic_youghand@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/core.c | 16 ++++++++++++++++
 drivers/net/wireless/ath/ath10k/htc.c  |  9 +++++++++
 drivers/net/wireless/ath/ath10k/hw.h   |  2 ++
 3 files changed, 27 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index d1ac64026cb3..9a8ea7231a9e 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -99,6 +99,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.dynamic_sar_support = false,
 		.hw_restart_disconnect = false,
 		.use_fw_tx_credits = true,
+		.delay_unmap_buffer = false,
 	},
 	{
 		.id = QCA988X_HW_2_0_VERSION,
@@ -138,6 +139,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.dynamic_sar_support = false,
 		.hw_restart_disconnect = false,
 		.use_fw_tx_credits = true,
+		.delay_unmap_buffer = false,
 	},
 	{
 		.id = QCA9887_HW_1_0_VERSION,
@@ -178,6 +180,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.dynamic_sar_support = false,
 		.hw_restart_disconnect = false,
 		.use_fw_tx_credits = true,
+		.delay_unmap_buffer = false,
 	},
 	{
 		.id = QCA6174_HW_3_2_VERSION,
@@ -213,6 +216,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.dynamic_sar_support = true,
 		.hw_restart_disconnect = false,
 		.use_fw_tx_credits = true,
+		.delay_unmap_buffer = false,
 	},
 	{
 		.id = QCA6174_HW_2_1_VERSION,
@@ -252,6 +256,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.dynamic_sar_support = false,
 		.hw_restart_disconnect = false,
 		.use_fw_tx_credits = true,
+		.delay_unmap_buffer = false,
 	},
 	{
 		.id = QCA6174_HW_2_1_VERSION,
@@ -291,6 +296,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.dynamic_sar_support = false,
 		.hw_restart_disconnect = false,
 		.use_fw_tx_credits = true,
+		.delay_unmap_buffer = false,
 	},
 	{
 		.id = QCA6174_HW_3_0_VERSION,
@@ -330,6 +336,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.dynamic_sar_support = false,
 		.hw_restart_disconnect = false,
 		.use_fw_tx_credits = true,
+		.delay_unmap_buffer = false,
 	},
 	{
 		.id = QCA6174_HW_3_2_VERSION,
@@ -373,6 +380,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.dynamic_sar_support = true,
 		.hw_restart_disconnect = false,
 		.use_fw_tx_credits = true,
+		.delay_unmap_buffer = false,
 	},
 	{
 		.id = QCA99X0_HW_2_0_DEV_VERSION,
@@ -418,6 +426,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.dynamic_sar_support = false,
 		.hw_restart_disconnect = false,
 		.use_fw_tx_credits = true,
+		.delay_unmap_buffer = false,
 	},
 	{
 		.id = QCA9984_HW_1_0_DEV_VERSION,
@@ -470,6 +479,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.dynamic_sar_support = false,
 		.hw_restart_disconnect = false,
 		.use_fw_tx_credits = true,
+		.delay_unmap_buffer = false,
 	},
 	{
 		.id = QCA9888_HW_2_0_DEV_VERSION,
@@ -519,6 +529,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.dynamic_sar_support = false,
 		.hw_restart_disconnect = false,
 		.use_fw_tx_credits = true,
+		.delay_unmap_buffer = false,
 	},
 	{
 		.id = QCA9377_HW_1_0_DEV_VERSION,
@@ -558,6 +569,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.dynamic_sar_support = false,
 		.hw_restart_disconnect = false,
 		.use_fw_tx_credits = true,
+		.delay_unmap_buffer = false,
 	},
 	{
 		.id = QCA9377_HW_1_1_DEV_VERSION,
@@ -599,6 +611,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.dynamic_sar_support = false,
 		.hw_restart_disconnect = false,
 		.use_fw_tx_credits = true,
+		.delay_unmap_buffer = false,
 	},
 	{
 		.id = QCA9377_HW_1_1_DEV_VERSION,
@@ -631,6 +644,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.dynamic_sar_support = false,
 		.hw_restart_disconnect = false,
 		.use_fw_tx_credits = true,
+		.delay_unmap_buffer = false,
 	},
 	{
 		.id = QCA4019_HW_1_0_DEV_VERSION,
@@ -677,6 +691,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.dynamic_sar_support = false,
 		.hw_restart_disconnect = false,
 		.use_fw_tx_credits = true,
+		.delay_unmap_buffer = false,
 	},
 	{
 		.id = WCN3990_HW_1_0_DEV_VERSION,
@@ -709,6 +724,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.dynamic_sar_support = true,
 		.hw_restart_disconnect = true,
 		.use_fw_tx_credits = false,
+		.delay_unmap_buffer = true,
 	},
 };
 
diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 6d1784f74bea..5bfeecb95fca 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -56,6 +56,15 @@ void ath10k_htc_notify_tx_completion(struct ath10k_htc_ep *ep,
 	ath10k_dbg(ar, ATH10K_DBG_HTC, "%s: ep %d skb %pK\n", __func__,
 		   ep->eid, skb);
 
+	/* A corner case where the copy completion is reaching to host but still
+	 * copy engine is processing it due to which host unmaps corresponding
+	 * memory and causes SMMU fault, hence as workaround adding delay
+	 * the unmapping memory to avoid SMMU faults.
+	 */
+	if (ar->hw_params.delay_unmap_buffer &&
+	    ep->ul_pipe_id == 3)
+		mdelay(2);
+
 	hdr = (struct ath10k_htc_hdr *)skb->data;
 	ath10k_htc_restore_tx_skb(ep->htc, skb);
 
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 1b99f3a39a11..9643031a4427 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -637,6 +637,8 @@ struct ath10k_hw_params {
 	bool hw_restart_disconnect;
 
 	bool use_fw_tx_credits;
+
+	bool delay_unmap_buffer;
 };
 
 struct htt_resp;
-- 
2.35.1


Return-Path: <netdev+bounces-343-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8337D6F7353
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 21:42:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D1E7F1C21370
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 19:42:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9DD1EEA1;
	Thu,  4 May 2023 19:41:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57804F4EF
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 19:41:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75EE4C433A8;
	Thu,  4 May 2023 19:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683229309;
	bh=0WiwHMcHXif2lDlvSZTXjjkYOySdSwVPXH3cTPH205Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YhJFDH2MQ0ztb/F6AvVN4boUaf+kuaIavh9WxBpsdvXSLvzOQMA4yc81vk9Ctd4IW
	 nDp/GgfAa+ri8gdMBkTqeXtUxJUJE/oKdKRGFxCdR7S9RmlfXpAueaxqTLvaXCiOXd
	 mCVaEgo0i7XSLr/ZzCQi/HOof6OJJeqmqB2X3ov68jy6W30TAJ51R4iDAlhmiZXBW9
	 ux2aUzKRet/tWBSwo/NTvdVS8FlZZsc0a58tM2WUFxiIb0KYaUuYKEBiRttaW4b4/1
	 gfAyH+SdEVwffIib2s4QnpmuiUZeizwmoYwsEvelX3D40TfWRk/qIhJKrIpAHKAxNx
	 FjEyvPf4udnTg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Ramya Gnanasekar <quic_rgnanase@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>,
	kvalo@kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.3 03/59] wifi: ath12k: PCI ops for wakeup/release MHI
Date: Thu,  4 May 2023 15:40:46 -0400
Message-Id: <20230504194142.3805425-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230504194142.3805425-1-sashal@kernel.org>
References: <20230504194142.3805425-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ramya Gnanasekar <quic_rgnanase@quicinc.com>

[ Upstream commit 80e396586d0a94c42015dd9472176d89a3b0e4ca ]

Wakeup/release MHI is not needed before pci_read/write for QCN9274.
Since wakeup & release MHI is enabled for all QCN9274 and
WCN7850, below MHI assert is seen in QCN9274

[  784.906613] BUG: sleeping function called from invalid context at drivers/bus/mhi/host/pm.c:989
[  784.906633] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 0, name: swapper/3
[  784.906637] preempt_count: 503, expected: 0
[  784.906641] RCU nest depth: 0, expected: 0
[  784.906644] 2 locks held by swapper/3/0:
[  784.906646]  #0: ffff8ed348e429e0 (&ab->ce.ce_lock){+.-.}-{2:2}, at: ath12k_ce_recv_process_cb+0xb3/0x2f0 [ath12k]
[  784.906664]  #1: ffff8ed348e491f0 (&srng->lock_key#3){+.-.}-{2:2}, at: ath12k_ce_recv_process_cb+0xfb/0x2f0 [ath12k]
[  784.906678] Preemption disabled at:
[  784.906680] [<0000000000000000>] 0x0
[  784.906686] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G        W  O       6.1.0-rc2+ #3
[  784.906688] Hardware name: Intel(R) Client Systems NUC8i7HVK/NUC8i7HVB, BIOS HNKBLi70.86A.0056.2019.0506.1527 05/06/2019
[  784.906690] Call Trace:
[  784.906691]  <IRQ>
[  784.906693]  dump_stack_lvl+0x56/0x7b
[  784.906698]  __might_resched+0x21c/0x270
[  784.906704]  __mhi_device_get_sync+0x7d/0x1c0 [mhi]
[  784.906714]  mhi_device_get_sync+0xd/0x20 [mhi]
[  784.906719]  ath12k_pci_write32+0x75/0x170 [ath12k]
[  784.906729]  ath12k_hal_srng_access_end+0x55/0xc0 [ath12k]
[  784.906737]  ath12k_ce_recv_process_cb+0x1f3/0x2f0 [ath12k]
[  784.906776]  ? ath12k_pci_ce_tasklet+0x11/0x30 [ath12k]
[  784.906788]  ath12k_pci_ce_tasklet+0x11/0x30 [ath12k]
[  784.906813]  tasklet_action_common.isra.18+0xb7/0xe0
[  784.906820]  __do_softirq+0xd0/0x4c9
[  784.906826]  irq_exit_rcu+0x88/0xe0
[  784.906828]  common_interrupt+0xa5/0xc0
[  784.906831]  </IRQ>
[  784.906832]  <TASK>

Adding function callbacks for MHI wakeup and release operations.
QCN9274 does not need wakeup/release, function callbacks are initialized
to NULL. In case of WCN7850, shadow registers are used to access rings.
Since, shadow register's offset is less than ACCESS_ALWAYS_OFF,
mhi_device_get_sync() or mhi_device_put() to wakeup
and release mhi will not be called during service ring accesses.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.0-03171-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0-03427-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.15378.4

Signed-off-by: Ramya Gnanasekar <quic_rgnanase@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20230123095141.5310-1-quic_rgnanase@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/pci.c | 47 ++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath12k/pci.h |  6 ++++
 2 files changed, 44 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
index ae7f6083c9fc2..d32637b0113db 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -119,6 +119,30 @@ static const char *irq_name[ATH12K_IRQ_NUM_MAX] = {
 	"tcl2host-status-ring",
 };
 
+static int ath12k_pci_bus_wake_up(struct ath12k_base *ab)
+{
+	struct ath12k_pci *ab_pci = ath12k_pci_priv(ab);
+
+	return mhi_device_get_sync(ab_pci->mhi_ctrl->mhi_dev);
+}
+
+static void ath12k_pci_bus_release(struct ath12k_base *ab)
+{
+	struct ath12k_pci *ab_pci = ath12k_pci_priv(ab);
+
+	mhi_device_put(ab_pci->mhi_ctrl->mhi_dev);
+}
+
+static const struct ath12k_pci_ops ath12k_pci_ops_qcn9274 = {
+	.wakeup = NULL,
+	.release = NULL,
+};
+
+static const struct ath12k_pci_ops ath12k_pci_ops_wcn7850 = {
+	.wakeup = ath12k_pci_bus_wake_up,
+	.release = ath12k_pci_bus_release,
+};
+
 static void ath12k_pci_select_window(struct ath12k_pci *ab_pci, u32 offset)
 {
 	struct ath12k_base *ab = ab_pci->ab;
@@ -989,13 +1013,14 @@ u32 ath12k_pci_read32(struct ath12k_base *ab, u32 offset)
 {
 	struct ath12k_pci *ab_pci = ath12k_pci_priv(ab);
 	u32 val, window_start;
+	int ret = 0;
 
 	/* for offset beyond BAR + 4K - 32, may
 	 * need to wakeup MHI to access.
 	 */
 	if (test_bit(ATH12K_PCI_FLAG_INIT_DONE, &ab_pci->flags) &&
-	    offset >= ACCESS_ALWAYS_OFF)
-		mhi_device_get_sync(ab_pci->mhi_ctrl->mhi_dev);
+	    offset >= ACCESS_ALWAYS_OFF && ab_pci->pci_ops->wakeup)
+		ret = ab_pci->pci_ops->wakeup(ab);
 
 	if (offset < WINDOW_START) {
 		val = ioread32(ab->mem + offset);
@@ -1023,9 +1048,9 @@ u32 ath12k_pci_read32(struct ath12k_base *ab, u32 offset)
 	}
 
 	if (test_bit(ATH12K_PCI_FLAG_INIT_DONE, &ab_pci->flags) &&
-	    offset >= ACCESS_ALWAYS_OFF)
-		mhi_device_put(ab_pci->mhi_ctrl->mhi_dev);
-
+	    offset >= ACCESS_ALWAYS_OFF && ab_pci->pci_ops->release &&
+	    !ret)
+		ab_pci->pci_ops->release(ab);
 	return val;
 }
 
@@ -1033,13 +1058,14 @@ void ath12k_pci_write32(struct ath12k_base *ab, u32 offset, u32 value)
 {
 	struct ath12k_pci *ab_pci = ath12k_pci_priv(ab);
 	u32 window_start;
+	int ret = 0;
 
 	/* for offset beyond BAR + 4K - 32, may
 	 * need to wakeup MHI to access.
 	 */
 	if (test_bit(ATH12K_PCI_FLAG_INIT_DONE, &ab_pci->flags) &&
-	    offset >= ACCESS_ALWAYS_OFF)
-		mhi_device_get_sync(ab_pci->mhi_ctrl->mhi_dev);
+	    offset >= ACCESS_ALWAYS_OFF && ab_pci->pci_ops->wakeup)
+		ret = ab_pci->pci_ops->wakeup(ab);
 
 	if (offset < WINDOW_START) {
 		iowrite32(value, ab->mem + offset);
@@ -1067,8 +1093,9 @@ void ath12k_pci_write32(struct ath12k_base *ab, u32 offset, u32 value)
 	}
 
 	if (test_bit(ATH12K_PCI_FLAG_INIT_DONE, &ab_pci->flags) &&
-	    offset >= ACCESS_ALWAYS_OFF)
-		mhi_device_put(ab_pci->mhi_ctrl->mhi_dev);
+	    offset >= ACCESS_ALWAYS_OFF && ab_pci->pci_ops->release &&
+	    !ret)
+		ab_pci->pci_ops->release(ab);
 }
 
 int ath12k_pci_power_up(struct ath12k_base *ab)
@@ -1182,6 +1209,7 @@ static int ath12k_pci_probe(struct pci_dev *pdev,
 	case QCN9274_DEVICE_ID:
 		ab_pci->msi_config = &ath12k_msi_config[0];
 		ab->static_window_map = true;
+		ab_pci->pci_ops = &ath12k_pci_ops_qcn9274;
 		ath12k_pci_read_hw_version(ab, &soc_hw_version_major,
 					   &soc_hw_version_minor);
 		switch (soc_hw_version_major) {
@@ -1202,6 +1230,7 @@ static int ath12k_pci_probe(struct pci_dev *pdev,
 		ab_pci->msi_config = &ath12k_msi_config[0];
 		ab->static_window_map = false;
 		ab->hw_rev = ATH12K_HW_WCN7850_HW20;
+		ab_pci->pci_ops = &ath12k_pci_ops_wcn7850;
 		break;
 
 	default:
diff --git a/drivers/net/wireless/ath/ath12k/pci.h b/drivers/net/wireless/ath/ath12k/pci.h
index 0d9e40ab31f26..0f24fd9395cd9 100644
--- a/drivers/net/wireless/ath/ath12k/pci.h
+++ b/drivers/net/wireless/ath/ath12k/pci.h
@@ -86,6 +86,11 @@ enum ath12k_pci_flags {
 	ATH12K_PCI_ASPM_RESTORE,
 };
 
+struct ath12k_pci_ops {
+	int (*wakeup)(struct ath12k_base *ab);
+	void (*release)(struct ath12k_base *ab);
+};
+
 struct ath12k_pci {
 	struct pci_dev *pdev;
 	struct ath12k_base *ab;
@@ -103,6 +108,7 @@ struct ath12k_pci {
 	/* enum ath12k_pci_flags */
 	unsigned long flags;
 	u16 link_ctl;
+	const struct ath12k_pci_ops *pci_ops;
 };
 
 static inline struct ath12k_pci *ath12k_pci_priv(struct ath12k_base *ab)
-- 
2.39.2



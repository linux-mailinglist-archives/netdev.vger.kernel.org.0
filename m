Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3F46537DC4
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 15:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237825AbiE3NmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 09:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238010AbiE3Nkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 09:40:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BC0C87A17;
        Mon, 30 May 2022 06:31:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF1F9B80DAF;
        Mon, 30 May 2022 13:31:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B4BDC36AF2;
        Mon, 30 May 2022 13:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917505;
        bh=bGvWXSsVYE8QDR2oEurh5TCb6bubWjqxrbK4wgMkhpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cvD/j7JhCYpHHj7BSQk0Ic2MVpOYyjyqvysbyxq1xut7Qz6wO2BSVQbPCLsMKOUQm
         vr49ywiXiBypELPV1yfCfUnvGi2XB4UFlV+pKof0uWSr6jGaHrWw05XmMh2O6BmZu2
         bKZoUccoS0YYH3NbzpXx9KK6IAsC+FDI4EFdkWL/ggkKlbr2aB60hjAjQiI9KttMT8
         lxkCvgNIlAg43Dzn88i3TlxnXLKjAFDcKGUMlfmP1J07M4Z/UQxBXrquWYP2VGfPS2
         HualXeMfGZhZcJGmL3YSeR33e3G2kx1/SY4r2RTrj7cWcsalGbITQ9MLGuR5DP8xjn
         gjn5e+Mz238jw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wen Gong <quic_wgong@quicinc.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 003/135] ath11k: fix the warning of dev_wake in mhi_pm_disable_transition()
Date:   Mon, 30 May 2022 09:29:21 -0400
Message-Id: <20220530133133.1931716-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133133.1931716-1-sashal@kernel.org>
References: <20220530133133.1931716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wen Gong <quic_wgong@quicinc.com>

[ Upstream commit 0d7a8a6204ea9271f1d0a8c66a9fd2f54d2e3cbc ]

When test device recovery with below command, it has warning in message
as below.
echo assert > /sys/kernel/debug/ath11k/wcn6855\ hw2.0/simulate_fw_crash
echo assert > /sys/kernel/debug/ath11k/qca6390\ hw2.0/simulate_fw_crash

warning message:
[ 1965.642121] ath11k_pci 0000:06:00.0: simulating firmware assert crash
[ 1968.471364] ieee80211 phy0: Hardware restart was requested
[ 1968.511305] ------------[ cut here ]------------
[ 1968.511368] WARNING: CPU: 3 PID: 1546 at drivers/bus/mhi/core/pm.c:505 mhi_pm_disable_transition+0xb37/0xda0 [mhi]
[ 1968.511443] Modules linked in: ath11k_pci ath11k mac80211 libarc4 cfg80211 qmi_helpers qrtr_mhi mhi qrtr nvme nvme_core
[ 1968.511563] CPU: 3 PID: 1546 Comm: kworker/u17:0 Kdump: loaded Tainted: G        W         5.17.0-rc3-wt-ath+ #579
[ 1968.511629] Hardware name: Intel(R) Client Systems NUC8i7HVK/NUC8i7HVB, BIOS HNKBLi70.86A.0067.2021.0528.1339 05/28/2021
[ 1968.511704] Workqueue: mhi_hiprio_wq mhi_pm_st_worker [mhi]
[ 1968.511787] RIP: 0010:mhi_pm_disable_transition+0xb37/0xda0 [mhi]
[ 1968.511870] Code: a9 fe ff ff 4c 89 ff 44 89 04 24 e8 03 46 f6 e5 44 8b 04 24 41 83 f8 01 0f 84 21 fe ff ff e9 4c fd ff ff 0f 0b e9 af f8 ff ff <0f> 0b e9 5c f8 ff ff 48 89 df e8 da 9e ee e3 e9 12 fd ff ff 4c 89
[ 1968.511923] RSP: 0018:ffffc900024efbf0 EFLAGS: 00010286
[ 1968.511969] RAX: 00000000ffffffff RBX: ffff88811d241250 RCX: ffffffffc0176922
[ 1968.512014] RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffff888118a90a24
[ 1968.512059] RBP: ffff888118a90800 R08: 0000000000000000 R09: ffff888118a90a27
[ 1968.512102] R10: ffffed1023152144 R11: 0000000000000001 R12: ffff888118a908ac
[ 1968.512229] R13: ffff888118a90928 R14: dffffc0000000000 R15: ffff888118a90a24
[ 1968.512310] FS:  0000000000000000(0000) GS:ffff888234200000(0000) knlGS:0000000000000000
[ 1968.512405] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1968.512493] CR2: 00007f5538f443a8 CR3: 000000016dc28001 CR4: 00000000003706e0
[ 1968.512587] Call Trace:
[ 1968.512672]  <TASK>
[ 1968.512751]  ? _raw_spin_unlock_irq+0x1f/0x40
[ 1968.512859]  mhi_pm_st_worker+0x3ac/0x790 [mhi]
[ 1968.512959]  ? mhi_pm_mission_mode_transition.isra.0+0x7d0/0x7d0 [mhi]
[ 1968.513063]  process_one_work+0x86a/0x1400
[ 1968.513184]  ? pwq_dec_nr_in_flight+0x230/0x230
[ 1968.513312]  ? move_linked_works+0x125/0x290
[ 1968.513416]  worker_thread+0x6db/0xf60
[ 1968.513536]  ? process_one_work+0x1400/0x1400
[ 1968.513627]  kthread+0x241/0x2d0
[ 1968.513733]  ? kthread_complete_and_exit+0x20/0x20
[ 1968.513821]  ret_from_fork+0x22/0x30
[ 1968.513924]  </TASK>

Reason is mhi_deassert_dev_wake() from mhi_device_put() is called
but mhi_assert_dev_wake() from __mhi_device_get_sync() is not called
in progress of recovery. Commit 8e0559921f9a ("bus: mhi: core:
Skip device wake in error or shutdown state") add check for the
pm_state of mhi in __mhi_device_get_sync(), and the pm_state is not
the normal state untill recovery is completed, so it leads the
dev_wake is not 0 and above warning print in mhi_pm_disable_transition()
while checking mhi_cntrl->dev_wake.

Add check in ath11k_pci_write32()/ath11k_pci_read32() to skip call
mhi_device_put() if mhi_device_get_sync() does not really do wake,
then the warning gone.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03003-QCAHSPSWPL_V1_V2_SILICONZ_LITE-2

Signed-off-by: Wen Gong <quic_wgong@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220228064606.8981-5-quic_wgong@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/pci.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
index 903758751c99..8a3ff12057e8 100644
--- a/drivers/net/wireless/ath/ath11k/pci.c
+++ b/drivers/net/wireless/ath/ath11k/pci.c
@@ -191,6 +191,7 @@ void ath11k_pci_write32(struct ath11k_base *ab, u32 offset, u32 value)
 {
 	struct ath11k_pci *ab_pci = ath11k_pci_priv(ab);
 	u32 window_start;
+	int ret = 0;
 
 	/* for offset beyond BAR + 4K - 32, may
 	 * need to wakeup MHI to access.
@@ -198,7 +199,7 @@ void ath11k_pci_write32(struct ath11k_base *ab, u32 offset, u32 value)
 	if (ab->hw_params.wakeup_mhi &&
 	    test_bit(ATH11K_PCI_FLAG_INIT_DONE, &ab_pci->flags) &&
 	    offset >= ACCESS_ALWAYS_OFF)
-		mhi_device_get_sync(ab_pci->mhi_ctrl->mhi_dev);
+		ret = mhi_device_get_sync(ab_pci->mhi_ctrl->mhi_dev);
 
 	if (offset < WINDOW_START) {
 		iowrite32(value, ab->mem  + offset);
@@ -222,7 +223,8 @@ void ath11k_pci_write32(struct ath11k_base *ab, u32 offset, u32 value)
 
 	if (ab->hw_params.wakeup_mhi &&
 	    test_bit(ATH11K_PCI_FLAG_INIT_DONE, &ab_pci->flags) &&
-	    offset >= ACCESS_ALWAYS_OFF)
+	    offset >= ACCESS_ALWAYS_OFF &&
+	    !ret)
 		mhi_device_put(ab_pci->mhi_ctrl->mhi_dev);
 }
 
@@ -230,6 +232,7 @@ u32 ath11k_pci_read32(struct ath11k_base *ab, u32 offset)
 {
 	struct ath11k_pci *ab_pci = ath11k_pci_priv(ab);
 	u32 val, window_start;
+	int ret = 0;
 
 	/* for offset beyond BAR + 4K - 32, may
 	 * need to wakeup MHI to access.
@@ -237,7 +240,7 @@ u32 ath11k_pci_read32(struct ath11k_base *ab, u32 offset)
 	if (ab->hw_params.wakeup_mhi &&
 	    test_bit(ATH11K_PCI_FLAG_INIT_DONE, &ab_pci->flags) &&
 	    offset >= ACCESS_ALWAYS_OFF)
-		mhi_device_get_sync(ab_pci->mhi_ctrl->mhi_dev);
+		ret = mhi_device_get_sync(ab_pci->mhi_ctrl->mhi_dev);
 
 	if (offset < WINDOW_START) {
 		val = ioread32(ab->mem + offset);
@@ -261,7 +264,8 @@ u32 ath11k_pci_read32(struct ath11k_base *ab, u32 offset)
 
 	if (ab->hw_params.wakeup_mhi &&
 	    test_bit(ATH11K_PCI_FLAG_INIT_DONE, &ab_pci->flags) &&
-	    offset >= ACCESS_ALWAYS_OFF)
+	    offset >= ACCESS_ALWAYS_OFF &&
+	    !ret)
 		mhi_device_put(ab_pci->mhi_ctrl->mhi_dev);
 
 	return val;
-- 
2.35.1


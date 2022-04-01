Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0D74EF001
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 16:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346977AbiDAOax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344589AbiDAOaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:30:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC04D286F54;
        Fri,  1 Apr 2022 07:27:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F060B82402;
        Fri,  1 Apr 2022 14:27:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A63C2BBE4;
        Fri,  1 Apr 2022 14:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823242;
        bh=tq/PAZijDm0q/Bd+wL1jqCgN0US56waVpWInoUjZvT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dtsqrKZBqZMSSkj6yVcnVweAkBEYTRPhmWhfUr92Kgmk2xS4Z8VZ6kyAplawefGIy
         AOV7DQc6JBv6dlFg2y4PNYMrXlhNdxRxsEYWG9+y/6iqU72b7ULUzx541O/7JMAeS4
         ahVkw4SbjJI2cGS98yJmIspl+hXcnEHvZDQ5oGID4FwvjnzpVMDc2O8G9Pk8LAbA5O
         wESWG/fYQQCm+k7C4tUMXew/Wz5nKah3zQi2we3HcQ08OCov9uuZaHbGtLgNWCaj39
         S/kSnLIA8ycUZvGXIsMGejeItSLXp8TKyERzVOUNKOIE227FKeJGiOWp1rJ1zkhcib
         3HKQ5Dto8yTOw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kalle Valo <quic_kvalo@quicinc.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 030/149] ath11k: pci: fix crash on suspend if board file is not found
Date:   Fri,  1 Apr 2022 10:23:37 -0400
Message-Id: <20220401142536.1948161-30-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kalle Valo <quic_kvalo@quicinc.com>

[ Upstream commit b4f4c56459a5c744f7f066b9fc2b54ea995030c5 ]

Mario reported that the kernel was crashing on suspend if ath11k was not able
to find a board file:

[  473.693286] PM: Suspending system (s2idle)
[  473.693291] printk: Suspending console(s) (use no_console_suspend to debug)
[  474.407787] BUG: unable to handle page fault for address: 0000000000002070
[  474.407791] #PF: supervisor read access in kernel mode
[  474.407794] #PF: error_code(0x0000) - not-present page
[  474.407798] PGD 0 P4D 0
[  474.407801] Oops: 0000 [#1] PREEMPT SMP NOPTI
[  474.407805] CPU: 2 PID: 2350 Comm: kworker/u32:14 Tainted: G        W         5.16.0 #248
[...]
[  474.407868] Call Trace:
[  474.407870]  <TASK>
[  474.407874]  ? _raw_spin_lock_irqsave+0x2a/0x60
[  474.407882]  ? lock_timer_base+0x72/0xa0
[  474.407889]  ? _raw_spin_unlock_irqrestore+0x29/0x3d
[  474.407892]  ? try_to_del_timer_sync+0x54/0x80
[  474.407896]  ath11k_dp_rx_pktlog_stop+0x49/0xc0 [ath11k]
[  474.407912]  ath11k_core_suspend+0x34/0x130 [ath11k]
[  474.407923]  ath11k_pci_pm_suspend+0x1b/0x50 [ath11k_pci]
[  474.407928]  pci_pm_suspend+0x7e/0x170
[  474.407935]  ? pci_pm_freeze+0xc0/0xc0
[  474.407939]  dpm_run_callback+0x4e/0x150
[  474.407947]  __device_suspend+0x148/0x4c0
[  474.407951]  async_suspend+0x20/0x90
dmesg-efi-164255130401001:
Oops#1 Part1
[  474.407955]  async_run_entry_fn+0x33/0x120
[  474.407959]  process_one_work+0x220/0x3f0
[  474.407966]  worker_thread+0x4a/0x3d0
[  474.407971]  kthread+0x17a/0x1a0
[  474.407975]  ? process_one_work+0x3f0/0x3f0
[  474.407979]  ? set_kthread_struct+0x40/0x40
[  474.407983]  ret_from_fork+0x22/0x30
[  474.407991]  </TASK>

The issue here is that board file loading happens after ath11k_pci_probe()
succesfully returns (ath11k initialisation happends asynchronously) and the
suspend handler is still enabled, of course failing as ath11k is not properly
initialised. Fix this by checking ATH11K_FLAG_QMI_FAIL during both suspend and
resume.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03003-QCAHSPSWPL_V1_V2_SILICONZ_LITE-2

Reported-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215504
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220127090117.2024-1-kvalo@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/pci.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
index de71ad594f34..903758751c99 100644
--- a/drivers/net/wireless/ath/ath11k/pci.c
+++ b/drivers/net/wireless/ath/ath11k/pci.c
@@ -1571,6 +1571,11 @@ static __maybe_unused int ath11k_pci_pm_suspend(struct device *dev)
 	struct ath11k_base *ab = dev_get_drvdata(dev);
 	int ret;
 
+	if (test_bit(ATH11K_FLAG_QMI_FAIL, &ab->dev_flags)) {
+		ath11k_dbg(ab, ATH11K_DBG_BOOT, "boot skipping pci suspend as qmi is not initialised\n");
+		return 0;
+	}
+
 	ret = ath11k_core_suspend(ab);
 	if (ret)
 		ath11k_warn(ab, "failed to suspend core: %d\n", ret);
@@ -1583,6 +1588,11 @@ static __maybe_unused int ath11k_pci_pm_resume(struct device *dev)
 	struct ath11k_base *ab = dev_get_drvdata(dev);
 	int ret;
 
+	if (test_bit(ATH11K_FLAG_QMI_FAIL, &ab->dev_flags)) {
+		ath11k_dbg(ab, ATH11K_DBG_BOOT, "boot skipping pci resume as qmi is not initialised\n");
+		return 0;
+	}
+
 	ret = ath11k_core_resume(ab);
 	if (ret)
 		ath11k_warn(ab, "failed to resume core: %d\n", ret);
-- 
2.34.1


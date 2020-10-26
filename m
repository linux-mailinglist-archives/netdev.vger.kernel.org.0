Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E5F29A1CD
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 01:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409218AbgJ0AoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 20:44:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409250AbgJZXu7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 19:50:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C032F2075B;
        Mon, 26 Oct 2020 23:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756258;
        bh=b9o6+lZL8gfNLxIwtWILYcPmPQdEBOBYmr2zCQFqWzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J7TbgjCdKJ9Gcj9nCd//e+xdiz1OgtO4CkoJrqMt0yIAsd3v+vwGiUjLEKfKM4aOT
         nT0GvGn4SMoQd+cxlB68kVCMYCg/j98+c3AOw89uGNTvt4Oct6/vJwsITkMCOc0+28
         F5bFu/ji18nh6Hgr6WJsiQFhARV6gNKo88Iz2sfU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Carl Huang <cjhuang@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 092/147] ath11k: fix warning caused by lockdep_assert_held
Date:   Mon, 26 Oct 2020 19:48:10 -0400
Message-Id: <20201026234905.1022767-92-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026234905.1022767-1-sashal@kernel.org>
References: <20201026234905.1022767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Carl Huang <cjhuang@codeaurora.org>

[ Upstream commit 2f588660e34a982377109872757f1b99d7748d21 ]

Fix warning caused by lockdep_assert_held when CONFIG_LOCKDEP is enabled.

[  271.940647] WARNING: CPU: 6 PID: 0 at drivers/net/wireless/ath/ath11k/hal.c:818 ath11k_hal_srng_access_begin+0x31/0x40 [ath11k]
[  271.940655] Modules linked in: qrtr_mhi qrtr ns ath11k_pci mhi ath11k qmi_helpers nvme nvme_core
[  271.940675] CPU: 6 PID: 0 Comm: swapper/6 Kdump: loaded Tainted: G        W         5.9.0-rc5-kalle-bringup-wt-ath+ #4
[  271.940682] Hardware name: Dell Inc. Inspiron 7590/08717F, BIOS 1.3.0 07/22/2019
[  271.940698] RIP: 0010:ath11k_hal_srng_access_begin+0x31/0x40 [ath11k]
[  271.940708] Code: 48 89 f3 85 c0 75 11 48 8b 83 a8 00 00 00 8b 00 89 83 b0 00 00 00 5b c3 48 8d 7e 58 be ff ff ff ff e8 53 24 ec fa 85 c0 75 dd <0f> 0b eb d9 90 66 2e 0f 1f 84 00 00 00 00 00 55 53 48 89 f3 8b 35
[  271.940718] RSP: 0018:ffffbdf0c0230df8 EFLAGS: 00010246
[  271.940727] RAX: 0000000000000000 RBX: ffffa12b34e67680 RCX: ffffa12b57a0d800
[  271.940735] RDX: 0000000000000000 RSI: 00000000ffffffff RDI: ffffa12b34e676d8
[  271.940742] RBP: ffffa12b34e60000 R08: 0000000000000001 R09: 0000000000000001
[  271.940753] R10: 0000000000000001 R11: 0000000000000046 R12: 0000000000000000
[  271.940763] R13: ffffa12b34e60000 R14: ffffa12b34e60000 R15: 0000000000000000
[  271.940774] FS:  0000000000000000(0000) GS:ffffa12b5a400000(0000) knlGS:0000000000000000
[  271.940788] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  271.940798] CR2: 00007f8bef282008 CR3: 00000001f4224004 CR4: 00000000003706e0
[  271.940805] Call Trace:
[  271.940813]  <IRQ>
[  271.940835]  ath11k_dp_tx_completion_handler+0x9e/0x950 [ath11k]
[  271.940847]  ? lock_acquire+0xba/0x3b0
[  271.940876]  ath11k_dp_service_srng+0x5a/0x2e0 [ath11k]
[  271.940893]  ath11k_pci_ext_grp_napi_poll+0x1e/0x80 [ath11k_pci]
[  271.940908]  net_rx_action+0x283/0x4f0
[  271.940931]  __do_softirq+0xcb/0x499
[  271.940950]  asm_call_on_stack+0x12/0x20
[  271.940963]  </IRQ>
[  271.940979]  do_softirq_own_stack+0x4d/0x60
[  271.940991]  irq_exit_rcu+0xb0/0xc0
[  271.941001]  common_interrupt+0xce/0x190
[  271.941014]  asm_common_interrupt+0x1e/0x40
[  271.941026] RIP: 0010:cpuidle_enter_state+0x115/0x500

Tested-on: QCA6390 hw2.0 PCI WLAN.HST.1.0.1-01740-QCAHSTSWPLZ_V2_TO_X86-1

Signed-off-by: Carl Huang <cjhuang@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1601463073-12106-5-git-send-email-kvalo@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp_tx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/dp_tx.c b/drivers/net/wireless/ath/ath11k/dp_tx.c
index 1af76775b1a87..99cff8fb39773 100644
--- a/drivers/net/wireless/ath/ath11k/dp_tx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_tx.c
@@ -514,6 +514,8 @@ void ath11k_dp_tx_completion_handler(struct ath11k_base *ab, int ring_id)
 	u32 msdu_id;
 	u8 mac_id;
 
+	spin_lock_bh(&status_ring->lock);
+
 	ath11k_hal_srng_access_begin(ab, status_ring);
 
 	while ((ATH11K_TX_COMPL_NEXT(tx_ring->tx_status_head) !=
@@ -533,6 +535,8 @@ void ath11k_dp_tx_completion_handler(struct ath11k_base *ab, int ring_id)
 
 	ath11k_hal_srng_access_end(ab, status_ring);
 
+	spin_unlock_bh(&status_ring->lock);
+
 	while (ATH11K_TX_COMPL_NEXT(tx_ring->tx_status_tail) != tx_ring->tx_status_head) {
 		struct hal_wbm_release_ring *tx_status;
 		u32 desc_id;
-- 
2.25.1


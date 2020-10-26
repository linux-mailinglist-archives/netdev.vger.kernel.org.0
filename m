Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E36829A1C3
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 01:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502392AbgJ0Anx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 20:43:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:50946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409103AbgJZXu5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 19:50:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D21E20773;
        Mon, 26 Oct 2020 23:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756257;
        bh=AiNIZxeGHWcTBuqcSjOE9j9u3H+LmbHkFa9ml/EBgYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iFyVzpbQLtvdD4E5ilPrhJbjNV9VaDNhxo1MXbmN2qT73MGjjlBsJzeFykuIiEcoZ
         hHC8AyheuZzduAylo/vGRr9Ad0t2ISn3Ik4JGz9+DTtV3gwfdQo+Z7lxn5psEFiFYI
         a+r11GPWH27fMgSynUUcnRFxdA6NSKFlNyzUSbZg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wen Gong <wgong@codeaurora.org>, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 091/147] ath11k: Use GFP_ATOMIC instead of GFP_KERNEL in ath11k_dp_htt_get_ppdu_desc
Date:   Mon, 26 Oct 2020 19:48:09 -0400
Message-Id: <20201026234905.1022767-91-sashal@kernel.org>
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

From: Wen Gong <wgong@codeaurora.org>

[ Upstream commit 6a8be1baa9116a038cb4f6158cc10134387ca0d0 ]

With SLUB DEBUG CONFIG below crash is seen as kmem_cache_alloc
is being called in non-atomic context.

To fix this issue, use GFP_ATOMIC instead of GFP_KERNEL kzalloc.

[  357.217088] BUG: sleeping function called from invalid context at mm/slab.h:498
[  357.217091] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 0, name: swapper/0
[  357.217092] INFO: lockdep is turned off.
[  357.217095] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W         5.9.0-rc5-wt-ath+ #196
[  357.217096] Hardware name: Intel(R) Client Systems NUC8i7HVK/NUC8i7HVB, BIOS HNKBLi70.86A.0049.2018.0801.1601 08/01/2018
[  357.217097] Call Trace:
[  357.217098]  <IRQ>
[  357.217107]  ? ath11k_dp_htt_get_ppdu_desc+0xa9/0x170 [ath11k]
[  357.217110]  dump_stack+0x77/0xa0
[  357.217113]  ___might_sleep.cold+0xa6/0xb6
[  357.217116]  kmem_cache_alloc_trace+0x1f2/0x270
[  357.217122]  ath11k_dp_htt_get_ppdu_desc+0xa9/0x170 [ath11k]
[  357.217129]  ath11k_htt_pull_ppdu_stats.isra.0+0x96/0x270 [ath11k]
[  357.217135]  ath11k_dp_htt_htc_t2h_msg_handler+0xe7/0x1d0 [ath11k]
[  357.217137]  ? trace_hardirqs_on+0x1c/0x100
[  357.217143]  ath11k_htc_rx_completion_handler+0x207/0x370 [ath11k]
[  357.217149]  ath11k_ce_recv_process_cb+0x15e/0x1e0 [ath11k]
[  357.217151]  ? handle_irq_event+0x70/0xa8
[  357.217154]  ath11k_pci_ce_tasklet+0x10/0x30 [ath11k_pci]
[  357.217157]  tasklet_action_common.constprop.0+0xd4/0xf0
[  357.217160]  __do_softirq+0xc9/0x482
[  357.217162]  asm_call_on_stack+0x12/0x20
[  357.217163]  </IRQ>
[  357.217166]  do_softirq_own_stack+0x49/0x60
[  357.217167]  irq_exit_rcu+0x9a/0xd0
[  357.217169]  common_interrupt+0xa1/0x190
[  357.217171]  asm_common_interrupt+0x1e/0x40
[  357.217173] RIP: 0010:cpu_idle_poll.isra.0+0x2e/0x60
[  357.217175] Code: 8b 35 26 27 74 69 e8 11 c8 3d ff e8 bc fa 42 ff e8 e7 9f 4a ff fb 65 48 8b 1c 25 80 90 01 00 48 8b 03 a8 08 74 0b eb 1c f3 90 <48> 8b 03 a8 08 75 13 8b 0
[  357.217177] RSP: 0018:ffffffff97403ee0 EFLAGS: 00000202
[  357.217178] RAX: 0000000000000001 RBX: ffffffff9742b8c0 RCX: 0000000000b890ca
[  357.217180] RDX: 0000000000b890ca RSI: 0000000000000001 RDI: ffffffff968d0c49
[  357.217181] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000001
[  357.217182] R10: ffffffff9742b8c0 R11: 0000000000000046 R12: 0000000000000000
[  357.217183] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000066fdf520
[  357.217186]  ? cpu_idle_poll.isra.0+0x19/0x60
[  357.217189]  do_idle+0x5f/0xe0
[  357.217191]  cpu_startup_entry+0x14/0x20
[  357.217193]  start_kernel+0x443/0x464
[  357.217196]  secondary_startup_64+0xa4/0xb0

Tested-on: QCA6390 hw2.0 PCI WLAN.HST.1.0.1-01740-QCAHSTSWPLZ_V2_TO_X86-1

Signed-off-by: Wen Gong <wgong@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1601399736-3210-8-git-send-email-kvalo@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 791d971784ce0..055c3bb61e4c5 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -1421,7 +1421,7 @@ struct htt_ppdu_stats_info *ath11k_dp_htt_get_ppdu_desc(struct ath11k *ar,
 	}
 	spin_unlock_bh(&ar->data_lock);
 
-	ppdu_info = kzalloc(sizeof(*ppdu_info), GFP_KERNEL);
+	ppdu_info = kzalloc(sizeof(*ppdu_info), GFP_ATOMIC);
 	if (!ppdu_info)
 		return NULL;
 
-- 
2.25.1


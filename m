Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8D34EF643
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 17:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349361AbiDAPcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 11:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349161AbiDAOxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:53:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 832E12B51A1;
        Fri,  1 Apr 2022 07:42:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1356060A3C;
        Fri,  1 Apr 2022 14:42:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ED74C34112;
        Fri,  1 Apr 2022 14:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824159;
        bh=aN1qM77wmJjzxBeg0zePnA10frPcAbO5h7VfCiWBCMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CvCa9ocAaQq/485HtTSnqry4FqQoRk0Ktz4iE+UBLXt+2K8yJu5NgBeKPs7d6LNdQ
         zi+qH/UBqwL7i5+Atk/GwebpndFF1n1p3CjNSBLawjSIOD0bl8va1+6Fpwgn5INAFx
         U1zDR6MB8J33BbWU1cOLy9aU59m1iujkqWKRyCLHY5IHzdr2MpuGdgO351i8vpypqv
         0/JEZe0Zlz9drBVoUnEltLrrEumyGoG3HFp5G6RlWaeEr0hAdNeuSjxmyJVOe653tG
         J0ePN3KvyizWQg39xENj2j50vjSPM/Exom1koSOinbeJ+L1fMXedtCMk7E7nhY3UrX
         WWM88y5CE9Lvg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 10/65] ath11k: mhi: use mhi_sync_power_up()
Date:   Fri,  1 Apr 2022 10:41:11 -0400
Message-Id: <20220401144206.1953700-10-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144206.1953700-1-sashal@kernel.org>
References: <20220401144206.1953700-1-sashal@kernel.org>
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

[ Upstream commit 3df6d74aedfdca919cca475d15dfdbc8b05c9e5d ]

If amss.bin was missing ath11k would crash during 'rmmod ath11k_pci'. The
reason for that was that we were using mhi_async_power_up() which does not
check any errors. But mhi_sync_power_up() on the other hand does check for
errors so let's use that to fix the crash.

I was not able to find a reason why an async version was used.
ath11k_mhi_start() (which enables state ATH11K_MHI_POWER_ON) is called from
ath11k_hif_power_up(), which can sleep. So sync version should be safe to use
here.

[  145.569731] general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC KASAN PTI
[  145.569789] KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
[  145.569843] CPU: 2 PID: 1628 Comm: rmmod Kdump: loaded Tainted: G        W         5.16.0-wt-ath+ #567
[  145.569898] Hardware name: Intel(R) Client Systems NUC8i7HVK/NUC8i7HVB, BIOS HNKBLi70.86A.0067.2021.0528.1339 05/28/2021
[  145.569956] RIP: 0010:ath11k_hal_srng_access_begin+0xb5/0x2b0 [ath11k]
[  145.570028] Code: df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 ec 01 00 00 48 8b ab a8 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 ea 48 c1 ea 03 <0f> b6 14 02 48 89 e8 83 e0 07 83 c0 03 45 85 ed 75 48 38 d0 7c 08
[  145.570089] RSP: 0018:ffffc900025d7ac0 EFLAGS: 00010246
[  145.570144] RAX: dffffc0000000000 RBX: ffff88814fca2dd8 RCX: 1ffffffff50cb455
[  145.570196] RDX: 0000000000000000 RSI: ffff88814fca2dd8 RDI: ffff88814fca2e80
[  145.570252] RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffffa8659497
[  145.570329] R10: fffffbfff50cb292 R11: 0000000000000001 R12: ffff88814fca0000
[  145.570410] R13: 0000000000000000 R14: ffff88814fca2798 R15: ffff88814fca2dd8
[  145.570465] FS:  00007fa399988540(0000) GS:ffff888233e00000(0000) knlGS:0000000000000000
[  145.570519] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  145.570571] CR2: 00007fa399b51421 CR3: 0000000137898002 CR4: 00000000003706e0
[  145.570623] Call Trace:
[  145.570675]  <TASK>
[  145.570727]  ? ath11k_ce_tx_process_cb+0x34b/0x860 [ath11k]
[  145.570797]  ath11k_ce_tx_process_cb+0x356/0x860 [ath11k]
[  145.570864]  ? tasklet_init+0x150/0x150
[  145.570919]  ? ath11k_ce_alloc_pipes+0x280/0x280 [ath11k]
[  145.570986]  ? tasklet_clear_sched+0x42/0xe0
[  145.571042]  ? tasklet_kill+0xe9/0x1b0
[  145.571095]  ? tasklet_clear_sched+0xe0/0xe0
[  145.571148]  ? irq_has_action+0x120/0x120
[  145.571202]  ath11k_ce_cleanup_pipes+0x45a/0x580 [ath11k]
[  145.571270]  ? ath11k_pci_stop+0x10e/0x170 [ath11k_pci]
[  145.571345]  ath11k_core_stop+0x8a/0xc0 [ath11k]
[  145.571434]  ath11k_core_deinit+0x9e/0x150 [ath11k]
[  145.571499]  ath11k_pci_remove+0xd2/0x260 [ath11k_pci]
[  145.571553]  pci_device_remove+0x9a/0x1c0
[  145.571605]  __device_release_driver+0x332/0x660
[  145.571659]  driver_detach+0x1e7/0x2c0
[  145.571712]  bus_remove_driver+0xe2/0x2d0
[  145.571772]  pci_unregister_driver+0x21/0x250
[  145.571826]  __do_sys_delete_module+0x30a/0x4b0
[  145.571879]  ? free_module+0xac0/0xac0
[  145.571933]  ? lockdep_hardirqs_on_prepare.part.0+0x18c/0x370
[  145.571986]  ? syscall_enter_from_user_mode+0x1d/0x50
[  145.572039]  ? lockdep_hardirqs_on+0x79/0x100
[  145.572097]  do_syscall_64+0x3b/0x90
[  145.572153]  entry_SYSCALL_64_after_hwframe+0x44/0xae

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-03003-QCAHSPSWPL_V1_V2_SILICONZ_LITE-2

Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220127090117.2024-2-kvalo@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mhi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/mhi.c b/drivers/net/wireless/ath/ath11k/mhi.c
index aded9a719d51..84db9e55c3e7 100644
--- a/drivers/net/wireless/ath/ath11k/mhi.c
+++ b/drivers/net/wireless/ath/ath11k/mhi.c
@@ -402,7 +402,7 @@ static int ath11k_mhi_set_state(struct ath11k_pci *ab_pci,
 		ret = 0;
 		break;
 	case ATH11K_MHI_POWER_ON:
-		ret = mhi_async_power_up(ab_pci->mhi_ctrl);
+		ret = mhi_sync_power_up(ab_pci->mhi_ctrl);
 		break;
 	case ATH11K_MHI_POWER_OFF:
 		mhi_power_down(ab_pci->mhi_ctrl, true);
-- 
2.34.1


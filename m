Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 382A9491567
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343911AbiARC1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:27:55 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38308 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245483AbiARCZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:25:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D30E6B81244;
        Tue, 18 Jan 2022 02:25:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C278C36AEF;
        Tue, 18 Jan 2022 02:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472747;
        bh=HRXudv1LX55jdNmLURQuWoLwq0VgBqKlNiBl0L6rbbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lJ8X2kAxMTYvtxlRq0YqIuD4oUGxrFLspgaue4vLoohHtfd/gQERRGKuNyOxxOMP2
         ziH6SV7CCt+wcRAeIO+NJwAXNJyAawlUuOPscnOqRfXXyhxme/fo6eODaycO9b6yyw
         Wqz3blQMOl93r0ivBKOeDR73Rze/BDgfeD5jUUIXpNLaczsRQKoyPnabvX1Nwl8KgV
         celuUgtsSjAUVO03VpZ/C1KFDSS8m+W1tLr6Em4tv0CxgifTacZiiJhZ+ffYaWBQbs
         h+IuZMl5a6R6G33mGboAd4UknIWNv37Et1f+Z6J1vkwtsw62aHebPUfrD4UDH0fjBD
         FLZAiGK7P0hUw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Baochen Qiang <quic_bqiang@quicinc.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 120/217] ath11k: Avoid false DEADLOCK warning reported by lockdep
Date:   Mon, 17 Jan 2022 21:18:03 -0500
Message-Id: <20220118021940.1942199-120-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit 767c94caf0efad136157110787fe221b74cb5c8a ]

With CONFIG_LOCKDEP=y and CONFIG_DEBUG_SPINLOCK=y, lockdep reports
below warning:

[  166.059415] ============================================
[  166.059416] WARNING: possible recursive locking detected
[  166.059418] 5.15.0-wt-ath+ #10 Tainted: G        W  O
[  166.059420] --------------------------------------------
[  166.059421] kworker/0:2/116 is trying to acquire lock:
[  166.059423] ffff9905f2083160 (&srng->lock){+.-.}-{2:2}, at: ath11k_hal_reo_cmd_send+0x20/0x490 [ath11k]
[  166.059440]
               but task is already holding lock:
[  166.059442] ffff9905f2083230 (&srng->lock){+.-.}-{2:2}, at: ath11k_dp_process_reo_status+0x95/0x2d0 [ath11k]
[  166.059491]
               other info that might help us debug this:
[  166.059492]  Possible unsafe locking scenario:

[  166.059493]        CPU0
[  166.059494]        ----
[  166.059495]   lock(&srng->lock);
[  166.059498]   lock(&srng->lock);
[  166.059500]
                *** DEADLOCK ***

[  166.059501]  May be due to missing lock nesting notation

[  166.059502] 3 locks held by kworker/0:2/116:
[  166.059504]  #0: ffff9905c0081548 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x1f6/0x660
[  166.059511]  #1: ffff9d2400a5fe68 ((debug_obj_work).work){+.+.}-{0:0}, at: process_one_work+0x1f6/0x660
[  166.059517]  #2: ffff9905f2083230 (&srng->lock){+.-.}-{2:2}, at: ath11k_dp_process_reo_status+0x95/0x2d0 [ath11k]
[  166.059532]
               stack backtrace:
[  166.059534] CPU: 0 PID: 116 Comm: kworker/0:2 Kdump: loaded Tainted: G        W  O      5.15.0-wt-ath+ #10
[  166.059537] Hardware name: Intel(R) Client Systems NUC8i7HVK/NUC8i7HVB, BIOS HNKBLi70.86A.0059.2019.1112.1124 11/12/2019
[  166.059539] Workqueue: events free_obj_work
[  166.059543] Call Trace:
[  166.059545]  <IRQ>
[  166.059547]  dump_stack_lvl+0x56/0x7b
[  166.059552]  __lock_acquire+0xb9a/0x1a50
[  166.059556]  lock_acquire+0x1e2/0x330
[  166.059560]  ? ath11k_hal_reo_cmd_send+0x20/0x490 [ath11k]
[  166.059571]  _raw_spin_lock_bh+0x33/0x70
[  166.059574]  ? ath11k_hal_reo_cmd_send+0x20/0x490 [ath11k]
[  166.059584]  ath11k_hal_reo_cmd_send+0x20/0x490 [ath11k]
[  166.059594]  ath11k_dp_tx_send_reo_cmd+0x3f/0x130 [ath11k]
[  166.059605]  ath11k_dp_rx_tid_del_func+0x221/0x370 [ath11k]
[  166.059618]  ath11k_dp_process_reo_status+0x22f/0x2d0 [ath11k]
[  166.059632]  ? ath11k_dp_service_srng+0x2ea/0x2f0 [ath11k]
[  166.059643]  ath11k_dp_service_srng+0x2ea/0x2f0 [ath11k]
[  166.059655]  ath11k_pci_ext_grp_napi_poll+0x1c/0x70 [ath11k_pci]
[  166.059659]  __napi_poll+0x28/0x230
[  166.059664]  net_rx_action+0x285/0x310
[  166.059668]  __do_softirq+0xe6/0x4d2
[  166.059672]  irq_exit_rcu+0xd2/0xf0
[  166.059675]  common_interrupt+0xa5/0xc0
[  166.059678]  </IRQ>
[  166.059679]  <TASK>
[  166.059680]  asm_common_interrupt+0x1e/0x40
[  166.059683] RIP: 0010:_raw_spin_unlock_irqrestore+0x38/0x70
[  166.059686] Code: 83 c7 18 e8 2a 95 43 ff 48 89 ef e8 22 d2 43 ff 81 e3 00 02 00 00 75 25 9c 58 f6 c4 02 75 2d 48 85 db 74 01 fb bf 01 00 00 00 <e8> 63 2e 40 ff 65 8b 05 8c 59 97 5c 85 c0 74 0a 5b 5d c3 e8 00 6a
[  166.059689] RSP: 0018:ffff9d2400a5fca0 EFLAGS: 00000206
[  166.059692] RAX: 0000000000000002 RBX: 0000000000000200 RCX: 0000000000000006
[  166.059694] RDX: 0000000000000000 RSI: ffffffffa404879b RDI: 0000000000000001
[  166.059696] RBP: ffff9905c0053000 R08: 0000000000000001 R09: 0000000000000001
[  166.059698] R10: ffff9d2400a5fc50 R11: 0000000000000001 R12: ffffe186c41e2840
[  166.059700] R13: 0000000000000001 R14: ffff9905c78a1c68 R15: 0000000000000001
[  166.059704]  free_debug_processing+0x257/0x3d0
[  166.059708]  ? free_obj_work+0x1f5/0x250
[  166.059712]  __slab_free+0x374/0x5a0
[  166.059718]  ? kmem_cache_free+0x2e1/0x370
[  166.059721]  ? free_obj_work+0x1f5/0x250
[  166.059724]  kmem_cache_free+0x2e1/0x370
[  166.059727]  free_obj_work+0x1f5/0x250
[  166.059731]  process_one_work+0x28b/0x660
[  166.059735]  ? process_one_work+0x660/0x660
[  166.059738]  worker_thread+0x37/0x390
[  166.059741]  ? process_one_work+0x660/0x660
[  166.059743]  kthread+0x176/0x1a0
[  166.059746]  ? set_kthread_struct+0x40/0x40
[  166.059749]  ret_from_fork+0x22/0x30
[  166.059754]  </TASK>

Since these two lockes are both initialized in ath11k_hal_srng_setup,
they are assigned with the same key. As a result lockdep suspects that
the task is trying to acquire the same lock (due to same key) while
already holding it, and thus reports the DEADLOCK warning. However as
they are different spinlock instances, the warning is false positive.

On the other hand, even no dead lock indeed, this is a major issue for
upstream regression testing as it disables lockdep functionality.

Fix it by assigning separate lock class key for each srng->lock.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-01720.1-QCAHSPSWPL_V1_V2_SILICONZ_LITE-1
Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20211209011949.151472-1-quic_bqiang@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/hal.c | 22 ++++++++++++++++++++++
 drivers/net/wireless/ath/ath11k/hal.h |  2 ++
 2 files changed, 24 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/hal.c b/drivers/net/wireless/ath/ath11k/hal.c
index eaa0edca55761..5dbf5596c9e8e 100644
--- a/drivers/net/wireless/ath/ath11k/hal.c
+++ b/drivers/net/wireless/ath/ath11k/hal.c
@@ -947,6 +947,7 @@ int ath11k_hal_srng_setup(struct ath11k_base *ab, enum hal_ring_type type,
 	srng->msi_data = params->msi_data;
 	srng->initialized = 1;
 	spin_lock_init(&srng->lock);
+	lockdep_set_class(&srng->lock, hal->srng_key + ring_id);
 
 	for (i = 0; i < HAL_SRNG_NUM_REG_GRP; i++) {
 		srng->hwreg_base[i] = srng_config->reg_start[i] +
@@ -1233,6 +1234,24 @@ static int ath11k_hal_srng_create_config(struct ath11k_base *ab)
 	return 0;
 }
 
+static void ath11k_hal_register_srng_key(struct ath11k_base *ab)
+{
+	struct ath11k_hal *hal = &ab->hal;
+	u32 ring_id;
+
+	for (ring_id = 0; ring_id < HAL_SRNG_RING_ID_MAX; ring_id++)
+		lockdep_register_key(hal->srng_key + ring_id);
+}
+
+static void ath11k_hal_unregister_srng_key(struct ath11k_base *ab)
+{
+	struct ath11k_hal *hal = &ab->hal;
+	u32 ring_id;
+
+	for (ring_id = 0; ring_id < HAL_SRNG_RING_ID_MAX; ring_id++)
+		lockdep_unregister_key(hal->srng_key + ring_id);
+}
+
 int ath11k_hal_srng_init(struct ath11k_base *ab)
 {
 	struct ath11k_hal *hal = &ab->hal;
@@ -1252,6 +1271,8 @@ int ath11k_hal_srng_init(struct ath11k_base *ab)
 	if (ret)
 		goto err_free_cont_rdp;
 
+	ath11k_hal_register_srng_key(ab);
+
 	return 0;
 
 err_free_cont_rdp:
@@ -1266,6 +1287,7 @@ void ath11k_hal_srng_deinit(struct ath11k_base *ab)
 {
 	struct ath11k_hal *hal = &ab->hal;
 
+	ath11k_hal_unregister_srng_key(ab);
 	ath11k_hal_free_cont_rdp(ab);
 	ath11k_hal_free_cont_wrp(ab);
 	kfree(hal->srng_config);
diff --git a/drivers/net/wireless/ath/ath11k/hal.h b/drivers/net/wireless/ath/ath11k/hal.h
index 35ed3a14e200a..7fdcd8bbf7e98 100644
--- a/drivers/net/wireless/ath/ath11k/hal.h
+++ b/drivers/net/wireless/ath/ath11k/hal.h
@@ -901,6 +901,8 @@ struct ath11k_hal {
 	/* shadow register configuration */
 	u32 shadow_reg_addr[HAL_SHADOW_NUM_REGS];
 	int num_shadow_reg_configured;
+
+	struct lock_class_key srng_key[HAL_SRNG_RING_ID_MAX];
 };
 
 u32 ath11k_hal_reo_qdesc_size(u32 ba_window_size, u8 tid);
-- 
2.34.1


Return-Path: <netdev+bounces-427-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 360076F76B1
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 22:12:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 772CC1C21451
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 20:12:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90CFB182C4;
	Thu,  4 May 2023 19:49:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4974182A0
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 19:49:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3673CC433EF;
	Thu,  4 May 2023 19:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683229794;
	bh=BB9ZIBrGr1d9vM0upxjrNClxrP60GY1VqXUXMJUsoSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ps+/2pMn3SYdxNDnQGII2ZKaoCqzXSkqGHubjTaTJ/oAVDudfHF/XoCDnB9/cmTSd
	 IpcWA85QCRlouP/pkq5e29B0iSs8efENJA4Hv2pDjVWxDUzcT1kyd01Qt95UkzjJz7
	 a41OEybbLxfeeANS+i6M+5YegK0LqrLuj3VcOHu8ZfTlBExa8utNKt4JWU0LDuhXwf
	 l9YsjL6sQW/2q3tYlpK0p/OBAMm9Udxp7Vm4zo3Vt/2NzyfszpmJs6/8qfVzTpubyB
	 5LEqizzp7LL0agjn3krS7vb/bHZ6IBiBlLiQQthmrQEfKcAvxd3ZM13UOedxzB5Epl
	 zaC7SFLxkLhnA==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Jisoo Jang <jisoo.jang@yonsei.ac.kr>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	aspriel@gmail.com,
	franky.lin@broadcom.com,
	hante.meuleman@broadcom.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	chi-hsien.lin@infineon.com,
	ian.lin@infineon.com,
	wright.feng@cypress.com,
	marcan@marcan.st,
	hdegoede@redhat.com,
	wataru.gohda@cypress.com,
	prasanna.kerekoppa@cypress.com,
	ramesh.rangavittal@infineon.com,
	linux-wireless@vger.kernel.org,
	brcm80211-dev-list.pdl@broadcom.com,
	SHA-cyfmac-dev-list@infineon.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 06/24] wifi: brcmfmac: slab-out-of-bounds read in brcmf_get_assoc_ies()
Date: Thu,  4 May 2023 15:49:19 -0400
Message-Id: <20230504194937.3808414-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230504194937.3808414-1-sashal@kernel.org>
References: <20230504194937.3808414-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jisoo Jang <jisoo.jang@yonsei.ac.kr>

[ Upstream commit 0da40e018fd034d87c9460123fa7f897b69fdee7 ]

Fix a slab-out-of-bounds read that occurs in kmemdup() called from
brcmf_get_assoc_ies().
The bug could occur when assoc_info->req_len, data from a URB provided
by a USB device, is bigger than the size of buffer which is defined as
WL_EXTRA_BUF_MAX.

Add the size check for req_len/resp_len of assoc_info.

Found by a modified version of syzkaller.

[   46.592467][    T7] ==================================================================
[   46.594687][    T7] BUG: KASAN: slab-out-of-bounds in kmemdup+0x3e/0x50
[   46.596572][    T7] Read of size 3014656 at addr ffff888019442000 by task kworker/0:1/7
[   46.598575][    T7]
[   46.599157][    T7] CPU: 0 PID: 7 Comm: kworker/0:1 Tainted: G           O      5.14.0+ #145
[   46.601333][    T7] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
[   46.604360][    T7] Workqueue: events brcmf_fweh_event_worker
[   46.605943][    T7] Call Trace:
[   46.606584][    T7]  dump_stack_lvl+0x8e/0xd1
[   46.607446][    T7]  print_address_description.constprop.0.cold+0x93/0x334
[   46.608610][    T7]  ? kmemdup+0x3e/0x50
[   46.609341][    T7]  kasan_report.cold+0x79/0xd5
[   46.610151][    T7]  ? kmemdup+0x3e/0x50
[   46.610796][    T7]  kasan_check_range+0x14e/0x1b0
[   46.611691][    T7]  memcpy+0x20/0x60
[   46.612323][    T7]  kmemdup+0x3e/0x50
[   46.612987][    T7]  brcmf_get_assoc_ies+0x967/0xf60
[   46.613904][    T7]  ? brcmf_notify_vif_event+0x3d0/0x3d0
[   46.614831][    T7]  ? lock_chain_count+0x20/0x20
[   46.615683][    T7]  ? mark_lock.part.0+0xfc/0x2770
[   46.616552][    T7]  ? lock_chain_count+0x20/0x20
[   46.617409][    T7]  ? mark_lock.part.0+0xfc/0x2770
[   46.618244][    T7]  ? lock_chain_count+0x20/0x20
[   46.619024][    T7]  brcmf_bss_connect_done.constprop.0+0x241/0x2e0
[   46.620019][    T7]  ? brcmf_parse_configure_security.isra.0+0x2a0/0x2a0
[   46.620818][    T7]  ? __lock_acquire+0x181f/0x5790
[   46.621462][    T7]  brcmf_notify_connect_status+0x448/0x1950
[   46.622134][    T7]  ? rcu_read_lock_bh_held+0xb0/0xb0
[   46.622736][    T7]  ? brcmf_cfg80211_join_ibss+0x7b0/0x7b0
[   46.623390][    T7]  ? find_held_lock+0x2d/0x110
[   46.623962][    T7]  ? brcmf_fweh_event_worker+0x19f/0xc60
[   46.624603][    T7]  ? mark_held_locks+0x9f/0xe0
[   46.625145][    T7]  ? lockdep_hardirqs_on_prepare+0x3e0/0x3e0
[   46.625871][    T7]  ? brcmf_cfg80211_join_ibss+0x7b0/0x7b0
[   46.626545][    T7]  brcmf_fweh_call_event_handler.isra.0+0x90/0x100
[   46.627338][    T7]  brcmf_fweh_event_worker+0x557/0xc60
[   46.627962][    T7]  ? brcmf_fweh_call_event_handler.isra.0+0x100/0x100
[   46.628736][    T7]  ? rcu_read_lock_sched_held+0xa1/0xd0
[   46.629396][    T7]  ? rcu_read_lock_bh_held+0xb0/0xb0
[   46.629970][    T7]  ? lockdep_hardirqs_on_prepare+0x273/0x3e0
[   46.630649][    T7]  process_one_work+0x92b/0x1460
[   46.631205][    T7]  ? pwq_dec_nr_in_flight+0x330/0x330
[   46.631821][    T7]  ? rwlock_bug.part.0+0x90/0x90
[   46.632347][    T7]  worker_thread+0x95/0xe00
[   46.632832][    T7]  ? __kthread_parkme+0x115/0x1e0
[   46.633393][    T7]  ? process_one_work+0x1460/0x1460
[   46.633957][    T7]  kthread+0x3a1/0x480
[   46.634369][    T7]  ? set_kthread_struct+0x120/0x120
[   46.634933][    T7]  ret_from_fork+0x1f/0x30
[   46.635431][    T7]
[   46.635687][    T7] Allocated by task 7:
[   46.636151][    T7]  kasan_save_stack+0x1b/0x40
[   46.636628][    T7]  __kasan_kmalloc+0x7c/0x90
[   46.637108][    T7]  kmem_cache_alloc_trace+0x19e/0x330
[   46.637696][    T7]  brcmf_cfg80211_attach+0x4a0/0x4040
[   46.638275][    T7]  brcmf_attach+0x389/0xd40
[   46.638739][    T7]  brcmf_usb_probe+0x12de/0x1690
[   46.639279][    T7]  usb_probe_interface+0x2aa/0x760
[   46.639820][    T7]  really_probe+0x205/0xb70
[   46.640342][    T7]  __driver_probe_device+0x311/0x4b0
[   46.640876][    T7]  driver_probe_device+0x4e/0x150
[   46.641445][    T7]  __device_attach_driver+0x1cc/0x2a0
[   46.642000][    T7]  bus_for_each_drv+0x156/0x1d0
[   46.642543][    T7]  __device_attach+0x23f/0x3a0
[   46.643065][    T7]  bus_probe_device+0x1da/0x290
[   46.643644][    T7]  device_add+0xb7b/0x1eb0
[   46.644130][    T7]  usb_set_configuration+0xf59/0x16f0
[   46.644720][    T7]  usb_generic_driver_probe+0x82/0xa0
[   46.645295][    T7]  usb_probe_device+0xbb/0x250
[   46.645786][    T7]  really_probe+0x205/0xb70
[   46.646258][    T7]  __driver_probe_device+0x311/0x4b0
[   46.646804][    T7]  driver_probe_device+0x4e/0x150
[   46.647387][    T7]  __device_attach_driver+0x1cc/0x2a0
[   46.647926][    T7]  bus_for_each_drv+0x156/0x1d0
[   46.648454][    T7]  __device_attach+0x23f/0x3a0
[   46.648939][    T7]  bus_probe_device+0x1da/0x290
[   46.649478][    T7]  device_add+0xb7b/0x1eb0
[   46.649936][    T7]  usb_new_device.cold+0x49c/0x1029
[   46.650526][    T7]  hub_event+0x1c98/0x3950
[   46.650975][    T7]  process_one_work+0x92b/0x1460
[   46.651535][    T7]  worker_thread+0x95/0xe00
[   46.651991][    T7]  kthread+0x3a1/0x480
[   46.652413][    T7]  ret_from_fork+0x1f/0x30
[   46.652885][    T7]
[   46.653131][    T7] The buggy address belongs to the object at ffff888019442000
[   46.653131][    T7]  which belongs to the cache kmalloc-2k of size 2048
[   46.654669][    T7] The buggy address is located 0 bytes inside of
[   46.654669][    T7]  2048-byte region [ffff888019442000, ffff888019442800)
[   46.656137][    T7] The buggy address belongs to the page:
[   46.656720][    T7] page:ffffea0000651000 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x19440
[   46.657792][    T7] head:ffffea0000651000 order:3 compound_mapcount:0 compound_pincount:0
[   46.658673][    T7] flags: 0x100000000010200(slab|head|node=0|zone=1)
[   46.659422][    T7] raw: 0100000000010200 0000000000000000 dead000000000122 ffff888100042000
[   46.660363][    T7] raw: 0000000000000000 0000000000080008 00000001ffffffff 0000000000000000
[   46.661236][    T7] page dumped because: kasan: bad access detected
[   46.661956][    T7] page_owner tracks the page as allocated
[   46.662588][    T7] page last allocated via order 3, migratetype Unmovable, gfp_mask 0x52a20(GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 7, ts 31136961085, free_ts 0
[   46.664271][    T7]  prep_new_page+0x1aa/0x240
[   46.664763][    T7]  get_page_from_freelist+0x159a/0x27c0
[   46.665340][    T7]  __alloc_pages+0x2da/0x6a0
[   46.665847][    T7]  alloc_pages+0xec/0x1e0
[   46.666308][    T7]  allocate_slab+0x380/0x4e0
[   46.666770][    T7]  ___slab_alloc+0x5bc/0x940
[   46.667264][    T7]  __slab_alloc+0x6d/0x80
[   46.667712][    T7]  kmem_cache_alloc_trace+0x30a/0x330
[   46.668299][    T7]  brcmf_usbdev_qinit.constprop.0+0x50/0x470
[   46.668885][    T7]  brcmf_usb_probe+0xc97/0x1690
[   46.669438][    T7]  usb_probe_interface+0x2aa/0x760
[   46.669988][    T7]  really_probe+0x205/0xb70
[   46.670487][    T7]  __driver_probe_device+0x311/0x4b0
[   46.671031][    T7]  driver_probe_device+0x4e/0x150
[   46.671604][    T7]  __device_attach_driver+0x1cc/0x2a0
[   46.672192][    T7]  bus_for_each_drv+0x156/0x1d0
[   46.672739][    T7] page_owner free stack trace missing
[   46.673335][    T7]
[   46.673620][    T7] Memory state around the buggy address:
[   46.674213][    T7]  ffff888019442700: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   46.675083][    T7]  ffff888019442780: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   46.675994][    T7] >ffff888019442800: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   46.676875][    T7]                    ^
[   46.677323][    T7]  ffff888019442880: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   46.678190][    T7]  ffff888019442900: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   46.679052][    T7] ==================================================================
[   46.679945][    T7] Disabling lock debugging due to kernel taint
[   46.680725][    T7] Kernel panic - not syncing:

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Jisoo Jang <jisoo.jang@yonsei.ac.kr>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230309104457.22628-1-jisoo.jang@yonsei.ac.kr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 24dda3762768d..baf5f0afe802e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -5835,6 +5835,11 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_info *cfg,
 		(struct brcmf_cfg80211_assoc_ielen_le *)cfg->extra_buf;
 	req_len = le32_to_cpu(assoc_info->req_len);
 	resp_len = le32_to_cpu(assoc_info->resp_len);
+	if (req_len > WL_EXTRA_BUF_MAX || resp_len > WL_EXTRA_BUF_MAX) {
+		bphy_err(drvr, "invalid lengths in assoc info: req %u resp %u\n",
+			 req_len, resp_len);
+		return -EINVAL;
+	}
 	if (req_len) {
 		err = brcmf_fil_iovar_data_get(ifp, "assoc_req_ies",
 					       cfg->extra_buf,
-- 
2.39.2



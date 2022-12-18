Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2FEC65011E
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 17:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbiLRQYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 11:24:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbiLRQXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 11:23:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6501913E2B;
        Sun, 18 Dec 2022 08:09:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E641160DD5;
        Sun, 18 Dec 2022 16:09:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 099EFC433D2;
        Sun, 18 Dec 2022 16:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379749;
        bh=UYhx+evpP8ZHfD9IL8KQ848NFyz7PIEsaO34Dd8PASY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I6DZP8ljOBHHZdKxgzFWgV3IdTMSh3OKRkD3zO6x02cHlx/I0EaVBRJmcHnYFu3Aq
         UQ28oHV+w4XDmwS1SzGOGfCAApQBjTWL8rpHf62KwUJ3wOKYfj4PeoFdkCl56xYgyY
         YXy8pMuHQZ4tiHTSqCHzM+K7uHg4OsJbtziHBIQ3JuOnnJQat88lCOJaWx6wUazR24
         C8Fcv5LsNRSgxgL1xma/0xaJX5VM5eE2m9oWxLkXACqA/+5h5J4+QK8DNiJYLIdTU+
         2E4hgr4qUvP9k1k5J37rcPjYIlw0WKb4Z5ODY1cCX9GKLhUo2P3mpWiqadBlFdr0Sr
         CTewV9wPrfcuw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Minsuk Kang <linuxlovemin@yonsei.ac.kr>,
        Dokyung Song <dokyungs@yonsei.ac.kr>,
        Jisoo Jang <jisoo.jang@yonsei.ac.kr>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>,
        aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        marcan@marcan.st, alsi@bang-olufsen.dk, rmk+kernel@armlinux.org.uk,
        linus.walleij@linaro.org, ardb@kernel.org,
        wsa+renesas@sang-engineering.com, phil@raspberrypi.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 23/73] wifi: brcmfmac: Fix potential shift-out-of-bounds in brcmf_fw_alloc_request()
Date:   Sun, 18 Dec 2022 11:06:51 -0500
Message-Id: <20221218160741.927862-23-sashal@kernel.org>
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

From: Minsuk Kang <linuxlovemin@yonsei.ac.kr>

[ Upstream commit 81d17f6f3331f03c8eafdacea68ab773426c1e3c ]

This patch fixes a shift-out-of-bounds in brcmfmac that occurs in
BIT(chiprev) when a 'chiprev' provided by the device is too large.
It should also not be equal to or greater than BITS_PER_TYPE(u32)
as we do bitwise AND with a u32 variable and BIT(chiprev). The patch
adds a check that makes the function return NULL if that is the case.
Note that the NULL case is later handled by the bus-specific caller,
brcmf_usb_probe_cb() or brcmf_usb_reset_resume(), for example.

Found by a modified version of syzkaller.

UBSAN: shift-out-of-bounds in drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
shift exponent 151055786 is too large for 64-bit type 'long unsigned int'
CPU: 0 PID: 1885 Comm: kworker/0:2 Tainted: G           O      5.14.0+ #132
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
Workqueue: usb_hub_wq hub_event
Call Trace:
 dump_stack_lvl+0x57/0x7d
 ubsan_epilogue+0x5/0x40
 __ubsan_handle_shift_out_of_bounds.cold+0x53/0xdb
 ? lock_chain_count+0x20/0x20
 brcmf_fw_alloc_request.cold+0x19/0x3ea
 ? brcmf_fw_get_firmwares+0x250/0x250
 ? brcmf_usb_ioctl_resp_wait+0x1a7/0x1f0
 brcmf_usb_get_fwname+0x114/0x1a0
 ? brcmf_usb_reset_resume+0x120/0x120
 ? number+0x6c4/0x9a0
 brcmf_c_process_clm_blob+0x168/0x590
 ? put_dec+0x90/0x90
 ? enable_ptr_key_workfn+0x20/0x20
 ? brcmf_common_pd_remove+0x50/0x50
 ? rcu_read_lock_sched_held+0xa1/0xd0
 brcmf_c_preinit_dcmds+0x673/0xc40
 ? brcmf_c_set_joinpref_default+0x100/0x100
 ? rcu_read_lock_sched_held+0xa1/0xd0
 ? rcu_read_lock_bh_held+0xb0/0xb0
 ? lock_acquire+0x19d/0x4e0
 ? find_held_lock+0x2d/0x110
 ? brcmf_usb_deq+0x1cc/0x260
 ? mark_held_locks+0x9f/0xe0
 ? lockdep_hardirqs_on_prepare+0x273/0x3e0
 ? _raw_spin_unlock_irqrestore+0x47/0x50
 ? trace_hardirqs_on+0x1c/0x120
 ? brcmf_usb_deq+0x1a7/0x260
 ? brcmf_usb_rx_fill_all+0x5a/0xf0
 brcmf_attach+0x246/0xd40
 ? wiphy_new_nm+0x1476/0x1d50
 ? kmemdup+0x30/0x40
 brcmf_usb_probe+0x12de/0x1690
 ? brcmf_usbdev_qinit.constprop.0+0x470/0x470
 usb_probe_interface+0x25f/0x710
 really_probe+0x1be/0xa90
 __driver_probe_device+0x2ab/0x460
 ? usb_match_id.part.0+0x88/0xc0
 driver_probe_device+0x49/0x120
 __device_attach_driver+0x18a/0x250
 ? driver_allows_async_probing+0x120/0x120
 bus_for_each_drv+0x123/0x1a0
 ? bus_rescan_devices+0x20/0x20
 ? lockdep_hardirqs_on_prepare+0x273/0x3e0
 ? trace_hardirqs_on+0x1c/0x120
 __device_attach+0x207/0x330
 ? device_bind_driver+0xb0/0xb0
 ? kobject_uevent_env+0x230/0x12c0
 bus_probe_device+0x1a2/0x260
 device_add+0xa61/0x1ce0
 ? __mutex_unlock_slowpath+0xe7/0x660
 ? __fw_devlink_link_to_suppliers+0x550/0x550
 usb_set_configuration+0x984/0x1770
 ? kernfs_create_link+0x175/0x230
 usb_generic_driver_probe+0x69/0x90
 usb_probe_device+0x9c/0x220
 really_probe+0x1be/0xa90
 __driver_probe_device+0x2ab/0x460
 driver_probe_device+0x49/0x120
 __device_attach_driver+0x18a/0x250
 ? driver_allows_async_probing+0x120/0x120
 bus_for_each_drv+0x123/0x1a0
 ? bus_rescan_devices+0x20/0x20
 ? lockdep_hardirqs_on_prepare+0x273/0x3e0
 ? trace_hardirqs_on+0x1c/0x120
 __device_attach+0x207/0x330
 ? device_bind_driver+0xb0/0xb0
 ? kobject_uevent_env+0x230/0x12c0
 bus_probe_device+0x1a2/0x260
 device_add+0xa61/0x1ce0
 ? __fw_devlink_link_to_suppliers+0x550/0x550
 usb_new_device.cold+0x463/0xf66
 ? hub_disconnect+0x400/0x400
 ? _raw_spin_unlock_irq+0x24/0x30
 hub_event+0x10d5/0x3330
 ? hub_port_debounce+0x280/0x280
 ? __lock_acquire+0x1671/0x5790
 ? wq_calc_node_cpumask+0x170/0x2a0
 ? lock_release+0x640/0x640
 ? rcu_read_lock_sched_held+0xa1/0xd0
 ? rcu_read_lock_bh_held+0xb0/0xb0
 ? lockdep_hardirqs_on_prepare+0x273/0x3e0
 process_one_work+0x873/0x13e0
 ? lock_release+0x640/0x640
 ? pwq_dec_nr_in_flight+0x320/0x320
 ? rwlock_bug.part.0+0x90/0x90
 worker_thread+0x8b/0xd10
 ? __kthread_parkme+0xd9/0x1d0
 ? process_one_work+0x13e0/0x13e0
 kthread+0x379/0x450
 ? _raw_spin_unlock_irq+0x24/0x30
 ? set_kthread_struct+0x100/0x100
 ret_from_fork+0x1f/0x30

Reported-by: Dokyung Song <dokyungs@yonsei.ac.kr>
Reported-by: Jisoo Jang <jisoo.jang@yonsei.ac.kr>
Reported-by: Minsuk Kang <linuxlovemin@yonsei.ac.kr>
Signed-off-by: Minsuk Kang <linuxlovemin@yonsei.ac.kr>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20221024071329.504277-1-linuxlovemin@yonsei.ac.kr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index b8379e4034a4..55d538978e9c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -737,6 +737,11 @@ brcmf_fw_alloc_request(u32 chip, u32 chiprev,
 	u32 i, j;
 	char end = '\0';
 
+	if (chiprev >= BITS_PER_TYPE(u32)) {
+		brcmf_err("Invalid chip revision %u\n", chiprev);
+		return NULL;
+	}
+
 	for (i = 0; i < table_size; i++) {
 		if (mapping_table[i].chipid == chip &&
 		    mapping_table[i].revmask & BIT(chiprev))
-- 
2.35.1


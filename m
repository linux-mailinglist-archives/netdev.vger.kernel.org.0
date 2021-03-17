Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8500A33E4C2
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 02:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232544AbhCQBAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 21:00:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:36348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232257AbhCQA7E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 20:59:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6DF164F10;
        Wed, 17 Mar 2021 00:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942734;
        bh=89cshh0mj/UjHhyU95gD6JCbNcHeJR5Uo+zqZvCK6UE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SdvjClbFXUqux5inxH4XDuovCbkQtzPl6EW9hfmqkNJZj0x/KE8IWF1iFMrGC+2Ld
         c9szoMufaxJSLF7LXitqbix3TY5LtL4CD3MTAtBNlOf052ro4elzyzVKlxhJXv6jn8
         gw6iSX6dBPXG/kgXUHzP58KoPajuHuiSvl7l6PaLFQbqUu38yt+77DD3SQcn88VIxy
         nGceGGJO9G9BKL10L1cRGgRs3KPD7XwBH7NdDp9LedH64p4H2SOUTAdNKiyKEm/V3D
         NOfbRaeI4QQ0Dgetn40tvwDd8/A0TdDoHw6j3JHDGNGuAsIMsDsKXxDYISk24jit2S
         JCv8iUMi80aMA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tong Zhang <ztong0001@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 03/23] atm: eni: dont release is never initialized
Date:   Tue, 16 Mar 2021 20:58:29 -0400
Message-Id: <20210317005850.726479-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005850.726479-1-sashal@kernel.org>
References: <20210317005850.726479-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tong Zhang <ztong0001@gmail.com>

[ Upstream commit 4deb550bc3b698a1f03d0332cde3df154d1b6c1e ]

label err_eni_release is reachable when eni_start() fail.
In eni_start() it calls dev->phy->start() in the last step, if start()
fail we don't need to call phy->stop(), if start() is never called, we
neither need to call phy->stop(), otherwise null-ptr-deref will happen.

In order to fix this issue, don't call phy->stop() in label err_eni_release

[    4.875714] ==================================================================
[    4.876091] BUG: KASAN: null-ptr-deref in suni_stop+0x47/0x100 [suni]
[    4.876433] Read of size 8 at addr 0000000000000030 by task modprobe/95
[    4.876778]
[    4.876862] CPU: 0 PID: 95 Comm: modprobe Not tainted 5.11.0-rc7-00090-gdcc0b49040c7 #2
[    4.877290] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-48-gd94
[    4.877876] Call Trace:
[    4.878009]  dump_stack+0x7d/0xa3
[    4.878191]  kasan_report.cold+0x10c/0x10e
[    4.878410]  ? __slab_free+0x2f0/0x340
[    4.878612]  ? suni_stop+0x47/0x100 [suni]
[    4.878832]  suni_stop+0x47/0x100 [suni]
[    4.879043]  eni_do_release+0x3b/0x70 [eni]
[    4.879269]  eni_init_one.cold+0x1152/0x1747 [eni]
[    4.879528]  ? _raw_spin_lock_irqsave+0x7b/0xd0
[    4.879768]  ? eni_ioctl+0x270/0x270 [eni]
[    4.879990]  ? __mutex_lock_slowpath+0x10/0x10
[    4.880226]  ? eni_ioctl+0x270/0x270 [eni]
[    4.880448]  local_pci_probe+0x6f/0xb0
[    4.880650]  pci_device_probe+0x171/0x240
[    4.880864]  ? pci_device_remove+0xe0/0xe0
[    4.881086]  ? kernfs_create_link+0xb6/0x110
[    4.881315]  ? sysfs_do_create_link_sd.isra.0+0x76/0xe0
[    4.881594]  really_probe+0x161/0x420
[    4.881791]  driver_probe_device+0x6d/0xd0
[    4.882010]  device_driver_attach+0x82/0x90
[    4.882233]  ? device_driver_attach+0x90/0x90
[    4.882465]  __driver_attach+0x60/0x100
[    4.882671]  ? device_driver_attach+0x90/0x90
[    4.882903]  bus_for_each_dev+0xe1/0x140
[    4.883114]  ? subsys_dev_iter_exit+0x10/0x10
[    4.883346]  ? klist_node_init+0x61/0x80
[    4.883557]  bus_add_driver+0x254/0x2a0
[    4.883764]  driver_register+0xd3/0x150
[    4.883971]  ? 0xffffffffc0038000
[    4.884149]  do_one_initcall+0x84/0x250
[    4.884355]  ? trace_event_raw_event_initcall_finish+0x150/0x150
[    4.884674]  ? unpoison_range+0xf/0x30
[    4.884875]  ? ____kasan_kmalloc.constprop.0+0x84/0xa0
[    4.885150]  ? unpoison_range+0xf/0x30
[    4.885352]  ? unpoison_range+0xf/0x30
[    4.885557]  do_init_module+0xf8/0x350
[    4.885760]  load_module+0x3fe6/0x4340
[    4.885960]  ? vm_unmap_ram+0x1d0/0x1d0
[    4.886166]  ? ____kasan_kmalloc.constprop.0+0x84/0xa0
[    4.886441]  ? module_frob_arch_sections+0x20/0x20
[    4.886697]  ? __do_sys_finit_module+0x108/0x170
[    4.886941]  __do_sys_finit_module+0x108/0x170
[    4.887178]  ? __ia32_sys_init_module+0x40/0x40
[    4.887419]  ? file_open_root+0x200/0x200
[    4.887634]  ? do_sys_open+0x85/0xe0
[    4.887826]  ? filp_open+0x50/0x50
[    4.888009]  ? fpregs_assert_state_consistent+0x4d/0x60
[    4.888287]  ? exit_to_user_mode_prepare+0x2f/0x130
[    4.888547]  do_syscall_64+0x33/0x40
[    4.888739]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[    4.889010] RIP: 0033:0x7ff62fcf1cf7
[    4.889202] Code: 48 89 57 30 48 8b 04 24 48 89 47 38 e9 1d a0 02 00 48 89 f8 48 89 f71
[    4.890172] RSP: 002b:00007ffe6644ade8 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[    4.890570] RAX: ffffffffffffffda RBX: 0000000000f2ca70 RCX: 00007ff62fcf1cf7
[    4.890944] RDX: 0000000000000000 RSI: 0000000000f2b9e0 RDI: 0000000000000003
[    4.891318] RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000001
[    4.891691] R10: 00007ff62fd55300 R11: 0000000000000246 R12: 0000000000f2b9e0
[    4.892064] R13: 0000000000000000 R14: 0000000000f2bdd0 R15: 0000000000000001
[    4.892439] ==================================================================

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/atm/eni.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/atm/eni.c b/drivers/atm/eni.c
index 38fec976e62d..1409d48affb7 100644
--- a/drivers/atm/eni.c
+++ b/drivers/atm/eni.c
@@ -2279,7 +2279,8 @@ static int eni_init_one(struct pci_dev *pci_dev,
 	return rc;
 
 err_eni_release:
-	eni_do_release(dev);
+	dev->phy = NULL;
+	iounmap(ENI_DEV(dev)->ioaddr);
 err_unregister:
 	atm_dev_deregister(dev);
 err_free_consistent:
-- 
2.30.1


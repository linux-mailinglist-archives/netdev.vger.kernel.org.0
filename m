Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE46326F03
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 22:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbhB0VQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Feb 2021 16:16:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbhB0VQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Feb 2021 16:16:08 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD36C06174A;
        Sat, 27 Feb 2021 13:15:27 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id q85so12816633qke.8;
        Sat, 27 Feb 2021 13:15:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yACuRrWeAOm+vqBty/emieUeumPYE3QmVfAJc1GKnd8=;
        b=Vu2BZkkQXqhikn25pbv0ujmiSS9XLUCndzZ/XThhFKestpyUcP1dPSZsWICjU5jNuO
         m+sKQ2d/cXzWueEF33QmS6dlvTnTlXum4GyML+ixsxdRdyMeq8Kr5peXBsPzpdpssy8X
         M+GIGRao1fZBUhIhSYo4XKH3Lhzp6LtGOUXsEloArnQPNJ+ZV/F67/PwL06aq07sT0/a
         gIm86PE0SxIq9P9H+Le4HavdokadCsj3Dr08AZoEUYRJ+NzhaoSpQqOg0vqdwqaUyLNP
         C6tC+60IAXh2m6DOwkgYCbP2J7WS02QA3OU/WyHBYIgWhCWutuV7Wt3yUqOZMboTd1KQ
         t5eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yACuRrWeAOm+vqBty/emieUeumPYE3QmVfAJc1GKnd8=;
        b=K/QWAQCpN+FDGhXnfGKm5L1WqjCxzCd3/jQb6pEwQ7pW+rt8yXHxNFB1MrEqICmLw1
         kADxMzTc7fDIFZNanwzrUVpOhL8lZEBnAkJpk4HI+5OOCe0H6x+oDEbNOuL7wj9hMOYE
         zkNDQiIdFPvfSSmNIvQjbv5QWkES34swBeyg98AJyyD0kHFzDqEINptV0T4b19DMmsCL
         FTauxQ7yyM6xu/p/hCKFVGU+CJeDvcU3J1FfPXKP8++ohjJ2yoOCE9ZeiW460sHFUlTN
         3ylIOJm4G7N+ask7yARp8LznbflrOTXifvBc+X8lyCzWxkl2yVqYn5LEl1gqddmgwuW7
         1LgQ==
X-Gm-Message-State: AOAM531deDEvNCpdNzmcfCIF3obHxykD+0b5vc2fmBOQ7kIY0//ZwCtE
        m0S00YaxPPvw+BvfNARzA9E=
X-Google-Smtp-Source: ABdhPJy+9gYyjSKSu3sQW5y++DMYjarSycMC+uz64TI9TxVaEiAMqbBHwZIJqI2tnKRPiws5OIcrgA==
X-Received: by 2002:a37:8806:: with SMTP id k6mr8370908qkd.339.1614460526217;
        Sat, 27 Feb 2021 13:15:26 -0800 (PST)
Received: from tong-desktop.local ([2601:5c0:c200:27c6:3177:5a9:ac9d:5621])
        by smtp.googlemail.com with ESMTPSA id 12sm8372157qtt.88.2021.02.27.13.15.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Feb 2021 13:15:25 -0800 (PST)
From:   Tong Zhang <ztong0001@gmail.com>
To:     Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     ztong0001@gmail.com
Subject: [PATCH] atm: eni: dont release is never initialized
Date:   Sat, 27 Feb 2021 16:15:06 -0500
Message-Id: <20210227211506.314125-1-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 drivers/atm/eni.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/atm/eni.c b/drivers/atm/eni.c
index 316a9947541f..b574cce98dc3 100644
--- a/drivers/atm/eni.c
+++ b/drivers/atm/eni.c
@@ -2260,7 +2260,8 @@ static int eni_init_one(struct pci_dev *pci_dev,
 	return rc;
 
 err_eni_release:
-	eni_do_release(dev);
+	dev->phy = NULL;
+	iounmap(ENI_DEV(dev)->ioaddr);
 err_unregister:
 	atm_dev_deregister(dev);
 err_free_consistent:
-- 
2.25.1


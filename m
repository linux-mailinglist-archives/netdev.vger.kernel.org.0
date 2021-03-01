Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E862B327623
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 03:46:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbhCACqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 21:46:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231833AbhCACp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 21:45:59 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B77C06174A;
        Sun, 28 Feb 2021 18:45:18 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id cw15so6734677qvb.11;
        Sun, 28 Feb 2021 18:45:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i3RUk30ykIg813PhDPfClgxpavudFjgIE8k7yntSSP0=;
        b=DjmA8VDvFrsn8iXdNqiZCrwvJrxZ89+xuCzSyzsKcHf04Jl/MrLfHWwb/DgBH00rO5
         L3WJuXYqIl3ZKbPJgYjlYKOxlmorczUeUFKlZaH2YhRyV4ZPWv2cHbj8Duzu+ubBAl9n
         cu+lpHARuvwQiwCsphZ5qjP3JV4OSQFlCnmtLEkYlK1MWLPxda4TPU1XDp+zlXw5vT/g
         1blibaILqFgywxpJnKfeNklUNdY8MT2hkAGPSWaE3qB+aRco/ee4HqJnMtg6WdKpuVhG
         /QMR/bWfhVCZOkNprS+WCjfUpCvh/X7ktPMHx1hUDPgDIs4/nyDb8wbW0Ih6kpj2V6sZ
         hz+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i3RUk30ykIg813PhDPfClgxpavudFjgIE8k7yntSSP0=;
        b=Gy2dpwXBxNG/9hHwSugaEgzR9iYLfs+1lE/fSZO3Pz7yDtm1Q+50LTYle1c3/dOYXu
         1A7sZ2XzUl0DOkpNJKXigY2ly0vqNlIcfoeRicRJ7uHkGJ7KKfEE5Nf8mnE+OUqP6YZ4
         BhiXimMV8Oemvs71h22zsO7KL5tLHrjJOAOUhKmsHrelOWbsFUVmztecQbanCGYszmyw
         v4aatoep0jPewHWS4ErwU1UD69cSu0jyfP6DCQNv2Kh6p++9Xc87djCvMBF6vMgfVSAT
         fSf0vXDfN4RAi6Q8/kLKhKEctBbq80aTzFe/O8YmyLpbZms3J6UXjMjfxfXes/ZN+VM/
         Vn1g==
X-Gm-Message-State: AOAM533JeOzks97TG/7kSaOgd8E+TTlpsLXrjaF2yAa05eiMr1BTofF9
        UzOqP7FiIPjDVAOfB6swvpHQ6LexCWsDew==
X-Google-Smtp-Source: ABdhPJwRwDQyJUDK4PbtI4Ec3MPStxzu5SaPsooJ9Xc0DKW8MtvvX3+JomDK3l2NY3SrgpAuhnh9uQ==
X-Received: by 2002:a0c:8c87:: with SMTP id p7mr12959756qvb.46.1614566718155;
        Sun, 28 Feb 2021 18:45:18 -0800 (PST)
Received: from tong-desktop.local ([2601:5c0:c200:27c6:1d59:a36:514:a21])
        by smtp.googlemail.com with ESMTPSA id e1sm11949958qkf.99.2021.02.28.18.45.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 18:45:17 -0800 (PST)
From:   Tong Zhang <ztong0001@gmail.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tong Zhang <ztong0001@gmail.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] can: c_can_pci: fix use-after-free
Date:   Sun, 28 Feb 2021 21:45:11 -0500
Message-Id: <20210301024512.539039-1-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a UAF in c_can_pci_remove().
dev is released by free_c_can_dev() and is used by
pci_iounmap(pdev, priv->base) later.
To fix this issue, save the mmio address before releasing dev.

[ 1795.746699] ==================================================================
[ 1795.747093] BUG: KASAN: use-after-free in c_can_pci_remove+0x34/0x70 [c_can_pci]
[ 1795.747503] Read of size 8 at addr ffff888103db0be8 by task modprobe/98
[ 1795.747867]
[ 1795.747957] CPU: 0 PID: 98 Comm: modprobe Not tainted 5.11.0-11746-g06d5d309a3f1-dirty #56
[ 1795.748410] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-48-gd9c812dda519-4
[ 1795.749025] Call Trace:
[ 1795.749176]  dump_stack+0x8a/0xb5
[ 1795.749385]  print_address_description.constprop.0+0x1a/0x140
[ 1795.749713]  ? c_can_pci_remove+0x34/0x70 [c_can_pci]
[ 1795.750001]  ? c_can_pci_remove+0x34/0x70 [c_can_pci]
[ 1795.750285]  kasan_report.cold+0x7f/0x111
[ 1795.750513]  ? c_can_pci_remove+0x34/0x70 [c_can_pci]
[ 1795.750797]  c_can_pci_remove+0x34/0x70 [c_can_pci]
[ 1795.751071]  pci_device_remove+0x62/0xe0
[ 1795.751308]  device_release_driver_internal+0x148/0x270
[ 1795.751609]  driver_detach+0x76/0xe0
[ 1795.751812]  bus_remove_driver+0x7e/0x100
[ 1795.752051]  pci_unregister_driver+0x28/0xf0
[ 1795.752286]  __x64_sys_delete_module+0x268/0x300
[ 1795.752547]  ? __ia32_sys_delete_module+0x300/0x300
[ 1795.752815]  ? call_rcu+0x3e4/0x580
[ 1795.753014]  ? fpregs_assert_state_consistent+0x4d/0x60
[ 1795.753305]  ? exit_to_user_mode_prepare+0x2f/0x130
[ 1795.753574]  do_syscall_64+0x33/0x40
[ 1795.753782]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[ 1795.754060] RIP: 0033:0x7f033332dcf7
[ 1795.754257] Code: 48 89 57 30 48 8b 04 24 48 89 47 38 e9 1d a0 02 00 48 89 f8 48 89 f7 48 89 d6 41
[ 1795.755248] RSP: 002b:00007ffd06037208 EFLAGS: 00000202 ORIG_RAX: 00000000000000b0
[ 1795.755655] RAX: ffffffffffffffda RBX: 00007f03333ab690 RCX: 00007f033332dcf7
[ 1795.756038] RDX: 00000000ffffffff RSI: 0000000000000080 RDI: 0000000000d20b10
[ 1795.756420] RBP: 0000000000d20ac0 R08: 2f2f2f2f2f2f2f2f R09: 0000000000d20ac0
[ 1795.756801] R10: fefefefefefefeff R11: 0000000000000202 R12: 0000000000d20ac0
[ 1795.757183] R13: 0000000000d2abf0 R14: 0000000000000000 R15: 0000000000000001
[ 1795.757565]
[ 1795.757651] The buggy address belongs to the page:
[ 1795.757912] page:(____ptrval____) refcount:0 mapcount:-128 mapping:0000000000000000 index:0x0 pfn0
[ 1795.758427] flags: 0x200000000000000()
[ 1795.758633] raw: 0200000000000000 ffffea00040f7608 ffff88817fffab18 0000000000000000
[ 1795.759047] raw: 0000000000000000 0000000000000003 00000000ffffff7f 0000000000000000
[ 1795.759460] page dumped because: kasan: bad access detected
[ 1795.759759]
[ 1795.759845] Memory state around the buggy address:
[ 1795.760104]  ffff888103db0a80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 1795.760490]  ffff888103db0b00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 1795.760878] >ffff888103db0b80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 1795.761264]                                                           ^
[ 1795.761618]  ffff888103db0c00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 1795.762007]  ffff888103db0c80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[ 1795.762392] ==================================================================

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
---
 drivers/net/can/c_can/c_can_pci.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/c_can/c_can_pci.c b/drivers/net/can/c_can/c_can_pci.c
index 406b4847e5dc..a378383a99fb 100644
--- a/drivers/net/can/c_can/c_can_pci.c
+++ b/drivers/net/can/c_can/c_can_pci.c
@@ -239,12 +239,13 @@ static void c_can_pci_remove(struct pci_dev *pdev)
 {
 	struct net_device *dev = pci_get_drvdata(pdev);
 	struct c_can_priv *priv = netdev_priv(dev);
-
+	void __iomem *addr = priv->base;
+  
 	unregister_c_can_dev(dev);
 
 	free_c_can_dev(dev);
 
-	pci_iounmap(pdev, priv->base);
+	pci_iounmap(pdev, addr);
 	pci_disable_msi(pdev);
 	pci_clear_master(pdev);
 	pci_release_regions(pdev);
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D395CECA2
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 21:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728632AbfJGTVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 15:21:10 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:55568 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728187AbfJGTVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 15:21:09 -0400
Received: by mail-pg1-f202.google.com with SMTP id k18so10743127pgh.22
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 12:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Ooyuf/BpwshM59ojJEzoOAXZsxnADNsKaeHNhoFlivU=;
        b=UQ1VDIbYLSKDJJ6mWp+bKGG5di7kFtpSotAU0oU4WKqNvbPVyvERI7JyAcLIRUMKUv
         x9R62wxfMuUn1R2WNMZfHarqujzd6qbYJ0FFv5/45sI1Kg20T2IKcyAg1l5r+Kp96V3y
         lp1Df+uUEszhWZeVuzJ4yfWisln+68goIDcALDiblWvordex0slRDzrgRQLBWxGLPgRm
         VJhnXKo4SHm8R26LEu4eaj8E0FpwCh8d8WW7SE/i3pr8xlnEJp2KeZza8nBVRl/jHhAg
         k7VMX+5GUttkA+BV9hznTtOmRExJzV445wPpmaUUSqWcNyaQ9ulHjgXmWwaNu401LNhU
         FZeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Ooyuf/BpwshM59ojJEzoOAXZsxnADNsKaeHNhoFlivU=;
        b=k1viZ09FQBSldm060AMOOZHW1OBBeanLyzYAXE9qWvH2Msujvd89YK9e0NYVZ1vuPL
         v1sF2A56QFcRblTqt267aKvjSRUgmX8K723oruU0YajDeCB6TxQmJK1RtMpFP8MUJsTu
         z05qDGaGOAs+VNXTpFs4xLM8f2OW1pFZYfV6i6zNWFwsLFhs6I/zJoJf3pe+6hOrWoyK
         v4xf8ffAoGZXsOJfFER6kq9yObth9XWvZ8sMI7x8jwaqkTSMTaeDxDqTz0MY7x+JpGlo
         xiRE8hru4B8uYU++/OZFYpSXvyeTHSyGqGDwR+pIm0PUPE7WSUdGu//7cel41mHaeKU1
         r5ZQ==
X-Gm-Message-State: APjAAAWW8+szR/6SCVsR5hx8cxzmxt87yFIFVdG+BCnScgAyrINPd7Hu
        xslRaF0AUHrvnG2WmwU2fiOBmNNw0LcIMg==
X-Google-Smtp-Source: APXvYqwCXMPzyOEw84Qh2G9hNfvBLm5eLQTtlEVsqrZpJLjc9DCCPuRlshJljBkWeMyhav6otAiWRQkw7CmizQ==
X-Received: by 2002:a63:4a04:: with SMTP id x4mr8872192pga.429.1570476068281;
 Mon, 07 Oct 2019 12:21:08 -0700 (PDT)
Date:   Mon,  7 Oct 2019 12:21:05 -0700
Message-Id: <20191007192105.147659-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
Subject: [PATCH net-next] tun: fix memory leak in error path
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported a warning [1] that triggered after recent Jiri patch.

This exposes a bug that we hit already in the past (see commit
ff244c6b29b1 ("tun: handle register_netdevice() failures properly")
for details)

tun uses priv->destructor without an ndo_init() method.

register_netdevice() can return an error, but will
not call priv->destructor() in some cases. Jiri recent
patch added one more.

A long term fix would be to transfer the initialization
of what we destroy in ->destructor() in the ndo_init()

This looks a bit risky given the complexity of tun driver.

A simpler fix is to detect after the failed register_netdevice()
if the tun_free_netdev() function was called already.

[1]
ODEBUG: free active (active state 0) object type: timer_list hint: tun_flow_cleanup+0x0/0x280 drivers/net/tun.c:457
WARNING: CPU: 0 PID: 8653 at lib/debugobjects.c:481 debug_print_object+0x168/0x250 lib/debugobjects.c:481
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 8653 Comm: syz-executor976 Not tainted 5.4.0-rc1-next-20191004 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x172/0x1f0 lib/dump_stack.c:113
 panic+0x2dc/0x755 kernel/panic.c:220
 __warn.cold+0x2f/0x3c kernel/panic.c:581
 report_bug+0x289/0x300 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:174 [inline]
 fixup_bug arch/x86/kernel/traps.c:169 [inline]
 do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
 do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1028
RIP: 0010:debug_print_object+0x168/0x250 lib/debugobjects.c:481
Code: dd 80 b9 e6 87 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 b5 00 00 00 48 8b 14 dd 80 b9 e6 87 48 c7 c7 e0 ae e6 87 e8 80 84 ff fd <0f> 0b 83 05 e3 ee 80 06 01 48 83 c4 20 5b 41 5c 41 5d 41 5e 5d c3
RSP: 0018:ffff888095997a28 EFLAGS: 00010082
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815cb526 RDI: ffffed1012b32f37
RBP: ffff888095997a68 R08: ffff8880a92ac580 R09: ffffed1015d04101
R10: ffffed1015d04100 R11: ffff8880ae820807 R12: 0000000000000001
R13: ffffffff88fb5340 R14: ffffffff81627110 R15: ffff8880aa41eab8
 __debug_check_no_obj_freed lib/debugobjects.c:963 [inline]
 debug_check_no_obj_freed+0x2d4/0x43f lib/debugobjects.c:994
 kfree+0xf8/0x2c0 mm/slab.c:3755
 kvfree+0x61/0x70 mm/util.c:593
 netdev_freemem net/core/dev.c:9384 [inline]
 free_netdev+0x39d/0x450 net/core/dev.c:9533
 tun_set_iff drivers/net/tun.c:2871 [inline]
 __tun_chr_ioctl+0x317b/0x3f30 drivers/net/tun.c:3075
 tun_chr_ioctl+0x2b/0x40 drivers/net/tun.c:3355
 vfs_ioctl fs/ioctl.c:47 [inline]
 file_ioctl fs/ioctl.c:539 [inline]
 do_vfs_ioctl+0xdb6/0x13e0 fs/ioctl.c:726
 ksys_ioctl+0xab/0xd0 fs/ioctl.c:743
 __do_sys_ioctl fs/ioctl.c:750 [inline]
 __se_sys_ioctl fs/ioctl.c:748 [inline]
 __x64_sys_ioctl+0x73/0xb0 fs/ioctl.c:748
 do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x441439
Code: e8 9c ae 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 3b 0a fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fff61c37438 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000441439
RDX: 0000000020000400 RSI: 00000000400454ca RDI: 0000000000000004
RBP: 00007fff61c37470 R08: 0000000000000001 R09: 0000000100000000
R10: 0000000000000000 R11: 0000000000000246 R12: ffffffffffffffff
R13: 0000000000000005 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..

Fixes: ff92741270bf ("net: introduce name_node struct to be used in hashlist")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jiri Pirko <jiri@mellanox.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 drivers/net/tun.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 812dc3a65efbb9d1ee2724e73978dbc4803ec171..1e541b08b136364302aa524e31efb62062c43faa 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2290,7 +2290,13 @@ static void tun_free_netdev(struct net_device *dev)
 	struct tun_struct *tun = netdev_priv(dev);
 
 	BUG_ON(!(list_empty(&tun->disabled)));
+
 	free_percpu(tun->pcpu_stats);
+	/* We clear pcpu_stats so that tun_set_iff() can tell if
+	 * tun_free_netdev() has been called from register_netdevice().
+	 */
+	tun->pcpu_stats = NULL;
+
 	tun_flow_uninit(tun);
 	security_tun_dev_free_security(tun->security);
 	__tun_set_ebpf(tun, &tun->steering_prog, NULL);
@@ -2859,8 +2865,12 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 
 err_detach:
 	tun_detach_all(dev);
-	/* register_netdevice() already called tun_free_netdev() */
-	goto err_free_dev;
+	/* We are here because register_netdevice() has failed.
+	 * If register_netdevice() already called tun_free_netdev()
+	 * while dealing with the error, tun->pcpu_stats has been cleared.
+	 */
+	if (!tun->pcpu_stats)
+		goto err_free_dev;
 
 err_free_flow:
 	tun_flow_uninit(tun);
-- 
2.23.0.581.g78d2f28ef7-goog


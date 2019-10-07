Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 902F5CEF28
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 00:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729506AbfJGWnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 18:43:06 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:45863 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728654AbfJGWnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 18:43:05 -0400
Received: by mail-pf1-f202.google.com with SMTP id a2so12171854pfo.12
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 15:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=DeUZvese4H7E5K4XrV0ImObRPffWCArXuIFX6+Cv1PE=;
        b=GAH9JpOx9u65MwLIn1mUG2Lg0ntMwQfL+/XVtXU9uAVfEb/NoEL1RJZKUqnGPjCeVx
         nAtu4U+86TCVx9/0Mft+dqUUjIVkocSvgIxOgiNB2+kmnIqgQfAfeZHoA/5BZ18JwmIk
         3gNeMWile9S3SToshmtURfgXQVnhQ0mpTGo9el71b37yd+J6eZXL4o20HwC9I0xY6DLi
         WrhrDv4k1ynt6CEobuI2Ybfo3FrpMYYSmoGmUS9RLxZkOw2ekq8rBwBga0VhMl/3xsnB
         LyauuOj4PucNAepcBAYk1g1IV2FyaGIZxpzAfstQix4gm1rA1mfo4UH3DgTWcObP4/Ww
         IsPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=DeUZvese4H7E5K4XrV0ImObRPffWCArXuIFX6+Cv1PE=;
        b=tVHecs0bXRr5Gsq1RN0yXdKk2dpQIRHjt59KfMwjD4oIPiqV/k6Su660S48mNoDvP5
         JI7YY1uX13Ggj9dCKKFt88lDEDCGEyBAT7BlavMOZPad4mbz4sIkMLHTVPsf1JkbrLeQ
         uPoVdSzFco8yrSVl/hUnAxwNR6czGe9t/2Tt9AHN1bZ1CdhJv2bxb9TB2GhLtc6v79Nb
         /TcRMvDaErgE59PcCQ3KGkmQ9E3ZXbdb2fE8b906u53ZfjpOjZ+Hz7uDp+sLtpNgZzAv
         o80IfFFSb5shbpdFh8F5PLndRYSnKcv20Ntfi9zIUcO+wHQ9n7S4r3OH35TZd/iO8zow
         jFoA==
X-Gm-Message-State: APjAAAVhvvp1sjniNBMa5he3NoUdkXdwj6yAn5qvHN713gzqXuxaW3J4
        R7tD+3+jnjrU86eDb5lArB3xn9iC1CREeQ==
X-Google-Smtp-Source: APXvYqz3UulfxHJMpmgYrR0k/azCvEgesODxVfXGF9Db5+Eleu/zK4PYdcv38GN5uWK+ocqcm/66x4/1UNs/6Q==
X-Received: by 2002:a65:4549:: with SMTP id x9mr32345440pgr.170.1570488184787;
 Mon, 07 Oct 2019 15:43:04 -0700 (PDT)
Date:   Mon,  7 Oct 2019 15:43:01 -0700
Message-Id: <20191007224301.218272-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
Subject: [PATCH net] bonding: fix potential NULL deref in bond_update_slave_arr
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Mahesh Bandewar <maheshb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot got a NULL dereference in bond_update_slave_arr() [1],
happening after a failure to allocate bond->slave_arr

A workqueue (bond_slave_arr_handler) is supposed to retry
the allocation later, but if the slave is removed before
the workqueue had a chance to complete, bond->slave_err
can still be NULL.

[1]

Failed to build slave-array.
kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] SMP KASAN PTI
Modules linked in:
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:bond_update_slave_arr.cold+0xc6/0x198 drivers/net/bonding/bond_main.c:4039
RSP: 0018:ffff88018fe33678 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffc9000290b000
RDX: 0000000000000000 RSI: ffffffff82b63037 RDI: ffff88019745ea20
RBP: ffff88018fe33760 R08: ffff880170754280 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: ffff88019745ea00 R14: 0000000000000000 R15: ffff88018fe338b0
FS:  00007febd837d700(0000) GS:ffff8801dad00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000004540a0 CR3: 00000001c242e005 CR4: 00000000001626f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 [<ffffffff82b5b45e>] __bond_release_one+0x43e/0x500 drivers/net/bonding/bond_main.c:1923
 [<ffffffff82b5b966>] bond_release drivers/net/bonding/bond_main.c:2039 [inline]
 [<ffffffff82b5b966>] bond_do_ioctl+0x416/0x870 drivers/net/bonding/bond_main.c:3562
 [<ffffffff83ae25f4>] dev_ifsioc+0x6f4/0x940 net/core/dev_ioctl.c:328
 [<ffffffff83ae2e58>] dev_ioctl+0x1b8/0xc70 net/core/dev_ioctl.c:495
 [<ffffffff83995ffd>] sock_do_ioctl+0x1bd/0x300 net/socket.c:1088
 [<ffffffff83996a80>] sock_ioctl+0x300/0x5d0 net/socket.c:1196
 [<ffffffff81b124db>] vfs_ioctl fs/ioctl.c:47 [inline]
 [<ffffffff81b124db>] file_ioctl fs/ioctl.c:501 [inline]
 [<ffffffff81b124db>] do_vfs_ioctl+0xacb/0x1300 fs/ioctl.c:688
 [<ffffffff81b12dc6>] SYSC_ioctl fs/ioctl.c:705 [inline]
 [<ffffffff81b12dc6>] SyS_ioctl+0xb6/0xe0 fs/ioctl.c:696
 [<ffffffff8101ccc8>] do_syscall_64+0x528/0x770 arch/x86/entry/common.c:305
 [<ffffffff84400091>] entry_SYSCALL_64_after_hwframe+0x42/0xb7

Fixes: ee6377147409 ("bonding: Simplify the xmit function for modes that use xmit_hash")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Mahesh Bandewar <maheshb@google.com>
---
 drivers/net/bonding/bond_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 931d9d9356869b400c1b653414164a3e5ecb0b51..21d8fcc83c9ce958b6e9cb4c6f499ed9ef53f4d5 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4039,7 +4039,7 @@ int bond_update_slave_arr(struct bonding *bond, struct slave *skipslave)
 		 * this to-be-skipped slave to send a packet out.
 		 */
 		old_arr = rtnl_dereference(bond->slave_arr);
-		for (idx = 0; idx < old_arr->count; idx++) {
+		for (idx = 0; old_arr != NULL && idx < old_arr->count; idx++) {
 			if (skipslave == old_arr->arr[idx]) {
 				old_arr->arr[idx] =
 				    old_arr->arr[old_arr->count-1];
-- 
2.23.0.581.g78d2f28ef7-goog


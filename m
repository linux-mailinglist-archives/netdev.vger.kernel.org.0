Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A78EE4E7A
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 16:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440461AbfJYOHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 10:07:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:49336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2505026AbfJYNz0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 09:55:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B661F20679;
        Fri, 25 Oct 2019 13:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572011725;
        bh=XE1eQ/h5CCe9a5XWcVT1HygStTWvXjWp9ol+/2CGAO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HKulgbgPGuHJRVZHH+lJrqQ6S02bqnt4RLQ6QsUC9t+8sc+mla/cuW6e1mv6T33so
         3iPZG4nZdk3tBWt+MRUSgEQRHr9ymATvLqhVEJaTqQaScd7jUzUdWaWwfDBGoTJdPX
         l+HaFnoi6PX+mxIvDAdf4S6fhF3M8/LxvIP/3Dqw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 10/33] bonding: fix potential NULL deref in bond_update_slave_arr
Date:   Fri, 25 Oct 2019 09:54:42 -0400
Message-Id: <20191025135505.24762-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025135505.24762-1-sashal@kernel.org>
References: <20191025135505.24762-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a7137534b597b7c303203e6bc3ed87e87a273bb8 ]

syzbot got a NULL dereference in bond_update_slave_arr() [1],
happening after a failure to allocate bond->slave_arr

A workqueue (bond_slave_arr_handler) is supposed to retry
the allocation later, but if the slave is removed before
the workqueue had a chance to complete, bond->slave_arr
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
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 931d9d9356869..21d8fcc83c9ce 100644
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
2.20.1


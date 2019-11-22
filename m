Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 926641078B5
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 20:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbfKVTwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 14:52:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:49950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727589AbfKVTts (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 14:49:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E28802072D;
        Fri, 22 Nov 2019 19:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574452187;
        bh=UvXNQJIdPf8WAaILk8OqsujAnyi0cKyXbCQAAaoulws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lSVG0ZDoCCWdiMjiVgjxHcIadyptifA1GNCFKsw8rUXjzztav1JGLXGsfomAAqLen
         XLU0ofXvZrihj+zbAIKJdXYTTkNh/Q0D6rtyWbp0BrqfXl28LC+5EqkYjC+PK23BCa
         +POI288DGXlSoe9F5ohK3Pk/l/a7I9gUb0YNssOA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jouni Hogander <jouni.hogander@unikie.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 13/21] slip: Fix memory leak in slip_open error path
Date:   Fri, 22 Nov 2019 14:49:23 -0500
Message-Id: <20191122194931.24732-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122194931.24732-1-sashal@kernel.org>
References: <20191122194931.24732-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jouni Hogander <jouni.hogander@unikie.com>

[ Upstream commit 3b5a39979dafea9d0cd69c7ae06088f7a84cdafa ]

Driver/net/can/slcan.c is derived from slip.c. Memory leak was detected
by Syzkaller in slcan. Same issue exists in slip.c and this patch is
addressing the leak in slip.c.

Here is the slcan memory leak trace reported by Syzkaller:

BUG: memory leak unreferenced object 0xffff888067f65500 (size 4096):
  comm "syz-executor043", pid 454, jiffies 4294759719 (age 11.930s)
  hex dump (first 32 bytes):
    73 6c 63 61 6e 30 00 00 00 00 00 00 00 00 00 00 slcan0..........
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................
  backtrace:
    [<00000000a06eec0d>] __kmalloc+0x18b/0x2c0
    [<0000000083306e66>] kvmalloc_node+0x3a/0xc0
    [<000000006ac27f87>] alloc_netdev_mqs+0x17a/0x1080
    [<0000000061a996c9>] slcan_open+0x3ae/0x9a0
    [<000000001226f0f9>] tty_ldisc_open.isra.1+0x76/0xc0
    [<0000000019289631>] tty_set_ldisc+0x28c/0x5f0
    [<000000004de5a617>] tty_ioctl+0x48d/0x1590
    [<00000000daef496f>] do_vfs_ioctl+0x1c7/0x1510
    [<0000000059068dbc>] ksys_ioctl+0x99/0xb0
    [<000000009a6eb334>] __x64_sys_ioctl+0x78/0xb0
    [<0000000053d0332e>] do_syscall_64+0x16f/0x580
    [<0000000021b83b99>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
    [<000000008ea75434>] 0xfffffffffffffff

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Jouni Hogander <jouni.hogander@unikie.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/slip/slip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
index 436dd78c396a7..2901b7db9d2e1 100644
--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -859,6 +859,7 @@ static int slip_open(struct tty_struct *tty)
 	sl->tty = NULL;
 	tty->disc_data = NULL;
 	clear_bit(SLF_INUSE, &sl->flags);
+	free_netdev(sl->dev);
 
 err_exit:
 	rtnl_unlock();
-- 
2.20.1


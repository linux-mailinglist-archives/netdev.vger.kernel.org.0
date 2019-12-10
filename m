Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A70E1194FF
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729318AbfLJVRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:17:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:38026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728807AbfLJVMt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:12:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F332214AF;
        Tue, 10 Dec 2019 21:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012368;
        bh=vWM0ZHYxx9xYaIp06F5yfYDOCVuzQvi6mVO4xd9HxW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G7f+mtoHYhcyedw5Xys+fegSrNqx+riavx+Z5M61i4ON7n5NLWXijBEVCTWYra6cg
         LjPdCgopYUqUJWWMFyDlgiScFL8PwZ8k5lo3+sRPopBRANxvwHDCYyRBRXjcWVI0SS
         tAeYoHvlOEhOYp2BlHssu5fq2Qon3ofDEmmR64d8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Petar Penkov <ppenkov@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 295/350] tun: fix data-race in gro_normal_list()
Date:   Tue, 10 Dec 2019 16:06:40 -0500
Message-Id: <20191210210735.9077-256-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petar Penkov <ppenkov@google.com>

[ Upstream commit c39e342a050a4425348e6fe7f75827c0a1a7ebc5 ]

There is a race in the TUN driver between napi_busy_loop and
napi_gro_frags. This commit resolves the race by adding the NAPI struct
via netif_tx_napi_add, instead of netif_napi_add, which disables polling
for the NAPI struct.

KCSAN reported:
BUG: KCSAN: data-race in gro_normal_list.part.0 / napi_busy_loop

write to 0xffff8880b5d474b0 of 4 bytes by task 11205 on cpu 0:
 gro_normal_list.part.0+0x77/0xb0 net/core/dev.c:5682
 gro_normal_list net/core/dev.c:5678 [inline]
 gro_normal_one net/core/dev.c:5692 [inline]
 napi_frags_finish net/core/dev.c:5705 [inline]
 napi_gro_frags+0x625/0x770 net/core/dev.c:5778
 tun_get_user+0x2150/0x26a0 drivers/net/tun.c:1976
 tun_chr_write_iter+0x79/0xd0 drivers/net/tun.c:2022
 call_write_iter include/linux/fs.h:1895 [inline]
 do_iter_readv_writev+0x487/0x5b0 fs/read_write.c:693
 do_iter_write fs/read_write.c:970 [inline]
 do_iter_write+0x13b/0x3c0 fs/read_write.c:951
 vfs_writev+0x118/0x1c0 fs/read_write.c:1015
 do_writev+0xe3/0x250 fs/read_write.c:1058
 __do_sys_writev fs/read_write.c:1131 [inline]
 __se_sys_writev fs/read_write.c:1128 [inline]
 __x64_sys_writev+0x4e/0x60 fs/read_write.c:1128
 do_syscall_64+0xcc/0x370 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

read to 0xffff8880b5d474b0 of 4 bytes by task 11168 on cpu 1:
 gro_normal_list net/core/dev.c:5678 [inline]
 napi_busy_loop+0xda/0x4f0 net/core/dev.c:6126
 sk_busy_loop include/net/busy_poll.h:108 [inline]
 __skb_recv_udp+0x4ad/0x560 net/ipv4/udp.c:1689
 udpv6_recvmsg+0x29e/0xe90 net/ipv6/udp.c:288
 inet6_recvmsg+0xbb/0x240 net/ipv6/af_inet6.c:592
 sock_recvmsg_nosec net/socket.c:871 [inline]
 sock_recvmsg net/socket.c:889 [inline]
 sock_recvmsg+0x92/0xb0 net/socket.c:885
 sock_read_iter+0x15f/0x1e0 net/socket.c:967
 call_read_iter include/linux/fs.h:1889 [inline]
 new_sync_read+0x389/0x4f0 fs/read_write.c:414
 __vfs_read+0xb1/0xc0 fs/read_write.c:427
 vfs_read fs/read_write.c:461 [inline]
 vfs_read+0x143/0x2c0 fs/read_write.c:446
 ksys_read+0xd5/0x1b0 fs/read_write.c:587
 __do_sys_read fs/read_write.c:597 [inline]
 __se_sys_read fs/read_write.c:595 [inline]
 __x64_sys_read+0x4c/0x60 fs/read_write.c:595
 do_syscall_64+0xcc/0x370 arch/x86/entry/common.c:290
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 11168 Comm: syz-executor.0 Not tainted 5.4.0-rc6+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: 943170998b20 ("tun: enable NAPI for TUN/TAP driver")
Signed-off-by: Petar Penkov <ppenkov@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index a8d3141582a53..16564ebcde500 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -313,8 +313,8 @@ static void tun_napi_init(struct tun_struct *tun, struct tun_file *tfile,
 	tfile->napi_enabled = napi_en;
 	tfile->napi_frags_enabled = napi_en && napi_frags;
 	if (napi_en) {
-		netif_napi_add(tun->dev, &tfile->napi, tun_napi_poll,
-			       NAPI_POLL_WEIGHT);
+		netif_tx_napi_add(tun->dev, &tfile->napi, tun_napi_poll,
+				  NAPI_POLL_WEIGHT);
 		napi_enable(&tfile->napi);
 	}
 }
-- 
2.20.1


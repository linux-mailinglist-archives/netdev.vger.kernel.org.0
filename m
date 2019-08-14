Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2888CF19
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 11:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726221AbfHNJMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 05:12:02 -0400
Received: from mail-qt1-f202.google.com ([209.85.160.202]:38554 "EHLO
        mail-qt1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfHNJMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 05:12:02 -0400
Received: by mail-qt1-f202.google.com with SMTP id i13so6870555qtq.5
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 02:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=LZjHGTJXNVoMkySb9EFv36Nm4bNMwzcw1+MXlv5Nd4w=;
        b=jtHvkbb2v1UBG05Onp9j1UyMjamXkTfR1I6vMGV3KduyFYy2rZfWcb+D3/qjBowJMU
         f2puYZ/MTBh5haNksLKhMhiS+gOsOXnpETJrygx4M9vNJ59oyiSlpYn2hIAQVxcbF1r4
         XjBeZuS7LcITy9Svy6GG5riemxS+hlbnlGLhFVFy6fjr/HiQW2R9lDYbmjsEzd9xD1uU
         L86pCRSHIm4WWdwwKezsvUUzzJqUH4aSv1WMbk9uz5uC28vKidGd+W+wNsIXEFGjhQcB
         1PXnIOLKBUjjREAfZ2GQJd6+cnr2L80eRGWkCo7g/a+OeaUBhQ8y+ddnyRmyqlL4Vezn
         PZ+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=LZjHGTJXNVoMkySb9EFv36Nm4bNMwzcw1+MXlv5Nd4w=;
        b=Aj9WXaLGOsqprpAW9PJgcBb0R6n61wk4ulGkFkdGd21yJyhksggVIlHaasbrqYG3nc
         fetqrTdswIjnxwEJ/Rzd3C4duBss6ocbrgdYNoQd0hHxL+Gvv7JgBMmLLx+/C9LNvNOX
         KqTXBak543/A6H3azp/c6uTPG087Kp1KKXreVPmR4t4cQ87YAAFui+OMTWFZJIDLSwB3
         NGAmzH3xYjq1SiJFEBIJVJS9fB74leYbldXNDd1dCFaNx3kOC1KIMlyqv/smyu0fxO8P
         7Rg0mzel7sLbVMh+L2o5H3MZMshiZYKO+RySIQhgigNzWtQS5Bsj5Hmi5CpsuzNZrIzt
         c9HQ==
X-Gm-Message-State: APjAAAXt37GWXtue/U6h6mbRgLST/l5MJ5lfJbLI/vNbjo1UXcP7ZkVw
        naF9WkSuOPXxZCIfLP8O1x1dhxL/EOJYRQ==
X-Google-Smtp-Source: APXvYqwn0VM404RD1dlK27XddefLMOgiOqmCoW2ralj879+ijr8hUM3zfFgCDdu3kdhCoZgB1FyX7ha3VPhagA==
X-Received: by 2002:a0c:f687:: with SMTP id p7mr1696126qvn.160.1565773921113;
 Wed, 14 Aug 2019 02:12:01 -0700 (PDT)
Date:   Wed, 14 Aug 2019 02:11:57 -0700
Message-Id: <20190814091157.215108-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [PATCH net] net/packet: fix race in tpacket_snd()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

packet_sendmsg() checks tx_ring.pg_vec to decide
if it must call tpacket_snd().

Problem is that the check is lockless, meaning another thread
can issue a concurrent setsockopt(PACKET_TX_RING ) to flip
tx_ring.pg_vec back to NULL.

Given that tpacket_snd() grabs pg_vec_lock mutex, we can
perform the check again to solve the race.

syzbot reported :

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 11429 Comm: syz-executor394 Not tainted 5.3.0-rc4+ #101
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:packet_lookup_frame+0x8d/0x270 net/packet/af_packet.c:474
Code: c1 ee 03 f7 73 0c 80 3c 0e 00 0f 85 cb 01 00 00 48 8b 0b 89 c0 4c 8d 24 c1 48 b8 00 00 00 00 00 fc ff df 4c 89 e1 48 c1 e9 03 <80> 3c 01 00 0f 85 94 01 00 00 48 8d 7b 10 4d 8b 3c 24 48 b8 00 00
RSP: 0018:ffff88809f82f7b8 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: ffff8880a45c7030 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 1ffff110148b8e06 RDI: ffff8880a45c703c
RBP: ffff88809f82f7e8 R08: ffff888087aea200 R09: fffffbfff134ae50
R10: fffffbfff134ae4f R11: ffffffff89a5727f R12: 0000000000000000
R13: 0000000000000001 R14: ffff8880a45c6ac0 R15: 0000000000000000
FS:  00007fa04716f700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa04716edb8 CR3: 0000000091eb4000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 packet_current_frame net/packet/af_packet.c:487 [inline]
 tpacket_snd net/packet/af_packet.c:2667 [inline]
 packet_sendmsg+0x590/0x6250 net/packet/af_packet.c:2975
 sock_sendmsg_nosec net/socket.c:637 [inline]
 sock_sendmsg+0xd7/0x130 net/socket.c:657
 ___sys_sendmsg+0x3e2/0x920 net/socket.c:2311
 __sys_sendmmsg+0x1bf/0x4d0 net/socket.c:2413
 __do_sys_sendmmsg net/socket.c:2442 [inline]
 __se_sys_sendmmsg net/socket.c:2439 [inline]
 __x64_sys_sendmmsg+0x9d/0x100 net/socket.c:2439
 do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Fixes: 69e3c75f4d54 ("net: TX_RING and packet mmap")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/packet/af_packet.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 8d54f3047768d2272cbd28a7bcda33df800aa589..e2742b006d255f598fc98953dbb823f615d2bf9a 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2618,6 +2618,13 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 
 	mutex_lock(&po->pg_vec_lock);
 
+	/* packet_sendmsg() check on tx_ring.pg_vec was lockless,
+	 * we need to confirm it under protection of pg_vec_lock.
+	 */
+	if (unlikely(!po->tx_ring.pg_vec)) {
+		err = -EBUSY;
+		goto out;
+	}
 	if (likely(saddr == NULL)) {
 		dev	= packet_cached_dev_get(po);
 		proto	= po->num;
-- 
2.23.0.rc1.153.gdeed80330f-goog


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E587B1B2DA0
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 19:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgDURAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 13:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725994AbgDURAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 13:00:33 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40680C061A41
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 10:00:33 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id u5so14441908qvt.12
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 10:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=IwWVmLssvVNMJiUPgzzKmqdlrJOMWrxYWjDmifIxPpg=;
        b=OvX0CAL12BzFX/mmWPvlo+ehFeYfsLT/D65KMLJ7rXjt+9AfVG8nV+1zORls8zScRz
         zm30ejpZMD93U0+j3tkxi0/oHlt5BFwSA4oUaEgAnaoHkI3HCFPkWY0hscRJaM+w9ojp
         UkWarRJLXip7F0B/Qq1draZEftKDvNexIAVfgy24Gs+t5BpXc/cgtd9Yq07LKB24Ipir
         usD7oTf2JBBmTVNum5BlYqvU9FsLXo6lmI5Zo9sJBBNweceUbMe5xYhuqrT2eRo6akQp
         AHhxoBw2D3K7swIcCCciN4ms9ZX4vTa66NvujWLsRNkJ1Vj/DBKmKo1xq4cLqBfFY+3j
         EjvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=IwWVmLssvVNMJiUPgzzKmqdlrJOMWrxYWjDmifIxPpg=;
        b=CttqjIFHvmqMhCd1qE9hEaB53eTZi2MS0jbqIQO+EGJQ+s8wQFVzKz5PRogeREL18e
         FfZTxZS+zfQIX98hCQYLUaO3Ekt3ycLZmvZw9KOS//PnPp9wwGo0pwUmHzAwo4IRFc9y
         J6OP95HkRE4sF2n59bT2LcgmCPxoafdnSVrAlsTnlqMuhfMZjtDcFTrjlgcjEkVgPMuS
         MrRlOREQAXTLzepzeMj79fRgig56ed8JUCqepwUcj6YZ3fdsPrC++XH43/zsJLSHoIcU
         NJRzlMWi1qHnVXpxsx/Difa0JKRpYAf3tMRan2c33pZtLuDQOTic2IAYoh6JDrK7YJg4
         gKuw==
X-Gm-Message-State: AGi0PuZyxWqARxLLDHQy0vAcJeufaBYG6I5AoFp3VcpC8XoCgL34ioTL
        TI5J70eAD7ZpE4vPlYgDXlxjUPvaLTo8pg==
X-Google-Smtp-Source: APiQypKL4BzZhhERGYwisRlMzJZzVhwUnUWru272i2vIhWAKM8SAhVJ5HpuPTgiUYsfoFPqGO0wEt7nSL19WUw==
X-Received: by 2002:a0c:a983:: with SMTP id a3mr2245693qvb.196.1587488432277;
 Tue, 21 Apr 2020 10:00:32 -0700 (PDT)
Date:   Tue, 21 Apr 2020 10:00:28 -0700
Message-Id: <20200421170028.153025-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH net] sched: etf: do not assume all sockets are full blown
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skb->sk does not always point to a full blown socket,
we need to use sk_fullsock() before accessing fields which
only make sense on full socket.

BUG: KASAN: use-after-free in report_sock_error+0x286/0x300 net/sched/sch_etf.c:141
Read of size 1 at addr ffff88805eb9b245 by task syz-executor.5/9630

CPU: 1 PID: 9630 Comm: syz-executor.5 Not tainted 5.7.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x188/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd3/0x315 mm/kasan/report.c:382
 __kasan_report.cold+0x35/0x4d mm/kasan/report.c:511
 kasan_report+0x33/0x50 mm/kasan/common.c:625
 report_sock_error+0x286/0x300 net/sched/sch_etf.c:141
 etf_enqueue_timesortedlist+0x389/0x740 net/sched/sch_etf.c:170
 __dev_xmit_skb net/core/dev.c:3710 [inline]
 __dev_queue_xmit+0x154a/0x30a0 net/core/dev.c:4021
 neigh_hh_output include/net/neighbour.h:499 [inline]
 neigh_output include/net/neighbour.h:508 [inline]
 ip6_finish_output2+0xfb5/0x25b0 net/ipv6/ip6_output.c:117
 __ip6_finish_output+0x442/0xab0 net/ipv6/ip6_output.c:143
 ip6_finish_output+0x34/0x1f0 net/ipv6/ip6_output.c:153
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip6_output+0x239/0x810 net/ipv6/ip6_output.c:176
 dst_output include/net/dst.h:435 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip6_xmit+0xe1a/0x2090 net/ipv6/ip6_output.c:280
 tcp_v6_send_synack+0x4e7/0x960 net/ipv6/tcp_ipv6.c:521
 tcp_rtx_synack+0x10d/0x1a0 net/ipv4/tcp_output.c:3916
 inet_rtx_syn_ack net/ipv4/inet_connection_sock.c:669 [inline]
 reqsk_timer_handler+0x4c2/0xb40 net/ipv4/inet_connection_sock.c:763
 call_timer_fn+0x1ac/0x780 kernel/time/timer.c:1405
 expire_timers kernel/time/timer.c:1450 [inline]
 __run_timers kernel/time/timer.c:1774 [inline]
 __run_timers kernel/time/timer.c:1741 [inline]
 run_timer_softirq+0x623/0x1600 kernel/time/timer.c:1787
 __do_softirq+0x26c/0x9f7 kernel/softirq.c:292
 invoke_softirq kernel/softirq.c:373 [inline]
 irq_exit+0x192/0x1d0 kernel/softirq.c:413
 exiting_irq arch/x86/include/asm/apic.h:546 [inline]
 smp_apic_timer_interrupt+0x19e/0x600 arch/x86/kernel/apic/apic.c:1140
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
 </IRQ>
RIP: 0010:des_encrypt+0x157/0x9c0 lib/crypto/des.c:792
Code: 85 22 06 00 00 41 31 dc 41 8b 4d 04 44 89 e2 41 83 e4 3f 4a 8d 3c a5 60 72 72 88 81 e2 3f 3f 3f 3f 48 89 f8 48 c1 e8 03 31 d9 <0f> b6 34 28 48 89 f8 c1 c9 04 83 e0 07 83 c0 03 40 38 f0 7c 09 40
RSP: 0018:ffffc90003b5f6c0 EFLAGS: 00000282 ORIG_RAX: ffffffffffffff13
RAX: 1ffffffff10e4e55 RBX: 00000000d2f846d0 RCX: 00000000d2f846d0
RDX: 0000000012380612 RSI: ffffffff839863ca RDI: ffffffff887272a8
RBP: dffffc0000000000 R08: ffff888091d0a380 R09: 0000000000800081
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000012
R13: ffff8880a8ae8078 R14: 00000000c545c93e R15: 0000000000000006
 cipher_crypt_one crypto/cipher.c:75 [inline]
 crypto_cipher_encrypt_one+0x124/0x210 crypto/cipher.c:82
 crypto_cbcmac_digest_update+0x1b5/0x250 crypto/ccm.c:830
 crypto_shash_update+0xc4/0x120 crypto/shash.c:119
 shash_ahash_update+0xa3/0x110 crypto/shash.c:246
 crypto_ahash_update include/crypto/hash.h:547 [inline]
 hash_sendmsg+0x518/0xad0 crypto/algif_hash.c:102
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:672
 ____sys_sendmsg+0x308/0x7e0 net/socket.c:2362
 ___sys_sendmsg+0x100/0x170 net/socket.c:2416
 __sys_sendmmsg+0x195/0x480 net/socket.c:2506
 __do_sys_sendmmsg net/socket.c:2535 [inline]
 __se_sys_sendmmsg net/socket.c:2532 [inline]
 __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2532
 do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x45c829
Code: 0d b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f6d9528ec78 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00000000004fc080 RCX: 000000000045c829
RDX: 0000000000000001 RSI: 0000000020002640 RDI: 0000000000000004
RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000000008d7 R14: 00000000004cb7aa R15: 00007f6d9528f6d4

Fixes: 4b15c7075352 ("net/sched: Make etf report drops on error_queue")
Fixes: 25db26a91364 ("net/sched: Introduce the ETF Qdisc")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 net/sched/sch_etf.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_etf.c b/net/sched/sch_etf.c
index b1da5589a0c6a2c9db9912430dca3d5f06fff10c..c48f91075b5c60ee4fe9e10186c913baf5894a69 100644
--- a/net/sched/sch_etf.c
+++ b/net/sched/sch_etf.c
@@ -82,7 +82,7 @@ static bool is_packet_valid(struct Qdisc *sch, struct sk_buff *nskb)
 	if (q->skip_sock_check)
 		goto skip;
 
-	if (!sk)
+	if (!sk || !sk_fullsock(sk))
 		return false;
 
 	if (!sock_flag(sk, SOCK_TXTIME))
@@ -137,8 +137,9 @@ static void report_sock_error(struct sk_buff *skb, u32 err, u8 code)
 	struct sock_exterr_skb *serr;
 	struct sk_buff *clone;
 	ktime_t txtime = skb->tstamp;
+	struct sock *sk = skb->sk;
 
-	if (!skb->sk || !(skb->sk->sk_txtime_report_errors))
+	if (!sk || !sk_fullsock(sk) || !(sk->sk_txtime_report_errors))
 		return;
 
 	clone = skb_clone(skb, GFP_ATOMIC);
@@ -154,7 +155,7 @@ static void report_sock_error(struct sk_buff *skb, u32 err, u8 code)
 	serr->ee.ee_data = (txtime >> 32); /* high part of tstamp */
 	serr->ee.ee_info = txtime; /* low part of tstamp */
 
-	if (sock_queue_err_skb(skb->sk, clone))
+	if (sock_queue_err_skb(sk, clone))
 		kfree_skb(clone);
 }
 
-- 
2.26.1.301.g55bc3eb7cb9-goog


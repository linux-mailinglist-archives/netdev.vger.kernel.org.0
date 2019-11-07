Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14172F3746
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 19:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727428AbfKGSbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 13:31:46 -0500
Received: from mail-pg1-f201.google.com ([209.85.215.201]:36722 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbfKGSbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 13:31:46 -0500
Received: by mail-pg1-f201.google.com with SMTP id h12so2508081pgd.3
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 10:31:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ThXBy1OSxNdmsrmn8Bx9L/WNnRuVK2l5s3niOfYbIaU=;
        b=oJYQlcEEn1M4VTmntNiEbk1uoZT4Ae5J7wn6UDmC965uZKkgJwv7D9Hj+2Js6U1akA
         oMLwb3fWuLqh+Fr1617ZD8iNcJec0+ctiJbob0e+a9Is+F3p0rPq6gh0UVPkislZC5YZ
         lS3x/uxyiEXjBmVtBFWlk5uIqUHa3LRNQRjakGMFn8QBkuGtrnd92CNP4azshmhgzY+V
         iwoNKZf0odhdgszFvEXJobr4mqgPyZOd1MqcMj0KvO2tSVusR8Nr0cehM6E30v1cj7rf
         MjzLzy/MV7c020wvUrEWx5kPCHG0SIvjgCoMwv/LscRAInNS12TmfYiukppxF7KhdW+V
         4TJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ThXBy1OSxNdmsrmn8Bx9L/WNnRuVK2l5s3niOfYbIaU=;
        b=P6hDrIHjmQ8iW65IPDvuLZRQ55ApnCoXv9ESaHRLMU3QWyv45QvzRoI8nJIxPuIkPW
         Xwhp9QxVborA3tfhFk239o4KK5j3lfkxJQF7x9k4G7mCtjlrKB3IRxdEoKhPPx4DITjX
         QRwrxYD5hEnsjJQkmmqDVulmS44/rLQm+gKlRx03L8MKfH7tFXkhaxmdtN1oGw3dsuzL
         eaI4XtSd8bM5QhVRC8z2B1S96nmfy+gVmrkByfe0w9RI4dW11xBVos3aHfnd7zBpcvUa
         H3znjuR8Bfa5s8ZrpTWTjLpi1Zk5iJONYCm7apjA/33NftyUqid9OGM0dxS4P25eU6Vz
         QIKA==
X-Gm-Message-State: APjAAAVVLjFHPOeKOwcIqHiJLFtE/ZEp6+/LEedxv2dL2HRzfqFF6jI9
        5+4YbAAgx/TtlV0STvkjoDoFClq7xbh78g==
X-Google-Smtp-Source: APXvYqwOApGX1s6E/A7XI399RXs3JlSrCwOsxKn+8qG/gsyMXaMrXnTB7q/9HO5+4c7hDRsDI90rzEHbjKRFYw==
X-Received: by 2002:a63:ff46:: with SMTP id s6mr3148151pgk.337.1573151505193;
 Thu, 07 Nov 2019 10:31:45 -0800 (PST)
Date:   Thu,  7 Nov 2019 10:30:42 -0800
Message-Id: <20191107183042.6286-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH net-next] inetpeer: fix data-race in inet_putpeer / inet_putpeer
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

We need to explicitely forbid read/store tearing in inet_peer_gc()
and inet_putpeer().

The following syzbot report reminds us about inet_putpeer()
running without a lock held.

BUG: KCSAN: data-race in inet_putpeer / inet_putpeer

write to 0xffff888121fb2ed0 of 4 bytes by interrupt on cpu 0:
 inet_putpeer+0x37/0xa0 net/ipv4/inetpeer.c:240
 ip4_frag_free+0x3d/0x50 net/ipv4/ip_fragment.c:102
 inet_frag_destroy_rcu+0x58/0x80 net/ipv4/inet_fragment.c:228
 __rcu_reclaim kernel/rcu/rcu.h:222 [inline]
 rcu_do_batch+0x256/0x5b0 kernel/rcu/tree.c:2157
 rcu_core+0x369/0x4d0 kernel/rcu/tree.c:2377
 rcu_core_si+0x12/0x20 kernel/rcu/tree.c:2386
 __do_softirq+0x115/0x33f kernel/softirq.c:292
 invoke_softirq kernel/softirq.c:373 [inline]
 irq_exit+0xbb/0xe0 kernel/softirq.c:413
 exiting_irq arch/x86/include/asm/apic.h:536 [inline]
 smp_apic_timer_interrupt+0xe6/0x280 arch/x86/kernel/apic/apic.c:1137
 apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:830
 native_safe_halt+0xe/0x10 arch/x86/kernel/paravirt.c:71
 arch_cpu_idle+0x1f/0x30 arch/x86/kernel/process.c:571
 default_idle_call+0x1e/0x40 kernel/sched/idle.c:94
 cpuidle_idle_call kernel/sched/idle.c:154 [inline]
 do_idle+0x1af/0x280 kernel/sched/idle.c:263

write to 0xffff888121fb2ed0 of 4 bytes by interrupt on cpu 1:
 inet_putpeer+0x37/0xa0 net/ipv4/inetpeer.c:240
 ip4_frag_free+0x3d/0x50 net/ipv4/ip_fragment.c:102
 inet_frag_destroy_rcu+0x58/0x80 net/ipv4/inet_fragment.c:228
 __rcu_reclaim kernel/rcu/rcu.h:222 [inline]
 rcu_do_batch+0x256/0x5b0 kernel/rcu/tree.c:2157
 rcu_core+0x369/0x4d0 kernel/rcu/tree.c:2377
 rcu_core_si+0x12/0x20 kernel/rcu/tree.c:2386
 __do_softirq+0x115/0x33f kernel/softirq.c:292
 run_ksoftirqd+0x46/0x60 kernel/softirq.c:603
 smpboot_thread_fn+0x37d/0x4a0 kernel/smpboot.c:165
 kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 16 Comm: ksoftirqd/1 Not tainted 5.4.0-rc3+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: 4b9d9be839fd ("inetpeer: remove unused list")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/ipv4/inetpeer.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/inetpeer.c b/net/ipv4/inetpeer.c
index be778599bfedf73be139f67e814d46092a88dc40..ff327a62c9ce9b1794104c3c924f5f2b9820ac8b 100644
--- a/net/ipv4/inetpeer.c
+++ b/net/ipv4/inetpeer.c
@@ -160,7 +160,12 @@ static void inet_peer_gc(struct inet_peer_base *base,
 					base->total / inet_peer_threshold * HZ;
 	for (i = 0; i < gc_cnt; i++) {
 		p = gc_stack[i];
-		delta = (__u32)jiffies - p->dtime;
+
+		/* The READ_ONCE() pairs with the WRITE_ONCE()
+		 * in inet_putpeer()
+		 */
+		delta = (__u32)jiffies - READ_ONCE(p->dtime);
+
 		if (delta < ttl || !refcount_dec_if_one(&p->refcnt))
 			gc_stack[i] = NULL;
 	}
@@ -237,7 +242,10 @@ EXPORT_SYMBOL_GPL(inet_getpeer);
 
 void inet_putpeer(struct inet_peer *p)
 {
-	p->dtime = (__u32)jiffies;
+	/* The WRITE_ONCE() pairs with itself (we run lockless)
+	 * and the READ_ONCE() in inet_peer_gc()
+	 */
+	WRITE_ONCE(p->dtime, (__u32)jiffies);
 
 	if (refcount_dec_and_test(&p->refcnt))
 		call_rcu(&p->rcu, inetpeer_free_rcu);
-- 
2.24.0.432.g9d3f5f5b63-goog


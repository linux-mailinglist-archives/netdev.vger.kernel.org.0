Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF342F6958
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 19:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729781AbhANST4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 13:19:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729731AbhANSTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 13:19:49 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B79C0613D3
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 10:19:34 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id j1so3335707pld.3
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 10:19:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e/tD7s21IDX+809lyC7g+BCVJzaRUkwjPBIzrtH0G6w=;
        b=pPMGylkK5l0IHp0cCH9zxw40FOuwJyfGT9+o0pnbkpP92Z5Rd94Nm4lI7mVouyURtw
         4+7bNsBSvD3yCz3EZAOtrtF8mHcN6qhTzp7W0fk91Tc0V8pMwvV524JjBY6VH1KjrsZI
         HgjqNkLB44mkDKIqAvU+VbkM1FQl+i0YwmKolUnyPO62cxUPvi6+LfRUSoflLxpO3nRb
         IIQHjinKHWbeFWJvYu1N+Z3jgC2jzWwLD714J7yfpebNa/gfyQmY3ZI4E1ascnxALQUh
         saRIi13wD/UexWT44PwLQ+kweb8bZTQTdM/xYGKSRkm797R9EyyqZFo+sk5iMfH3T5Pd
         s7mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=e/tD7s21IDX+809lyC7g+BCVJzaRUkwjPBIzrtH0G6w=;
        b=I5yb+yjxXp95PK/CbuygDuyZmeTfkrZvpUQ1iDWcm/FhbsGBPA6NSNJaELjWhsJSN7
         meBjIFGlQSa2iNQReMpp3u2BgK8BMM0fsXBNyBAfsvoUqLzYky6u2OOR++VClNFkR1cv
         HvimXzWhomDQQW9y+N5Oke+GT58oiXBAwSJ6vw/JmqX8CytZZZKNp8cbnIn+skqEFy6w
         P0fpdDGaJaPz7SY555B9+7SQJTsa9QS3K+uXLBjTjy+FV8GI2h2Gd5hnE433NbPt5op2
         nAFt5PltSKJne8jkGO3rFiS+5kIZSgIaMEUMCrZm0TgnxWSrsW9a2UxpTJeUVhEyoLvE
         jNBA==
X-Gm-Message-State: AOAM5309R3xUWmdOymNZ8Xaq+wioWjXjpiw4qRLbZTo3tM0bBMfJ5rYe
        Vo/I4qlxdSLe2mERKAHEIDI=
X-Google-Smtp-Source: ABdhPJxQLZQDpjYsCH5S5+jnc9O6ipwShDYHRrH8+ESdqOO3kTHfuuz9rap38w6dEoURjzr+DqqFyg==
X-Received: by 2002:a17:902:a5cb:b029:dc:2706:4cc8 with SMTP id t11-20020a170902a5cbb02900dc27064cc8mr8685054plq.62.1610648373892;
        Thu, 14 Jan 2021 10:19:33 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
        by smtp.gmail.com with ESMTPSA id m16sm5988471pjv.25.2021.01.14.10.19.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 10:19:33 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] net_sched: gen_estimator: support large ewma log
Date:   Thu, 14 Jan 2021 10:19:29 -0800
Message-Id: <20210114181929.1717985-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

syzbot report reminded us that very big ewma_log were supported in the past,
even if they made litle sense.

tc qdisc replace dev xxx root est 1sec 131072sec ...

While fixing the bug, also add boundary checks for ewma_log, in line
with range supported by iproute2.

UBSAN: shift-out-of-bounds in net/core/gen_estimator.c:83:38
shift exponent -1 is negative
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.10.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
 __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x181 lib/ubsan.c:395
 est_timer.cold+0xbb/0x12d net/core/gen_estimator.c:83
 call_timer_fn+0x1a5/0x710 kernel/time/timer.c:1417
 expire_timers kernel/time/timer.c:1462 [inline]
 __run_timers.part.0+0x692/0xa80 kernel/time/timer.c:1731
 __run_timers kernel/time/timer.c:1712 [inline]
 run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1744
 __do_softirq+0x2bc/0xa77 kernel/softirq.c:343
 asm_call_irq_on_stack+0xf/0x20
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:26 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:77 [inline]
 do_softirq_own_stack+0xaa/0xd0 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:226 [inline]
 __irq_exit_rcu+0x17f/0x200 kernel/softirq.c:420
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:432
 sysvec_apic_timer_interrupt+0x4d/0x100 arch/x86/kernel/apic/apic.c:1096
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:628
RIP: 0010:native_save_fl arch/x86/include/asm/irqflags.h:29 [inline]
RIP: 0010:arch_local_save_flags arch/x86/include/asm/irqflags.h:79 [inline]
RIP: 0010:arch_irqs_disabled arch/x86/include/asm/irqflags.h:169 [inline]
RIP: 0010:acpi_safe_halt drivers/acpi/processor_idle.c:111 [inline]
RIP: 0010:acpi_idle_do_entry+0x1c9/0x250 drivers/acpi/processor_idle.c:516

Fixes: 1c0d32fde5bd ("net_sched: gen_estimator: complete rewrite of rate estimators")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/core/gen_estimator.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/core/gen_estimator.c b/net/core/gen_estimator.c
index 80dbf2f4016e26824bc968115503ca2072933f63..8e582e29a41e39809cc534865bb3c91c05b3d9f2 100644
--- a/net/core/gen_estimator.c
+++ b/net/core/gen_estimator.c
@@ -80,11 +80,11 @@ static void est_timer(struct timer_list *t)
 	u64 rate, brate;
 
 	est_fetch_counters(est, &b);
-	brate = (b.bytes - est->last_bytes) << (10 - est->ewma_log - est->intvl_log);
-	brate -= (est->avbps >> est->ewma_log);
+	brate = (b.bytes - est->last_bytes) << (10 - est->intvl_log);
+	brate = (brate >> est->ewma_log) - (est->avbps >> est->ewma_log);
 
-	rate = (b.packets - est->last_packets) << (10 - est->ewma_log - est->intvl_log);
-	rate -= (est->avpps >> est->ewma_log);
+	rate = (b.packets - est->last_packets) << (10 - est->intvl_log);
+	rate = (rate >> est->ewma_log) - (est->avpps >> est->ewma_log);
 
 	write_seqcount_begin(&est->seq);
 	est->avbps += brate;
@@ -143,6 +143,9 @@ int gen_new_estimator(struct gnet_stats_basic_packed *bstats,
 	if (parm->interval < -2 || parm->interval > 3)
 		return -EINVAL;
 
+	if (parm->ewma_log == 0 || parm->ewma_log >= 31)
+		return -EINVAL;
+
 	est = kzalloc(sizeof(*est), GFP_KERNEL);
 	if (!est)
 		return -ENOBUFS;
-- 
2.30.0.284.gd98b1dd5eaa7-goog


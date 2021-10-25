Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAA06439E3B
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 20:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbhJYSSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 14:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231583AbhJYSSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 14:18:21 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0D2C061745
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 11:15:58 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id i5so8498702pla.5
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 11:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7K8t6I4PSf/AYb0ACXiP/vEYMnl1yg+EAv7W1hgmM0E=;
        b=gnULa0pGrUP5rm7bPYFw8N44rWaVCxQAQ458JoBwyPSJmdb1fdqysgjT2T/RwK6IVC
         JRdeOYFRVeE++Y/W73CW3p17iXW176maQsJBVousk08VqTHO0f4V46Ov/j+TRJ0SM9TA
         fcu1NVeSVVU/N4Lcrltucw1IDz/8aIwmBF9B30qOVWcZ2py4gVDA2ru/4AHQB9KivTvt
         QWcr+yiooArpUAwnMXAfcyEW4JLvljbOkizZGTyKRjQggnmzdJcfdrU9OPB8zumglSfX
         EImkybo+SJGxJhiEBic6JvVQDNjJZlQ/ByqQtD+xeBSfzUrnhwVq8kghLirc4/nhHRWT
         zU8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7K8t6I4PSf/AYb0ACXiP/vEYMnl1yg+EAv7W1hgmM0E=;
        b=SI8AKKMEGEjr4lAnx80kf6h8P5QdxYdOB7uOaqKcOrthDddNvsNSJFvSbzKXuDitBn
         YMYV9vtyhsSX1tec8lgqA/IJvxwDk8CcIZkh/9cablx8bPeLy/9pJ5yBDbO6l/tfbDeL
         s8JbOxsMm1e5Ve5gjUuD46H5vf65lBeUxng6IAeRw+CBYQJFPK6brs2GJ3NWUOx58Tp9
         yGilQe9c3JH/g6RfvGjwvPS4y+iS8562SH2nGRSwr8wfs25y55qBsSdIonCGrcpT9XcP
         cALAEedRkDaK/tRXo2CKYgdYtUkjYJ9rRUyF3xjoBa2UWf5mCxwEQDmBvKxBS9jNSsDz
         8ydw==
X-Gm-Message-State: AOAM530Zyq3cx8Zt7pjcdeEfbxZNo8/qNizgpqUy28S6A8u+PZhSrc2Z
        TQNFHHnA8nREOKDgyG2tw9xzsaotnR8=
X-Google-Smtp-Source: ABdhPJwVj5RmF6MrnfyEtGIAYBBgkYEwoUHTyp8LgiCe/Ik/Q5W471tiEw6uOo7LOCb6IGHsah1QJg==
X-Received: by 2002:a17:903:1cd:b0:140:43f0:353c with SMTP id e13-20020a17090301cd00b0014043f0353cmr11230690plh.81.1635185758216;
        Mon, 25 Oct 2021 11:15:58 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:b7cd:daa3:a144:1652])
        by smtp.gmail.com with ESMTPSA id j1sm6015149pgb.5.2021.10.25.11.15.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 11:15:57 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net-next] net: annotate data-race in neigh_output()
Date:   Mon, 25 Oct 2021 11:15:55 -0700
Message-Id: <20211025181555.673034-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

neigh_output() reads n->nud_state and hh->hh_len locklessly.

This is fine, but we need to add annotations and document this.

We evaluate skip_cache first to avoid reading these fields
if the cache has to by bypassed.

syzbot report:

BUG: KCSAN: data-race in __neigh_event_send / ip_finish_output2

write to 0xffff88810798a885 of 1 bytes by interrupt on cpu 1:
 __neigh_event_send+0x40d/0xac0 net/core/neighbour.c:1128
 neigh_event_send include/net/neighbour.h:444 [inline]
 neigh_resolve_output+0x104/0x410 net/core/neighbour.c:1476
 neigh_output include/net/neighbour.h:510 [inline]
 ip_finish_output2+0x80a/0xaa0 net/ipv4/ip_output.c:221
 ip_finish_output+0x3b5/0x510 net/ipv4/ip_output.c:309
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip_output+0xf3/0x1a0 net/ipv4/ip_output.c:423
 dst_output include/net/dst.h:450 [inline]
 ip_local_out+0x164/0x220 net/ipv4/ip_output.c:126
 __ip_queue_xmit+0x9d3/0xa20 net/ipv4/ip_output.c:525
 ip_queue_xmit+0x34/0x40 net/ipv4/ip_output.c:539
 __tcp_transmit_skb+0x142a/0x1a00 net/ipv4/tcp_output.c:1405
 tcp_transmit_skb net/ipv4/tcp_output.c:1423 [inline]
 tcp_xmit_probe_skb net/ipv4/tcp_output.c:4011 [inline]
 tcp_write_wakeup+0x4a9/0x810 net/ipv4/tcp_output.c:4064
 tcp_send_probe0+0x2c/0x2b0 net/ipv4/tcp_output.c:4079
 tcp_probe_timer net/ipv4/tcp_timer.c:398 [inline]
 tcp_write_timer_handler+0x394/0x520 net/ipv4/tcp_timer.c:626
 tcp_write_timer+0xb9/0x180 net/ipv4/tcp_timer.c:642
 call_timer_fn+0x2e/0x1d0 kernel/time/timer.c:1421
 expire_timers+0x135/0x240 kernel/time/timer.c:1466
 __run_timers+0x368/0x430 kernel/time/timer.c:1734
 run_timer_softirq+0x19/0x30 kernel/time/timer.c:1747
 __do_softirq+0x12c/0x26e kernel/softirq.c:558
 invoke_softirq kernel/softirq.c:432 [inline]
 __irq_exit_rcu kernel/softirq.c:636 [inline]
 irq_exit_rcu+0x4e/0xa0 kernel/softirq.c:648
 sysvec_apic_timer_interrupt+0x69/0x80 arch/x86/kernel/apic/apic.c:1097
 asm_sysvec_apic_timer_interrupt+0x12/0x20
 native_safe_halt arch/x86/include/asm/irqflags.h:51 [inline]
 arch_safe_halt arch/x86/include/asm/irqflags.h:89 [inline]
 acpi_safe_halt drivers/acpi/processor_idle.c:109 [inline]
 acpi_idle_do_entry drivers/acpi/processor_idle.c:553 [inline]
 acpi_idle_enter+0x258/0x2e0 drivers/acpi/processor_idle.c:688
 cpuidle_enter_state+0x2b4/0x760 drivers/cpuidle/cpuidle.c:237
 cpuidle_enter+0x3c/0x60 drivers/cpuidle/cpuidle.c:351
 call_cpuidle kernel/sched/idle.c:158 [inline]
 cpuidle_idle_call kernel/sched/idle.c:239 [inline]
 do_idle+0x1a3/0x250 kernel/sched/idle.c:306
 cpu_startup_entry+0x15/0x20 kernel/sched/idle.c:403
 secondary_startup_64_no_verify+0xb1/0xbb

read to 0xffff88810798a885 of 1 bytes by interrupt on cpu 0:
 neigh_output include/net/neighbour.h:507 [inline]
 ip_finish_output2+0x79a/0xaa0 net/ipv4/ip_output.c:221
 ip_finish_output+0x3b5/0x510 net/ipv4/ip_output.c:309
 NF_HOOK_COND include/linux/netfilter.h:296 [inline]
 ip_output+0xf3/0x1a0 net/ipv4/ip_output.c:423
 dst_output include/net/dst.h:450 [inline]
 ip_local_out+0x164/0x220 net/ipv4/ip_output.c:126
 __ip_queue_xmit+0x9d3/0xa20 net/ipv4/ip_output.c:525
 ip_queue_xmit+0x34/0x40 net/ipv4/ip_output.c:539
 __tcp_transmit_skb+0x142a/0x1a00 net/ipv4/tcp_output.c:1405
 tcp_transmit_skb net/ipv4/tcp_output.c:1423 [inline]
 tcp_xmit_probe_skb net/ipv4/tcp_output.c:4011 [inline]
 tcp_write_wakeup+0x4a9/0x810 net/ipv4/tcp_output.c:4064
 tcp_send_probe0+0x2c/0x2b0 net/ipv4/tcp_output.c:4079
 tcp_probe_timer net/ipv4/tcp_timer.c:398 [inline]
 tcp_write_timer_handler+0x394/0x520 net/ipv4/tcp_timer.c:626
 tcp_write_timer+0xb9/0x180 net/ipv4/tcp_timer.c:642
 call_timer_fn+0x2e/0x1d0 kernel/time/timer.c:1421
 expire_timers+0x135/0x240 kernel/time/timer.c:1466
 __run_timers+0x368/0x430 kernel/time/timer.c:1734
 run_timer_softirq+0x19/0x30 kernel/time/timer.c:1747
 __do_softirq+0x12c/0x26e kernel/softirq.c:558
 invoke_softirq kernel/softirq.c:432 [inline]
 __irq_exit_rcu kernel/softirq.c:636 [inline]
 irq_exit_rcu+0x4e/0xa0 kernel/softirq.c:648
 sysvec_apic_timer_interrupt+0x69/0x80 arch/x86/kernel/apic/apic.c:1097
 asm_sysvec_apic_timer_interrupt+0x12/0x20
 native_safe_halt arch/x86/include/asm/irqflags.h:51 [inline]
 arch_safe_halt arch/x86/include/asm/irqflags.h:89 [inline]
 acpi_safe_halt drivers/acpi/processor_idle.c:109 [inline]
 acpi_idle_do_entry drivers/acpi/processor_idle.c:553 [inline]
 acpi_idle_enter+0x258/0x2e0 drivers/acpi/processor_idle.c:688
 cpuidle_enter_state+0x2b4/0x760 drivers/cpuidle/cpuidle.c:237
 cpuidle_enter+0x3c/0x60 drivers/cpuidle/cpuidle.c:351
 call_cpuidle kernel/sched/idle.c:158 [inline]
 cpuidle_idle_call kernel/sched/idle.c:239 [inline]
 do_idle+0x1a3/0x250 kernel/sched/idle.c:306
 cpu_startup_entry+0x15/0x20 kernel/sched/idle.c:403
 rest_init+0xee/0x100 init/main.c:734
 arch_call_rest_init+0xa/0xb
 start_kernel+0x5e4/0x669 init/main.c:1142
 secondary_startup_64_no_verify+0xb1/0xbb

value changed: 0x20 -> 0x01

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.15.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 include/net/neighbour.h | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index e8e48be667552b20650d52941b48e405b7d0d9bd..38a0c1d2457087c2683792ec3b2277d071349bb9 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -516,10 +516,15 @@ static inline int neigh_output(struct neighbour *n, struct sk_buff *skb,
 {
 	const struct hh_cache *hh = &n->hh;
 
-	if ((n->nud_state & NUD_CONNECTED) && hh->hh_len && !skip_cache)
+	/* n->nud_state and hh->hh_len could be changed under us.
+	 * neigh_hh_output() is taking care of the race later.
+	 */
+	if (!skip_cache &&
+	    (READ_ONCE(n->nud_state) & NUD_CONNECTED) &&
+	    READ_ONCE(hh->hh_len))
 		return neigh_hh_output(hh, skb);
-	else
-		return n->output(n, skb);
+
+	return n->output(n, skb);
 }
 
 static inline struct neighbour *
-- 
2.33.0.1079.g6e70778dc9-goog


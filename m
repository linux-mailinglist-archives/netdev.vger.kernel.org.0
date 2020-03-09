Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F414F17EC5B
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 23:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbgCIW5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 18:57:09 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:53038 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbgCIW5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 18:57:09 -0400
Received: by mail-pf1-f202.google.com with SMTP id v26so7780020pfn.19
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 15:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=xyqo8GYR9vr4X7dDfjaXpDTaX8ZQSuWjqS3iClkGBmk=;
        b=mRYxjdx37lZkqtaR9FGp2Yh6LrqYxLFDIt/R8XhhwQHUzSocujzKu32CQaS2Pl+0Bb
         LrGG8R5efNF+lAthCXEVoBZicmTqVYwaJzYc5/fhVvAWKDSIvsbBmAdP3N7UKvYdAYdi
         4ZM9RMNBPt/yy/Clyd+0sSDNAZ5HpMISAo9dkl54Bvgiz/ndIlaUFBgDr3b6aCPM6fll
         3MwwXUdmmvh65HLpAXpjRAcuPahE6ywsQypCblb/QxRlrh3QviIy2B2xmCg0x+yWG7ZT
         +WefrPKv51qlgiHmVY1DQHkd1HBZ1hGO1PD92PfxhVE80GN+BYqBXQ76I1/iB6VSngNm
         sXkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=xyqo8GYR9vr4X7dDfjaXpDTaX8ZQSuWjqS3iClkGBmk=;
        b=chgAi8NZqKdcFYAzi60Io/D3EqTlqN/dH0eCwiKpPzuJaGS2Jx3XuBzYZ7GTRALFAp
         +GDu6c4Qd2ZslAya3V5FnIvbPPcXYbNTo1LV6zq97PZrmE2Xd3lMaJ5f8ypXsyTCVhWY
         qcfWweH2Sa3Lee9X3KjpJzusNsvkBecv9qhajgvT+gAvhV5IvuLaUkwjwecXLzg5t/nG
         YGcqVScA+7jVVkR3urer0Q92wps/UH8AG37lUQ16UjFSD2rXbkzBRkCaeYAL15mC+1Zl
         Ntew92lVzxmoTgImXwzaRvhn3l9TxsSFoYrCVrW/fjlmHUAze4ciUzdndtdVpv7WRkXv
         7D3g==
X-Gm-Message-State: ANhLgQ1XyBFWB7wiA0qPJX4oG4KNn6HBzV/zc1msrSQb1AwjvP0KHwSA
        Fah2wvGvVkGKV+Biit/eSonNeABMT/U1
X-Google-Smtp-Source: ADFU+vt1RF3/RYrX9nPVbMuSwtNOUtBt75gs2+djugWQhK7o2VNMId2Y9SwV+64gw4UHCc/ODKbpDdJ0uufg
X-Received: by 2002:a17:90a:aa0c:: with SMTP id k12mr1667846pjq.193.1583794626394;
 Mon, 09 Mar 2020 15:57:06 -0700 (PDT)
Date:   Mon,  9 Mar 2020 15:57:02 -0700
Message-Id: <20200309225702.63695-1-maheshb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
Subject: [PATCH net] ipvlan: add cond_resched_rcu() while processing muticast backlog
From:   Mahesh Bandewar <maheshb@google.com>
To:     David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        Mahesh Bandewar <maheshb@google.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If there are substantial number of slaves created as simulated by
Syzbot, the backlog processing could take much longer and result
into the issue found in the Syzbot report.

INFO: rcu_sched detected stalls on CPUs/tasks:
        (detected by 1, t=3D10502 jiffies, g=3D5049, c=3D5048, q=3D752)
All QSes seen, last rcu_sched kthread activity 10502 (4294965563-4294955061=
), jiffies_till_next_fqs=3D1, root ->qsmask 0x0
syz-executor.1  R  running task on cpu   1  10984 11210   3866 0x30020008 1=
79034491270
Call Trace:
 <IRQ>
 [<ffffffff81497163>] _sched_show_task kernel/sched/core.c:8063 [inline]
 [<ffffffff81497163>] _sched_show_task.cold+0x2fd/0x392 kernel/sched/core.c=
:8030
 [<ffffffff8146a91b>] sched_show_task+0xb/0x10 kernel/sched/core.c:8073
 [<ffffffff815c931b>] print_other_cpu_stall kernel/rcu/tree.c:1577 [inline]
 [<ffffffff815c931b>] check_cpu_stall kernel/rcu/tree.c:1695 [inline]
 [<ffffffff815c931b>] __rcu_pending kernel/rcu/tree.c:3478 [inline]
 [<ffffffff815c931b>] rcu_pending kernel/rcu/tree.c:3540 [inline]
 [<ffffffff815c931b>] rcu_check_callbacks.cold+0xbb4/0xc29 kernel/rcu/tree.=
c:2876
 [<ffffffff815e3962>] update_process_times+0x32/0x80 kernel/time/timer.c:16=
35
 [<ffffffff816164f0>] tick_sched_handle+0xa0/0x180 kernel/time/tick-sched.c=
:161
 [<ffffffff81616ae4>] tick_sched_timer+0x44/0x130 kernel/time/tick-sched.c:=
1193
 [<ffffffff815e75f7>] __run_hrtimer kernel/time/hrtimer.c:1393 [inline]
 [<ffffffff815e75f7>] __hrtimer_run_queues+0x307/0xd90 kernel/time/hrtimer.=
c:1455
 [<ffffffff815e90ea>] hrtimer_interrupt+0x2ea/0x730 kernel/time/hrtimer.c:1=
513
 [<ffffffff844050f4>] local_apic_timer_interrupt arch/x86/kernel/apic/apic.=
c:1031 [inline]
 [<ffffffff844050f4>] smp_apic_timer_interrupt+0x144/0x5e0 arch/x86/kernel/=
apic/apic.c:1056
 [<ffffffff84401cbe>] apic_timer_interrupt+0x8e/0xa0 arch/x86/entry/entry_6=
4.S:778
RIP: 0010:do_raw_read_lock+0x22/0x80 kernel/locking/spinlock_debug.c:153
RSP: 0018:ffff8801dad07ab8 EFLAGS: 00000a02 ORIG_RAX: ffffffffffffff12
RAX: 0000000000000000 RBX: ffff8801c4135680 RCX: 0000000000000000
RDX: 1ffff10038826afe RSI: ffff88019d816bb8 RDI: ffff8801c41357f0
RBP: ffff8801dad07ac0 R08: 0000000000004b15 R09: 0000000000310273
R10: ffff88019d816bb8 R11: 0000000000000001 R12: ffff8801c41357e8
R13: 0000000000000000 R14: ffff8801cfb19850 R15: ffff8801cfb198b0
 [<ffffffff8101460e>] __raw_read_lock_bh include/linux/rwlock_api_smp.h:177=
 [inline]
 [<ffffffff8101460e>] _raw_read_lock_bh+0x3e/0x50 kernel/locking/spinlock.c=
:240
 [<ffffffff840d78ca>] ipv6_chk_mcast_addr+0x11a/0x6f0 net/ipv6/mcast.c:1006
 [<ffffffff84023439>] ip6_mc_input+0x319/0x8e0 net/ipv6/ip6_input.c:482
 [<ffffffff840211c8>] dst_input include/net/dst.h:449 [inline]
 [<ffffffff840211c8>] ip6_rcv_finish+0x408/0x610 net/ipv6/ip6_input.c:78
 [<ffffffff840214de>] NF_HOOK include/linux/netfilter.h:292 [inline]
 [<ffffffff840214de>] NF_HOOK include/linux/netfilter.h:286 [inline]
 [<ffffffff840214de>] ipv6_rcv+0x10e/0x420 net/ipv6/ip6_input.c:278
 [<ffffffff83a29efa>] __netif_receive_skb_one_core+0x12a/0x1f0 net/core/dev=
.c:5303
 [<ffffffff83a2a15c>] __netif_receive_skb+0x2c/0x1b0 net/core/dev.c:5417
 [<ffffffff83a2f536>] process_backlog+0x216/0x6c0 net/core/dev.c:6243
 [<ffffffff83a30d1b>] napi_poll net/core/dev.c:6680 [inline]
 [<ffffffff83a30d1b>] net_rx_action+0x47b/0xfb0 net/core/dev.c:6748
 [<ffffffff846002c8>] __do_softirq+0x2c8/0x99a kernel/softirq.c:317
 [<ffffffff813e656a>] invoke_softirq kernel/softirq.c:399 [inline]
 [<ffffffff813e656a>] irq_exit+0x16a/0x1a0 kernel/softirq.c:439
 [<ffffffff84405115>] exiting_irq arch/x86/include/asm/apic.h:561 [inline]
 [<ffffffff84405115>] smp_apic_timer_interrupt+0x165/0x5e0 arch/x86/kernel/=
apic/apic.c:1058
 [<ffffffff84401cbe>] apic_timer_interrupt+0x8e/0xa0 arch/x86/entry/entry_6=
4.S:778
 </IRQ>
RIP: 0010:__sanitizer_cov_trace_pc+0x26/0x50 kernel/kcov.c:102
RSP: 0018:ffff880196033bd8 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff12
RAX: ffff88019d8161c0 RBX: 00000000ffffffff RCX: ffffc90003501000
RDX: 0000000000000002 RSI: ffffffff816236d1 RDI: 0000000000000005
RBP: ffff880196033bd8 R08: ffff88019d8161c0 R09: 0000000000000000
R10: 1ffff10032c067f0 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000080 R14: 0000000000000000 R15: 0000000000000000
 [<ffffffff816236d1>] do_futex+0x151/0x1d50 kernel/futex.c:3548
 [<ffffffff816260f0>] C_SYSC_futex kernel/futex_compat.c:201 [inline]
 [<ffffffff816260f0>] compat_SyS_futex+0x270/0x3b0 kernel/futex_compat.c:17=
5
 [<ffffffff8101da17>] do_syscall_32_irqs_on arch/x86/entry/common.c:353 [in=
line]
 [<ffffffff8101da17>] do_fast_syscall_32+0x357/0xe1c arch/x86/entry/common.=
c:415
 [<ffffffff84401a9b>] entry_SYSENTER_compat+0x8b/0x9d arch/x86/entry/entry_=
64_compat.S:139
RIP: 0023:0xf7f23c69
RSP: 002b:00000000f5d1f12c EFLAGS: 00000282 ORIG_RAX: 00000000000000f0
RAX: ffffffffffffffda RBX: 000000000816af88 RCX: 0000000000000080
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000000000816af8c
RBP: 00000000f5d1f228 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
rcu_sched kthread starved for 10502 jiffies! g5049 c5048 f0x2 RCU_GP_WAIT_F=
QS(3) ->state=3D0x0 ->cpu=3D1
rcu_sched       R  running task on cpu   1  13048     8      2 0x90000000 1=
79099587640
Call Trace:
 [<ffffffff8147321f>] context_switch+0x60f/0xa60 kernel/sched/core.c:3209
 [<ffffffff8100095a>] __schedule+0x5aa/0x1da0 kernel/sched/core.c:3934
 [<ffffffff810021df>] schedule+0x8f/0x1b0 kernel/sched/core.c:4011
 [<ffffffff8101116d>] schedule_timeout+0x50d/0xee0 kernel/time/timer.c:1803
 [<ffffffff815c13f1>] rcu_gp_kthread+0xda1/0x3b50 kernel/rcu/tree.c:2327
 [<ffffffff8144b318>] kthread+0x348/0x420 kernel/kthread.c:246
 [<ffffffff84400266>] ret_from_fork+0x56/0x70 arch/x86/entry/entry_64.S:393

Fixes: ba35f8588f47 (=E2=80=9Cipvlan: Defer multicast / broadcast processin=
g to a work-queue=E2=80=9D)
Signed-off-by: Mahesh Bandewar <maheshb@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 drivers/net/ipvlan/ipvlan_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ipvlan/ipvlan_core.c b/drivers/net/ipvlan/ipvlan_c=
ore.c
index 53dac397db37..5759e91dec71 100644
--- a/drivers/net/ipvlan/ipvlan_core.c
+++ b/drivers/net/ipvlan/ipvlan_core.c
@@ -277,6 +277,7 @@ void ipvlan_process_multicast(struct work_struct *work)
 			}
 			ipvlan_count_rx(ipvlan, len, ret =3D=3D NET_RX_SUCCESS, true);
 			local_bh_enable();
+			cond_resched_rcu();
 		}
 		rcu_read_unlock();
=20
--=20
2.25.1.481.gfbce0eb801-goog


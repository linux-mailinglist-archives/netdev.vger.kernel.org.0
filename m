Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2222EF0D6
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 23:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729928AbfKDW5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 17:57:07 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:45258 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729122AbfKDW5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 17:57:07 -0500
Received: by mail-ed1-f66.google.com with SMTP id b5so3677503eds.12;
        Mon, 04 Nov 2019 14:57:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RiAR56LvYehlVbvWCkbqbSQuYGYsIk95j6fMdrpV1nc=;
        b=AIS2YTrgGVneqWdDn+fH1eTxEwwxRNtUIU3pG1STWPZwY2NZnp6ohxnHJyDqiSoL0J
         VGQ/tstwtD/Tw1o/b/M2X4PA70uR3ZBi1YlxfN+HQHBKw+u/e2eOa813nOr2ndmD8ttx
         /F7+sp1hgJpUvYA4lvwWjuiyT11qzQ8IXIYPWee6dlPtsEyrRaG1Z3OpNERetXSvdluc
         4vhCCIGQRwDO9GjtlYJ1/TuDjDlK9qg3v5VzcJpRgKvZs1JXlZpQQlV36Ov4vHUdikk/
         ifNhwexViRNvn69RZatQhYcg2EYxwkQuuHZY2FjoWARY4AVKxlN9l/+UfCzCncgakHDY
         7S5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RiAR56LvYehlVbvWCkbqbSQuYGYsIk95j6fMdrpV1nc=;
        b=Cs+Le4Pr19zxY7Inxpr8B+9Fa2lbuVk6pakhl8WcvI5onuDVFh2xK1Cpr91sEYGT7B
         vCtup79J2SXwnX5OaIuGm8HN7YJ8FqB4SGcofeYcllgH4N6rPzRjspy4F+pVRbY5c2Kg
         VaA6krL1W6Peg0MySyRhIS0J7nF4Ye0IkKkKLB6lluYkvxOouj024huKQY/dwGqIt9os
         Uk5gGOqbL/DinUGscMKUnTAF2vxXASfB8DW352ANeTLIDggTLEIl/Nk1B3L6VTQmxDeo
         IGvIEU4KEi4I/YjUC0MOWMKzlE0qirXW+LB52ImMorlatGmC1cFjreO25tsn+h1HTcjg
         Emcw==
X-Gm-Message-State: APjAAAX7CjKPoEQ3EpBZrIE50zCQA5SordtBvCXZe60po/VixtdA2vXs
        TEMuHEiFX+blsECfHyLLnq+EY33lvAGbmHpojRk=
X-Google-Smtp-Source: APXvYqx2CnK3SgwLJ4BQMckOxgGLFIjdGb7UqylaacXOSV0qbaW5N8hbK/HSX+Ul1XtOVKh/7kG+2NTPWWh/fCNxYKo=
X-Received: by 2002:a17:906:1d19:: with SMTP id n25mr5343130ejh.151.1572908222565;
 Mon, 04 Nov 2019 14:57:02 -0800 (PST)
MIME-Version: 1.0
References: <20191101232828.17023-1-ivan.khoronzhuk@linaro.org> <87tv7juymy.fsf@linux.intel.com>
In-Reply-To: <87tv7juymy.fsf@linux.intel.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 5 Nov 2019 00:56:51 +0200
Message-ID: <CA+h21hpruAy1=yuBS1_YDOZ6t-g0=Xky_AJjBfPGhNMq0tOT2Q@mail.gmail.com>
Subject: Re: [PATCH net] taprio: fix panic while hw offload sched list swap
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 4 Nov 2019 at 23:19, Vinicius Costa Gomes
<vinicius.gomes@intel.com> wrote:
>
> Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> writes:
>
> > Don't swap oper and admin schedules too early, it's not correct and
> > causes crash.
> >
> > Steps to reproduce:
> >
> > 1)
> > tc qdisc replace dev eth0 parent root handle 100 taprio \
> >     num_tc 3 \
> >     map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
> >     queues 1@0 1@1 1@2 \
> >     base-time $SOME_BASE_TIME \
> >     sched-entry S 01 80000 \
> >     sched-entry S 02 15000 \
> >     sched-entry S 04 40000 \
> >     flags 2
> >
> > 2)
> > tc qdisc replace dev eth0 parent root handle 100 taprio \
> >     base-time $SOME_BASE_TIME \
> >     sched-entry S 01 90000 \
> >     sched-entry S 02 20000 \
> >     sched-entry S 04 40000 \
> >     flags 2
> >
> > 3)
> > tc qdisc replace dev eth0 parent root handle 100 taprio \
> >     base-time $SOME_BASE_TIME \
> >     sched-entry S 01 150000 \
> >     sched-entry S 02 200000 \
> >     sched-entry S 04 40000 \
> >     flags 2
> >
> > Do 2 3 2 .. steps  more times if not happens and observe:
> >
> > [  305.832319] Unable to handle kernel write to read-only memory at
> > virtual address ffff0000087ce7f0
> > [  305.910887] CPU: 0 PID: 0 Comm: swapper/0 Not tainted
> > [  305.919306] Hardware name: Texas Instruments AM654 Base Board (DT)
> >
> > [...]
> >
> > [  306.017119] x1 : ffff800848031d88 x0 : ffff800848031d80
> > [  306.022422] Call trace:
> > [  306.024866]  taprio_free_sched_cb+0x4c/0x98
> > [  306.029040]  rcu_process_callbacks+0x25c/0x410
> > [  306.033476]  __do_softirq+0x10c/0x208
> > [  306.037132]  irq_exit+0xb8/0xc8
> > [  306.040267]  __handle_domain_irq+0x64/0xb8
> > [  306.044352]  gic_handle_irq+0x7c/0x178
> > [  306.048092]  el1_irq+0xb0/0x128
> > [  306.051227]  arch_cpu_idle+0x10/0x18
> > [  306.054795]  do_idle+0x120/0x138
> > [  306.058015]  cpu_startup_entry+0x20/0x28
> > [  306.061931]  rest_init+0xcc/0xd8
> > [  306.065154]  start_kernel+0x3bc/0x3e4
> > [  306.068810] Code: f2fbd5b7 f2fbd5b6 d503201f f9400422 (f9000662)
> > [  306.074900] ---[ end trace 96c8e2284a9d9d6e ]---
> > [  306.079507] Kernel panic - not syncing: Fatal exception in interrupt
> > [  306.085847] SMP: stopping secondary CPUs
> > [  306.089765] Kernel Offset: disabled
> >
> > Try to explain one of the possible crash cases:
> >
> > The "real" admin list is assigned when admin_sched is set to
> > new_admin, it happens after "swap", that assigns to oper_sched NULL.
> > Thus if call qdisc show it can crash.
> >
> > Farther, next second time, when sched list is updated, the admin_sched
> > is not NULL and becomes the oper_sched, previous oper_sched was NULL so
> > just skipped. But then admin_sched is assigned new_admin, but schedules
> > to free previous assigned admin_sched (that already became oper_sched).
> >
> > Farther, next third time, when sched list is updated,
> > while one more swap, oper_sched is not null, but it was happy to be
> > freed already (while prev. admin update), so while try to free
> > oper_sched the kernel panic happens at taprio_free_sched_cb().
> >
> > So, move the "swap emulation" where it should be according to function
> > comment from code.
> >
> > Fixes: 9c66d15646760e ("taprio: Add support for hardware offloading")
> > Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> > ---
>
> As it solves a crash, and I have no problems with this fix:
>
> Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
>
> But reading the code, I got the feeling that upstream "swap emulation"
> part of the code is not working as it should, perhaps it was lost during
> upstreaming of the patch? Vladimir, can you confirm that this works for
> you? (yeah, this can be solved later)
>
>
> Cheers,
> --
> Vinicius
>

Hi Ivan, Vinicius,

I haven't actually used the "replace" functionality. I found it
strange that subsequent "replace" commands can't have the same syntax
as the first one, so it's kind of difficult to integrate them in a
script. And given the fact that I don't actually have a use case for
"replace", I left this where it is (apparently causing this race when
offloading a config and q->oper_sched is not NULL).

Actually there was yet another issue introduced by my patch, which I
discovered with lockdep after it got merged. I never managed to figure
out what it was saying, but it looks like your fix addresses that as
well, for some reason:

[94787.464015] =====================================================
[94787.470076] WARNING: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected
[94787.476654] 5.4.0-rc1-00457-g19cf0a771e53 #300 Not tainted
[94787.482106] -----------------------------------------------------
[94787.488165] tc/2575 [HC0[0]:SC0[2]:HE0:SE0] is trying to acquire:
[94787.494224] da592db0 (&(&q->current_entry_lock)->rlock){+.+.}, at:
taprio_change+0xddc/0xf04
[94787.502633]
[94787.502633] and this task is already holding:
[94787.508431] da592c88 (&(&sch->q.lock)->rlock){+.-.}, at:
taprio_change+0xa94/0xf04
[94787.515965] which would create a new lock dependency:
[94787.520985]  (&(&sch->q.lock)->rlock){+.-.} ->
(&(&q->current_entry_lock)->rlock){+.+.}
[94787.528952]
[94787.528952] but this new dependency connects a SOFTIRQ-irq-safe lock:
[94787.536823]  (&(&sch->q.lock)->rlock){+.-.}
[94787.536828]
[94787.536828] ... which became SOFTIRQ-irq-safe at:
[94787.547129]   _raw_spin_lock+0x44/0x54
[94787.550858]   sch_direct_xmit+0x274/0x2ac
[94787.554847]   __dev_queue_xmit+0xc7c/0xfcc
[94787.558920]   br_dev_queue_push_xmit+0x84/0x1ac
[94787.563426]   br_forward_finish+0x21c/0x230
[94787.567583]   __br_forward+0x2fc/0x30c
[94787.571312]   br_dev_xmit+0x358/0x648
[94787.574953]   dev_hard_start_xmit+0xf4/0x3b0
[94787.579198]   __dev_queue_xmit+0xe38/0xfcc
[94787.583274]   arp_solicit+0x1a0/0x504
[94787.586916]   neigh_probe+0x54/0x7c
[94787.590385]   neigh_timer_handler+0x9c/0x3a4
[94787.594631]   call_timer_fn+0xd4/0x3bc
[94787.598357]   run_timer_softirq+0x24c/0x6a8
[94787.602517]   __do_softirq+0x114/0x54c
[94787.606244]   irq_exit+0x168/0x178
[94787.609627]   __handle_domain_irq+0x60/0xb4
[94787.613788]   gic_handle_irq+0x58/0x9c
[94787.617515]   __irq_svc+0x70/0x98
[94787.620811]   arch_cpu_idle+0x24/0x3c
[94787.624451]   arch_cpu_idle+0x24/0x3c
[94787.628093]   do_idle+0x1c4/0x2b0
[94787.631388]   cpu_startup_entry+0x18/0x1c
[94787.635373]   0x8030278c
[94787.637888]
[94787.637888] to a SOFTIRQ-irq-unsafe lock:
[94787.643339]  (&(&q->current_entry_lock)->rlock){+.+.}
[94787.643345]
[94787.643345] ... which became SOFTIRQ-irq-unsafe at:
[94787.654675] ...
[94787.654680]   _raw_spin_lock+0x44/0x54
[94787.660140]   taprio_offload_config_changed+0x14/0x100
[94787.665248]   taprio_change+0xa78/0xf04
[94787.669063]   qdisc_create+0x1f0/0x53c
[94787.672790]   tc_modify_qdisc+0x1b0/0x834
[94787.676777]   rtnetlink_rcv_msg+0x1a4/0x510
[94787.680937]   netlink_rcv_skb+0xe0/0x114
[94787.684837]   netlink_unicast+0x17c/0x1f8
[94787.688822]   netlink_sendmsg+0x2c4/0x370
[94787.692809]   ___sys_sendmsg+0x22c/0x24c
[94787.696709]   __sys_sendmsg+0x50/0x8c
[94787.700349]   ret_fast_syscall+0x0/0x28
[94787.704161]   0xbeb4e208
[94787.706675]
[94787.706675] other info that might help us debug this:
[94787.706675]
[94787.714634]  Possible interrupt unsafe locking scenario:
[94787.714634]
[94787.721382]        CPU0                    CPU1
[94787.725884]        ----                    ----
[94787.730384]   lock(&(&q->current_entry_lock)->rlock);
[94787.735406]                                local_irq_disable();
[94787.741290]                                lock(&(&sch->q.lock)->rlock);
[94787.747954]
lock(&(&q->current_entry_lock)->rlock);
[94787.755481]   <Interrupt>
[94787.758082]     lock(&(&sch->q.lock)->rlock);
[94787.762412]
[94787.762412]  *** DEADLOCK ***
[94787.762412]
[94787.768297] 2 locks held by tc/2575:
[94787.771848]  #0: c21b18ec (rtnl_mutex){+.+.}, at:
rtnetlink_rcv_msg+0x174/0x510
[94787.779127]  #1: da592c88 (&(&sch->q.lock)->rlock){+.-.}, at:
taprio_change+0xa94/0xf04
[94787.787095]
[94787.787095] the dependencies between SOFTIRQ-irq-safe lock and the
holding lock:
[94787.795939] -> (&(&sch->q.lock)->rlock){+.-.} {
[94787.800447]    HARDIRQ-ON-W at:
[94787.803572]                     _raw_spin_lock_bh+0x40/0x50
[94787.809114]                     dev_deactivate_queue.constprop.13+0x4c/0xd8
[94787.816038]                     dev_deactivate_many+0x5c/0x3d8
[94787.821838]                     dev_deactivate+0x3c/0x64
[94787.827121]                     linkwatch_do_dev+0x4c/0x80
[94787.832577]                     __linkwatch_run_queue+0x198/0x1e0
[94787.838637]                     linkwatch_event+0x2c/0x34
[94787.844008]                     process_one_work+0x300/0x7f4
[94787.849636]                     worker_thread+0x58/0x5a0
[94787.854919]                     kthread+0x12c/0x160
[94787.859769]                     ret_from_fork+0x14/0x20
[94787.864963]                     0x0
[94787.868427]    IN-SOFTIRQ-W at:
[94787.871550]                     _raw_spin_lock+0x44/0x54
[94787.876833]                     sch_direct_xmit+0x274/0x2ac
[94787.882377]                     __dev_queue_xmit+0xc7c/0xfcc
[94787.888005]                     br_dev_queue_push_xmit+0x84/0x1ac
[94787.894065]                     br_forward_finish+0x21c/0x230
[94787.899778]                     __br_forward+0x2fc/0x30c
[94787.905063]                     br_dev_xmit+0x358/0x648
[94787.910259]                     dev_hard_start_xmit+0xf4/0x3b0
[94787.916060]                     __dev_queue_xmit+0xe38/0xfcc
[94787.921689]                     arp_solicit+0x1a0/0x504
[94787.926887]                     neigh_probe+0x54/0x7c
[94787.931911]                     neigh_timer_handler+0x9c/0x3a4
[94787.937711]                     call_timer_fn+0xd4/0x3bc
[94787.942993]                     run_timer_softirq+0x24c/0x6a8
[94787.948708]                     __do_softirq+0x114/0x54c
[94787.953989]                     irq_exit+0x168/0x178
[94787.958927]                     __handle_domain_irq+0x60/0xb4
[94787.964642]                     gic_handle_irq+0x58/0x9c
[94787.969924]                     __irq_svc+0x70/0x98
[94787.974775]                     arch_cpu_idle+0x24/0x3c
[94787.979970]                     arch_cpu_idle+0x24/0x3c
[94787.985167]                     do_idle+0x1c4/0x2b0
[94787.990017]                     cpu_startup_entry+0x18/0x1c
[94787.995556]                     0x8030278c
[94787.999626]    INITIAL USE at:
[94788.002664]                    _raw_spin_lock_bh+0x40/0x50
[94788.008120]                    dev_deactivate_queue.constprop.13+0x4c/0xd8
[94788.014958]                    dev_deactivate_many+0x5c/0x3d8
[94788.020671]                    dev_deactivate+0x3c/0x64
[94788.025868]                    linkwatch_do_dev+0x4c/0x80
[94788.031237]                    __linkwatch_run_queue+0x198/0x1e0
[94788.037210]                    linkwatch_event+0x2c/0x34
[94788.042493]                    process_one_work+0x300/0x7f4
[94788.048035]                    worker_thread+0x58/0x5a0
[94788.053231]                    kthread+0x12c/0x160
[94788.057996]                    ret_from_fork+0x14/0x20
[94788.063104]                    0x0
[94788.066482]  }
[94788.068138]  ... key      at: [<c2862598>] __key.72250+0x0/0x8
[94788.073937]  ... acquired at:
[94788.076885]    taprio_change+0xddc/0xf04
[94788.080785]    qdisc_create+0x1f0/0x53c
[94788.084599]    tc_modify_qdisc+0x1b0/0x834
[94788.088671]    rtnetlink_rcv_msg+0x1a4/0x510
[94788.092917]    netlink_rcv_skb+0xe0/0x114
[94788.096904]    netlink_unicast+0x17c/0x1f8
[94788.100976]    netlink_sendmsg+0x2c4/0x370
[94788.105048]    ___sys_sendmsg+0x22c/0x24c
[94788.109034]    __sys_sendmsg+0x50/0x8c
[94788.112761]    ret_fast_syscall+0x0/0x28
[94788.116658]    0xbeb4e208
[94788.119259]
[94788.120736]
[94788.120736] the dependencies between the lock to be acquired
[94788.120739]  and SOFTIRQ-irq-unsafe lock:
[94788.131825] -> (&(&q->current_entry_lock)->rlock){+.+.} {
[94788.137196]    HARDIRQ-ON-W at:
[94788.140320]                     _raw_spin_lock+0x44/0x54
[94788.145602]                     taprio_offload_config_changed+0x14/0x100
[94788.152267]                     taprio_change+0xa78/0xf04
[94788.157636]                     qdisc_create+0x1f0/0x53c
[94788.162919]                     tc_modify_qdisc+0x1b0/0x834
[94788.168460]                     rtnetlink_rcv_msg+0x1a4/0x510
[94788.174175]                     netlink_rcv_skb+0xe0/0x114
[94788.179631]                     netlink_unicast+0x17c/0x1f8
[94788.185173]                     netlink_sendmsg+0x2c4/0x370
[94788.190714]                     ___sys_sendmsg+0x22c/0x24c
[94788.196170]                     __sys_sendmsg+0x50/0x8c
[94788.201365]                     ret_fast_syscall+0x0/0x28
[94788.206731]                     0xbeb4e208
[94788.210801]    SOFTIRQ-ON-W at:
[94788.213924]                     _raw_spin_lock+0x44/0x54
[94788.219206]                     taprio_offload_config_changed+0x14/0x100
[94788.225871]                     taprio_change+0xa78/0xf04
[94788.231239]                     qdisc_create+0x1f0/0x53c
[94788.236523]                     tc_modify_qdisc+0x1b0/0x834
[94788.242064]                     rtnetlink_rcv_msg+0x1a4/0x510
[94788.247779]                     netlink_rcv_skb+0xe0/0x114
[94788.253234]                     netlink_unicast+0x17c/0x1f8
[94788.258776]                     netlink_sendmsg+0x2c4/0x370
[94788.264317]                     ___sys_sendmsg+0x22c/0x24c
[94788.269773]                     __sys_sendmsg+0x50/0x8c
[94788.274968]                     ret_fast_syscall+0x0/0x28
[94788.280336]                     0xbeb4e208
[94788.284405]    INITIAL USE at:
[94788.287442]                    _raw_spin_lock+0x44/0x54
[94788.292638]                    taprio_offload_config_changed+0x14/0x100
[94788.299216]                    taprio_change+0xa78/0xf04
[94788.304497]                    qdisc_create+0x1f0/0x53c
[94788.309694]                    tc_modify_qdisc+0x1b0/0x834
[94788.315149]                    rtnetlink_rcv_msg+0x1a4/0x510
[94788.320777]                    netlink_rcv_skb+0xe0/0x114
[94788.326146]                    netlink_unicast+0x17c/0x1f8
[94788.331602]                    netlink_sendmsg+0x2c4/0x370
[94788.337057]                    ___sys_sendmsg+0x22c/0x24c
[94788.342426]                    __sys_sendmsg+0x50/0x8c
[94788.347535]                    ret_fast_syscall+0x0/0x28
[94788.352815]                    0xbeb4e208
[94788.356799]  }
[94788.358453]  ... key      at: [<c28626b4>] __key.70731+0x0/0x8
[94788.364251]  ... acquired at:
[94788.367199]    taprio_change+0xddc/0xf04
[94788.371099]    qdisc_create+0x1f0/0x53c
[94788.374913]    tc_modify_qdisc+0x1b0/0x834
[94788.378985]    rtnetlink_rcv_msg+0x1a4/0x510
[94788.383231]    netlink_rcv_skb+0xe0/0x114
[94788.387217]    netlink_unicast+0x17c/0x1f8
[94788.391290]    netlink_sendmsg+0x2c4/0x370
[94788.395362]    ___sys_sendmsg+0x22c/0x24c
[94788.399348]    __sys_sendmsg+0x50/0x8c
[94788.403074]    ret_fast_syscall+0x0/0x28
[94788.406972]    0xbeb4e208
[94788.409572]
[94788.411049]
[94788.411049] stack backtrace:
[94788.415384] CPU: 1 PID: 2575 Comm: tc Not tainted
5.4.0-rc1-00457-g19cf0a771e53 #300
[94788.423083] Hardware name: Freescale LS1021A
[94788.427338] [<c03142ec>] (unwind_backtrace) from [<c030e034>]
(show_stack+0x10/0x14)
[94788.435045] [<c030e034>] (show_stack) from [<c11b561c>]
(dump_stack+0xcc/0xf8)
[94788.442233] [<c11b561c>] (dump_stack) from [<c03b5fd0>]
(__lock_acquire+0x1d90/0x2398)
[94788.450111] [<c03b5fd0>] (__lock_acquire) from [<c03b6ec8>]
(lock_acquire+0xe0/0x22c)
[94788.457903] [<c03b6ec8>] (lock_acquire) from [<c11d9200>]
(_raw_spin_lock_irqsave+0x54/0x68)
[94788.466298] [<c11d9200>] (_raw_spin_lock_irqsave) from [<c0fdd894>]
(taprio_change+0xddc/0xf04)
[94788.474956] [<c0fdd894>] (taprio_change) from [<c0fc1698>]
(qdisc_create+0x1f0/0x53c)
[94788.482749] [<c0fc1698>] (qdisc_create) from [<c0fc1b94>]
(tc_modify_qdisc+0x1b0/0x834)
[94788.490714] [<c0fc1b94>] (tc_modify_qdisc) from [<c0f73c48>]
(rtnetlink_rcv_msg+0x1a4/0x510)
[94788.499112] [<c0f73c48>] (rtnetlink_rcv_msg) from [<c0ff13a8>]
(netlink_rcv_skb+0xe0/0x114)
[94788.507422] [<c0ff13a8>] (netlink_rcv_skb) from [<c0ff0bec>]
(netlink_unicast+0x17c/0x1f8)
[94788.515647] [<c0ff0bec>] (netlink_unicast) from [<c0ff0f2c>]
(netlink_sendmsg+0x2c4/0x370)
[94788.523872] [<c0ff0f2c>] (netlink_sendmsg) from [<c0f2da7c>]
(___sys_sendmsg+0x22c/0x24c)
[94788.532010] [<c0f2da7c>] (___sys_sendmsg) from [<c0f2ee90>]
(__sys_sendmsg+0x50/0x8c)
[94788.539802] [<c0f2ee90>] (__sys_sendmsg) from [<c0301000>]
(ret_fast_syscall+0x0/0x28)
[94788.547676] Exception stack(0xe9db3fa8 to 0xe9db3ff0)
[94788.552701] 3fa0:                   b6f4d8c8 00000114 00000003
beb4e260 00000000 00000000
[94788.560837] 3fc0: b6f4d8c8 00000114 004eb02c 00000128 5da59019
00000000 0000002d 00522c98
[94788.568971] 3fe0: 00000070 beb4e208 004fa950 b6dbee64

But anyway, yes it makes sense to call taprio_offload_config_changed
only after rcu_assign_pointer(q->admin_sched, new_admin), and that is
part of the reason why I found it difficult to add a mechanism for
drivers to notify back on offload activation time that doesn't trigger
any races in taprio.

Tested-by: Vladimir Oltean <olteanv@gmail.com>

Thanks,
-Vladimir

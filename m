Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1087B377147
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 12:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbhEHKtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 06:49:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbhEHKtn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 06:49:43 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51A0C061574
        for <netdev@vger.kernel.org>; Sat,  8 May 2021 03:48:41 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id w3so17424769ejc.4
        for <netdev@vger.kernel.org>; Sat, 08 May 2021 03:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=DId7r9IjrOE1xiCLNpv2Xp6WK+XEYkrrdJ+/5oKbHts=;
        b=tIvd9XImtJPSlaJy/Rp9nXxqNeBDigZHp+nohcybdXy7ZLN3HpYt13rXLhxH44t4Cq
         ycmcdJEYKTIt5su148bT7wqWFFezLOhNFMR0CVxIwCkFMU4QGVDjz/mN1GN7sQtqFPFI
         /PN8Z1twVDc01rOJe6iP7/6Grfjv7nTIPM+TMTqg6ZsVl+h7GrWmQf+BBh2Mvm8gFGAE
         l222gY4cJ0U5WV3I9uh51j3S5JrmnUcAjGvCiEzBnFekDY3mu8GlBUYfv8Q7IIffKoWM
         IS0D54SnFvTfA1yxVvF2eXR5tgLbdl7zj+AQI20lleOYpJMRbciOGZCl3Ly8QCot5UYD
         EuFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=DId7r9IjrOE1xiCLNpv2Xp6WK+XEYkrrdJ+/5oKbHts=;
        b=c06T0DNUBIn/T17K3NgYDZvwEGD22OUE4qbNiHAGxJmdxVULrbMKk78Joyulo7YKRY
         qD/KjVdnIzjRdXptZMNGn9LITwDXxjGN4vV0Cfvg6DaEMu9JhRQyz0oAqjhO0XxwY2Bk
         E0s6FQs3IAuAFRAuy0FOs8CMvJmr+cf8pNKN/zpNqmP7+os6FDRI8S2gsAGny3aps3wA
         NNPd9ImF7N8EZcJX3f/IkTnlIQdrohFfRYNkbUDNoLC7XNT8JIuO20ODNXSBNvMs0vDh
         0yLacJZmIn9EiPn8rlTJVccyCN4v9EQETaH0I2VMwKvQK/0bXqgD/qh9WdBEoMRL3xwC
         utVg==
X-Gm-Message-State: AOAM5305Sp/yZ+sn5yfBz38z1NKha7zqviVlSU3MRZebj8k6XHzMKesM
        CcHeKJ+Njf1qYlQqRVotgODWzaXsGrPgvg==
X-Google-Smtp-Source: ABdhPJxy4n5IDpkULHJDbobUi/FVr8+cio7TtQ4FBEMW+Ofslhcf5BcdEj7W946RBwxsaD+qwqKkkQ==
X-Received: by 2002:a17:907:7895:: with SMTP id ku21mr15509668ejc.373.1620470920273;
        Sat, 08 May 2021 03:48:40 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id k9sm5443882eje.102.2021.05.08.03.48.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 May 2021 03:48:39 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.11\))
Subject: Bug Report Napi kthread rcd 
From:   Martin Zaharinov <micron10@gmail.com>
In-Reply-To: <457C51FA-5AD3-40AE-B8CE-AFBDB81DD258@gmail.com>
Date:   Sat, 8 May 2021 13:48:37 +0300
Cc:     netdev <netdev@vger.kernel.org>, Wei Wang <weiwan@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <edumazet@google.com>, alobakin@pm.me
Content-Transfer-Encoding: quoted-printable
Message-Id: <E1410B34-4551-469C-8EE9-AAB5C001248E@gmail.com>
References: <20210316223647.4080796-1-weiwan@google.com>
 <6AF20AA6-07E7-4DDD-8A9E-BE093FC03802@gmail.com>
 <CANn89iJxXOZktXv6Arh82OAGOpn523NuOcWFDaSmJriOaXQMRw@mail.gmail.com>
 <AE7C80D4-DD7E-4AA7-B261-A66B30F57D3B@gmail.com>
 <CANn89iKyWgYeD_B-iJxL50C4BHYiDh+dWOyFYXatteF=eU7zoA@mail.gmail.com>
 <9F81F217-6E5C-49EB-95A7-CCB1D3C3ED4F@gmail.com>
 <00722e87685db9da3ef76166780dcbf5b4617bf7.camel@redhat.com>
 <457C51FA-5AD3-40AE-B8CE-AFBDB81DD258@gmail.com>
To:     Paolo Abeni <pabeni@redhat.com>
X-Mailer: Apple Mail (2.3654.100.0.2.11)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all=20
One more bug report .
Kernel is 5.12.1=20

If you need more info I will write.

Server run with 200 users with nat=20

[81402.540906] rcu: INFO: rcu_sched self-detected stall on CPU
[81402.540909] rcu: 5-....: (3314 ticks this GP) =
idle=3D74e/1/0x4000000000000000 softirq=3D4979878/4979878 fqs=3D2554 =
last_accelerate: a926/c0a0 dyntick_enabled: 1
[81402.540911] (t=3D6001 jiffies g=3D7517749 q=3D44479)
[81402.540913] NMI backtrace for cpu 5
[81402.540914] CPU: 5 PID: 36 Comm: ksoftirqd/5 Tainted: G O 5.12.1 #1
[81402.540916] Hardware name: Supermicro Super Server/X10SRD-F, BIOS 3.3 =
10/28/2020
[81402.540917] Call Trace:
[81402.540919]
[81402.540920] dump_stack+0x65/0x7d
[81402.540924] ? lapic_can_unplug_cpu+0x70/0x70
[81402.540927] nmi_trigger_cpumask_backtrace.cold+0x40/0x4d
[81402.540929] rcu_dump_cpu_stacks+0xbe/0xec
[81402.540932] rcu_sched_clock_irq.cold+0x195/0x3f1
[81402.540934] ? enqueue_task_fair+0x796/0xbd0
[81402.540938] update_process_times+0x88/0xc0
[81402.540942] tick_sched_timer+0x7f/0x110
[81402.540944] ? tick_nohz_dep_set_task+0x80/0x80
[81402.540945] __hrtimer_run_queues+0x10b/0x1b0
[81402.540947] hrtimer_interrupt+0x10a/0x420
[81402.540949] __sysvec_apic_timer_interrupt+0x47/0x60
[81402.540952] sysvec_apic_timer_interrupt+0x65/0x90
[81402.540955]
[81402.540955] asm_sysvec_apic_timer_interrupt+0xf/0x20
[81402.540959] RIP: 0010:console_unlock+0x366/0x5e0
[81402.540961] Code: ff ff 8b 05 44 5f b2 01 85 c0 75 66 c7 05 3a 5f b2 =
01 01 00 00 00 e9 0f fd ff ff e8 f4 1c 00 00 48 85 db 74 01 fb 8b 54 24 =
0c <85> d2 0f 84 4a fd ff ff e8 1d 2b 7c 00 e9 40 fd ff ff 4d 85 ff 74
[81402.540963] RSP: 0018:ffff9dc980203a80 EFLAGS: 00000206
[81402.540964] RAX: 0000000000000000 RBX: 0000000000000200 RCX: =
0000000000000000
[81402.540965] RDX: 0000000000000000 RSI: 0000000000000087 RDI: =
ffffffff82b59898
[81402.540966] RBP: 0000000000000000 R08: ffff9786814db080 R09: =
0000000000000000
[81402.540966] R10: ffff9786a85bf260 R11: ffff9786f7bd7cf0 R12: =
0000000000000048
[81402.540967] R13: 0000000000000000 R14: 20c49ba5e353f7cf R15: =
0000000000000000
[81402.540968] ? common_interrupt+0x14/0xa0
[81402.540969] ? asm_common_interrupt+0x1b/0x40
[81402.540971] vprintk_default+0x5a/0x150
[81402.540972] printk+0x43/0x45
[81402.540975] create_nat_session+0x1c5e/0x1cfd [xt_NAT]
[81402.540978] ipt_do_table+0x2e5/0x670 [ip_tables]
[81402.540980] ? ip_route_input_noref+0xa8/0x1e0
[81402.540983] nf_hook_slow+0x36/0xa0
[81402.540986] ip_forward+0x40d/0x450
[81402.540987] ? ip4_obj_hashfn+0xc0/0xc0
[81402.540989] process_backlog+0x11a/0x230
[81402.540992] __napi_poll+0x1f/0x130
[81402.540994] net_rx_action+0x239/0x2f0
[81402.540996] ? run_timer_softirq+0x730/0x880
[81402.540998] __do_softirq+0xaf/0x1da
[81402.541000] run_ksoftirqd+0x15/0x20
[81402.541004] smpboot_thread_fn+0xb3/0x140
[81402.541006] ? sort_range+0x20/0x20
[81402.541008] kthread+0xea/0x120
[81402.541010] ? kthread_park+0x80/0x80
[81402.541012] ret_from_fork+0x1f/0x30
[81416.300055] rcu: INFO: rcu_sched detected expedited stalls on =
CPUs/tasks: {
[81476.311498] rcu: INFO: rcu_sched self-detected stall on CPU
[81476.311500] rcu: 3-....: (1 GPs behind) idle=3D86a/1/0x4000000000000000=
 softirq=3D4703397/4703398 fqs=3D2596 last_accelerate: c5ff/dd71 =
dyntick_enabled: 1
[81476.311503] (t=3D6001 jiffies g=3D7517753 q=3D82419)
[81476.311505] NMI backtrace for cpu 3
[81476.311506] CPU: 3 PID: 527214 Comm: kworker/3:2 Tainted: G O 5.12.1 =
#1
[81476.311507] Hardware name: Supermicro Super Server/X10SRD-F, BIOS 3.3 =
10/28/2020
[81476.311509] Workqueue: rcu_gp wait_rcu_exp_gp
[81476.311512] Call Trace:
[81476.311514]
[81476.311515] dump_stack+0x65/0x7d
[81476.311519] ? lapic_can_unplug_cpu+0x70/0x70
[81476.311521] nmi_trigger_cpumask_backtrace.cold+0x40/0x4d
[81476.311523] rcu_dump_cpu_stacks+0xbe/0xec
[81476.311527] rcu_sched_clock_irq.cold+0x195/0x3f1
[81476.311529] ? timekeeping_advance+0x34e/0x540
[81476.311531] update_process_times+0x88/0xc0
[81476.311534] tick_sched_timer+0x7f/0x110
[81476.311536] ? tick_nohz_dep_set_task+0x80/0x80
[81476.311537] __hrtimer_run_queues+0x10b/0x1b0
[81476.311539] hrtimer_interrupt+0x10a/0x420
[81476.311541] __sysvec_apic_timer_interrupt+0x47/0x60
[81476.311544] sysvec_apic_timer_interrupt+0x65/0x90
[81476.311547]
[81476.311547] asm_sysvec_apic_timer_interrupt+0xf/0x20
[81476.311551] RIP: 0010:console_unlock+0x366/0x5e0
[81476.311554] Code: ff ff 8b 05 44 5f b2 01 85 c0 75 66 c7 05 3a 5f b2 =
01 01 00 00 00 e9 0f fd ff ff e8 f4 1c 00 00 48 85 db 74 01 fb 8b 54 24 =
0c <85> d2 0f 84 4a fd ff ff e8 1d 2b 7c 00 e9 40 fd ff ff 4d 85 ff 74
[81476.311555] RSP: 0018:ffff9dc980313cc0 EFLAGS: 00000206
[81476.311556] RAX: 0000000000000000 RBX: 0000000000000200 RCX: =
0000000000000000
[81476.311557] RDX: 0000000000000000 RSI: 0000000000000087 RDI: =
ffffffff82b59898
[81476.311557] RBP: 0000000000000000 R08: ffff9786814db080 R09: =
0000000000000000
[81476.311558] R10: ffff9786a85bac10 R11: ffff97872e90acf0 R12: =
0000000000000048
[81476.311559] R13: 0000000000000000 R14: 20c49ba5e353f7cf R15: =
0000000000000000
[81476.311560] vprintk_default+0x5a/0x150
[81476.311562] printk+0x43/0x45
[81476.311563] synchronize_rcu_expedited_wait.cold+0x20/0x2db
[81476.311565] rcu_exp_wait_wake+0xc/0x110
[81476.311567] process_one_work+0x1ec/0x350
[81476.311569] worker_thread+0x4f/0x4d0
[81476.311570] ? process_one_work+0x350/0x350
[81476.311571] kthread+0xea/0x120
[81476.311573] ? kthread_park+0x80/0x80
[81476.311574] ret_from_fork+0x1f/0x30
[81551.199572] } 19586 jiffies s: 14473 root: 0x0/.=

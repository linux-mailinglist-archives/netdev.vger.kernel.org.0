Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A861063D1D6
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 10:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233368AbiK3J3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 04:29:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233224AbiK3J26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 04:28:58 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E8EA37229
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 01:28:57 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id b126so3596045oif.5
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 01:28:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WE/wpoe8wyBxBHKakNxetZ2YMP80E+8QwJz69OkRN0U=;
        b=HssRzSbrSQyJoGkd5nNJrJ47K/btKlVQCYR/JLZLF5KIJAHzuAFLQQulvXQ4yzcMML
         RrpMnm+4A9MDUAKE0oXnobLNLWbTtEvFsVmIJ0v5lxi9qZTEfHm/fAI8/UT84yQRvGZw
         Eh7/pGBPNd0L/L1gvNLk6jKMuimN2iRDfvqcfGzEzzGpPZvI5fDsztgpBvqAok44s+Id
         CN5Ndrf2IEJGp63AMdUdtMqMNCkZFwRykKeHYY5GvQyqUNOBWsxs+XDrWrpDFqP9HRNU
         MlntVSVUW9HCUATiv8MGJOS/s+/xGZcQIaFIEFegGqsG44jPgeoNJXsSMPk9Gy+3LRzu
         yUcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WE/wpoe8wyBxBHKakNxetZ2YMP80E+8QwJz69OkRN0U=;
        b=rVfKFGQb4ZBgiCirqv+jzW1ovlfQjsHN24qXAckcOtHhAxxw1gnpbuW9STT6XdlIrR
         lxxC+KvskJFvBhqDCbckY71K/OWmImHfJQAkg3YROGUsHO+nytl7TNz32UraTfjAX5jT
         359ft5ufN4yUgxWgm7IA7htj0EVW9h8WW7LA7rO626BuaJLvaFn6Hq90Cl7DodyhAbb2
         7ZMDAFdfo1iuhyR0p5fHaL38dAroESNTxLckW+JByk/XqaFqjvNZ9ZF/Edm02IoLZTCZ
         IdONwlpRCnlTFCr1VaIoGRLUeTTXMMedqnRHkGfD+tGS9P8i6AZVpCiRAAhucJrX7Bt4
         iYRw==
X-Gm-Message-State: ANoB5plWpDXCmhMjcBuK1oH5qdEMy8/71UybMKux7wqO1lEC9bETYOF7
        lPZ+RQVJSyDkVKgIU77prh2MA8E5N7QO32O3B7vrrg==
X-Google-Smtp-Source: AA0mqf4DiGy4FVHY1mnnDBa34cgVhJ/HgpD1QUBSqmURBcBBYIt34SlIStjXcaonS7eB+apS4mqD3mh3Y+jEI7qkx24=
X-Received: by 2002:a05:6808:1115:b0:359:cb71:328b with SMTP id
 e21-20020a056808111500b00359cb71328bmr28507259oih.282.1669800536644; Wed, 30
 Nov 2022 01:28:56 -0800 (PST)
MIME-Version: 1.0
References: <00000000000055882e05ed9445a2@google.com> <a700b13.191985.1848090ad97.Coremail.linma@zju.edu.cn>
In-Reply-To: <a700b13.191985.1848090ad97.Coremail.linma@zju.edu.cn>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 30 Nov 2022 10:28:45 +0100
Message-ID: <CACT4Y+bj=xVbT+s6VmsiK12frTuPZCOf-hS+tZkuH_dSNKsb-w@mail.gmail.com>
Subject: Re: [syzbot] BUG: unable to handle kernel NULL pointer dereference in nci_cmd_timer
To:     Lin Ma <linma@zju.edu.cn>,
        =?UTF-8?B?6ams6bqf?= <kylin.formalin@gmail.com>
Cc:     syzbot <syzbot+10257d01dd285b15170a@syzkaller.appspotmail.com>,
        krzysztof.kozlowski@linaro.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Nov 2022 at 14:11, Lin Ma <linma@zju.edu.cn> wrote:
>
> > Subject: [syzbot] BUG: unable to handle kernel NULL pointer dereference in nci_cmd_timer
> >
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    9500fc6e9e60 Merge branch 'for-next/core' into for-kernelci
> > git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
> > console output: https://syzkaller.appspot.com/x/log.txt?x=16cbf7a5880000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=b25c9f218686dd5e
> > dashboard link: https://syzkaller.appspot.com/bug?extid=10257d01dd285b15170a
> > compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
> > userspace arch: arm64
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1354dce9880000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10880a95880000
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/1363e60652f7/disk-9500fc6e.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/fcc4da811bb6/vmlinux-9500fc6e.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/0b554298f1fa/Image-9500fc6e.gz.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+10257d01dd285b15170a@syzkaller.appspotmail.com
> >
> > Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
> > Mem abort info:
> >   ESR = 0x0000000096000004
> >   EC = 0x25: DABT (current EL), IL = 32 bits
> >   SET = 0, FnV = 0
> >   EA = 0, S1PTW = 0
> >   FSC = 0x04: level 0 translation fault
> > Data abort info:
> >   ISV = 0, ISS = 0x00000004
> >   CM = 0, WnR = 0
> > user pgtable: 4k pages, 48-bit VAs, pgdp=000000010c75b000
> > [0000000000000000] pgd=0000000000000000, p4d=0000000000000000
> > Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
> > Modules linked in:
> > CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.1.0-rc5-syzkaller-32269-g9500fc6e9e60 #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/30/2022
> > pstate: 004000c5 (nzcv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> > pc : __queue_work+0x3c4/0x8b4
> > lr : __queue_work+0x3c4/0x8b4 kernel/workqueue.c:1458
> > sp : ffff800008003d60
> > x29: ffff800008003d60 x28: 0000000000000000 x27: ffff80000d3a9000
> > x26: ffff80000d3ad050 x25: ffff80000d2fe008 x24: ffff80000db54000
> > x23: 0000000000000000 x22: 0000000000000023 x21: ffff0000c7a95400
> > x20: 0000000000000008 x19: ffff0000cd0d20f8 x18: ffff80000db78158
> > x17: ffff80000ddda198 x16: ffff80000dc18158 x15: ffff80000d3cbc80
> > x14: 0000000000000000 x13: 00000000ffffffff x12: ffff80000d3cbc80
> > x11: ff8080000c07dfe4 x10: 0000000000000000 x9 : ffff80000c07dfe4
> > x8 : ffff80000d3cbc80 x7 : ffff80000813bae8 x6 : 0000000000000000
> > x5 : 0000000000000080 x4 : 0000000000000000 x3 : 0000000000000002
> > x2 : 0000000000000008 x1 : 0000000000000000 x0 : ffff0000c0014c00
> > Call trace:
> >  __queue_work+0x3c4/0x8b4 kernel/workqueue.c:1458
> >  queue_work_on+0xb0/0x15c kernel/workqueue.c:1545
> >  queue_work include/linux/workqueue.h:503 [inline]
> >  nci_cmd_timer+0x30/0x40 net/nfc/nci/core.c:615
> >  call_timer_fn+0x90/0x144 kernel/time/timer.c:1474
> >  expire_timers kernel/time/timer.c:1519 [inline]
> >  __run_timers+0x280/0x374 kernel/time/timer.c:1790
> >  run_timer_softirq+0x34/0x5c kernel/time/timer.c:1803
> >  _stext+0x168/0x37c
> >  ____do_softirq+0x14/0x20 arch/arm64/kernel/irq.c:79
> >  call_on_irq_stack+0x2c/0x54 arch/arm64/kernel/entry.S:892
> >  do_softirq_own_stack+0x20/0x2c arch/arm64/kernel/irq.c:84
> >  invoke_softirq+0x70/0xbc kernel/softirq.c:452
> >  __irq_exit_rcu+0xf0/0x140 kernel/softirq.c:650
> >  irq_exit_rcu+0x10/0x40 kernel/softirq.c:662
> >  __el1_irq arch/arm64/kernel/entry-common.c:472 [inline]
> >  el1_interrupt+0x38/0x68 arch/arm64/kernel/entry-common.c:486
> >  el1h_64_irq_handler+0x18/0x24 arch/arm64/kernel/entry-common.c:491
> >  el1h_64_irq+0x64/0x68 arch/arm64/kernel/entry.S:580
> >  arch_local_irq_enable+0xc/0x18 arch/arm64/include/asm/irqflags.h:35
> >  default_idle_call+0x48/0xb8 kernel/sched/idle.c:109
> >  cpuidle_idle_call kernel/sched/idle.c:191 [inline]
> >  do_idle+0x110/0x2d4 kernel/sched/idle.c:303
> >  cpu_startup_entry+0x24/0x28 kernel/sched/idle.c:400
> >  kernel_init+0x0/0x290 init/main.c:729
> >  start_kernel+0x0/0x620 init/main.c:890
> >  start_kernel+0x450/0x620 init/main.c:1145
> >  __primary_switched+0xb4/0xbc arch/arm64/kernel/head.S:471
> > Code: 94001384 aa0003f7 aa1303e0 9400144a (f94002f8)
> > ---[ end trace 0000000000000000 ]---
> > ----------------
> > Code disassembly (best guess):
> >    0: 94001384        bl      0x4e10
> >    4: aa0003f7        mov     x23, x0
> >    8: aa1303e0        mov     x0, x19
> >    c: 9400144a        bl      0x5134
> > * 10: f94002f8        ldr     x24, [x23] <-- trapping instruction
> >
> >
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > syzbot can test patches for this issue, for details see:
> > https://goo.gl/tpsmEJ#testing-patches
>
> #syz test: https://github.com/f0rm2l1n/linux-fix.git master

#syz dup: WARNING in nci_send_cmd

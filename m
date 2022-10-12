Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 621975FCCC8
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 23:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiJLVIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 17:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbiJLVIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 17:08:16 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BDBBF028
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 14:08:13 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id a20-20020a17090acb9400b0020aff595f9eso47842pju.5
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 14:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YQ92MyYkDi0rXzsY9g25bbZtz0xg0smQTszHXunhR9Y=;
        b=DtHz3MGJYhQHIWK/6XAPNc4RldgwZDxwAY5kuC5r2GeW+K3pKhqB4dLF61O+pJE2oP
         O4G6w/XVhTgXQqwYDfS96rg1BQ5d00XyN6gEmyiWaxgwxm6/APko+OHTAApYNgp+8+6J
         2RcEjXmKb3D6zoDtxhTtegz+HfjHC3FUwOaQxldZme+OaA+e7CwXNW0wxiGayhBn1k/j
         Hf223dBQyoilinuEX1AujNqtWp4Y+UZlLag75mUeaR1yUC1PsDYjB70cnzFiTjoR0j+A
         Tvuas6lcQB1/nNWJeQpDgKhAbWzCujcm84lWagneOU/EupRq83T1yvgwZtv65i3nr5f4
         zr2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YQ92MyYkDi0rXzsY9g25bbZtz0xg0smQTszHXunhR9Y=;
        b=MSuh0fhny3FR3nuhetm4Uv53hhVVZizdzIg9fEkRu8YaSgPb5lyjAoV3VBSSx/zxWJ
         aWtO5/nVHod6b86pPCRwdEfpxboniubsPcmQx96ZI6VOYCGjGIxK0zS8Xtlm77/fTeGD
         VyfjesqZKt/PmwRZujye1FT8XvXdubCLKUfP83SWGf13mGFUClmtlGjc2Tzh9m/IIiqc
         PfdWmncNrVFR9Vt5Vq8NI5oZAhqJYNKej2CuPeC31AqZURYNsUZEh2J7WRQZk3E18I8C
         dlA7Rr076rfxfsnCRKeIt6WNXOQ24L7w91DAGk3J+3V2skSe8E/+rFak+Ud95UxmHt17
         pOew==
X-Gm-Message-State: ACrzQf0vJTKYo3uEMHbdE/XjM0zxJMZk3SoqKpI/PUGwQaEFKGIg2brF
        Th1+Bkc0yXoh0e49fPm2jhF2hlA=
X-Google-Smtp-Source: AMsMyM4O5iGbs4pYw4R/DIzFJMeeNajau+8QKMTNsG7BvklrN7LhYjyAUu5S2peKUCqUiqhMhEv1mnU=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:903:258e:b0:17b:a251:c80a with SMTP id
 jb14-20020a170903258e00b0017ba251c80amr32194690plb.110.1665608892519; Wed, 12
 Oct 2022 14:08:12 -0700 (PDT)
Date:   Wed, 12 Oct 2022 14:08:11 -0700
Mime-Version: 1.0
Message-ID: <Y0csu2SwegJ8Tab+@google.com>
Subject: Lockdep warning after c0feea594e058223973db94c1c32a830c9807c86
From:   sdf@google.com
To:     john.fastabend@gmail.com, jakub@cloudflare.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi John & Jakub,

Upstream commit c0feea594e05 ("workqueue: don't skip lockdep work
dependency in cancel_work_sync()") seems to trigger the following
lockdep warning during test_prog's sockmap_listen:

[  +0.003631] WARNING: possible circular locking dependency detected
[  +0.003647] 6.0.0-dbx-DEV #10 Not tainted
[  +0.002402] ------------------------------------------------------
[  +0.003685] kworker/1:0/23 is trying to acquire lock:
[  +0.003012] ffff888100b1e3f0 (sk_lock-AF_INET){+.+.}-{0:0}, at:  
tcp_sendpage+0x28/0x80
[  +0.004655]
               but task is already holding lock:
[  +0.003434] ffff88810642c360 (&psock->work_mutex){+.+.}-{3:3}, at:  
sk_psock_backlog+0x2e/0x370
[  +0.005043]
               which lock already depends on the new lock.

[  +0.004792]
               the existing dependency chain (in reverse order) is:
[  +0.004397]
               -> #2 (&psock->work_mutex){+.+.}-{3:3}:
[  +0.003732]        __mutex_lock_common+0xdf/0xe70
[  +0.002958]        mutex_lock_nested+0x20/0x30
[  +0.002685]        sk_psock_backlog+0x2e/0x370
[  +0.002689]        process_one_work+0x22c/0x3b0
[  +0.002815]        worker_thread+0x21b/0x400
[  +0.002652]        kthread+0xf7/0x110
[  +0.002406]        ret_from_fork+0x1f/0x30
[  +0.002512]
               -> #1 ((work_completion)(&psock->work)){+.+.}-{0:0}:
[  +0.004457]        __flush_work+0x6b/0xd0
[  +0.002638]        __cancel_work_timer+0x11a/0x1a0
[  +0.002973]        cancel_work_sync+0x10/0x20
[  +0.002724]        sk_psock_stop+0x298/0x2b0
[  +0.002969]        sock_map_close+0xd8/0x140
[  +0.002739]        inet_release+0x57/0x80
[  +0.002475]        sock_close+0x4b/0xe0
[  +0.002380]        __fput+0x101/0x230
[  +0.002347]        ____fput+0xe/0x10
[  +0.002259]        task_work_run+0x5d/0xb0
[  +0.002535]        exit_to_user_mode_loop+0xd6/0xf0
[  +0.003019]        exit_to_user_mode_prepare+0xa6/0x100
[  +0.003201]        syscall_exit_to_user_mode+0x5b/0x160
[  +0.003145]        do_syscall_64+0x49/0x80
[  +0.002549]        entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  +0.003410]
               -> #0 (sk_lock-AF_INET){+.+.}-{0:0}:
[  +0.003906]        __lock_acquire+0x16f4/0x30c0
[  +0.002837]        lock_acquire+0xc5/0x1c0
[  +0.002599]        lock_sock_nested+0x32/0x80
[  +0.002690]        tcp_sendpage+0x28/0x80
[  +0.002435]        inet_sendpage+0x7b/0xe0
[  +0.002534]        kernel_sendpage+0x5d/0xa0
[  +0.002709]        skb_send_sock+0x24b/0x2d0
[  +0.002662]        sk_psock_backlog+0x106/0x370
[  +0.002908]        process_one_work+0x22c/0x3b0
[  +0.002736]        worker_thread+0x21b/0x400
[  +0.002552]        kthread+0xf7/0x110
[  +0.002252]        ret_from_fork+0x1f/0x30
[  +0.002480]
               other info that might help us debug this:

[  +0.004778] Chain exists of:
                 sk_lock-AF_INET --> (work_completion)(&psock->work) -->  
&psock->work_mutex

[  +0.007265]  Possible unsafe locking scenario:

[  +0.003496]        CPU0                    CPU1
[  +0.002717]        ----                    ----
[  +0.002809]   lock(&psock->work_mutex);
[  +0.002335]                                 
lock((work_completion)(&psock->work));
[  +0.004496]                                lock(&psock->work_mutex);
[  +0.003766]   lock(sk_lock-AF_INET);
[  +0.002185]
                *** DEADLOCK ***

[  +0.003600] 3 locks held by kworker/1:0/23:
[  +0.002698]  #0: ffff888100055138 ((wq_completion)events){+.+.}-{0:0},  
at: process_one_work+0x1d6/0x3b0
[  +0.005552]  #1: ffffc900001e7e58  
((work_completion)(&psock->work)){+.+.}-{0:0}, at:  
process_one_work+0x1fc/0x3b0
[  +0.006085]  #2: ffff88810642c360 (&psock->work_mutex){+.+.}-{3:3}, at:  
sk_psock_backlog+0x2e/0x370
[  +0.005424]
               stack backtrace:
[  +0.002689] CPU: 1 PID: 23 Comm: kworker/1:0 Not tainted 6.0.0-dbx-DEV #10
[  +0.004086] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS  
rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
[  +0.006806] Workqueue: events sk_psock_backlog
[  +0.002699] Call Trace:
[  +0.001577]  <TASK>
[  +0.001350]  dump_stack_lvl+0x69/0xaa
[  +0.002225]  dump_stack+0x10/0x12
[  +0.002051]  print_circular_bug+0x289/0x290
[  +0.002531]  check_noncircular+0x12c/0x140
[  +0.002578]  __lock_acquire+0x16f4/0x30c0
[  +0.002483]  ? ret_from_fork+0x1f/0x30
[  +0.002297]  ? __this_cpu_preempt_check+0x13/0x20
[  +0.002869]  ? lock_is_held_type+0xf8/0x160
[  +0.002511]  lock_acquire+0xc5/0x1c0
[  +0.002165]  ? tcp_sendpage+0x28/0x80
[  +0.002367]  lock_sock_nested+0x32/0x80
[  +0.002401]  ? tcp_sendpage+0x28/0x80
[  +0.002262]  tcp_sendpage+0x28/0x80
[  +0.002148]  inet_sendpage+0x7b/0x[   12.231432] sysrq: Power Off
e0
[  +0.002202[   12.234545] kvm: exiting hardware virtualization
]  kernel_sendpage+0x5d/0xa0
[  +0.002277]  skb_send_sock+0x24b/0x2d0
[  +0.002278]  ? _raw_spin_unlock_irqrestore+0x35/0x60
[  +0.003030]  ? __this_cpu_preempt_check+0x13/0x20
[  +0.002861]  ? lockdep_hardirqs_on+0x97/0x140
[  +0.002685]  ? trace_hardirqs_on+0x47/0x50
[  +0.002576]  ? _raw_spin_unlock_irqrestore+0x40/0x60
[  +0.003207]  sk_psock_backlog+0x106/0x370
[  +0.002476]  process_one_work+0x22c/0x3b0
[  +0.002473]  worker_thread+0x21b/0x400
[  +0.002335]  kthread+0xf7/0x110
[  +0.001954]  ? rcu_lock_release+0x20/0x20
[  +0.002444]  ? kthread_blkcg+0x30/0x30
[  +0.002325]  ret_from_fork+0x1f/0x30
[  +0.002221]  </TASK>

This is on bpf-next:

commit d31ada3b511141f4b78cae5a05cc2dad887c40b7 (HEAD -> bpf-next,
bpf-next/master)
Author: David Vernet <void@manifault.com>
Date:   Tue Oct 11 11:52:55 2022 -0500

     selftests/bpf: Alphabetize DENYLISTs

Are you ware? Any idea what's wrong?
Is there some stable fix I'm missing in bpf-next?

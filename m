Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 984296447D9
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 16:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235434AbiLFPUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 10:20:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235201AbiLFPT6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 10:19:58 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66EA263A7;
        Tue,  6 Dec 2022 07:18:19 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id bx10so23995449wrb.0;
        Tue, 06 Dec 2022 07:18:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tVN3fMG+6cD2s/6OLI+89I+1PSP3ud/CsbhzNc4apwM=;
        b=dnZ99HXkwT/9RLfB4GwVErS33uLQn27GT+0d1Uf6eEtxEEbw07hvT74JRqH6QeCIvU
         7A8uArJjFNOrXGCpr6Cz8VA39kwQ/n7rP06MfTX8HlHWw5WqAUW57EvZlbKY6huRa9bZ
         NpW+FKvEstwZu9PJu9vZE+BXhfscF8yLrRENh7zoZmsAz4pozuUd/pt6ukC1Px9Ydfwn
         jDDx6sWLb6h9GcR2Eyic/+T1kDqs5tXin17OOey+i7mDvWr9z42xPuuy5A5KlfXCDbNg
         PCVk1xHxIktbNwIsHHNrKZfMYZ3QwWBLrsAj3Bwhgsq7sd+ZZVvE7ZHfCn/4L/UrY+z9
         +d9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tVN3fMG+6cD2s/6OLI+89I+1PSP3ud/CsbhzNc4apwM=;
        b=uI2nSxLj7DFiiN7AwRk6t+001vjIqL1+kXmXoTq6Zk+5gV3XC6iFcq9nsM3b0Dr0rh
         dEwIdU32Lt8cpRj3hfkI9wPtzs9OQ1HEkt9jLVyGjyP4nd/SpYku+YtneJKToqe0DFv1
         7fUcHf0/8YrC6qpfvIBGZxjxpCUmbMYM3iKQavdUp6S7ZmvK2pKNofqN3JSKhEZFVdac
         Ki29ieM+rDAyPHKYW502yTq6glMEZnldf5wbk2re/mcKfS2nLzgy+6t/jDeA9m2FJfNQ
         5ZQPNx9WJy90PFILHfbTRYjvPQu0HFYdsX6cBn3OpdG8SEbdfdY0tU1yLfy8f2UFMmPy
         H8Lw==
X-Gm-Message-State: ANoB5pmtUaf1Yq+/IGJSu8vaAAaX8HJl+RS/+Csh4zfNi1PfQO63fbS0
        iNAkv9Qh3q1SO3ULK/cOgGs=
X-Google-Smtp-Source: AA0mqf7zKxeKxK7Qa3b87XO0sls9S4QyOxvL+iqAIZpJxnpkuxq42gYIg8NNDwgeWdTzMaWmBlBqQA==
X-Received: by 2002:adf:fd01:0:b0:235:83aa:a6ed with SMTP id e1-20020adffd01000000b0023583aaa6edmr50887987wrr.543.1670339897777;
        Tue, 06 Dec 2022 07:18:17 -0800 (PST)
Received: from krava (2001-1ae9-1c2-4c00-726e-c10f-8833-ff22.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:726e:c10f:8833:ff22])
        by smtp.gmail.com with ESMTPSA id hg6-20020a05600c538600b003a6125562e1sm21333257wmb.46.2022.12.06.07.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 07:18:17 -0800 (PST)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Tue, 6 Dec 2022 16:18:09 +0100
To:     Hao Sun <sunhao.th@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, hawk@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: BUG: unable to handle kernel paging request in bpf_dispatcher_xdp
Message-ID: <Y49dMUsX2YgHK0J+@krava>
References: <CACkBjsYioeJLhJAZ=Sq4CAL2O_W+5uqcJynFgLSizWLqEjNrjw@mail.gmail.com>
 <CACkBjsbD4SWoAmhYFR2qkP1b6JHO3Og0Vyve0=FO-Jb2JGGRfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACkBjsbD4SWoAmhYFR2qkP1b6JHO3Og0Vyve0=FO-Jb2JGGRfw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 02:46:43PM +0800, Hao Sun wrote:
> Hao Sun <sunhao.th@gmail.com> 于2022年12月6日周二 11:28写道：
> >
> > Hi,
> >
> > The following crash can be triggered with the BPF prog provided.
> > It seems the verifier passed some invalid progs. I will try to simplify
> > the C reproducer, for now, the following can reproduce this:
> >
> > HEAD commit: ab0350c743d5 selftests/bpf: Fix conflicts with built-in
> > functions in bpf_iter_ksym
> > git tree: bpf-next
> > console log: https://pastebin.com/raw/87RCSnCs
> > kernel config: https://pastebin.com/raw/rZdWLcgK
> > Syz reproducer: https://pastebin.com/raw/4kbwhdEv
> > C reproducer: https://pastebin.com/raw/GFfDn2Gk
> >
> 
> Simplified C reproducer: https://pastebin.com/raw/aZgLcPvW
> 
> Only two syscalls are required to reproduce this, seems it's an issue
> in XDP test run. Essentially, the reproducer just loads a very simple
> prog and tests run repeatedly and concurrently:
> 
> r0 = bpf$PROG_LOAD(0x5, &(0x7f0000000640)=@base={0x6, 0xb,
> &(0x7f0000000500)}, 0x80)
> bpf$BPF_PROG_TEST_RUN(0xa, &(0x7f0000000140)={r0, 0x0, 0x0, 0x0, 0x0,
> 0x0, 0xffffffff, 0x0, 0x0, 0x0, 0x0, 0x0}, 0x48)
> 
> Loaded prog:
>    0: (18) r0 = 0x0
>    2: (18) r6 = 0x0
>    4: (18) r7 = 0x0
>    6: (18) r8 = 0x0
>    8: (18) r9 = 0x0
>   10: (95) exit

hi,
I can reproduce with your config.. it seems related to the
recent static call change:
  c86df29d11df bpf: Convert BPF_DISPATCHER to use static_call() (not ftrace)

I can't reproduce when I revert that commit.. Peter, any idea?

thanks,
jirka

> 
> > wlan1: Creating new IBSS network, BSSID 50:50:50:50:50:50
> > IPv6: ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
> > wlan1: Created IBSS using preconfigured BSSID 50:50:50:50:50:50
> > wlan1: Creating new IBSS network, BSSID 50:50:50:50:50:50
> > IPv6: ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
> > BUG: unable to handle page fault for address: 000000000fe0840f
> > #PF: supervisor write access in kernel mode
> > #PF: error_code(0x0002) - not-present page
> > PGD 2ebe3067 P4D 2ebe3067 PUD 1dd9b067 PMD 0
> > Oops: 0002 [#1] PREEMPT SMP KASAN
> > CPU: 0 PID: 7536 Comm: a.out Not tainted
> > 6.1.0-rc7-01489-gab0350c743d5-dirty #118
> > Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux
> > 1.16.1-1-1 04/01/2014
> > RIP: 0010:bpf_dispatcher_xdp+0x24/0x1000
> > Code: cc cc cc cc cc cc 48 81 fa e8 55 00 a0 0f 8f 63 00 00 00 48 81
> > fa d8 54 00 a0 7f 2a 48 81 fa 4c 53 00 a0 7f 11 48 81 fa 4c 53 <00> a0
> > 0f 84 e0 0f 00 00 ff e2 66 90 48 81 fa d8 54 00 a0 0f 84 5b
> > RSP: 0018:ffffc900029df908 EFLAGS: 00010246
> > RAX: 0000000000000000 RBX: ffffc900028b9000 RCX: 0000000000000000
> > RDX: ffffffffa000534c RSI: ffffc900028b9048 RDI: ffffc900029dfb70
> > RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
> > R10: 0000000000000001 R11: 0000000000000000 R12: dffffc0000000000
> > R13: 0000000000000001 R14: ffffc900028b9030 R15: ffffc900029dfb50
> > FS:  00007ff249efc700(0000) GS:ffff888063a00000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 000000000fe0840f CR3: 000000002e0ba000 CR4: 0000000000750ef0
> > PKRU: 55555554
> > Call Trace:
> >  <TASK>
> >  ? __bpf_prog_run include/linux/filter.h:600 [inline]
> >  ? bpf_prog_run_xdp include/linux/filter.h:775 [inline]
> >  ? bpf_test_run+0x2ce/0x990 net/bpf/test_run.c:400
> >  ? bpf_test_timer_continue+0x3d0/0x3d0 net/bpf/test_run.c:79
> >  ? bpf_dispatcher_xdp+0x800/0x1000
> >  ? bpf_dispatcher_xdp+0x800/0x1000
> >  ? bpf_dispatcher_xdp+0x800/0x1000
> >  ? _copy_from_user+0x5f/0x180 lib/usercopy.c:21
> >  ? bpf_test_init.isra.0+0x111/0x150 net/bpf/test_run.c:772
> >  ? bpf_prog_test_run_xdp+0xbde/0x1400 net/bpf/test_run.c:1389
> >  ? bpf_prog_test_run_skb+0x1dd0/0x1dd0 include/linux/skbuff.h:2594
> >  ? rcu_lock_release include/linux/rcupdate.h:321 [inline]
> >  ? rcu_read_unlock include/linux/rcupdate.h:783 [inline]
> >  ? __fget_files+0x283/0x3e0 fs/file.c:914
> >  ? fput+0x30/0x1a0 fs/file_table.c:371
> >  ? ____bpf_prog_get kernel/bpf/syscall.c:2206 [inline]
> >  ? __bpf_prog_get+0x9a/0x2e0 kernel/bpf/syscall.c:2270
> >  ? bpf_prog_test_run_skb+0x1dd0/0x1dd0 include/linux/skbuff.h:2594
> >  ? bpf_prog_test_run kernel/bpf/syscall.c:3644 [inline]
> >  ? __sys_bpf+0x1293/0x5840 kernel/bpf/syscall.c:4997
> >  ? futex_wait_setup+0x230/0x230 kernel/futex/waitwake.c:625
> >  ? bpf_perf_link_attach+0x520/0x520 kernel/bpf/syscall.c:2720
> >  ? instrument_atomic_read include/linux/instrumented.h:72 [inline]
> >  ? atomic_read include/linux/atomic/atomic-instrumented.h:27 [inline]
> >  ? queued_spin_is_locked include/asm-generic/qspinlock.h:57 [inline]
> >  ? debug_spin_unlock kernel/locking/spinlock_debug.c:100 [inline]
> >  ? do_raw_spin_unlock+0x53/0x230 kernel/locking/spinlock_debug.c:140
> >  ? futex_wake+0x15b/0x4a0 kernel/futex/waitwake.c:161
> >  ? do_futex+0x130/0x350 kernel/futex/syscalls.c:122
> >  ? __ia32_sys_get_robust_list+0x3b0/0x3b0 kernel/futex/syscalls.c:72
> >  ? __do_sys_bpf kernel/bpf/syscall.c:5083 [inline]
> >  ? __se_sys_bpf kernel/bpf/syscall.c:5081 [inline]
> >  ? __x64_sys_bpf+0x78/0xc0 kernel/bpf/syscall.c:5081
> >  ? syscall_enter_from_user_mode+0x26/0xb0 kernel/entry/common.c:111
> >  ? do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >  ? do_syscall_64+0x38/0xb0 arch/x86/entry/common.c:80
> >  ? entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >  </TASK>
> > Modules linked in:
> > Dumping ftrace buffer:
> >    (ftrace buffer empty)
> > CR2: 000000000fe0840f
> > ---[ end trace 0000000000000000 ]---
> > RIP: 0010:bpf_dispatcher_xdp+0x24/0x1000
> > Code: cc cc cc cc cc cc 48 81 fa e8 55 00 a0 0f 8f 63 00 00 00 48 81
> > fa d8 54 00 a0 7f 2a 48 81 fa 4c 53 00 a0 7f 11 48 81 fa 4c 53 <00> a0
> > 0f 84 e0 0f 00 00 ff e2 66 90 48 81 fa d8 54 00 a0 0f 84 5b
> > RSP: 0018:ffffc900029df908 EFLAGS: 00010246
> > RAX: 0000000000000000 RBX: ffffc900028b9000 RCX: 0000000000000000
> > RDX: ffffffffa000534c RSI: ffffc900028b9048 RDI: ffffc900029dfb70
> > RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
> > R10: 0000000000000001 R11: 0000000000000000 R12: dffffc0000000000
> > R13: 0000000000000001 R14: ffffc900028b9030 R15: ffffc900029dfb50
> > FS:  00007ff249efc700(0000) GS:ffff888063a00000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 000000000fe0840f CR3: 000000002e0ba000 CR4: 0000000000750ef0
> > PKRU: 55555554

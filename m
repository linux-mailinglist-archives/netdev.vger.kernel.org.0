Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED8C532F53D
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 22:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbhCEVRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 16:17:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbhCEVRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 16:17:23 -0500
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D742C06175F
        for <netdev@vger.kernel.org>; Fri,  5 Mar 2021 13:17:23 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id x10so3449869qkm.8
        for <netdev@vger.kernel.org>; Fri, 05 Mar 2021 13:17:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YS67vMflJW97a3c03YUjpjyl1DBxu/orOO1PCrzTovY=;
        b=wJWdTjN9xc/aBqWWk4r/llFIBBLfNqf68/R9DQCdI/ygb6XaY7QQWoEYvnUcz8LmmS
         Oi0+j/0h+pQ3KtgCxIGiwL8ldqm8zS3Pl2RYz0AAPqacMUuHus9d3rBpuuyS1UYolnhF
         i8OMGmCn52Jxh5snx/21bjUFprJwDqKxQhU9bV7ZkDLN1QuI/0G0unLpfJrKaKKw2pOl
         LcKnVJUWrTfTcLyOXGF4TYML5MGmC1TqXF1c1MY8/uBU4v0jbydpSDJgtWpzNL9hfqld
         gzBvtixwzIgmEcEMHGmf+KnR3ZXD3Re7MbV0paYhNWDyfroHaDl29khkOhKCDo84YpPd
         x1gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YS67vMflJW97a3c03YUjpjyl1DBxu/orOO1PCrzTovY=;
        b=SHSXzzNffkZVFcfH3bLMhfGHJB+TWUKhm9Dfd/wXfj+hsRUBWgNtiCcPA1cQEyEAo4
         GWln3VIiGedpYWP+l8dCJ3/nEa/ETgNcsjhtHju/LUNevIQ/3/PoO3SDNWE5Fv9aYBXu
         CN7Nyn0aK5WO1OU/virE1y0bGhCMYh6SSi6euUwWI5gFzbDT4Jn+uo5iTFzf5BVL3Yve
         HEECdRluG+xwoRePhLNurXb8PGs2Ge/1ls7/yS07WXk0sWQJcRSSVpyS6a5l5JZ+rmij
         HEksgp3XH9BG9gQ7MJrY3pz3mEvydKqJzlHphoYXNOHzlCt83A0e0YW0kWbCHXEb3LMh
         kiXw==
X-Gm-Message-State: AOAM531U+oX8yiwwATD2KYvWjpS8YORbOXC+6WtzqBmqn6Bk13GixK8O
        jDU1rdAwLlC2xCYxJnEtCzaiC1CaSOOiGqzXLiwbQw==
X-Google-Smtp-Source: ABdhPJyMIfK5NpYT50u8oiXSCZxf5EIy23Gd0E0junbugcJzCgpLOVvy9i3iRAMJPJ72xrBGbQ//BK50i7+OzXinmKY=
X-Received: by 2002:a05:620a:819:: with SMTP id s25mr8953423qks.485.1614979041955;
 Fri, 05 Mar 2021 13:17:21 -0800 (PST)
MIME-Version: 1.0
References: <YEEvBUiJl2pJkxTd@krava> <YEKWyLG20OgpBMnt@carbon.DHCP.thefacebook.com>
 <14570a91-a793-3f56-047f-5c203cc44345@fb.com>
In-Reply-To: <14570a91-a793-3f56-047f-5c203cc44345@fb.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 5 Mar 2021 13:17:11 -0800
Message-ID: <CAKH8qBuXCfUz=w8L+Fj74OaUpbosO29niYwTki7e3Ag044_aww@mail.gmail.com>
Subject: Re: [BUG] hitting bug when running spinlock test
To:     Yonghong Song <yhs@fb.com>
Cc:     Roman Gushchin <guro@fb.com>, Jiri Olsa <jolsa@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        YiFei Zhu <zhuyifei@google.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Yauheni Kaliuta <ykaliuta@redhat.com>,
        Jiri Benc <jbenc@redhat.com>, Hangbin Liu <haliu@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 5, 2021 at 1:10 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 3/5/21 12:38 PM, Roman Gushchin wrote:
> > On Thu, Mar 04, 2021 at 08:03:33PM +0100, Jiri Olsa wrote:
> >> hi,
> >> I'm getting attached BUG/crash when running in parralel selftests, like:
> >>
> >>    while :; do ./test_progs -t spinlock; done
> >>    while :; do ./test_progs ; done
> >>
> >> it's the latest bpf-next/master, I can send the .config if needed,
> >> but I don't think there's anything special about it, because I saw
> >> the bug on other servers with different generic configs
> >>
> >> it looks like it's related to cgroup local storage, for some reason
> >> the storage deref returns NULL
> >>
> >> I'm bit lost in this code, so any help would be great ;-)
> >
> > Hi!
> >
> > I think the patch to blame is df1a2cb7c74b ("bpf/test_run: fix unkillable BPF_PROG_TEST_RUN").
>
> Thanks, Roman, I did some experiments and found the reason of NULL
> storage deref is because a tracing program (mostly like a kprobe) is run
> after bpf_cgroup_storage_set() is called but before bpf program calls
> bpf_get_local_storage(). Note that trace_call_bpf() macro
> BPF_PROG_RUN_ARRAY_CHECK does call bpf_cgroup_storage_set().
>
> > Prior to it, we were running the test program in the preempt_disable() && rcu_read_lock()
> > section:
> >
> > preempt_disable();
> > rcu_read_lock();
> > bpf_cgroup_storage_set(storage);
> > ret = BPF_PROG_RUN(prog, ctx);
> > rcu_read_unlock();
> > preempt_enable();
> >
> > So, a percpu variable with a cgroup local storage pointer couldn't go away.
>
> I think even with using preempt_disable(), if the bpf program calls map
> lookup and there is a kprobe bpf on function htab_map_lookup_elem(), we
> will have the issue as BPF_PROG_RUN_ARRAY_CHECK will call
> bpf_cgroup_storage_set() too. I need to write a test case to confirm
> this though.
>
> >
> > After df1a2cb7c74b we can temporarily enable the preemption, so nothing prevents
> > another program to call into bpf_cgroup_storage_set() on the same cpu.
> > I guess it's exactly what happens here.
>
> It is. I confirmed.
>
> >
> > One option to fix it is to make bpf_cgroup_storage_set() to return the old value,
> > save it on a local variable and restore after the execution of the program.
>
> In this particular case, we are doing bpf_test_run, we explicitly
> allocate storage and call bpf_cgroup_storage_set() right before
> each BPF_PROG_RUN.
>
> > But I didn't follow closely the development of sleepable bpf programs, so I could
> > easily miss something.
>
> Yes, sleepable bpf program is another complication. I think we need a
> variable similar to bpf_prog_active, which should not nested bpf program
> execution for those bpf programs having local_storage map.
> Will try to craft some patch to facilitate the discussion.
Can we add a new argument to bpf_cgroup_storage_set to save existing
per-cpu values (on the stack) such that we can restore them later,
after BPF_PROG_RUN finishes?
Is it too much overhead?


>
> >
> > Thanks!
> >
> > Roman
> >
> >>
> >> thanks,
> >> jirka
> >>
> >>
> >> ---
> >> ...
> >> [  382.324440] bpf_testmod: loading out-of-tree module taints kernel.
> >> [  382.330670] bpf_testmod: module verification failed: signature and/or required key missing - tainting kernel
> >> [  480.391667] perf: interrupt took too long (2540 > 2500), lowering kernel.perf_event_max_sample_rate to 78000
> >> [  480.401730] perf: interrupt took too long (6860 > 6751), lowering kernel.perf_event_max_sample_rate to 29000
> >> [  480.416172] perf: interrupt took too long (8602 > 8575), lowering kernel.perf_event_max_sample_rate to 23000
> >> [  480.433053] BUG: kernel NULL pointer dereference, address: 0000000000000000
> >> [  480.440014] #PF: supervisor read access in kernel mode
> >> [  480.445153] #PF: error_code(0x0000) - not-present page
> >> [  480.450294] PGD 8000000133a18067 P4D 8000000133a18067 PUD 10c019067 PMD 0
> >> [  480.457164] Oops: 0000 [#1] PREEMPT SMP PTI
> >> [  480.461350] CPU: 6 PID: 16689 Comm: test_progs Tainted: G          IOE     5.11.0+ #11
> >> [  480.469263] Hardware name: Dell Inc. PowerEdge R440/08CYF7, BIOS 1.7.0 12/14/2018
> >> [  480.476742] RIP: 0010:bpf_get_local_storage+0x13/0x50
> >> [  480.481797] Code: e8 92 c5 8e 00 5d 89 c0 c3 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 0f 1f 44 00 00 83 7f 18 15 74 10 65 48 8b 05 6d c6 e2 7e <48> 8b 00 48 83 c0 10 c3 55 48 89 e5 53 65 48 8b 05 60 c6 e2 7e8
> >> [  480.500540] RSP: 0018:ffffc90001bd3ce0 EFLAGS: 00010293
> >> [  480.505766] RAX: 0000000000000000 RBX: 982a259500000000 RCX: 0000000000000018
> >> [  480.512901] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff888149ccf000
> >> [  480.520034] RBP: ffffc90001bd3d20 R08: ffffc90001bd3d04 R09: ffff888105121600
> >> [  480.527164] R10: d3b9342000000000 R11: 000000000000025c R12: 0000000000000734
> >> [  480.534299] R13: ffff888149ccc710 R14: 0000000000000000 R15: ffffc90000379048
> >> [  480.541430] FS:  00007f8f2357b640(0000) GS:ffff8897e0980000(0000) knlGS:0000000000000000
> >> [  480.549515] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >> [  480.555262] CR2: 0000000000000000 CR3: 000000014e826006 CR4: 00000000007706e0
> >> [  480.562395] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >> [  480.569527] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> >> [  480.576660] PKRU: 55555554
> >> [  480.579372] Call Trace:
> >> [  480.581829]  ? bpf_prog_c48154a736e5c014_bpf_sping_lock_test+0x2ba/0x860
> >> [  480.588526]  bpf_test_run+0x127/0x2b0
> >> [  480.592192]  ? __build_skb_around+0xb0/0xc0
> >> [  480.596378]  bpf_prog_test_run_skb+0x32f/0x6b0
> >> [  480.600824]  __do_sys_bpf+0xa94/0x2240
> >> [  480.604577]  ? debug_smp_processor_id+0x17/0x20
> >> [  480.609107]  ? __perf_event_task_sched_in+0x32/0x340
> >> [  480.614077]  __x64_sys_bpf+0x1a/0x20
> >> [  480.617653]  do_syscall_64+0x38/0x50
> >> [  480.621233]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> >> [  480.626286] RIP: 0033:0x7f8f2467f55d
> >> [  480.629865] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d eb 78 0c 00 f7 d8 64 89 018
> >> [  480.648611] RSP: 002b:00007f8f2357ad58 EFLAGS: 00000206 ORIG_RAX: 0000000000000141
> >> [  480.656175] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f8f2467f55d
> >> [  480.663308] RDX: 0000000000000078 RSI: 00007f8f2357ad60 RDI: 000000000000000a
> >> [  480.670442] RBP: 00007f8f2357ae28 R08: 0000000000000000 R09: 0000000000000008
> >> [  480.677574] R10: 0000000000000000 R11: 0000000000000206 R12: 00007f8f2357ae2c
> >> [  480.684707] R13: 00000000022df420 R14: 0000000000000000 R15: 00007f8f2357b640
> >> [  480.691842] Modules linked in: bpf_testmod(OE) intel_rapl_msr intel_rapl_common x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm ipmi_ssif irqbypass rapl intel_cstate dell_smbios intel_uncore mei_]
> >> [  480.739134] CR2: 0000000000000000
> >> [  480.742452] ---[ end trace 807177cbb5e3b3da ]---
> >> [  480.752174] RIP: 0010:bpf_get_local_storage+0x13/0x50
> >> [  480.757230] Code: e8 92 c5 8e 00 5d 89 c0 c3 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 0f 1f 44 00 00 83 7f 18 15 74 10 65 48 8b 05 6d c6 e2 7e <48> 8b 00 48 83 c0 10 c3 55 48 89 e5 53 65 48 8b 05 60 c6 e2 7e8
> >> [  480.775976] RSP: 0018:ffffc90001bd3ce0 EFLAGS: 00010293
> >> [  480.781202] RAX: 0000000000000000 RBX: 982a259500000000 RCX: 0000000000000018
> >> [  480.788335] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff888149ccf000
> >> [  480.795466] RBP: ffffc90001bd3d20 R08: ffffc90001bd3d04 R09: ffff888105121600
> >> [  480.802598] R10: d3b9342000000000 R11: 000000000000025c R12: 0000000000000734
> >> [  480.809730] R13: ffff888149ccc710 R14: 0000000000000000 R15: ffffc90000379048
> >> [  480.816865] FS:  00007f8f2357b640(0000) GS:ffff8897e0980000(0000) knlGS:0000000000000000
> >> [  480.824951] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >> [  480.830695] CR2: 0000000000000000 CR3: 000000014e826006 CR4: 00000000007706e0
> >> [  480.837829] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >> [  480.844961] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> >> [  480.852093] PKRU: 55555554
> >>

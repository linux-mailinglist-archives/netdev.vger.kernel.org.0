Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2284B48F4D2
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 05:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbiAOEw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 23:52:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232330AbiAOEw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 23:52:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97151C061574;
        Fri, 14 Jan 2022 20:52:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34CFBB82A3F;
        Sat, 15 Jan 2022 04:52:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13291C36AE3;
        Sat, 15 Jan 2022 04:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642222345;
        bh=kSCnrayE8Mo1ZIMcOG8B3aBkGFLr6EGhQVWCkHxVQUU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QWaz6iKhyIEz8G4LFQIttgPQWdtBsy9HFLengeCDlgwR4uVUAMeWeY+6JE1DoF6h0
         IMAfEcJWDbYYr/I23d6Or+93YACdc4oAqAJwFQcVSCkcNg0OpbpbUzWCyzjUBcuB7i
         iYNtsNOqvSHmlsW+Yj5A7F0YzLyP2GswfjKRrL8wtyy+OPR3CtayukTsumfYzH/V7G
         okYRmvOfFW5sdsYB6/1JicNPE0LKVQqmd4kypyztEO4VJ5lTSSuidocFgk3Z21nl+V
         NE06EzD5IhnqB/OnKD219ptgLL2JthgY7g+/FM6wzQ8ubXeEJP8RzNNBLhZS7JxCrO
         gBN/JA9AYZe4A==
Date:   Sat, 15 Jan 2022 13:52:19 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH v2 0/8] fprobe: Introduce fprobe function entry/exit
 probe
Message-Id: <20220115135219.64ef1cc6482d5de8a3bce9b0@kernel.org>
In-Reply-To: <YeAatqQTKsrxmUkS@krava>
References: <164199616622.1247129.783024987490980883.stgit@devnote2>
        <Yd77SYWgtrkhFIYz@krava>
        <YeAatqQTKsrxmUkS@krava>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Jan 2022 13:27:34 +0100
Jiri Olsa <jolsa@redhat.com> wrote:

> On Wed, Jan 12, 2022 at 05:01:15PM +0100, Jiri Olsa wrote:
> > On Wed, Jan 12, 2022 at 11:02:46PM +0900, Masami Hiramatsu wrote:
> > > Hi Jiri and Alexei,
> > > 
> > > Here is the 2nd version of fprobe. This version uses the
> > > ftrace_set_filter_ips() for reducing the registering overhead.
> > > Note that this also drops per-probe point private data, which
> > > is not used anyway.
> > > 
> > > This introduces the fprobe, the function entry/exit probe with
> > > multiple probe point support. This also introduces the rethook
> > > for hooking function return as same as kretprobe does. This
> > 
> > nice, I was going through the multi-user-graph support 
> > and was wondering that this might be a better way
> > 
> > > abstraction will help us to generalize the fgraph tracer,
> > > because we can just switch it from rethook in fprobe, depending
> > > on the kernel configuration.
> > > 
> > > The patch [1/8] and [7/8] are from your series[1]. Other libbpf
> > > patches will not be affected by this change.
> > 
> > I'll try the bpf selftests on top of this
> 
> I'm getting crash and stall when running bpf selftests,
> the fprobe sample module works fine, I'll check on that

OK, I got a kernel stall. I missed to enable CONFIG_FPROBE.
I think vmtest.sh should support menuconfig option.

#6 bind_perm:OK
#7 bloom_filter_map:OK
[  107.282403] clocksource: timekeeping watchdog on CPU0: Marking clocksource 'tsc' as unstable because the skew is too large:
[  107.283240] clocksource:                       'hpet' wd_nsec: 496216090 wd_now: 7ddc7120 wd_last: 7ae746b7 mask: ffffffff
[  107.284045] clocksource:                       'tsc' cs_nsec: 495996979 cs_now: 31fdb69b39 cs_last: 31c2d29219 mask: ffffffffffffffff
[  107.284926] clocksource:                       'tsc' is current clocksource.
[  107.285487] tsc: Marking TSC unstable due to clocksource watchdog
[  107.285973] TSC found unstable after boot, most likely due to broken BIOS. Use 'tsc=unstable'.
[  107.286616] sched_clock: Marking unstable (107240582544, 45390230)<-(107291410145, -5437339)
[  107.290408] clocksource: Not enough CPUs to check clocksource 'tsc'.
[  107.290879] clocksource: Switched to clocksource hpet
[  604.210415] INFO: rcu_tasks detected stalls on tasks:
[  604.210830] (____ptrval____): .. nvcsw: 86/86 holdout: 1 idle_cpu: -1/0
[  604.211314] task:test_progs      state:R  running task     stack:    0 pid:   87 ppid:    85 flags:0x00004000
[  604.212058] Call Trace:
[  604.212246]  <TASK>
[  604.212452]  __schedule+0x362/0xbb0
[  604.212723]  ? preempt_schedule_notrace_thunk+0x16/0x18
[  604.213107]  preempt_schedule_notrace+0x48/0x80
[  604.217403]  ? asm_sysvec_apic_timer_interrupt+0x12/0x20
[  604.217790]  ? ftrace_regs_call+0xd/0x52
[  604.218087]  ? bpf_test_finish.isra.0+0x190/0x190
[  604.218461]  ? bpf_fentry_test1+0x5/0x10
[  604.218750]  ? trace_clock_x86_tsc+0x10/0x10
[  604.219064]  ? __sys_bpf+0x8b1/0x2970
[  604.219337]  ? lock_is_held_type+0xd7/0x130
[  604.219680]  ? __x64_sys_bpf+0x1c/0x20
[  604.219957]  ? do_syscall_64+0x35/0x80
[  604.220237]  ? entry_SYSCALL_64_after_hwframe+0x44/0xae
[  604.220653]  </TASK>

Jiri, is that what you had seen? 


Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>

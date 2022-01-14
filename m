Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 572C148EBF6
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 15:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241986AbiANOrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 09:47:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50212 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231920AbiANOrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 09:47:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C03E861E96;
        Fri, 14 Jan 2022 14:47:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C81C36AE5;
        Fri, 14 Jan 2022 14:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642171630;
        bh=qHWrUmeiZSefYYwS58iqTPXzITzDmFN48zXbQXZimWs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kdQgPnfDGxD87/z11qY6V9c3zmpICJbRX00TrZn1aTGgnGpmrHT27bf+ibRb3nY6F
         9wM9CF2zkvP7AIHBk3YrpygLhSXOplR3ROk5BI/IEjzKkbomUK0U+2Vz/+quhHu/8a
         NO9Xw60LjQ7XBBXhSnW8iRqWTAh3JOKLBOsN4TPX8FJcYqWCvxpkQ+AUnH+D+Ukqqr
         T7hYoxQ9Fesf4Ckh8eokUYo1CzsIcQh1GMKvX96hMV+9lK4ooA3Zn1mUTNBhse0MuL
         EqgVG42K6zUzShv+Y8p1KjrDMOUPT1/a6yfZvJ07HwzxAqJ2SxikbC+R/imbVe+xLP
         9ahuXzQr6nZ9A==
Date:   Fri, 14 Jan 2022 23:47:04 +0900
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
Message-Id: <20220114234704.41f28e8b5e63368c655d848e@kernel.org>
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

Hi Jiri and Alexei,

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

I've tried to build tools/testing/selftests/bpf on my machine,
but I got below errors. Would you know how I can setup to build
the bpf selftests correctly? (I tried "make M=samples/bpf", but same result)

~/ksrc/linux/tools/testing/selftests/bpf$ make 
[...]
  CLANG   /home/mhiramat/ksrc/linux/tools/testing/selftests/bpf/tools/build/bpftool/pid_iter.bpf.o
skeleton/pid_iter.bpf.c:35:10: error: incomplete definition of type 'struct bpf_link'
                return BPF_CORE_READ((struct bpf_link *)ent, id);
                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/home/mhiramat/ksrc/linux/tools/testing/selftests/bpf/tools/build/bpftool//bootstrap/libbpf//include/bpf/bpf_core_read.h:403:2: note: expanded from macro 'BPF_CORE_READ'
        ___type((src), a, ##__VA_ARGS__) __r;                               \
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/home/mhiramat/ksrc/linux/tools/testing/selftests/bpf/tools/build/bpftool//bootstrap/libbpf//include/bpf/bpf_core_read.h:274:29: note: expanded from macro '___type'
#define ___type(...) typeof(___arrow(__VA_ARGS__))
                            ^~~~~~~~~~~~~~~~~~~~~
/home/mhiramat/ksrc/linux/tools/testing/selftests/bpf/tools/build/bpftool//bootstrap/libbpf//include/bpf/bpf_core_read.h:272:23: note: expanded from macro '___arrow'
#define ___arrow(...) ___apply(___arrow, ___narg(__VA_ARGS__))(__VA_ARGS__)
                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
/home/mhiramat/ksrc/linux/tools/testing/selftests/bpf/tools/build/bpftool//bootstrap/libbpf//include/bpf/bpf_core_read.h:223:25: note: expanded from macro '___concat'
#define ___concat(a, b) a ## b
                        ^
<scratch space>:16:1: note: expanded from here
___arrow2
^
/home/mhiramat/ksrc/linux/tools/testing/selftests/bpf/tools/build/bpftool//bootstrap/libbpf//include/bpf/bpf_core_read.h:263:26: note: expanded from macro '___arrow2'
#define ___arrow2(a, b) a->b
                        ~^
skeleton/pid_iter.bpf.c:35:32: note: forward declaration of 'struct bpf_link'
                return BPF_CORE_READ((struct bpf_link *)ent, id);
                                             ^
skeleton/pid_iter.bpf.c:35:10: error: incomplete definition of type 'struct bpf_link'
                return BPF_CORE_READ((struct bpf_link *)ent, id);
                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/home/mhiramat/ksrc/linux/tools/testing/selftests/bpf/tools/build/bpftool//bootstrap/libbpf//include/bpf/bpf_core_read.h:404:2: note: expanded from macro 'BPF_CORE_READ'
        BPF_CORE_READ_INTO(&__r, (src), a, ##__VA_ARGS__);                  \
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/home/mhiramat/ksrc/linux/tools/testing/selftests/bpf/tools/build/bpftool//bootstrap/libbpf//include/bpf/bpf_core_read.h:311:2: note: expanded from macro 'BPF_CORE_READ_INTO'
        ___core_read(bpf_core_read, bpf_core_read,                          \
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/home/mhiramat/ksrc/linux/tools/testing/selftests/bpf/tools/build/bpftool//bootstrap/libbpf//include/bpf/bpf_core_read.h:302:2: note: expanded from macro '___core_read'
        ___apply(___core_read, ___empty(__VA_ARGS__))(fn, fn_ptr, dst,      \
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
note: (skipping 3 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
/home/mhiramat/ksrc/linux/tools/testing/selftests/bpf/tools/build/bpftool//bootstrap/libbpf//include/bpf/bpf_core_read.h:296:2: note: expanded from macro '___core_read0'
        ___read(fn, dst, ___type(src), src, a);
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/home/mhiramat/ksrc/linux/tools/testing/selftests/bpf/tools/build/bpftool//bootstrap/libbpf//include/bpf/bpf_core_read.h:277:59: note: expanded from macro '___read'
        read_fn((void *)(dst), sizeof(*(dst)), &((src_type)(src))->accessor)
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~
/home/mhiramat/ksrc/linux/tools/testing/selftests/bpf/tools/build/bpftool//bootstrap/libbpf//include/bpf/bpf_core_read.h:206:79: note: expanded from macro 'bpf_core_read'
        bpf_probe_read_kernel(dst, sz, (const void *)__builtin_preserve_access_index(src))
                                                                                     ^~~
skeleton/pid_iter.bpf.c:35:32: note: forward declaration of 'struct bpf_link'
                return BPF_CORE_READ((struct bpf_link *)ent, id);
                                             ^
skeleton/pid_iter.bpf.c:35:10: error: returning 'void' from a function with incompatible result type '__u32' (aka 'unsigned int')
                return BPF_CORE_READ((struct bpf_link *)ent, id);
                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/home/mhiramat/ksrc/linux/tools/testing/selftests/bpf/tools/build/bpftool//bootstrap/libbpf//include/bpf/bpf_core_read.h:402:36: note: expanded from macro 'BPF_CORE_READ'
#define BPF_CORE_READ(src, a, ...) ({                                       \
                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
skeleton/pid_iter.bpf.c:42:17: warning: declaration of 'struct bpf_iter__task_file' will not be visible outside of this function [-Wvisibility]
int iter(struct bpf_iter__task_file *ctx)
                ^
skeleton/pid_iter.bpf.c:44:25: error: incomplete definition of type 'struct bpf_iter__task_file'
        struct file *file = ctx->file;
                            ~~~^
skeleton/pid_iter.bpf.c:42:17: note: forward declaration of 'struct bpf_iter__task_file'
int iter(struct bpf_iter__task_file *ctx)
                ^
skeleton/pid_iter.bpf.c:45:32: error: incomplete definition of type 'struct bpf_iter__task_file'
        struct task_struct *task = ctx->task;
                                   ~~~^
skeleton/pid_iter.bpf.c:42:17: note: forward declaration of 'struct bpf_iter__task_file'
int iter(struct bpf_iter__task_file *ctx)
                ^
skeleton/pid_iter.bpf.c:76:19: error: incomplete definition of type 'struct bpf_iter__task_file'
        bpf_seq_write(ctx->meta->seq, &e, sizeof(e));
                      ~~~^
skeleton/pid_iter.bpf.c:42:17: note: forward declaration of 'struct bpf_iter__task_file'
int iter(struct bpf_iter__task_file *ctx)
                ^
1 warning and 6 errors generated.
make[1]: *** [Makefile:188: /home/mhiramat/ksrc/linux/tools/testing/selftests/bpf/tools/build/bpftool/pid_iter.bpf.o] Error 1
make: *** [Makefile:219: /home/mhiramat/ksrc/linux/tools/testing/selftests/bpf/tools/sbin/bpftool] Error 2


Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>

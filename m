Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D36DA2268
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 19:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbfH2Rgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 13:36:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:39506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727675AbfH2Rgy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 13:36:54 -0400
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 810652341C
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 17:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567100213;
        bh=ea0FkmH8PXzRBW7RcDTQEVccdf8hPAz7TZuLpvzvZaI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=IKM+nPQ+alg5O5IVfRE/2QO9Ec0GcIu8gegQg/3+boqUxCn4co39iaJ06oHWkQxvS
         vWx+Lu8Ru7lcoA6KM0RLotpwO2EtGh8dBFlUeXLBGnnjFLxMnTU4jYWwD5ml+o/upZ
         YJv/5M2koVM/zHgvNSpL6VbAuEo5Rr3UjkNsAaTY=
Received: by mail-wm1-f41.google.com with SMTP id p13so4703375wmh.1
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 10:36:53 -0700 (PDT)
X-Gm-Message-State: APjAAAUm1xjV+Vwi5aVMY6/ksJIbF4V4LJUi8SmdYdsipKw1GgKlymGH
        Btf/4n9AtJ0kDdcmnS71piPO7IrUOrOL5BHtkNR4zA==
X-Google-Smtp-Source: APXvYqygGVqJ1zS6mVlVm9RUh+IxDMWHbVhAGM9wKUXsszCSiT4u/WM3d1Iy9ZTHTQB+lr9p94LELbHNcWUtCs4z3mI=
X-Received: by 2002:a05:600c:24cf:: with SMTP id 15mr13061992wmu.76.1567100211920;
 Thu, 29 Aug 2019 10:36:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190827205213.456318-1-ast@kernel.org> <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
 <20190828071421.GK2332@hirez.programming.kicks-ass.net> <20190828220826.nlkpp632rsomocve@ast-mbp.dhcp.thefacebook.com>
 <20190829093434.36540972@gandalf.local.home> <CALCETrWYu0XB_d-MhXFgopEmBu-pog493G1e+KsE3dS32UULgA@mail.gmail.com>
 <20190829172309.xd73ax4wgsjmv6zg@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20190829172309.xd73ax4wgsjmv6zg@ast-mbp.dhcp.thefacebook.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 29 Aug 2019 10:36:39 -0700
X-Gmail-Original-Message-ID: <CALCETrUJt9YgV_q2EuqS0-u0HzLrTopkMkvO+NC05C13xUnDxw@mail.gmail.com>
Message-ID: <CALCETrUJt9YgV_q2EuqS0-u0HzLrTopkMkvO+NC05C13xUnDxw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 29, 2019 at 10:23 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Aug 29, 2019 at 08:43:23AM -0700, Andy Lutomirski wrote:
> >
> > I can imagine splitting it into three capabilities:
> >
> > CAP_TRACE_KERNEL: learn which kernel functions are called when.  This
> > would allow perf profiling, for example, but not sampling of kernel
> > regs.
> >
> > CAP_TRACE_READ_KERNEL_DATA: allow the tracing, profiling, etc features
> > that can read the kernel's data.  So you get function arguments via
> > kprobe, kernel regs, and APIs that expose probe_kernel_read()
> >
> > CAP_TRACE_USER: trace unrelated user processes
> >
> > I'm not sure the code is written in a way that makes splitting
> > CAP_TRACE_KERNEL and CAP_TRACE_READ_KERNEL_DATA, and I'm not sure that
> > CAP_TRACE_KERNEL is all that useful except for plain perf record
> > without CAP_TRACE_READ_KERNEL_DATA.  What do you all think?  I suppose
> > it could also be:
> >
> > CAP_PROFILE_KERNEL: Use perf with events that aren't kprobes or
> > tracepoints.  Does not grant the ability to sample regs or the kernel
> > stack directly.
> >
> > CAP_TRACE_KERNEL: Use all of perf, ftrace, kprobe, etc.
> >
> > CAP_TRACE_USER: Use all of perf with scope limited to user mode and uprobes.
>
> imo that makes little sense from security pov, since
> such CAP_TRACE_KERNEL (ex kprobe) can trace "unrelated user process"
> just as well. Yet not letting it do cleanly via uprobe.
> Sort of like giving a spare key for back door of the house and
> saying no, you cannot have main door key.
>

Not all combinations of capabilities make total sense.  CAP_SETUID,
for example, generally lets you get all the other capabilities.
CAP_TRACE_KERNEL + CAP_TRACE_USER makes sense.  CAP_TRACE_USER by
itself makes sense.  CAP_TRACE_READ_KERNEL_DATA without
CAP_TRACE_KERNEL does not.  I don't think this is a really a problem.

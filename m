Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8659F8C5
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 05:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbfH1Dat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 23:30:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726206AbfH1Dat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 23:30:49 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E43AB217F5;
        Wed, 28 Aug 2019 03:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566963048;
        bh=QwBtkl1IG8fVTvlSF50wiwwTEzxi3t44fFqpGmTznss=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PlKZdbng3HaPSeMSMuTn/q7fDeuMCIcNgcagEmqFg8UkACtVF7d4RGuTbMtljfY5j
         dMrw4idt7ZYU1EK1yn31eKwtzhqQWClquZcg6cV0PxHSKsqnoKhMlCuOp3FTi95Otl
         Je+5JUJ8rCcOqDxsNvpYC0bIyg5Yi9Rvpq43rss8=
Date:   Wed, 28 Aug 2019 12:30:41 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
Message-Id: <20190828123041.c0c90c15865897461ee819a2@kernel.org>
In-Reply-To: <20190827192144.3b38b25a@gandalf.local.home>
References: <20190827205213.456318-1-ast@kernel.org>
        <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
        <20190827192144.3b38b25a@gandalf.local.home>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Aug 2019 19:21:44 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:


> > Here's my proposal for CAP_TRACING, documentation-style:
> > 
> > --- begin ---
> > 
> > CAP_TRACING enables a task to use various kernel features to trace
> > running user programs and the kernel itself.  CAP_TRACING also enables
> > a task to bypass some speculation attack countermeasures.  A task in
> > the init user namespace with CAP_TRACING will be able to tell exactly
> > what kernel code is executed and when, and will be able to read kernel
> > registers and kernel memory.  It will, similarly, be able to read the
> > state of other user tasks.
> > 
> > Specifically, CAP_TRACING allows the following operations.  It may
> > allow more operations in the future:
> > 
> >  - Full use of perf_event_open(), similarly to the effect of
> > kernel.perf_event_paranoid == -1.
> > 
> >  - Loading and attaching tracing BPF programs, including use of BPF
> > raw tracepoints.
> > 
> >  - Use of BPF stack maps.
> > 
> >  - Use of bpf_probe_read() and bpf_trace_printk().
> > 
> >  - Use of unsafe pointer-to-integer conversions in BPF.
> > 
> >  - Bypassing of BPF's speculation attack hardening measures and
> > constant blinding.  (Note: other mechanisms might also allow this.)
> > 
> > CAP_TRACING does not override normal permissions on sysfs or debugfs.
> > This means that, unless a new interface for programming kprobes and
> > such is added, it does not directly allow use of kprobes.
> 
> kprobes can be created in the tracefs filesystem (which is separate from
> debugfs, tracefs just gets automatically mounted
> in /sys/kernel/debug/tracing when debugfs is mounted) from the
> kprobe_events file. /sys/kernel/tracing is just the tracefs
> directory without debugfs, and was created specifically to allow
> tracing to be access without opening up the can of worms in debugfs.

I like the CAP_TRACING for tracefs. Can we make the tracefs itself
check the CAP_TRACING and call file_ops? or each tracefs file-ops
handlers must check it?

> Should we allow CAP_TRACING access to /proc/kallsyms? as it is helpful
> to convert perf and trace-cmd's function pointers into names. Once you
> allow tracing of the kernel, hiding /proc/kallsyms is pretty useless.

Also, there is a blacklist of kprobes under debugfs. If CAP_TRACING
introduced and it allows to access kallsyms, I would like to move the
blacklist under tracefs, or make an alias of blacklist entry on tracefs.

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>

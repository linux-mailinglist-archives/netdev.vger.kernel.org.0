Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64B693625FB
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 18:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236466AbhDPQtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 12:49:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235437AbhDPQtC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 12:49:02 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58E016117A;
        Fri, 16 Apr 2021 16:48:36 +0000 (UTC)
Date:   Fri, 16 Apr 2021 12:48:34 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Jesper Brouer <jbrouer@redhat.com>,
        Toke =?UTF-8?B?SMO4?= =?UTF-8?B?aWxhbmQtSsO4cmdlbnNlbg==?= 
        <toke@redhat.com>, Viktor Malik <vmalik@redhat.com>
Subject: Re: [PATCHv2 RFC bpf-next 0/7] bpf: Add support for ftrace probe
Message-ID: <20210416124834.05862233@gandalf.local.home>
In-Reply-To: <20210417000304.fc987dc00d706e7551b29c04@kernel.org>
References: <20210413121516.1467989-1-jolsa@kernel.org>
        <CAEf4Bzazst1rBi4=LuP6_FnPXCRYBNFEtDnK3UVBj6Eo6xFNtQ@mail.gmail.com>
        <YHbd2CmeoaiLJj7X@krava>
        <CAEf4BzYyVj-Tjy9ZZdAU5nOtJ8_auvVobTT6pMqg8zPb9jj-Ow@mail.gmail.com>
        <20210415111002.324b6bfa@gandalf.local.home>
        <CAEf4BzY=yBZH2Aad1hNcqCt51u0+SmNdkD6NfJRVMzF7DsvG+A@mail.gmail.com>
        <20210415170007.31420132@gandalf.local.home>
        <20210417000304.fc987dc00d706e7551b29c04@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 17 Apr 2021 00:03:04 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

> > Anyway, IIRC, Masami wasn't sure that the full regs was ever needed for the
> > return (who cares about the registers on return, except for the return
> > value?)  
> 
> I think kretprobe and ftrace are for a bit different usage. kretprobe can be
> used for something like debugger. In that case, accessing full regs stack
> will be more preferrable. (BTW, what the not "full regs" means? Does that
> save partial registers?)

When the REGS flag is not set in the ftrace_ops (where kprobes uses the
REGS flags), the regs parameter is not a full set of regs, but holds just
enough to get access to the parameters. This just happened to be what was
saved in the mcount/fentry trampoline, anyway, because tracing the start of
the program, you had to save the arguments before calling the trace code,
otherwise you would corrupt the parameters of the function being traced.

I just tweaked it so that by default, the ftrace callbacks now have access
to the saved regs (call ftrace_regs, to not let a callback get confused and
think it has full regs when it does not).

Now for the exit of a function, what does having the full pt_regs give you?
Besides the information to get the return value, the rest of the regs are
pretty much meaningless. Is there any example that someone wants access to
the regs at the end of a function besides getting the return value?

-- Steve

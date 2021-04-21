Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F238E366D98
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 16:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243289AbhDUOGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 10:06:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243275AbhDUOGS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 10:06:18 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8DED61445;
        Wed, 21 Apr 2021 14:05:42 +0000 (UTC)
Date:   Wed, 21 Apr 2021 10:05:41 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Jesper Brouer <jbrouer@redhat.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [PATCHv2 RFC bpf-next 0/7] bpf: Add support for ftrace probe
Message-ID: <20210421100541.3ea5c3bf@gandalf.local.home>
In-Reply-To: <YIArVa6IE37vsazU@krava>
References: <CAEf4BzYyVj-Tjy9ZZdAU5nOtJ8_auvVobTT6pMqg8zPb9jj-Ow@mail.gmail.com>
        <20210415111002.324b6bfa@gandalf.local.home>
        <CAEf4BzY=yBZH2Aad1hNcqCt51u0+SmNdkD6NfJRVMzF7DsvG+A@mail.gmail.com>
        <20210415170007.31420132@gandalf.local.home>
        <20210417000304.fc987dc00d706e7551b29c04@kernel.org>
        <20210416124834.05862233@gandalf.local.home>
        <YH7OXrjBIqvEZbsc@krava>
        <CAADnVQK55WzR6_JfxkMzEfUnLJnX75bRHjCkaptcVF=nQ_gWfw@mail.gmail.com>
        <YH8GxNi5VuYjwNmK@krava>
        <CAADnVQLh3tCWi=TiWnJVaMrYhJ=j-xSrJ72+XnZDP8CMZM+1mQ@mail.gmail.com>
        <YIArVa6IE37vsazU@krava>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Apr 2021 15:40:37 +0200
Jiri Olsa <jolsa@redhat.com> wrote:

> ok, I understand why this would be the best solution for calling
> the program from multiple probes
> 
> I think it's the 'attach' layer which is the source of problems
> 
> currently there is ftrace's fgraph_ops support that allows fast mass
> attach and calls callbacks for functions entry and exit:
>   https://lore.kernel.org/lkml/20190525031633.811342628@goodmis.org/
> 
> these callbacks get ip/parent_ip and can get pt_regs (that's not
> implemented at the moment)
> 
> but that gets us to the situation of having full pt_regs on both
> entry/exit callbacks that you described above and want to avoid,
> but I think it's the price for having this on top of generic
> tracing layer
> 
> the way ftrace's fgraph_ops is implemented, I'm not sure it can
> be as fast as current bpf entry/exit trampoline

Note, the above mentioned code was an attempt to consolidate the code that
does the "highjacking" of the return pointer in order to record the
return of a function. At the time there was only kretprobes and function
graph tracing. Now bpf has another version. That means there's three
utilities that record the exit of the function.

What we need is a single method that works for all three utilities. And I'm
perfectly fine with a rewrite of function graph tracer to do that. The one
problem is that function graph and kretprobes works for pretty much all the
architectures now, and whatever we decide to do, we can't break those
architectures.

One way is to have an abstract layer that allows function graph and
kretprobes to work with the old implementation as well as, depending on a
config set, a new implementation that also supports bpf trampolines.

> 
> but to better understand the pain points I think I'll try to implement
> the 'mass trampolines' call to the bpf program you described above and
> attach it for now to fgraph_ops callbacks

One thing that ftrace gives you is a way to have each function call its own
trampoline, then depending on what is attached, each one can have multiple
implementations.

One thing that needs to be fixed is the direct trampoline and function
graph and kretprobes. As the direct trampoline will break both of them,
with the bpf implementation to trace after it.

I would be interested in what a mass generic trampoline would look like, if
it had to deal with handling functions with 1 parameter and one with 12
parameters. From this thread, I was told it can currently only handle 6
parameters on x86_64. Not sure how it works on x86_32.

> 
> perhaps this is a good topic to discuss in one of the Thursday's BPF mtg?

I'm unaware of these meetings.


-- Steve

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C1E296111
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 16:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2901007AbgJVOmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 10:42:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:49642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2900871AbgJVOmK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 10:42:10 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 098A824171;
        Thu, 22 Oct 2020 14:42:07 +0000 (UTC)
Date:   Thu, 22 Oct 2020 10:42:05 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Jesper Brouer <jbrouer@redhat.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [RFC bpf-next 00/16] bpf: Speed up trampoline attach
Message-ID: <20201022104205.728dd135@gandalf.local.home>
In-Reply-To: <20201022141154.GB2332608@krava>
References: <20201022082138.2322434-1-jolsa@kernel.org>
        <20201022093510.37e8941f@gandalf.local.home>
        <20201022141154.GB2332608@krava>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Oct 2020 16:11:54 +0200
Jiri Olsa <jolsa@redhat.com> wrote:

> I understand direct calls as a way that bpf trampolines and ftrace can
> co-exist together - ebpf trampolines need that functionality of accessing
> parameters of a function as if it was called directly and at the same
> point we need to be able attach to any function and to as many functions
> as we want in a fast way

I was sold that bpf needed a quick and fast way to get the arguments of a
function, as the only way to do that with ftrace is to save all registers,
which, I was told was too much overhead, as if you only care about
arguments, there's much less that is needed to save.

Direct calls wasn't added so that bpf and ftrace could co-exist, it was
that for certain cases, bpf wanted a faster way to access arguments,
because it still worked with ftrace, but the saving of regs was too
strenuous.

> 
> the bpftrace example above did not use arguments for simplicity, but they
> could have been there ... I think we could detect arguments presence in
> ebpf programs and use ftrace_ops directly in case they are not needed

What I don't see, is how one would need to access arguments for a lot of
calls directly? The direct trampoline was for "one-offs", because for every
function that has a direct trampoline, it prevents kretprobes and function
graph tracer from accessing it. Before I allow a "batch" direct caller, I
need it to not break function graph tracing.

If we are going to have a way to get parameters for multiple functions, I
would then like to have that be directly part of the ftrace infrastructure.
That is, allow more than just bpf to have access to this. If it's going to
be generic, then let's have it work for all function trace users and not
just bpf.

I'd like to see how batch functions will work. I guess I need to start
looking at the bpf trampoline, to see if we can modify the ftrace
trampoline to have a quick access to parameters. It would be much more
beneficial to update the existing generic function tracer to have access to
function parameters that all users could benefit from, than to tweak a
single use case into giving this feature to a single user.

-- Steve

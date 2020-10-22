Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF50296015
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 15:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900172AbgJVNfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 09:35:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726257AbgJVNfP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 09:35:15 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C46B720BED;
        Thu, 22 Oct 2020 13:35:12 +0000 (UTC)
Date:   Thu, 22 Oct 2020 09:35:10 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
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
Message-ID: <20201022093510.37e8941f@gandalf.local.home>
In-Reply-To: <20201022082138.2322434-1-jolsa@kernel.org>
References: <20201022082138.2322434-1-jolsa@kernel.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Oct 2020 10:21:22 +0200
Jiri Olsa <jolsa@kernel.org> wrote:

> hi,
> this patchset tries to speed up the attach time for trampolines
> and make bpftrace faster for wildcard use cases like:
> 
>   # bpftrace -ve "kfunc:__x64_sys_s* { printf("test\n"); }"
> 
> Profiles show mostly ftrace backend, because we add trampoline
> functions one by one and ftrace direct function registering is
> quite expensive. Thus main change in this patchset is to allow
> batch attach and use just single ftrace call to attach or detach
> multiple ips/trampolines.

The issue I have with this change is that the purpose of the direct
trampoline was to give bpf access to the parameters of a function as if it
was called directly. That is, it could see the parameters of a function
quickly. I even made the direct function work if it wanted to also trace
the return code.

What the direct calls is NOT, is a generic tracing function tracer. If that
is required, then bpftrace should be registering itself with ftrace.
If you are attaching to a set of functions, where it becomes obvious that
its not being used to access specific parameters, then that's an abuse of
the direct calls.

We already have one generic function tracer, we don't need another.

-- Steve

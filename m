Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C71B7296299
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 18:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2901649AbgJVQV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 12:21:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:38072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2444383AbgJVQV4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 12:21:56 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C456C208B6;
        Thu, 22 Oct 2020 16:21:52 +0000 (UTC)
Date:   Thu, 22 Oct 2020 12:21:50 -0400
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
Message-ID: <20201022122150.45e81da0@gandalf.local.home>
In-Reply-To: <20201022104205.728dd135@gandalf.local.home>
References: <20201022082138.2322434-1-jolsa@kernel.org>
        <20201022093510.37e8941f@gandalf.local.home>
        <20201022141154.GB2332608@krava>
        <20201022104205.728dd135@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Oct 2020 10:42:05 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> I'd like to see how batch functions will work. I guess I need to start
> looking at the bpf trampoline, to see if we can modify the ftrace
> trampoline to have a quick access to parameters. It would be much more
> beneficial to update the existing generic function tracer to have access to
> function parameters that all users could benefit from, than to tweak a
> single use case into giving this feature to a single user.

Looking at the creation of the bpf trampoline, I think I can modify ftrace
to have a more flexible callback. Something that passes the callback the
following:

 the function being traced.
 a pointer to the parent caller (that could be modified)
 a pointer to the original stack frame (what the stack was when the
      function is entered)
 An array of the arguments of the function (which could also be modified)

This is a change I've been wanting to make for some time, because it would
allow function graph to be a user of function tracer, and would give
everything access to the arguments.

We would still need a helper function to store all regs to keep kprobes
working unmodified, but this would still only be done if asked.

The above change shouldn't hurt performance for either ftrace or bpf
because it appears they both do the same. If BPF wants to have a batch
processing of functions, then I think we should modify ftrace to do this
new approach instead of creating another set of function trampolines.

-- Steve

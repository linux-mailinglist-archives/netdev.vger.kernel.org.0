Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE148297841
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 22:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1756128AbgJWUbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 16:31:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:54660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S465603AbgJWUbO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 16:31:14 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B12B20897;
        Fri, 23 Oct 2020 20:31:12 +0000 (UTC)
Date:   Fri, 23 Oct 2020 16:31:10 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
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
Subject: Re: [RFC bpf-next 09/16] bpf: Add BPF_TRAMPOLINE_BATCH_ATTACH
 support
Message-ID: <20201023163110.54e4a202@gandalf.local.home>
In-Reply-To: <CAEf4Bzb_HPmGSoUX+9+LvSP2Yb95OqEQKtjpMiW1Um-rixAM8Q@mail.gmail.com>
References: <20201022082138.2322434-1-jolsa@kernel.org>
        <20201022082138.2322434-10-jolsa@kernel.org>
        <CAEf4Bzb_HPmGSoUX+9+LvSP2Yb95OqEQKtjpMiW1Um-rixAM8Q@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Oct 2020 13:03:22 -0700
Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:

> Basically, maybe ftrace subsystem could provide a set of APIs to
> prepare a set of functions to attach to. Then BPF subsystem would just
> do what it does today, except instead of attaching to a specific
> kernel function, it would attach to ftrace's placeholder. I don't know
> anything about ftrace implementation, so this might be far off. But I
> thought that looking at this problem from a bit of a different angle
> would benefit the discussion. Thoughts?

I probably understand bpf internals as much as you understand ftrace
internals ;-)

Anyway, what I'm currently working on, is a fast way to get to the
arguments of a function. For now, I'm just focused on x86_64, and only add
6 argments.

The main issue that Alexei had with using the ftrace trampoline, was that
the only way to get to the arguments was to set the "REGS" flag, which
would give a regs parameter that contained a full pt_regs. The problem with
this approach is that it required saving *all* regs for every function
traced. Alexei felt that this was too much overehead.

Looking at Jiri's patch, I took a look at the creation of the bpf
trampoline, and noticed that it's copying the regs on a stack (at least
what is used, which I think could be an issue).

For tracing a function, one must store all argument registers used, and
restore them, as that's how they are passed from caller to callee. And
since they are stored anyway, I figure, that should also be sent to the
function callbacks, so that they have access to them too.

I'm working on a set of patches to make this a reality.

-- Steve

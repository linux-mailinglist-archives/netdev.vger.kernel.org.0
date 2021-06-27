Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177753B50CF
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 04:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbhF0CzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 22:55:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230186AbhF0Cy7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Jun 2021 22:54:59 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C20661C54;
        Sun, 27 Jun 2021 02:52:34 +0000 (UTC)
Date:   Sat, 26 Jun 2021 22:52:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@kernel.org>,
        Robert Richter <rric@kernel.org>,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf@vger.kernel.org
Subject: Re: [PATCH] tracepoint: Do not warn on EEXIST or ENOENT
Message-ID: <20210626225233.2baae8be@rorschach.local.home>
In-Reply-To: <fc5d0f90-502d-b217-0ad6-0d17cae12ff7@i-love.sakura.ne.jp>
References: <20210626135845.4080-1-penguin-kernel@I-love.SAKURA.ne.jp>
        <20210626101834.55b4ecf1@rorschach.local.home>
        <7297f336-70e5-82d3-f8d3-27f08c7d1548@i-love.sakura.ne.jp>
        <20210626114157.765d9371@rorschach.local.home>
        <20210626142213.6dee5c60@rorschach.local.home>
        <fc5d0f90-502d-b217-0ad6-0d17cae12ff7@i-love.sakura.ne.jp>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 27 Jun 2021 10:10:24 +0900
Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:

> On 2021/06/27 3:22, Steven Rostedt wrote:
> >> If BPF is expected to register the same tracepoint with the same
> >> callback and data more than once, then let's add a call to do that
> >> without warning. Like I said, other callers expect the call to succeed
> >> unless it's out of memory, which tends to cause other problems.  
> > 
> > If BPF is OK with registering the same probe more than once if user
> > space expects it, we can add this patch, which allows the caller (in
> > this case BPF) to not warn if the probe being registered is already
> > registered, and keeps the idea that a probe registered twice is a bug
> > for all other use cases.  
> 
> I think BPF will not register the same tracepoint with the same callback and
> data more than once, for bpf(BPF_RAW_TRACEPOINT_OPEN) cleans the request up
> by calling bpf_link_cleanup() and returns -EEXIST. But I think BPF relies on
> tracepoint_add_func() returning -EEXIST without crashing the kernel.

Which is the only user that does so, and what this patch addresses.

> > That's because (before BPF) there's no place in the kernel that tries
> > to register the same tracepoint multiple times, and was considered a
> > bug if it happened, because there's no ref counters to deal with adding
> > them multiple times.  
> 
> I see. But does that make sense? Since func_add() can fail with -ENOMEM,
> all places (even before BPF) needs to be prepared for failures.

Yes. -ENOMEM means that there's no resources to create a tracepoint.
But if the tracepoint already exsits, that means the accounting for
what tracepoints are running has been corrupted.

> 
> > 
> > If the tracepoint is already registered (with the given function and
> > data), then something likely went wrong.  
> 
> That can be prepared on the caller side of tracepoint_add_func() rather than
> tracepoint_add_func() side.

Not sure what you mean by that.

> 
> >   
> >>   (3) And tracepoint_add_func() is triggerable via request from userspace.  
> > 
> > Only via BPF correct?
> > 
> > I'm not sure how it works, but can't BPF catch that it is registering
> > the same tracepoint again?  
> 
> There is no chance to check whether some tracepoint is already registered, for
> tracepoints_mutex is the only lock which gives us a chance to check whether
> some tracepoint is already registered.
> 
> Should bpf() syscall hold a global lock (like tracepoints_mutex) which will serialize
> the entire code in order to check whether some tracepoint is already registered?
> That might severely damage concurrency.

I think that the patch I posted handles what you want. For BPF it
returns without warning, but for all other cases, it warns. Does it fix
your issue?

-- Steve



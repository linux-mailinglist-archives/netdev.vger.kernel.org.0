Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 606634EC9BA
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 18:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348845AbiC3QgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 12:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348839AbiC3QgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 12:36:04 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 870211D320;
        Wed, 30 Mar 2022 09:34:18 -0700 (PDT)
Received: from kbox (c-73-140-2-214.hsd1.wa.comcast.net [73.140.2.214])
        by linux.microsoft.com (Postfix) with ESMTPSA id E7AF420B96D6;
        Wed, 30 Mar 2022 09:34:17 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E7AF420B96D6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1648658058;
        bh=NE1Gzgfcu1RVAQTBcQFmkLsZA71WWxETeZdDl0NVbGk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aPSThqM5IPvFG/nHKA0shVLzXfcjf3BuMxLCBELpv/wumVaQ/8A6ypVhJfck1YAat
         0bd7iRH9n722EW/ZXFcqE/ULmpv1L/sqLZSiWJ9HfCB8E5L0b1Y1bICMux2PPMkDNv
         YQZnbdhmN0xtdoPXKTDQMauOZ9yemyA8+fKPIOLs=
Date:   Wed, 30 Mar 2022 09:34:11 -0700
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     Song Liu <song@kernel.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH] tracing/user_events: Add eBPF interface for user_event
 created events
Message-ID: <20220330163411.GA1812@kbox>
References: <20220329181935.2183-1-beaub@linux.microsoft.com>
 <CAADnVQ+XpoCjL-rSz2hj05L21s8NtMJuWYC14b9Mvk7XE5KT_g@mail.gmail.com>
 <20220329201057.GA2549@kbox>
 <CAADnVQ+gm4yU9S6y+oeR3TNj82kKX0gk4ey9gVnKXKWy1Js4-A@mail.gmail.com>
 <20220329231137.GA3357@kbox>
 <CAPhsuW4WH4Hn+DaQZui5au=ueG1G5zGYiOACfKm9imG2kGA+KA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW4WH4Hn+DaQZui5au=ueG1G5zGYiOACfKm9imG2kGA+KA@mail.gmail.com>
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 30, 2022 at 09:06:24AM -0700, Song Liu wrote:
> On Tue, Mar 29, 2022 at 4:11 PM Beau Belgrave <beaub@linux.microsoft.com> wrote:
> >
> > On Tue, Mar 29, 2022 at 03:31:31PM -0700, Alexei Starovoitov wrote:
> > > On Tue, Mar 29, 2022 at 1:11 PM Beau Belgrave <beaub@linux.microsoft.com> wrote:
> > > >
> > > > On Tue, Mar 29, 2022 at 12:50:40PM -0700, Alexei Starovoitov wrote:
> > > > > On Tue, Mar 29, 2022 at 11:19 AM Beau Belgrave
> > > > > <beaub@linux.microsoft.com> wrote:
> > > > > >
> > > > > > Send user_event data to attached eBPF programs for user_event based perf
> > > > > > events.
> > > > > >
> > > > > > Add BPF_ITER flag to allow user_event data to have a zero copy path into
> > > > > > eBPF programs if required.
> > > > > >
> > > > > > Update documentation to describe new flags and structures for eBPF
> > > > > > integration.
> > > > > >
> > > > > > Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
> > > > >
> > > > > The commit describes _what_ it does, but says nothing about _why_.
> > > > > At present I see no use out of bpf and user_events connection.
> > > > > The whole user_events feature looks redundant to me.
> > > > > We have uprobes and usdt. It doesn't look to me that
> > > > > user_events provide anything new that wasn't available earlier.
> > > >
> > > > A lot of the why, in general, for user_events is covered in the first
> > > > change in the series.
> > > > Link: https://lore.kernel.org/all/20220118204326.2169-1-beaub@linux.microsoft.com/
> > > >
> > > > The why was also covered in Linux Plumbers Conference 2021 within the
> > > > tracing microconference.
> > > >
> > > > An example of why we want user_events:
> > > > Managed code running that emits data out via Open Telemetry.
> > > > Since it's managed there isn't a stub location to patch, it moves.
> > > > We watch the Open Telemetry spans in an eBPF program, when a span takes
> > > > too long we collect stack data and perform other actions.
> > > > With user_events and perf we can monitor the entire system from the root
> > > > container without having to have relay agents within each
> > > > cgroup/namespace taking up resources.
> > > > We do not need to enter each cgroup mnt space and determine the correct
> > > > patch location or the right version of each binary for processes that
> > > > use user_events.
> > > >
> > > > An example of why we want eBPF integration:
> > > > We also have scenarios where we are live decoding the data quickly.
> > > > Having user_data fed directly to eBPF lets us cast the data coming in to
> > > > a struct and decode very very quickly to determine if something is
> > > > wrong.
> > > > We can take that data quickly and put it into maps to perform further
> > > > aggregation as required.
> > > > We have scenarios that have "skid" problems, where we need to grab
> > > > further data exactly when the process that had the problem was running.
> > > > eBPF lets us do all of this that we cannot easily do otherwise.
> > > >
> > > > Another benefit from user_events is the tracing is much faster than
> > > > uprobes or others using int 3 traps. This is critical to us to enable on
> > > > production systems.
> > >
> > > None of it makes sense to me.
> >
> > Sorry.
> >
> > > To take advantage of user_events user space has to be modified
> > > and writev syscalls inserted.
> >
> > Yes, both user_events and lttng require user space modifications to do
> > tracing correctly. The syscall overheads are real, and the cost depends
> > on the mitigations around spectre/meltdown.
> >
> > > This is not cheap and I cannot see a production system using this interface.
> >
> > But you are fine with uprobe costs? uprobes appear to be much more costly
> > than a syscall approach on the hardware I've run on.
> 
> Can we achieve the same/similar performance with sys_bpf(BPF_PROG_RUN)?
> 

I think so, the tough part is how do you let the user-space know which
program is attached to run? In the current code this is done by the BPF
program attaching to the event via perf and we run the one there if
any when data is emitted out via write calls.

I would want to make sure that operators can decide where the user-space
data goes (perf/ftrace/eBPF) after the code has been written. With the
current code this is done via the tracepoint callbacks that perf/ftrace
hook up when operators enable recording via perf, tracefs, libbpf, etc.

We have managed code (C#/Java) where we cannot utilize stubs or traps
easily due to code movement. So we are limited in how we can approach
this problem. Having the interface be mmap/write has enabled this
for us, since it's easy to interact with in most languages and gives us
lifetime management of the trace objects between user-space and the
kernel.

> Thanks,
> Song
> 
> >
> > > All you did is a poor man version of lttng that doesn't rely
> > > on such heavy instrumentation.
> >
> > Well I am a frugal person. :)
> >
> > This work has solved some critical issues we've been having, and I would
> > appreciate a review of the code if possible.
> >
> > Thanks,
> > -Beau

Thanks,
-Beau

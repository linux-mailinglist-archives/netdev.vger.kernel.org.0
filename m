Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C97F94EBA1C
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 07:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242942AbiC3FYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 01:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238534AbiC3FYc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 01:24:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D21015B987;
        Tue, 29 Mar 2022 22:22:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6256615AE;
        Wed, 30 Mar 2022 05:22:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0277EC340EE;
        Wed, 30 Mar 2022 05:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648617767;
        bh=MJKsvBQ12FvT30/ZTbEHl9aaaA+42sFCmsreyXrBKNU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SkYLQIsd5AJBx8xrtUVjID4Oq1RzFIK8qF9u/qC5hFgyXu2iCId0g1UTHzKxfoiZ5
         vL/Epu+gIdPE/+SI1yVd/zXG9MIsH0HZhqeDWhhN4+y55VRYzQ/bpUC0Q5Z7C/ygH2
         u0oeSOd8JoPAUpxImH90Ebp2UvLNIScEscJyJ83FtpvKt6MVWoyRbbn9K6zvVlU/tg
         MrT5eatFKJtSOoUuaSvevnjoHQ9sfTtB40TUsP6vCJsmnFHFbag5ucifIVa+9hGlrU
         Td0rNb/5s4zgOwkKwcK0klZOwROG5tBcTuXboZ8gVfE2pEcXceP25Hk91Ix6q2L0Gy
         9kj445xnIAR0Q==
Date:   Wed, 30 Mar 2022 14:22:42 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Beau Belgrave <beaub@linux.microsoft.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-trace-devel <linux-trace-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH] tracing/user_events: Add eBPF interface for user_event
 created events
Message-Id: <20220330142242.87b8b84ff922ef3688559b61@kernel.org>
In-Reply-To: <CAADnVQ+gm4yU9S6y+oeR3TNj82kKX0gk4ey9gVnKXKWy1Js4-A@mail.gmail.com>
References: <20220329181935.2183-1-beaub@linux.microsoft.com>
        <CAADnVQ+XpoCjL-rSz2hj05L21s8NtMJuWYC14b9Mvk7XE5KT_g@mail.gmail.com>
        <20220329201057.GA2549@kbox>
        <CAADnVQ+gm4yU9S6y+oeR3TNj82kKX0gk4ey9gVnKXKWy1Js4-A@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Mar 2022 15:31:31 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Tue, Mar 29, 2022 at 1:11 PM Beau Belgrave <beaub@linux.microsoft.com> wrote:
> >
> > On Tue, Mar 29, 2022 at 12:50:40PM -0700, Alexei Starovoitov wrote:
> > > On Tue, Mar 29, 2022 at 11:19 AM Beau Belgrave
> > > <beaub@linux.microsoft.com> wrote:
> > > >
> > > > Send user_event data to attached eBPF programs for user_event based perf
> > > > events.
> > > >
> > > > Add BPF_ITER flag to allow user_event data to have a zero copy path into
> > > > eBPF programs if required.
> > > >
> > > > Update documentation to describe new flags and structures for eBPF
> > > > integration.
> > > >
> > > > Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
> > >
> > > The commit describes _what_ it does, but says nothing about _why_.
> > > At present I see no use out of bpf and user_events connection.
> > > The whole user_events feature looks redundant to me.
> > > We have uprobes and usdt. It doesn't look to me that
> > > user_events provide anything new that wasn't available earlier.
> >
> > A lot of the why, in general, for user_events is covered in the first
> > change in the series.
> > Link: https://lore.kernel.org/all/20220118204326.2169-1-beaub@linux.microsoft.com/
> >
> > The why was also covered in Linux Plumbers Conference 2021 within the
> > tracing microconference.
> >
> > An example of why we want user_events:
> > Managed code running that emits data out via Open Telemetry.
> > Since it's managed there isn't a stub location to patch, it moves.
> > We watch the Open Telemetry spans in an eBPF program, when a span takes
> > too long we collect stack data and perform other actions.
> > With user_events and perf we can monitor the entire system from the root
> > container without having to have relay agents within each
> > cgroup/namespace taking up resources.
> > We do not need to enter each cgroup mnt space and determine the correct
> > patch location or the right version of each binary for processes that
> > use user_events.
> >
> > An example of why we want eBPF integration:
> > We also have scenarios where we are live decoding the data quickly.
> > Having user_data fed directly to eBPF lets us cast the data coming in to
> > a struct and decode very very quickly to determine if something is
> > wrong.
> > We can take that data quickly and put it into maps to perform further
> > aggregation as required.
> > We have scenarios that have "skid" problems, where we need to grab
> > further data exactly when the process that had the problem was running.
> > eBPF lets us do all of this that we cannot easily do otherwise.
> >
> > Another benefit from user_events is the tracing is much faster than
> > uprobes or others using int 3 traps. This is critical to us to enable on
> > production systems.
> 
> None of it makes sense to me.
> To take advantage of user_events user space has to be modified
> and writev syscalls inserted.

That can be done by introducing new user SDT macros, which currently
expected to use uprobes (thus it just introduces a list of probe
address and semaphore in a section). But we can provide another
implementation for lighter user-events.

> This is not cheap and I cannot see a production system using this interface.

I agree this point. At least this needs to be paired with user-space
library so that the applications can use it. But I also think that
new feature is not always requires an actual production system which
relays on that, since that means such production system must use
out-of-tree custom kernel. That should be avoided from the upstream-first
policy viewpoint. (However, I would like to know the actual use case.)

> All you did is a poor man version of lttng that doesn't rely
> on such heavy instrumentation.

Isn't it reasonable to avoid using heavy instrumentation? :-)

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>

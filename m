Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5FD068FD21
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 03:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231965AbjBIC3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 21:29:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbjBIC3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 21:29:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E72635AC;
        Wed,  8 Feb 2023 18:29:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 117B4B81F78;
        Thu,  9 Feb 2023 02:29:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB0EBC433EF;
        Thu,  9 Feb 2023 02:28:59 +0000 (UTC)
Date:   Wed, 8 Feb 2023 21:28:58 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     John Stultz <jstultz@google.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Yafang Shao <laoar.shao@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel test robot <oliver.sang@intel.com>,
        kbuild test robot <lkp@intel.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Miroslaw <mirq-linux@rere.qmqm.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Petr Mladek <pmladek@suse.com>,
        Kajetan Puchalski <kajetan.puchalski@arm.com>,
        Lukasz Luba <lukasz.luba@arm.com>,
        Qais Yousef <qyousef@google.com>,
        Daniele Di Proietto <ddiproietto@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2 7/7] tools/testing/selftests/bpf: replace open-coded
 16 with TASK_COMM_LEN
Message-ID: <20230208212858.477cd05e@gandalf.local.home>
In-Reply-To: <CANDhNCo_=Q3pWc7h=ruGyHdRVGpsMKRY=C2AtZgLDwtGzRz8Kw@mail.gmail.com>
References: <20211120112738.45980-1-laoar.shao@gmail.com>
        <20211120112738.45980-8-laoar.shao@gmail.com>
        <Y+QaZtz55LIirsUO@google.com>
        <CAADnVQ+nf8MmRWP+naWwZEKBFOYr7QkZugETgAVfjKcEVxmOtg@mail.gmail.com>
        <CANDhNCo_=Q3pWc7h=ruGyHdRVGpsMKRY=C2AtZgLDwtGzRz8Kw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Feb 2023 16:54:03 -0800
John Stultz <jstultz@google.com> wrote:

> > Let me understand what you're saying...
> >
> > The commit 3087c61ed2c4 did
> >
> > -/* Task command name length: */
> > -#define TASK_COMM_LEN                  16
> > +/*
> > + * Define the task command name length as enum, then it can be visible to
> > + * BPF programs.
> > + */
> > +enum {
> > +       TASK_COMM_LEN = 16,
> > +};
> >
> >
> > and that caused:
> >
> > cat /sys/kernel/debug/tracing/events/task/task_newtask/format
> >
> > to print
> > field:char comm[TASK_COMM_LEN];    offset:12;    size:16;    signed:0;

Yes because there's no easy way to automatically convert an enum to a
number. And this has been a macro for a very long time (so it works,
because macros convert to numbers).

And this breaks much more than android. It will break trace-cmd, rasdaemon
and perf (if it's not using BTF). This change very much "Breaks userspace!"
And requires a kernel workaround, not a user space one.


> > instead of
> > field:char comm[16];    offset:12;    size:16;    signed:0;
> >
> > so the ftrace parsing android tracing tool had to do:
> >
> > -  if (Match(type_and_name.c_str(), R"(char [a-zA-Z_]+\[[0-9]+\])")) {
> > +  if (Match(type_and_name.c_str(),
> > +            R"(char [a-zA-Z_][a-zA-Z_0-9]*\[[a-zA-Z_0-9]+\])")) {
> >
> > to workaround this change.
> > Right?  
> 
> I believe so.
> 
> > And what are you proposing?  
> 
> I'm not proposing anything. I was just wanting to understand more
> context around this, as it outwardly appears to be a user-breaking
> change, and that is usually not done, so I figured it was an issue
> worth raising.
> 
> If the debug/tracing/*/format output is in the murky not-really-abi
> space, that's fine, but I wanted to know if this was understood as
> something that may require userland updates or if this was a
> unexpected side-effect.

Linus has already said that /sys/kernel/tracing/* is an ABI (fyi, getting
to the tracing directory via debugfs is obsolete).

Usually, when a trace event uses an enum, it can do:

TRACE_DEFINE_ENUM(TASK_COMM_LEN);

But that's a very common define. It would require it updated for every trace
event, or the change needs to be reverted.

Not sure why BTF needs it like this, because it hasn't changed in years.
Can't it just hard code it?

For ftrace to change it, it requires reading the format files at boot up
and replacing the enums with the numbers, which does impact start up.

-- Steve

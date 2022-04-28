Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3CC6513C56
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 22:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351623AbiD1UIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 16:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349810AbiD1UIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 16:08:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C21284EF7;
        Thu, 28 Apr 2022 13:05:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBC5661D2B;
        Thu, 28 Apr 2022 20:05:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8908C385A9;
        Thu, 28 Apr 2022 20:05:21 +0000 (UTC)
Date:   Thu, 28 Apr 2022 16:05:19 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [RFC bpf-next 4/4] selftests/bpf: Add attach bench test
Message-ID: <20220428160519.04cc40c0@gandalf.local.home>
In-Reply-To: <CAADnVQKi+4oBt2C__qz7QoHqTtXYLUjaqwTNFoSE=up9c9k4cA@mail.gmail.com>
References: <20220407125224.310255-1-jolsa@kernel.org>
        <20220407125224.310255-5-jolsa@kernel.org>
        <CAEf4BzbE1n3Lie+tWTzN69RQUWgjxePorxRr9J8CuiQVUfy-kA@mail.gmail.com>
        <20220412094923.0abe90955e5db486b7bca279@kernel.org>
        <CAEf4BzaQRcZGMqq5wqHo3wSHZAAVvY6AhizDk_dV_GtnwHuxLQ@mail.gmail.com>
        <20220416232103.c0b241c2ec7f2b3b985a2f99@kernel.org>
        <20220428095803.66c17c32@gandalf.local.home>
        <CAADnVQKi+4oBt2C__qz7QoHqTtXYLUjaqwTNFoSE=up9c9k4cA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Apr 2022 11:59:55 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> > The weak function gets a call to ftrace, but it still gets compiled into
> > vmlinux but its symbol is dropped due to it being overridden. Thus, the
> > mcount_loc finds this call to fentry, and maps it to the symbol that is
> > before it, which just happened to be __bpf_tramp_exit.  
> 
> Ouch. That _is_ a bug in recordmocount.

Exactly HOW is it a bug in recordmcount?

The job of recordmcount is to create a section of all the locations that
call fentry. That is EXACTLY what it did. No bug there! It did its job.

In fact, recordmcount probably didn't even get called. If you see this on
x86 with gcc version greater than 8 (which I do), recordmcount is not even
used. gcc creates this section internally instead.

> 
> > I made that weak function "notrace" and the __bpf_tramp_exit disappeared
> > from the available_filter_functions list.  
> 
> That's a hack. We cannot rely on such hacks for all weak functions.

Then don't do anything. The only thing this bug causes is perhaps some
confusion, because functions before weak functions that are overridden will
be listed incorrectly in the available_filter_functions file. And that's
because of the way it is created with respect to kallsyms.

If you enable __bpf_tramp_exit, it will not do anything to that function.
What it will do is enable the location inside of the weak function that no
longer has its symbol shown.

One solution is to simply get the end of the function that is provided by
kallsyms to make sure the fentry call location is inside the function, and
if it is not, then not show that function in available_filter_functions but
instead show something like "** unnamed function **" or whatever.

I could write a patch to do that when I get the time. But because the only
issue that this causes is some confusion among the users and does not cause
any issue with functionality, then it is low priority.

-- Steve

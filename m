Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D769954309F
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 14:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239781AbiFHMkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 08:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239512AbiFHMka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 08:40:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B19EC2D80A9;
        Wed,  8 Jun 2022 05:40:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BFE061975;
        Wed,  8 Jun 2022 12:40:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F377C34116;
        Wed,  8 Jun 2022 12:40:25 +0000 (UTC)
Date:   Wed, 8 Jun 2022 08:40:23 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [PATCHv2 bpf 3/3] bpf: Force cookies array to follow symbols
 sorting
Message-ID: <20220608084023.4be8ffe2@gandalf.local.home>
In-Reply-To: <YqBynO64am32z13X@krava>
References: <20220606184731.437300-1-jolsa@kernel.org>
        <20220606184731.437300-4-jolsa@kernel.org>
        <CAADnVQJA54Ra8+tV0e0KwSXAg93JRoiefDXWR-Lqatya5YWKpg@mail.gmail.com>
        <Yp+tTsqPOuVdjpba@krava>
        <CAADnVQJGoM9eqcODx2LGo-qLo0=O05gSw=iifRsWXgU0XWifAA@mail.gmail.com>
        <YqBW65t+hlWNok8e@krava>
        <YqBynO64am32z13X@krava>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Jun 2022 11:57:48 +0200
Jiri Olsa <olsajiri@gmail.com> wrote:

> Steven,
> is there a reason to show '__ftrace_invalid_address___*' symbols in
> available_filter_functions? it seems more like debug message to me
> 

Yes, because set_ftrace_filter may be set by index. That is, if schedule is
the 43,245th entry in available_filter_functions, then you can do:

  # echo 43245 > set_ftrace_filter
  # cat set_ftrace_filter
  schedule

That index must match the array index of the entries in the function list
internally. The reason for this is that entering a name is an O(n)
operation, where n is the number of functions in
available_filter_functions. If you want to enable half of those functions,
then it takes O(n^2) to do so.

I first implemented this trick to help with bisecting bad functions. That
is, every so often a function that should be annotated with notrace, isn't
and if it gets traced it cause the machine to reboot. To bisect this, I
would enable half the functions at a time and enable tracing to see if it
reboots or not, and if it does, I know that one of the half I enabled is
the culprit, if not, it's in the other half. It would take over 5 minutes
to enable half the functions. Where as the number trick took one second,
not only was it O(1) per function, but it did not need to do kallsym
lookups either. It simply enabled the function at the index.

Later, libtracefs (used by trace-cmd and others) would allow regex(3)
enabling of functions. That is, it would search available_filter_functions
in user space, match them via normal regex, create an index of the
functions to know where they are, and then write in those numbers to enable
them. It's much faster than writing in strings.

My original fix was to simply ignore those functions, but then it would
make the index no longer match what got set. I noticed this while writing
my slides for Kernel Recipes, and then fixed it.

The commit you mention above even states this:

      __ftrace_invalid_address___<invalid-offset>
    
    (showing the offset that caused it to be invalid).
    
    This is required for tools that use libtracefs (like trace-cmd does) that
    scan the available_filter_functions and enable set_ftrace_filter and
    set_ftrace_notrace using indexes of the function listed in the file (this
    is a speedup, as enabling thousands of files via names is an O(n^2)
    operation and can take minutes to complete, where the indexing takes less
    than a second).

In other words, having a placeholder is required to keep from breaking user
space.

-- Steve



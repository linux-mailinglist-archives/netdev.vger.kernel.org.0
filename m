Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB44536823
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 22:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351932AbiE0Ugt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 16:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbiE0Ugs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 16:36:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A1A606CD;
        Fri, 27 May 2022 13:36:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37F1AB82644;
        Fri, 27 May 2022 20:36:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 222BEC385B8;
        Fri, 27 May 2022 20:36:42 +0000 (UTC)
Date:   Fri, 27 May 2022 16:36:41 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ingo Molnar <mingo@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org
Subject: Re: [PATCH v2] ftrace: Add FTRACE_MCOUNT_MAX_OFFSET to avoid adding
 weak function
Message-ID: <20220527163641.67d97382@gandalf.local.home>
In-Reply-To: <YpCiHlBjj99hALbV@gmail.com>
References: <20220525180553.419eac77@gandalf.local.home>
        <Yo7q6dwphFexGuRA@gmail.com>
        <20220526091106.1eb2287a@gandalf.local.home>
        <YpCiHlBjj99hALbV@gmail.com>
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

On Fri, 27 May 2022 12:04:14 +0200
Ingo Molnar <mingo@kernel.org> wrote:

> For those which implement objtool, it certainly should: as we parse through 
> each object file during the build, generating kallsyms data structures is 
> relatively straightforward.
> 
> Objtool availability is a big gating condition though. :-/
> 
> [ ... and still Acked-by on -v4 too. ]

I just sent out a v5 and removed your Acked-by because the changes to v5
are non-trivial like the previous changes in the other versions were.

The big difference was that I needed place holders for the invalid
functions in the available_filter_functions file, as I forgot that
libtracefs uses the line number of these functions as a way to enable them
in the set_ftrace_filter and set_ftrace_notrace files. Removing them made
the indexing not in sync, and broke trace-cmd.

I also added a work queue at boot up to run through all the records and
mark any of the ones that fail the kallsyms check as DISABLED.

If you want, feel free to review and ack that change too.

  https://lore.kernel.org/all/20220527163205.421c7828@gandalf.local.home/

I need to add a selftest to test the indexing code as well. The only reason
I found it was that I was writing my presentation for Embedded Recipes and
was using it as an example. And when the filtering wasn't working, I had to
figure out why.

-- Steve

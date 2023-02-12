Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77BFD6935E0
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 04:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjBLDpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 22:45:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjBLDpE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 22:45:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA4B10A85;
        Sat, 11 Feb 2023 19:45:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43E0A60B42;
        Sun, 12 Feb 2023 03:45:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5851C433EF;
        Sun, 12 Feb 2023 03:44:57 +0000 (UTC)
Date:   Sat, 11 Feb 2023 22:44:55 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     John Stultz <jstultz@google.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
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
Message-ID: <20230211224455.0a4b2914@gandalf.local.home>
In-Reply-To: <CALOAHbAnFHAiMH4QDgS6xN16B31qfhG8tfQ+iioCr9pw3sP=bw@mail.gmail.com>
References: <20211120112738.45980-1-laoar.shao@gmail.com>
        <20211120112738.45980-8-laoar.shao@gmail.com>
        <Y+QaZtz55LIirsUO@google.com>
        <CAADnVQ+nf8MmRWP+naWwZEKBFOYr7QkZugETgAVfjKcEVxmOtg@mail.gmail.com>
        <CANDhNCo_=Q3pWc7h=ruGyHdRVGpsMKRY=C2AtZgLDwtGzRz8Kw@mail.gmail.com>
        <20230208212858.477cd05e@gandalf.local.home>
        <20230208213343.40ee15a5@gandalf.local.home>
        <20230211140011.4f15a633@gandalf.local.home>
        <CALOAHbAnFHAiMH4QDgS6xN16B31qfhG8tfQ+iioCr9pw3sP=bw@mail.gmail.com>
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

On Sun, 12 Feb 2023 11:38:52 +0800
Yafang Shao <laoar.shao@gmail.com> wrote:

> > Actually, there are cases that this needs to be a number, as b3bc8547d3be6
> > ("tracing: Have TRACE_DEFINE_ENUM affect trace event types as well") made
> > it update fields as well as the printk fmt.
> >  
> 
> It seems that TRACE_DEFINE_ENUM(TASK_COMM_LEN) in the trace events
> header files would be a better fix.

NACK! I much prefer the proper fix that adds the length.

-- Steve

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA4A1E0F93
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 15:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403812AbgEYNey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 09:34:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:46578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388794AbgEYNex (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 09:34:53 -0400
Received: from quaco.ghostprotocols.net (unknown [179.97.37.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64B8E2078B;
        Mon, 25 May 2020 13:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590413692;
        bh=LKwcpxkHQoO3E/8QaKt2bzjocoFx3vHlcNvLz/L4MiQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wemD2NKWMlvPpTU9wb/1jYNbEK71jG9+ZVcp2HTG/Glq+tRQe5vaEYi5At27yiQDK
         VHyxpangjdAiZ6PnRhwF5BtYkaGc9vRdGDGqBU77wkA0UsYL5N8LfDmuVSGJCdDAjQ
         rWzrLpBSyPgaXCU8+I8CcnzSbnfR42rjlbvEhp1U=
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id A02E840AFD; Mon, 25 May 2020 10:34:48 -0300 (-03)
Date:   Mon, 25 May 2020 10:34:48 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Ian Rogers <irogers@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Kajol Jain <kjain@linux.ibm.com>,
        Andi Kleen <ak@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Paul Clarke <pc@us.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-perf-users <linux-perf-users@vger.kernel.org>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v2 0/7] Share events between metrics
Message-ID: <20200525133448.GJ14034@kernel.org>
References: <20200520182011.32236-1-irogers@google.com>
 <20200521114325.GT157452@krava>
 <20200521172235.GD14034@kernel.org>
 <20200522101311.GA404187@krava>
 <20200522144908.GI14034@kernel.org>
 <CAP-5=fUaaNpi3RZd9-Q-uCaudop0tU5NN8HFek5e2XLoBZqt6w@mail.gmail.com>
 <CAP-5=fWZYJ2RXeXGGmFXAW9CNnb2S6cGYKc_M=hUQyCng7KJBQ@mail.gmail.com>
 <20200523221936.GA123450@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200523221936.GA123450@krava>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Sun, May 24, 2020 at 12:19:36AM +0200, Jiri Olsa escreveu:
> On Fri, May 22, 2020 at 10:56:59AM -0700, Ian Rogers wrote:
> 
> SNIP
> 
> > >> >       #11 0x00000000004b6911 in cmd_test (argc=1, argv=0x7fffffffd7f0) at tests/builtin-test.c:772
> > >> >       #12 0x00000000004e977b in run_builtin (p=0xa7eee8 <commands+552>, argc=3, argv=0x7fffffffd7f0) at perf.c:312
> > >> >       #13 0x00000000004e99e8 in handle_internal_command (argc=3, argv=0x7fffffffd7f0) at perf.c:364
> > >> >       #14 0x00000000004e9b2f in run_argv (argcp=0x7fffffffd64c, argv=0x7fffffffd640) at perf.c:408
> > >> >       #15 0x00000000004e9efb in main (argc=3, argv=0x7fffffffd7f0) at perf.c:538
> > >> >
> > >> > attached patch fixes it for me, but I'm not sure this
> > >> > should be necessary
> > >>
> > >> ... applying the patch below makes the segfault go away. Ian, Ack? I can
> > >> fold it into the patch introducing the problem.
> > >
> > >
> > > I suspect this patch is a memory leak. The underlying issue is likely the outstanding hashmap_clear fix in libbpf. Let me check.
> > >
> > > Thanks,
> > > Ian
> > 
> > Tested:
> > $ git checkout -b testing acme/tmp.perf/core
> > $ make ...
> > $ perf test 7
> > 7: Simple expression parser                              : FAILED!
> > $ git cherry-pick 6bca339175bf
> > [acme-perf-expr-testing 4614bd252003] libbpf: Fix memory leak and
> > possible double-free in hashmap__c
> 
> yep, it fixes the issue for me, but I see that under different commit number:
> 
>   229bf8bf4d91 libbpf: Fix memory leak and possible double-free in hashmap__clear

Ok, so I'll just add a note mentioning that this test will pass as soon
as the libbpf fix gets upstream.

Thanks,

- Arnaldo

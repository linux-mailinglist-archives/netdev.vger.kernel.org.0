Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6743C1DE999
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 16:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730211AbgEVOtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 10:49:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729997AbgEVOtL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 10:49:11 -0400
Received: from quaco.ghostprotocols.net (unknown [179.97.37.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FB272053B;
        Fri, 22 May 2020 14:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590158950;
        bh=+f8T2XpT8Zs8Bv6jUoU95oWGnxtHJs1LfQUPUFLZoH0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=edd2Pq2RYEDWriBG3FIvJMQZkQaEKEA6gjJnWJR4IxrGt/96GYfF3iAMeTWP0Qz91
         F9KSgJe0b45RU0Acj+Y7AScf3KNpZfTR/rQDDlo6/QZDvDAw13pgS7j7tJTmDg2LOJ
         neMMXHHZUZD8YlqtbsbG8Mj9JTPQoyGpisYtgbtA=
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 4382240AFD; Fri, 22 May 2020 11:49:08 -0300 (-03)
Date:   Fri, 22 May 2020 11:49:08 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>, Ian Rogers <irogers@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
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
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Vince Weaver <vincent.weaver@maine.edu>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v2 0/7] Share events between metrics
Message-ID: <20200522144908.GI14034@kernel.org>
References: <20200520182011.32236-1-irogers@google.com>
 <20200521114325.GT157452@krava>
 <20200521172235.GD14034@kernel.org>
 <20200522101311.GA404187@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522101311.GA404187@krava>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, May 22, 2020 at 12:13:11PM +0200, Jiri Olsa escreveu:
> On Thu, May 21, 2020 at 02:22:35PM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Thu, May 21, 2020 at 01:43:25PM +0200, Jiri Olsa escreveu:
> > > On Wed, May 20, 2020 at 11:20:04AM -0700, Ian Rogers wrote:
> > > 
> > > SNIP
> > > 
> > > > There are 5 out of 12 metric groups where no events are shared, such
> > > > as Power, however, disabling grouping of events always reduces the
> > > > number of events.
> > > > 
> > > > The result for Memory_BW needs explanation:
> > > > 
> > > > Metric group: Memory_BW
> > > >  - No merging (old default, now --metric-no-merge): 9
> > > >  - Merging over metrics (new default)             : 5
> > > >  - No event groups and merging (--metric-no-group): 11
> > > > 
> > > > Both with and without merging the groups fail to be set up and so the
> > > > event counts here are for broken metrics. The --metric-no-group number
> > > > is accurate as all the events are scheduled. Ideally a constraint
> > > > would be added for these metrics in the json code to avoid grouping.
> > > > 
> > > > v2. rebases on kernel/git/acme/linux.git branch tmp.perf/core, fixes a
> > > > missing comma with metric lists (reported-by Jiri Olsa
> > > > <jolsa@redhat.com>) and adds early returns to metricgroup__add_metric
> > > > (suggested-by Jiri Olsa).
> > > 
> > > Acked-by: Jiri Olsa <jolsa@redhat.com>
> > 
> > Applied and pushed to tmp.perf/core, will move to perf/core as soon as
> > testing finishes,
> 
> I checked tmp.perf/core and I'm getting segfault for 'perf test expr'

Right, reproduced here and...
 
> 	 7: Simple expression parser                              :
> 	Program received signal SIGSEGV, Segmentation fault.
> 	0x000000000067841e in hashmap_find_entry (map=0x7fffffffd0c0, key=0xc83b30, hash=9893851511679796638, pprev=0x0, entry=0x7fffffffc658) at hashmap.c:131
> 	131             for (prev_ptr = &map->buckets[hash], cur = *prev_ptr;
> 	(gdb) bt
> 	#0  0x000000000067841e in hashmap_find_entry (map=0x7fffffffd0c0, key=0xc83b30, hash=9893851511679796638, pprev=0x0, entry=0x7fffffffc658) at hashmap.c:131
> 	#1  0x000000000067853a in hashmap__insert (map=0x7fffffffd0c0, key=0xc83b30, value=0x0, strategy=HASHMAP_SET, old_key=0x7fffffffc718, 
> 	    old_value=0x7fffffffc710) at hashmap.c:160
> 	#2  0x00000000005d3209 in hashmap__set (map=0x7fffffffd0c0, key=0xc83b30, value=0x0, old_key=0x7fffffffc718, old_value=0x7fffffffc710)
> 	    at /home/jolsa/kernel/linux-perf/tools/perf/util/hashmap.h:107
> 	#3  0x00000000005d3386 in expr__add_id (ctx=0x7fffffffd0c0, name=0xc83b30 "FOO", val=0) at util/expr.c:45
> 	#4  0x00000000005d27ee in expr_parse (final_val=0x0, ctx=0x7fffffffd0c0, scanner=0xc87990) at util/expr.y:63
> 	#5  0x00000000005d35b7 in __expr__parse (val=0x0, ctx=0x7fffffffd0c0, expr=0x75a84b "FOO + BAR + BAZ + BOZO", start=259, runtime=1) at util/expr.c:102
> 	#6  0x00000000005d36c6 in expr__find_other (expr=0x75a84b "FOO + BAR + BAZ + BOZO", one=0x75a791 "FOO", ctx=0x7fffffffd0c0, runtime=1) at util/expr.c:121
> 	#7  0x00000000004e3aaf in test__expr (t=0xa7bd40 <generic_tests+384>, subtest=-1) at tests/expr.c:55
> 	#8  0x00000000004b5651 in run_test (test=0xa7bd40 <generic_tests+384>, subtest=-1) at tests/builtin-test.c:393
> 	#9  0x00000000004b5787 in test_and_print (t=0xa7bd40 <generic_tests+384>, force_skip=false, subtest=-1) at tests/builtin-test.c:423
> 	#10 0x00000000004b61c4 in __cmd_test (argc=1, argv=0x7fffffffd7f0, skiplist=0x0) at tests/builtin-test.c:628
> 	#11 0x00000000004b6911 in cmd_test (argc=1, argv=0x7fffffffd7f0) at tests/builtin-test.c:772
> 	#12 0x00000000004e977b in run_builtin (p=0xa7eee8 <commands+552>, argc=3, argv=0x7fffffffd7f0) at perf.c:312
> 	#13 0x00000000004e99e8 in handle_internal_command (argc=3, argv=0x7fffffffd7f0) at perf.c:364
> 	#14 0x00000000004e9b2f in run_argv (argcp=0x7fffffffd64c, argv=0x7fffffffd640) at perf.c:408
> 	#15 0x00000000004e9efb in main (argc=3, argv=0x7fffffffd7f0) at perf.c:538
> 
> attached patch fixes it for me, but I'm not sure this
> should be necessary

... applying the patch below makes the segfault go away. Ian, Ack? I can
fold it into the patch introducing the problem.

- Arnaldo
 
> jirka
> 
> 
> ---
> diff --git a/tools/perf/tests/expr.c b/tools/perf/tests/expr.c
> index 1cb02ca2b15f..21693fe516c1 100644
> --- a/tools/perf/tests/expr.c
> +++ b/tools/perf/tests/expr.c
> @@ -52,6 +52,7 @@ int test__expr(struct test *t __maybe_unused, int subtest __maybe_unused)
>  	TEST_ASSERT_VAL("missing operand", ret == -1);
>  
>  	expr__ctx_clear(&ctx);
> +	expr__ctx_init(&ctx);
>  	TEST_ASSERT_VAL("find other",
>  			expr__find_other("FOO + BAR + BAZ + BOZO", "FOO",
>  					 &ctx, 1) == 0);
> @@ -64,6 +65,7 @@ int test__expr(struct test *t __maybe_unused, int subtest __maybe_unused)
>  						    (void **)&val_ptr));
>  
>  	expr__ctx_clear(&ctx);
> +	expr__ctx_init(&ctx);
>  	TEST_ASSERT_VAL("find other",
>  			expr__find_other("EVENT1\\,param\\=?@ + EVENT2\\,param\\=?@",
>  					 NULL, &ctx, 3) == 0);
> 
> 

-- 

- Arnaldo

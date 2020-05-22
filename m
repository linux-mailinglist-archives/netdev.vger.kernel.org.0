Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6F31DE3C7
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 12:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728641AbgEVKN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 06:13:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25329 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728542AbgEVKN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 06:13:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590142404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jmmhgCWLlRr4VrUoOVJYV5wmsB/OPdH6k2kU0IKZExE=;
        b=Oy8jYKu6jLJRAgEsEs0JF5GvwO0sliwJBGI0poo53izCdWKgyzqWyS7gLIJNfZLQB/9SA1
        Px+xnMhUK+OLurq5xdUbCf9wKLqDdwIvG9wnW+2Th/iMYiQhP7ZykrzsDBOJKMQzgwZMV9
        J7gO5MP8Ry68YYPCTg5irg0mXtH/CEE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-kwhSc4EHP92KGJQ6eq9sSg-1; Fri, 22 May 2020 06:13:20 -0400
X-MC-Unique: kwhSc4EHP92KGJQ6eq9sSg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA24C8015CF;
        Fri, 22 May 2020 10:13:17 +0000 (UTC)
Received: from krava (unknown [10.40.195.217])
        by smtp.corp.redhat.com (Postfix) with SMTP id 55C413420A;
        Fri, 22 May 2020 10:13:12 +0000 (UTC)
Date:   Fri, 22 May 2020 12:13:11 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ian Rogers <irogers@google.com>
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
Message-ID: <20200522101311.GA404187@krava>
References: <20200520182011.32236-1-irogers@google.com>
 <20200521114325.GT157452@krava>
 <20200521172235.GD14034@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200521172235.GD14034@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 02:22:35PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, May 21, 2020 at 01:43:25PM +0200, Jiri Olsa escreveu:
> > On Wed, May 20, 2020 at 11:20:04AM -0700, Ian Rogers wrote:
> > 
> > SNIP
> > 
> > > There are 5 out of 12 metric groups where no events are shared, such
> > > as Power, however, disabling grouping of events always reduces the
> > > number of events.
> > > 
> > > The result for Memory_BW needs explanation:
> > > 
> > > Metric group: Memory_BW
> > >  - No merging (old default, now --metric-no-merge): 9
> > >  - Merging over metrics (new default)             : 5
> > >  - No event groups and merging (--metric-no-group): 11
> > > 
> > > Both with and without merging the groups fail to be set up and so the
> > > event counts here are for broken metrics. The --metric-no-group number
> > > is accurate as all the events are scheduled. Ideally a constraint
> > > would be added for these metrics in the json code to avoid grouping.
> > > 
> > > v2. rebases on kernel/git/acme/linux.git branch tmp.perf/core, fixes a
> > > missing comma with metric lists (reported-by Jiri Olsa
> > > <jolsa@redhat.com>) and adds early returns to metricgroup__add_metric
> > > (suggested-by Jiri Olsa).
> > 
> > Acked-by: Jiri Olsa <jolsa@redhat.com>
> 
> Applied and pushed to tmp.perf/core, will move to perf/core as soon as
> testing finishes,

I checked tmp.perf/core and I'm getting segfault for 'perf test expr'

	 7: Simple expression parser                              :
	Program received signal SIGSEGV, Segmentation fault.
	0x000000000067841e in hashmap_find_entry (map=0x7fffffffd0c0, key=0xc83b30, hash=9893851511679796638, pprev=0x0, entry=0x7fffffffc658) at hashmap.c:131
	131             for (prev_ptr = &map->buckets[hash], cur = *prev_ptr;
	(gdb) bt
	#0  0x000000000067841e in hashmap_find_entry (map=0x7fffffffd0c0, key=0xc83b30, hash=9893851511679796638, pprev=0x0, entry=0x7fffffffc658) at hashmap.c:131
	#1  0x000000000067853a in hashmap__insert (map=0x7fffffffd0c0, key=0xc83b30, value=0x0, strategy=HASHMAP_SET, old_key=0x7fffffffc718, 
	    old_value=0x7fffffffc710) at hashmap.c:160
	#2  0x00000000005d3209 in hashmap__set (map=0x7fffffffd0c0, key=0xc83b30, value=0x0, old_key=0x7fffffffc718, old_value=0x7fffffffc710)
	    at /home/jolsa/kernel/linux-perf/tools/perf/util/hashmap.h:107
	#3  0x00000000005d3386 in expr__add_id (ctx=0x7fffffffd0c0, name=0xc83b30 "FOO", val=0) at util/expr.c:45
	#4  0x00000000005d27ee in expr_parse (final_val=0x0, ctx=0x7fffffffd0c0, scanner=0xc87990) at util/expr.y:63
	#5  0x00000000005d35b7 in __expr__parse (val=0x0, ctx=0x7fffffffd0c0, expr=0x75a84b "FOO + BAR + BAZ + BOZO", start=259, runtime=1) at util/expr.c:102
	#6  0x00000000005d36c6 in expr__find_other (expr=0x75a84b "FOO + BAR + BAZ + BOZO", one=0x75a791 "FOO", ctx=0x7fffffffd0c0, runtime=1) at util/expr.c:121
	#7  0x00000000004e3aaf in test__expr (t=0xa7bd40 <generic_tests+384>, subtest=-1) at tests/expr.c:55
	#8  0x00000000004b5651 in run_test (test=0xa7bd40 <generic_tests+384>, subtest=-1) at tests/builtin-test.c:393
	#9  0x00000000004b5787 in test_and_print (t=0xa7bd40 <generic_tests+384>, force_skip=false, subtest=-1) at tests/builtin-test.c:423
	#10 0x00000000004b61c4 in __cmd_test (argc=1, argv=0x7fffffffd7f0, skiplist=0x0) at tests/builtin-test.c:628
	#11 0x00000000004b6911 in cmd_test (argc=1, argv=0x7fffffffd7f0) at tests/builtin-test.c:772
	#12 0x00000000004e977b in run_builtin (p=0xa7eee8 <commands+552>, argc=3, argv=0x7fffffffd7f0) at perf.c:312
	#13 0x00000000004e99e8 in handle_internal_command (argc=3, argv=0x7fffffffd7f0) at perf.c:364
	#14 0x00000000004e9b2f in run_argv (argcp=0x7fffffffd64c, argv=0x7fffffffd640) at perf.c:408
	#15 0x00000000004e9efb in main (argc=3, argv=0x7fffffffd7f0) at perf.c:538

attached patch fixes it for me, but I'm not sure this
should be necessary

jirka


---
diff --git a/tools/perf/tests/expr.c b/tools/perf/tests/expr.c
index 1cb02ca2b15f..21693fe516c1 100644
--- a/tools/perf/tests/expr.c
+++ b/tools/perf/tests/expr.c
@@ -52,6 +52,7 @@ int test__expr(struct test *t __maybe_unused, int subtest __maybe_unused)
 	TEST_ASSERT_VAL("missing operand", ret == -1);
 
 	expr__ctx_clear(&ctx);
+	expr__ctx_init(&ctx);
 	TEST_ASSERT_VAL("find other",
 			expr__find_other("FOO + BAR + BAZ + BOZO", "FOO",
 					 &ctx, 1) == 0);
@@ -64,6 +65,7 @@ int test__expr(struct test *t __maybe_unused, int subtest __maybe_unused)
 						    (void **)&val_ptr));
 
 	expr__ctx_clear(&ctx);
+	expr__ctx_init(&ctx);
 	TEST_ASSERT_VAL("find other",
 			expr__find_other("EVENT1\\,param\\=?@ + EVENT2\\,param\\=?@",
 					 NULL, &ctx, 3) == 0);



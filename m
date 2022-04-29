Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B60A514841
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 13:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358515AbiD2LiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 07:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358492AbiD2LiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 07:38:04 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 131A756C2D;
        Fri, 29 Apr 2022 04:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651232086; x=1682768086;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+cVgl0hg4+FfEa3fwzkyzeeufuAMXREixA82G/CSzOQ=;
  b=l6mSaaVQl4kixASiS5B71nUyWmSnAIrrqF3nUeiHj5+3h7K5urvOSgV3
   wLRkS9P7PxhqyyU8T06JA2JQVZXf2bWt1v1mpDF6zZ1AILIglFjPMyrVT
   7n7vq/u/pR9sf6aLndkxMFJ2m8KGFnFVXrnI89q9i7BSo4EhxlbKQJijo
   Pe2anHbpUO94CWpnF0BNA1LNhax+5S8Dy1SqQQVJZnls/KXQSXUA3ABeq
   v0ZTk2INvzEdfBaTrTc64j2tHkfEwm9ZEMEYK0TlQ1Y3Y2jr9ngf9OvdF
   iyezDYuDDgYx8lYI8oaBQ4fciim0WlefTHcDE7w5nwfg7DQH/InhhrXfT
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="291789356"
X-IronPort-AV: E=Sophos;i="5.91,185,1647327600"; 
   d="scan'208";a="291789356"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 04:34:45 -0700
X-IronPort-AV: E=Sophos;i="5.91,185,1647327600"; 
   d="scan'208";a="582077415"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.58.231])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 04:34:36 -0700
Message-ID: <e82c7ab0-605e-8795-58dd-dc182f80c6b3@intel.com>
Date:   Fri, 29 Apr 2022 14:34:31 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.8.1
Subject: Re: [PATCH v3 4/5] perf evlist: Respect all_cpus when setting
 user_requested_cpus
Content-Language: en-US
To:     Ian Rogers <irogers@google.com>
Cc:     Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mike Leach <mike.leach@linaro.org>,
        Leo Yan <leo.yan@linaro.org>,
        John Garry <john.garry@huawei.com>,
        Will Deacon <will@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Kajol Jain <kjain@linux.ibm.com>,
        James Clark <james.clark@arm.com>,
        German Gomez <german.gomez@arm.com>,
        Riccardo Mancini <rickyman7@gmail.com>,
        Andi Kleen <ak@linux.intel.com>,
        Alexey Bayduraev <alexey.v.bayduraev@linux.intel.com>,
        Alexander Antonov <alexander.antonov@linux.intel.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        coresight@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20220408035616.1356953-1-irogers@google.com>
 <20220408035616.1356953-5-irogers@google.com>
 <c9205f19-52bf-43fe-b1ab-b599d5e2cc7a@intel.com>
 <CAP-5=fVNuQDW+yge897RjaWfE3cfQTD4ufFws6PS2k99Qe05Uw@mail.gmail.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <CAP-5=fVNuQDW+yge897RjaWfE3cfQTD4ufFws6PS2k99Qe05Uw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-10.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/04/22 23:49, Ian Rogers wrote:
> On Thu, Apr 28, 2022 at 1:16 PM Adrian Hunter <adrian.hunter@intel.com <mailto:adrian.hunter@intel.com>> wrote:
> 
>     On 8/04/22 06:56, Ian Rogers wrote:
>     > If all_cpus is calculated it represents the merge/union of all
>     > evsel cpu maps. By default user_requested_cpus is computed to be
>     > the online CPUs. For uncore events, it is often the case currently
>     > that all_cpus is a subset of user_requested_cpus. Metrics printed
>     > without aggregation and with metric-only, in print_no_aggr_metric,
>     > iterate over user_requested_cpus assuming every CPU has a metric to
>     > print. For each CPU the prefix is printed, but then if the
>     > evsel's cpus doesn't contain anything you get an empty line like
>     > the following on a 2 socket 36 core SkylakeX:
>     >
>     > ```
>     > $ perf stat -A -M DRAM_BW_Use -a --metric-only -I 1000
>     >      1.000453137 CPU0                       0.00
>     >      1.000453137
>     >      1.000453137
>     >      1.000453137
>     >      1.000453137
>     >      1.000453137
>     >      1.000453137
>     >      1.000453137
>     >      1.000453137
>     >      1.000453137
>     >      1.000453137
>     >      1.000453137
>     >      1.000453137
>     >      1.000453137
>     >      1.000453137
>     >      1.000453137
>     >      1.000453137
>     >      1.000453137
>     >      1.000453137 CPU18                      0.00
>     >      1.000453137
>     >      1.000453137
>     >      1.000453137
>     >      1.000453137
>     >      1.000453137
>     >      1.000453137
>     >      1.000453137
>     >      1.000453137
>     >      1.000453137
>     >      1.000453137
>     >      1.000453137
>     >      1.000453137
>     >      1.000453137
>     >      1.000453137
>     >      1.000453137
>     >      1.000453137
>     >      1.000453137
>     >      2.003717143 CPU0                       0.00
>     > ...
>     > ```
>     >
>     > While it is possible to be lazier in printing the prefix and
>     > trailing newline, having user_requested_cpus not be a subset of
>     > all_cpus is preferential so that wasted work isn't done elsewhere
>     > user_requested_cpus is used. The change modifies user_requested_cpus
>     > to be the intersection of user specified CPUs, or default all online
>     > CPUs, with the CPUs computed through the merge of all evsel cpu maps.
>     >
>     > New behavior:
>     > ```
>     > $ perf stat -A -M DRAM_BW_Use -a --metric-only -I 1000
>     >      1.001086325 CPU0                       0.00
>     >      1.001086325 CPU18                      0.00
>     >      2.003671291 CPU0                       0.00
>     >      2.003671291 CPU18                      0.00
>     > ...
>     > ```
>     >
>     > Signed-off-by: Ian Rogers <irogers@google.com <mailto:irogers@google.com>>
>     > ---
>     >  tools/perf/util/evlist.c | 7 +++++++
>     >  1 file changed, 7 insertions(+)
>     >
>     > diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
>     > index 52ea004ba01e..196d57b905a0 100644
>     > --- a/tools/perf/util/evlist.c
>     > +++ b/tools/perf/util/evlist.c
>     > @@ -1036,6 +1036,13 @@ int evlist__create_maps(struct evlist *evlist, struct target *target)
>     >       if (!cpus)
>     >               goto out_delete_threads;
>     > 
>     > +     if (evlist->core.all_cpus) {
>     > +             struct perf_cpu_map *tmp;
>     > +
>     > +             tmp = perf_cpu_map__intersect(cpus, evlist->core.all_cpus);
> 
>     Isn't an uncore PMU represented as being on CPU0 actually
>     collecting data that can be due to any CPU.
> 
> 
> This is correct but the counter is only opened on CPU0 as the all_cpus cpu_map will only contain CPU0. Trying to dump the counter for say CPU1 will fail as there is no counter there. This is why the metric-only output isn't displaying anything above.

That's not what happens for me:

$ perf stat -A -M DRAM_BW_Use -a --metric-only -I 1000 -- sleep 1
#           time CPU              DRAM_BW_Use 
     1.001114691 CPU0                       0.00 
     1.001114691 
     1.001114691 
     1.001114691 
     1.001114691 
     1.001114691 
     1.001114691 
     1.001114691 
     1.001114691 
     1.001114691 
     1.001114691 
     1.001114691 
     1.001114691 
     1.001114691 
     1.001114691 
     1.001114691 
     1.001114691 
     1.001114691 
     1.001114691 
     1.001114691 
     1.001114691 
     1.001114691 
     1.001114691 
     1.001114691 
     1.001114691 
     1.001114691 
     1.001114691 
     1.001114691 
     1.002265387 CPU0                       0.00 
     1.002265387 
     1.002265387 
     1.002265387 
     1.002265387 
     1.002265387 
     1.002265387 
     1.002265387 
     1.002265387 
     1.002265387 
     1.002265387 
     1.002265387 
     1.002265387 
     1.002265387 
     1.002265387 
     1.002265387 
     1.002265387 
     1.002265387 
     1.002265387 
     1.002265387 
     1.002265387 
     1.002265387 
     1.002265387 
     1.002265387 
     1.002265387 
     1.002265387 
     1.002265387 
     1.002265387 

perf stat -A -M DRAM_BW_Use -a --metric-only -I 1000 -C 1 -- sleep 1
#           time CPU              DRAM_BW_Use 
     1.001100827 CPU1                       0.00 
     1.002128527 CPU1                       0.00 


>  
> 
>     Or for an uncore PMU represented as being on CPU0-CPU4 on a
>     4 core 8 hyperthread processor, actually 1 PMU per core.
> 
> 
> In this case I believe the CPU map will be CPU0, CPU2, CPU4, CPU6. To get the core counter for hyperthreads on CPU0 and CPU1 you read on CPU0, there is no counter on CPU1 and trying to read it will fail as the counters are indexed by a cpu map index into the all_cpus . Not long ago I cleaned up the cpu_map code as there was quite a bit of confusion over cpus and indexes which were both of type int.
>  
> 
>     So I am not sure intersection makes sense.
> 
>     Also it is not obvious what happens with hybrid CPUs or
>     per thread recording.
> 
> 
> The majority of code is using all_cpus, and so is unchanged by this change.

I am not sure what you mean.  Every tool uses this code.  It affects everything when using PMUs with their own cpus.

 Code that is affected, when it say needs to use counters, needs to check that the user CPU was valid in all_cpus, and use the all_cpus index. The metric-only output could be fixed in the same way, ie don't display lines when the user_requested_cpu isn't in all_cpus. I prefered to solve the problem this way as it is inefficient  to be processing cpus where there can be no corresponding counters, etc. We may be setting something like affinity unnecessarily - although that doesn't currently happen as that code iterates over all_cpus. I also think it is confusing from its name when the variable all_cpus is for a cpu_map that contains fewer cpus than user_requested_cpus - albeit that was worse when user_requested_cpus was called just cpus.
> 
> It could be hybrid or intel-pt have different assumptions on these cpu_maps. I don't have access to a hybrid test system. For intel-pt it'd be great if there were a perf test. Given that most code is using all_cpus and was cleaned up as part of the cpu_map work, I believe the change to be correct.

Mainly what happens if you try to intersect all_cpus with dummy cpus?

> 
> Thanks,
> Ian
> 
> 
>     > +             perf_cpu_map__put(cpus);
>     > +             cpus = tmp;
>     > +     }
>     >       evlist->core.has_user_cpus = !!target->cpu_list && !target->hybrid;
>     > 
>     >       perf_evlist__set_maps(&evlist->core, cpus, threads);
> 


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71B5D513C8C
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 22:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236307AbiD1UTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 16:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233541AbiD1UTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 16:19:13 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BDDB4BFDE;
        Thu, 28 Apr 2022 13:15:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651176957; x=1682712957;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zMklSUCdIQqEBYk+4h1mfKBKNx+yRC9UqcAiC5+Gp/c=;
  b=L3dgOZih1RaQJxQOZ2VmonmuHlY15fZjdQNglq6g3VXJdOpix2oruwpJ
   fR0Uf53s/RUIev1OpHEexGveNJLHJgm/foxRJcxbdxJJ5oKnjY1oEHaNT
   iuAL8uuSXQh/BPlQkU22vsKVu4lPEpq8+5YA+NxjEsLfQKneLjCobwNpH
   JOc1ffww+QQredmE1FJ2+R//4I17XGUxz8olYDoai7iPpcXgqnNhc7YXR
   sZTGroYZFyaE9pFEOvLehK63UM/B7L3Psn2Ql3RBWMN/DC6pMjAo0N8s9
   fY9UT+FBjfdcK0cEUSWuxg5NXnJiTDJWIdyt0+RyopRBA7zDM6igsWcVF
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="266566221"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="266566221"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 13:15:57 -0700
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="581612352"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.32.153])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 13:15:48 -0700
Message-ID: <c9205f19-52bf-43fe-b1ab-b599d5e2cc7a@intel.com>
Date:   Thu, 28 Apr 2022 23:15:42 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
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
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20220408035616.1356953-5-irogers@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/04/22 06:56, Ian Rogers wrote:
> If all_cpus is calculated it represents the merge/union of all
> evsel cpu maps. By default user_requested_cpus is computed to be
> the online CPUs. For uncore events, it is often the case currently
> that all_cpus is a subset of user_requested_cpus. Metrics printed
> without aggregation and with metric-only, in print_no_aggr_metric,
> iterate over user_requested_cpus assuming every CPU has a metric to
> print. For each CPU the prefix is printed, but then if the
> evsel's cpus doesn't contain anything you get an empty line like
> the following on a 2 socket 36 core SkylakeX:
> 
> ```
> $ perf stat -A -M DRAM_BW_Use -a --metric-only -I 1000
>      1.000453137 CPU0                       0.00
>      1.000453137
>      1.000453137
>      1.000453137
>      1.000453137
>      1.000453137
>      1.000453137
>      1.000453137
>      1.000453137
>      1.000453137
>      1.000453137
>      1.000453137
>      1.000453137
>      1.000453137
>      1.000453137
>      1.000453137
>      1.000453137
>      1.000453137
>      1.000453137 CPU18                      0.00
>      1.000453137
>      1.000453137
>      1.000453137
>      1.000453137
>      1.000453137
>      1.000453137
>      1.000453137
>      1.000453137
>      1.000453137
>      1.000453137
>      1.000453137
>      1.000453137
>      1.000453137
>      1.000453137
>      1.000453137
>      1.000453137
>      1.000453137
>      2.003717143 CPU0                       0.00
> ...
> ```
> 
> While it is possible to be lazier in printing the prefix and
> trailing newline, having user_requested_cpus not be a subset of
> all_cpus is preferential so that wasted work isn't done elsewhere
> user_requested_cpus is used. The change modifies user_requested_cpus
> to be the intersection of user specified CPUs, or default all online
> CPUs, with the CPUs computed through the merge of all evsel cpu maps.
> 
> New behavior:
> ```
> $ perf stat -A -M DRAM_BW_Use -a --metric-only -I 1000
>      1.001086325 CPU0                       0.00
>      1.001086325 CPU18                      0.00
>      2.003671291 CPU0                       0.00
>      2.003671291 CPU18                      0.00
> ...
> ```
> 
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  tools/perf/util/evlist.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
> index 52ea004ba01e..196d57b905a0 100644
> --- a/tools/perf/util/evlist.c
> +++ b/tools/perf/util/evlist.c
> @@ -1036,6 +1036,13 @@ int evlist__create_maps(struct evlist *evlist, struct target *target)
>  	if (!cpus)
>  		goto out_delete_threads;
>  
> +	if (evlist->core.all_cpus) {
> +		struct perf_cpu_map *tmp;
> +
> +		tmp = perf_cpu_map__intersect(cpus, evlist->core.all_cpus);

Isn't an uncore PMU represented as being on CPU0 actually
collecting data that can be due to any CPU.

Or for an uncore PMU represented as being on CPU0-CPU4 on a
4 core 8 hyperthread processor, actually 1 PMU per core.

So I am not sure intersection makes sense.

Also it is not obvious what happens with hybrid CPUs or
per thread recording.

> +		perf_cpu_map__put(cpus);
> +		cpus = tmp;
> +	}
>  	evlist->core.has_user_cpus = !!target->cpu_list && !target->hybrid;
>  
>  	perf_evlist__set_maps(&evlist->core, cpus, threads);


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4910B4EA177
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 22:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345203AbiC1U2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 16:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345122AbiC1U2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 16:28:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F5766612;
        Mon, 28 Mar 2022 13:26:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E84E9B81107;
        Mon, 28 Mar 2022 20:26:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58486C34100;
        Mon, 28 Mar 2022 20:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648499187;
        bh=JbZmSa9juiLf0oAIpCV18B8Gsa8QNhEYAXYAWPoGCjY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CIshgBsAthZuhsL1QUYnPtPpeH8E4IrAr2ib6qONsURzkGABcvVjzKbKyWBMtcTA1
         vK+4LI8FpxEdrpOfm2xZMgMNCWUm/Nr3r2g5NdExEjBAEY93bhy5PB6vwR59LrAeiA
         KHjwP9cHKcwehG0hQZA4FRfVPYssYmIm0K1+8yfzQNDnMXSTPKL3t5vPoQzlUwAXme
         mr1qd2zFrVsZwtZlvxfxPMP3ZHSHYQxc0n2hgO2+ndP/1EER7wuBEDlYYm5iJV4ITB
         2R7gEsMrsYFHbk6zJlzIQKw+ZUDTjQupKHZ0a4pAjoh2FJAsXzaEkrQerdT7zfl/82
         oh14FN2Roaclw==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id D9D9940407; Mon, 28 Mar 2022 17:26:24 -0300 (-03)
Date:   Mon, 28 Mar 2022 17:26:24 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ian Rogers <irogers@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
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
        Adrian Hunter <adrian.hunter@intel.com>,
        Riccardo Mancini <rickyman7@gmail.com>,
        Andi Kleen <ak@linux.intel.com>,
        Alexey Bayduraev <alexey.v.bayduraev@linux.intel.com>,
        Alexander Antonov <alexander.antonov@linux.intel.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        coresight@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/5] perf cpumap: More cpu map reuse by merge.
Message-ID: <YkIZ8MNdWvtPEikz@kernel.org>
References: <20220328062414.1893550-1-irogers@google.com>
 <20220328062414.1893550-3-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220328062414.1893550-3-irogers@google.com>
X-Url:  http://acmel.wordpress.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Sun, Mar 27, 2022 at 11:24:11PM -0700, Ian Rogers escreveu:
> perf_cpu_map__merge will reuse one of its arguments if they are equal or
> the other argument is NULL. The arguments could be reused if it is known
> one set of values is a subset of the other. For example, a map of 0-1
> and a map of just 0 when merged yields the map of 0-1. Currently a new
> map is created rather than adding a reference count to the original 0-1
> map.
> 
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  tools/lib/perf/cpumap.c | 38 ++++++++++++++++++++++++++++----------
>  1 file changed, 28 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/lib/perf/cpumap.c b/tools/lib/perf/cpumap.c
> index ee66760f1e63..953bc50b0e41 100644
> --- a/tools/lib/perf/cpumap.c
> +++ b/tools/lib/perf/cpumap.c
> @@ -319,6 +319,29 @@ struct perf_cpu perf_cpu_map__max(struct perf_cpu_map *map)
>  	return map->nr > 0 ? map->map[map->nr - 1] : result;
>  }
>  
> +/** Is 'b' a subset of 'a'. */
> +static bool perf_cpu_map__is_subset(const struct perf_cpu_map *a,
> +				    const struct perf_cpu_map *b)
> +{
> +	int i, j;
> +
> +	if (a == b || !b)
> +		return true;
> +	if (!a || b->nr > a->nr)
> +		return false;
> +	j = 0;
> +	for (i = 0; i < a->nr; i++) {

Since the kernel bumped the minimum gcc version to one that supports
declaring loop variables locally and that perf has been using this since
forever:

⬢[acme@toolbox perf]$ grep -r '(int [[:alpha:]] = 0;' tools/perf
tools/perf/util/block-info.c:	for (int i = 0; i < nr_hpps; i++)
tools/perf/util/block-info.c:	for (int i = 0; i < nr_hpps; i++) {
tools/perf/util/block-info.c:	for (int i = 0; i < nr_reps; i++)
tools/perf/util/stream.c:	for (int i = 0; i < nr_evsel; i++)
tools/perf/util/stream.c:	for (int i = 0; i < nr_evsel; i++) {
tools/perf/util/stream.c:	for (int i = 0; i < els->nr_evsel; i++) {
tools/perf/util/stream.c:	for (int i = 0; i < es_pair->nr_streams; i++) {
tools/perf/util/stream.c:	for (int i = 0; i < es_base->nr_streams; i++) {
tools/perf/util/cpumap.c:		for (int j = 0; j < c->nr; j++) {
tools/perf/util/mem-events.c:	for (int j = 0; j < PERF_MEM_EVENTS__MAX; j++) {
tools/perf/util/header.c:	for (int i = 0; i < ff->ph->env.nr_hybrid_cpc_nodes; i++) {
tools/perf/builtin-diff.c:	for (int i = 0; i < num; i++)
tools/perf/builtin-diff.c:		for (int i = 0; i < pair->block_info->num; i++) {
tools/perf/builtin-stat.c:	for (int i = 0; i < perf_cpu_map__nr(a->core.cpus); i++) {
⬢[acme@toolbox perf]$

And this builds on all my test containers, please use:

	for (int i = 0, j = 0; i < a->nr; i++)

In this case to make the source code more compact.

> +		if (a->map[i].cpu > b->map[j].cpu)
> +			return false;
> +		if (a->map[i].cpu == b->map[j].cpu) {
> +			j++;
> +			if (j == b->nr)
> +				return true;

Ok, as its guaranteed that cpu_maps are ordered.

> +		}
> +	}
> +	return false;
> +}
> +
>  /*
>   * Merge two cpumaps
>   *
> @@ -335,17 +358,12 @@ struct perf_cpu_map *perf_cpu_map__merge(struct perf_cpu_map *orig,
>  	int i, j, k;
>  	struct perf_cpu_map *merged;
>  
> -	if (!orig && !other)
> -		return NULL;
> -	if (!orig) {
> -		perf_cpu_map__get(other);
> -		return other;
> -	}
> -	if (!other)
> -		return orig;
> -	if (orig->nr == other->nr &&
> -	    !memcmp(orig->map, other->map, orig->nr * sizeof(struct perf_cpu)))
> +	if (perf_cpu_map__is_subset(orig, other))
>  		return orig;

Can't we have first the introduction of perf_cpu_map__is_subset() and
then another patch that gets the refcount, i.e. the four lines below?

> +	if (perf_cpu_map__is_subset(other, orig)) {
> +		perf_cpu_map__put(orig);
> +		return perf_cpu_map__get(other);
> +	}
>  
>  	tmp_len = orig->nr + other->nr;
>  	tmp_cpus = malloc(tmp_len * sizeof(struct perf_cpu));
> -- 
> 2.35.1.1021.g381101b075-goog

-- 

- Arnaldo

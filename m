Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5E6D4EFA4E
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 21:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347075AbiDATOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 15:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236407AbiDATOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 15:14:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174E6617D;
        Fri,  1 Apr 2022 12:12:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB536B82604;
        Fri,  1 Apr 2022 19:12:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C023C340F3;
        Fri,  1 Apr 2022 19:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648840359;
        bh=YApioM8rRksuAEkG5aeY8aT6WHhUt0SJ/cvtvDy3mIQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mq9ioClIwWzL8dm0dnfl9fxy3t4LppiDFcfjh+24Q3lbf5r5aI+7zIrT8zfKATY/q
         nHZaT8suCYmK5RCUOlW0HGDkK1Gpifed4aFZVab0KxfKzX/wsA0Dq9JTKIBXeCV+nh
         FxuJ6zg82piHE1mdtgXYUyUpzImSADdk7KMl4aktptJcxUDYyCQTO+UfjnIqJ9E7aw
         NoO1GVnHIfT2tOSDLmQ6pK6M2bqd6lE9lx5sTGPiXQQK1/NcwxCYqxxgz7gXgzMz55
         GS4yfivU4CP7GzH//pqv3av34vTRFUdxXzAbfn8HgNMFMldQr2J67V1qtKQ0WOo1RB
         FtnUqAt+slLDg==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 5EE5040407; Fri,  1 Apr 2022 16:12:36 -0300 (-03)
Date:   Fri, 1 Apr 2022 16:12:36 -0300
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
Subject: Re: [PATCH v2 5/6] perf cpumap: Add intersect function.
Message-ID: <YkdOpJDnknrOPq2t@kernel.org>
References: <20220328232648.2127340-1-irogers@google.com>
 <20220328232648.2127340-6-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220328232648.2127340-6-irogers@google.com>
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

Em Mon, Mar 28, 2022 at 04:26:47PM -0700, Ian Rogers escreveu:
> The merge function gives the union of two cpu maps. Add an intersect
> function which will be used in the next change.

So I really don't think intersect() shouldn't modify the contents of any
of its arguments, at most return one of them with a bumped refcount, as
an optimization.

The merge() operation is different in the sense that one expects that
one of the operands will be inserted into the other, and even then it
would be better to have a clearer semantic, i.e. merge(a, b) should mean
get the contents of b and insert into a.

Since we're talking about CPUs, it doesn't make sense to have a CPU
multiple times in the cpu_map, so we eliminate duplicates while doing
it.

Also perhaps the merge() operation should not even change any of the
operands, but instead return a new cpuset if one of the operands isn't
contained in the other, in which case a bump in the reference count of
the superset would be a valid optimization.

But that boat has departed already, i.e. perf_cpu_map__merge() is
already an exported libperf API, sigh.

This is something we're exporting, so I think this warrants further
discussion, even with a fix depending on the merge of this new API.

- Arnaldo
 
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  tools/lib/perf/cpumap.c              | 38 ++++++++++++++++++++++++++++
>  tools/lib/perf/include/perf/cpumap.h |  2 ++
>  2 files changed, 40 insertions(+)
> 
> diff --git a/tools/lib/perf/cpumap.c b/tools/lib/perf/cpumap.c
> index 384d5e076ee4..60cccd05f243 100644
> --- a/tools/lib/perf/cpumap.c
> +++ b/tools/lib/perf/cpumap.c
> @@ -390,3 +390,41 @@ struct perf_cpu_map *perf_cpu_map__merge(struct perf_cpu_map *orig,
>  	perf_cpu_map__put(orig);
>  	return merged;
>  }
> +
> +struct perf_cpu_map *perf_cpu_map__intersect(struct perf_cpu_map *orig,
> +					     struct perf_cpu_map *other)
> +{
> +	struct perf_cpu *tmp_cpus;
> +	int tmp_len;
> +	int i, j, k;
> +	struct perf_cpu_map *merged = NULL;
> +
> +	if (perf_cpu_map__is_subset(other, orig))
> +		return orig;
> +	if (perf_cpu_map__is_subset(orig, other)) {
> +		perf_cpu_map__put(orig);
> +		return perf_cpu_map__get(other);
> +	}
> +
> +	tmp_len = max(orig->nr, other->nr);
> +	tmp_cpus = malloc(tmp_len * sizeof(struct perf_cpu));
> +	if (!tmp_cpus)
> +		return NULL;
> +
> +	i = j = k = 0;
> +	while (i < orig->nr && j < other->nr) {
> +		if (orig->map[i].cpu < other->map[j].cpu)
> +			i++;
> +		else if (orig->map[i].cpu > other->map[j].cpu)
> +			j++;
> +		else {
> +			j++;
> +			tmp_cpus[k++] = orig->map[i++];
> +		}
> +	}
> +	if (k)
> +		merged = cpu_map__trim_new(k, tmp_cpus);
> +	free(tmp_cpus);
> +	perf_cpu_map__put(orig);
> +	return merged;
> +}
> diff --git a/tools/lib/perf/include/perf/cpumap.h b/tools/lib/perf/include/perf/cpumap.h
> index 4a2edbdb5e2b..a2a7216c0b78 100644
> --- a/tools/lib/perf/include/perf/cpumap.h
> +++ b/tools/lib/perf/include/perf/cpumap.h
> @@ -19,6 +19,8 @@ LIBPERF_API struct perf_cpu_map *perf_cpu_map__read(FILE *file);
>  LIBPERF_API struct perf_cpu_map *perf_cpu_map__get(struct perf_cpu_map *map);
>  LIBPERF_API struct perf_cpu_map *perf_cpu_map__merge(struct perf_cpu_map *orig,
>  						     struct perf_cpu_map *other);
> +LIBPERF_API struct perf_cpu_map *perf_cpu_map__intersect(struct perf_cpu_map *orig,
> +							 struct perf_cpu_map *other);
>  LIBPERF_API void perf_cpu_map__put(struct perf_cpu_map *map);
>  LIBPERF_API struct perf_cpu perf_cpu_map__cpu(const struct perf_cpu_map *cpus, int idx);
>  LIBPERF_API int perf_cpu_map__nr(const struct perf_cpu_map *cpus);
> -- 
> 2.35.1.1021.g381101b075-goog

-- 

- Arnaldo

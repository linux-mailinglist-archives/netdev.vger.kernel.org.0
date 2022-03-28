Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D88984EA185
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 22:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345735AbiC1UaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 16:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243163AbiC1UaD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 16:30:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B77F63CB;
        Mon, 28 Mar 2022 13:28:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24206614AF;
        Mon, 28 Mar 2022 20:28:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5558CC34100;
        Mon, 28 Mar 2022 20:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648499301;
        bh=L9F9sed3I6zVMFBhDzt/us35ixJsSrs2mjG6DDuTy54=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HQMEO/8UzHEDmCqZYmz0LJD6GbzO1mLlKbjG3+mnvBT+qw8CkKnSLmeiLNBh0BY4K
         0JxZ6sz1CNpFofH/2Ob2AMowYYw25Sa2VzOLz29PIpasDORj6pWNpS+k/PnS54/qCb
         vHNsEHJdSUfqUzUSh6+07Bdmn7G97d7zCE3I1XpGexHN6uA24H2exV4avMfJO52G/e
         dfXXWnQl+I+qGa68FnFUPaY4zojrvARdDYK5XSJ82+Nn4FWxj1W51+mnqR7nDbztuT
         PYW8hTw4f+vVVYPTbMvrLaNOSvkdSR54FsWJl/4A1AfdJAZZWj17Ta6265HfJ4O5yb
         yAuE8FFR+VQRg==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 9A21340407; Mon, 28 Mar 2022 17:28:18 -0300 (-03)
Date:   Mon, 28 Mar 2022 17:28:18 -0300
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
Subject: Re: [PATCH 3/5] perf cpumap: Add intersect function.
Message-ID: <YkIaYq2alnNUiIfr@kernel.org>
References: <20220328062414.1893550-1-irogers@google.com>
 <20220328062414.1893550-4-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220328062414.1893550-4-irogers@google.com>
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

Em Sun, Mar 27, 2022 at 11:24:12PM -0700, Ian Rogers escreveu:
> The merge function gives the union of two cpu maps. Add an intersect
> function which will be used in the next change.
> 
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  tools/lib/perf/cpumap.c              | 38 ++++++++++++++++++++++++++++
>  tools/lib/perf/include/perf/cpumap.h |  2 ++
>  2 files changed, 40 insertions(+)
> 
> diff --git a/tools/lib/perf/cpumap.c b/tools/lib/perf/cpumap.c
> index 953bc50b0e41..56b4d213039f 100644
> --- a/tools/lib/perf/cpumap.c
> +++ b/tools/lib/perf/cpumap.c
> @@ -393,3 +393,41 @@ struct perf_cpu_map *perf_cpu_map__merge(struct perf_cpu_map *orig,
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

Why this put(orig)?

> +		return perf_cpu_map__get(other);

And why the get here and not on the first if?

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

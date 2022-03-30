Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93E9F4ECE1D
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 22:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351048AbiC3UgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 16:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351073AbiC3Uf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 16:35:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149112DCD;
        Wed, 30 Mar 2022 13:34:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6C38B81E45;
        Wed, 30 Mar 2022 20:34:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BCB6C340EE;
        Wed, 30 Mar 2022 20:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648672445;
        bh=hcdqaYSmSK2xXJZLV14LMkx9on5I7W9ImHA2gJ/i8S0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JWOPoKGznYgqYwkfYqPe8bAxr3mfP5Kly/Cxz8mbCMKB8G7nyc4UVSw5OYo2m4ZyH
         vO9UTy7wOXOCvzMzw4Am3snOkNnbFurqfvD4Vj+1jAb2vQp9HyvQWOd8Zo93GYAePC
         d6Qw6HfxG1q9G+4iAv8GSYY/R7AqEVIK/QXG5SNwLNVl37nsgLoaJl9W0mprbj1B6N
         h6sZYvLqqVL4sXbmOwo4uhTJmQgBT1UzlIz3q6TRwgBRGd1bXri0ZGtoHaXT9lk4yg
         6IyhQ5yDgD426wEDldEUkfLoIPoj7z85DrBNhxHvUVEbAxXEdi7dFDdlvLv8v2Y+1Y
         tLK1VsJdqlwkw==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 7FF5440407; Wed, 30 Mar 2022 17:34:02 -0300 (-03)
Date:   Wed, 30 Mar 2022 17:34:02 -0300
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
Subject: Re: [PATCH v2 3/6] perf cpumap: Add is_subset function
Message-ID: <YkS+ukZgXrn63X7f@kernel.org>
References: <20220328232648.2127340-1-irogers@google.com>
 <20220328232648.2127340-4-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220328232648.2127340-4-irogers@google.com>
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

Em Mon, Mar 28, 2022 at 04:26:45PM -0700, Ian Rogers escreveu:
> Returns true if the second argument is a subset of the first.

Thanks, applied.

- Arnaldo

 
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  tools/lib/perf/cpumap.c                  | 20 ++++++++++++++++++++
>  tools/lib/perf/include/internal/cpumap.h |  1 +
>  2 files changed, 21 insertions(+)
> 
> diff --git a/tools/lib/perf/cpumap.c b/tools/lib/perf/cpumap.c
> index ee66760f1e63..23701024e0c0 100644
> --- a/tools/lib/perf/cpumap.c
> +++ b/tools/lib/perf/cpumap.c
> @@ -319,6 +319,26 @@ struct perf_cpu perf_cpu_map__max(struct perf_cpu_map *map)
>  	return map->nr > 0 ? map->map[map->nr - 1] : result;
>  }
>  
> +/** Is 'b' a subset of 'a'. */
> +bool perf_cpu_map__is_subset(const struct perf_cpu_map *a, const struct perf_cpu_map *b)
> +{
> +	if (a == b || !b)
> +		return true;
> +	if (!a || b->nr > a->nr)
> +		return false;
> +
> +	for (int i = 0, j = 0; i < a->nr; i++) {
> +		if (a->map[i].cpu > b->map[j].cpu)
> +			return false;
> +		if (a->map[i].cpu == b->map[j].cpu) {
> +			j++;
> +			if (j == b->nr)
> +				return true;
> +		}
> +	}
> +	return false;
> +}
> +
>  /*
>   * Merge two cpumaps
>   *
> diff --git a/tools/lib/perf/include/internal/cpumap.h b/tools/lib/perf/include/internal/cpumap.h
> index 1973a18c096b..35dd29642296 100644
> --- a/tools/lib/perf/include/internal/cpumap.h
> +++ b/tools/lib/perf/include/internal/cpumap.h
> @@ -25,5 +25,6 @@ struct perf_cpu_map {
>  #endif
>  
>  int perf_cpu_map__idx(const struct perf_cpu_map *cpus, struct perf_cpu cpu);
> +bool perf_cpu_map__is_subset(const struct perf_cpu_map *a, const struct perf_cpu_map *b);
>  
>  #endif /* __LIBPERF_INTERNAL_CPUMAP_H */
> -- 
> 2.35.1.1021.g381101b075-goog

-- 

- Arnaldo

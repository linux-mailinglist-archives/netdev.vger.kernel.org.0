Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE33F4ECE21
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 22:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351021AbiC3Ugf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 16:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347659AbiC3Uge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 16:36:34 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA07E65;
        Wed, 30 Mar 2022 13:34:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C0D09CE1F29;
        Wed, 30 Mar 2022 20:34:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C794CC340EE;
        Wed, 30 Mar 2022 20:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648672485;
        bh=cBOrBvjbX97s0kggbCbKdYTRFK3sz1bC7LSgIO8grsc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZPROt6wC63wFO/BGHP1ABCT7TuYbkibFq2RV6MpbL5c9vMzeTiT4e6gA3r8GD4ljN
         hirrDByPeTXsJ6CdXW6fjhMEPXEkJ6t+I5i+bEOv5Gad2LflBiu4GPIfGA8E+eNkcS
         Mrj6ROapNmlOqG4SQgZtz0bJs9GQJK54cOlprti24ylWOk50ppDoguxJR5hXfUhWZH
         q5cNRc0d4Et4jA42SKwNqTzTaGzoXUxI1ykx4AnChMEZ16iHVZxR6Dnux+6FWsSdMR
         pfy09nvY5oT3qaEDFRyP0Zi2Db+uaYizRD5LpI+id2KG4OGwCGP6vD1bOo7EmR0dNl
         mXb7vcuaHb6mg==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 2EE5440407; Wed, 30 Mar 2022 17:34:42 -0300 (-03)
Date:   Wed, 30 Mar 2022 17:34:42 -0300
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
Subject: Re: [PATCH v2 4/6] perf cpumap: More cpu map reuse by merge.
Message-ID: <YkS+4iGPdZixhbcn@kernel.org>
References: <20220328232648.2127340-1-irogers@google.com>
 <20220328232648.2127340-5-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220328232648.2127340-5-irogers@google.com>
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

Em Mon, Mar 28, 2022 at 04:26:46PM -0700, Ian Rogers escreveu:
> perf_cpu_map__merge will reuse one of its arguments if they are equal or
> the other argument is NULL. The arguments could be reused if it is known
> one set of values is a subset of the other. For example, a map of 0-1
> and a map of just 0 when merged yields the map of 0-1. Currently a new
> map is created rather than adding a reference count to the original 0-1
> map.

Thanks, applied.

- Arnaldo

 
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  tools/lib/perf/cpumap.c | 15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/lib/perf/cpumap.c b/tools/lib/perf/cpumap.c
> index 23701024e0c0..384d5e076ee4 100644
> --- a/tools/lib/perf/cpumap.c
> +++ b/tools/lib/perf/cpumap.c
> @@ -355,17 +355,12 @@ struct perf_cpu_map *perf_cpu_map__merge(struct perf_cpu_map *orig,
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

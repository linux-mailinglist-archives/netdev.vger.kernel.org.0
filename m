Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 279E24EA191
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 22:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344567AbiC1UgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 16:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346274AbiC1UeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 16:34:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE6232EF8;
        Mon, 28 Mar 2022 13:32:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A86D6149E;
        Mon, 28 Mar 2022 20:32:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60CA1C340ED;
        Mon, 28 Mar 2022 20:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648499554;
        bh=8+UTYWbVLgOBzCkQVECx2w9eUsJDkRhc8E5Y1Jz2ip0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sPy/YTXkdJdSZVHLGbJfXwU8C0JLpFaTNvtev8+HV1HOtIxVNXr8isggfrPXodslo
         d5/r7Zn4lLeWOpZWcd6/rk9M00q9O4CdS79sdqlXOUUii20ZrQfqN71rPcBUHIPlXt
         /rEBLI07rQO8OI0qPBNmerM0KlAC0VQ41Z3LCJPahzAQtSjhlJAHJWqJ3PmGy4EGLn
         zoqohpSev54HbH7NZ3SaAfInKtZs3xSf7/XehKqj/XFM4yzbMcF4aWogKMRHdcrsdC
         6Lwvr77bWO60aTj9DzWNDIyoBLUkno0z6EB7mdF7+Lxdk/b0X7KepLA0XELxwUDTAR
         twPi+mbwai4Mw==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 3A55E40407; Mon, 28 Mar 2022 17:32:31 -0300 (-03)
Date:   Mon, 28 Mar 2022 17:32:31 -0300
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
Subject: Re: [PATCH 4/5] perf stat: Avoid segv if core.user_cpus isn't set.
Message-ID: <YkIbXzCYEutqxQRE@kernel.org>
References: <20220328062414.1893550-1-irogers@google.com>
 <20220328062414.1893550-5-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220328062414.1893550-5-irogers@google.com>
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

Em Sun, Mar 27, 2022 at 11:24:13PM -0700, Ian Rogers escreveu:
> Passing null to perf_cpu_map__max doesn't make sense as there is no
> valid max. Avoid this problem by null checking in
> perf_stat_init_aggr_mode.

Applying this one after changing user_cpus back to cpus as this is a fix
independent of this patchset.

In the future, please try to have such patches at the beginning of the
series, so that  they can get cherry-picked more easily.

- Arnaldo
 
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  tools/perf/builtin-stat.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> index 5bee529f7656..ecd5cf4fd872 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -1472,7 +1472,10 @@ static int perf_stat_init_aggr_mode(void)
>  	 * taking the highest cpu number to be the size of
>  	 * the aggregation translate cpumap.
>  	 */
> -	nr = perf_cpu_map__max(evsel_list->core.user_cpus).cpu;
> +	if (evsel_list->core.user_cpus)
> +		nr = perf_cpu_map__max(evsel_list->core.user_cpus).cpu;
> +	else
> +		nr = 0;
>  	stat_config.cpus_aggr_map = cpu_aggr_map__empty_new(nr + 1);
>  	return stat_config.cpus_aggr_map ? 0 : -ENOMEM;
>  }
> -- 
> 2.35.1.1021.g381101b075-goog

-- 

- Arnaldo

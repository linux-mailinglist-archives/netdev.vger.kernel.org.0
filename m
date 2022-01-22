Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC837496DF5
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 21:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbiAVURf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 15:17:35 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35740 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbiAVURd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 15:17:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2619AB80AD5;
        Sat, 22 Jan 2022 20:17:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9607C004E1;
        Sat, 22 Jan 2022 20:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642882650;
        bh=J49R2Ueqf4nuK+xxyfVIPpTu+GvFrG1lLmORfkLqfgE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AYVLHEkPhPmNjfNUkIa/WY8xuCgtPqUcbM3FmpVeL7K9RlgaA2bY9N+CfQ4JYY1wy
         pBbyjfDm8ceLSWYyBWCbQ0IlFJChZI6m6hYc/y5D66cSO70WytDVlEInvZXyMK3wL2
         o970bc56t/Y4ZvxTXQcqEdW76gmT9I4T//6VeVH1iPbbKgVxNflFa7PhIJZRn+DdZf
         4u5k/J7Zpm2GzcUEk1QKfKO3m9xxBjkm6h/066t+eAGUuM4PlH4zeKIl68R1lXbCML
         wMiLybZMNI+zIlMtIlhn5ISjFAgNEabm0H9vfOmWHUowZUSCH+P3EvO1D3eIQFjbzD
         mDYVrHIM/+Ykw==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 212CA40D20; Sat, 22 Jan 2022 17:15:29 -0300 (-03)
Date:   Sat, 22 Jan 2022 17:15:29 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     German Gomez <german.gomez@arm.com>
Cc:     linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Chase Conklin <chase.conklin@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Ian Rogers <irogers@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH v2] perf record/arm-spe: Override attr->sample_period for
 non-libpfm4 events
Message-ID: <Yexl4R5qsyi9sEQf@kernel.org>
References: <20220118144054.2541-1-german.gomez@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220118144054.2541-1-german.gomez@arm.com>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Tue, Jan 18, 2022 at 02:40:54PM +0000, German Gomez escreveu:
> A previous patch preventing "attr->sample_period" values from being
> overridden in pfm events changed a related behaviour in arm-spe.
> 
> Before said patch:
> perf record -c 10000 -e arm_spe_0// -- sleep 1
> 
> Would yield an SPE event with period=10000. After the patch, the period
> in "-c 10000" was being ignored because the arm-spe code initializes
> sample_period to a non-zero value.
> 
> This patch restores the previous behaviour for non-libpfm4 events.
> 
> Reported-by: Chase Conklin <chase.conklin@arm.com>
> Fixes: ae5dcc8abe31 (“perf record: Prevent override of attr->sample_period for libpfm4 events”)
> Signed-off-by: German Gomez <german.gomez@arm.com>
> ---
> As suggested by Arnaldo, this v2 doesn't include a test in order to not
> block this fix for longer than necessary. So the test can be sent as a
> separate submission later.

Got it, will apply.
 
> Changes since v1.
>  - Update commit message (James Clark)
> ---
>  tools/perf/util/evsel.c | 25 +++++++++++++++++--------
>  1 file changed, 17 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index a59fb2ecb84e..86ab038f020f 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -1065,6 +1065,17 @@ void __weak arch_evsel__fixup_new_cycles(struct perf_event_attr *attr __maybe_un
>  {
>  }
>  
> +static void evsel__set_default_freq_period(struct record_opts *opts,
> +					   struct perf_event_attr *attr)
> +{
> +	if (opts->freq) {
> +		attr->freq = 1;
> +		attr->sample_freq = opts->freq;
> +	} else {
> +		attr->sample_period = opts->default_interval;
> +	}
> +}
> +
>  /*
>   * The enable_on_exec/disabled value strategy:
>   *
> @@ -1131,14 +1142,12 @@ void evsel__config(struct evsel *evsel, struct record_opts *opts,
>  	 * We default some events to have a default interval. But keep
>  	 * it a weak assumption overridable by the user.
>  	 */
> -	if (!attr->sample_period) {
> -		if (opts->freq) {
> -			attr->freq		= 1;
> -			attr->sample_freq	= opts->freq;
> -		} else {
> -			attr->sample_period = opts->default_interval;
> -		}
> -	}
> +	if ((evsel->is_libpfm_event && !attr->sample_period) ||
> +	    (!evsel->is_libpfm_event && (!attr->sample_period ||
> +					 opts->user_freq != UINT_MAX ||
> +					 opts->user_interval != ULLONG_MAX)))
> +		evsel__set_default_freq_period(opts, attr);
> +
>  	/*
>  	 * If attr->freq was set (here or earlier), ask for period
>  	 * to be sampled.
> -- 
> 2.25.1

-- 

- Arnaldo

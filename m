Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 862112324E7
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 20:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgG2SwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 14:52:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:50252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726365AbgG2SwP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 14:52:15 -0400
Received: from quaco.ghostprotocols.net (unknown [179.97.37.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 046D72075D;
        Wed, 29 Jul 2020 18:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596048735;
        bh=X2GAMQ3RIXB69rXlNng75zFV3IhgrTburC3Gs/D1yUo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0qquShLGWf9uf/R0aFWS6yJCF4oe+DjfWxvCgVH5a4PxSbv6kinVZ2bPUcuDqE2Ef
         3xmCYVUvr0b5f4uYukyQnmx6lbnT4J0Yz6EnWT7t8uEQkVCPZTiyweyFVyM0P40cyw
         n0kY0p72PSwig5blFpb/EI4z2cZS7P/bN8V8n3j0=
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 0661340E57; Wed, 29 Jul 2020 15:52:13 -0300 (-03)
Date:   Wed, 29 Jul 2020 15:52:12 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ian Rogers <irogers@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        David Sharp <dhsharp@google.com>
Subject: Re: [PATCH v2 1/5] perf record: Set PERF_RECORD_PERIOD if attr->freq
 is set.
Message-ID: <20200729185212.GB433799@kernel.org>
References: <20200728085734.609930-1-irogers@google.com>
 <20200728085734.609930-2-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728085734.609930-2-irogers@google.com>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Tue, Jul 28, 2020 at 01:57:30AM -0700, Ian Rogers escreveu:
> From: David Sharp <dhsharp@google.com>
> 
> evsel__config() would only set PERF_RECORD_PERIOD if it set attr->freq

There is no such thing as 'PERF_RECORD_PERIOD', its PERF_SAMPLE_PERIOD,
also...

> from perf record options. When it is set by libpfm events, it would not
> get set. This changes evsel__config to see if attr->freq is set outside of
> whether or not it changes attr->freq itself.
> 
> Signed-off-by: David Sharp <dhsharp@google.com>
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  tools/perf/util/evsel.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index ef802f6d40c1..811f538f7d77 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -979,13 +979,18 @@ void evsel__config(struct evsel *evsel, struct record_opts *opts,
>  	if (!attr->sample_period || (opts->user_freq != UINT_MAX ||
>  				     opts->user_interval != ULLONG_MAX)) {
>  		if (opts->freq) {
> -			evsel__set_sample_bit(evsel, PERIOD);
>  			attr->freq		= 1;
>  			attr->sample_freq	= opts->freq;
>  		} else {
>  			attr->sample_period = opts->default_interval;
>  		}
>  	}
> +	/*
> +	 * If attr->freq was set (here or earlier), ask for period
> +	 * to be sampled.
> +	 */
> +	if (attr->freq)
> +		evsel__set_sample_bit(evsel, PERIOD);

Why can't the libpfm code set opts?

With this patch we will end up calling evsel__set_sample_bit(evsel,
PERIOD) twice, which isn't a problem but looks strange.

- Arnaldo

>  
>  	if (opts->no_samples)
>  		attr->sample_freq = 0;
> -- 
> 2.28.0.163.g6104cc2f0b6-goog
> 

-- 

- Arnaldo

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1CD26983C
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 23:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbgINVrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 17:47:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726020AbgINVq6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 17:46:58 -0400
Received: from quaco.ghostprotocols.net (unknown [179.97.37.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A8BE208DB;
        Mon, 14 Sep 2020 21:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600120017;
        bh=/Pbh7AFCaCoqEJpG+EEJ8uVxBFloGWJRBIt5siAgkTE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tx7rXHzgsTlKduKMD5j1zQC6huHfk4dEbx74U7jjMEQBGIOaf8SNVKZ18ruEd6udp
         LvSzR1z8vHq0bbXxHR/sKuijZ5lqL+g8JD22RgZpi/PtfTVXJtr4/+JUlpFgiQD0PO
         bc0FJkgIRYZ75hOzH427wLPrAU3jT6fuvCTBhifg=
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 1E72140D3D; Mon, 14 Sep 2020 18:46:55 -0300 (-03)
Date:   Mon, 14 Sep 2020 18:46:55 -0300
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
        bpf@vger.kernel.org, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v3 3/4] perf record: Don't clear event's period if set by
 a term
Message-ID: <20200914214655.GE166601@kernel.org>
References: <20200912025655.1337192-1-irogers@google.com>
 <20200912025655.1337192-4-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200912025655.1337192-4-irogers@google.com>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, Sep 11, 2020 at 07:56:54PM -0700, Ian Rogers escreveu:
> If events in a group explicitly set a frequency or period with leader
> sampling, don't disable the samples on those events.
> 
> Prior to 5.8:
> perf record -e '{cycles/period=12345000/,instructions/period=6789000/}:S'
> would clear the attributes then apply the config terms. In commit
> 5f34278867b7 leader sampling configuration was moved to after applying the
> config terms, in the example, making the instructions' event have its period
> cleared.
> This change makes it so that sampling is only disabled if configuration
> terms aren't present.

Adrian, Jiri, can you please take a look a this and provide Reviewed-by
or Acked-by tags?

- Arnaldo
 
> Fixes: 5f34278867b7 ("perf evlist: Move leader-sampling configuration")
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  tools/perf/util/record.c | 34 ++++++++++++++++++++++++++--------
>  1 file changed, 26 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
> index a4cc11592f6b..ea9aa1d7cf50 100644
> --- a/tools/perf/util/record.c
> +++ b/tools/perf/util/record.c
> @@ -2,6 +2,7 @@
>  #include "debug.h"
>  #include "evlist.h"
>  #include "evsel.h"
> +#include "evsel_config.h"
>  #include "parse-events.h"
>  #include <errno.h>
>  #include <limits.h>
> @@ -33,11 +34,24 @@ static struct evsel *evsel__read_sampler(struct evsel *evsel, struct evlist *evl
>  	return leader;
>  }
>  
> +static u64 evsel__config_term_mask(struct evsel *evsel)
> +{
> +	struct evsel_config_term *term;
> +	struct list_head *config_terms = &evsel->config_terms;
> +	u64 term_types = 0;
> +
> +	list_for_each_entry(term, config_terms, list) {
> +		term_types |= 1 << term->type;
> +	}
> +	return term_types;
> +}
> +
>  static void evsel__config_leader_sampling(struct evsel *evsel, struct evlist *evlist)
>  {
>  	struct perf_event_attr *attr = &evsel->core.attr;
>  	struct evsel *leader = evsel->leader;
>  	struct evsel *read_sampler;
> +	u64 term_types, freq_mask;
>  
>  	if (!leader->sample_read)
>  		return;
> @@ -47,16 +61,20 @@ static void evsel__config_leader_sampling(struct evsel *evsel, struct evlist *ev
>  	if (evsel == read_sampler)
>  		return;
>  
> +	term_types = evsel__config_term_mask(evsel);
>  	/*
> -	 * Disable sampling for all group members other than the leader in
> -	 * case the leader 'leads' the sampling, except when the leader is an
> -	 * AUX area event, in which case the 2nd event in the group is the one
> -	 * that 'leads' the sampling.
> +	 * Disable sampling for all group members except those with explicit
> +	 * config terms or the leader. In the case of an AUX area event, the 2nd
> +	 * event in the group is the one that 'leads' the sampling.
>  	 */
> -	attr->freq           = 0;
> -	attr->sample_freq    = 0;
> -	attr->sample_period  = 0;
> -	attr->write_backward = 0;
> +	freq_mask = (1 << EVSEL__CONFIG_TERM_FREQ) | (1 << EVSEL__CONFIG_TERM_PERIOD);
> +	if ((term_types & freq_mask) == 0) {
> +		attr->freq           = 0;
> +		attr->sample_freq    = 0;
> +		attr->sample_period  = 0;
> +	}
> +	if ((term_types & (1 << EVSEL__CONFIG_TERM_OVERWRITE)) == 0)
> +		attr->write_backward = 0;
>  
>  	/*
>  	 * We don't get a sample for slave events, we make them when delivering
> -- 
> 2.28.0.618.gf4bc123cb7-goog
> 

-- 

- Arnaldo

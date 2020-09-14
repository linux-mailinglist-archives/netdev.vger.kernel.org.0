Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7317268455
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 08:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726056AbgINGDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 02:03:06 -0400
Received: from mga07.intel.com ([134.134.136.100]:35134 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbgINGDE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 02:03:04 -0400
IronPort-SDR: ZymWsi7tSIW8J9lotooGdL3gS3WpV+CounimYwMiNpzjr0tDhfDlIbGO7y7Vov0E8lpVrvpw5N
 NnbZtMTPTrlA==
X-IronPort-AV: E=McAfee;i="6000,8403,9743"; a="223214512"
X-IronPort-AV: E=Sophos;i="5.76,425,1592895600"; 
   d="scan'208";a="223214512"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2020 23:03:03 -0700
IronPort-SDR: zey0M9isQqH0xC6ieLbbbLgjVGRIAT/8GkiaH+6aqeNm4ekl5glxB45rsLM1pPyXWG+pVTgA8v
 YKLzZmNnCAkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,425,1592895600"; 
   d="scan'208";a="408764517"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.190]) ([10.237.72.190])
  by fmsmga001.fm.intel.com with ESMTP; 13 Sep 2020 23:02:58 -0700
Subject: Re: [PATCH v3 3/4] perf record: Don't clear event's period if set by
 a term
To:     Ian Rogers <irogers@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
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
        Andi Kleen <ak@linux.intel.com>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     Stephane Eranian <eranian@google.com>
References: <20200912025655.1337192-1-irogers@google.com>
 <20200912025655.1337192-4-irogers@google.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <77df85d3-a50c-d6aa-1d60-4fc9ea90dc44@intel.com>
Date:   Mon, 14 Sep 2020 09:02:32 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200912025655.1337192-4-irogers@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/09/20 5:56 am, Ian Rogers wrote:
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
> 
> Fixes: 5f34278867b7 ("perf evlist: Move leader-sampling configuration")
> Signed-off-by: Ian Rogers <irogers@google.com>

Acked-by: Adrian Hunter <adrian.hunter@intel.com>

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
> 


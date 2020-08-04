Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F78623B87B
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 12:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730084AbgHDKIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 06:08:38 -0400
Received: from mga05.intel.com ([192.55.52.43]:27813 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728311AbgHDKIg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Aug 2020 06:08:36 -0400
IronPort-SDR: YvfCLoP76/WchcUK3mqhku/G18fwOtBbKndIzu9cGfE2Tv9YEVQlIyKxwliQciIsMQyaxGX3S7
 GUoSADAQWhsQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9702"; a="237144713"
X-IronPort-AV: E=Sophos;i="5.75,433,1589266800"; 
   d="scan'208";a="237144713"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2020 03:08:36 -0700
IronPort-SDR: be8eyJZeFVeLLnafcVjQTCVfiLuUnKwBuaLmEDk1u04eTWawCpv5/52FWWS2iMAhRKLRXbDhhy
 lKz17Fe5ktQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,433,1589266800"; 
   d="scan'208";a="330557050"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.73]) ([10.237.72.73])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Aug 2020 03:08:31 -0700
Subject: Re: [PATCH v2 4/5] perf record: Don't clear event's period if set by
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
References: <20200728085734.609930-1-irogers@google.com>
 <20200728085734.609930-5-irogers@google.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <969ef797-59ea-69d0-24b9-33bcdff106a1@intel.com>
Date:   Tue, 4 Aug 2020 13:08:07 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200728085734.609930-5-irogers@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/07/20 11:57 am, Ian Rogers wrote:
> If events in a group explicitly set a frequency or period with leader
> sampling, don't disable the samples on those events.
> 
> Prior to 5.8:
> perf record -e '{cycles/period=12345000/,instructions/period=6789000/}:S'

Might be worth explaining this use-case some more.
Perhaps add it to the leader sampling documentation for perf-list.

> would clear the attributes then apply the config terms. In commit
> 5f34278867b7 leader sampling configuration was moved to after applying the
> config terms, in the example, making the instructions' event have its period
> cleared.
> This change makes it so that sampling is only disabled if configuration
> terms aren't present.
> 
> Fixes: 5f34278867b7 ("perf evlist: Move leader-sampling configuration")
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  tools/perf/util/record.c | 28 ++++++++++++++++++++--------
>  1 file changed, 20 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
> index a4cc11592f6b..01d1c6c613f7 100644
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
> @@ -38,6 +39,9 @@ static void evsel__config_leader_sampling(struct evsel *evsel, struct evlist *ev
>  	struct perf_event_attr *attr = &evsel->core.attr;
>  	struct evsel *leader = evsel->leader;
>  	struct evsel *read_sampler;
> +	struct evsel_config_term *term;
> +	struct list_head *config_terms = &evsel->config_terms;
> +	int term_types, freq_mask;
>  
>  	if (!leader->sample_read)
>  		return;
> @@ -47,16 +51,24 @@ static void evsel__config_leader_sampling(struct evsel *evsel, struct evlist *ev
>  	if (evsel == read_sampler)
>  		return;
>  
> +	/* Determine the evsel's config term types. */
> +	term_types = 0;
> +	list_for_each_entry(term, config_terms, list) {
> +		term_types |= 1 << term->type;
> +	}
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

It would be nicer to have a helper e.g.

	if (!evsel__have_config_term(evsel, FREQ) &&
	    !evsel__have_config_term(evsel, PERIOD)) {

> +		attr->freq           = 0;
> +		attr->sample_freq    = 0;
> +		attr->sample_period  = 0;

If we are not sampling, then maybe we should also put here:

		attr->write_backward = 0;

> +	}

Then, if we are sampling this evsel shouldn't the backward setting
match the leader? e.g.

	if (attr->sample_freq)
		attr->write_backward = leader->core.attr.write_backward;


> +	if ((term_types & (1 << EVSEL__CONFIG_TERM_OVERWRITE)) == 0)
> +		attr->write_backward = 0;
>  
>  	/*
>  	 * We don't get a sample for slave events, we make them when delivering
> 


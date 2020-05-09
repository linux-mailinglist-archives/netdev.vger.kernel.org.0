Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1EA1CBBBB
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 02:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbgEIAQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 20:16:56 -0400
Received: from mga04.intel.com ([192.55.52.120]:1833 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727959AbgEIAQz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 20:16:55 -0400
IronPort-SDR: jGHGrdazT7A2jbDDycBetioIa1peGwCbqQnn4BGS63ByC6AY5wBC9CNM9gFhqkgUe5EdsG+0aF
 y56vzQ716gkA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2020 17:14:53 -0700
IronPort-SDR: UPdB6mXq9jZJRJkM/eTWC6pCGxhBeWdNAvVrJ9xXbpNSboRtDFExvWMGHNHwl0Rk4pY+naIWxf
 xNVMfrOfdL9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,369,1583222400"; 
   d="scan'208";a="297110810"
Received: from tassilo.jf.intel.com (HELO tassilo.localdomain) ([10.7.201.21])
  by orsmga008.jf.intel.com with ESMTP; 08 May 2020 17:14:53 -0700
Received: by tassilo.localdomain (Postfix, from userid 1000)
        id 1F249301C4C; Fri,  8 May 2020 17:14:51 -0700 (PDT)
Date:   Fri, 8 May 2020 17:14:51 -0700
From:   Andi Kleen <ak@linux.intel.com>
To:     Ian Rogers <irogers@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
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
        Kajol Jain <kjain@linux.ibm.com>,
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Vince Weaver <vincent.weaver@maine.edu>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [RFC PATCH v3 01/14] perf parse-events: expand add PMU
 error/verbose messages
Message-ID: <20200509001451.GE3538@tassilo.jf.intel.com>
References: <20200508053629.210324-1-irogers@google.com>
 <20200508053629.210324-2-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508053629.210324-2-irogers@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


This seems like a independent bug fix and should probably
be pushed independently of the rest.

Perhaps add a Fixes: tag.

Reviewed-by: Andi Kleen <ak@linux.inte.com>

On Thu, May 07, 2020 at 10:36:16PM -0700, Ian Rogers wrote:
> On a CPU like skylakex an uncore_iio_0 PMU may alias with
> uncore_iio_free_running_0. The latter PMU doesn't support fc_mask
> as a parameter and so pmu_config_term fails. Typically
> parse_events_add_pmu is called in a loop where if one alias succeeds
> errors are ignored, however, if multiple errors occur
> parse_events__handle_error will currently give a WARN_ONCE.
> 
> This change removes the WARN_ONCE in parse_events__handle_error and
> makes it a pr_debug. It adds verbose messages to parse_events_add_pmu
> warning that non-fatal errors may occur, while giving details on the pmu
> and config terms for useful context. pmu_config_term is altered so the
> failing term and pmu are present in the case of the 'unknown term'
> error which makes spotting the free_running case more straightforward.
> 
> Before:
> $ perf --debug verbose=3 stat -M llc_misses.pcie_read sleep 1
> Using CPUID GenuineIntel-6-55-4
> metric expr unc_iio_data_req_of_cpu.mem_read.part0 + unc_iio_data_req_of_cpu.mem_read.part1 + unc_iio_data_req_of_cpu.mem_read.part2 + unc_iio_data_req_of_cpu.mem_read.part3 for LLC_MISSES.PCIE_READ
> found event unc_iio_data_req_of_cpu.mem_read.part0
> found event unc_iio_data_req_of_cpu.mem_read.part1
> found event unc_iio_data_req_of_cpu.mem_read.part2
> found event unc_iio_data_req_of_cpu.mem_read.part3
> metric expr unc_iio_data_req_of_cpu.mem_read.part0 + unc_iio_data_req_of_cpu.mem_read.part1 + unc_iio_data_req_of_cpu.mem_read.part2 + unc_iio_data_req_of_cpu.mem_read.part3 for LLC_MISSES.PCIE_READ
> found event unc_iio_data_req_of_cpu.mem_read.part0
> found event unc_iio_data_req_of_cpu.mem_read.part1
> found event unc_iio_data_req_of_cpu.mem_read.part2
> found event unc_iio_data_req_of_cpu.mem_read.part3
> adding {unc_iio_data_req_of_cpu.mem_read.part0,unc_iio_data_req_of_cpu.mem_read.part1,unc_iio_data_req_of_cpu.mem_read.part2,unc_iio_data_req_of_cpu.mem_read.part3}:W,{unc_iio_data_req_of_cpu.mem_read.part0,unc_iio_data_req_of_cpu.mem_read.part1,unc_iio_data_req_of_cpu.mem_read.part2,unc_iio_data_req_of_cpu.mem_read.part3}:W
> intel_pt default config: tsc,mtc,mtc_period=3,psb_period=3,pt,branch
> WARNING: multiple event parsing errors
> ...
> Invalid event/parameter 'fc_mask'
> ...
> 
> After:
> $ perf --debug verbose=3 stat -M llc_misses.pcie_read sleep 1
> Using CPUID GenuineIntel-6-55-4
> metric expr unc_iio_data_req_of_cpu.mem_read.part0 + unc_iio_data_req_of_cpu.mem_read.part1 + unc_iio_data_req_of_cpu.mem_read.part2 + unc_iio_data_req_of_cpu.mem_read.part3 for LLC_MISSES.PCIE_READ
> found event unc_iio_data_req_of_cpu.mem_read.part0
> found event unc_iio_data_req_of_cpu.mem_read.part1
> found event unc_iio_data_req_of_cpu.mem_read.part2
> found event unc_iio_data_req_of_cpu.mem_read.part3
> metric expr unc_iio_data_req_of_cpu.mem_read.part0 + unc_iio_data_req_of_cpu.mem_read.part1 + unc_iio_data_req_of_cpu.mem_read.part2 + unc_iio_data_req_of_cpu.mem_read.part3 for LLC_MISSES.PCIE_READ
> found event unc_iio_data_req_of_cpu.mem_read.part0
> found event unc_iio_data_req_of_cpu.mem_read.part1
> found event unc_iio_data_req_of_cpu.mem_read.part2
> found event unc_iio_data_req_of_cpu.mem_read.part3
> adding {unc_iio_data_req_of_cpu.mem_read.part0,unc_iio_data_req_of_cpu.mem_read.part1,unc_iio_data_req_of_cpu.mem_read.part2,unc_iio_data_req_of_cpu.mem_read.part3}:W,{unc_iio_data_req_of_cpu.mem_read.part0,unc_iio_data_req_of_cpu.mem_read.part1,unc_iio_data_req_of_cpu.mem_read.part2,unc_iio_data_req_of_cpu.mem_read.part3}:W
> intel_pt default config: tsc,mtc,mtc_period=3,psb_period=3,pt,branch
> Attempting to add event pmu 'uncore_iio_free_running_5' with 'unc_iio_data_req_of_cpu.mem_read.part0,' that may result in non-fatal errors
> After aliases, add event pmu 'uncore_iio_free_running_5' with 'fc_mask,ch_mask,umask,event,' that may result in non-fatal errors
> Attempting to add event pmu 'uncore_iio_free_running_3' with 'unc_iio_data_req_of_cpu.mem_read.part0,' that may result in non-fatal errors
> After aliases, add event pmu 'uncore_iio_free_running_3' with 'fc_mask,ch_mask,umask,event,' that may result in non-fatal errors
> Attempting to add event pmu 'uncore_iio_free_running_1' with 'unc_iio_data_req_of_cpu.mem_read.part0,' that may result in non-fatal errors
> After aliases, add event pmu 'uncore_iio_free_running_1' with 'fc_mask,ch_mask,umask,event,' that may result in non-fatal errors
> Multiple errors dropping message: unknown term 'fc_mask' for pmu 'uncore_iio_free_running_3' (valid terms: event,umask,config,config1,config2,name,period,percore)
> ...
> 
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  tools/perf/arch/x86/util/intel-pt.c | 32 +++++++++++++++++-----------
>  tools/perf/tests/pmu.c              |  4 ++--
>  tools/perf/util/parse-events.c      | 29 ++++++++++++++++++++++++-
>  tools/perf/util/pmu.c               | 33 ++++++++++++++++++-----------
>  tools/perf/util/pmu.h               |  2 +-
>  5 files changed, 72 insertions(+), 28 deletions(-)
> 
> diff --git a/tools/perf/arch/x86/util/intel-pt.c b/tools/perf/arch/x86/util/intel-pt.c
> index fd9e22d1e366..0fe401ad3347 100644
> --- a/tools/perf/arch/x86/util/intel-pt.c
> +++ b/tools/perf/arch/x86/util/intel-pt.c
> @@ -59,7 +59,8 @@ struct intel_pt_recording {
>  	size_t				priv_size;
>  };
>  
> -static int intel_pt_parse_terms_with_default(struct list_head *formats,
> +static int intel_pt_parse_terms_with_default(const char *pmu_name,
> +					     struct list_head *formats,
>  					     const char *str,
>  					     u64 *config)
>  {
> @@ -78,7 +79,8 @@ static int intel_pt_parse_terms_with_default(struct list_head *formats,
>  		goto out_free;
>  
>  	attr.config = *config;
> -	err = perf_pmu__config_terms(formats, &attr, terms, true, NULL);
> +	err = perf_pmu__config_terms(pmu_name, formats, &attr, terms, true,
> +				     NULL);
>  	if (err)
>  		goto out_free;
>  
> @@ -88,11 +90,12 @@ static int intel_pt_parse_terms_with_default(struct list_head *formats,
>  	return err;
>  }
>  
> -static int intel_pt_parse_terms(struct list_head *formats, const char *str,
> -				u64 *config)
> +static int intel_pt_parse_terms(const char *pmu_name, struct list_head *formats,
> +				const char *str, u64 *config)
>  {
>  	*config = 0;
> -	return intel_pt_parse_terms_with_default(formats, str, config);
> +	return intel_pt_parse_terms_with_default(pmu_name, formats, str,
> +						 config);
>  }
>  
>  static u64 intel_pt_masked_bits(u64 mask, u64 bits)
> @@ -229,7 +232,8 @@ static u64 intel_pt_default_config(struct perf_pmu *intel_pt_pmu)
>  
>  	pr_debug2("%s default config: %s\n", intel_pt_pmu->name, buf);
>  
> -	intel_pt_parse_terms(&intel_pt_pmu->format, buf, &config);
> +	intel_pt_parse_terms(intel_pt_pmu->name, &intel_pt_pmu->format, buf,
> +			     &config);
>  
>  	return config;
>  }
> @@ -337,13 +341,16 @@ static int intel_pt_info_fill(struct auxtrace_record *itr,
>  	if (priv_size != ptr->priv_size)
>  		return -EINVAL;
>  
> -	intel_pt_parse_terms(&intel_pt_pmu->format, "tsc", &tsc_bit);
> -	intel_pt_parse_terms(&intel_pt_pmu->format, "noretcomp",
> -			     &noretcomp_bit);
> -	intel_pt_parse_terms(&intel_pt_pmu->format, "mtc", &mtc_bit);
> +	intel_pt_parse_terms(intel_pt_pmu->name, &intel_pt_pmu->format,
> +			     "tsc", &tsc_bit);
> +	intel_pt_parse_terms(intel_pt_pmu->name, &intel_pt_pmu->format,
> +			     "noretcomp", &noretcomp_bit);
> +	intel_pt_parse_terms(intel_pt_pmu->name, &intel_pt_pmu->format,
> +			     "mtc", &mtc_bit);
>  	mtc_freq_bits = perf_pmu__format_bits(&intel_pt_pmu->format,
>  					      "mtc_period");
> -	intel_pt_parse_terms(&intel_pt_pmu->format, "cyc", &cyc_bit);
> +	intel_pt_parse_terms(intel_pt_pmu->name, &intel_pt_pmu->format,
> +			     "cyc", &cyc_bit);
>  
>  	intel_pt_tsc_ctc_ratio(&tsc_ctc_ratio_n, &tsc_ctc_ratio_d);
>  
> @@ -768,7 +775,8 @@ static int intel_pt_recording_options(struct auxtrace_record *itr,
>  		}
>  	}
>  
> -	intel_pt_parse_terms(&intel_pt_pmu->format, "tsc", &tsc_bit);
> +	intel_pt_parse_terms(intel_pt_pmu->name, &intel_pt_pmu->format,
> +			     "tsc", &tsc_bit);
>  
>  	if (opts->full_auxtrace && (intel_pt_evsel->core.attr.config & tsc_bit))
>  		have_timing_info = true;
> diff --git a/tools/perf/tests/pmu.c b/tools/perf/tests/pmu.c
> index 74379ff1f7fa..5c11fe2b3040 100644
> --- a/tools/perf/tests/pmu.c
> +++ b/tools/perf/tests/pmu.c
> @@ -156,8 +156,8 @@ int test__pmu(struct test *test __maybe_unused, int subtest __maybe_unused)
>  		if (ret)
>  			break;
>  
> -		ret = perf_pmu__config_terms(&formats, &attr, terms,
> -					     false, NULL);
> +		ret = perf_pmu__config_terms("perf-pmu-test", &formats, &attr,
> +					     terms, false, NULL);
>  		if (ret)
>  			break;
>  
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index e9464b04f149..0ebc0fd9385a 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -204,7 +204,8 @@ void parse_events__handle_error(struct parse_events_error *err, int idx,
>  		err->help = help;
>  		break;
>  	default:
> -		WARN_ONCE(1, "WARNING: multiple event parsing errors\n");
> +		pr_debug("Multiple errors dropping message: %s (%s)\n",
> +			err->str, err->help);
>  		free(err->str);
>  		err->str = str;
>  		free(err->help);
> @@ -1422,6 +1423,19 @@ int parse_events_add_pmu(struct parse_events_state *parse_state,
>  	bool use_uncore_alias;
>  	LIST_HEAD(config_terms);
>  
> +	if (verbose > 1) {
> +		fprintf(stderr, "Attempting to add event pmu '%s' with '",
> +			name);
> +		if (head_config) {
> +			struct parse_events_term *term;
> +
> +			list_for_each_entry(term, head_config, list) {
> +				fprintf(stderr, "%s,", term->config);
> +			}
> +		}
> +		fprintf(stderr, "' that may result in non-fatal errors\n");
> +	}
> +
>  	pmu = perf_pmu__find(name);
>  	if (!pmu) {
>  		char *err_str;
> @@ -1458,6 +1472,19 @@ int parse_events_add_pmu(struct parse_events_state *parse_state,
>  	if (perf_pmu__check_alias(pmu, head_config, &info))
>  		return -EINVAL;
>  
> +	if (verbose > 1) {
> +		fprintf(stderr, "After aliases, add event pmu '%s' with '",
> +			name);
> +		if (head_config) {
> +			struct parse_events_term *term;
> +
> +			list_for_each_entry(term, head_config, list) {
> +				fprintf(stderr, "%s,", term->config);
> +			}
> +		}
> +		fprintf(stderr, "' that may result in non-fatal errors\n");
> +	}
> +
>  	/*
>  	 * Configure hardcoded terms first, no need to check
>  	 * return value when called with fail == 0 ;)
> diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
> index 92bd7fafcce6..71d0290b616a 100644
> --- a/tools/perf/util/pmu.c
> +++ b/tools/perf/util/pmu.c
> @@ -1056,7 +1056,8 @@ static char *pmu_formats_string(struct list_head *formats)
>   * Setup one of config[12] attr members based on the
>   * user input data - term parameter.
>   */
> -static int pmu_config_term(struct list_head *formats,
> +static int pmu_config_term(const char *pmu_name,
> +			   struct list_head *formats,
>  			   struct perf_event_attr *attr,
>  			   struct parse_events_term *term,
>  			   struct list_head *head_terms,
> @@ -1082,16 +1083,24 @@ static int pmu_config_term(struct list_head *formats,
>  
>  	format = pmu_find_format(formats, term->config);
>  	if (!format) {
> -		if (verbose > 0)
> -			printf("Invalid event/parameter '%s'\n", term->config);
> +		char *pmu_term = pmu_formats_string(formats);
> +		char *unknown_term;
> +		char *help_msg;
> +
> +		if (asprintf(&unknown_term,
> +				"unknown term '%s' for pmu '%s'",
> +				term->config, pmu_name) < 0)
> +			unknown_term = strdup("unknown term");
> +		help_msg = parse_events_formats_error_string(pmu_term);
>  		if (err) {
> -			char *pmu_term = pmu_formats_string(formats);
> -
>  			parse_events__handle_error(err, term->err_term,
> -				strdup("unknown term"),
> -				parse_events_formats_error_string(pmu_term));
> -			free(pmu_term);
> +						   unknown_term,
> +						   help_msg);
> +		} else {
> +			pr_debug("%s (%s)\n", unknown_term, help_msg);
> +			free(unknown_term);
>  		}
> +		free(pmu_term);
>  		return -EINVAL;
>  	}
>  
> @@ -1168,7 +1177,7 @@ static int pmu_config_term(struct list_head *formats,
>  	return 0;
>  }
>  
> -int perf_pmu__config_terms(struct list_head *formats,
> +int perf_pmu__config_terms(const char *pmu_name, struct list_head *formats,
>  			   struct perf_event_attr *attr,
>  			   struct list_head *head_terms,
>  			   bool zero, struct parse_events_error *err)
> @@ -1176,7 +1185,7 @@ int perf_pmu__config_terms(struct list_head *formats,
>  	struct parse_events_term *term;
>  
>  	list_for_each_entry(term, head_terms, list) {
> -		if (pmu_config_term(formats, attr, term, head_terms,
> +		if (pmu_config_term(pmu_name, formats, attr, term, head_terms,
>  				    zero, err))
>  			return -EINVAL;
>  	}
> @@ -1196,8 +1205,8 @@ int perf_pmu__config(struct perf_pmu *pmu, struct perf_event_attr *attr,
>  	bool zero = !!pmu->default_config;
>  
>  	attr->type = pmu->type;
> -	return perf_pmu__config_terms(&pmu->format, attr, head_terms,
> -				      zero, err);
> +	return perf_pmu__config_terms(pmu->name, &pmu->format, attr,
> +				      head_terms, zero, err);
>  }
>  
>  static struct perf_pmu_alias *pmu_find_alias(struct perf_pmu *pmu,
> diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
> index e119333e93ba..85e0c7f2515c 100644
> --- a/tools/perf/util/pmu.h
> +++ b/tools/perf/util/pmu.h
> @@ -76,7 +76,7 @@ struct perf_pmu *perf_pmu__find_by_type(unsigned int type);
>  int perf_pmu__config(struct perf_pmu *pmu, struct perf_event_attr *attr,
>  		     struct list_head *head_terms,
>  		     struct parse_events_error *error);
> -int perf_pmu__config_terms(struct list_head *formats,
> +int perf_pmu__config_terms(const char *pmu_name, struct list_head *formats,
>  			   struct perf_event_attr *attr,
>  			   struct list_head *head_terms,
>  			   bool zero, struct parse_events_error *error);
> -- 
> 2.26.2.645.ge9eca65c58-goog
> 

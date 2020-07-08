Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58E922185EF
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 13:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbgGHLTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 07:19:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728763AbgGHLTi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 07:19:38 -0400
Received: from quaco.ghostprotocols.net (unknown [179.179.83.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C87220739;
        Wed,  8 Jul 2020 11:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594207177;
        bh=eUgIo/46QmRmLemfChQoEWZQ6jErzhl1bOJQgWf5Cz4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=x2Cu0abvdpzB9DdgFpKtPVV61a7eK8lqrnKy3W8XW016M3yrVw7i73ZvlO7RMDgrF
         E9tEmq2EMV8PPcrt82ifFv4mqaQOY/Rwk8CTmRBIFoygAV2uNes8aRkDbFpNX2uIvx
         08/pHGKDZ71HWeeNx37QeQazCES7qVb4xA7C3FI4=
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 529E1405FF; Wed,  8 Jul 2020 08:19:35 -0300 (-03)
Date:   Wed, 8 Jul 2020 08:19:35 -0300
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
        Leo Yan <leo.yan@linaro.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf parse-events: report bpf errors
Message-ID: <20200708111935.GK1320@kernel.org>
References: <20200707211449.3868944-1-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707211449.3868944-1-irogers@google.com>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Tue, Jul 07, 2020 at 02:14:49PM -0700, Ian Rogers escreveu:
> Setting the parse_events_error directly doesn't increment num_errors
> causing the error message not to be displayed. Use the
> parse_events__handle_error function that sets num_errors and handle
> multiple errors.

What was the command line you used to exercise the error and then the
fix?

- Arnaldo

> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  tools/perf/util/parse-events.c | 38 ++++++++++++++++++----------------
>  1 file changed, 20 insertions(+), 18 deletions(-)
> 
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
> index c4906a6a9f1a..e88e4c7a2a9a 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -767,8 +767,8 @@ int parse_events_load_bpf_obj(struct parse_events_state *parse_state,
>  
>  	return 0;
>  errout:
> -	parse_state->error->help = strdup("(add -v to see detail)");
> -	parse_state->error->str = strdup(errbuf);
> +	parse_events__handle_error(parse_state->error, 0,
> +				strdup(errbuf), strdup("(add -v to see detail)"));
>  	return err;
>  }
>  
> @@ -784,36 +784,38 @@ parse_events_config_bpf(struct parse_events_state *parse_state,
>  		return 0;
>  
>  	list_for_each_entry(term, head_config, list) {
> -		char errbuf[BUFSIZ];
>  		int err;
>  
>  		if (term->type_term != PARSE_EVENTS__TERM_TYPE_USER) {
> -			snprintf(errbuf, sizeof(errbuf),
> -				 "Invalid config term for BPF object");
> -			errbuf[BUFSIZ - 1] = '\0';
> -
> -			parse_state->error->idx = term->err_term;
> -			parse_state->error->str = strdup(errbuf);
> +			parse_events__handle_error(parse_state->error, term->err_term,
> +						strdup("Invalid config term for BPF object"),
> +						NULL);
>  			return -EINVAL;
>  		}
>  
>  		err = bpf__config_obj(obj, term, parse_state->evlist, &error_pos);
>  		if (err) {
> +			char errbuf[BUFSIZ];
> +			int idx;
> +
>  			bpf__strerror_config_obj(obj, term, parse_state->evlist,
>  						 &error_pos, err, errbuf,
>  						 sizeof(errbuf));
> -			parse_state->error->help = strdup(
> +
> +			if (err == -BPF_LOADER_ERRNO__OBJCONF_MAP_VALUE)
> +				idx = term->err_val;
> +			else
> +				idx = term->err_term + error_pos;
> +
> +			parse_events__handle_error(parse_state->error, idx,
> +						strdup(errbuf),
> +						strdup(
>  "Hint:\tValid config terms:\n"
>  "     \tmap:[<arraymap>].value<indices>=[value]\n"
>  "     \tmap:[<eventmap>].event<indices>=[event]\n"
>  "\n"
>  "     \twhere <indices> is something like [0,3...5] or [all]\n"
> -"     \t(add -v to see detail)");
> -			parse_state->error->str = strdup(errbuf);
> -			if (err == -BPF_LOADER_ERRNO__OBJCONF_MAP_VALUE)
> -				parse_state->error->idx = term->err_val;
> -			else
> -				parse_state->error->idx = term->err_term + error_pos;
> +"     \t(add -v to see detail)"));
>  			return err;
>  		}
>  	}
> @@ -877,8 +879,8 @@ int parse_events_load_bpf(struct parse_events_state *parse_state,
>  						   -err, errbuf,
>  						   sizeof(errbuf));
>  
> -		parse_state->error->help = strdup("(add -v to see detail)");
> -		parse_state->error->str = strdup(errbuf);
> +		parse_events__handle_error(parse_state->error, 0,
> +					strdup(errbuf), strdup("(add -v to see detail)"));
>  		return err;
>  	}
>  
> -- 
> 2.27.0.383.g050319c2ae-goog
> 

-- 

- Arnaldo

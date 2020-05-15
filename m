Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 722631D5A32
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 21:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgEOTld (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 15:41:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41343 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726717AbgEOTlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 15:41:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589571690;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OUOZlTx+NnYcTtCx+Ldkfxstccp83o8CLEeza083+h4=;
        b=KZbFGOMzr3ujnLAknJlALZpv3PhOXvy3G81NpdW0ut3iaZUtYKeTxOALdA3deX7Dr4BSbi
        wzxR+b2ifzC0riGQ/uGeAxOPk+WQiISb+crLkjeFambJ5vGoBh530oT1Yt8tmsAz4m1WGY
        BSIbFlqMtvnvdUfUwgYz3h9RHFhd90k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-372-5h7CuIQlMNSSU3X4nvjb1Q-1; Fri, 15 May 2020 15:41:27 -0400
X-MC-Unique: 5h7CuIQlMNSSU3X4nvjb1Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A2411030986;
        Fri, 15 May 2020 19:41:23 +0000 (UTC)
Received: from krava (unknown [10.40.192.69])
        by smtp.corp.redhat.com (Postfix) with SMTP id 4CA7462971;
        Fri, 15 May 2020 19:41:16 +0000 (UTC)
Date:   Fri, 15 May 2020 21:41:15 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Ian Rogers <irogers@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Kajol Jain <kjain@linux.ibm.com>,
        Andi Kleen <ak@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Leo Yan <leo.yan@linaro.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v2 7/7] perf expr: Migrate expr ids table to a hashmap
Message-ID: <20200515194115.GA3577540@krava>
References: <20200515165007.217120-1-irogers@google.com>
 <20200515165007.217120-8-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515165007.217120-8-irogers@google.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 09:50:07AM -0700, Ian Rogers wrote:

SNIP

> diff --git a/tools/perf/util/metricgroup.c b/tools/perf/util/metricgroup.c
> index b071df373f8b..37be5a368d6e 100644
> --- a/tools/perf/util/metricgroup.c
> +++ b/tools/perf/util/metricgroup.c
> @@ -85,8 +85,7 @@ static void metricgroup__rblist_init(struct rblist *metric_events)
>  
>  struct egroup {
>  	struct list_head nd;
> -	int idnum;
> -	const char **ids;
> +	struct expr_parse_ctx pctx;
>  	const char *metric_name;
>  	const char *metric_expr;
>  	const char *metric_unit;
> @@ -94,19 +93,21 @@ struct egroup {
>  };
>  
>  static struct evsel *find_evsel_group(struct evlist *perf_evlist,
> -				      const char **ids,
> -				      int idnum,
> +				      struct expr_parse_ctx *pctx,
>  				      struct evsel **metric_events,
>  				      bool *evlist_used)
>  {
>  	struct evsel *ev;
> -	int i = 0, j = 0;
>  	bool leader_found;
> +	const size_t idnum = hashmap__size(&pctx->ids);
> +	size_t i = 0;
> +	int j = 0;
> +	double *val_ptr;
>  
>  	evlist__for_each_entry (perf_evlist, ev) {
>  		if (evlist_used[j++])
>  			continue;
> -		if (!strcmp(ev->name, ids[i])) {
> +		if (hashmap__find(&pctx->ids, ev->name, (void **)&val_ptr)) {

hum, you sure it's doing the same thing as before?

hashmap__find will succede all the time in here, while the
previous code was looking for the start of the group ...
the logic in here is little convoluted, so maybe I'm
missing some point in here ;-)

jirka

>  			if (!metric_events[i])
>  				metric_events[i] = ev;
>  			i++;
> @@ -118,7 +119,8 @@ static struct evsel *find_evsel_group(struct evlist *perf_evlist,
>  			memset(metric_events, 0,
>  				sizeof(struct evsel *) * idnum);
>  
> -			if (!strcmp(ev->name, ids[i])) {
> +			if (hashmap__find(&pctx->ids, ev->name,
> +					  (void **)&val_ptr)) {
>  				if (!metric_events[i])
>  					metric_events[i] = ev;

SNIP


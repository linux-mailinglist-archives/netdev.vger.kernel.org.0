Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE521DB4BC
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 15:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgETNOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 09:14:37 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26041 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726548AbgETNOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 09:14:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589980475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3bQBk28+CfN7MxyBrv8xDw/DEBfvcuoXApS/KUph1C0=;
        b=iA0jk59RgObfmVwiT0GsXBysMjQlK8+2dPfmSIEjHv8WJKkPhO4apNTCzVkzlAABOrLN/V
        OpK7mpVBXyQiQNo3pQC1RJ3IfqTQwmLVN4mfNgybXacVj2Ga3E3pY+mo9bd5JDzeWga3Gn
        nMYS3eCXpWDHWx2wKoBrrr2SrqmUiAg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-4dWvN2ifNbiGZzzcr1IFUg-1; Wed, 20 May 2020 09:14:32 -0400
X-MC-Unique: 4dWvN2ifNbiGZzzcr1IFUg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C5F8EC1A1;
        Wed, 20 May 2020 13:14:29 +0000 (UTC)
Received: from krava (unknown [10.40.193.10])
        by smtp.corp.redhat.com (Postfix) with SMTP id 9DACB1053B2C;
        Wed, 20 May 2020 13:14:23 +0000 (UTC)
Date:   Wed, 20 May 2020 15:14:22 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Ian Rogers <irogers@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Kajol Jain <kjain@linux.ibm.com>,
        Andi Kleen <ak@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Paul Clarke <pc@us.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Vince Weaver <vincent.weaver@maine.edu>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/7] perf metricgroup: Change evlist_used to a bitmap
Message-ID: <20200520131422.GL157452@krava>
References: <20200520072814.128267-1-irogers@google.com>
 <20200520072814.128267-2-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520072814.128267-2-irogers@google.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 12:28:08AM -0700, Ian Rogers wrote:
> Use a bitmap rather than an array of bools.
> 
> Signed-off-by: Ian Rogers <irogers@google.com>

Acked-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka

> ---
>  tools/perf/util/metricgroup.c | 18 ++++++++----------
>  1 file changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/perf/util/metricgroup.c b/tools/perf/util/metricgroup.c
> index 6772d256dfdf..a16f60da06ab 100644
> --- a/tools/perf/util/metricgroup.c
> +++ b/tools/perf/util/metricgroup.c
> @@ -95,7 +95,7 @@ struct egroup {
>  static struct evsel *find_evsel_group(struct evlist *perf_evlist,
>  				      struct expr_parse_ctx *pctx,
>  				      struct evsel **metric_events,
> -				      bool *evlist_used)
> +				      unsigned long *evlist_used)
>  {
>  	struct evsel *ev;
>  	bool leader_found;
> @@ -105,7 +105,7 @@ static struct evsel *find_evsel_group(struct evlist *perf_evlist,
>  	double *val_ptr;
>  
>  	evlist__for_each_entry (perf_evlist, ev) {
> -		if (evlist_used[j++])
> +		if (test_bit(j++, evlist_used))
>  			continue;
>  		if (hashmap__find(&pctx->ids, ev->name, (void **)&val_ptr)) {
>  			if (!metric_events[i])
> @@ -141,7 +141,7 @@ static struct evsel *find_evsel_group(struct evlist *perf_evlist,
>  			j++;
>  		}
>  		ev = metric_events[i];
> -		evlist_used[ev->idx] = true;
> +		set_bit(ev->idx, evlist_used);
>  	}
>  
>  	return metric_events[0];
> @@ -157,13 +157,11 @@ static int metricgroup__setup_events(struct list_head *groups,
>  	int ret = 0;
>  	struct egroup *eg;
>  	struct evsel *evsel;
> -	bool *evlist_used;
> +	unsigned long *evlist_used;
>  
> -	evlist_used = calloc(perf_evlist->core.nr_entries, sizeof(bool));
> -	if (!evlist_used) {
> -		ret = -ENOMEM;
> -		return ret;
> -	}
> +	evlist_used = bitmap_alloc(perf_evlist->core.nr_entries);
> +	if (!evlist_used)
> +		return -ENOMEM;
>  
>  	list_for_each_entry (eg, groups, nd) {
>  		struct evsel **metric_events;
> @@ -201,7 +199,7 @@ static int metricgroup__setup_events(struct list_head *groups,
>  		list_add(&expr->nd, &me->head);
>  	}
>  
> -	free(evlist_used);
> +	bitmap_free(evlist_used);
>  
>  	return ret;
>  }
> -- 
> 2.26.2.761.g0e0b3e54be-goog
> 


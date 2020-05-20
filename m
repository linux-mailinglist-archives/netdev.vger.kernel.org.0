Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75D931DB4BA
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 15:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgETNO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 09:14:27 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:45802 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726875AbgETNO0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 09:14:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589980465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FUXBwwotAXFntved+mHgO+sQBn869QaplV5u5W6iFT8=;
        b=hgr4t0RXAaj/OvSq7dJYiQi2awgawfAqA32hhn6Ti2eIlxYeMP/JusjG8CSshUcKbNXoJl
        kTXQuEclc3ele0V89fA8fcWapiQF7YpHfd8ZlZpnHrsehDT1cm0LIrzL/fGXYGTtl39dSq
        NaWUcm7jqk5mfJ0MYUEjca5yZOHhHMk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-510-spznU9dSOg6wqyimfcBGhQ-1; Wed, 20 May 2020 09:14:21 -0400
X-MC-Unique: spznU9dSOg6wqyimfcBGhQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3531D107ACCD;
        Wed, 20 May 2020 13:14:18 +0000 (UTC)
Received: from krava (unknown [10.40.193.10])
        by smtp.corp.redhat.com (Postfix) with SMTP id 46AB57958F;
        Wed, 20 May 2020 13:14:13 +0000 (UTC)
Date:   Wed, 20 May 2020 15:14:12 +0200
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
Subject: Re: [PATCH 3/7] perf metricgroup: Delay events string creation
Message-ID: <20200520131412.GK157452@krava>
References: <20200520072814.128267-1-irogers@google.com>
 <20200520072814.128267-4-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520072814.128267-4-irogers@google.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 12:28:10AM -0700, Ian Rogers wrote:
> Currently event groups are placed into groups_list at the same time as
> the events string containing the events is built. Separate these two
> operations and build the groups_list first, then the event string from
> the groups_list. This adds an ability to reorder the groups_list that
> will be used in a later patch.
> 
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  tools/perf/util/metricgroup.c | 38 +++++++++++++++++++++++------------
>  1 file changed, 25 insertions(+), 13 deletions(-)
> 
> diff --git a/tools/perf/util/metricgroup.c b/tools/perf/util/metricgroup.c
> index 7a43ee0a2e40..afd960d03a77 100644
> --- a/tools/perf/util/metricgroup.c
> +++ b/tools/perf/util/metricgroup.c
> @@ -90,6 +90,7 @@ struct egroup {
>  	const char *metric_expr;
>  	const char *metric_unit;
>  	int runtime;
> +	bool has_constraint;
>  };
>  
>  static struct evsel *find_evsel_group(struct evlist *perf_evlist,
> @@ -485,8 +486,8 @@ int __weak arch_get_runtimeparam(void)
>  	return 1;
>  }
>  
> -static int __metricgroup__add_metric(struct strbuf *events,
> -		struct list_head *group_list, struct pmu_event *pe, int runtime)
> +static int __metricgroup__add_metric(struct list_head *group_list,
> +				     struct pmu_event *pe, int runtime)
>  {
>  	struct egroup *eg;
>  
> @@ -499,6 +500,7 @@ static int __metricgroup__add_metric(struct strbuf *events,
>  	eg->metric_expr = pe->metric_expr;
>  	eg->metric_unit = pe->unit;
>  	eg->runtime = runtime;
> +	eg->has_constraint = metricgroup__has_constraint(pe);
>  
>  	if (expr__find_other(pe->metric_expr, NULL, &eg->pctx, runtime) < 0) {
>  		expr__ctx_clear(&eg->pctx);
> @@ -506,14 +508,6 @@ static int __metricgroup__add_metric(struct strbuf *events,
>  		return -EINVAL;
>  	}
>  
> -	if (events->len > 0)
> -		strbuf_addf(events, ",");
> -
> -	if (metricgroup__has_constraint(pe))
> -		metricgroup__add_metric_non_group(events, &eg->pctx);
> -	else
> -		metricgroup__add_metric_weak_group(events, &eg->pctx);
> -
>  	list_add_tail(&eg->nd, group_list);
>  
>  	return 0;
> @@ -524,6 +518,7 @@ static int metricgroup__add_metric(const char *metric, struct strbuf *events,
>  {
>  	struct pmu_events_map *map = perf_pmu__find_map(NULL);
>  	struct pmu_event *pe;
> +	struct egroup *eg;
>  	int i, ret = -EINVAL;
>  
>  	if (!map)
> @@ -542,7 +537,8 @@ static int metricgroup__add_metric(const char *metric, struct strbuf *events,
>  			pr_debug("metric expr %s for %s\n", pe->metric_expr, pe->metric_name);
>  
>  			if (!strstr(pe->metric_expr, "?")) {
> -				ret = __metricgroup__add_metric(events, group_list, pe, 1);
> +				ret = __metricgroup__add_metric(group_list,
> +								pe, 1);
>  			} else {
>  				int j, count;
>  
> @@ -553,13 +549,29 @@ static int metricgroup__add_metric(const char *metric, struct strbuf *events,
>  				 * those events to group_list.
>  				 */
>  
> -				for (j = 0; j < count; j++)
> -					ret = __metricgroup__add_metric(events, group_list, pe, j);
> +				for (j = 0; j < count; j++) {
> +					ret = __metricgroup__add_metric(
> +						group_list, pe, j);
> +				}
>  			}
>  			if (ret == -ENOMEM)
>  				break;
>  		}
>  	}
> +	if (!ret) {

could you please do instead:

	if (ret)
		return ret;

so the code below cuts down one indent level and you
don't need to split up the lines

thanks,
jirka

> +		list_for_each_entry(eg, group_list, nd) {
> +			if (events->len > 0)
> +				strbuf_addf(events, ",");
> +
> +			if (eg->has_constraint) {
> +				metricgroup__add_metric_non_group(events,
> +								  &eg->pctx);
> +			} else {
> +				metricgroup__add_metric_weak_group(events,
> +								   &eg->pctx);
> +			}
> +		}
> +	}
>  	return ret;
>  }
>  
> -- 
> 2.26.2.761.g0e0b3e54be-goog
> 


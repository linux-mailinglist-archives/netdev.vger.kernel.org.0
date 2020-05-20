Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0B61DB58F
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 15:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbgETNtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 09:49:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40885 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726570AbgETNtB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 09:49:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589982540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a816W8Z5hp9K0nG+dy2LJ94rdDDToT47/ru3WqNRsNQ=;
        b=iXLUJwYxYGP/SkkPVywn7SleB/SImDDE7f5MlyAugUmXwJydPQj7YQowJLBM6S9TX3jbg5
        d90uCmewab+pxDHd5bxI6HtdBF9p8BNFCIPZ2dzlsIKCdllUO38GQ/MyozFRtD78dzQ6O2
        WFE72Ys2vTEVLUxrlcQ6baE6lZqEPYQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-Of_ePFwOOx-1njuz7CnsEg-1; Wed, 20 May 2020 09:48:56 -0400
X-MC-Unique: Of_ePFwOOx-1njuz7CnsEg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3300E80B71E;
        Wed, 20 May 2020 13:48:53 +0000 (UTC)
Received: from krava (unknown [10.40.193.10])
        by smtp.corp.redhat.com (Postfix) with SMTP id 373567958D;
        Wed, 20 May 2020 13:48:48 +0000 (UTC)
Date:   Wed, 20 May 2020 15:48:47 +0200
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
Subject: Re: [PATCH 5/7] perf metricgroup: Remove duped metric group events
Message-ID: <20200520134847.GM157452@krava>
References: <20200520072814.128267-1-irogers@google.com>
 <20200520072814.128267-6-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520072814.128267-6-irogers@google.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 12:28:12AM -0700, Ian Rogers wrote:

SNIP

>  
> @@ -157,7 +183,7 @@ static int metricgroup__setup_events(struct list_head *groups,
>  	int i = 0;
>  	int ret = 0;
>  	struct egroup *eg;
> -	struct evsel *evsel;
> +	struct evsel *evsel, *tmp;
>  	unsigned long *evlist_used;
>  
>  	evlist_used = bitmap_alloc(perf_evlist->core.nr_entries);
> @@ -173,7 +199,8 @@ static int metricgroup__setup_events(struct list_head *groups,
>  			ret = -ENOMEM;
>  			break;
>  		}
> -		evsel = find_evsel_group(perf_evlist, &eg->pctx, metric_events,
> +		evsel = find_evsel_group(perf_evlist, &eg->pctx,
> +					eg->has_constraint, metric_events,
>  					evlist_used);
>  		if (!evsel) {
>  			pr_debug("Cannot resolve %s: %s\n",
> @@ -200,6 +227,12 @@ static int metricgroup__setup_events(struct list_head *groups,
>  		list_add(&expr->nd, &me->head);
>  	}
>  
> +	evlist__for_each_entry_safe(perf_evlist, tmp, evsel) {
> +		if (!test_bit(evsel->idx, evlist_used)) {
> +			evlist__remove(perf_evlist, evsel);
> +			evsel__delete(evsel);
> +		}

is the groupping still enabled when we merge groups? could part
of the metric (events) be now computed in different groups?

I was wondering if we could merge all the hasmaps into single
one before the parse the evlist.. this way we won't need removing
later.. but I did not thought this through completely, so it
might not work at some point

jirka


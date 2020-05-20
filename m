Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E151DB523
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 15:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgETNfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 09:35:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:34790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726439AbgETNfp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 09:35:45 -0400
Received: from quaco.ghostprotocols.net (unknown [179.97.37.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2182205CB;
        Wed, 20 May 2020 13:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589981745;
        bh=phloIUBQpu3/jpZrsC4HMcX5ETMF1RT2H6pJF8+igM8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pRPVN1VEWz1jagm9L1OZpf/2CjCGsJiDqQqthV2zLLnj3k95/HLC/fXdMNPDW2D8l
         mzjIOsRpyd6E48y1AXQsLa1G/1JN0vR5TM2JquiEVwBJIeX4LuLEHJXc6fjyE8jkZ2
         b9Ns2hHBsXXh5sQMQLNgqbINFvLJyNDTF3ZtHb1U=
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id BEEF840AFD; Wed, 20 May 2020 10:35:42 -0300 (-03)
Date:   Wed, 20 May 2020 10:35:42 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Ian Rogers <irogers@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
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
Message-ID: <20200520133542.GG32678@kernel.org>
References: <20200520072814.128267-1-irogers@google.com>
 <20200520072814.128267-2-irogers@google.com>
 <20200520131422.GL157452@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520131422.GL157452@krava>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Wed, May 20, 2020 at 03:14:22PM +0200, Jiri Olsa escreveu:
> On Wed, May 20, 2020 at 12:28:08AM -0700, Ian Rogers wrote:
> > Use a bitmap rather than an array of bools.
> > 
> > Signed-off-by: Ian Rogers <irogers@google.com>
> 
> Acked-by: Jiri Olsa <jolsa@redhat.com>

Thanks, applied.
 
> thanks,
> jirka
> 
> > ---
> >  tools/perf/util/metricgroup.c | 18 ++++++++----------
> >  1 file changed, 8 insertions(+), 10 deletions(-)
> > 
> > diff --git a/tools/perf/util/metricgroup.c b/tools/perf/util/metricgroup.c
> > index 6772d256dfdf..a16f60da06ab 100644
> > --- a/tools/perf/util/metricgroup.c
> > +++ b/tools/perf/util/metricgroup.c
> > @@ -95,7 +95,7 @@ struct egroup {
> >  static struct evsel *find_evsel_group(struct evlist *perf_evlist,
> >  				      struct expr_parse_ctx *pctx,
> >  				      struct evsel **metric_events,
> > -				      bool *evlist_used)
> > +				      unsigned long *evlist_used)
> >  {
> >  	struct evsel *ev;
> >  	bool leader_found;
> > @@ -105,7 +105,7 @@ static struct evsel *find_evsel_group(struct evlist *perf_evlist,
> >  	double *val_ptr;
> >  
> >  	evlist__for_each_entry (perf_evlist, ev) {
> > -		if (evlist_used[j++])
> > +		if (test_bit(j++, evlist_used))
> >  			continue;
> >  		if (hashmap__find(&pctx->ids, ev->name, (void **)&val_ptr)) {
> >  			if (!metric_events[i])
> > @@ -141,7 +141,7 @@ static struct evsel *find_evsel_group(struct evlist *perf_evlist,
> >  			j++;
> >  		}
> >  		ev = metric_events[i];
> > -		evlist_used[ev->idx] = true;
> > +		set_bit(ev->idx, evlist_used);
> >  	}
> >  
> >  	return metric_events[0];
> > @@ -157,13 +157,11 @@ static int metricgroup__setup_events(struct list_head *groups,
> >  	int ret = 0;
> >  	struct egroup *eg;
> >  	struct evsel *evsel;
> > -	bool *evlist_used;
> > +	unsigned long *evlist_used;
> >  
> > -	evlist_used = calloc(perf_evlist->core.nr_entries, sizeof(bool));
> > -	if (!evlist_used) {
> > -		ret = -ENOMEM;
> > -		return ret;
> > -	}
> > +	evlist_used = bitmap_alloc(perf_evlist->core.nr_entries);
> > +	if (!evlist_used)
> > +		return -ENOMEM;
> >  
> >  	list_for_each_entry (eg, groups, nd) {
> >  		struct evsel **metric_events;
> > @@ -201,7 +199,7 @@ static int metricgroup__setup_events(struct list_head *groups,
> >  		list_add(&expr->nd, &me->head);
> >  	}
> >  
> > -	free(evlist_used);
> > +	bitmap_free(evlist_used);
> >  
> >  	return ret;
> >  }
> > -- 
> > 2.26.2.761.g0e0b3e54be-goog
> > 
> 

-- 

- Arnaldo

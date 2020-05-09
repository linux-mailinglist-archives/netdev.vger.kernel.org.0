Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DAE31CBBDB
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 02:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728375AbgEIAib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 20:38:31 -0400
Received: from mga04.intel.com ([192.55.52.120]:3157 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727878AbgEIAib (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 20:38:31 -0400
IronPort-SDR: aopw/5m44GsnUnkU1UtPtopuLYOg5xUtm14EvccOz4UiwM0pFZW+oFS8saxF4FNlGpEQy55wKv
 MdQkV1M55APg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2020 17:38:30 -0700
IronPort-SDR: q+sV77rbJRSonenXnHAbxIaNJcsxfDDnbUmDtOAuy5/ssIMbKCf1nWEdjdgakP2jskGvmkmC8t
 JWZnt/bd8Y3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,369,1583222400"; 
   d="scan'208";a="279197066"
Received: from tassilo.jf.intel.com (HELO tassilo.localdomain) ([10.7.201.21])
  by orsmga002.jf.intel.com with ESMTP; 08 May 2020 17:38:30 -0700
Received: by tassilo.localdomain (Postfix, from userid 1000)
        id 79BCB301C4C; Fri,  8 May 2020 17:38:30 -0700 (PDT)
Date:   Fri, 8 May 2020 17:38:30 -0700
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
Subject: Re: [RFC PATCH v3 13/14] perf metricgroup: remove duped metric group
 events
Message-ID: <20200509003830.GG3538@tassilo.jf.intel.com>
References: <20200508053629.210324-1-irogers@google.com>
 <20200508053629.210324-14-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508053629.210324-14-irogers@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  static struct evsel *find_evsel_group(struct evlist *perf_evlist,
>  				      struct expr_parse_ctx *pctx,
> +				      bool has_constraint,
>  				      struct evsel **metric_events,
>  				      unsigned long *evlist_used)
>  {
> -	struct evsel *ev;
> -	bool leader_found;
> -	const size_t idnum = hashmap__size(&pctx->ids);
> -	size_t i = 0;
> -	int j = 0;
> +	struct evsel *ev, *current_leader = NULL;
>  	double *val_ptr;
> +	int i = 0, matched_events = 0, events_to_match;
> +	const int idnum = (int)hashmap__size(&pctx->ids);

BTW standard perf data structure would be a rblist or strlist

I think it would be really better to do the deduping in a separate
pass than trying to add it to find_evsel_group. This leads
to very complicated logic.

This will likely make it easier to implement more sophisticated
algorithms too.

-Andi


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE901CBBC3
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 02:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbgEIAZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 20:25:20 -0400
Received: from mga18.intel.com ([134.134.136.126]:21538 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727959AbgEIAZU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 20:25:20 -0400
IronPort-SDR: pIo6F0/8O7TC2UXmiMHEksOej2ZCyC8bMh/SQpPqVqCot+CTTOOAmHk4vLT0ESPUil4bNWQTO1
 v2Ryrah2CXcw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2020 17:25:19 -0700
IronPort-SDR: kp/Bvufejq8QaWyJR4D2rYpIQqVsAZcRWvpWTSQV2Ju9IakfrwneT2vv3QgUINgRL/7grVRuo7
 RISbptYjt02w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,369,1583222400"; 
   d="scan'208";a="370671781"
Received: from tassilo.jf.intel.com (HELO tassilo.localdomain) ([10.7.201.21])
  by fmsmga001.fm.intel.com with ESMTP; 08 May 2020 17:25:18 -0700
Received: by tassilo.localdomain (Postfix, from userid 1000)
        id A22B6301C4C; Fri,  8 May 2020 17:25:18 -0700 (PDT)
Date:   Fri, 8 May 2020 17:25:18 -0700
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
Subject: Re: [RFC PATCH v3 12/14] perf metricgroup: order event groups by size
Message-ID: <20200509002518.GF3538@tassilo.jf.intel.com>
References: <20200508053629.210324-1-irogers@google.com>
 <20200508053629.210324-13-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508053629.210324-13-irogers@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 07, 2020 at 10:36:27PM -0700, Ian Rogers wrote:
> When adding event groups to the group list, insert them in size order.
> This performs an insertion sort on the group list. By placing the
> largest groups at the front of the group list it is possible to see if a
> larger group contains the same events as a later group. This can make
> the later group redundant - it can reuse the events from the large group.
> A later patch will add this sharing.

I'm not sure if size is that great an heuristic. The dedup algorithm should
work in any case even if you don't order by size, right?

I suppose in theory some kind of topological sort would be better.

-Andi
> 
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  tools/perf/util/metricgroup.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/metricgroup.c b/tools/perf/util/metricgroup.c
> index 2a6456fa178b..69fbff47089f 100644
> --- a/tools/perf/util/metricgroup.c
> +++ b/tools/perf/util/metricgroup.c
> @@ -520,7 +520,21 @@ static int __metricgroup__add_metric(struct list_head *group_list,
>  		return -EINVAL;
>  	}
>  
> -	list_add_tail(&eg->nd, group_list);
> +	if (list_empty(group_list))
> +		list_add(&eg->nd, group_list);
> +	else {
> +		struct list_head *pos;
> +
> +		/* Place the largest groups at the front. */
> +		list_for_each_prev(pos, group_list) {
> +			struct egroup *old = list_entry(pos, struct egroup, nd);
> +
> +			if (hashmap__size(&eg->pctx.ids) <=
> +			    hashmap__size(&old->pctx.ids))
> +				break;
> +		}
> +		list_add(&eg->nd, pos);
> +	}
>  
>  	return 0;
>  }
> -- 
> 2.26.2.645.ge9eca65c58-goog
> 

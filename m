Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC551DD3E7
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729568AbgEURHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:07:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:42254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728565AbgEURHH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 13:07:07 -0400
Received: from quaco.ghostprotocols.net (unknown [179.97.37.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8D9820759;
        Thu, 21 May 2020 17:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590080827;
        bh=OtwlfFmNQgc80UjNIdcExbJwJxfb18Gjc2AQYQZ4KCA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jX0v0UwvZ+soIo2gh1lmoddPZuETI8kS51MBmggNIbQ9bOOYSEpLfGRMWUN8bwbeX
         MjIzR+Dhfv4VmR1xNymBIMekvXeOOoPzHgjCkp5s0Qv/BOCOf+BPxKLF3ai+Cfq/tn
         Peze1O6CrD7GOjqV+bpFAKppYK+iHzATNC65OtsY=
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id DB22F40AFD; Thu, 21 May 2020 14:07:04 -0300 (-03)
Date:   Thu, 21 May 2020 14:07:04 -0300
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
        Kajol Jain <kjain@linux.ibm.com>,
        Andi Kleen <ak@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Vince Weaver <vincent.weaver@maine.edu>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [RFC PATCH v3 09/14] perf metricgroup: free metric_events on
 error
Message-ID: <20200521170704.GC14034@kernel.org>
References: <20200508053629.210324-1-irogers@google.com>
 <20200508053629.210324-10-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508053629.210324-10-irogers@google.com>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Thu, May 07, 2020 at 10:36:24PM -0700, Ian Rogers escreveu:
> Avoid a simple memory leak.

Thanks, applied.

- Arnaldo
 
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  tools/perf/util/metricgroup.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tools/perf/util/metricgroup.c b/tools/perf/util/metricgroup.c
> index 4f7e36bc49d9..7e1725d61c39 100644
> --- a/tools/perf/util/metricgroup.c
> +++ b/tools/perf/util/metricgroup.c
> @@ -186,6 +186,7 @@ static int metricgroup__setup_events(struct list_head *groups,
>  		if (!evsel) {
>  			pr_debug("Cannot resolve %s: %s\n",
>  					eg->metric_name, eg->metric_expr);
> +			free(metric_events);
>  			continue;
>  		}
>  		for (i = 0; metric_events[i]; i++)
> @@ -193,11 +194,13 @@ static int metricgroup__setup_events(struct list_head *groups,
>  		me = metricgroup__lookup(metric_events_list, evsel, true);
>  		if (!me) {
>  			ret = -ENOMEM;
> +			free(metric_events);
>  			break;
>  		}
>  		expr = malloc(sizeof(struct metric_expr));
>  		if (!expr) {
>  			ret = -ENOMEM;
> +			free(metric_events);
>  			break;
>  		}
>  		expr->metric_expr = eg->metric_expr;
> -- 
> 2.26.2.645.ge9eca65c58-goog
> 

-- 

- Arnaldo

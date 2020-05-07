Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 290901C9848
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 19:49:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbgEGRsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 13:48:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:26136 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726393AbgEGRsg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 13:48:36 -0400
IronPort-SDR: rJCF1nCYdeGGqwiQ9w4IJDvSipRRgKnHw7dz4VS9dNTKKVOPy34fCUPcoZ2F2+EMFaUVpRQUtg
 DTms4HLsWFmQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2020 10:48:36 -0700
IronPort-SDR: n+wnT7yQJKWW2P4uJXN3jxTgi9+UwRapDpTr3iblt8rCQtRCqnTDxbaOqU0Y1naHjEx+FhhC4r
 SzYipRyvdyhQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,364,1583222400"; 
   d="scan'208";a="435378020"
Received: from tassilo.jf.intel.com (HELO tassilo.localdomain) ([10.7.201.21])
  by orsmga005.jf.intel.com with ESMTP; 07 May 2020 10:48:35 -0700
Received: by tassilo.localdomain (Postfix, from userid 1000)
        id D31B9301C1B; Thu,  7 May 2020 10:48:35 -0700 (PDT)
Date:   Thu, 7 May 2020 10:48:35 -0700
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
        Stephane Eranian <eranian@google.com>
Subject: Re: [RFC PATCH 0/7] Share events between metrics
Message-ID: <20200507174835.GB3538@tassilo.jf.intel.com>
References: <20200507081436.49071-1-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200507081436.49071-1-irogers@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 07, 2020 at 01:14:29AM -0700, Ian Rogers wrote:
> Metric groups contain metrics. Metrics create groups of events to
> ideally be scheduled together. Often metrics refer to the same events,
> for example, a cache hit and cache miss rate. Using separate event
> groups means these metrics are multiplexed at different times and the
> counts don't sum to 100%. More multiplexing also decreases the
> accuracy of the measurement.
> 
> This change orders metrics from groups or the command line, so that
> the ones with the most events are set up first. Later metrics see if
> groups already provide their events, and reuse them if
> possible. Unnecessary events and groups are eliminated.

Note this actually may make multiplexing errors worse.

For metrics it is often important that all the input values to
the metric run at the same time. 

So e.g. if you have two metrics and they each fit into a group,
but not together, even though you have more multiplexing it
will give more accurate results for each metric.

I think you change can make sense for metrics that don't fit 
into single groups anyways. perf currently doesn't quite know
this but some heuristic could be added. 

But I wouldn't do it for simple metrics that fit into groups.
The result may well be worse.

My toplev tool has some heuristics for this, also some more
sophisticated ones that tracks subexpressions. That would
be far too complicated for perf likely.

-Andi

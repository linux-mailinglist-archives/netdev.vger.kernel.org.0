Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 085CB1C8CF5
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 15:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgEGNt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 09:49:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25723 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726382AbgEGNt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 09:49:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588859396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mtfeKIrFwLIEu5xU9YDtgCdmdoqxZ0ztvTPMoqop3dw=;
        b=AGxBZ0fMxXikV1tTe5JLTsiS9m4aU/KMHz0DhgJOPPGdh0EQygERYLkL7YYB/HkZN3TLQr
        2jGBc3AdyWFxk30suf92l9eFIExR7bZbPhTMwfc4hgpEJfndS/rrA4/8tXECeUT1GQgRFV
        k5zOe4dVNJ1s5FIO2j16xexDxN4VfYY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-pIKrsyx3PpWPxylVzzPlvg-1; Thu, 07 May 2020 09:49:52 -0400
X-MC-Unique: pIKrsyx3PpWPxylVzzPlvg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C0D3E1895A29;
        Thu,  7 May 2020 13:49:48 +0000 (UTC)
Received: from krava (unknown [10.40.194.212])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E28AD10016E8;
        Thu,  7 May 2020 13:49:41 +0000 (UTC)
Date:   Thu, 7 May 2020 15:49:39 +0200
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
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [RFC PATCH 0/7] Share events between metrics
Message-ID: <20200507134939.GA2804092@krava>
References: <20200507081436.49071-1-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200507081436.49071-1-irogers@google.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
> 
> RFC because:
>  - without this change events within a metric may get scheduled
>    together, after they may appear as part of a larger group and be
>    multiplexed at different times, lowering accuracy - however, less
>    multiplexing may compensate for this.
>  - libbpf's hashmap is used, however, libbpf is an optional
>    requirement for building perf.
>  - other things I'm not thinking of.

hi,
I can't apply this, what branch/commit is this based on?

	Applying: perf expr: migrate expr ids table to libbpf's hashmap
	error: patch failed: tools/perf/tests/pmu-events.c:428
	error: tools/perf/tests/pmu-events.c: patch does not apply
	error: patch failed: tools/perf/util/expr.h:2
	error: tools/perf/util/expr.h: patch does not apply
	error: patch failed: tools/perf/util/expr.y:73
	error: tools/perf/util/expr.y: patch does not apply
	Patch failed at 0001 perf expr: migrate expr ids table to libbpf's hashmap

thanks,
jirka

> 
> Thanks!
> 
> Ian Rogers (7):
>   perf expr: migrate expr ids table to libbpf's hashmap
>   perf metricgroup: change evlist_used to a bitmap
>   perf metricgroup: free metric_events on error
>   perf metricgroup: always place duration_time last
>   perf metricgroup: delay events string creation
>   perf metricgroup: order event groups by size
>   perf metricgroup: remove duped metric group events
> 
>  tools/perf/tests/expr.c       |  32 ++---
>  tools/perf/tests/pmu-events.c |  22 ++--
>  tools/perf/util/expr.c        | 125 ++++++++++--------
>  tools/perf/util/expr.h        |  22 ++--
>  tools/perf/util/expr.y        |  22 +---
>  tools/perf/util/metricgroup.c | 242 +++++++++++++++++++++-------------
>  tools/perf/util/stat-shadow.c |  46 ++++---
>  7 files changed, 280 insertions(+), 231 deletions(-)
> 
> -- 
> 2.26.2.526.g744177e7f7-goog
> 


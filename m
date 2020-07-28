Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22448230EA0
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 18:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731203AbgG1P7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 11:59:55 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:45576 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730679AbgG1P7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 11:59:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595951993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FwMDmCLjPgPyIwCwBV+M7ENrQyFWuABUGAGQkmMVDFE=;
        b=OwSb4dfvPnjGmUZFK+fkyFeNnasx2geBmE9EAppuoOVMk/G9LFbpRTe4CnudLTI8KzmjAy
        SdudnO2Hjkq19EB3ku34Onx/P04tXMlHStF0B6jKFN0AMBxOCfbbS6HrlzAucVPuR5i0/k
        qoJW6+92Y4IKSHHRtafUeOMSuLD2NYg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-454-IIO8mskENACISyAGc0c4zQ-1; Tue, 28 Jul 2020 11:59:49 -0400
X-MC-Unique: IIO8mskENACISyAGc0c4zQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B55CB19200C5;
        Tue, 28 Jul 2020 15:59:46 +0000 (UTC)
Received: from krava (unknown [10.40.192.211])
        by smtp.corp.redhat.com (Postfix) with SMTP id C526F69324;
        Tue, 28 Jul 2020 15:59:41 +0000 (UTC)
Date:   Tue, 28 Jul 2020 17:59:40 +0200
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
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v2 2/5] perf record: Prevent override of
 attr->sample_period for libpfm4 events
Message-ID: <20200728155940.GC1319041@krava>
References: <20200728085734.609930-1-irogers@google.com>
 <20200728085734.609930-3-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728085734.609930-3-irogers@google.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 01:57:31AM -0700, Ian Rogers wrote:
> From: Stephane Eranian <eranian@google.com>
> 
> Before:
> $ perf record -c 10000 --pfm-events=cycles:period=77777
> 
> Would yield a cycles event with period=10000, instead of 77777.
> 
> This was due to an ordering issue between libpfm4 parsing
> the event string and perf record initializing the event.
> 
> This patch fixes the problem by preventing override for
> events with attr->sample_period != 0 by the time
> perf_evsel__config() is invoked. This seems to have been the
> intent of the author.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> Reviewed-by: Ian Rogers <irogers@google.com>
> ---
>  tools/perf/util/evsel.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index 811f538f7d77..8afc24e2ec52 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -976,8 +976,7 @@ void evsel__config(struct evsel *evsel, struct record_opts *opts,
>  	 * We default some events to have a default interval. But keep
>  	 * it a weak assumption overridable by the user.
>  	 */
> -	if (!attr->sample_period || (opts->user_freq != UINT_MAX ||
> -				     opts->user_interval != ULLONG_MAX)) {
> +	if (!attr->sample_period) {

I was wondering why this wouldn't break record/top
but we take care of the via record_opts__config

as long as 'perf test attr' works it looks ok to me

Acked-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka


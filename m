Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6512324ED
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 20:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgG2Sym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 14:54:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726365AbgG2Sym (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 14:54:42 -0400
Received: from quaco.ghostprotocols.net (unknown [179.97.37.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A00512075D;
        Wed, 29 Jul 2020 18:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596048881;
        bh=zFBRJidD33JrSWfE/vO6FUHZfJQaVyBLHNmxTMcCR+w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PXdf8TPvoqKgwUP3eDPDXfYNVmMwQnCyWXg9w356HFunVON0fr0sYi02gbFeIJg04
         pk1cS6IYpqQHeO6WVoMB90Rgxx0jyvuw42ZLJr0XzP0rbJ5LEuQ72uELggcnBZ0gj1
         vK3N7lkajFi5hL+IJvBp7dexMla/MwpVX4jE2wh8=
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id D056F40E59; Wed, 29 Jul 2020 15:54:39 -0300 (-03)
Date:   Wed, 29 Jul 2020 15:54:39 -0300
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
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v2 2/5] perf record: Prevent override of
 attr->sample_period for libpfm4 events
Message-ID: <20200729185439.GC433799@kernel.org>
References: <20200728085734.609930-1-irogers@google.com>
 <20200728085734.609930-3-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728085734.609930-3-irogers@google.com>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Tue, Jul 28, 2020 at 01:57:31AM -0700, Ian Rogers escreveu:
> From: Stephane Eranian <eranian@google.com>
> 
> Before:
> $ perf record -c 10000 --pfm-events=cycles:period=77777
> 
> Would yield a cycles event with period=10000, instead of 77777.

I tried the equivalent without libpfm and it works:

  $ perf record -c 10000 -e cycles/period=20000/ sleep 1
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.024 MB perf.data (23 samples) ]
  $ perf evlist -v
  cycles/period=20000/u: size: 120, { sample_period, sample_freq }: 20000, sample_type: IP|TID|TIME, read_format: ID, disabled: 1, inherit: 1, exclude_kernel: 1, exclude_hv: 1, mmap: 1, comm: 1, enable_on_exec: 1, task: 1, sample_id_all: 1, exclude_guest: 1, mmap2: 1, comm_exec: 1, ksymbol: 1, bpf_event: 1
  $
 
> This was due to an ordering issue between libpfm4 parsing
> the event string and perf record initializing the event.
 
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
>  		if (opts->freq) {
>  			attr->freq		= 1;
>  			attr->sample_freq	= opts->freq;
> -- 
> 2.28.0.163.g6104cc2f0b6-goog
> 

-- 

- Arnaldo

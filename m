Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86BEB230EBB
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 18:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731279AbgG1QDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 12:03:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:33668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731044AbgG1QDM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 12:03:12 -0400
Received: from quaco.ghostprotocols.net (unknown [179.97.37.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 032BA2053B;
        Tue, 28 Jul 2020 16:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595952192;
        bh=Nrdi6RbUtjXiYs3BGWNlvAd1Qp355THznjM8Xpt7rHM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kRBIP/lUOGCQLFimbaXgdiU+ySb4ll3DCS93Emg/zKgvyvq6SA4qKZJcxNhvxwWIq
         HVWqU+pwq2OeRzjmkzbYA4sqqQOpdDIvyjmHi+9TUJqrdKIYTRxdjOOKFwArzRr+lT
         b824zOQw0jmr9LIi6fxBF83dEDY+pGi2qQz6eVgo=
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id A987440E57; Tue, 28 Jul 2020 13:03:09 -0300 (-03)
Date:   Tue, 28 Jul 2020 13:03:09 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Ian Rogers <irogers@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
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
        bpf@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        David Sharp <dhsharp@google.com>
Subject: Re: [PATCH v2 1/5] perf record: Set PERF_RECORD_PERIOD if attr->freq
 is set.
Message-ID: <20200728160309.GC374564@kernel.org>
References: <20200728085734.609930-1-irogers@google.com>
 <20200728085734.609930-2-irogers@google.com>
 <20200728154347.GB1319041@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728154347.GB1319041@krava>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Tue, Jul 28, 2020 at 05:43:47PM +0200, Jiri Olsa escreveu:
> On Tue, Jul 28, 2020 at 01:57:30AM -0700, Ian Rogers wrote:
> > From: David Sharp <dhsharp@google.com>
> > 
> > evsel__config() would only set PERF_RECORD_PERIOD if it set attr->freq
> > from perf record options. When it is set by libpfm events, it would not
> > get set. This changes evsel__config to see if attr->freq is set outside of
> > whether or not it changes attr->freq itself.
> > 
> > Signed-off-by: David Sharp <dhsharp@google.com>
> > Signed-off-by: Ian Rogers <irogers@google.com>
> 
> Acked-by: Jiri Olsa <jolsa@redhat.com>

So, somebody else complained that its not PERF_RECORD_PERIOD (there is
no such thing) that is being set, its PERF_SAMPLE_PERIOD.

Since you acked it I merged it now, with that correction,

- Arnaldo
 
> thanks,
> jirka
> 
> > ---
> >  tools/perf/util/evsel.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> > index ef802f6d40c1..811f538f7d77 100644
> > --- a/tools/perf/util/evsel.c
> > +++ b/tools/perf/util/evsel.c
> > @@ -979,13 +979,18 @@ void evsel__config(struct evsel *evsel, struct record_opts *opts,
> >  	if (!attr->sample_period || (opts->user_freq != UINT_MAX ||
> >  				     opts->user_interval != ULLONG_MAX)) {
> >  		if (opts->freq) {
> > -			evsel__set_sample_bit(evsel, PERIOD);
> >  			attr->freq		= 1;
> >  			attr->sample_freq	= opts->freq;
> >  		} else {
> >  			attr->sample_period = opts->default_interval;
> >  		}
> >  	}
> > +	/*
> > +	 * If attr->freq was set (here or earlier), ask for period
> > +	 * to be sampled.
> > +	 */
> > +	if (attr->freq)
> > +		evsel__set_sample_bit(evsel, PERIOD);
> >  
> >  	if (opts->no_samples)
> >  		attr->sample_freq = 0;
> > -- 
> > 2.28.0.163.g6104cc2f0b6-goog
> > 
> 

-- 

- Arnaldo

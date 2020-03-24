Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8D23190AE4
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 11:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbgCXK0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 06:26:14 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:49339 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727130AbgCXK0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 06:26:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585045573;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TI9J12sTDb0Vpr1mpuy5hfvmrFn3PMyYGmmiVFdQMGA=;
        b=WqRb7UfTMW+TJGzAQC+DhGQa/0E+1YwDUhP5hVoIlL0AeST+uWJZ3zyrklHJf7iNM5hm6q
        Pfz2r3jUMgDIyaMHNu8qVQHie4l64b0FUaa46UqMd7ioQkHBtzD05K+9lDh3KMFF9LKHVs
        hOfRmtfHUSYjCJ2VCIdAzJjR166/5fk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-gMheyZxdMLWKB16HPk3-Lw-1; Tue, 24 Mar 2020 06:26:09 -0400
X-MC-Unique: gMheyZxdMLWKB16HPk3-Lw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A016107ACC7;
        Tue, 24 Mar 2020 10:26:05 +0000 (UTC)
Received: from krava (unknown [10.40.192.119])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 97B6A60BE0;
        Tue, 24 Mar 2020 10:25:59 +0000 (UTC)
Date:   Tue, 24 Mar 2020 11:25:57 +0100
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
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Igor Lubashev <ilubashe@akamai.com>,
        Alexey Budankov <alexey.budankov@linux.intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Jiwei Sun <jiwei.sun@windriver.com>,
        yuzhoujian <yuzhoujian@didichuxing.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Leo Yan <leo.yan@linaro.org>,
        John Garry <john.garry@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v5] perf tools: add support for libpfm4
Message-ID: <20200324102557.GN1534489@krava>
References: <20200323235846.104937-1-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323235846.104937-1-irogers@google.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 23, 2020 at 04:58:46PM -0700, Ian Rogers wrote:

SNIP

> +		/* no event */
> +		if (*q == '\0')
> +			continue;
> +
> +		memset(&attr, 0, sizeof(attr));
> +		event_attr_init(&attr);
> +
> +		ret = parse_libpfm_event(q, &attr);
> +		if (ret != PFM_SUCCESS) {
> +			fprintf(stderr, "failed to parse event %s : %s\n", str, pfm_strerror(ret));
> +			goto error;
> +		}
> +
> +		evsel = perf_evsel__new_idx(&attr, evlist->core.nr_entries);
> +		if (evsel == NULL)
> +			goto error;
> +
> +		evsel->name = strdup(q);
> +		if (!evsel->name) {
> +			evsel__delete(evsel);
> +			goto error;
> +		}
> +		evsel->is_libpfm_event = true;
> +
> +		pmu = perf_pmu__find_by_type((unsigned)attr.type);
> +		if (pmu)
> +			evsel->core.own_cpus = perf_cpu_map__get(pmu->cpus);

I think you need to do more setup in here, like in __add_event function
would be great to factor those bits from __add_event function and call
it from here, so it's all in one place

jirka


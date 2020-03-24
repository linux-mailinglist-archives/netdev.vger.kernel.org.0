Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 002F1190AF1
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 11:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbgCXK1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 06:27:33 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:47337 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727159AbgCXK1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 06:27:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585045651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fX9AvyJtx+an2xNdor76lpMhrpg4TBL76cAdmDBBOik=;
        b=DI/3txcSsh7JxZAM8HvVnKJZKfLjtfOZrgEGWtXdKKTIB1IHGweG7fC+zJBQU2Dag71fGe
        32DdqGqqRQ7YqA0VkKOur5fHdGh2kkmbYlNbU7tsrQ0ia6I6p76lSXezaaJNeprnporgeF
        MEq0n95hpIJ1vkE48QS5jQEeuSaDZgY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-gelj7AS_NCy0l9A8FALZTw-1; Tue, 24 Mar 2020 06:27:29 -0400
X-MC-Unique: gelj7AS_NCy0l9A8FALZTw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F9BD100550D;
        Tue, 24 Mar 2020 10:27:26 +0000 (UTC)
Received: from krava (unknown [10.40.192.119])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 668918F342;
        Tue, 24 Mar 2020 10:27:20 +0000 (UTC)
Date:   Tue, 24 Mar 2020 11:27:17 +0100
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
Message-ID: <20200324102717.GQ1534489@krava>
References: <20200323235846.104937-1-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323235846.104937-1-irogers@google.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 23, 2020 at 04:58:46PM -0700, Ian Rogers wrote:

SNIP

> +
> +int parse_libpfm_events_option(const struct option *opt, const char *str,
> +			int unset __maybe_unused)
> +{
> +	struct evlist *evlist = *(struct evlist **)opt->value;
> +	struct perf_event_attr attr;
> +	struct perf_pmu *pmu;
> +	struct evsel *evsel, *grp_leader = NULL;
> +	char *p, *q, *p_orig;
> +	const char *sep;
> +	int grp_evt = -1;
> +	int ret;
> +
> +	p_orig = p = strdup(str);
> +	if (!p)
> +		return -1;
> +	/*
> +	 * force loading of the PMU list
> +	 */
> +	perf_pmu__scan(NULL);
> +
> +	for (q = p; strsep(&p, ",{}"); q = p) {

it seems like this code could be really easily testtable,
could you please write simple test for this?

thanks,
jirka


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44F21190ADF
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 11:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbgCXKZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 06:25:57 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:48221 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727330AbgCXKZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 06:25:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585045555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YRjdfdefaqhNj49BdQQDHV2kO4Tm7PbH4nOc30QhTz4=;
        b=R92wT0DnvpeZ7hoY+nzP40lfmdh4TxRjhIF2KlQab+rEmmCikTsAg/5SIXGu7oGulE3UdT
        HeJLEjvLD8AFOnMctCmBIQHKLuOImEYqOsiV4rzfN8MeH0hLt38NfzNtBiMBz7m1rgLoE9
        vv/i6VmpppKWJPc9zG5+Sl+QoFENlEI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-259-TG1H4V6LM1KBS-ysRkT1Bw-1; Tue, 24 Mar 2020 06:25:54 -0400
X-MC-Unique: TG1H4V6LM1KBS-ysRkT1Bw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 62E51800D5A;
        Tue, 24 Mar 2020 10:25:50 +0000 (UTC)
Received: from krava (unknown [10.40.192.119])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7C3F6BBBC2;
        Tue, 24 Mar 2020 10:25:34 +0000 (UTC)
Date:   Tue, 24 Mar 2020 11:25:28 +0100
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
Message-ID: <20200324102528.GM1534489@krava>
References: <20200323235846.104937-1-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323235846.104937-1-irogers@google.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 23, 2020 at 04:58:46PM -0700, Ian Rogers wrote:

SNIP

> diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
> index 616fbda7c3fc..11421f5dc9cb 100644
> --- a/tools/perf/util/pmu.c
> +++ b/tools/perf/util/pmu.c
> @@ -869,6 +869,17 @@ static struct perf_pmu *pmu_find(const char *name)
>  	return NULL;
>  }
>  
> +struct perf_pmu *perf_pmu__find_by_type(unsigned int type)
> +{
> +	struct perf_pmu *pmu;
> +
> +	list_for_each_entry(pmu, &pmus, list)
> +		if (pmu->type == type)
> +			return pmu;
> +
> +	return NULL;
> +}

please move this to separate patch

thanks,
jirka

> +
>  struct perf_pmu *perf_pmu__scan(struct perf_pmu *pmu)
>  {
>  	/*
> diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
> index 5fb3f16828df..de3b868d912c 100644
> --- a/tools/perf/util/pmu.h
> +++ b/tools/perf/util/pmu.h
> @@ -65,6 +65,7 @@ struct perf_pmu_alias {
>  };
>  
>  struct perf_pmu *perf_pmu__find(const char *name);
> +struct perf_pmu *perf_pmu__find_by_type(unsigned int type);
>  int perf_pmu__config(struct perf_pmu *pmu, struct perf_event_attr *attr,
>  		     struct list_head *head_terms,
>  		     struct parse_events_error *error);
> -- 
> 2.25.1.696.g5e7596f4ac-goog
> 


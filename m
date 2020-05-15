Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8C21D5C73
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 00:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgEOWlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 18:41:55 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:24764 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726238AbgEOWly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 18:41:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589582513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UL8fOqZTfdv9oaZOkGUT1dwItLiG3P0x4wkHssJgnAs=;
        b=YG2IKlNXKGGESBWlpBg+YAYyaOLyKs0cjZBl7IJYFlfnMEKflGox/nifPhbihgppsoNcxO
        VqIrUXp7TR8yjd3ekq3DTlyQGOa2rKos6PNWkFkMoFES1vLQno5NsedfQ6FkG3iqb6UT8O
        BsYrUKcOqjHsgXyWXnHxJCosRDhNl5Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-Sv82uqk7PmSG4lAKL9NIow-1; Fri, 15 May 2020 18:41:49 -0400
X-MC-Unique: Sv82uqk7PmSG4lAKL9NIow-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D39D7107ACCD;
        Fri, 15 May 2020 22:41:45 +0000 (UTC)
Received: from krava (unknown [10.40.192.69])
        by smtp.corp.redhat.com (Postfix) with SMTP id 35F945D9C9;
        Fri, 15 May 2020 22:41:40 +0000 (UTC)
Date:   Sat, 16 May 2020 00:41:39 +0200
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
        Adrian Hunter <adrian.hunter@intel.com>,
        Leo Yan <leo.yan@linaro.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v2 7/7] perf expr: Migrate expr ids table to a hashmap
Message-ID: <20200515224139.GB3577540@krava>
References: <20200515165007.217120-1-irogers@google.com>
 <20200515165007.217120-8-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515165007.217120-8-irogers@google.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 09:50:07AM -0700, Ian Rogers wrote:

SNIP

> diff --git a/tools/perf/util/expr.c b/tools/perf/util/expr.c
> index 8b4ce704a68d..f64ab91c432b 100644
> --- a/tools/perf/util/expr.c
> +++ b/tools/perf/util/expr.c
> @@ -4,25 +4,76 @@
>  #include "expr.h"
>  #include "expr-bison.h"
>  #include "expr-flex.h"
> +#include <linux/kernel.h>
>  
>  #ifdef PARSER_DEBUG
>  extern int expr_debug;
>  #endif
>  
> +static size_t key_hash(const void *key, void *ctx __maybe_unused)
> +{
> +	const char *str = (const char *)key;
> +	size_t hash = 0;
> +
> +	while (*str != '\0') {
> +		hash *= 31;
> +		hash += *str;
> +		str++;
> +	}
> +	return hash;
> +}
> +
> +static bool key_equal(const void *key1, const void *key2,
> +		    void *ctx __maybe_unused)
> +{
> +	return !strcmp((const char *)key1, (const char *)key2);

should that be strcasecmp ? would it affect the key_hash as well?

jirka


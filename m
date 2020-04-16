Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54CC51ABD68
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 11:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504501AbgDPJ4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 05:56:11 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:52181 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2504147AbgDPJ4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 05:56:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587030966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Lc+yq/vS8URFnXpc64MoW39Z5tJ2hW9F4KCw+f7L+9Y=;
        b=MYvkiXit4vyOFBpwCtXamuRL+nF4hnyC71La6wca05DoRk4e8cTLF8F7tJ+sPHJXjqR7Ap
        GL2r60Wj3svOdwsmIXVuherpwLPFdVd38t5pPjIliwmuonxBoWWPZoMg6OlhDvQpc3dvPQ
        0Fj8G6oYZX/lZF+EpJdTVbFEDiR7gqQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-e75isgY2Mlqqj38w2wFCoA-1; Thu, 16 Apr 2020 05:56:00 -0400
X-MC-Unique: e75isgY2Mlqqj38w2wFCoA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B5238018A3;
        Thu, 16 Apr 2020 09:55:57 +0000 (UTC)
Received: from krava (unknown [10.40.195.119])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 206AE60BF3;
        Thu, 16 Apr 2020 09:55:50 +0000 (UTC)
Date:   Thu, 16 Apr 2020 11:55:48 +0200
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
Subject: Re: [PATCH v9 4/4] perf tools: add support for libpfm4
Message-ID: <20200416095548.GD369437@krava>
References: <20200416063551.47637-1-irogers@google.com>
 <20200416063551.47637-5-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200416063551.47637-5-irogers@google.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 15, 2020 at 11:35:51PM -0700, Ian Rogers wrote:

SNIP

> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 1ab349abe904..80ac598f125b 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -43,6 +43,7 @@
>  #include "util/time-utils.h"
>  #include "util/units.h"
>  #include "util/bpf-event.h"
> +#include "util/pfm.h"
>  #include "asm/bug.h"
>  #include "perf.h"
>  
> @@ -64,6 +65,9 @@
>  #include <linux/zalloc.h>
>  #include <linux/bitmap.h>
>  
> +
> +
> +

extra new lines..

jirka

>  struct switch_output {
>  	bool		 enabled;
>  	bool		 signal;
> @@ -2421,6 +2425,11 @@ static struct option __record_options[] = {
>  #endif
>  	OPT_CALLBACK(0, "max-size", &record.output_max_size,
>  		     "size", "Limit the maximum size of the output file", parse_output_max_size),
> +#ifdef HAVE_LIBPFM
> +	OPT_CALLBACK(0, "pfm-events", &record.evlist, "event",
> +		"libpfm4 event selector. use 'perf list' to list available events",
> +		parse_libpfm_events_option),
> +#endif
>  	OPT_END()
>  };

SNIP


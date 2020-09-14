Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 919E82698FF
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 00:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbgINWgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 18:36:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726031AbgINWgE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 18:36:04 -0400
Received: from quaco.ghostprotocols.net (unknown [179.97.37.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E296A20732;
        Mon, 14 Sep 2020 22:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600122964;
        bh=iyTRP9xb115YSwNnAmaJ8c2Ffk0qyORigb9cgRe92iM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L4piqai68TzqSmMJT3ckXkEvMZth9f8EFVVoUNar/JdMUxnI8rJFqsf2umpnGom3u
         10p7OmjtUwso19m4ys3bPWVK+n55Y3H/Cbo6AxR8EIGzJRqNbWYMEWr2CgwWmGyPeQ
         Te+dR1mNku2fXT7rMmG0LogPr/m0pyWhWjpN+Mlo=
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 0919E40D3D; Mon, 14 Sep 2020 19:36:02 -0300 (-03)
Date:   Mon, 14 Sep 2020 19:36:01 -0300
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
Subject: Re: [PATCH v3 4/4] perf test: Leader sampling shouldn't clear sample
 period
Message-ID: <20200914223601.GJ166601@kernel.org>
References: <20200912025655.1337192-1-irogers@google.com>
 <20200912025655.1337192-5-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200912025655.1337192-5-irogers@google.com>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, Sep 11, 2020 at 07:56:55PM -0700, Ian Rogers escreveu:
> Add test that a sibling with leader sampling doesn't have its period
> cleared.

Thanks, applied and collected Jiri's Acks for [34]/4 and Adrian's for
3/4.

- Arnaldo
 
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  tools/perf/tests/attr/README             |  1 +
>  tools/perf/tests/attr/test-record-group2 | 29 ++++++++++++++++++++++++
>  2 files changed, 30 insertions(+)
>  create mode 100644 tools/perf/tests/attr/test-record-group2
> 
> diff --git a/tools/perf/tests/attr/README b/tools/perf/tests/attr/README
> index 6cd408108595..a36f49fb4dbe 100644
> --- a/tools/perf/tests/attr/README
> +++ b/tools/perf/tests/attr/README
> @@ -49,6 +49,7 @@ Following tests are defined (with perf commands):
>    perf record --call-graph fp kill              (test-record-graph-fp)
>    perf record --group -e cycles,instructions kill (test-record-group)
>    perf record -e '{cycles,instructions}' kill   (test-record-group1)
> +  perf record -e '{cycles/period=1/,instructions/period=2/}:S' kill (test-record-group2)
>    perf record -D kill                           (test-record-no-delay)
>    perf record -i kill                           (test-record-no-inherit)
>    perf record -n kill                           (test-record-no-samples)
> diff --git a/tools/perf/tests/attr/test-record-group2 b/tools/perf/tests/attr/test-record-group2
> new file mode 100644
> index 000000000000..6b9f8d182ce1
> --- /dev/null
> +++ b/tools/perf/tests/attr/test-record-group2
> @@ -0,0 +1,29 @@
> +[config]
> +command = record
> +args    = --no-bpf-event -e '{cycles/period=1234000/,instructions/period=6789000/}:S' kill >/dev/null 2>&1
> +ret     = 1
> +
> +[event-1:base-record]
> +fd=1
> +group_fd=-1
> +config=0|1
> +sample_period=1234000
> +sample_type=87
> +read_format=12
> +inherit=0
> +freq=0
> +
> +[event-2:base-record]
> +fd=2
> +group_fd=1
> +config=0|1
> +sample_period=6789000
> +sample_type=87
> +read_format=12
> +disabled=0
> +inherit=0
> +mmap=0
> +comm=0
> +freq=0
> +enable_on_exec=0
> +task=0
> -- 
> 2.28.0.618.gf4bc123cb7-goog
> 

-- 

- Arnaldo

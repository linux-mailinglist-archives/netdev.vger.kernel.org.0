Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2DB04B899E
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 14:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233886AbiBPNVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 08:21:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231818AbiBPNTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 08:19:32 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2BD5C29B9C2;
        Wed, 16 Feb 2022 05:18:45 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 87532106F;
        Wed, 16 Feb 2022 05:18:45 -0800 (PST)
Received: from [10.1.31.148] (e127744.cambridge.arm.com [10.1.31.148])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 017123F66F;
        Wed, 16 Feb 2022 05:18:41 -0800 (PST)
Subject: Re: [PATCH] perf test: update arm64 perf_event_attr tests for
 --call-graph
To:     linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        acme@kernel.org
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        James Clark <james.clark@arm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Alexandre Truong <alexandre.truong@arm.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, irogers@google.com
References: <20220125104435.2737-1-german.gomez@arm.com>
From:   German Gomez <german.gomez@arm.com>
Message-ID: <622a42bd-69da-0df4-bbf3-7d21de77c73b@arm.com>
Date:   Wed, 16 Feb 2022 13:17:56 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220125104435.2737-1-german.gomez@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Friendly ping on this perf-test fix for arm64

I will include some quick test notes:
Before:

$ ./perf test 17 -v
17: Setup struct perf_event_attr
[...]
running './tests/attr/test-record-graph-default'
expected sample_type=295, got 4391
expected sample_regs_user=0, got 1073741824
FAILED './tests/attr/test-record-graph-default' - match failure
test child finished with -1
---- end ----

After:

[...]
running './tests/attr/test-record-graph-default-aarch64'
test limitation 'aarch64'
running './tests/attr/test-record-graph-fp-aarch64'
test limitation 'aarch64'
running './tests/attr/test-record-graph-default'
test limitation '!aarch64'
excluded architecture list ['aarch64']
skipped [aarch64] './tests/attr/test-record-graph-default'
running './tests/attr/test-record-graph-fp'
test limitation '!aarch64'
excluded architecture list ['aarch64']
skipped [aarch64] './tests/attr/test-record-graph-fp'
[...]

Thanks,
German

On 25/01/2022 10:44, German Gomez wrote:
> The struct perf_event_attr is initialised differently in Arm64 when
> recording in call-graph fp mode, so update the relevant tests, and add
> two extra arm64-only tests.
>
> Fixes: 7248e308a575 ("perf tools: Record ARM64 LR register automatically")
> Signed-off-by: German Gomez <german.gomez@arm.com>
> ---
>  tools/perf/tests/attr/README                            | 2 ++
>  tools/perf/tests/attr/test-record-graph-default         | 2 ++
>  tools/perf/tests/attr/test-record-graph-default-aarch64 | 9 +++++++++
>  tools/perf/tests/attr/test-record-graph-fp              | 2 ++
>  tools/perf/tests/attr/test-record-graph-fp-aarch64      | 9 +++++++++
>  5 files changed, 24 insertions(+)
>  create mode 100644 tools/perf/tests/attr/test-record-graph-default-aarch64
>  create mode 100644 tools/perf/tests/attr/test-record-graph-fp-aarch64
>
> diff --git a/tools/perf/tests/attr/README b/tools/perf/tests/attr/README
> index a36f49fb4dbe..1116fc6bf2ac 100644
> --- a/tools/perf/tests/attr/README
> +++ b/tools/perf/tests/attr/README
> @@ -45,8 +45,10 @@ Following tests are defined (with perf commands):
>    perf record -d kill                           (test-record-data)
>    perf record -F 100 kill                       (test-record-freq)
>    perf record -g kill                           (test-record-graph-default)
> +  perf record -g kill                           (test-record-graph-default-aarch64)
>    perf record --call-graph dwarf kill		(test-record-graph-dwarf)
>    perf record --call-graph fp kill              (test-record-graph-fp)
> +  perf record --call-graph fp kill              (test-record-graph-fp-aarch64)
>    perf record --group -e cycles,instructions kill (test-record-group)
>    perf record -e '{cycles,instructions}' kill   (test-record-group1)
>    perf record -e '{cycles/period=1/,instructions/period=2/}:S' kill (test-record-group2)
> diff --git a/tools/perf/tests/attr/test-record-graph-default b/tools/perf/tests/attr/test-record-graph-default
> index 5d8234d50845..f0a18b4ea4f5 100644
> --- a/tools/perf/tests/attr/test-record-graph-default
> +++ b/tools/perf/tests/attr/test-record-graph-default
> @@ -2,6 +2,8 @@
>  command = record
>  args    = --no-bpf-event -g kill >/dev/null 2>&1
>  ret     = 1
> +# arm64 enables registers in the default mode (fp)
> +arch    = !aarch64
>  
>  [event:base-record]
>  sample_type=295
> diff --git a/tools/perf/tests/attr/test-record-graph-default-aarch64 b/tools/perf/tests/attr/test-record-graph-default-aarch64
> new file mode 100644
> index 000000000000..e98d62efb6f7
> --- /dev/null
> +++ b/tools/perf/tests/attr/test-record-graph-default-aarch64
> @@ -0,0 +1,9 @@
> +[config]
> +command = record
> +args    = --no-bpf-event -g kill >/dev/null 2>&1
> +ret     = 1
> +arch    = aarch64
> +
> +[event:base-record]
> +sample_type=4391
> +sample_regs_user=1073741824
> diff --git a/tools/perf/tests/attr/test-record-graph-fp b/tools/perf/tests/attr/test-record-graph-fp
> index 5630521c0b0f..a6e60e839205 100644
> --- a/tools/perf/tests/attr/test-record-graph-fp
> +++ b/tools/perf/tests/attr/test-record-graph-fp
> @@ -2,6 +2,8 @@
>  command = record
>  args    = --no-bpf-event --call-graph fp kill >/dev/null 2>&1
>  ret     = 1
> +# arm64 enables registers in fp mode
> +arch    = !aarch64
>  
>  [event:base-record]
>  sample_type=295
> diff --git a/tools/perf/tests/attr/test-record-graph-fp-aarch64 b/tools/perf/tests/attr/test-record-graph-fp-aarch64
> new file mode 100644
> index 000000000000..cbeea9971285
> --- /dev/null
> +++ b/tools/perf/tests/attr/test-record-graph-fp-aarch64
> @@ -0,0 +1,9 @@
> +[config]
> +command = record
> +args    = --no-bpf-event --call-graph fp kill >/dev/null 2>&1
> +ret     = 1
> +arch    = aarch64
> +
> +[event:base-record]
> +sample_type=4391
> +sample_regs_user=1073741824

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 404054C7041
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 16:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237121AbiB1PGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 10:06:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231941AbiB1PGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 10:06:05 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8B97B76E0B;
        Mon, 28 Feb 2022 07:05:26 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 49749ED1;
        Mon, 28 Feb 2022 07:05:26 -0800 (PST)
Received: from [10.57.40.132] (unknown [10.57.40.132])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 317593F73D;
        Mon, 28 Feb 2022 07:05:23 -0800 (PST)
Message-ID: <fb98e7fd-bf0f-bc3b-ad2a-2775d2ef321d@arm.com>
Date:   Mon, 28 Feb 2022 15:05:21 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] perf test: Add perf_event_attr tests for the arm_spe
 event
Content-Language: en-US
To:     German Gomez <german.gomez@arm.com>, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, acme@kernel.org
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20220126160710.32983-1-german.gomez@arm.com>
From:   James Clark <james.clark@arm.com>
In-Reply-To: <20220126160710.32983-1-german.gomez@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26/01/2022 16:07, German Gomez wrote:
> Adds a couple of perf_event_attr tests for the fix introduced in [1].
> The tests check that the correct sample_period value is set in the
> struct perf_event_attr of the arm_spe events.
> 
> [1]: https://lore.kernel.org/all/20220118144054.2541-1-german.gomez@arm.com/
> 
> Signed-off-by: German Gomez <german.gomez@arm.com>

Reviewed-by: James Clark <james.clark@arm.com>

> ---
>  tools/perf/tests/attr/README                  |  2 +
>  tools/perf/tests/attr/base-record-spe         | 40 +++++++++++++++++++
>  tools/perf/tests/attr/test-record-spe-period  | 12 ++++++
>  .../tests/attr/test-record-spe-period-term    | 12 ++++++
>  4 files changed, 66 insertions(+)
>  create mode 100644 tools/perf/tests/attr/base-record-spe
>  create mode 100644 tools/perf/tests/attr/test-record-spe-period
>  create mode 100644 tools/perf/tests/attr/test-record-spe-period-term
> 
> diff --git a/tools/perf/tests/attr/README b/tools/perf/tests/attr/README
> index 1116fc6bf2ac..454505d343fa 100644
> --- a/tools/perf/tests/attr/README
> +++ b/tools/perf/tests/attr/README
> @@ -58,6 +58,8 @@ Following tests are defined (with perf commands):
>    perf record -c 100 -P kill                    (test-record-period)
>    perf record -c 1 --pfm-events=cycles:period=2 (test-record-pfm-period)
>    perf record -R kill                           (test-record-raw)
> +  perf record -c 2 -e arm_spe_0// -- kill       (test-record-spe-period)
> +  perf record -e arm_spe_0/period=3/ -- kill    (test-record-spe-period-term)
>    perf stat -e cycles kill                      (test-stat-basic)
>    perf stat kill                                (test-stat-default)
>    perf stat -d kill                             (test-stat-detailed-1)
> diff --git a/tools/perf/tests/attr/base-record-spe b/tools/perf/tests/attr/base-record-spe
> new file mode 100644
> index 000000000000..08fa96b59240
> --- /dev/null
> +++ b/tools/perf/tests/attr/base-record-spe
> @@ -0,0 +1,40 @@
> +[event]
> +fd=*
> +group_fd=-1
> +flags=*
> +cpu=*
> +type=*
> +size=*
> +config=*
> +sample_period=*
> +sample_type=*
> +read_format=*
> +disabled=*
> +inherit=*
> +pinned=*
> +exclusive=*
> +exclude_user=*
> +exclude_kernel=*
> +exclude_hv=*
> +exclude_idle=*
> +mmap=*
> +comm=*
> +freq=*
> +inherit_stat=*
> +enable_on_exec=*
> +task=*
> +watermark=*
> +precise_ip=*
> +mmap_data=*
> +sample_id_all=*
> +exclude_host=*
> +exclude_guest=*
> +exclude_callchain_kernel=*
> +exclude_callchain_user=*
> +wakeup_events=*
> +bp_type=*
> +config1=*
> +config2=*
> +branch_sample_type=*
> +sample_regs_user=*
> +sample_stack_user=*
> diff --git a/tools/perf/tests/attr/test-record-spe-period b/tools/perf/tests/attr/test-record-spe-period
> new file mode 100644
> index 000000000000..75f8c9cd8e3f
> --- /dev/null
> +++ b/tools/perf/tests/attr/test-record-spe-period
> @@ -0,0 +1,12 @@
> +[config]
> +command = record
> +args    = --no-bpf-event -c 2 -e arm_spe_0// -- kill >/dev/null 2>&1
> +ret     = 1
> +arch    = aarch64
> +
> +[event-10:base-record-spe]
> +sample_period=2
> +freq=0
> +
> +# dummy event
> +[event-1:base-record-spe]
> diff --git a/tools/perf/tests/attr/test-record-spe-period-term b/tools/perf/tests/attr/test-record-spe-period-term
> new file mode 100644
> index 000000000000..8f60a4fec657
> --- /dev/null
> +++ b/tools/perf/tests/attr/test-record-spe-period-term
> @@ -0,0 +1,12 @@
> +[config]
> +command = record
> +args    = --no-bpf-event -e arm_spe_0/period=3/ -- kill >/dev/null 2>&1
> +ret     = 1
> +arch    = aarch64
> +
> +[event-10:base-record-spe]
> +sample_period=3
> +freq=0
> +
> +# dummy event
> +[event-1:base-record-spe]

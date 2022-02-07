Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 607634AB9A7
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 12:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239955AbiBGLGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 06:06:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350675AbiBGK6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 05:58:34 -0500
X-Greylist: delayed 446 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Feb 2022 02:58:33 PST
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8B6EDC043181;
        Mon,  7 Feb 2022 02:58:33 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 121B011B3;
        Mon,  7 Feb 2022 02:51:07 -0800 (PST)
Received: from [10.57.86.115] (unknown [10.57.86.115])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 141953F73B;
        Mon,  7 Feb 2022 02:51:03 -0800 (PST)
Subject: Re: [PATCH] perf test: Add perf_event_attr tests for the arm_spe
 event
To:     Leo Yan <leo.yan@linaro.org>
Cc:     linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        acme@kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20220126160710.32983-1-german.gomez@arm.com>
 <20220205081013.GA391033@leoy-ThinkPad-X240s>
From:   German Gomez <german.gomez@arm.com>
Message-ID: <37a1a2f9-2c94-664f-19fb-8337029b8fe5@arm.com>
Date:   Mon, 7 Feb 2022 10:50:26 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220205081013.GA391033@leoy-ThinkPad-X240s>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Leo, thanks for checking this

On 05/02/2022 08:10, Leo Yan wrote:
> Hi German,
>
> On Wed, Jan 26, 2022 at 04:07:09PM +0000, German Gomez wrote:
>> Adds a couple of perf_event_attr tests for the fix introduced in [1].
>> The tests check that the correct sample_period value is set in the
>> struct perf_event_attr of the arm_spe events.
>>
>> [1]: https://lore.kernel.org/all/20220118144054.2541-1-german.gomez@arm.com/
>>
>> Signed-off-by: German Gomez <german.gomez@arm.com>
> I tested this patch with two commands:
>
> # PERF_TEST_ATTR=/tmp /usr/bin/python2 ./tests/attr.py -d ./tests/attr/ \
>         -p ./perf -vvvvv -t test-record-spe-period
> # PERF_TEST_ATTR=/tmp /usr/bin/python2 ./tests/attr.py -d ./tests/attr/ \
>         -p ./perf -vvvvv -t test-record-spe-period-term
>
> Both testing can pass on Hisilicon D06 board.
>
> One question: I'm a bit concern this case will fail on some Arm64
> platforms which doesn't contain Arm SPE modules.  E.g. below commands
> will always fail on Arm64 platforms if SPE module is absent.  So I am
> wandering if we can add extra checking ARM SPE event is existed or not?
 
The test reports "unsupported" if the return code and the 'ret' field don't match.

When I unload the SPE module:

running './tests/attr//test-record-spe-period-term'
test limitation 'aarch64'
unsupp  './tests/attr//test-record-spe-period-term'

>
>   # ./perf test list
>    17: Setup struct perf_event_attr
>   # ./perf test 17
>
> Thanks,
> Leo
>
>> ---
>>  tools/perf/tests/attr/README                  |  2 +
>>  tools/perf/tests/attr/base-record-spe         | 40 +++++++++++++++++++
>>  tools/perf/tests/attr/test-record-spe-period  | 12 ++++++
>>  .../tests/attr/test-record-spe-period-term    | 12 ++++++
>>  4 files changed, 66 insertions(+)
>>  create mode 100644 tools/perf/tests/attr/base-record-spe
>>  create mode 100644 tools/perf/tests/attr/test-record-spe-period
>>  create mode 100644 tools/perf/tests/attr/test-record-spe-period-term
>>
>> diff --git a/tools/perf/tests/attr/README b/tools/perf/tests/attr/README
>> index 1116fc6bf2ac..454505d343fa 100644
>> --- a/tools/perf/tests/attr/README
>> +++ b/tools/perf/tests/attr/README
>> @@ -58,6 +58,8 @@ Following tests are defined (with perf commands):
>>    perf record -c 100 -P kill                    (test-record-period)
>>    perf record -c 1 --pfm-events=cycles:period=2 (test-record-pfm-period)
>>    perf record -R kill                           (test-record-raw)
>> +  perf record -c 2 -e arm_spe_0// -- kill       (test-record-spe-period)
>> +  perf record -e arm_spe_0/period=3/ -- kill    (test-record-spe-period-term)
>>    perf stat -e cycles kill                      (test-stat-basic)
>>    perf stat kill                                (test-stat-default)
>>    perf stat -d kill                             (test-stat-detailed-1)
>> diff --git a/tools/perf/tests/attr/base-record-spe b/tools/perf/tests/attr/base-record-spe
>> new file mode 100644
>> index 000000000000..08fa96b59240
>> --- /dev/null
>> +++ b/tools/perf/tests/attr/base-record-spe
>> @@ -0,0 +1,40 @@
>> +[event]
>> +fd=*
>> +group_fd=-1
>> +flags=*
>> +cpu=*
>> +type=*
>> +size=*
>> +config=*
>> +sample_period=*
>> +sample_type=*
>> +read_format=*
>> +disabled=*
>> +inherit=*
>> +pinned=*
>> +exclusive=*
>> +exclude_user=*
>> +exclude_kernel=*
>> +exclude_hv=*
>> +exclude_idle=*
>> +mmap=*
>> +comm=*
>> +freq=*
>> +inherit_stat=*
>> +enable_on_exec=*
>> +task=*
>> +watermark=*
>> +precise_ip=*
>> +mmap_data=*
>> +sample_id_all=*
>> +exclude_host=*
>> +exclude_guest=*
>> +exclude_callchain_kernel=*
>> +exclude_callchain_user=*
>> +wakeup_events=*
>> +bp_type=*
>> +config1=*
>> +config2=*
>> +branch_sample_type=*
>> +sample_regs_user=*
>> +sample_stack_user=*
>> diff --git a/tools/perf/tests/attr/test-record-spe-period b/tools/perf/tests/attr/test-record-spe-period
>> new file mode 100644
>> index 000000000000..75f8c9cd8e3f
>> --- /dev/null
>> +++ b/tools/perf/tests/attr/test-record-spe-period
>> @@ -0,0 +1,12 @@
>> +[config]
>> +command = record
>> +args    = --no-bpf-event -c 2 -e arm_spe_0// -- kill >/dev/null 2>&1
>> +ret     = 1
>> +arch    = aarch64
>> +
>> +[event-10:base-record-spe]
>> +sample_period=2
>> +freq=0
>> +
>> +# dummy event
>> +[event-1:base-record-spe]
>> diff --git a/tools/perf/tests/attr/test-record-spe-period-term b/tools/perf/tests/attr/test-record-spe-period-term
>> new file mode 100644
>> index 000000000000..8f60a4fec657
>> --- /dev/null
>> +++ b/tools/perf/tests/attr/test-record-spe-period-term
>> @@ -0,0 +1,12 @@
>> +[config]
>> +command = record
>> +args    = --no-bpf-event -e arm_spe_0/period=3/ -- kill >/dev/null 2>&1
>> +ret     = 1
>> +arch    = aarch64
>> +
>> +[event-10:base-record-spe]
>> +sample_period=3
>> +freq=0
>> +
>> +# dummy event
>> +[event-1:base-record-spe]
>> -- 
>> 2.25.1
>>

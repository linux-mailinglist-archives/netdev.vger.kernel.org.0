Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 674EA50DC3D
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 11:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235195AbiDYJQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 05:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238730AbiDYJPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 05:15:45 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3092ADF2C;
        Mon, 25 Apr 2022 02:12:41 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AA9821FB;
        Mon, 25 Apr 2022 02:12:40 -0700 (PDT)
Received: from [10.57.13.137] (unknown [10.57.13.137])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0139C3F73B;
        Mon, 25 Apr 2022 02:12:37 -0700 (PDT)
Message-ID: <322009d2-330c-22d4-4075-eca2042f64e1@arm.com>
Date:   Mon, 25 Apr 2022 10:12:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 2/3] perf: arm-spe: Fix SPE events with phys addresses
Content-Language: en-US
To:     Leo Yan <leo.yan@linaro.org>, Timothy Hayes <timothy.hayes@arm.com>
Cc:     linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        acme@kernel.org, John Garry <john.garry@huawei.com>,
        Will Deacon <will@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20220421165205.117662-1-timothy.hayes@arm.com>
 <20220421165205.117662-3-timothy.hayes@arm.com>
 <20220424125951.GD978927@leoy-ThinkPad-X240s>
From:   James Clark <james.clark@arm.com>
In-Reply-To: <20220424125951.GD978927@leoy-ThinkPad-X240s>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 24/04/2022 13:59, Leo Yan wrote:
> Hi Timothy,
> 
> On Thu, Apr 21, 2022 at 05:52:04PM +0100, Timothy Hayes wrote:
>> This patch corrects a bug whereby SPE collection is invoked with
>> pa_enable=1 but synthesized events fail to show physical addresses.
>>
>> Signed-off-by: Timothy Hayes <timothy.hayes@arm.com>
>> ---
>>  tools/perf/arch/arm64/util/arm-spe.c | 10 ++++++++++
>>  tools/perf/util/arm-spe.c            |  3 ++-
>>  2 files changed, 12 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/perf/arch/arm64/util/arm-spe.c b/tools/perf/arch/arm64/util/arm-spe.c
>> index af4d63af8072..e8b577d33e53 100644
>> --- a/tools/perf/arch/arm64/util/arm-spe.c
>> +++ b/tools/perf/arch/arm64/util/arm-spe.c
>> @@ -148,6 +148,7 @@ static int arm_spe_recording_options(struct auxtrace_record *itr,
>>  	bool privileged = perf_event_paranoid_check(-1);
>>  	struct evsel *tracking_evsel;
>>  	int err;
>> +	u64 bit;
>>  
>>  	sper->evlist = evlist;
>>  
>> @@ -245,6 +246,15 @@ static int arm_spe_recording_options(struct auxtrace_record *itr,
>>  	 */
>>  	evsel__set_sample_bit(arm_spe_evsel, DATA_SRC);
>>  
>> +	/*
>> +	 * The PHYS_ADDR flag does not affect the driver behaviour, it is used to
>> +	 * inform that the resulting output's SPE samples contain physical addresses
>> +	 * where applicable.
>> +	 */
>> +	bit = perf_pmu__format_bits(&arm_spe_pmu->format, "pa_enable");
>> +	if (arm_spe_evsel->core.attr.config & bit)
>> +		evsel__set_sample_bit(arm_spe_evsel, PHYS_ADDR);
>> +
>>  	/* Add dummy event to keep tracking */
>>  	err = parse_events(evlist, "dummy:u", NULL);
>>  	if (err)
>> diff --git a/tools/perf/util/arm-spe.c b/tools/perf/util/arm-spe.c
>> index 151cc38a171c..1a80151baed9 100644
>> --- a/tools/perf/util/arm-spe.c
>> +++ b/tools/perf/util/arm-spe.c
>> @@ -1033,7 +1033,8 @@ arm_spe_synth_events(struct arm_spe *spe, struct perf_session *session)
>>  	memset(&attr, 0, sizeof(struct perf_event_attr));
>>  	attr.size = sizeof(struct perf_event_attr);
>>  	attr.type = PERF_TYPE_HARDWARE;
>> -	attr.sample_type = evsel->core.attr.sample_type & PERF_SAMPLE_MASK;
>> +	attr.sample_type = evsel->core.attr.sample_type &
>> +				(PERF_SAMPLE_MASK | PERF_SAMPLE_PHYS_ADDR);
> 
> I verified this patch and I can confirm the physical address can be
> dumped successfully.
> 
> I have a more general question, seems to me, we need to change the
> macro PERF_SAMPLE_MASK in the file util/event.h as below, so
> here doesn't need to 'or' the flag PERF_SAMPLE_PHYS_ADDR anymore.
> 
> @Arnaldo, @Jiri, could you confirm if this is the right way to move
> forward?  I am not sure why PERF_SAMPLE_MASK doesn't contain the bit
> PERF_SAMPLE_PHYS_ADDR in current code.

I think there is a reason that PERF_SAMPLE_MASK is a subset of all the
bits. This comment below suggests it. Is it so the mask only includes fields
that are 64bits? That makes the __evsel__sample_size() function a simple
multiplication of a count of all the fields that are 64bits.

  static int
  perf_event__check_size(union perf_event *event, unsigned int sample_size)
  {
	/*
	 * The evsel's sample_size is based on PERF_SAMPLE_MASK which includes
	 * up to PERF_SAMPLE_PERIOD.  After that overflow() must be used to
	 * check the format does not go past the end of the event.
	 */
	if (sample_size + sizeof(event->header) > event->header.size)
		return -EFAULT;

	return 0;
  }

Having said that, the mask was updated once to add PERF_SAMPLE_IDENTIFIER to
it, so that comment is slightly out of date now.


> 
> diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
> index cdd72e05fd28..c905ac32ebad 100644
> --- a/tools/perf/util/event.h
> +++ b/tools/perf/util/event.h
> @@ -39,7 +39,7 @@ struct perf_event_attr;
>          PERF_SAMPLE_TIME | PERF_SAMPLE_ADDR |          \
>         PERF_SAMPLE_ID | PERF_SAMPLE_STREAM_ID |        \
>          PERF_SAMPLE_CPU | PERF_SAMPLE_PERIOD |         \
> -        PERF_SAMPLE_IDENTIFIER)
> +        PERF_SAMPLE_IDENTIFIER | PERF_SAMPLE_PHYS_ADDR)
> 
> Thanks,
> Leo
> 
>>  	attr.sample_type |= PERF_SAMPLE_IP | PERF_SAMPLE_TID |
>>  			    PERF_SAMPLE_PERIOD | PERF_SAMPLE_DATA_SRC |
>>  			    PERF_SAMPLE_WEIGHT | PERF_SAMPLE_ADDR;
>> -- 
>> 2.25.1
>>

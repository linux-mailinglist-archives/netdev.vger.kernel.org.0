Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19A675B0861
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 17:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbiIGPV2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 11:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbiIGPVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 11:21:24 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 435FCA9261;
        Wed,  7 Sep 2022 08:21:20 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2702B106F;
        Wed,  7 Sep 2022 08:21:26 -0700 (PDT)
Received: from [10.57.77.239] (unknown [10.57.77.239])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D11303F71A;
        Wed,  7 Sep 2022 08:21:15 -0700 (PDT)
Message-ID: <d5fdbae3-aaf0-e837-d7e6-05e9d3af7e4c@arm.com>
Date:   Wed, 7 Sep 2022 16:21:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 1/8] perf arm64: Send pointer auth masks to ring buffer
Content-Language: en-US
To:     "peterz@infradead.org" <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Tom Rix <trix@redhat.com>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, llvm@lists.linux.dev,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andrew Kilroy <andrew.kilroy@arm.com>
References: <20220704145333.22557-1-andrew.kilroy@arm.com>
 <20220704145333.22557-2-andrew.kilroy@arm.com> <YvOxOBzsbjX1rMdY@kernel.org>
From:   James Clark <james.clark@arm.com>
In-Reply-To: <YvOxOBzsbjX1rMdY@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-11.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/08/2022 14:23, Arnaldo Carvalho de Melo wrote:
> Em Mon, Jul 04, 2022 at 03:53:25PM +0100, Andrew Kilroy escreveu:
>> Perf report cannot produce callgraphs using dwarf on arm64 where pointer
>> authentication is enabled.  This is because libunwind and libdw cannot
>> unmangle instruction pointers that have a pointer authentication code
>> (PAC) embedded in them.
>>
>> libunwind and libdw need to be given an instruction mask which they can
>> use to arrive at the correct return address that does not contain the
>> PAC.
>>
>> The bits in the return address that contain the PAC can differ by
>> process, so this patch adds a new sample field PERF_SAMPLE_ARCH_1
>> to allow the kernel to send the masks up to userspace perf.
>>
>> This field can be used in a architecture specific fashion, but on
>> aarch64, it contains the ptrauth mask information.
> 
> I'm not seeing this kernel patch applied to tip/master or
> torvalds/master, what is the status of that part? Then I can look at the
> tooling part.
> 

Hi Peter,

I just left my review tag for the whole set, is it ok by you to apply
the first commit?

I'm not 100% sure of the process because it has some kernel/events
changes and arch/arm64 in the same commit. And I'm also not sure if
there is consensus about the new PERF_SAMPLE_ARCH_1 bit. There was a
comment from Vince Weaver but I don't agree that perf_event_open should
or can ever be completely generic so it's not a huge issue for me. And
there weren't any other comments against adding it.

Thanks
James

> - Arnaldo
>  
>> Signed-off-by: Andrew Kilroy <andrew.kilroy@arm.com>
>> ---
>>  arch/arm64/include/asm/arch_sample_data.h | 38 +++++++++++++++++++++++
>>  arch/arm64/kernel/Makefile                |  2 +-
>>  arch/arm64/kernel/arch_sample_data.c      | 37 ++++++++++++++++++++++
>>  include/linux/perf_event.h                | 24 ++++++++++++++
>>  include/uapi/linux/perf_event.h           |  5 ++-
>>  kernel/events/core.c                      | 35 +++++++++++++++++++++
>>  6 files changed, 139 insertions(+), 2 deletions(-)
>>  create mode 100644 arch/arm64/include/asm/arch_sample_data.h
>>  create mode 100644 arch/arm64/kernel/arch_sample_data.c
>>
>> diff --git a/arch/arm64/include/asm/arch_sample_data.h b/arch/arm64/include/asm/arch_sample_data.h
>> new file mode 100644
>> index 000000000000..83fda293b1fc
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/arch_sample_data.h
>> @@ -0,0 +1,38 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +
>> +#ifndef _ASM_ARCH_SAMPLE_DATA_H
>> +#define _ASM_ARCH_SAMPLE_DATA_H
>> +
>> +#include <linux/types.h>
>> +
>> +/*
>> + * Structure holding masks to help userspace stack unwinding
>> + * in the presence of arm64 pointer authentication.
>> + */
>> +struct ptrauth_info {
>> +	/*
>> +	 * Bits 0, 1, 2, 3, 4 may be set to on, to indicate which keys are being used
>> +	 * The APIAKEY, APIBKEY, APDAKEY, APDBKEY, or the APGAKEY respectively.
>> +	 * Where all bits are off, pointer authentication is not in use for the
>> +	 * process.
>> +	 */
>> +	u64 enabled_keys;
>> +
>> +	/*
>> +	 * The on bits represent which bits in an instruction pointer
>> +	 * constitute the pointer authentication code.
>> +	 */
>> +	u64 insn_mask;
>> +
>> +	/*
>> +	 * The on bits represent which bits in a data pointer constitute the
>> +	 * pointer authentication code.
>> +	 */
>> +	u64 data_mask;
>> +};
>> +
>> +struct arch_sample_data {
>> +	struct ptrauth_info ptrauth;
>> +};
>> +
>> +#endif
>> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
>> index fa7981d0d917..843c6e0e2393 100644
>> --- a/arch/arm64/kernel/Makefile
>> +++ b/arch/arm64/kernel/Makefile
>> @@ -44,7 +44,7 @@ obj-$(CONFIG_KUSER_HELPERS)		+= kuser32.o
>>  obj-$(CONFIG_FUNCTION_TRACER)		+= ftrace.o entry-ftrace.o
>>  obj-$(CONFIG_MODULES)			+= module.o
>>  obj-$(CONFIG_ARM64_MODULE_PLTS)		+= module-plts.o
>> -obj-$(CONFIG_PERF_EVENTS)		+= perf_regs.o perf_callchain.o
>> +obj-$(CONFIG_PERF_EVENTS)		+= perf_regs.o perf_callchain.o arch_sample_data.o
>>  obj-$(CONFIG_HW_PERF_EVENTS)		+= perf_event.o
>>  obj-$(CONFIG_HAVE_HW_BREAKPOINT)	+= hw_breakpoint.o
>>  obj-$(CONFIG_CPU_PM)			+= sleep.o suspend.o
>> diff --git a/arch/arm64/kernel/arch_sample_data.c b/arch/arm64/kernel/arch_sample_data.c
>> new file mode 100644
>> index 000000000000..2d47e8db0dbe
>> --- /dev/null
>> +++ b/arch/arm64/kernel/arch_sample_data.c
>> @@ -0,0 +1,37 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +
>> +#include <asm/arch_sample_data.h>
>> +#include <linux/perf_event.h>
>> +
>> +inline void perf_output_sample_arch_1(struct perf_output_handle *handle,
>> +				      struct perf_event_header *header,
>> +				      struct perf_sample_data *data,
>> +				      struct perf_event *event)
>> +{
>> +	perf_output_put(handle, data->arch.ptrauth.enabled_keys);
>> +	perf_output_put(handle, data->arch.ptrauth.insn_mask);
>> +	perf_output_put(handle, data->arch.ptrauth.data_mask);
>> +}
>> +
>> +inline void perf_prepare_sample_arch_1(struct perf_event_header *header,
>> +				       struct perf_sample_data *data,
>> +				       struct perf_event *event,
>> +				       struct pt_regs *regs)
>> +{
>> +	struct task_struct *task = current;
>> +	int keys_result = ptrauth_get_enabled_keys(task);
>> +	u64 user_pac_mask = keys_result > 0 ? ptrauth_user_pac_mask() : 0;
>> +
>> +	data->arch.ptrauth.enabled_keys = keys_result > 0 ? keys_result : 0;
>> +	data->arch.ptrauth.insn_mask = user_pac_mask;
>> +	data->arch.ptrauth.data_mask = user_pac_mask;
>> +
>> +	header->size += (3 * sizeof(u64));
>> +}
>> +
>> +inline int perf_event_open_request_arch_1(void)
>> +{
>> +	return 0;
>> +}
>> +
>> +
>> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
>> index da759560eec5..8a99942989ce 100644
>> --- a/include/linux/perf_event.h
>> +++ b/include/linux/perf_event.h
>> @@ -999,6 +999,29 @@ int perf_event_read_local(struct perf_event *event, u64 *value,
>>  extern u64 perf_event_read_value(struct perf_event *event,
>>  				 u64 *enabled, u64 *running);
>>  
>> +void perf_output_sample_arch_1(struct perf_output_handle *handle,
>> +			       struct perf_event_header *header,
>> +			       struct perf_sample_data *data,
>> +			       struct perf_event *event);
>> +
>> +void perf_prepare_sample_arch_1(struct perf_event_header *header,
>> +				struct perf_sample_data *data,
>> +				struct perf_event *event,
>> +				struct pt_regs *regs);
>> +
>> +int perf_event_open_request_arch_1(void);
>> +
>> +#if IS_ENABLED(CONFIG_ARM64)
>> +
>> +#define HAS_ARCH_SAMPLE_DATA
>> +#include <asm/arch_sample_data.h>
>> +
>> +#endif
>> +
>> +#ifndef HAS_ARCH_SAMPLE_DATA
>> +struct arch_sample_data {
>> +};
>> +#endif
>>  
>>  struct perf_sample_data {
>>  	/*
>> @@ -1041,6 +1064,7 @@ struct perf_sample_data {
>>  	u64				cgroup;
>>  	u64				data_page_size;
>>  	u64				code_page_size;
>> +	struct arch_sample_data		arch;
>>  } ____cacheline_aligned;
>>  
>>  /* default value for data source */
>> diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
>> index d37629dbad72..821bf5ff6a19 100644
>> --- a/include/uapi/linux/perf_event.h
>> +++ b/include/uapi/linux/perf_event.h
>> @@ -162,12 +162,15 @@ enum perf_event_sample_format {
>>  	PERF_SAMPLE_DATA_PAGE_SIZE		= 1U << 22,
>>  	PERF_SAMPLE_CODE_PAGE_SIZE		= 1U << 23,
>>  	PERF_SAMPLE_WEIGHT_STRUCT		= 1U << 24,
>> +	PERF_SAMPLE_ARCH_1			= 1U << 25,
>>  
>> -	PERF_SAMPLE_MAX = 1U << 25,		/* non-ABI */
>> +	PERF_SAMPLE_MAX = 1U << 26,		/* non-ABI */
>>  
>>  	__PERF_SAMPLE_CALLCHAIN_EARLY		= 1ULL << 63, /* non-ABI; internal use */
>>  };
>>  
>> +#define PERF_SAMPLE_ARM64_PTRAUTH PERF_SAMPLE_ARCH_1
>> +
>>  #define PERF_SAMPLE_WEIGHT_TYPE	(PERF_SAMPLE_WEIGHT | PERF_SAMPLE_WEIGHT_STRUCT)
>>  /*
>>   * values to program into branch_sample_type when PERF_SAMPLE_BRANCH is set
>> diff --git a/kernel/events/core.c b/kernel/events/core.c
>> index 80782cddb1da..89ab8120f4f0 100644
>> --- a/kernel/events/core.c
>> +++ b/kernel/events/core.c
>> @@ -6957,6 +6957,29 @@ static inline bool perf_sample_save_hw_index(struct perf_event *event)
>>  	return event->attr.branch_sample_type & PERF_SAMPLE_BRANCH_HW_INDEX;
>>  }
>>  
>> +#ifndef HAS_ARCH_SAMPLE_DATA
>> +
>> +inline void perf_output_sample_arch_1(struct perf_output_handle *handle __maybe_unused,
>> +				      struct perf_event_header *header __maybe_unused,
>> +				      struct perf_sample_data *data __maybe_unused,
>> +				      struct perf_event *event __maybe_unused)
>> +{
>> +}
>> +
>> +inline void perf_prepare_sample_arch_1(struct perf_event_header *header __maybe_unused,
>> +				       struct perf_sample_data *data __maybe_unused,
>> +				       struct perf_event *event __maybe_unused,
>> +				       struct pt_regs *regs __maybe_unused)
>> +{
>> +}
>> +
>> +inline int perf_event_open_request_arch_1(void)
>> +{
>> +	return -EINVAL;
>> +}
>> +
>> +#endif
>> +
>>  void perf_output_sample(struct perf_output_handle *handle,
>>  			struct perf_event_header *header,
>>  			struct perf_sample_data *data,
>> @@ -7125,6 +7148,9 @@ void perf_output_sample(struct perf_output_handle *handle,
>>  			perf_aux_sample_output(event, handle, data);
>>  	}
>>  
>> +	if (sample_type & PERF_SAMPLE_ARCH_1)
>> +		perf_output_sample_arch_1(handle, header, data, event);
>> +
>>  	if (!event->attr.watermark) {
>>  		int wakeup_events = event->attr.wakeup_events;
>>  
>> @@ -7427,6 +7453,9 @@ void perf_prepare_sample(struct perf_event_header *header,
>>  	if (sample_type & PERF_SAMPLE_CODE_PAGE_SIZE)
>>  		data->code_page_size = perf_get_page_size(data->ip);
>>  
>> +	if (sample_type & PERF_SAMPLE_ARCH_1)
>> +		perf_prepare_sample_arch_1(header, data, event, regs);
>> +
>>  	if (sample_type & PERF_SAMPLE_AUX) {
>>  		u64 size;
>>  
>> @@ -12074,6 +12103,12 @@ SYSCALL_DEFINE5(perf_event_open,
>>  			return err;
>>  	}
>>  
>> +	if (attr.sample_type & PERF_SAMPLE_ARCH_1) {
>> +		err = perf_event_open_request_arch_1();
>> +		if (err)
>> +			return err;
>> +	}
>> +
>>  	/*
>>  	 * In cgroup mode, the pid argument is used to pass the fd
>>  	 * opened to the cgroup directory in cgroupfs. The cpu argument
>> -- 
>> 2.17.1
> 

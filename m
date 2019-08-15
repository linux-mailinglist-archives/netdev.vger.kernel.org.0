Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C85148EA95
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 13:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731062AbfHOLrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 07:47:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:55622 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726317AbfHOLrL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 07:47:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Aug 2019 04:47:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,389,1559545200"; 
   d="scan'208";a="184600470"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.122]) ([10.237.72.122])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Aug 2019 04:47:06 -0700
Subject: Re: [PATCH v5] perf machine: arm/arm64: Improve completeness for
 kernel address space
To:     Leo Yan <leo.yan@linaro.org>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Suzuki Poulouse <suzuki.poulose@arm.com>,
        coresight@lists.linaro.org, linux-arm-kernel@lists.infradead.org
References: <20190815082521.16885-1-leo.yan@linaro.org>
 <d874e6b3-c115-6c8c-bb12-160cfd600505@intel.com>
 <20190815113242.GA28881@leoy-ThinkPad-X240s>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <e0919e39-7607-815b-3a12-96f098e45a5f@intel.com>
Date:   Thu, 15 Aug 2019 14:45:57 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190815113242.GA28881@leoy-ThinkPad-X240s>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/08/19 2:32 PM, Leo Yan wrote:
> Hi Adrian,
> 
> On Thu, Aug 15, 2019 at 11:54:54AM +0300, Adrian Hunter wrote:
> 
> [...]
> 
>>> diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
>>> index e4988f49ea79..d7ff839d8b20 100644
>>> --- a/tools/perf/Makefile.config
>>> +++ b/tools/perf/Makefile.config
>>> @@ -48,9 +48,20 @@ ifeq ($(SRCARCH),x86)
>>>    NO_PERF_REGS := 0
>>>  endif
>>>  
>>> +ARM_PRE_START_SIZE := 0
>>> +
>>>  ifeq ($(SRCARCH),arm)
>>>    NO_PERF_REGS := 0
>>>    LIBUNWIND_LIBS = -lunwind -lunwind-arm
>>> +  ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/kernel/vmlinux.lds),)
>>> +    # Extract info from lds:
>>> +    #   . = ((0xC0000000)) + 0x00208000;
>>> +    # ARM_PRE_START_SIZE := 0x00208000
>>> +    ARM_PRE_START_SIZE := $(shell egrep ' \. \= \({2}0x[0-9a-fA-F]+\){2}' \
>>> +      $(srctree)/arch/$(SRCARCH)/kernel/vmlinux.lds | \
>>> +      sed -e 's/[(|)|.|=|+|<|;|-]//g' -e 's/ \+/ /g' -e 's/^[ \t]*//' | \
>>> +      awk -F' ' '{printf "0x%x", $$2}' 2>/dev/null)
>>> +  endif
>>>  endif
>>>  
>>>  ifeq ($(SRCARCH),arm64)
>>> @@ -58,8 +69,19 @@ ifeq ($(SRCARCH),arm64)
>>>    NO_SYSCALL_TABLE := 0
>>>    CFLAGS += -I$(OUTPUT)arch/arm64/include/generated
>>>    LIBUNWIND_LIBS = -lunwind -lunwind-aarch64
>>> +  ifneq ($(wildcard $(srctree)/arch/$(SRCARCH)/kernel/vmlinux.lds),)
>>> +    # Extract info from lds:
>>> +    #  . = ((((((((0xffffffffffffffff)) - (((1)) << (48)) + 1) + (0)) + (0x08000000))) + (0x08000000))) + 0x00080000;
>>> +    # ARM_PRE_START_SIZE := (0x08000000 + 0x08000000 + 0x00080000) = 0x10080000
>>> +    ARM_PRE_START_SIZE := $(shell egrep ' \. \= \({8}0x[0-9a-fA-F]+\){2}' \
>>> +      $(srctree)/arch/$(SRCARCH)/kernel/vmlinux.lds | \
>>> +      sed -e 's/[(|)|.|=|+|<|;|-]//g' -e 's/ \+/ /g' -e 's/^[ \t]*//' | \
>>> +      awk -F' ' '{printf "0x%x", $$6+$$7+$$8}' 2>/dev/null)
>>> +  endif
>>
>> So, that is not going to work if you take a perf.data file to a non-arm machine?
> 
> Yeah, this patch will only allow perf to work correctly when perf
> run natively on arm/arm64, so it can resolve partial of the issue.
> 
>> How come you cannot use kallsyms to get the information?
> 
> Thanks for pointing out this.  Sorry I skipped your comment "I don't
> know how you intend to calculate ARM_PRE_START_SIZE" when you reviewed
> the patch v3, I should use that chance to elaborate the detailed idea
> and so can get more feedback/guidance before procceed.
> 
> Actually, I have considered to use kallsyms when worked on the previous
> patch set.
> 
> As mentioned in patch set v4's cover letter, I tried to implement
> machine__create_extra_kernel_maps() for arm/arm64, the purpose is to
> parse kallsyms so can find more kernel maps and thus also can fixup
> the kernel start address.  But I found the 'perf script' tool directly
> calls machine__get_kernel_start() instead of running into the flow for
> machine__create_extra_kernel_maps();

Doesn't it just need to loop through each kernel map to find the lowest
start address?

>                                      so I finally gave up to use
> machine__create_extra_kernel_maps() for tweaking kernel start address
> and went back to use this patch's approach by parsing lds files.
> 
> So for next step, I want to get some guidances:
> 
> - One method is to add a new weak function, e.g.
>   arch__fix_kernel_text_start(), then every arch can implement its own
>   function to fixup the kernel start address;
> 
>   For arm/arm64, can use kallsyms to find the symbols with least
>   address and fixup for kernel start address.
> 
> - Another method is to directly parse kallsyms in the function
>   machine__get_kernel_start(), thus the change can be used for all
>   archs;
> 
> Seems to me the second method is to address this issue as a common
> issue crossing all archs.  But not sure if this is the requirement for
> all archs or just this is only required for arm/arm64.  Please let me
> know what's your preference or other thoughts.  Thanks a lot!
> 
> Leo.
> 
>>>  endif
>>>  
>>> +CFLAGS += -DARM_PRE_START_SIZE=$(ARM_PRE_START_SIZE)
>>> +
>>>  ifeq ($(SRCARCH),csky)
>>>    NO_PERF_REGS := 0
>>>  endif
>>> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
>>> index f6ee7fbad3e4..e993f891bb82 100644
>>> --- a/tools/perf/util/machine.c
>>> +++ b/tools/perf/util/machine.c
>>> @@ -2687,13 +2687,26 @@ int machine__get_kernel_start(struct machine *machine)
>>>  	machine->kernel_start = 1ULL << 63;
>>>  	if (map) {
>>>  		err = map__load(map);
>>> +		if (err)
>>> +			return err;
>>> +
>>>  		/*
>>>  		 * On x86_64, PTI entry trampolines are less than the
>>>  		 * start of kernel text, but still above 2^63. So leave
>>>  		 * kernel_start = 1ULL << 63 for x86_64.
>>>  		 */
>>> -		if (!err && !machine__is(machine, "x86_64"))
>>> +		if (!machine__is(machine, "x86_64"))
>>>  			machine->kernel_start = map->start;
>>> +
>>> +		/*
>>> +		 * On arm/arm64, the kernel uses some memory regions which are
>>> +		 * prior to '_stext' symbol; to reflect the complete kernel
>>> +		 * address space, compensate these pre-defined regions for
>>> +		 * kernel start address.
>>> +		 */
>>> +		if (!strcmp(perf_env__arch(machine->env), "arm") ||
>>> +		    !strcmp(perf_env__arch(machine->env), "arm64"))
>>> +			machine->kernel_start -= ARM_PRE_START_SIZE;
>>>  	}
>>>  	return err;
>>>  }
>>>
>>
> 


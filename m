Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3FF90249
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 15:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727282AbfHPNBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 09:01:18 -0400
Received: from mga12.intel.com ([192.55.52.136]:56584 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726075AbfHPNBS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 09:01:18 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Aug 2019 06:01:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,393,1559545200"; 
   d="scan'208";a="171409585"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.122]) ([10.237.72.122])
  by orsmga008.jf.intel.com with ESMTP; 16 Aug 2019 06:01:12 -0700
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
 <e0919e39-7607-815b-3a12-96f098e45a5f@intel.com>
 <20190816014541.GA17960@leoy-ThinkPad-X240s>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <363577f1-097e-eddd-a6ca-b23f644dd8ce@intel.com>
Date:   Fri, 16 Aug 2019 16:00:02 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190816014541.GA17960@leoy-ThinkPad-X240s>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/08/19 4:45 AM, Leo Yan wrote:
> Hi Adrian,
> 
> On Thu, Aug 15, 2019 at 02:45:57PM +0300, Adrian Hunter wrote:
> 
> [...]
> 
>>>> How come you cannot use kallsyms to get the information?
>>>
>>> Thanks for pointing out this.  Sorry I skipped your comment "I don't
>>> know how you intend to calculate ARM_PRE_START_SIZE" when you reviewed
>>> the patch v3, I should use that chance to elaborate the detailed idea
>>> and so can get more feedback/guidance before procceed.
>>>
>>> Actually, I have considered to use kallsyms when worked on the previous
>>> patch set.
>>>
>>> As mentioned in patch set v4's cover letter, I tried to implement
>>> machine__create_extra_kernel_maps() for arm/arm64, the purpose is to
>>> parse kallsyms so can find more kernel maps and thus also can fixup
>>> the kernel start address.  But I found the 'perf script' tool directly
>>> calls machine__get_kernel_start() instead of running into the flow for
>>> machine__create_extra_kernel_maps();
>>
>> Doesn't it just need to loop through each kernel map to find the lowest
>> start address?
> 
> Based on your suggestion, I worked out below change and verified it
> can work well on arm64 for fixing up start address; please let me know
> if the change works for you?

How does that work if take a perf.data file to a machine with a different
architecture?

> 
> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index f6ee7fbad3e4..51d78313dca1 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -2671,9 +2671,26 @@ int machine__nr_cpus_avail(struct machine *machine)
>  	return machine ? perf_env__nr_cpus_avail(machine->env) : 0;
>  }
>  
> +static int machine__fixup_kernel_start(void *arg,
> +				       const char *name __maybe_unused,
> +				       char type,
> +				       u64 start)
> +{
> +	struct machine *machine = arg;
> +
> +	type = toupper(type);
> +
> +	/* Fixup for text, weak, data and bss sections. */
> +	if (type == 'T' || type == 'W' || type == 'D' || type == 'B')
> +		machine->kernel_start = min(machine->kernel_start, start);
> +
> +	return 0;
> +}
> +
>  int machine__get_kernel_start(struct machine *machine)
>  {
>  	struct map *map = machine__kernel_map(machine);
> +	char filename[PATH_MAX];
>  	int err = 0;
>  
>  	/*
> @@ -2687,6 +2704,7 @@ int machine__get_kernel_start(struct machine *machine)
>  	machine->kernel_start = 1ULL << 63;
>  	if (map) {
>  		err = map__load(map);
>  		/*
>  		 * On x86_64, PTI entry trampolines are less than the
>  		 * start of kernel text, but still above 2^63. So leave
> @@ -2695,6 +2713,16 @@ int machine__get_kernel_start(struct machine *machine)
>  		if (!err && !machine__is(machine, "x86_64"))
>  			machine->kernel_start = map->start;
>  	}
> +
> +	machine__get_kallsyms_filename(machine, filename, PATH_MAX);
> +
> +	if (symbol__restricted_filename(filename, "/proc/kallsyms"))
> +		goto out;
> +
> +	if (kallsyms__parse(filename, machine, machine__fixup_kernel_start))
> +		pr_warning("Fail to fixup kernel start address. skipping...\n");
> +
> +out:
>  	return err;
>  }
> 
> Thanks,
> Leo Yan
> 


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8843889744
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 08:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbfHLGiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 02:38:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:62393 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725822AbfHLGiq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 02:38:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Aug 2019 23:38:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,376,1559545200"; 
   d="scan'208";a="193891549"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.122]) ([10.237.72.122])
  by fmsmga001.fm.intel.com with ESMTP; 11 Aug 2019 23:38:41 -0700
Subject: Re: [PATCH v4 1/2] perf machine: Support arch's specific kernel start
 address
To:     Leo Yan <leo.yan@linaro.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Milian Wolff <milian.wolff@kdab.com>,
        Donald Yandt <donald.yandt@gmail.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Wei Li <liwei391@huawei.com>, Mark Drayton <mbd@fb.com>,
        "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        Mathieu Poirier <mathieu.poirier@linaro.org>
References: <20190810072135.27072-1-leo.yan@linaro.org>
 <20190810072135.27072-2-leo.yan@linaro.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <c1818f6f-37df-6971-fddc-6663e5b6ff95@intel.com>
Date:   Mon, 12 Aug 2019 09:37:33 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190810072135.27072-2-leo.yan@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/08/19 10:21 AM, Leo Yan wrote:
> machine__get_kernel_start() gives out the kernel start address; some
> architectures need to tweak the start address so that can reflect the
> kernel start address correctly.  This is not only for x86_64 arch, but
> it is also required by other architectures, e.g. arm/arm64 needs to
> tweak the kernel start address so can include the kernel memory regions
> which are used before the '_stext' symbol.
> 
> This patch refactors machine__get_kernel_start() by adding a weak
> arch__fix_kernel_text_start(), any architecture can implement it to
> tweak its specific start address; this also allows the arch specific
> code to be placed into 'arch' folder.
> 
> Signed-off-by: Leo Yan <leo.yan@linaro.org>
> ---
>  tools/perf/arch/x86/util/machine.c | 10 ++++++++++
>  tools/perf/util/machine.c          | 13 +++++++------
>  tools/perf/util/machine.h          |  2 ++
>  3 files changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/perf/arch/x86/util/machine.c b/tools/perf/arch/x86/util/machine.c
> index 1e9ec783b9a1..9f012131534a 100644
> --- a/tools/perf/arch/x86/util/machine.c
> +++ b/tools/perf/arch/x86/util/machine.c
> @@ -101,4 +101,14 @@ int machine__create_extra_kernel_maps(struct machine *machine,
>  	return ret;
>  }
>  
> +void arch__fix_kernel_text_start(u64 *start)
> +{
> +	/*
> +	 * On x86_64, PTI entry trampolines are less than the
> +	 * start of kernel text, but still above 2^63. So leave
> +	 * kernel_start = 1ULL << 63 for x86_64.
> +	 */
> +	*start = 1ULL << 63;
> +}

That is needed for reporting x86 data on any arch i.e. it is not specific to
the compile-time architecture, it is specific to the perf.data file
architecture, which is what machine__is() compares. So, this looks wrong.

> +
>  #endif
> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index f6ee7fbad3e4..603518835692 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -2671,6 +2671,10 @@ int machine__nr_cpus_avail(struct machine *machine)
>  	return machine ? perf_env__nr_cpus_avail(machine->env) : 0;
>  }
>  
> +void __weak arch__fix_kernel_text_start(u64 *start __maybe_unused)
> +{
> +}
> +
>  int machine__get_kernel_start(struct machine *machine)
>  {
>  	struct map *map = machine__kernel_map(machine);
> @@ -2687,14 +2691,11 @@ int machine__get_kernel_start(struct machine *machine)
>  	machine->kernel_start = 1ULL << 63;
>  	if (map) {
>  		err = map__load(map);
> -		/*
> -		 * On x86_64, PTI entry trampolines are less than the
> -		 * start of kernel text, but still above 2^63. So leave
> -		 * kernel_start = 1ULL << 63 for x86_64.
> -		 */
> -		if (!err && !machine__is(machine, "x86_64"))
> +		if (!err)
>  			machine->kernel_start = map->start;
>  	}
> +
> +	arch__fix_kernel_text_start(&machine->kernel_start);
>  	return err;
>  }
>  
> diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
> index ef803f08ae12..9cb459f4bfbc 100644
> --- a/tools/perf/util/machine.h
> +++ b/tools/perf/util/machine.h
> @@ -278,6 +278,8 @@ void machine__get_kallsyms_filename(struct machine *machine, char *buf,
>  int machine__create_extra_kernel_maps(struct machine *machine,
>  				      struct dso *kernel);
>  
> +void arch__fix_kernel_text_start(u64 *start);
> +
>  /* Kernel-space maps for symbols that are outside the main kernel map and module maps */
>  struct extra_kernel_map {
>  	u64 start;
> 


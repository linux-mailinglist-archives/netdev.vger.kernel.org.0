Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDB034152B0
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 23:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238008AbhIVVYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 17:24:24 -0400
Received: from www62.your-server.de ([213.133.104.62]:37346 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236476AbhIVVYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 17:24:23 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mT9hZ-000D8G-7O; Wed, 22 Sep 2021 23:22:49 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mT9hY-000Rpx-Vo; Wed, 22 Sep 2021 23:22:49 +0200
Subject: Re: [PATCH v2 bpf-next] libbpf: Use sysconf to simplify
 libbpf_num_possible_cpus
To:     Muhammad Falak R Wani <falakreyaz@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210922070748.21614-1-falakreyaz@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ef0f23d0-456a-70b0-1ef9-2615a5528278@iogearbox.net>
Date:   Wed, 22 Sep 2021 23:22:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210922070748.21614-1-falakreyaz@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26300/Wed Sep 22 11:04:22 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/22/21 9:07 AM, Muhammad Falak R Wani wrote:
> Simplify libbpf_num_possible_cpus by using sysconf(_SC_NPROCESSORS_CONF)
> instead of parsing a file.
> This patch is a part ([0]) of libbpf-1.0 milestone.
> 
> [0] Closes: https://github.com/libbpf/libbpf/issues/383
> 
> Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
> ---
>   tools/lib/bpf/libbpf.c | 17 ++++-------------
>   1 file changed, 4 insertions(+), 13 deletions(-)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index ef5db34bf913..f1c0abe5b58d 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -10898,25 +10898,16 @@ int parse_cpu_mask_file(const char *fcpu, bool **mask, int *mask_sz)
>   
>   int libbpf_num_possible_cpus(void)
>   {
> -	static const char *fcpu = "/sys/devices/system/cpu/possible";
>   	static int cpus;
> -	int err, n, i, tmp_cpus;
> -	bool *mask;
> +	int tmp_cpus;
>   
>   	tmp_cpus = READ_ONCE(cpus);
>   	if (tmp_cpus > 0)
>   		return tmp_cpus;
>   
> -	err = parse_cpu_mask_file(fcpu, &mask, &n);
> -	if (err)
> -		return libbpf_err(err);
> -
> -	tmp_cpus = 0;
> -	for (i = 0; i < n; i++) {
> -		if (mask[i])
> -			tmp_cpus++;
> -	}
> -	free(mask);
> +	tmp_cpus = sysconf(_SC_NPROCESSORS_CONF);
> +	if (tmp_cpus < 1)
> +		return libbpf_err(-EINVAL);

This approach is unfortunately broken, see also commit e00c7b216f34 ("bpf: fix
multiple issues in selftest suite and samples") for more details:

     3) Current selftest suite code relies on sysconf(_SC_NPROCESSORS_CONF) for
        retrieving the number of possible CPUs. This is broken at least in our
        scenario and really just doesn't work.

        glibc tries a number of things for retrieving _SC_NPROCESSORS_CONF.
        First it tries equivalent of /sys/devices/system/cpu/cpu[0-9]* | wc -l,
        if that fails, depending on the config, it either tries to count CPUs
        in /proc/cpuinfo, or returns the _SC_NPROCESSORS_ONLN value instead.
        If /proc/cpuinfo has some issue, it returns just 1 worst case. This
        oddity is nothing new [1], but semantics/behaviour seems to be settled.
        _SC_NPROCESSORS_ONLN will parse /sys/devices/system/cpu/online, if
        that fails it looks into /proc/stat for cpuX entries, and if also that
        fails for some reason, /proc/cpuinfo is consulted (and returning 1 if
        unlikely all breaks down).

        While that might match num_possible_cpus() from the kernel in some
        cases, it's really not guaranteed with CPU hotplugging, and can result
        in a buffer overflow since the array in user space could have too few
        number of slots, and on perpcu map lookup, the kernel will write beyond
        that memory of the value buffer.

        William Tu reported such mismatches:

          [...] The fact that sysconf(_SC_NPROCESSORS_CONF) != num_possible_cpu()
          happens when CPU hotadd is enabled. For example, in Fusion when
          setting vcpu.hotadd = "TRUE" or in KVM, setting ./qemu-system-x86_64
          -smp 2, maxcpus=4 ... the num_possible_cpu() will be 4 and sysconf()
          will be 2 [2]. [...]

        Documentation/cputopology.txt says /sys/devices/system/cpu/possible
        outputs cpu_possible_mask. That is the same as in num_possible_cpus(),
        so first step would be to fix the _SC_NPROCESSORS_CONF calls with our
        own implementation. Later, we could add support to bpf(2) for passing
        a mask via CPU_SET(3), for example, to just select a subset of CPUs.

        BPF samples code needs this fix as well (at least so that people stop
        copying this). Thus, define bpf_num_possible_cpus() once in selftests
        and import it from there for the sample code to avoid duplicating it.
        The remaining sysconf(_SC_NPROCESSORS_CONF) in samples are unrelated.

Thanks,
Daniel

>   	WRITE_ONCE(cpus, tmp_cpus);
>   	return tmp_cpus;
> 


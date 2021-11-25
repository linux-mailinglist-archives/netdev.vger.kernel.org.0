Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0F2045E333
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 00:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347597AbhKYXKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 18:10:53 -0500
Received: from www62.your-server.de ([213.133.104.62]:57324 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237122AbhKYXIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 18:08:51 -0500
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mqNo5-000C1N-Cm; Fri, 26 Nov 2021 00:05:33 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mqNo5-000Jp0-3m; Fri, 26 Nov 2021 00:05:33 +0100
Subject: Re: [PATCH bpf-next v2] bpf, mips: Fix build errors about __NR_bpf
 undeclared
To:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Xuefeng Li <lixuefeng@loongson.cn>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        johan.almbladh@anyfinetworks.com
References: <1637804167-8323-1-git-send-email-yangtiezhu@loongson.cn>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <0ca847a8-78a5-6ad9-ab4b-62dcda33df7c@iogearbox.net>
Date:   Fri, 26 Nov 2021 00:05:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1637804167-8323-1-git-send-email-yangtiezhu@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26364/Thu Nov 25 10:20:31 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ +Johan ]

On 11/25/21 2:36 AM, Tiezhu Yang wrote:
> Add the __NR_bpf definitions to fix the following build errors for mips.
> 
>   $ cd tools/bpf/bpftool
>   $ make
>   [...]
>   bpf.c:54:4: error: #error __NR_bpf not defined. libbpf does not support your arch.
>    #  error __NR_bpf not defined. libbpf does not support your arch.
>       ^~~~~
>   bpf.c: In function ‘sys_bpf’:
>   bpf.c:66:17: error: ‘__NR_bpf’ undeclared (first use in this function); did you mean ‘__NR_brk’?
>     return syscall(__NR_bpf, cmd, attr, size);
>                    ^~~~~~~~
>                    __NR_brk
>   [...]
>   In file included from gen_loader.c:15:0:
>   skel_internal.h: In function ‘skel_sys_bpf’:
>   skel_internal.h:53:17: error: ‘__NR_bpf’ undeclared (first use in this function); did you mean ‘__NR_brk’?
>     return syscall(__NR_bpf, cmd, attr, size);
>                    ^~~~~~~~
>                    __NR_brk
> 
> We can see the following generated definitions:
> 
>   $ grep -r "#define __NR_bpf" arch/mips
>   arch/mips/include/generated/uapi/asm/unistd_o32.h:#define __NR_bpf (__NR_Linux + 355)
>   arch/mips/include/generated/uapi/asm/unistd_n64.h:#define __NR_bpf (__NR_Linux + 315)
>   arch/mips/include/generated/uapi/asm/unistd_n32.h:#define __NR_bpf (__NR_Linux + 319)
> 
> The __NR_Linux is defined in arch/mips/include/uapi/asm/unistd.h:
> 
>   $ grep -r "#define __NR_Linux" arch/mips
>   arch/mips/include/uapi/asm/unistd.h:#define __NR_Linux	4000
>   arch/mips/include/uapi/asm/unistd.h:#define __NR_Linux	5000
>   arch/mips/include/uapi/asm/unistd.h:#define __NR_Linux	6000
> 
> That is to say, __NR_bpf is
> 4000 + 355 = 4355 for mips o32,
> 6000 + 319 = 6319 for mips n32,
> 5000 + 315 = 5315 for mips n64.
> 
> So use the GCC pre-defined macro _ABIO32, _ABIN32 and _ABI64 [1] to define
> the corresponding __NR_bpf.
> 
> This patch is similar with commit bad1926dd2f6 ("bpf, s390: fix build for
> libbpf and selftest suite").
> 
> [1] https://gcc.gnu.org/git/?p=gcc.git;a=blob;f=gcc/config/mips/mips.h#l549
> 
> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> ---
> 
> v2: use a final number without __NR_Linux to define __NR_bpf
>      suggested by Andrii Nakryiko, thank you.
> 
>   tools/build/feature/test-bpf.c |  6 ++++++
>   tools/lib/bpf/bpf.c            |  6 ++++++
>   tools/lib/bpf/skel_internal.h  | 10 ++++++++++
>   3 files changed, 22 insertions(+)
> 
> diff --git a/tools/build/feature/test-bpf.c b/tools/build/feature/test-bpf.c
> index 82070ea..727d22e 100644
> --- a/tools/build/feature/test-bpf.c
> +++ b/tools/build/feature/test-bpf.c
> @@ -14,6 +14,12 @@
>   #  define __NR_bpf 349
>   # elif defined(__s390__)
>   #  define __NR_bpf 351
> +# elif defined(__mips__) && defined(_ABIO32)
> +#  define __NR_bpf 4355
> +# elif defined(__mips__) && defined(_ABIN32)
> +#  define __NR_bpf 6319
> +# elif defined(__mips__) && defined(_ABI64)
> +#  define __NR_bpf 5315
>   # else
>   #  error __NR_bpf not defined. libbpf does not support your arch.
>   # endif
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index 94560ba..17f9fe2 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -50,6 +50,12 @@
>   #  define __NR_bpf 351
>   # elif defined(__arc__)
>   #  define __NR_bpf 280
> +# elif defined(__mips__) && defined(_ABIO32)
> +#  define __NR_bpf 4355
> +# elif defined(__mips__) && defined(_ABIN32)
> +#  define __NR_bpf 6319
> +# elif defined(__mips__) && defined(_ABI64)
> +#  define __NR_bpf 5315
>   # else
>   #  error __NR_bpf not defined. libbpf does not support your arch.
>   # endif
> diff --git a/tools/lib/bpf/skel_internal.h b/tools/lib/bpf/skel_internal.h
> index 9cf6670..064da66 100644
> --- a/tools/lib/bpf/skel_internal.h
> +++ b/tools/lib/bpf/skel_internal.h
> @@ -7,6 +7,16 @@
>   #include <sys/syscall.h>
>   #include <sys/mman.h>
>   
> +#ifndef __NR_bpf
> +# if defined(__mips__) && defined(_ABIO32)
> +#  define __NR_bpf 4355
> +# elif defined(__mips__) && defined(_ABIN32)
> +#  define __NR_bpf 6319
> +# elif defined(__mips__) && defined(_ABI64)
> +#  define __NR_bpf 5315
> +# endif
> +#endif

Bit unfortunate that mips is the only arch where we run into this apparently? :/
Given we also redefine a skel_sys_bpf(), maybe libbpf should just provide something
like a `LIBBPF_API int libbpf_sys_bpf(enum bpf_cmd cmd, [...])` so we rely implicitly
only on the libbpf-internal __NR_bpf instead of duplicating again?

>   /* This file is a base header for auto-generated *.lskel.h files.
>    * Its contents will change and may become part of auto-generation in the future.
>    *
> 


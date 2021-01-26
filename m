Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6A50304358
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 17:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404402AbhAZQC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 11:02:26 -0500
Received: from www62.your-server.de ([213.133.104.62]:55492 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391626AbhAZQCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 11:02:09 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1l4QmC-0007wD-Pt; Tue, 26 Jan 2021 17:01:08 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1l4QmC-000VGR-Et; Tue, 26 Jan 2021 17:01:08 +0100
Subject: Re: [PATCH bpf-next] samples/bpf: Add include dir for MIPS Loongson64
 to fix build errors
To:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xuefeng Li <lixuefeng@loongson.cn>
References: <1611669925-25315-1-git-send-email-yangtiezhu@loongson.cn>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <67891f2f-a374-54fb-e6e5-44145190934f@iogearbox.net>
Date:   Tue, 26 Jan 2021 17:01:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1611669925-25315-1-git-send-email-yangtiezhu@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26061/Tue Jan 26 13:29:51 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/26/21 3:05 PM, Tiezhu Yang wrote:
> There exists many build errors when make M=samples/bpf on the Loongson
> platform, this issue is MIPS related, x86 compiles just fine.
> 
> Here are some errors:
[...]
> 
> So we can do the similar things in samples/bpf/Makefile, just add
> platform specific and generic include dir for MIPS Loongson64 to
> fix the build errors.

Your patch from [0] said ...

   There exists many build warnings when make M=samples/bpf on the Loongson
   platform, this issue is MIPS related, x86 compiles just fine.

   Here are some warnings:
   [...]

   With #ifndef __SANE_USERSPACE_TYPES__  in tools/include/linux/types.h,
   the above error has gone and this ifndef change does not hurt other
   compilations.

... which ave the impression that all the issues were fixed. What else
is needed aside from this patch here? More samples/bpf fixes coming? If
yes, please all submit them as a series instead of individual ones.

  [0] https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=190d1c921ad0862da14807e1670f54020f48e889

> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> ---
>   samples/bpf/Makefile | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index 362f314..45ceca4 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -185,6 +185,10 @@ endif
>   
>   ifeq ($(ARCH), mips)
>   TPROGS_CFLAGS += -D__SANE_USERSPACE_TYPES__
> +ifdef CONFIG_MACH_LOONGSON64
> +BPF_EXTRA_CFLAGS += -I$(srctree)/arch/mips/include/asm/mach-loongson64
> +BPF_EXTRA_CFLAGS += -I$(srctree)/arch/mips/include/asm/mach-generic
> +endif
>   endif
>   
>   TPROGS_CFLAGS += -Wall -O2
> 


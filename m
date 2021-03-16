Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C9033DFB5
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 22:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232225AbhCPVBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 17:01:50 -0400
Received: from www62.your-server.de ([213.133.104.62]:59966 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232211AbhCPVBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 17:01:45 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lMGov-000DD5-8i; Tue, 16 Mar 2021 22:01:41 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lMGou-000NvJ-VU; Tue, 16 Mar 2021 22:01:40 +0100
Subject: Re: [PATCH] libbpf: avoid inline hint definition from
 'linux/stddef.h'
To:     Pedro Tammela <pctammela@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
References: <20210314173839.457768-1-pctammela@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5083f82b-39fc-9d46-bcd0-3a6be2fc7f98@iogearbox.net>
Date:   Tue, 16 Mar 2021 22:01:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210314173839.457768-1-pctammela@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26110/Tue Mar 16 12:05:23 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/14/21 6:38 PM, Pedro Tammela wrote:
> Linux headers might pull 'linux/stddef.h' which defines
> '__always_inline' as the following:
> 
>     #ifndef __always_inline
>     #define __always_inline __inline__
>     #endif
> 
> This becomes an issue if the program picks up the 'linux/stddef.h'
> definition as the macro now just hints inline to clang.

How did the program end up including linux/stddef.h ? Would be good to
also have some more details on how we got here for the commit desc.

> This change now enforces the proper definition for BPF programs
> regardless of the include order.
> 
> Signed-off-by: Pedro Tammela <pctammela@gmail.com>
> ---
>   tools/lib/bpf/bpf_helpers.h | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> index ae6c975e0b87..5fa483c0b508 100644
> --- a/tools/lib/bpf/bpf_helpers.h
> +++ b/tools/lib/bpf/bpf_helpers.h
> @@ -29,9 +29,12 @@
>    */
>   #define SEC(NAME) __attribute__((section(NAME), used))
>   
> -#ifndef __always_inline
> +/*
> + * Avoid 'linux/stddef.h' definition of '__always_inline'.
> + */

I think the comment should have more details on 'why' we undef it as in
few months looking at it again, the next question to dig into would be
what was wrong with linux/stddef.h. Providing a better rationale would
be nice for readers here.

> +#undef __always_inline
>   #define __always_inline inline __attribute__((always_inline))
> -#endif
> +
>   #ifndef __noinline
>   #define __noinline __attribute__((noinline))
>   #endif
> 


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E27836C937
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 18:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237723AbhD0QVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 12:21:30 -0400
Received: from www62.your-server.de ([213.133.104.62]:43158 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236581AbhD0QTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 12:19:25 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lbQPr-0003Vl-TX; Tue, 27 Apr 2021 18:18:27 +0200
Received: from [85.7.101.30] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lbQPr-000Wof-La; Tue, 27 Apr 2021 18:18:27 +0200
Subject: Re: [PATCH bpf-next] libbpf: handle ENOTSUPP errno in
 libbpf_strerror()
To:     Pedro Tammela <pctammela@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Pedro Tammela <pctammela@mojatatu.com>
References: <20210424221648.809525-1-pctammela@mojatatu.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <7c789fc1-de3d-5232-4d32-5bd3afbf26ea@iogearbox.net>
Date:   Tue, 27 Apr 2021 18:18:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210424221648.809525-1-pctammela@mojatatu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26153/Tue Apr 27 13:09:27 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/25/21 12:16 AM, Pedro Tammela wrote:
> The 'bpf()' syscall is leaking the ENOTSUPP errno that is internal to the kernel[1].
> More recent code is already using the correct EOPNOTSUPP, but changing
> older return codes is not possible due to dependency concerns, so handle ENOTSUPP
> in libbpf_strerror().
> 
> [1] https://lore.kernel.org/netdev/20200511165319.2251678-1-kuba@kernel.org/
> 
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> ---
>   tools/lib/bpf/libbpf_errno.c | 9 +++++++++
>   1 file changed, 9 insertions(+)
> 
> diff --git a/tools/lib/bpf/libbpf_errno.c b/tools/lib/bpf/libbpf_errno.c
> index 0afb51f7a919..7de8bbc34a37 100644
> --- a/tools/lib/bpf/libbpf_errno.c
> +++ b/tools/lib/bpf/libbpf_errno.c
> @@ -13,6 +13,9 @@
>   
>   #include "libbpf.h"
>   
> +/* This errno is internal to the kernel but leaks in the bpf() syscall. */
> +#define ENOTSUPP 524
> +
>   /* make sure libbpf doesn't use kernel-only integer typedefs */
>   #pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
>   
> @@ -43,6 +46,12 @@ int libbpf_strerror(int err, char *buf, size_t size)
>   
>   	err = err > 0 ? err : -err;
>   
> +	if (err == ENOTSUPP) {
> +		snprintf(buf, size, "Operation not supported");
> +		buf[size - 1] = '\0';
> +		return 0;
> +	}
> +
>   	if (err < __LIBBPF_ERRNO__START) {
>   		int ret;

Could you fold this into the __LIBBPF_ERRNO__START test body to denote that it
belongs outside the libbpf error range? For example, could be simplified like this:

         if (err < __LIBBPF_ERRNO__START) {
                 int ret;

                 /* Handle ENOTSUPP separate here given it's kernel internal,
                  * but for sake of error string it has the same meaning as
                  * the EOPNOTSUPP error.
                  */
                 if (err == ENOTSUPP)
                         err = EOPNOTSUPP;
                 ret = strerror_r(err, buf, size);
                 buf[size - 1] = '\0';
                 return ret;
         }

Thanks,
Daniel

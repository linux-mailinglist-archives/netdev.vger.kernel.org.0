Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF13195FDC
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 21:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbgC0UeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 16:34:11 -0400
Received: from www62.your-server.de ([213.133.104.62]:39836 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727393AbgC0UeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 16:34:11 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jHvg6-00089O-S4; Fri, 27 Mar 2020 21:34:06 +0100
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jHvg6-000Lpp-Dh; Fri, 27 Mar 2020 21:34:06 +0100
Subject: Re: [PATCH v3] bpf: fix build warning - missing prototype
To:     Jean-Philippe Menil <jpmenil@gmail.com>,
        alexei.starovoitov@gmail.com
Cc:     kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200326235426.ei6ae2z5ek6uq3tt@ast-mbp>
 <20200327075544.22814-1-jpmenil@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3164e566-d54e-2254-32c4-d7fee47c37ea@iogearbox.net>
Date:   Fri, 27 Mar 2020 21:34:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200327075544.22814-1-jpmenil@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25764/Fri Mar 27 14:11:26 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/27/20 8:55 AM, Jean-Philippe Menil wrote:
> Fix build warnings when building net/bpf/test_run.o with W=1 due
> to missing prototype for bpf_fentry_test{1..6}.
> 
> Instead of declaring prototypes, turn off warnings with
> __diag_{push,ignore,pop} as pointed by Alexei.
> 
> Signed-off-by: Jean-Philippe Menil <jpmenil@gmail.com>

Looks better, but this doesn't apply cleanly. Please respin to latest bpf-next tree, thanks.

> ---
>   net/bpf/test_run.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index d555c0d8657d..cc1592413fc3 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -113,6 +113,9 @@ static int bpf_test_finish(const union bpf_attr *kattr,
>    * architecture dependent calling conventions. 7+ can be supported in the
>    * future.
>    */
> +__diag_push();
> +__diag_ignore(GCC, 8, "-Wmissing-prototypes",
> +	      "Global functions as their definitions will be in vmlinux BTF);
>   int noinline bpf_fentry_test1(int a)
>   {
>   	return a + 1;
> @@ -143,6 +146,8 @@ int noinline bpf_fentry_test6(u64 a, void *b, short c, int d, void *e, u64 f)
>   	return a + (long)b + c + d + (long)e + f;
>   }
>   
> +__diag_pop();
> +
>   static void *bpf_test_init(const union bpf_attr *kattr, u32 size,
>   			   u32 headroom, u32 tailroom)
>   {
> 


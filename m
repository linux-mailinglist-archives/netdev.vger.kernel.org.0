Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C23D9498491
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 17:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243658AbiAXQVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 11:21:43 -0500
Received: from www62.your-server.de ([213.133.104.62]:42906 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243666AbiAXQVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 11:21:42 -0500
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nC25u-0002qy-So; Mon, 24 Jan 2022 17:21:26 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nC25u-000L2R-Hz; Mon, 24 Jan 2022 17:21:26 +0100
Subject: Re: [PATCH bpf-next] bpf, arm64: enable kfunc call
To:     Hou Tao <houtao1@huawei.com>, Alexei Starovoitov <ast@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@arm.com>
Cc:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <20220119144942.305568-1-houtao1@huawei.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b54b3297-086c-1b64-1c25-01f70c6412af@iogearbox.net>
Date:   Mon, 24 Jan 2022 17:21:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220119144942.305568-1-houtao1@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26432/Mon Jan 24 10:24:33 2022)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/19/22 3:49 PM, Hou Tao wrote:
> Since commit b2eed9b58811 ("arm64/kernel: kaslr: reduce module
> randomization range to 2 GB"), for arm64 whether KASLR is enabled
> or not, the module is placed within 2GB of the kernel region, so
> s32 in bpf_kfunc_desc is sufficient to represente the offset of
> module function relative to __bpf_call_base. The only thing needed
> is to override bpf_jit_supports_kfunc_call().
> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>

Lgtm, could we also add a BPF selftest to assert that this assumption
won't break in future when bpf_jit_supports_kfunc_call() returns true?

E.g. extending lib/test_bpf.ko could be an option, wdyt?

> ---
>   arch/arm64/net/bpf_jit_comp.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
> index e96d4d87291f..74f9a9b6a053 100644
> --- a/arch/arm64/net/bpf_jit_comp.c
> +++ b/arch/arm64/net/bpf_jit_comp.c
> @@ -1143,6 +1143,11 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>   	return prog;
>   }
>   
> +bool bpf_jit_supports_kfunc_call(void)
> +{
> +	return true;
> +}
> +
>   u64 bpf_jit_alloc_exec_limit(void)
>   {
>   	return VMALLOC_END - VMALLOC_START;
> 


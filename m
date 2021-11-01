Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 284E84422F6
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 22:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbhKAWCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 18:02:07 -0400
Received: from www62.your-server.de ([213.133.104.62]:56708 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230460AbhKAWCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 18:02:07 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mhfKv-000DWv-Kp; Mon, 01 Nov 2021 22:59:25 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mhfKv-000OVr-FI; Mon, 01 Nov 2021 22:59:25 +0100
Subject: Re: [PATCH bpf-next v2 2/2] bpf: disallow BPF_LOG_KERNEL log level
 for sys(BPF_BTF_LOAD)
To:     Hou Tao <houtao1@huawei.com>, Alexei Starovoitov <ast@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20211029135321.94065-1-houtao1@huawei.com>
 <20211029135321.94065-3-houtao1@huawei.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <50a07acf-a9e9-13b1-11c8-fae221acf495@iogearbox.net>
Date:   Mon, 1 Nov 2021 22:59:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20211029135321.94065-3-houtao1@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26340/Mon Nov  1 09:21:46 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/29/21 3:53 PM, Hou Tao wrote:
> BPF_LOG_KERNEL is only used internally, so disallow bpf_btf_load()
> to set log level as BPF_LOG_KERNEL. The same checking has already
> been done in bpf_check(), so factor out a helper to check the
> validity of log attributes and use it in both places.
> 
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
>   include/linux/bpf_verifier.h | 6 ++++++
>   kernel/bpf/btf.c             | 3 +--
>   kernel/bpf/verifier.c        | 6 +++---
>   3 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
> index c8a78e830fca..b36a0da8d5cf 100644
> --- a/include/linux/bpf_verifier.h
> +++ b/include/linux/bpf_verifier.h
> @@ -396,6 +396,12 @@ static inline bool bpf_verifier_log_needed(const struct bpf_verifier_log *log)
>   		 log->level == BPF_LOG_KERNEL);
>   }
>   
> +static inline bool bpf_verifier_log_attr_valid(const struct bpf_verifier_log *log)
> +{
> +	return (log->len_total >= 128 && log->len_total <= UINT_MAX >> 2 &&
> +		log->level && log->ubuf && !(log->level & ~BPF_LOG_MASK));

nit: No surrounding () needed.

This should probably also get a Fixes tag wrt BPF_LOG_KERNEL exposure?

Is there a need to bump log->len_total for BTF so significantly?

> +}
> +
>   #define BPF_MAX_SUBPROGS 256
>   
>   struct bpf_subprog_info {
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index dbc3ad07e21b..ea8874eaedac 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -4460,8 +4460,7 @@ static struct btf *btf_parse(bpfptr_t btf_data, u32 btf_data_size,
>   		log->len_total = log_size;
>   
>   		/* log attributes have to be sane */
> -		if (log->len_total < 128 || log->len_total > UINT_MAX >> 8 ||
> -		    !log->level || !log->ubuf) {
> +		if (!bpf_verifier_log_attr_valid(log)) {
>   			err = -EINVAL;
>   			goto errout;
>   		}
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 22f0d2292c2c..47ad91cea7e9 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -13935,11 +13935,11 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr, bpfptr_t uattr)
>   		log->ubuf = (char __user *) (unsigned long) attr->log_buf;
>   		log->len_total = attr->log_size;
>   
> -		ret = -EINVAL;
>   		/* log attributes have to be sane */
> -		if (log->len_total < 128 || log->len_total > UINT_MAX >> 2 ||
> -		    !log->level || !log->ubuf || log->level & ~BPF_LOG_MASK)
> +		if (!bpf_verifier_log_attr_valid(log)) {
> +			ret = -EINVAL;
>   			goto err_unlock;
> +		}
>   	}
>   
>   	if (IS_ERR(btf_vmlinux)) {
> 


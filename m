Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6549A146D96
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 16:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgAWP5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 10:57:53 -0500
Received: from www62.your-server.de ([213.133.104.62]:37536 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbgAWP5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 10:57:53 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iuerU-0002Nx-KQ; Thu, 23 Jan 2020 16:57:40 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1iuerU-000SOJ-77; Thu, 23 Jan 2020 16:57:40 +0100
Subject: Re: [PATCH] Support for nlattr and nested_nlattr attribute search in
 EBPF filter
To:     Kalimuthu Velappan <kalimuthu.velappan@broadcom.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Andrey Ignatov <rdna@fb.com>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
References: <20200123130816.24815-1-kalimuthu.velappan@broadcom.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a7d6f51f-8c5c-9242-97a1-8fdea9fdbb7b@iogearbox.net>
Date:   Thu, 23 Jan 2020 16:57:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200123130816.24815-1-kalimuthu.velappan@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25704/Thu Jan 23 12:37:43 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/23/20 2:08 PM, Kalimuthu Velappan wrote:
> Added attribute search and nested attribute support in EBPF filter
> functionality.

Your commit describes what the code does, but not the rationale why it's needed
resp. the use-case you're trying to solve with this.

Also, why it cannot be resolved in native BPF?

> Signed-off-by: Kalimuthu Velappan <kalimuthu.velappan@broadcom.com>
> ---
>   include/uapi/linux/bpf.h       |  5 ++++-
>   net/core/filter.c              | 22 ++++++++++++++++++++++
>   tools/include/uapi/linux/bpf.h |  4 +++-
>   3 files changed, 29 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index dbbcf0b..ac9794c 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -2938,7 +2938,10 @@ union bpf_attr {
>   	FN(probe_read_user),		\
>   	FN(probe_read_kernel),		\
>   	FN(probe_read_user_str),	\
> -	FN(probe_read_kernel_str),
> +	FN(probe_read_kernel_str),  \
> +	FN(skb_get_nlattr),     \
> +	FN(skb_get_nlattr_nest),
> +

This is not on latest bpf-next tree.

>   /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>    * function eBPF program intends to call
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 538f6a7..56a87e1 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -2699,6 +2699,24 @@ static const struct bpf_func_proto bpf_set_hash_invalid_proto = {
>   	.arg1_type	= ARG_PTR_TO_CTX,
>   };
>   
> +static const struct bpf_func_proto bpf_skb_get_nlattr_proto = {
> +	.func		= bpf_skb_get_nlattr,
> +	.gpl_only	= false,
> +	.ret_type	= RET_INTEGER,
> +	.arg1_type	= ARG_PTR_TO_CTX,
> +	.arg2_type  = ARG_ANYTHING,
> +	.arg3_type  = ARG_ANYTHING,
> +};
> +
> +static const struct bpf_func_proto skb_get_nlattr_nest_proto = {
> +	.func		= bpf_skb_get_nlattr_nest,
> +	.gpl_only	= false,
> +	.ret_type	= RET_INTEGER,
> +	.arg1_type	= ARG_PTR_TO_CTX,
> +	.arg2_type  = ARG_ANYTHING,
> +	.arg3_type  = ARG_ANYTHING,
> +};
> +
>   BPF_CALL_2(bpf_set_hash, struct sk_buff *, skb, u32, hash)

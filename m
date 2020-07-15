Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B034C2217C0
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 00:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgGOW2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 18:28:19 -0400
Received: from www62.your-server.de ([213.133.104.62]:35268 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbgGOW2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 18:28:19 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jvpsv-0005nw-1i; Thu, 16 Jul 2020 00:28:17 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jvpsu-000Pxq-RX; Thu, 16 Jul 2020 00:28:16 +0200
Subject: Re: [PATCH bpf-next] bpf: add a new bpf argument type
 ARG_CONST_MAP_PTR_OR_NULL
To:     Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>, ast@kernel.org
References: <20200715070001.2048207-1-liuhangbin@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <67a68a77-f287-1bb1-3221-24e8b3351958@iogearbox.net>
Date:   Thu, 16 Jul 2020 00:28:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200715070001.2048207-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25874/Wed Jul 15 16:18:08 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/15/20 9:00 AM, Hangbin Liu wrote:
> Add a new bpf argument type ARG_CONST_MAP_PTR_OR_NULL which could be
> used when we want to allow NULL pointer for map parameter. The bpf helper
> need to take care and check if the map is NULL when use this type.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Is this patch to be merged into the set in [0] for passing NULL ex_map as discussed?
Seems you sent out two incomplete sets?

   [0] https://lore.kernel.org/bpf/20200709013008.3900892-1-liuhangbin@gmail.com/T/#m99a8fa8ffe79d5f00d305c0800ad3abe619294f2

> ---
>   include/linux/bpf.h   |  1 +
>   kernel/bpf/verifier.c | 11 ++++++++---
>   2 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index c67c88ad35f8..9d4dbef3c943 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -253,6 +253,7 @@ enum bpf_arg_type {
>   	ARG_PTR_TO_ALLOC_MEM,	/* pointer to dynamically allocated memory */
>   	ARG_PTR_TO_ALLOC_MEM_OR_NULL,	/* pointer to dynamically allocated memory or NULL */
>   	ARG_CONST_ALLOC_SIZE_OR_ZERO,	/* number of allocated bytes requested */
> +	ARG_CONST_MAP_PTR_OR_NULL,	/* const argument used as pointer to bpf_map or NULL */
>   };
>   
>   /* type of values returned from helper functions */
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 3c1efc9d08fd..d3551a19853a 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -3849,9 +3849,13 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
>   		expected_type = SCALAR_VALUE;
>   		if (type != expected_type)
>   			goto err_type;
> -	} else if (arg_type == ARG_CONST_MAP_PTR) {
> +	} else if (arg_type == ARG_CONST_MAP_PTR ||
> +		   arg_type == ARG_CONST_MAP_PTR_OR_NULL) {
>   		expected_type = CONST_PTR_TO_MAP;
> -		if (type != expected_type)
> +		if (register_is_null(reg) &&
> +		    arg_type == ARG_CONST_MAP_PTR_OR_NULL)
> +			/* final test in check_stack_boundary() */;
> +		else if (type != expected_type)
>   			goto err_type;
>   	} else if (arg_type == ARG_PTR_TO_CTX ||
>   		   arg_type == ARG_PTR_TO_CTX_OR_NULL) {
> @@ -3957,7 +3961,8 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
>   		return -EFAULT;
>   	}
>   
> -	if (arg_type == ARG_CONST_MAP_PTR) {
> +	if (arg_type == ARG_CONST_MAP_PTR ||
> +	    (arg_type == ARG_CONST_MAP_PTR_OR_NULL && !register_is_null(reg))) {
>   		/* bpf_map_xxx(map_ptr) call: remember that map_ptr */
>   		meta->map_ptr = reg->map_ptr;

I would probably have the semantics a bit different in the sense that I would
update meta->map_ptr to the last ARG_CONST_MAP_PTR, meaning:

     meta->map_ptr = register_is_null(reg) ? NULL : reg->map_ptr;

>   	} else if (arg_type == ARG_PTR_TO_MAP_KEY) {
> 

In combination with the set, this also needs test_verifier selftests in order to
exercise BPF insn snippets for the good & [expected] bad case.

Thanks,
Daniel

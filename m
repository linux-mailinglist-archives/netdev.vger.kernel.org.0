Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 888DC25DB94
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 16:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730781AbgIDO0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 10:26:25 -0400
Received: from www62.your-server.de ([213.133.104.62]:33046 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730747AbgIDO0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 10:26:18 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kECfP-00008k-OL; Fri, 04 Sep 2020 16:26:15 +0200
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux.fritz.box)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kECfP-000Dsz-G2; Fri, 04 Sep 2020 16:26:15 +0200
Subject: Re: [PATCHv10 bpf-next 1/5] bpf: add a new bpf argument type
 ARG_CONST_MAP_PTR_OR_NULL
To:     Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
References: <20200826132002.2808380-1-liuhangbin@gmail.com>
 <20200903102701.3913258-1-liuhangbin@gmail.com>
 <20200903102701.3913258-2-liuhangbin@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <a72776ea-4252-41b0-1783-d70abd2baffa@iogearbox.net>
Date:   Fri, 4 Sep 2020 16:26:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200903102701.3913258-2-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25919/Thu Sep  3 15:39:22 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/3/20 12:26 PM, Hangbin Liu wrote:
> Add a new bpf argument type ARG_CONST_MAP_PTR_OR_NULL which could be
> used when we want to allow NULL pointer for map parameter. The bpf helper
> need to take care and check if the map is NULL when use this type.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
> 
> v10: remove useless CONST_PTR_TO_MAP_OR_NULL and Copy-paste comment.
> v9: merge the patch from [1] in to this series.
> v1-v8: no this patch
> 
> [1] https://lore.kernel.org/bpf/20200715070001.2048207-1-liuhangbin@gmail.com/
> 
> ---
>   include/linux/bpf.h   |  1 +
>   kernel/bpf/verifier.c | 14 +++++++++-----
>   2 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index c6d9f2c444f4..884392297874 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -292,6 +292,7 @@ enum bpf_arg_type {
>   	ARG_PTR_TO_ALLOC_MEM,	/* pointer to dynamically allocated memory */
>   	ARG_PTR_TO_ALLOC_MEM_OR_NULL,	/* pointer to dynamically allocated memory or NULL */
>   	ARG_CONST_ALLOC_SIZE_OR_ZERO,	/* number of allocated bytes requested */
> +	ARG_CONST_MAP_PTR_OR_NULL,	/* const argument used as pointer to bpf_map or NULL */
>   };
>   
>   /* type of values returned from helper functions */
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index b4e9c56b8b32..95444022f74c 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -3966,9 +3966,13 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
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
> +			/* fall through to next check */;
> +		else if (type != expected_type)
>   			goto err_type;
>   	} else if (arg_type == ARG_PTR_TO_CTX ||
>   		   arg_type == ARG_PTR_TO_CTX_OR_NULL) {
> @@ -4085,9 +4089,9 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 arg,
>   		return -EFAULT;
>   	}
>   
> -	if (arg_type == ARG_CONST_MAP_PTR) {
> -		/* bpf_map_xxx(map_ptr) call: remember that map_ptr */
> -		meta->map_ptr = reg->map_ptr;
> +	if (arg_type == ARG_CONST_MAP_PTR ||
> +	    arg_type == ARG_CONST_MAP_PTR_OR_NULL) {
> +		meta->map_ptr = register_is_null(reg) ? NULL : reg->map_ptr;

Lgtm, one thing to note is that meta->map_ptr is just a single var right now, so if there
are two maps as args like in your helper case, this would confuse verifier if we were to
do more elaborate verification on the types. Not the case here, but to keep in mind if
there are ever other helpers with two map args. I think we would need some bpf_func_proto
sanity check on this at some point to prevent such situations.

>   	} else if (arg_type == ARG_PTR_TO_MAP_KEY) {
>   		/* bpf_map_xxx(..., map_ptr, ..., key) call:
>   		 * check that [key, key + map->key_size) are within
> 


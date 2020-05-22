Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43EF31DF1D0
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 00:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731176AbgEVW1D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 18:27:03 -0400
Received: from www62.your-server.de ([213.133.104.62]:46286 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731122AbgEVW1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 18:27:03 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jcG84-00023q-9B; Sat, 23 May 2020 00:27:00 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jcG83-000LmB-Vu; Sat, 23 May 2020 00:27:00 +0200
Subject: Re: [PATCH v2 bpf-next 2/3] bpf: Relax the max_entries check for
 inner map
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>, kernel-team@fb.com,
        netdev@vger.kernel.org, Andrey Ignatov <rdna@fb.com>
References: <20200522022336.899416-1-kafai@fb.com>
 <20200522022349.900034-1-kafai@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <777e87c2-e871-8409-c942-38054ab2d419@iogearbox.net>
Date:   Sat, 23 May 2020 00:26:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200522022349.900034-1-kafai@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25820/Fri May 22 14:21:08 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/22/20 4:23 AM, Martin KaFai Lau wrote:
> This patch relaxes the max_entries check for most of the inner map types
> during an update to the outer map.  The max_entries of those map types
> are only used in runtime.  By doing this, an inner map with different
> size can be updated to the outer map in runtime.  People has a use
> case that starts with a smaller inner map first and then replaces
> it with a larger inner map later when it is needed.
> 
> The max_entries of arraymap and xskmap are used statically
> in verification time to generate the inline code, so they
> are excluded in this patch.
> 
> Cc: Andrey Ignatov <rdna@fb.com>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>   include/linux/bpf.h       | 12 ++++++++++++
>   include/linux/bpf_types.h |  6 ++++--
>   kernel/bpf/map_in_map.c   |  3 ++-
>   3 files changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index f947d899aa46..1839ef9aca02 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -99,6 +99,18 @@ struct bpf_map_memory {
>   
>   /* Cannot be used as an inner map */
>   #define BPF_MAP_NO_INNER_MAP (1 << 0)
> +/* When a prog has used map-in-map, the verifier requires
> + * an inner-map as a template to verify the access operations
> + * on the outer and inner map.  For some inner map-types,
> + * the verifier uses the inner_map's max_entries statically
> + * (e.g. to generate inline code).  If this verification
> + * time usage on max_entries applies to an inner map-type,
> + * during runtime, only the inner map with the same
> + * max_entries can be updated to this outer map.
> + *
> + * Please see bpf_map_meta_equal() for details.
> + */
> +#define BPF_MAP_NO_DYNAMIC_INNER_MAP_SIZE (1 << 1)
>   
>   struct bpf_map {
>   	/* The first two cachelines with read-mostly members of which some
> diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
> index 3f32702c9bf4..85861722b7f3 100644
> --- a/include/linux/bpf_types.h
> +++ b/include/linux/bpf_types.h
> @@ -78,7 +78,8 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_LSM, lsm,
>   
>   #define BPF_MAP_TYPE(x, y) BPF_MAP_TYPE_FL(x, y, 0)
>   
> -BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY, array_map_ops)
> +BPF_MAP_TYPE_FL(BPF_MAP_TYPE_ARRAY, array_map_ops,
> +		BPF_MAP_NO_DYNAMIC_INNER_MAP_SIZE)
>   BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_ARRAY, percpu_array_map_ops)
>   /* prog_array->aux->{type,jited} is a runtime binding.
>    * Doing static check alone in the verifier is not enough,
> @@ -116,7 +117,8 @@ BPF_MAP_TYPE(BPF_MAP_TYPE_SOCKHASH, sock_hash_ops)
>   #endif
>   BPF_MAP_TYPE(BPF_MAP_TYPE_CPUMAP, cpu_map_ops)
>   #if defined(CONFIG_XDP_SOCKETS)
> -BPF_MAP_TYPE(BPF_MAP_TYPE_XSKMAP, xsk_map_ops)
> +BPF_MAP_TYPE_FL(BPF_MAP_TYPE_XSKMAP, xsk_map_ops,
> +		BPF_MAP_NO_DYNAMIC_INNER_MAP_SIZE)
>   #endif
>   #ifdef CONFIG_INET
>   BPF_MAP_TYPE(BPF_MAP_TYPE_REUSEPORT_SOCKARRAY, reuseport_array_ops)
> diff --git a/kernel/bpf/map_in_map.c b/kernel/bpf/map_in_map.c
> index d965a1d328a9..b296fe8af1ad 100644
> --- a/kernel/bpf/map_in_map.c
> +++ b/kernel/bpf/map_in_map.c
> @@ -77,7 +77,8 @@ bool bpf_map_meta_equal(const struct bpf_map *meta0,
>   		meta0->key_size == meta1->key_size &&
>   		meta0->value_size == meta1->value_size &&
>   		meta0->map_flags == meta1->map_flags &&
> -		meta0->max_entries == meta1->max_entries;
> +		(meta0->max_entries == meta1->max_entries ||
> +		 !(meta0->properties & BPF_MAP_NO_DYNAMIC_INNER_MAP_SIZE));

Same thought here on making it an explicit opt-in instead. So no 'by default a
dynamic inner map size is safe and enabled' but instead the other way round and
allow the cases we know that are working and care about (e.g. htab, lru, etc)
where we can safely follow-up later with more on a case-by-case basis.

>   }
>   
>   void *bpf_map_fd_get_ptr(struct bpf_map *map,
> 


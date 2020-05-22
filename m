Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D68E1DF1C1
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 00:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731184AbgEVWW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 18:22:57 -0400
Received: from www62.your-server.de ([213.133.104.62]:45878 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731122AbgEVWW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 18:22:56 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jcG46-0001le-In; Sat, 23 May 2020 00:22:54 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jcG46-0008lt-AZ; Sat, 23 May 2020 00:22:54 +0200
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: Consolidate inner-map-compatible
 properties into bpf_types.h
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>, kernel-team@fb.com,
        netdev@vger.kernel.org, Andrey Ignatov <rdna@fb.com>
References: <20200522022336.899416-1-kafai@fb.com>
 <20200522022342.899756-1-kafai@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <9c00ced2-983f-ad59-d805-777ebd1f1cab@iogearbox.net>
Date:   Sat, 23 May 2020 00:22:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200522022342.899756-1-kafai@fb.com>
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
[...]
>   };
>   
> +/* Cannot be used as an inner map */
> +#define BPF_MAP_NO_INNER_MAP (1 << 0)
> +
>   struct bpf_map {
>   	/* The first two cachelines with read-mostly members of which some
>   	 * are also accessed in fast-path (e.g. ops, max_entries).
> @@ -120,6 +123,7 @@ struct bpf_map {
>   	struct bpf_map_memory memory;
>   	char name[BPF_OBJ_NAME_LEN];
>   	u32 btf_vmlinux_value_type_id;
> +	u32 properties;
>   	bool bypass_spec_v1;
>   	bool frozen; /* write-once; write-protected by freeze_mutex */
>   	/* 22 bytes hole */
> @@ -1037,12 +1041,12 @@ extern const struct file_operations bpf_iter_fops;
>   #define BPF_PROG_TYPE(_id, _name, prog_ctx_type, kern_ctx_type) \
>   	extern const struct bpf_prog_ops _name ## _prog_ops; \
>   	extern const struct bpf_verifier_ops _name ## _verifier_ops;
> -#define BPF_MAP_TYPE(_id, _ops) \
> +#define BPF_MAP_TYPE_FL(_id, _ops, properties) \
>   	extern const struct bpf_map_ops _ops;
>   #define BPF_LINK_TYPE(_id, _name)
>   #include <linux/bpf_types.h>
>   #undef BPF_PROG_TYPE
> -#undef BPF_MAP_TYPE
> +#undef BPF_MAP_TYPE_FL
>   #undef BPF_LINK_TYPE
>   
>   extern const struct bpf_prog_ops bpf_offload_prog_ops;
> diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
> index 29d22752fc87..3f32702c9bf4 100644
> --- a/include/linux/bpf_types.h
> +++ b/include/linux/bpf_types.h
> @@ -76,16 +76,25 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_LSM, lsm,
>   #endif /* CONFIG_BPF_LSM */
>   #endif
>   
> +#define BPF_MAP_TYPE(x, y) BPF_MAP_TYPE_FL(x, y, 0)
> +
>   BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY, array_map_ops)
>   BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_ARRAY, percpu_array_map_ops)
> -BPF_MAP_TYPE(BPF_MAP_TYPE_PROG_ARRAY, prog_array_map_ops)
> +/* prog_array->aux->{type,jited} is a runtime binding.
> + * Doing static check alone in the verifier is not enough,
> + * so BPF_MAP_NO_INNTER_MAP is needed.

typo: INNTER

> + */
> +BPF_MAP_TYPE_FL(BPF_MAP_TYPE_PROG_ARRAY, prog_array_map_ops,
> +		BPF_MAP_NO_INNER_MAP)

Probably nit, but what is "FL"? flags? We do have map_flags already, but here the
BPF_MAP_NO_INNER_MAP ends up in 'properties' instead. To avoid confusion, it would
probably be better to name it 'map_flags_fixed' since this is what it really means;
fixed flags that cannot be changed/controlled when creating a map.

>   BPF_MAP_TYPE(BPF_MAP_TYPE_PERF_EVENT_ARRAY, perf_event_array_map_ops)
>   #ifdef CONFIG_CGROUPS
>   BPF_MAP_TYPE(BPF_MAP_TYPE_CGROUP_ARRAY, cgroup_array_map_ops)
>   #endif
>   #ifdef CONFIG_CGROUP_BPF
> -BPF_MAP_TYPE(BPF_MAP_TYPE_CGROUP_STORAGE, cgroup_storage_map_ops)
> -BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE, cgroup_storage_map_ops)
> +BPF_MAP_TYPE_FL(BPF_MAP_TYPE_CGROUP_STORAGE, cgroup_storage_map_ops,
> +		BPF_MAP_NO_INNER_MAP)
> +BPF_MAP_TYPE_FL(BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE, cgroup_storage_map_ops,
> +		BPF_MAP_NO_INNER_MAP)
>   #endif
>   BPF_MAP_TYPE(BPF_MAP_TYPE_HASH, htab_map_ops)
>   BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_HASH, htab_percpu_map_ops)
> @@ -116,8 +125,10 @@ BPF_MAP_TYPE(BPF_MAP_TYPE_REUSEPORT_SOCKARRAY, reuseport_array_ops)
>   BPF_MAP_TYPE(BPF_MAP_TYPE_QUEUE, queue_map_ops)
>   BPF_MAP_TYPE(BPF_MAP_TYPE_STACK, stack_map_ops)
>   #if defined(CONFIG_BPF_JIT)
> -BPF_MAP_TYPE(BPF_MAP_TYPE_STRUCT_OPS, bpf_struct_ops_map_ops)
> +BPF_MAP_TYPE_FL(BPF_MAP_TYPE_STRUCT_OPS, bpf_struct_ops_map_ops,
> +		BPF_MAP_NO_INNER_MAP)
>   #endif
> +#undef BPF_MAP_TYPE
>   
>   BPF_LINK_TYPE(BPF_LINK_TYPE_RAW_TRACEPOINT, raw_tracepoint)
>   BPF_LINK_TYPE(BPF_LINK_TYPE_TRACING, tracing)
[...]
> diff --git a/kernel/bpf/map_in_map.c b/kernel/bpf/map_in_map.c
> index 17738c93bec8..d965a1d328a9 100644
> --- a/kernel/bpf/map_in_map.c
> +++ b/kernel/bpf/map_in_map.c
> @@ -17,13 +17,7 @@ struct bpf_map *bpf_map_meta_alloc(int inner_map_ufd)
>   	if (IS_ERR(inner_map))
>   		return inner_map;
>   
> -	/* prog_array->aux->{type,jited} is a runtime binding.
> -	 * Doing static check alone in the verifier is not enough.
> -	 */
> -	if (inner_map->map_type == BPF_MAP_TYPE_PROG_ARRAY ||
> -	    inner_map->map_type == BPF_MAP_TYPE_CGROUP_STORAGE ||
> -	    inner_map->map_type == BPF_MAP_TYPE_PERCPU_CGROUP_STORAGE ||
> -	    inner_map->map_type == BPF_MAP_TYPE_STRUCT_OPS) {
> +	if (inner_map->properties & BPF_MAP_NO_INNER_MAP) {
>   		fdput(f);
>   		return ERR_PTR(-ENOTSUPP);
>   	}

This whole check here is currently very fragile. For example, given we forbid cgroup
local storage here, why do we not forbid socket local storage? What about other maps
like stackmap? It's quite unclear if it even works as expected and if there's also a
use-case we are aware of. Why not making this an explicit opt-in?

Like explicit annotating via struct bpf_map_ops where everything is visible in one
single place where the map is defined:

const struct bpf_map_ops array_map_ops = {
         .map_alloc_check = array_map_alloc_check,
         [...]
         .map_flags_fixed = BPF_MAP_IN_MAP_OK,
};

That way, if someone forgets to add .map_flags_fixed to a new map type, it's okay since
it's _safe_ to forget to add these flags (and okay to add in future uapi-wise) as opposed
to the other way round where one can easily miss the opt-out case and potentially crash
the machine worst case.

Thanks,
Daniel

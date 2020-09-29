Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7CBD27D063
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 16:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730318AbgI2OCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 10:02:14 -0400
Received: from www62.your-server.de ([213.133.104.62]:42250 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729073AbgI2OCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 10:02:13 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kNGCo-00076i-Ng; Tue, 29 Sep 2020 16:02:10 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kNGCo-0006Xr-Hi; Tue, 29 Sep 2020 16:02:10 +0200
Subject: Re: [PATCH bpf-next 1/2] bpf: introduce BPF_F_SHARE_PE for perf event
 array
To:     Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kernel-team@fb.com, ast@kernel.org, john.fastabend@gmail.com,
        kpsingh@chromium.org
References: <20200929084750.419168-1-songliubraving@fb.com>
 <20200929084750.419168-2-songliubraving@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <04ba2027-a5ad-d715-ffc8-67f13e40f2d2@iogearbox.net>
Date:   Tue, 29 Sep 2020 16:02:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200929084750.419168-2-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25941/Mon Sep 28 15:55:11 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/29/20 10:47 AM, Song Liu wrote:
> Currently, perf event in perf event array is removed from the array when
> the map fd used to add the event is closed. This behavior makes it
> difficult to the share perf events with perf event array.
> 
> Introduce perf event map that keeps the perf event open with a new flag
> BPF_F_SHARE_PE. With this flag set, perf events in the array are not
> removed when the original map fd is closed. Instead, the perf event will
> stay in the map until 1) it is explicitly removed from the array; or 2)
> the array is freed.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>   include/uapi/linux/bpf.h       |  3 +++
>   kernel/bpf/arraymap.c          | 31 +++++++++++++++++++++++++++++--
>   tools/include/uapi/linux/bpf.h |  3 +++
>   3 files changed, 35 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 82522f05c0213..74f7a09e9d1e3 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -414,6 +414,9 @@ enum {
>   
>   /* Enable memory-mapping BPF map */
>   	BPF_F_MMAPABLE		= (1U << 10),
> +
> +/* Share perf_event among processes */
> +	BPF_F_SHARE_PE		= (1U << 11),

nit but given UAPI: maybe name into something more self-descriptive
like BPF_F_SHAREABLE_EVENT ?

>   };
>   
>   /* Flags for BPF_PROG_QUERY. */
> diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
> index e5fd31268ae02..4938ff183d846 100644
> --- a/kernel/bpf/arraymap.c
> +++ b/kernel/bpf/arraymap.c
> @@ -15,7 +15,7 @@
>   #include "map_in_map.h"
>   
>   #define ARRAY_CREATE_FLAG_MASK \
> -	(BPF_F_NUMA_NODE | BPF_F_MMAPABLE | BPF_F_ACCESS_MASK)
> +	(BPF_F_NUMA_NODE | BPF_F_MMAPABLE | BPF_F_ACCESS_MASK | BPF_F_SHARE_PE)
>   
>   static void bpf_array_free_percpu(struct bpf_array *array)
>   {
> @@ -64,6 +64,10 @@ int array_map_alloc_check(union bpf_attr *attr)
>   	    attr->map_flags & BPF_F_MMAPABLE)
>   		return -EINVAL;
>   
> +	if (attr->map_type != BPF_MAP_TYPE_PERF_EVENT_ARRAY &&
> +	    attr->map_flags & BPF_F_SHARE_PE)
> +		return -EINVAL;
> +
>   	if (attr->value_size > KMALLOC_MAX_SIZE)
>   		/* if value_size is bigger, the user space won't be able to
>   		 * access the elements.
> @@ -778,6 +782,26 @@ static int fd_array_map_delete_elem(struct bpf_map *map, void *key)
>   	}
>   }
>   
> +static void perf_event_fd_array_map_free(struct bpf_map *map)
> +{
> +	struct bpf_event_entry *ee;
> +	struct bpf_array *array;
> +	int i;
> +
> +	if ((map->map_flags & BPF_F_SHARE_PE) == 0) {
> +		fd_array_map_free(map);
> +		return;
> +	}
> +
> +	array = container_of(map, struct bpf_array, map);
> +	for (i = 0; i < array->map.max_entries; i++) {
> +		ee = READ_ONCE(array->ptrs[i]);
> +		if (ee)
> +			fd_array_map_delete_elem(map, &i);
> +	}
> +	bpf_map_area_free(array);

Why not simplify into:

	if (map->map_flags & BPF_F_SHAREABLE_EVENT)
		bpf_fd_array_map_clear(map);
	fd_array_map_free(map);

> +}
> +
>   static void *prog_fd_array_get_ptr(struct bpf_map *map,
>   				   struct file *map_file, int fd)
>   {
> @@ -1134,6 +1158,9 @@ static void perf_event_fd_array_release(struct bpf_map *map,
>   	struct bpf_event_entry *ee;
>   	int i;
>   
> +	if (map->map_flags & BPF_F_SHARE_PE)
> +		return;
> +
>   	rcu_read_lock();
>   	for (i = 0; i < array->map.max_entries; i++) {
>   		ee = READ_ONCE(array->ptrs[i]);
> @@ -1148,7 +1175,7 @@ const struct bpf_map_ops perf_event_array_map_ops = {
>   	.map_meta_equal = bpf_map_meta_equal,
>   	.map_alloc_check = fd_array_map_alloc_check,
>   	.map_alloc = array_map_alloc,
> -	.map_free = fd_array_map_free,
> +	.map_free = perf_event_fd_array_map_free,
>   	.map_get_next_key = array_map_get_next_key,
>   	.map_lookup_elem = fd_array_map_lookup_elem,
>   	.map_delete_elem = fd_array_map_delete_elem,
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index 82522f05c0213..74f7a09e9d1e3 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -414,6 +414,9 @@ enum {
>   
>   /* Enable memory-mapping BPF map */
>   	BPF_F_MMAPABLE		= (1U << 10),
> +
> +/* Share perf_event among processes */
> +	BPF_F_SHARE_PE		= (1U << 11),
>   };
>   
>   /* Flags for BPF_PROG_QUERY. */
> 


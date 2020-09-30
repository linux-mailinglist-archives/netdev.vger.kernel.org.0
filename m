Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F52F27EB57
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 16:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730710AbgI3Otb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 10:49:31 -0400
Received: from www62.your-server.de ([213.133.104.62]:47002 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730520AbgI3Ota (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 10:49:30 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kNdQ8-0008QA-PB; Wed, 30 Sep 2020 16:49:28 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kNdQ8-00013G-Il; Wed, 30 Sep 2020 16:49:28 +0200
Subject: Re: [PATCH v2 bpf-next 1/2] bpf: introduce BPF_F_PRESERVE_ELEMS for
 perf event array
To:     Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kernel-team@fb.com, ast@kernel.org, john.fastabend@gmail.com,
        kpsingh@chromium.org
References: <20200929215659.3938706-1-songliubraving@fb.com>
 <20200929215659.3938706-2-songliubraving@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c7b572d4-df22-db9d-6c01-d2b577c47116@iogearbox.net>
Date:   Wed, 30 Sep 2020 16:49:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200929215659.3938706-2-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25942/Tue Sep 29 15:56:33 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/29/20 11:56 PM, Song Liu wrote:
[...]
>   
> +static void bpf_fd_array_map_clear(struct bpf_map *map);
> +
> +static void perf_event_fd_array_map_free(struct bpf_map *map)
> +{
> +	if (map->map_flags & BPF_F_PRESERVE_ELEMS)
> +		bpf_fd_array_map_clear(map);
> +	fd_array_map_free(map);
> +}

Not quite sure why you place that here and added the fwd declaration? If you
place perf_event_fd_array_map_free() near perf_event_array_map_ops, then you
also don't need the additional bpf_fd_array_map_clear declaration.

>   static void *prog_fd_array_get_ptr(struct bpf_map *map,
>   				   struct file *map_file, int fd)
>   {
> @@ -1134,6 +1148,9 @@ static void perf_event_fd_array_release(struct bpf_map *map,
>   	struct bpf_event_entry *ee;
>   	int i;
>   
> +	if (map->map_flags & BPF_F_PRESERVE_ELEMS)
> +		return;
> +
>   	rcu_read_lock();
>   	for (i = 0; i < array->map.max_entries; i++) {
>   		ee = READ_ONCE(array->ptrs[i]);
> @@ -1148,7 +1165,7 @@ const struct bpf_map_ops perf_event_array_map_ops = {
>   	.map_meta_equal = bpf_map_meta_equal,
>   	.map_alloc_check = fd_array_map_alloc_check,
>   	.map_alloc = array_map_alloc,
> -	.map_free = fd_array_map_free,
> +	.map_free = perf_event_fd_array_map_free,
>   	.map_get_next_key = array_map_get_next_key,
>   	.map_lookup_elem = fd_array_map_lookup_elem,
>   	.map_delete_elem = fd_array_map_delete_elem,
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index 82522f05c0213..ea78eb89f8d67 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -414,6 +414,9 @@ enum {
>   
>   /* Enable memory-mapping BPF map */
>   	BPF_F_MMAPABLE		= (1U << 10),
> +
> +/* Share perf_event among processes */
> +	BPF_F_PRESERVE_ELEMS	= (1U << 11),
>   };
>   
>   /* Flags for BPF_PROG_QUERY. */
> 


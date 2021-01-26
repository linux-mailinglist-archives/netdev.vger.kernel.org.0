Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A88E2304DA8
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 01:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387599AbhAZXNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:13:18 -0500
Received: from www62.your-server.de ([213.133.104.62]:38600 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728175AbhAZWGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 17:06:00 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1l4WSI-0007jY-Jj; Tue, 26 Jan 2021 23:04:58 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1l4WSI-000TDX-BY; Tue, 26 Jan 2021 23:04:58 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [Patch bpf-next v5 1/3] bpf: introduce timeout hash map
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jhs@mojatatu.com, andrii@kernel.org,
        ast@kernel.org, kafai@fb.com, Cong Wang <cong.wang@bytedance.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>
References: <20210122205415.113822-1-xiyou.wangcong@gmail.com>
 <20210122205415.113822-2-xiyou.wangcong@gmail.com>
Message-ID: <d69d44ca-206c-d818-1177-c8f14d8be8d1@iogearbox.net>
Date:   Tue, 26 Jan 2021 23:04:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210122205415.113822-2-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26061/Tue Jan 26 13:29:51 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/22/21 9:54 PM, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> This borrows the idea from conntrack and will be used for conntrack in
> ebpf too. Each element in a timeout map has a user-specified timeout
> in msecs, after it expires it will be automatically removed from the
> map. Cilium already does the same thing, it uses a regular map or LRU
> map to track connections and has its own GC in user-space. This does
> not scale well when we have millions of connections, as each removal
> needs a syscall. Even if we could batch the operations, it still needs
> to copy a lot of data between kernel and user space.
> 
> There are two cases to consider here:
> 
> 1. When the timeout map is idle, i.e. no one updates or accesses it,
>     we rely on the delayed work to scan the whole hash table and remove
>     these expired. The delayed work is scheduled every 1 sec when idle,
>     which is also what conntrack uses. It is fine to scan the whole
>     table as we do not actually remove elements during this scan,
>     instead we simply queue them to the lockless list and defer all the
>     removals to the next schedule.
> 
> 2. When the timeout map is actively accessed, we could reach expired
>     elements before the idle work automatically scans them, we can
>     simply skip them and schedule the delayed work immediately to do
>     the actual removals. We have to avoid taking locks on fast path.
> 
> The timeout of an element can be set or updated via bpf_map_update_elem()
> and we reuse the upper 32-bit of the 64-bit flag for the timeout value,
> as there are only a few bits are used currently. Note, a zero timeout
> means to expire immediately.
> 
> To avoid adding memory overhead to regular map, we have to reuse some
> field in struct htab_elem, that is, lru_node. Otherwise we would have
> to rewrite a lot of code.
> 
> For now, batch ops is not supported, we can add it later if needed.

Back in earlier conversation [0], I mentioned also LRU map flavors and to look
into adding a flag, so we wouldn't need new BPF_MAP_TYPE_TIMEOUT_HASH/*LRU types
that replicate existing types once again just with the timeout in addition, so
UAPI wise new map type is not great.

Given you mention Cilium above, only for kernels where there is no LRU hash map,
that is < 4.10, we rely on plain hash, everything else LRU + prealloc to mitigate
ddos by refusing to add new entries when full whereas less active ones will be
purged instead. Timeout /only/ for plain hash is less useful overall, did you
sketch a more generic approach in the meantime that would work for all the htab/lru
flavors (and ideally as non-delayed_work based)?

   [0] https://lore.kernel.org/bpf/20201214201118.148126-1-xiyou.wangcong@gmail.com/

[...]
> @@ -1012,6 +1081,8 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
>   			copy_map_value_locked(map,
>   					      l_old->key + round_up(key_size, 8),
>   					      value, false);
> +			if (timeout_map)
> +				l_old->expires = msecs_to_expire(timeout);
>   			return 0;
>   		}
>   		/* fall through, grab the bucket lock and lookup again.
> @@ -1020,6 +1091,7 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
>   		 */
>   	}
>   
> +again:
>   	ret = htab_lock_bucket(htab, b, hash, &flags);
>   	if (ret)
>   		return ret;
> @@ -1040,26 +1112,41 @@ static int htab_map_update_elem(struct bpf_map *map, void *key, void *value,
>   		copy_map_value_locked(map,
>   				      l_old->key + round_up(key_size, 8),
>   				      value, false);
> +		if (timeout_map)
> +			l_old->expires = msecs_to_expire(timeout);
>   		ret = 0;
>   		goto err;
>   	}
>   
>   	l_new = alloc_htab_elem(htab, key, value, key_size, hash, false, false,
> -				l_old);
> +				timeout_map, l_old);
>   	if (IS_ERR(l_new)) {
> -		/* all pre-allocated elements are in use or memory exhausted */
>   		ret = PTR_ERR(l_new);
> +		if (ret == -EAGAIN) {
> +			htab_unlock_bucket(htab, b, hash, flags);
> +			htab_gc_elem(htab, l_old);
> +			mod_delayed_work(system_unbound_wq, &htab->gc_work, 0);
> +			goto again;

Also this one looks rather worrying, so the BPF prog is stalled here, loop-waiting
in (e.g. XDP) hot path for system_unbound_wq to kick in to make forward progress?

> +		}
> +		/* all pre-allocated elements are in use or memory exhausted */
>   		goto err;
>   	}
>   
> +	if (timeout_map)
> +		l_new->expires = msecs_to_expire(timeout);
> +

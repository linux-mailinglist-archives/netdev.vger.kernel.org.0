Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C00486D92
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 00:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245400AbiAFXLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 18:11:21 -0500
Received: from www62.your-server.de ([213.133.104.62]:47918 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234795AbiAFXLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 18:11:20 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1n5bue-000436-GF; Fri, 07 Jan 2022 00:11:16 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1n5bue-000LZU-3b; Fri, 07 Jan 2022 00:11:16 +0100
Subject: Re: [PATCH bpf-next v4 1/3] bpf: Add map tracing functions and call
 sites
To:     Joe Burton <jevburton.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, ppenkov@google.com,
        sdf@google.com, haoluo@google.com
Cc:     Joe Burton <jevburton@google.com>
References: <20220105030345.3255846-1-jevburton.kernel@gmail.com>
 <20220105030345.3255846-2-jevburton.kernel@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <52eb82c3-2272-1707-9de7-8347b57b933c@iogearbox.net>
Date:   Fri, 7 Jan 2022 00:11:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220105030345.3255846-2-jevburton.kernel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26414/Thu Jan  6 10:26:00 2022)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/22 4:03 AM, Joe Burton wrote:
> From: Joe Burton <jevburton@google.com>
> 
> Add two functions that fentry/fexit/fmod_ret programs can attach to:
> 	bpf_map_trace_update_elem
> 	bpf_map_trace_delete_elem
> These functions have the same arguments as bpf_map_{update,delete}_elem.
> 
> Invoke these functions from the following map types:
> 	BPF_MAP_TYPE_ARRAY
> 	BPF_MAP_TYPE_PERCPU_ARRAY
> 	BPF_MAP_TYPE_HASH
> 	BPF_MAP_TYPE_PERCPU_HASH
> 	BPF_MAP_TYPE_LRU_HASH
> 	BPF_MAP_TYPE_LRU_PERCPU_HASH
> 
> The only guarantee about these functions is that they are invoked before
> the corresponding action occurs. Other conditions may prevent the
> corresponding action from occurring after the function is invoked.
> 
> Signed-off-by: Joe Burton <jevburton@google.com>
> ---
>   kernel/bpf/Makefile    |  2 +-
>   kernel/bpf/arraymap.c  |  4 +++-
>   kernel/bpf/hashtab.c   | 20 +++++++++++++++++++-
>   kernel/bpf/map_trace.c | 17 +++++++++++++++++
>   kernel/bpf/map_trace.h | 19 +++++++++++++++++++
>   5 files changed, 59 insertions(+), 3 deletions(-)
>   create mode 100644 kernel/bpf/map_trace.c
>   create mode 100644 kernel/bpf/map_trace.h
> 
> diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
> index c1a9be6a4b9f..0cf38dab339a 100644
> --- a/kernel/bpf/Makefile
> +++ b/kernel/bpf/Makefile
> @@ -9,7 +9,7 @@ CFLAGS_core.o += $(call cc-disable-warning, override-init) $(cflags-nogcse-yy)
>   obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o task_iter.o prog_iter.o
>   obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o bloom_filter.o
>   obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o ringbuf.o
> -obj-$(CONFIG_BPF_SYSCALL) += bpf_local_storage.o bpf_task_storage.o
> +obj-$(CONFIG_BPF_SYSCALL) += bpf_local_storage.o bpf_task_storage.o map_trace.o
>   obj-${CONFIG_BPF_LSM}	  += bpf_inode_storage.o
>   obj-$(CONFIG_BPF_SYSCALL) += disasm.o
>   obj-$(CONFIG_BPF_JIT) += trampoline.o
> diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
> index c7a5be3bf8be..e9e7bd27ffad 100644
> --- a/kernel/bpf/arraymap.c
> +++ b/kernel/bpf/arraymap.c
> @@ -13,6 +13,7 @@
>   #include <linux/rcupdate_trace.h>
>   
>   #include "map_in_map.h"
> +#include "map_trace.h"
>   
>   #define ARRAY_CREATE_FLAG_MASK \
>   	(BPF_F_NUMA_NODE | BPF_F_MMAPABLE | BPF_F_ACCESS_MASK | \
> @@ -329,7 +330,8 @@ static int array_map_update_elem(struct bpf_map *map, void *key, void *value,
>   			copy_map_value(map, val, value);
>   		check_and_free_timer_in_array(array, val);
>   	}
> -	return 0;
> +
> +	return bpf_map_trace_update_elem(map, key, value, map_flags);

Given post-update, do you have a use case where you make use of the fmod_ret for
propagating non-zero ret codes?

Could you also extend commit description on rationale to not add these dummy
funcs more higher level, e.g. into map_update_elem() upon success?

[...]
> @@ -1133,6 +1137,10 @@ static int htab_lru_map_update_elem(struct bpf_map *map, void *key, void *value,
>   		/* unknown flags */
>   		return -EINVAL;
>   
> +	ret = bpf_map_trace_update_elem(map, key, value, map_flags);
> +	if (unlikely(ret))
> +		return ret;
> +
>   	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_trace_held() &&
>   		     !rcu_read_lock_bh_held());
>   
> @@ -1182,6 +1190,8 @@ static int htab_lru_map_update_elem(struct bpf_map *map, void *key, void *value,
>   	else if (l_old)
>   		htab_lru_push_free(htab, l_old);
>   
> +	if (!ret)
> +		ret = bpf_map_trace_update_elem(map, key, value, map_flags);
>   	return ret;
>   }

Here, it's pre and post update, is that intentional?

Thanks,
Daniel

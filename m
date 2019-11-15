Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C880FE898
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 00:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727344AbfKOXYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 18:24:04 -0500
Received: from www62.your-server.de ([213.133.104.62]:56324 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbfKOXYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 18:24:04 -0500
Received: from sslproxy01.your-server.de ([88.198.220.130])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iVkwa-0003XA-Pl; Sat, 16 Nov 2019 00:24:00 +0100
Received: from [178.197.248.45] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iVkwa-0005ww-B2; Sat, 16 Nov 2019 00:24:00 +0100
Subject: Re: [PATCH v4 bpf-next 1/4] bpf: switch bpf_map ref counter to 64bit
 so bpf_map_inc never fails
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20191115040225.2147245-1-andriin@fb.com>
 <20191115040225.2147245-2-andriin@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <7032bc3c-9375-876d-8d97-1ed21e94ae92@iogearbox.net>
Date:   Sat, 16 Nov 2019 00:23:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191115040225.2147245-2-andriin@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25634/Fri Nov 15 10:44:37 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/15/19 5:02 AM, Andrii Nakryiko wrote:
> 92117d8443bc ("bpf: fix refcnt overflow") turned refcounting of bpf_map into
> potentially failing operation, when refcount reaches BPF_MAX_REFCNT limit
> (32k). Due to using 32-bit counter, it's possible in practice to overflow
> refcounter and make it wrap around to 0, causing erroneous map free, while
> there are still references to it, causing use-after-free problems.

You mention 'it's possible in practice' to overflow in relation to bpf map
refcount, do we need any fixing for bpf tree here?

> But having a failing refcounting operations are problematic in some cases. One
> example is mmap() interface. After establishing initial memory-mapping, user
> is allowed to arbitrarily map/remap/unmap parts of mapped memory, arbitrarily
> splitting it into multiple non-contiguous regions. All this happening without
> any control from the users of mmap subsystem. Rather mmap subsystem sends
> notifications to original creator of memory mapping through open/close
> callbacks, which are optionally specified during initial memory mapping
> creation. These callbacks are used to maintain accurate refcount for bpf_map
> (see next patch in this series). The problem is that open() callback is not
> supposed to fail, because memory-mapped resource is set up and properly
> referenced. This is posing a problem for using memory-mapping with BPF maps.
> 
> One solution to this is to maintain separate refcount for just memory-mappings
> and do single bpf_map_inc/bpf_map_put when it goes from/to zero, respectively.
> There are similar use cases in current work on tcp-bpf, necessitating extra
> counter as well. This seems like a rather unfortunate and ugly solution that
> doesn't scale well to various new use cases.
> 
> Another approach to solve this is to use non-failing refcount_t type, which
> uses 32-bit counter internally, but, once reaching overflow state at UINT_MAX,
> stays there. This utlimately causes memory leak, but prevents use after free.
> 
> But given refcounting is not the most performance-critical operation with BPF
> maps (it's not used from running BPF program code), we can also just switch to
> 64-bit counter that can't overflow in practice, potentially disadvantaging
> 32-bit platforms a tiny bit. This simplifies semantics and allows above
> described scenarios to not worry about failing refcount increment operation.
> 
> In terms of struct bpf_map size, we are still good and use the same amount of
> space:
> 
> BEFORE (3 cache lines, 8 bytes of padding at the end):
> struct bpf_map {
> 	const struct bpf_map_ops  * ops __attribute__((__aligned__(64))); /*     0     8 */
> 	struct bpf_map *           inner_map_meta;       /*     8     8 */
> 	void *                     security;             /*    16     8 */
> 	enum bpf_map_type  map_type;                     /*    24     4 */
> 	u32                        key_size;             /*    28     4 */
> 	u32                        value_size;           /*    32     4 */
> 	u32                        max_entries;          /*    36     4 */
> 	u32                        map_flags;            /*    40     4 */
> 	int                        spin_lock_off;        /*    44     4 */
> 	u32                        id;                   /*    48     4 */
> 	int                        numa_node;            /*    52     4 */
> 	u32                        btf_key_type_id;      /*    56     4 */
> 	u32                        btf_value_type_id;    /*    60     4 */
> 	/* --- cacheline 1 boundary (64 bytes) --- */
> 	struct btf *               btf;                  /*    64     8 */
> 	struct bpf_map_memory memory;                    /*    72    16 */
> 	bool                       unpriv_array;         /*    88     1 */
> 	bool                       frozen;               /*    89     1 */
> 
> 	/* XXX 38 bytes hole, try to pack */
> 
> 	/* --- cacheline 2 boundary (128 bytes) --- */
> 	atomic_t                   refcnt __attribute__((__aligned__(64))); /*   128     4 */
> 	atomic_t                   usercnt;              /*   132     4 */
> 	struct work_struct work;                         /*   136    32 */
> 	char                       name[16];             /*   168    16 */
> 
> 	/* size: 192, cachelines: 3, members: 21 */
> 	/* sum members: 146, holes: 1, sum holes: 38 */
> 	/* padding: 8 */
> 	/* forced alignments: 2, forced holes: 1, sum forced holes: 38 */
> } __attribute__((__aligned__(64)));
> 
> AFTER (same 3 cache lines, no extra padding now):
> struct bpf_map {
> 	const struct bpf_map_ops  * ops __attribute__((__aligned__(64))); /*     0     8 */
> 	struct bpf_map *           inner_map_meta;       /*     8     8 */
> 	void *                     security;             /*    16     8 */
> 	enum bpf_map_type  map_type;                     /*    24     4 */
> 	u32                        key_size;             /*    28     4 */
> 	u32                        value_size;           /*    32     4 */
> 	u32                        max_entries;          /*    36     4 */
> 	u32                        map_flags;            /*    40     4 */
> 	int                        spin_lock_off;        /*    44     4 */
> 	u32                        id;                   /*    48     4 */
> 	int                        numa_node;            /*    52     4 */
> 	u32                        btf_key_type_id;      /*    56     4 */
> 	u32                        btf_value_type_id;    /*    60     4 */
> 	/* --- cacheline 1 boundary (64 bytes) --- */
> 	struct btf *               btf;                  /*    64     8 */
> 	struct bpf_map_memory memory;                    /*    72    16 */
> 	bool                       unpriv_array;         /*    88     1 */
> 	bool                       frozen;               /*    89     1 */
> 
> 	/* XXX 38 bytes hole, try to pack */
> 
> 	/* --- cacheline 2 boundary (128 bytes) --- */
> 	atomic64_t                 refcnt __attribute__((__aligned__(64))); /*   128     8 */
> 	atomic64_t                 usercnt;              /*   136     8 */
> 	struct work_struct work;                         /*   144    32 */
> 	char                       name[16];             /*   176    16 */
> 
> 	/* size: 192, cachelines: 3, members: 21 */
> 	/* sum members: 154, holes: 1, sum holes: 38 */
> 	/* forced alignments: 2, forced holes: 1, sum forced holes: 38 */
> } __attribute__((__aligned__(64)));
> 
> This patch, while modifying all users of bpf_map_inc, also cleans up its
> interface to match bpf_map_put with separate operations for bpf_map_inc and
> bpf_map_inc_with_uref (to match bpf_map_put and bpf_map_put_with_uref,
> respectively). Also, given there are no users of bpf_map_inc_not_zero
> specifying uref=true, remove uref flag and default to uref=false internally.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>   .../net/ethernet/netronome/nfp/bpf/offload.c  |  4 +-
>   include/linux/bpf.h                           | 10 ++--
>   kernel/bpf/inode.c                            |  2 +-
>   kernel/bpf/map_in_map.c                       |  2 +-
>   kernel/bpf/syscall.c                          | 51 ++++++++-----------
>   kernel/bpf/verifier.c                         |  6 +--
>   kernel/bpf/xskmap.c                           |  6 +--
>   net/core/bpf_sk_storage.c                     |  2 +-
>   8 files changed, 34 insertions(+), 49 deletions(-)
> 
[...]
> +	refold = atomic64_fetch_add_unless(&map->refcnt, 1, 0);
>   	if (!refold)
>   		return ERR_PTR(-ENOENT);
> -
>   	if (uref)
> -		atomic_inc(&map->usercnt);
> +		atomic64_inc(&map->usercnt);
>   
>   	return map;
>   }
>   
> -struct bpf_map *bpf_map_inc_not_zero(struct bpf_map *map, bool uref)
> +struct bpf_map *bpf_map_inc_not_zero(struct bpf_map *map)
>   {
>   	spin_lock_bh(&map_idr_lock);
> -	map = __bpf_map_inc_not_zero(map, uref);
> +	map = __bpf_map_inc_not_zero(map, false);
>   	spin_unlock_bh(&map_idr_lock);
>   
>   	return map;
> @@ -1454,6 +1444,9 @@ static struct bpf_prog *____bpf_prog_get(struct fd f)
>   	return f.file->private_data;
>   }
>   
> +/* prog's refcnt limit */
> +#define BPF_MAX_REFCNT 32768
> +

Would it make sense in this context to also convert prog refcount over to atomic64
so we have both in one go in order to align them again? This could likely simplify
even more wrt error paths.

>   struct bpf_prog *bpf_prog_add(struct bpf_prog *prog, int i)
>   {
>   	if (atomic_add_return(i, &prog->aux->refcnt) > BPF_MAX_REFCNT) {

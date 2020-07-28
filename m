Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E262303A6
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 09:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgG1HO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 03:14:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:17345 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726885AbgG1HO6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 03:14:58 -0400
IronPort-SDR: JVnqZ9H42Wc43zN/g1ZBAdUOMsDH9B/OmoPd1Rt3mfwrLZW4HJ8Oz0EAcQNkRV4Cyaf+dqmp1Z
 pLHYeoKDor+g==
X-IronPort-AV: E=McAfee;i="6000,8403,9695"; a="169275731"
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="169275731"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2020 00:14:58 -0700
IronPort-SDR: El4VcZLOJt/yUH0v5cTJ/RXTjDiK8r2CDm0e15OmuN+LS7gH5oSMfaAdA9pvEXI+7ee8NKVySD
 KJwJZiXVWulg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,405,1589266800"; 
   d="scan'208";a="322092127"
Received: from nheyde-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.57.223])
  by fmsmga002.fm.intel.com with ESMTP; 28 Jul 2020 00:14:55 -0700
Subject: Re: [PATCH bpf-next v4 09/14] xsk: rearrange internal structs for
 better performance
To:     Magnus Karlsson <magnus.karlsson@intel.com>, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maximmi@mellanox.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, cristian.dumitrescu@intel.com
References: <1595307848-20719-1-git-send-email-magnus.karlsson@intel.com>
 <1595307848-20719-10-git-send-email-magnus.karlsson@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <141bf975-52be-325b-7c48-a0c611695e19@intel.com>
Date:   Tue, 28 Jul 2020 09:14:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1595307848-20719-10-git-send-email-magnus.karlsson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020-07-21 07:04, Magnus Karlsson wrote:
> Rearrange the xdp_sock, xdp_umem and xsk_buff_pool structures so
> that they get smaller and align better to the cache lines. In the
> previous commits of this patch set, these structs have been
> reordered with the focus on functionality and simplicity, not
> performance. This patch improves throughput performance by around
> 3%.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Acked-by: Björn Töpel <bjorn.topel@intel.com>


> ---
>   include/net/xdp_sock.h      | 13 +++++++------
>   include/net/xsk_buff_pool.h | 27 +++++++++++++++------------
>   2 files changed, 22 insertions(+), 18 deletions(-)
> 
> diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
> index 282aeba..1a9559c 100644
> --- a/include/net/xdp_sock.h
> +++ b/include/net/xdp_sock.h
> @@ -23,13 +23,13 @@ struct xdp_umem {
>   	u32 headroom;
>   	u32 chunk_size;
>   	u32 chunks;
> +	u32 npgs;
>   	struct user_struct *user;
>   	refcount_t users;
> -	struct page **pgs;
> -	u32 npgs;
>   	u8 flags;
> -	int id;
>   	bool zc;
> +	struct page **pgs;
> +	int id;
>   	struct list_head xsk_dma_list;
>   };
>   
> @@ -42,7 +42,7 @@ struct xsk_map {
>   struct xdp_sock {
>   	/* struct sock must be the first member of struct xdp_sock */
>   	struct sock sk;
> -	struct xsk_queue *rx;
> +	struct xsk_queue *rx ____cacheline_aligned_in_smp;
>   	struct net_device *dev;
>   	struct xdp_umem *umem;
>   	struct list_head flush_node;
> @@ -54,8 +54,7 @@ struct xdp_sock {
>   		XSK_BOUND,
>   		XSK_UNBOUND,
>   	} state;
> -	/* Protects multiple processes in the control path */
> -	struct mutex mutex;
> +
>   	struct xsk_queue *tx ____cacheline_aligned_in_smp;
>   	struct list_head tx_list;
>   	/* Mutual exclusion of NAPI TX thread and sendmsg error paths
> @@ -72,6 +71,8 @@ struct xdp_sock {
>   	struct list_head map_list;
>   	/* Protects map_list */
>   	spinlock_t map_list_lock;
> +	/* Protects multiple processes in the control path */
> +	struct mutex mutex;
>   	struct xsk_queue *fq_tmp; /* Only as tmp storage before bind */
>   	struct xsk_queue *cq_tmp; /* Only as tmp storage before bind */
>   };
> diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
> index 8f1dc4c..b4d6307 100644
> --- a/include/net/xsk_buff_pool.h
> +++ b/include/net/xsk_buff_pool.h
> @@ -36,34 +36,37 @@ struct xsk_dma_map {
>   };
>   
>   struct xsk_buff_pool {
> -	struct xsk_queue *fq;
> -	struct xsk_queue *cq;
> +	/* Members only used in the control path first. */
> +	struct device *dev;
> +	struct net_device *netdev;
> +	struct list_head xsk_tx_list;
> +	/* Protects modifications to the xsk_tx_list */
> +	spinlock_t xsk_tx_list_lock;
> +	refcount_t users;
> +	struct xdp_umem *umem;
> +	struct work_struct work;
>   	struct list_head free_list;
> +	u32 heads_cnt;
> +	u16 queue_id;
> +
> +	/* Data path members as close to free_heads at the end as possible. */
> +	struct xsk_queue *fq ____cacheline_aligned_in_smp;
> +	struct xsk_queue *cq;
>   	dma_addr_t *dma_pages;
>   	struct xdp_buff_xsk *heads;
>   	u64 chunk_mask;
>   	u64 addrs_cnt;
>   	u32 free_list_cnt;
>   	u32 dma_pages_cnt;
> -	u32 heads_cnt;
>   	u32 free_heads_cnt;
>   	u32 headroom;
>   	u32 chunk_size;
>   	u32 frame_len;
> -	u16 queue_id;
>   	u8 cached_need_wakeup;
>   	bool uses_need_wakeup;
>   	bool dma_need_sync;
>   	bool unaligned;
> -	struct xdp_umem *umem;
>   	void *addrs;
> -	struct device *dev;
> -	struct net_device *netdev;
> -	struct list_head xsk_tx_list;
> -	/* Protects modifications to the xsk_tx_list */
> -	spinlock_t xsk_tx_list_lock;
> -	refcount_t users;
> -	struct work_struct work;
>   	struct xdp_buff_xsk *free_heads[];
>   };
>   
> 

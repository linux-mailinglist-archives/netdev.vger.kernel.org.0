Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 574BA39B456
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 09:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhFDHyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 03:54:50 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3427 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbhFDHyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 03:54:49 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FxFKj22d1z6tsM;
        Fri,  4 Jun 2021 15:50:01 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 4 Jun 2021 15:53:00 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Fri, 4 Jun 2021
 15:53:00 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
Subject: Re: [PATCH net-next v6 3/5] page_pool: Allow drivers to hint on SKB
 recycling
To:     Matteo Croce <mcroce@linux.microsoft.com>,
        <netdev@vger.kernel.org>, <linux-mm@kvack.org>
CC:     Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Thomas Petazzoni" <thomas.petazzoni@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>, Yu Zhao <yuzhao@google.com>,
        Will Deacon <will@kernel.org>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Roman Gushchin <guro@fb.com>, Hugh Dickins <hughd@google.com>,
        Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Cong Wang <cong.wang@bytedance.com>, wenxu <wenxu@ucloud.cn>,
        Kevin Hao <haokexin@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <bpf@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>, Paolo Abeni <pabeni@redhat.com>,
        Sven Auhagen <sven.auhagen@voleatech.de>
References: <20210521161527.34607-1-mcroce@linux.microsoft.com>
 <20210521161527.34607-4-mcroce@linux.microsoft.com>
Message-ID: <badedf51-ce74-061d-732c-61d0678180b3@huawei.com>
Date:   Fri, 4 Jun 2021 15:52:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210521161527.34607-4-mcroce@linux.microsoft.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme717-chm.china.huawei.com (10.1.199.113) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/5/22 0:15, Matteo Croce wrote:
> From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> 
> Up to now several high speed NICs have custom mechanisms of recycling
> the allocated memory they use for their payloads.
> Our page_pool API already has recycling capabilities that are always
> used when we are running in 'XDP mode'. So let's tweak the API and the
> kernel network stack slightly and allow the recycling to happen even
> during the standard operation.
> The API doesn't take into account 'split page' policies used by those
> drivers currently, but can be extended once we have users for that.
> 
> The idea is to be able to intercept the packet on skb_release_data().
> If it's a buffer coming from our page_pool API recycle it back to the
> pool for further usage or just release the packet entirely.
> 
> To achieve that we introduce a bit in struct sk_buff (pp_recycle:1) and
> a field in struct page (page->pp) to store the page_pool pointer.
> Storing the information in page->pp allows us to recycle both SKBs and
> their fragments.
> We could have skipped the skb bit entirely, since identical information
> can bederived from struct page. However, in an effort to affect the free path
> as less as possible, reading a single bit in the skb which is already
> in cache, is better that trying to derive identical information for the
> page stored data.
> 
> The driver or page_pool has to take care of the sync operations on it's own
> during the buffer recycling since the buffer is, after opting-in to the
> recycling, never unmapped.
> 
> Since the gain on the drivers depends on the architecture, we are not
> enabling recycling by default if the page_pool API is used on a driver.
> In order to enable recycling the driver must call skb_mark_for_recycle()
> to store the information we need for recycling in page->pp and
> enabling the recycling bit, or page_pool_store_mem_info() for a fragment.

The state of this patch in patchwork is "Not Applicable", so
you may need to respin it again.

Some minor comment below:

> 
> Co-developed-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Co-developed-by: Matteo Croce <mcroce@microsoft.com>
> Signed-off-by: Matteo Croce <mcroce@microsoft.com>
> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> ---
>  include/linux/skbuff.h  | 28 +++++++++++++++++++++++++---
>  include/net/page_pool.h |  9 +++++++++
>  net/core/page_pool.c    | 23 +++++++++++++++++++++++
>  net/core/skbuff.c       | 24 ++++++++++++++++++++----
>  4 files changed, 77 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 7fcfea7e7b21..057b40ad29bd 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -40,6 +40,9 @@
>  #if IS_ENABLED(CONFIG_NF_CONNTRACK)
>  #include <linux/netfilter/nf_conntrack_common.h>
>  #endif
> +#ifdef CONFIG_PAGE_POOL
> +#include <net/page_pool.h>
> +#endif
>  
>  /* The interface for checksum offload between the stack and networking drivers
>   * is as follows...
> @@ -667,6 +670,8 @@ typedef unsigned char *sk_buff_data_t;
>   *	@head_frag: skb was allocated from page fragments,
>   *		not allocated by kmalloc() or vmalloc().
>   *	@pfmemalloc: skbuff was allocated from PFMEMALLOC reserves
> + *	@pp_recycle: mark the packet for recycling instead of freeing (implies
> + *		page_pool support on driver)
>   *	@active_extensions: active extensions (skb_ext_id types)
>   *	@ndisc_nodetype: router type (from link layer)
>   *	@ooo_okay: allow the mapping of a socket to a queue to be changed
> @@ -791,10 +796,12 @@ struct sk_buff {
>  				fclone:2,
>  				peeked:1,
>  				head_frag:1,
> -				pfmemalloc:1;
> +				pfmemalloc:1,
> +				pp_recycle:1; /* page_pool recycle indicator */

The about comment seems unnecessary, for there is comment
added above in this patch to explain that.

>  #ifdef CONFIG_SKB_EXTENSIONS
>  	__u8			active_extensions;
>  #endif
> +

Unnecessary change?

>  	/* fields enclosed in headers_start/headers_end are copied
>  	 * using a single memcpy() in __copy_skb_header()
>  	 */
> @@ -3088,7 +3095,13 @@ static inline void skb_frag_ref(struct sk_buff *skb, int f)
>   */
>  static inline void __skb_frag_unref(skb_frag_t *frag, bool recycle)
>  {
> -	put_page(skb_frag_page(frag));
> +	struct page *page = skb_frag_page(frag);
> +
> +#ifdef CONFIG_PAGE_POOL
> +	if (recycle && page_pool_return_skb_page(page_address(page)))
> +		return;
> +#endif
> +	put_page(page);
>  }
>  
>  /**
> @@ -3100,7 +3113,7 @@ static inline void __skb_frag_unref(skb_frag_t *frag, bool recycle)
>   */
>  static inline void skb_frag_unref(struct sk_buff *skb, int f)
>  {
> -	__skb_frag_unref(&skb_shinfo(skb)->frags[f], false);
> +	__skb_frag_unref(&skb_shinfo(skb)->frags[f], skb->pp_recycle);
>  }
>  
>  /**
> @@ -4699,5 +4712,14 @@ static inline u64 skb_get_kcov_handle(struct sk_buff *skb)
>  #endif
>  }
>  
> +#ifdef CONFIG_PAGE_POOL
> +static inline void skb_mark_for_recycle(struct sk_buff *skb, struct page *page,
> +					struct page_pool *pp)
> +{
> +	skb->pp_recycle = 1;
> +	page_pool_store_mem_info(page, pp);
> +}
> +#endif
> +
>  #endif	/* __KERNEL__ */
>  #endif	/* _LINUX_SKBUFF_H */
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index b4b6de909c93..7b9b6a1c61f5 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -146,6 +146,8 @@ inline enum dma_data_direction page_pool_get_dma_dir(struct page_pool *pool)
>  	return pool->p.dma_dir;
>  }
>  
> +bool page_pool_return_skb_page(void *data);
> +
>  struct page_pool *page_pool_create(const struct page_pool_params *params);
>  
>  #ifdef CONFIG_PAGE_POOL
> @@ -251,4 +253,11 @@ static inline void page_pool_ring_unlock(struct page_pool *pool)
>  		spin_unlock_bh(&pool->ring.producer_lock);
>  }
>  
> +/* Store mem_info on struct page and use it while recycling skb frags */
> +static inline
> +void page_pool_store_mem_info(struct page *page, struct page_pool *pp)

The conventional practice seems to put "struct page_pool" before other
parameter in page_pool.h.

> +{
> +	page->pp = pp;
> +}
> +
>  #endif /* _NET_PAGE_POOL_H */
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index e1321bc9d316..2a020cca489f 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -628,3 +628,26 @@ void page_pool_update_nid(struct page_pool *pool, int new_nid)
>  	}
>  }
>  EXPORT_SYMBOL(page_pool_update_nid);
> +
> +bool page_pool_return_skb_page(void *data)
> +{
> +	struct page_pool *pp;
> +	struct page *page;
> +
> +	page = virt_to_head_page(data);
> +	if (unlikely(page->pp_magic != PP_SIGNATURE))
> +		return false;
> +
> +	pp = (struct page_pool *)page->pp;
> +
> +	/* Driver set this to memory recycling info. Reset it on recycle.
> +	 * This will *not* work for NIC using a split-page memory model.
> +	 * The page will be returned to the pool here regardless of the
> +	 * 'flipped' fragment being in use or not.
> +	 */

I am not sure I understand how does the last part of comment related
to the code below, as there is no driver using split-page memory model
will reach here because those driver will not call skb_mark_for_recycle(),
right?

> +	page->pp = NULL;
> +	page_pool_put_full_page(pp, virt_to_head_page(data), false);
> +
> +	return true;
> +}
> +EXPORT_SYMBOL(page_pool_return_skb_page);


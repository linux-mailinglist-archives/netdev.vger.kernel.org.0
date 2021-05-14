Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A1C38028B
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 05:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbhENDk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 23:40:56 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3755 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbhENDkz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 23:40:55 -0400
Received: from dggems702-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FhDhd0px1zqSTJ;
        Fri, 14 May 2021 11:36:17 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggems702-chm.china.huawei.com (10.3.19.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 14 May 2021 11:39:41 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Fri, 14 May
 2021 11:39:40 +0800
Subject: Re: [PATCH net-next v5 3/5] page_pool: Allow drivers to hint on SKB
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
References: <20210513165846.23722-1-mcroce@linux.microsoft.com>
 <20210513165846.23722-4-mcroce@linux.microsoft.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <798d6dad-7950-91b2-46a5-3535f44df4e2@huawei.com>
Date:   Fri, 14 May 2021 11:39:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210513165846.23722-4-mcroce@linux.microsoft.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme718-chm.china.huawei.com (10.1.199.114) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/5/14 0:58, Matteo Croce wrote:
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
> The SKB bit is needed for a couple of reasons. First of all in an effort
> to affect the free path as less as possible, reading a single bit,
> is better that trying to derive identical information for the page stored
> data. We do have a special mark in the page, that won't allow this to
> happen, but again deciding without having to read the entire page is
> preferable.
> 
> The driver has to take care of the sync operations on it's own
> during the buffer recycling since the buffer is, after opting-in to the
> recycling, never unmapped.
> 
> Since the gain on the drivers depends on the architecture, we are not
> enabling recycling by default if the page_pool API is used on a driver.
> In order to enable recycling the driver must call skb_mark_for_recycle()
> to store the information we need for recycling in page->pp and
> enabling the recycling bit, or page_pool_store_mem_info() for a fragment.
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
>  net/core/skbuff.c       | 25 +++++++++++++++++++++----
>  4 files changed, 78 insertions(+), 7 deletions(-)
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
>  #ifdef CONFIG_SKB_EXTENSIONS
>  	__u8			active_extensions;
>  #endif
> +
>  	/* fields enclosed in headers_start/headers_end are copied
>  	 * using a single memcpy() in __copy_skb_header()
>  	 */
> @@ -3088,7 +3095,13 @@ static inline void skb_frag_ref(struct sk_buff *skb, int f)
>   */
>  static inline void __skb_frag_unref(skb_frag_t *frag, bool recycle)

Does it make sure to define a new function like recyclable_skb_frag_unref()
instead of adding the recycle parameter? This way we may avoid checking
skb->pp_recycle for head data and every frag?

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
> index 24b3d42c62c0..ce75abeddb29 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -148,6 +148,8 @@ inline enum dma_data_direction page_pool_get_dma_dir(struct page_pool *pool)
>  	return pool->p.dma_dir;
>  }
>  
> +bool page_pool_return_skb_page(void *data);
> +
>  struct page_pool *page_pool_create(const struct page_pool_params *params);
>  
>  #ifdef CONFIG_PAGE_POOL
> @@ -253,4 +255,11 @@ static inline void page_pool_ring_unlock(struct page_pool *pool)
>  		spin_unlock_bh(&pool->ring.producer_lock);
>  }
>  
> +/* Store mem_info on struct page and use it while recycling skb frags */
> +static inline
> +void page_pool_store_mem_info(struct page *page, struct page_pool *pp)
> +{
> +	page->pp = pp;
> +}
> +
>  #endif /* _NET_PAGE_POOL_H */
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 9de5d8c08c17..fa9f17db7c48 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -626,3 +626,26 @@ void page_pool_update_nid(struct page_pool *pool, int new_nid)
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

we have checked the skb->pp_recycle before checking the page->pp_magic,
so the above seems like a likely() instead of unlikely()?

> +		return false;
> +
> +	pp = (struct page_pool *)page->pp;
> +
> +	/* Driver set this to memory recycling info. Reset it on recycle.
> +	 * This will *not* work for NIC using a split-page memory model.
> +	 * The page will be returned to the pool here regardless of the
> +	 * 'flipped' fragment being in use or not.
> +	 */
> +	page->pp = NULL;

Why not only clear the page->pp when the page can not be recycled
by the page pool? so that we do not need to set and clear it every
time the page is recycled。

> +	page_pool_put_full_page(pp, virt_to_head_page(data), false);
> +
> +	return true;
> +}
> +EXPORT_SYMBOL(page_pool_return_skb_page);
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 12b7e90dd2b5..9581af44d587 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -70,6 +70,9 @@
>  #include <net/xfrm.h>
>  #include <net/mpls.h>
>  #include <net/mptcp.h>
> +#ifdef CONFIG_PAGE_POOL
> +#include <net/page_pool.h>
> +#endif
>  
>  #include <linux/uaccess.h>
>  #include <trace/events/skb.h>
> @@ -645,10 +648,15 @@ static void skb_free_head(struct sk_buff *skb)
>  {
>  	unsigned char *head = skb->head;
>  
> -	if (skb->head_frag)
> +	if (skb->head_frag) {
> +#ifdef CONFIG_PAGE_POOL
> +		if (skb->pp_recycle && page_pool_return_skb_page(head))
> +			return;
> +#endif
>  		skb_free_frag(head);
> -	else
> +	} else {
>  		kfree(head);
> +	}
>  }
>  
>  static void skb_release_data(struct sk_buff *skb)
> @@ -664,7 +672,7 @@ static void skb_release_data(struct sk_buff *skb)
>  	skb_zcopy_clear(skb, true);
>  
>  	for (i = 0; i < shinfo->nr_frags; i++)
> -		__skb_frag_unref(&shinfo->frags[i], false);
> +		__skb_frag_unref(&shinfo->frags[i], skb->pp_recycle);
>  
>  	if (shinfo->frag_list)
>  		kfree_skb_list(shinfo->frag_list);
> @@ -1046,6 +1054,7 @@ static struct sk_buff *__skb_clone(struct sk_buff *n, struct sk_buff *skb)
>  	n->nohdr = 0;
>  	n->peeked = 0;
>  	C(pfmemalloc);
> +	C(pp_recycle);
>  	n->destructor = NULL;
>  	C(tail);
>  	C(end);
> @@ -1725,6 +1734,7 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
>  	skb->cloned   = 0;
>  	skb->hdr_len  = 0;
>  	skb->nohdr    = 0;
> +	skb->pp_recycle = 0;

I am not sure why we clear the skb->pp_recycle here.
As my understanding, the pskb_expand_head() only allocate new head
data, the old frag page in skb_shinfo()->frags still could be from
page pool， right?

>  	atomic_set(&skb_shinfo(skb)->dataref, 1);
>  
>  	skb_metadata_clear(skb);
> @@ -3495,7 +3505,7 @@ int skb_shift(struct sk_buff *tgt, struct sk_buff *skb, int shiftlen)
>  		fragto = &skb_shinfo(tgt)->frags[merge];
>  
>  		skb_frag_size_add(fragto, skb_frag_size(fragfrom));
> -		__skb_frag_unref(fragfrom, false);
> +		__skb_frag_unref(fragfrom, skb->pp_recycle);
>  	}
>  
>  	/* Reposition in the original skb */
> @@ -5285,6 +5295,13 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
>  	if (skb_cloned(to))
>  		return false;
>  
> +	/* We can't coalesce skb that are allocated from slab and page_pool
> +	 * The recycle mark is on the skb, so that might end up trying to
> +	 * recycle slab allocated skb->head
> +	 */
> +	if (to->pp_recycle != from->pp_recycle)
> +		return false;

Since we are also depending on page->pp_magic to decide whether to
recycle a page, we could just set the to->pp_recycle according to
from->pp_recycle and do the coalesce?

> +
>  	if (len <= skb_tailroom(to)) {
>  		if (len)
>  			BUG_ON(skb_copy_bits(from, 0, skb_put(to, len), len));
> 


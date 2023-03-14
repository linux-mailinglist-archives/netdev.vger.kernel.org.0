Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8D76B91C7
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 12:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbjCNLhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 07:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjCNLhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 07:37:34 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E6609AFFC;
        Tue, 14 Mar 2023 04:37:26 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4PbWgz4PY9zrSgV;
        Tue, 14 Mar 2023 19:36:31 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Tue, 14 Mar
 2023 19:37:24 +0800
Subject: Re: [PATCH bpf-next v3 4/4] xdp: remove unused
 {__,}xdp_release_frame()
To:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>
CC:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Menglong Dong <imagedong@tencent.com>,
        Mykola Lysenko <mykolal@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230313215553.1045175-1-aleksander.lobakin@intel.com>
 <20230313215553.1045175-5-aleksander.lobakin@intel.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <42712a3f-544f-6e45-1468-9f9fae7922e8@huawei.com>
Date:   Tue, 14 Mar 2023 19:37:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20230313215553.1045175-5-aleksander.lobakin@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/3/14 5:55, Alexander Lobakin wrote:
> __xdp_build_skb_from_frame() was the last user of
> {__,}xdp_release_frame(), which detaches pages from the page_pool.
> All the consumers now recycle Page Pool skbs and page, except mlx5,
> stmmac and tsnep drivers, which use page_pool_release_page() directly
> (might change one day). It's safe to assume this functionality is not
> needed anymore and can be removed (in favor of recycling).
> 
> Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
> ---
>  include/net/xdp.h | 29 -----------------------------
>  net/core/xdp.c    | 15 ---------------
>  2 files changed, 44 deletions(-)
> 
> diff --git a/include/net/xdp.h b/include/net/xdp.h
> index d517bfac937b..5393b3ebe56e 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -317,35 +317,6 @@ void xdp_flush_frame_bulk(struct xdp_frame_bulk *bq);
>  void xdp_return_frame_bulk(struct xdp_frame *xdpf,
>  			   struct xdp_frame_bulk *bq);
>  
> -/* When sending xdp_frame into the network stack, then there is no
> - * return point callback, which is needed to release e.g. DMA-mapping
> - * resources with page_pool.  Thus, have explicit function to release
> - * frame resources.
> - */
> -void __xdp_release_frame(void *data, struct xdp_mem_info *mem);
> -static inline void xdp_release_frame(struct xdp_frame *xdpf)
> -{
> -	struct xdp_mem_info *mem = &xdpf->mem;
> -	struct skb_shared_info *sinfo;
> -	int i;
> -
> -	/* Curr only page_pool needs this */
> -	if (mem->type != MEM_TYPE_PAGE_POOL)
> -		return;
> -
> -	if (likely(!xdp_frame_has_frags(xdpf)))
> -		goto out;
> -
> -	sinfo = xdp_get_shared_info_from_frame(xdpf);
> -	for (i = 0; i < sinfo->nr_frags; i++) {
> -		struct page *page = skb_frag_page(&sinfo->frags[i]);
> -
> -		__xdp_release_frame(page_address(page), mem);
> -	}
> -out:
> -	__xdp_release_frame(xdpf->data, mem);
> -}
> -
>  static __always_inline unsigned int xdp_get_frame_len(struct xdp_frame *xdpf)
>  {
>  	struct skb_shared_info *sinfo;
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index a2237cfca8e9..8d3ad315f18d 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -531,21 +531,6 @@ void xdp_return_buff(struct xdp_buff *xdp)
>  }
>  EXPORT_SYMBOL_GPL(xdp_return_buff);
>  
> -/* Only called for MEM_TYPE_PAGE_POOL see xdp.h */
> -void __xdp_release_frame(void *data, struct xdp_mem_info *mem)
> -{
> -	struct xdp_mem_allocator *xa;
> -	struct page *page;
> -
> -	rcu_read_lock();
> -	xa = rhashtable_lookup(mem_id_ht, &mem->id, mem_id_rht_params);
> -	page = virt_to_head_page(data);
> -	if (xa)
> -		page_pool_release_page(xa->page_pool, page);

page_pool_release_page() is only call here when xa is not NULL
and mem->type == MEM_TYPE_PAGE_POOL.

But skb_mark_for_recycle() is call when mem->type == MEM_TYPE_PAGE_POOL
without checking xa, it does not seems symmetric to patch 3, if this is
intended?

> -	rcu_read_unlock();
> -}
> -EXPORT_SYMBOL_GPL(__xdp_release_frame);
> -
>  void xdp_attachment_setup(struct xdp_attachment_info *info,
>  			  struct netdev_bpf *bpf)
>  {
> 

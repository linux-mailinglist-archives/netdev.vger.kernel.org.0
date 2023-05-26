Return-Path: <netdev+bounces-5560-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBD9F712231
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:29:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 71935281202
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 08:29:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95B9DC2DB;
	Fri, 26 May 2023 08:29:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8287B322B
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 08:29:18 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C6F6128;
	Fri, 26 May 2023 01:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1685089756; x=1716625756;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=iWO1MfdJCzGC3YITtNdOfCdqaJYl5A9FQ5lMWK5MTAU=;
  b=aCEGdizwQ3v4r4WBtX6TNMdQXpZgyIpudx/tfALuwQFpyoSR8TdNOurm
   4lFvJF2+5eicmBOg0ObYhyrvu1TA+ECiTMflrX6Uq5AuTHS++NqyaW7QQ
   J8aPVUYZj7+6rW0CXlwQY15V+3dbeQ1Xk49QGiFU/IPGn0JcNCQ5ccsxd
   NZ+Cqn2oRT3VQ9WpBMa6EazQs6pFxpV5Rs0YZrMHORpCQIlE6me5UaBxS
   l/zYYQxLApGxy2EQtDxExi9m2jembCaIcGy1beRIr6vw4U5k0+S/b3sqQ
   vlPQ3RMjSDqCc1um9dyxhkFhBVvDjkl00d62irl0rw6vSUkAG9ZLJ9iwV
   A==;
X-IronPort-AV: E=Sophos;i="6.00,193,1681196400"; 
   d="scan'208";a="215005322"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 May 2023 01:29:15 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 26 May 2023 01:29:15 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Fri, 26 May 2023 01:29:14 -0700
Date: Fri, 26 May 2023 10:29:14 +0200
From: Horatiu Vultur <horatiu.vultur@microchip.com>
To: Liang Chen <liangchen.linux@gmail.com>
CC: <jasowang@redhat.com>, <mst@redhat.com>,
	<virtualization@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <xuanzhuo@linux.alibaba.com>,
	<kuba@kernel.org>, <edumazet@google.com>, <davem@davemloft.net>,
	<pabeni@redhat.com>, <alexander.duyck@gmail.com>
Subject: Re: [PATCH net-next 3/5] virtio_net: Add page pool fragmentation
 support
Message-ID: <20230526082914.owofnszwdjgcjwhi@soft-dev3-1>
References: <20230526054621.18371-1-liangchen.linux@gmail.com>
 <20230526054621.18371-3-liangchen.linux@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20230526054621.18371-3-liangchen.linux@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The 05/26/2023 13:46, Liang Chen wrote:

Hi Liang,

> 
> To further enhance performance, implement page pool fragmentation
> support and introduce a module parameter to enable or disable it.
> 
> In single-core vm testing environments, there is an additional performance
> gain observed in the normal path compared to the one packet per page
> approach.
>   Upstream codebase: 47.5 Gbits/sec
>   Upstream codebase with page pool: 50.2 Gbits/sec
>   Upstream codebase with page pool fragmentation support: 52.3 Gbits/sec
> 
> There is also some performance gain for XDP cpumap.
>   Upstream codebase: 1.38 Gbits/sec
>   Upstream codebase with page pool: 9.74 Gbits/sec
>   Upstream codebase with page pool fragmentation: 10.3 Gbits/sec
> 
> Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
> ---
>  drivers/net/virtio_net.c | 72 ++++++++++++++++++++++++++++++----------
>  1 file changed, 55 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 99c0ca0c1781..ac40b8c66c59 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -32,7 +32,9 @@ module_param(gso, bool, 0444);
>  module_param(napi_tx, bool, 0644);
> 
>  static bool page_pool_enabled;
> +static bool page_pool_frag;
>  module_param(page_pool_enabled, bool, 0400);
> +module_param(page_pool_frag, bool, 0400);
> 
>  /* FIXME: MTU in config. */
>  #define GOOD_PACKET_LEN (ETH_HLEN + VLAN_HLEN + ETH_DATA_LEN)
> @@ -909,23 +911,32 @@ static struct page *xdp_linearize_page(struct receive_queue *rq,
>                                        struct page *p,
>                                        int offset,
>                                        int page_off,
> -                                      unsigned int *len)
> +                                      unsigned int *len,
> +                                          unsigned int *pp_frag_offset)

The 'unsigned int *pp_frag_offset' seems to be unaligned.

>  {
>         int tailroom = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
>         struct page *page;
> +       unsigned int pp_frag_offset_val;

Please use reverse christmas tree notation here. The pp_frag_offset_val
needs to be declared before page;

> 
>         if (page_off + *len + tailroom > PAGE_SIZE)
>                 return NULL;
> 
>         if (rq->page_pool)
> -               page = page_pool_dev_alloc_pages(rq->page_pool);
> +               if (rq->page_pool->p.flags & PP_FLAG_PAGE_FRAG)
> +                       page = page_pool_dev_alloc_frag(rq->page_pool, pp_frag_offset,
> +                                                       PAGE_SIZE);

Don't you need to check if pp_frag_offset is null? As you call once with
NULL.

> +               else
> +                       page = page_pool_dev_alloc_pages(rq->page_pool);
>         else
>                 page = alloc_page(GFP_ATOMIC);
> 
>         if (!page)
>                 return NULL;
> 
> -       memcpy(page_address(page) + page_off, page_address(p) + offset, *len);
> +       pp_frag_offset_val = pp_frag_offset ? *pp_frag_offset : 0;
> +
> +       memcpy(page_address(page) + page_off + pp_frag_offset_val,
> +              page_address(p) + offset, *len);
>         page_off += *len;
> 
>         while (--*num_buf) {
> @@ -948,7 +959,7 @@ static struct page *xdp_linearize_page(struct receive_queue *rq,
>                         goto err_buf;
>                 }
> 
> -               memcpy(page_address(page) + page_off,
> +               memcpy(page_address(page) + page_off + pp_frag_offset_val,
>                        page_address(p) + off, buflen);
>                 page_off += buflen;
>                 virtnet_put_page(rq, p);
> @@ -1029,7 +1040,7 @@ static struct sk_buff *receive_small_xdp(struct net_device *dev,
>                         SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
>                 xdp_page = xdp_linearize_page(rq, &num_buf, page,
>                                               offset, header_offset,
> -                                             &tlen);
> +                                             &tlen, NULL);
>                 if (!xdp_page)
>                         goto err_xdp;
> 
> @@ -1323,6 +1334,7 @@ static void *mergeable_xdp_get_buf(struct virtnet_info *vi,
>         unsigned int headroom = mergeable_ctx_to_headroom(ctx);
>         struct page *xdp_page;
>         unsigned int xdp_room;
> +       unsigned int page_frag_offset = 0;

Please use reverse x-mas tree notation.

> 
>         /* Transient failure which in theory could occur if
>          * in-flight packets from before XDP was enabled reach
> @@ -1356,7 +1368,8 @@ static void *mergeable_xdp_get_buf(struct virtnet_info *vi,
>                 xdp_page = xdp_linearize_page(rq, num_buf,
>                                               *page, offset,
>                                               VIRTIO_XDP_HEADROOM,
> -                                             len);
> +                                             len,
> +                                                 &page_frag_offset);

You have also here some misalignment with regards to page_frag_offset.

>                 if (!xdp_page)
>                         return NULL;
>         } else {
> @@ -1366,14 +1379,19 @@ static void *mergeable_xdp_get_buf(struct virtnet_info *vi,
>                         return NULL;
> 
>                 if (rq->page_pool)
> -                       xdp_page = page_pool_dev_alloc_pages(rq->page_pool);
> +                       if (rq->page_pool->p.flags & PP_FLAG_PAGE_FRAG)
> +                               xdp_page = page_pool_dev_alloc_frag(rq->page_pool,
> +                                                                   &page_frag_offset, PAGE_SIZE);
> +                       else
> +                               xdp_page = page_pool_dev_alloc_pages(rq->page_pool);
>                 else
>                         xdp_page = alloc_page(GFP_ATOMIC);
> +
>                 if (!xdp_page)
>                         return NULL;
> 
> -               memcpy(page_address(xdp_page) + VIRTIO_XDP_HEADROOM,
> -                      page_address(*page) + offset, *len);
> +               memcpy(page_address(xdp_page) + VIRTIO_XDP_HEADROOM +
> +                               page_frag_offset, page_address(*page) + offset, *len);
>         }
> 
>         *frame_sz = PAGE_SIZE;
> @@ -1382,7 +1400,7 @@ static void *mergeable_xdp_get_buf(struct virtnet_info *vi,
> 
>         *page = xdp_page;
> 
> -       return page_address(*page) + VIRTIO_XDP_HEADROOM;
> +       return page_address(*page) + VIRTIO_XDP_HEADROOM + page_frag_offset;
>  }
> 
>  static struct sk_buff *receive_mergeable_xdp(struct net_device *dev,
> @@ -1762,6 +1780,7 @@ static int add_recvbuf_mergeable(struct virtnet_info *vi,
>         void *ctx;
>         int err;
>         unsigned int len, hole;
> +       unsigned int pp_frag_offset;

There same here.

> 
>         /* Extra tailroom is needed to satisfy XDP's assumption. This
>          * means rx frags coalescing won't work, but consider we've
> @@ -1769,13 +1788,29 @@ static int add_recvbuf_mergeable(struct virtnet_info *vi,
>          */
>         len = get_mergeable_buf_len(rq, &rq->mrg_avg_pkt_len, room);
>         if (rq->page_pool) {
> -               struct page *page;
> +               if (rq->page_pool->p.flags & PP_FLAG_PAGE_FRAG) {
> +                       if (unlikely(!page_pool_dev_alloc_frag(rq->page_pool,
> +                                                              &pp_frag_offset, len + room)))
> +                               return -ENOMEM;
> +                       buf = (char *)page_address(rq->page_pool->frag_page) +
> +                               pp_frag_offset;
> +                       buf += headroom; /* advance address leaving hole at front of pkt */
> +                       hole = (PAGE_SIZE << rq->page_pool->p.order)
> +                               - rq->page_pool->frag_offset;
> +                       if (hole < len + room) {
> +                               if (!headroom)
> +                                       len += hole;
> +                               rq->page_pool->frag_offset += hole;
> +                       }
> +               } else {
> +                       struct page *page;
> 
> -               page = page_pool_dev_alloc_pages(rq->page_pool);
> -               if (unlikely(!page))
> -                       return -ENOMEM;
> -               buf = (char *)page_address(page);
> -               buf += headroom; /* advance address leaving hole at front of pkt */
> +                       page = page_pool_dev_alloc_pages(rq->page_pool);
> +                       if (unlikely(!page))
> +                               return -ENOMEM;
> +                       buf = (char *)page_address(page);
> +                       buf += headroom; /* advance address leaving hole at front of pkt */
> +               }
>         } else {
>                 if (unlikely(!skb_page_frag_refill(len + room, alloc_frag, gfp)))
>                         return -ENOMEM;
> @@ -3800,13 +3835,16 @@ static void virtnet_alloc_page_pool(struct receive_queue *rq)
>         struct virtio_device *vdev = rq->vq->vdev;
> 
>         struct page_pool_params pp_params = {
> -               .order = 0,
> +               .order = page_pool_frag ? SKB_FRAG_PAGE_ORDER : 0,
>                 .pool_size = rq->vq->num_max,
>                 .nid = dev_to_node(vdev->dev.parent),
>                 .dev = vdev->dev.parent,
>                 .offset = 0,
>         };
> 
> +       if (page_pool_frag)
> +               pp_params.flags |= PP_FLAG_PAGE_FRAG;
> +
>         rq->page_pool = page_pool_create(&pp_params);
>         if (IS_ERR(rq->page_pool)) {
>                 dev_warn(&vdev->dev, "page pool creation failed: %ld\n",
> --
> 2.31.1
> 
> 

-- 
/Horatiu


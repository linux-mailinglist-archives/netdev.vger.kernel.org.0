Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A22E46C44CC
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 09:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbjCVIW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 04:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbjCVIWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 04:22:23 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CDFE5941D;
        Wed, 22 Mar 2023 01:22:21 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4PhLz20wz8zrW78;
        Wed, 22 Mar 2023 16:21:18 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Wed, 22 Mar
 2023 16:22:19 +0800
Subject: Re: [PATCH net-next 1/8] virtio_net: mergeable xdp: put old page
 immediately
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, <netdev@vger.kernel.org>
CC:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <virtualization@lists.linux-foundation.org>, <bpf@vger.kernel.org>
References: <20230322030308.16046-1-xuanzhuo@linux.alibaba.com>
 <20230322030308.16046-2-xuanzhuo@linux.alibaba.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <4bd07874-b1ad-336b-b15e-ba56a10182e9@huawei.com>
Date:   Wed, 22 Mar 2023 16:22:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20230322030308.16046-2-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.3 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/3/22 11:03, Xuan Zhuo wrote:
> In the xdp implementation of virtio-net mergeable, it always checks
> whether two page is used and a page is selected to release. This is
> complicated for the processing of action, and be careful.
> 
> In the entire process, we have such principles:
> * If xdp_page is used (PASS, TX, Redirect), then we release the old
>   page.
> * If it is a drop case, we will release two. The old page obtained from
>   buf is release inside err_xdp, and xdp_page needs be relased by us.
> 
> But in fact, when we allocate a new page, we can release the old page
> immediately. Then just one is using, we just need to release the new
> page for drop case. On the drop path, err_xdp will release the variable
> "page", so we only need to let "page" point to the new xdp_page in
> advance.
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  drivers/net/virtio_net.c | 15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index e2560b6f7980..4d2bf1ce0730 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1245,6 +1245,9 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>  			if (!xdp_page)
>  				goto err_xdp;
>  			offset = VIRTIO_XDP_HEADROOM;
> +
> +			put_page(page);

the error handling of xdp_linearize_page() does not seems self contained.
Does it not seem better：
1. if xdp_linearize_page() succesed, call put_page() for first buffer just
   as put_page() is call for other buffer
2. or call virtqueue_get_buf() and put_page() for all the buffer of the packet
   so the error handling is not needed outside the virtqueue_get_buf().

In that case, it seems we can just do below without xdp_page:
page = xdp_linearize_page(rq, num_buf, page, ...);


> +			page = xdp_page;
>  		} else if (unlikely(headroom < virtnet_get_headroom(vi))) {
>  			xdp_room = SKB_DATA_ALIGN(VIRTIO_XDP_HEADROOM +
>  						  sizeof(struct skb_shared_info));
> @@ -1259,6 +1262,9 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>  			       page_address(page) + offset, len);
>  			frame_sz = PAGE_SIZE;
>  			offset = VIRTIO_XDP_HEADROOM;
> +
> +			put_page(page);
> +			page = xdp_page;

It seems we can limit the scope of xdp_page in this "else if" block.

>  		} else {
>  			xdp_page = page;
>  		}

It seems the above else block is not needed anymore.

> @@ -1278,8 +1284,6 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>  			if (unlikely(!head_skb))
>  				goto err_xdp_frags;
>  
> -			if (unlikely(xdp_page != page))
> -				put_page(page);
>  			rcu_read_unlock();
>  			return head_skb;
>  		case XDP_TX:
> @@ -1297,8 +1301,6 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>  				goto err_xdp_frags;
>  			}
>  			*xdp_xmit |= VIRTIO_XDP_TX;
> -			if (unlikely(xdp_page != page))
> -				put_page(page);
>  			rcu_read_unlock();
>  			goto xdp_xmit;
>  		case XDP_REDIRECT:
> @@ -1307,8 +1309,6 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>  			if (err)
>  				goto err_xdp_frags;
>  			*xdp_xmit |= VIRTIO_XDP_REDIR;
> -			if (unlikely(xdp_page != page))
> -				put_page(page);
>  			rcu_read_unlock();
>  			goto xdp_xmit;
>  		default:
> @@ -1321,9 +1321,6 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>  			goto err_xdp_frags;
>  		}
>  err_xdp_frags:
> -		if (unlikely(xdp_page != page))
> -			__free_pages(xdp_page, 0);

It seems __free_pages() and put_page() is used interchangeably here.
Perhaps using __free_pages() have performance reason? As the comment below:

https://elixir.bootlin.com/linux/v6.3-rc3/source/net/core/page_pool.c#L500

> -
>  		if (xdp_buff_has_frags(&xdp)) {
>  			shinfo = xdp_get_shared_info_from_buff(&xdp);
>  			for (i = 0; i < shinfo->nr_frags; i++) {
> 

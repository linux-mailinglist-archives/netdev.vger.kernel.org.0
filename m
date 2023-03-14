Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9946B917F
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 12:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbjCNLUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 07:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231179AbjCNLUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 07:20:23 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0034C2D67;
        Tue, 14 Mar 2023 04:19:54 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PbWDQ12K7zSlRF;
        Tue, 14 Mar 2023 19:16:06 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Tue, 14 Mar
 2023 19:19:19 +0800
Subject: Re: [PATCH net v1 2/2] virtio_net: free xdp shinfo frags when
 build_skb_from_xdp_buff() fails
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
        Heng Qi <hengqi@linux.alibaba.com>,
        <virtualization@lists.linux-foundation.org>, <bpf@vger.kernel.org>
References: <20230314104939.67212-1-xuanzhuo@linux.alibaba.com>
 <20230314104939.67212-3-xuanzhuo@linux.alibaba.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <faf3772c-b494-54bd-b29a-6cc3068985d5@huawei.com>
Date:   Tue, 14 Mar 2023 19:19:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20230314104939.67212-3-xuanzhuo@linux.alibaba.com>
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

On 2023/3/14 18:49, Xuan Zhuo wrote:
> build_skb_from_xdp_buff() may return NULL, in this case
> we need to free the frags of xdp shinfo.
> 
> Fixes: fab89bafa95b ("virtio-net: support multi-buffer xdp")
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/net/virtio_net.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 8ecf7a341d54..d36183be0481 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1273,9 +1273,12 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>  
>  		switch (act) {
>  		case XDP_PASS:
> +			head_skb = build_skb_from_xdp_buff(dev, vi, &xdp, xdp_frags_truesz);
> +			if (!head_skb)

It is a error case, perhaps add a unlikely() for it.

> +				goto err_xdp_frags;
> +
>  			if (unlikely(xdp_page != page))
>  				put_page(page);
> -			head_skb = build_skb_from_xdp_buff(dev, vi, &xdp, xdp_frags_truesz);
>  			rcu_read_unlock();
>  			return head_skb;
>  		case XDP_TX:
> 

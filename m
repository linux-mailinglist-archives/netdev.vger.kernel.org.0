Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E93AE4102D2
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 03:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238674AbhIRB6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 21:58:11 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:54497 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233022AbhIRB6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 21:58:10 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R551e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UojdgoO_1631930205;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UojdgoO_1631930205)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 18 Sep 2021 09:56:46 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <1631930173.5851955-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net] virtio-net: fix pages leaking when building skb in
 big mode
Date:   Sat, 18 Sep 2021 09:56:13 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20210917083406.75602-1-jasowang@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Sep 2021 16:34:06 +0800, Jason Wang <jasowang@redhat.com> wrote:
> We try to use build_skb() if we had sufficient tailroom. But we forget
> to release the unused pages chained via private in big mode which will
> leak pages. Fixing this by release the pages after building the skb in
> big mode.
>
> Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Fixes: fb32856b16ad ("virtio-net: page_to_skb() use build_skb when there's sufficient tailroom")
> Signed-off-by: Jason Wang <jasowang@redhat.com>

LGTM

Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

Thanks.


> ---
>  drivers/net/virtio_net.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 271d38c1d9f8..79bd2585ec6b 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -423,6 +423,10 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>
>  		skb_reserve(skb, p - buf);
>  		skb_put(skb, len);
> +
> +		page = (struct page *)page->private;
> +		if (page)
> +			give_pages(rq, page);
>  		goto ok;
>  	}
>
> --
> 2.25.1
>

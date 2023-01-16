Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3500566B5A1
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 03:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231721AbjAPC3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 21:29:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231716AbjAPC3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 21:29:07 -0500
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6EB9272C
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 18:29:06 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VZbZNlw_1673836141;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VZbZNlw_1673836141)
          by smtp.aliyun-inc.com;
          Mon, 16 Jan 2023 10:29:02 +0800
Message-ID: <1673836131.7281802-2-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net-next 2/2] virtio_net: Reuse buffer free function
Date:   Mon, 16 Jan 2023 10:28:51 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     <edumazet@google.com>, <pabeni@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        Parav Pandit <parav@nvidia.com>, <mst@redhat.com>,
        <jasowang@redhat.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>
References: <20230113223619.162405-1-parav@nvidia.com>
 <20230113223619.162405-3-parav@nvidia.com>
In-Reply-To: <20230113223619.162405-3-parav@nvidia.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 14 Jan 2023 00:36:19 +0200, Parav Pandit <parav@nvidia.com> wrote:
> virtnet_rq_free_unused_buf() helper function to free the buffer
> already exists. Avoid code duplication by reusing existing function.
>
> Signed-off-by: Parav Pandit <parav@nvidia.com>


Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>


> ---
>  drivers/net/virtio_net.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index d45e140b6852..c1faaf11fbcd 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1251,13 +1251,7 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
>  	if (unlikely(len < vi->hdr_len + ETH_ZLEN)) {
>  		pr_debug("%s: short packet %i\n", dev->name, len);
>  		dev->stats.rx_length_errors++;
> -		if (vi->mergeable_rx_bufs) {
> -			put_page(virt_to_head_page(buf));
> -		} else if (vi->big_packets) {
> -			give_pages(rq, buf);
> -		} else {
> -			put_page(virt_to_head_page(buf));
> -		}
> +		virtnet_rq_free_unused_buf(rq->vq, buf);
>  		return;
>  	}
>
> --
> 2.26.2
>

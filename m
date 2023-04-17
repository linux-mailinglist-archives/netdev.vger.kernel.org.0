Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F22326E3D41
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 03:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbjDQBx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 21:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjDQBx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 21:53:58 -0400
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 586051987;
        Sun, 16 Apr 2023 18:53:56 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R721e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VgBVEby_1681696431;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VgBVEby_1681696431)
          by smtp.aliyun-inc.com;
          Mon, 17 Apr 2023 09:53:52 +0800
Message-ID: <1681696410.7972026-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net] virtio-net: reject small vring sizes
Date:   Mon, 17 Apr 2023 09:53:30 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alvaro Karsz <alvaro.karsz@solid-run.com>, mst@redhat.com,
        jasowang@redhat.com
References: <20230416074607.292616-1-alvaro.karsz@solid-run.com>
In-Reply-To: <20230416074607.292616-1-alvaro.karsz@solid-run.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 16 Apr 2023 10:46:07 +0300, Alvaro Karsz <alvaro.karsz@solid-run.com> wrote:
> Check vring size and fail probe if a transmit/receive vring size is
> smaller than MAX_SKB_FRAGS + 2.
>
> At the moment, any vring size is accepted. This is problematic because
> it may result in attempting to transmit a packet with more fragments
> than there are descriptors in the ring.

So, why we check the rx ring?

Thanks.


>
> Furthermore, it leads to an immediate bug:
>
> The condition: (sq->vq->num_free >= 2 + MAX_SKB_FRAGS) in
> virtnet_poll_cleantx and virtnet_poll_tx always evaluates to false,
> so netif_tx_wake_queue is not called, leading to TX timeouts.
>
> Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
> ---
>  drivers/net/virtio_net.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 2396c28c012..59676252c5c 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3745,6 +3745,26 @@ static int init_vqs(struct virtnet_info *vi)
>  	return ret;
>  }
>
> +static int virtnet_validate_vqs(struct virtnet_info *vi)
> +{
> +	u32 i, min_size = roundup_pow_of_two(MAX_SKB_FRAGS + 2);
> +
> +	/* Transmit/Receive vring size must be at least MAX_SKB_FRAGS + 2
> +	 * (fragments + linear part + virtio header)
> +	 */
> +	for (i = 0; i < vi->max_queue_pairs; i++) {
> +		if (virtqueue_get_vring_size(vi->sq[i].vq) < min_size ||
> +		    virtqueue_get_vring_size(vi->rq[i].vq) < min_size) {
> +			dev_warn(&vi->vdev->dev,
> +				 "Transmit/Receive virtqueue vring size must be at least %u\n",
> +				 min_size);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  #ifdef CONFIG_SYSFS
>  static ssize_t mergeable_rx_buffer_size_show(struct netdev_rx_queue *queue,
>  		char *buf)
> @@ -4056,6 +4076,10 @@ static int virtnet_probe(struct virtio_device *vdev)
>  	if (err)
>  		goto free;
>
> +	err = virtnet_validate_vqs(vi);
> +	if (err)
> +		goto free_vqs;
> +
>  #ifdef CONFIG_SYSFS
>  	if (vi->mergeable_rx_bufs)
>  		dev->sysfs_rx_queue_group = &virtio_net_mrg_rx_group;
> --
> 2.34.1
>

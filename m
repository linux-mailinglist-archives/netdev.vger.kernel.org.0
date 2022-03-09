Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 351524D2B94
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 10:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbiCIJP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 04:15:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231685AbiCIJP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 04:15:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B3A4C157233
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 01:14:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646817296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sc9oWQ1T35bRoFzTSlgzenvWUozmVf90/ZtKZIwMHUs=;
        b=EKDNhhxOZjbWhJTtS+5mu33ZxOh0SeHPZqD+cVEut5kfNE0s5AjOfpjguJ2GDhEjKWN+RS
        /HJM6vDYpIsezzr6gZwxNd01AtqjvtJFvR9nr1JZr0ebyix6xSqAViqHf4xQaYVbi2rGfG
        enLTGSFPvPAA4fmkIJ2gprJVLPynKmQ=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-380-3g9qussLMH60DMAfC4I8GA-1; Wed, 09 Mar 2022 04:14:55 -0500
X-MC-Unique: 3g9qussLMH60DMAfC4I8GA-1
Received: by mail-pj1-f69.google.com with SMTP id j10-20020a17090a7e8a00b001bbef243093so3442529pjl.1
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 01:14:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sc9oWQ1T35bRoFzTSlgzenvWUozmVf90/ZtKZIwMHUs=;
        b=dbyaJ6BITM8u6kDKL4KkpLRp0NBc4zoUFrE9IKSStJFu/c754Lh5upJk4twrUgrGzI
         9hz7GvfMdVsNZCp8OwB2P5xgJd+beyvlauRtZF3Tjrh+8Nc2aVZIZOvhPDDpcJw3oZCZ
         QUDvI2wzIcdpGyvGlhzXs3pzTFbGqRXLzPhcYwcOzl3PZjd3FvJiN+82+6VZIdeSAq+t
         RSICsk3eHAqzOuriQo6B6hZNXfB+3fdCy3Kj1xGKbplp1d2q6QXrCzchW1r7VEzutECS
         U+FTYxOzpM4V8d/Porab4ORr+X/0Vg50sxycsPkL2IRtQES2hqR1qJNT5i5AvW4V4UxC
         qdNg==
X-Gm-Message-State: AOAM530apmQwA0iSzk3Q9NdMNJcjnChcHTiPL+ZwFsfo1fZjLzRlyUNP
        2wMybinBHh1GV2Q1ek2i5DrNGxOKd09q8Lcp7GXWX08f2SERmrSWCZsBB3w6r9AD2+GKN004LMA
        5nPS97krD33bKgiki
X-Received: by 2002:a17:90b:1b43:b0:1bf:6180:367a with SMTP id nv3-20020a17090b1b4300b001bf6180367amr9413279pjb.172.1646817294425;
        Wed, 09 Mar 2022 01:14:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJybmsMuEBcxZ7oYSDw9tPVnvRoFjWIEzgnMTihTr3NYtzJOE9wVfTp/SLtdAOZZcYSLhnlPZw==
X-Received: by 2002:a17:90b:1b43:b0:1bf:6180:367a with SMTP id nv3-20020a17090b1b4300b001bf6180367amr9413201pjb.172.1646817294071;
        Wed, 09 Mar 2022 01:14:54 -0800 (PST)
Received: from [10.72.12.183] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h17-20020a63df51000000b0036b9776ae5bsm1721846pgj.85.2022.03.09.01.14.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 01:14:53 -0800 (PST)
Message-ID: <7ff78ff8-bdd0-bb5e-1cea-cf1126226feb@redhat.com>
Date:   Wed, 9 Mar 2022 17:14:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH v7 24/26] virtio_net: support rx/tx queue reset
Content-Language: en-US
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org
References: <20220308123518.33800-1-xuanzhuo@linux.alibaba.com>
 <20220308123518.33800-25-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220308123518.33800-25-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/3/8 下午8:35, Xuan Zhuo 写道:
> This patch implements the reset function of the rx, tx queues.
>
> Based on this function, it is possible to modify the ring num of the
> queue. And quickly recycle the buffer in the queue.
>
> In the process of the queue disable, in theory, as long as virtio
> supports queue reset, there will be no exceptions.
>
> However, in the process of the queue enable, there may be exceptions due to
> memory allocation.  In this case, vq is not available, but we still have
> to execute napi_enable(). Because napi_disable is similar to a lock,
> napi_enable must be called after calling napi_disable.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>   drivers/net/virtio_net.c | 107 +++++++++++++++++++++++++++++++++++++++
>   1 file changed, 107 insertions(+)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 409a8e180918..ffff323dcef0 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -251,6 +251,11 @@ struct padded_vnet_hdr {
>   	char padding[4];
>   };
>   
> +static void virtnet_sq_free_unused_bufs(struct virtnet_info *vi,
> +					struct send_queue *sq);
> +static void virtnet_rq_free_unused_bufs(struct virtnet_info *vi,
> +					struct receive_queue *rq);
> +
>   static bool is_xdp_frame(void *ptr)
>   {
>   	return (unsigned long)ptr & VIRTIO_XDP_FLAG;
> @@ -1369,6 +1374,9 @@ static void virtnet_napi_enable(struct virtqueue *vq, struct napi_struct *napi)
>   {
>   	napi_enable(napi);
>   
> +	if (vq->reset)
> +		return;
> +


Let's WARN_ONCE() here?


>   	/* If all buffers were filled by other side before we napi_enabled, we
>   	 * won't get another interrupt, so process any outstanding packets now.
>   	 * Call local_bh_enable after to trigger softIRQ processing.
> @@ -1413,6 +1421,10 @@ static void refill_work(struct work_struct *work)
>   		struct receive_queue *rq = &vi->rq[i];
>   
>   		napi_disable(&rq->napi);
> +		if (rq->vq->reset) {
> +			virtnet_napi_enable(rq->vq, &rq->napi);
> +			continue;
> +		}


This seems racy and it's a hint that we need sync with the refill work 
during reset like what we did in virtnet_close():

         /* Make sure refill_work doesn't re-enable napi! */
         cancel_delayed_work_sync(&vi->refill);


>   		still_empty = !try_fill_recv(vi, rq, GFP_KERNEL);
>   		virtnet_napi_enable(rq->vq, &rq->napi);
>   
> @@ -1523,6 +1535,9 @@ static void virtnet_poll_cleantx(struct receive_queue *rq)
>   	if (!sq->napi.weight || is_xdp_raw_buffer_queue(vi, index))
>   		return;
>   
> +	if (sq->vq->reset)
> +		return;


It looks to me we'd better either WARN or just remove this. Since it 
looks like a workaround for the un-synchronized NAPI somehow.


> +
>   	if (__netif_tx_trylock(txq)) {
>   		do {
>   			virtqueue_disable_cb(sq->vq);
> @@ -1769,6 +1784,98 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
>   	return NETDEV_TX_OK;
>   }
>   
> +static int virtnet_rx_vq_reset(struct virtnet_info *vi,
> +			       struct receive_queue *rq, u32 ring_num)


It's better to rename this as virtnet_rx_resize().


> +{
> +	int err;
> +
> +	/* stop napi */
> +	napi_disable(&rq->napi);
> +


Here, as discussed above, we need synchronize with the refill work.


> +	/* reset the queue */
> +	err = virtio_reset_vq(rq->vq);
> +	if (err)
> +		goto err;


Btw, most comment of this function seems useless since code already 
explain themselves.


> +
> +	/* free bufs */
> +	virtnet_rq_free_unused_bufs(vi, rq);
> +
> +	/* reset vring. */
> +	err = virtqueue_reset_vring(rq->vq, ring_num);
> +	if (err)
> +		goto err;
> +
> +	/* enable reset queue */
> +	err = virtio_enable_resetq(rq->vq);
> +	if (err)
> +		goto err;
> +
> +	/* fill recv */
> +	if (!try_fill_recv(vi, rq, GFP_KERNEL))
> +		schedule_delayed_work(&vi->refill, 0);
> +
> +	/* enable napi */
> +	virtnet_napi_enable(rq->vq, &rq->napi);
> +	return 0;
> +
> +err:
> +	netdev_err(vi->dev,
> +		   "reset rx reset vq fail: rx queue index: %ld err: %d\n",
> +		   rq - vi->rq, err);
> +	virtnet_napi_enable(rq->vq, &rq->napi);
> +	return err;
> +}
> +
> +static int virtnet_tx_vq_reset(struct virtnet_info *vi,
> +			       struct send_queue *sq, u32 ring_num)
> +{


It looks to me it's better to rename this as "virtnet_rx_resize()"


> +	struct netdev_queue *txq;
> +	int err, qindex;
> +
> +	qindex = sq - vi->sq;
> +
> +	txq = netdev_get_tx_queue(vi->dev, qindex);
> +	__netif_tx_lock_bh(txq);
> +
> +	/* stop tx queue and napi */
> +	netif_stop_subqueue(vi->dev, qindex);
> +	virtnet_napi_tx_disable(&sq->napi);


There's no need to hold tx lock for napi disable.

Thanks


> +
> +	__netif_tx_unlock_bh(txq);
> +
> +	/* reset the queue */
> +	err = virtio_reset_vq(sq->vq);
> +	if (err) {
> +		netif_start_subqueue(vi->dev, qindex);
> +		goto err;
> +	}
> +
> +	/* free bufs */
> +	virtnet_sq_free_unused_bufs(vi, sq);
> +
> +	/* reset vring. */
> +	err = virtqueue_reset_vring(sq->vq, ring_num);
> +	if (err)
> +		goto err;
> +
> +	/* enable reset queue */
> +	err = virtio_enable_resetq(sq->vq);
> +	if (err)
> +		goto err;
> +
> +	/* start tx queue and napi */
> +	netif_start_subqueue(vi->dev, qindex);
> +	virtnet_napi_tx_enable(vi, sq->vq, &sq->napi);
> +	return 0;
> +
> +err:
> +	netdev_err(vi->dev,
> +		   "reset tx reset vq fail: tx queue index: %ld err: %d\n",
> +		   sq - vi->sq, err);
> +	virtnet_napi_tx_enable(vi, sq->vq, &sq->napi);
> +	return err;
> +}
> +
>   /*
>    * Send command via the control virtqueue and check status.  Commands
>    * supported by the hypervisor, as indicated by feature bits, should


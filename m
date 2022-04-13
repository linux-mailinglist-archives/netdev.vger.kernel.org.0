Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 536D54FF131
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 10:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbiDMIDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 04:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233710AbiDMIC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 04:02:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 44DE41FA53
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 01:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649836838;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BK0xGHuGKSg6tS7OvJ2UZVDC8hGmPnNquXolsiCRFqU=;
        b=SpBobL0+Ak45xvC7fLbPX+9PE9fTu6q0sZ5e2bAvAIWpZYHxyPxh8z7FkWz6iZu11qzDkj
        Qhld3W1sAu8Y+3AnhzAwBJann9OJ+QrQCzimZ/UAVvIcr8paOEaoTs7wabpckBel5QaUIy
        hN0Ew5w1di1NFT/H/f1EU/wFyW2fkHw=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-c_3fvY8iNsqgjqiESu3IAA-1; Wed, 13 Apr 2022 04:00:37 -0400
X-MC-Unique: c_3fvY8iNsqgjqiESu3IAA-1
Received: by mail-pj1-f72.google.com with SMTP id r12-20020a17090a690c00b001cb9bce2284so749140pjj.8
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 01:00:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BK0xGHuGKSg6tS7OvJ2UZVDC8hGmPnNquXolsiCRFqU=;
        b=I6k2tuRpz0dKjLy9mTvan08uzO7GaLUnwASw07HRSrdHPp+fECWkDYxcUpl4AJkMP9
         FMl9ng8njAM5GPGrr8QzZ9egK0n4oKjKf9YAPgzWMeHOrtCk7VJS4UBYjmUiId3w9Mgl
         YxtAmB7LPykaMIDIbG+766ppuWHY/ZkyJKr89e53/s7PXoD2iYR9UmHgCD/sknQFKA7D
         TB+6e52vE38OuI5RuLq/LuKNS/xLTexnwuLRX7HFhIlD7Ro4rvk26XAeN3rDpo8DuOus
         B988VAjJngHUbsLpUFkhiOJLkKE20zj/GHdOSjQfP3sdDClgj+ACZBYt8q34gu1hzY0l
         rpGw==
X-Gm-Message-State: AOAM53121+YD7vdWSbW82RWMswmKhTjH7Oh8FUWV9pDdLHoiFoe9CGat
        cU1b8TJw/f2SxuGjBq6bDnzZxJq+7K+bIN4WGW62CqiPgoRcAaAzc/dJQ/4dLwiCp/NybGe1wJy
        6ZfM9jAneDD/9A5d1
X-Received: by 2002:a63:885:0:b0:39d:2197:2dcf with SMTP id 127-20020a630885000000b0039d21972dcfmr16534610pgi.300.1649836831093;
        Wed, 13 Apr 2022 01:00:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxxYX/5hHC47/+wODyw6SuCX6q43fRwhhJkty2IwP5vjbtPmYxOh8zOxYYGS8lSmQrVc9+uNA==
X-Received: by 2002:a63:885:0:b0:39d:2197:2dcf with SMTP id 127-20020a630885000000b0039d21972dcfmr16534566pgi.300.1649836830786;
        Wed, 13 Apr 2022 01:00:30 -0700 (PDT)
Received: from [10.72.13.223] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q6-20020a056a00150600b004fb2d266f97sm43184355pfu.115.2022.04.13.01.00.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Apr 2022 01:00:30 -0700 (PDT)
Message-ID: <122008a6-1e79-14d3-1478-59f96464afc9@redhat.com>
Date:   Wed, 13 Apr 2022 16:00:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v9 31/32] virtio_net: support rx/tx queue resize
Content-Language: en-US
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org
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
        linux-um@lists.infradead.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org
References: <20220406034346.74409-1-xuanzhuo@linux.alibaba.com>
 <20220406034346.74409-32-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220406034346.74409-32-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/4/6 上午11:43, Xuan Zhuo 写道:
> This patch implements the resize function of the rx, tx queues.
> Based on this function, it is possible to modify the ring num of the
> queue.
>
> There may be an exception during the resize process, the resize may
> fail, or the vq can no longer be used. Either way, we must execute
> napi_enable(). Because napi_disable is similar to a lock, napi_enable
> must be called after calling napi_disable.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>   drivers/net/virtio_net.c | 81 ++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 81 insertions(+)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index b8bf00525177..ba6859f305f7 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -251,6 +251,9 @@ struct padded_vnet_hdr {
>   	char padding[4];
>   };
>   
> +static void virtnet_sq_free_unused_buf(struct virtqueue *vq, void *buf);
> +static void virtnet_rq_free_unused_buf(struct virtqueue *vq, void *buf);
> +
>   static bool is_xdp_frame(void *ptr)
>   {
>   	return (unsigned long)ptr & VIRTIO_XDP_FLAG;
> @@ -1369,6 +1372,15 @@ static void virtnet_napi_enable(struct virtqueue *vq, struct napi_struct *napi)
>   {
>   	napi_enable(napi);
>   
> +	/* Check if vq is in reset state. The normal reset/resize process will
> +	 * be protected by napi. However, the protection of napi is only enabled
> +	 * during the operation, and the protection of napi will end after the
> +	 * operation is completed. If re-enable fails during the process, vq
> +	 * will remain unavailable with reset state.
> +	 */
> +	if (vq->reset)
> +		return;


I don't get when could we hit this condition.


> +
>   	/* If all buffers were filled by other side before we napi_enabled, we
>   	 * won't get another interrupt, so process any outstanding packets now.
>   	 * Call local_bh_enable after to trigger softIRQ processing.
> @@ -1413,6 +1425,15 @@ static void refill_work(struct work_struct *work)
>   		struct receive_queue *rq = &vi->rq[i];
>   
>   		napi_disable(&rq->napi);
> +
> +		/* Check if vq is in reset state. See more in
> +		 * virtnet_napi_enable()
> +		 */
> +		if (rq->vq->reset) {
> +			virtnet_napi_enable(rq->vq, &rq->napi);
> +			continue;
> +		}


Can we do something similar in virtnet_close() by canceling the work?


> +
>   		still_empty = !try_fill_recv(vi, rq, GFP_KERNEL);
>   		virtnet_napi_enable(rq->vq, &rq->napi);
>   
> @@ -1523,6 +1544,10 @@ static void virtnet_poll_cleantx(struct receive_queue *rq)
>   	if (!sq->napi.weight || is_xdp_raw_buffer_queue(vi, index))
>   		return;
>   
> +	/* Check if vq is in reset state. See more in virtnet_napi_enable() */
> +	if (sq->vq->reset)
> +		return;


We've disabled TX napi, any chance we can still hit this?


> +
>   	if (__netif_tx_trylock(txq)) {
>   		do {
>   			virtqueue_disable_cb(sq->vq);
> @@ -1769,6 +1794,62 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
>   	return NETDEV_TX_OK;
>   }
>   
> +static int virtnet_rx_resize(struct virtnet_info *vi,
> +			     struct receive_queue *rq, u32 ring_num)
> +{
> +	int err;
> +
> +	napi_disable(&rq->napi);
> +
> +	err = virtqueue_resize(rq->vq, ring_num, virtnet_rq_free_unused_buf);
> +	if (err)
> +		goto err;
> +
> +	if (!try_fill_recv(vi, rq, GFP_KERNEL))
> +		schedule_delayed_work(&vi->refill, 0);
> +
> +	virtnet_napi_enable(rq->vq, &rq->napi);
> +	return 0;
> +
> +err:
> +	netdev_err(vi->dev,
> +		   "reset rx reset vq fail: rx queue index: %td err: %d\n",
> +		   rq - vi->rq, err);
> +	virtnet_napi_enable(rq->vq, &rq->napi);
> +	return err;
> +}
> +
> +static int virtnet_tx_resize(struct virtnet_info *vi,
> +			     struct send_queue *sq, u32 ring_num)
> +{
> +	struct netdev_queue *txq;
> +	int err, qindex;
> +
> +	qindex = sq - vi->sq;
> +
> +	virtnet_napi_tx_disable(&sq->napi);
> +
> +	txq = netdev_get_tx_queue(vi->dev, qindex);
> +	__netif_tx_lock_bh(txq);
> +	netif_stop_subqueue(vi->dev, qindex);
> +	__netif_tx_unlock_bh(txq);
> +
> +	err = virtqueue_resize(sq->vq, ring_num, virtnet_sq_free_unused_buf);
> +	if (err)
> +		goto err;
> +
> +	netif_start_subqueue(vi->dev, qindex);
> +	virtnet_napi_tx_enable(vi, sq->vq, &sq->napi);
> +	return 0;
> +
> +err:


I guess we can still start the queue in this case? (Since we don't 
change the queue if resize fails).


> +	netdev_err(vi->dev,
> +		   "reset tx reset vq fail: tx queue index: %td err: %d\n",
> +		   sq - vi->sq, err);
> +	virtnet_napi_tx_enable(vi, sq->vq, &sq->napi);
> +	return err;
> +}
> +
>   /*
>    * Send command via the control virtqueue and check status.  Commands
>    * supported by the hypervisor, as indicated by feature bits, should


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A58A357C794
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 11:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbiGUJag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 05:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiGUJae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 05:30:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9202B7D798
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 02:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658395832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cE2msxk6QPw86zAV3haYmpL0Ot9f5ZCy5ykRLxOKnec=;
        b=GlQjpbr7E+McOWJVbcQk3HbL++9lYEsdLLPe232nBwS20VCQ8UVr88APvkNZShIZ2bdUE3
        gwnC908AMcEdw/MeRywV3jTADaCBKeqhXJ9mcvuMUNuUdt9yKjl5IBljgOubmAlnwIL4cO
        8mNKyrrEmOeFGML90r5dJy1vHkuBN6E=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-484-wZjtAVCyObKhjbo4APpMuw-1; Thu, 21 Jul 2022 05:30:31 -0400
X-MC-Unique: wZjtAVCyObKhjbo4APpMuw-1
Received: by mail-pg1-f197.google.com with SMTP id d66-20020a636845000000b0040a88edd9c1so674317pgc.13
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 02:30:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cE2msxk6QPw86zAV3haYmpL0Ot9f5ZCy5ykRLxOKnec=;
        b=3udMvfhEJ/8Whxek6VlXmCwQYSzTvNeIaFjng7IBWdTzxNTORfVZnv1g4m/gFvK5vP
         2JPAntme+xtxnZ157Guyh2XwQsSYVKwFrDr+bYo9XbkxyBH5fUZGq+qfJSxiPYsgGdG/
         Ww3okXbkfHfinjWOWfkQJ2uHdZubFa1vOAop8ndoPj1rsH7bhnfWukrXzpLS2uEtcrOx
         Ez3QUey4AlI4eNe67PgD1/379Eh2MehAJGdQRqrG5fs9BiNGtJ1FPizu4zy6ntrsbbTA
         AKiewmqeLytvRMVr5Qggb0BTevf2LmZk8gq1QedlWkuY3j7ji98YW9zIgcsIB5B5Yica
         YrWQ==
X-Gm-Message-State: AJIora9eZxSeyZS59PrEi8GZ/VSUHpj1eWBUIkVl4JzBUA8Q9Q69JLQw
        AFM2yvUCa2ZzOxE+T9kO+T60ZjQZc9p0Uq5g75q4b7UQAzXb6x5PolZFhx4f1SmruGLi4wWkfrF
        8gAis72btsQEKVdw2
X-Received: by 2002:a05:6a00:1308:b0:528:2ed8:7e3d with SMTP id j8-20020a056a00130800b005282ed87e3dmr44101337pfu.82.1658395830225;
        Thu, 21 Jul 2022 02:30:30 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sZJ2tQPOK504th0WDmmE1eCdXGAgBe+DPqkW4Ch1xqd/jvYFMXQX10YnFglctjFz+BMq1srg==
X-Received: by 2002:a05:6a00:1308:b0:528:2ed8:7e3d with SMTP id j8-20020a056a00130800b005282ed87e3dmr44101301pfu.82.1658395829765;
        Thu, 21 Jul 2022 02:30:29 -0700 (PDT)
Received: from [10.72.12.47] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b14-20020a17090a6ace00b001f061359023sm988456pjm.21.2022.07.21.02.30.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jul 2022 02:30:29 -0700 (PDT)
Message-ID: <cbc59d60-f3b3-465d-185b-5b83f893be63@redhat.com>
Date:   Thu, 21 Jul 2022 17:30:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v12 39/40] virtio_net: support tx queue resize
Content-Language: en-US
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org
Cc:     Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org,
        kangjie.xu@linux.alibaba.com
References: <20220720030436.79520-1-xuanzhuo@linux.alibaba.com>
 <20220720030436.79520-40-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220720030436.79520-40-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/7/20 11:04, Xuan Zhuo 写道:
> This patch implements the resize function of the tx queues.
> Based on this function, it is possible to modify the ring num of the
> queue.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/net/virtio_net.c | 47 ++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 47 insertions(+)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 1115a8b59a08..d1e6940b46d8 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -135,6 +135,9 @@ struct send_queue {
>   	struct virtnet_sq_stats stats;
>   
>   	struct napi_struct napi;
> +
> +	/* Record whether sq is in reset state. */
> +	bool reset;
>   };
>   
>   /* Internal representation of a receive virtqueue */
> @@ -279,6 +282,7 @@ struct padded_vnet_hdr {
>   };
>   
>   static void virtnet_rq_free_unused_buf(struct virtqueue *vq, void *buf);
> +static void virtnet_sq_free_unused_buf(struct virtqueue *vq, void *buf);
>   
>   static bool is_xdp_frame(void *ptr)
>   {
> @@ -1603,6 +1607,11 @@ static void virtnet_poll_cleantx(struct receive_queue *rq)
>   		return;
>   
>   	if (__netif_tx_trylock(txq)) {
> +		if (sq->reset) {
> +			__netif_tx_unlock(txq);
> +			return;
> +		}
> +
>   		do {
>   			virtqueue_disable_cb(sq->vq);
>   			free_old_xmit_skbs(sq, true);
> @@ -1868,6 +1877,44 @@ static int virtnet_rx_resize(struct virtnet_info *vi,
>   	return err;
>   }
>   
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
> +
> +	/* 1. wait all ximt complete
> +	 * 2. fix the race of netif_stop_subqueue() vs netif_start_subqueue()
> +	 */
> +	__netif_tx_lock_bh(txq);
> +
> +	/* Prevent rx poll from accessing sq. */
> +	sq->reset = true;
> +
> +	/* Prevent the upper layer from trying to send packets. */
> +	netif_stop_subqueue(vi->dev, qindex);
> +
> +	__netif_tx_unlock_bh(txq);
> +
> +	err = virtqueue_resize(sq->vq, ring_num, virtnet_sq_free_unused_buf);
> +	if (err)
> +		netdev_err(vi->dev, "resize tx fail: tx queue index: %d err: %d\n", qindex, err);
> +
> +	__netif_tx_lock_bh(txq);
> +	sq->reset = false;
> +	netif_tx_wake_queue(txq);
> +	__netif_tx_unlock_bh(txq);
> +
> +	virtnet_napi_tx_enable(vi, sq->vq, &sq->napi);
> +	return err;
> +}
> +
>   /*
>    * Send command via the control virtqueue and check status.  Commands
>    * supported by the hypervisor, as indicated by feature bits, should


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71A174D2BE4
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 10:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbiCIJ3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 04:29:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231716AbiCIJ3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 04:29:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EF238EACAD
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 01:28:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646818124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hWn8/vrpqWZiMgWnWn1Y0AikbZvs5gY1FZ1FP2CFNp8=;
        b=h+BzGU0unQ/SCXfK+AgnuQRMBIXWI8an8Upld52VcV6o22PjHzN3GPIvxjHKFGNcDfBGJe
        PbnhNIDJDkJ0CcoDzT9wmgdButUgGFkHwc8kD7r+yK1v/9vmMCxKSI+yT2GdjTa4I+Y1mB
        uQWEVhFcRhNv0KAvSmD/Yv588lJn0Hc=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-597-A_7q5QcCM_aEccHtPTsgBg-1; Wed, 09 Mar 2022 04:28:42 -0500
X-MC-Unique: A_7q5QcCM_aEccHtPTsgBg-1
Received: by mail-pg1-f199.google.com with SMTP id q7-20020a63e207000000b003801b9bb18dso986910pgh.15
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 01:28:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hWn8/vrpqWZiMgWnWn1Y0AikbZvs5gY1FZ1FP2CFNp8=;
        b=bMArg30Q7FABecsKOsdZwKbYC66TmqOmgJefz1O7oVEA2s0HCEi04DFvxsv+UdTu9H
         uAgX8AUPirM6tKoAjYn50RXmz32nzBDCimCPDFrs5gdwp7UYdLODxbAuZo1OEg9Zkz8O
         EtFlni4IF8M7xawNJiTjB/Hw/6lUCG0dxKezzM4O3AM7GsnaiopgdB283p5OAp46qhp9
         esQB4t9/mOo4DVROwnI2V8qlnNMvjB6W8O0qOhw+oitAJWBPg+Piu2Lw4BJYjwArb+78
         St+jn0rMSpyYYW9l+H4yBQoS8SLusB3yh/G7+0aoVZMSPjPWixkRDfPrFNE/rCVWS12G
         rs1Q==
X-Gm-Message-State: AOAM533Ww8NfnJQEWIL0nx5IK0MHP0tvboSv+4eR9Vs99Ear68qshMDZ
        3cDli4qrP93Bfih+N5rx8gl0qDdgYcCNTGq+hbuLiMOFHo56y+F0MYAnYzD7jOVTTfC80k4eH6I
        creQ8h1iM9cIO5leT
X-Received: by 2002:a17:902:8f83:b0:151:5c71:a6e6 with SMTP id z3-20020a1709028f8300b001515c71a6e6mr22071873plo.126.1646818121767;
        Wed, 09 Mar 2022 01:28:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwKLZVIwZDJNnQ8YaxGrbHS5lO7yIdkUUhfXnPrMYsGuclXTOzQNdeuiPknSERt+cv2yMNnwA==
X-Received: by 2002:a17:902:8f83:b0:151:5c71:a6e6 with SMTP id z3-20020a1709028f8300b001515c71a6e6mr22071834plo.126.1646818121459;
        Wed, 09 Mar 2022 01:28:41 -0800 (PST)
Received: from [10.72.12.183] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id f21-20020a056a00239500b004f754dd3d4csm2116960pfc.3.2022.03.09.01.28.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 01:28:40 -0800 (PST)
Message-ID: <d7ec6eed-d692-091b-a438-1ae1cc5ee614@redhat.com>
Date:   Wed, 9 Mar 2022 17:28:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH v7 25/26] virtio_net: set the default max ring size by
 find_vqs()
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
 <20220308123518.33800-26-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220308123518.33800-26-xuanzhuo@linux.alibaba.com>
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
> Use virtio_find_vqs_ctx_size() to specify the maximum ring size of tx,
> rx at the same time.
>
>                           | rx/tx ring size
> -------------------------------------------
> speed == UNKNOWN or < 10G| 1024
> speed < 40G              | 4096
> speed >= 40G             | 8192
>
> Call virtnet_update_settings() once before calling init_vqs() to update
> speed.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>   drivers/net/virtio_net.c | 42 ++++++++++++++++++++++++++++++++++++----
>   1 file changed, 38 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index ffff323dcef0..f1bdc6ce21c3 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -2977,6 +2977,29 @@ static unsigned int mergeable_min_buf_len(struct virtnet_info *vi, struct virtqu
>   		   (unsigned int)GOOD_PACKET_LEN);
>   }
>   
> +static void virtnet_config_sizes(struct virtnet_info *vi, u32 *sizes)
> +{
> +	u32 i, rx_size, tx_size;
> +
> +	if (vi->speed == SPEED_UNKNOWN || vi->speed < SPEED_10000) {
> +		rx_size = 1024;
> +		tx_size = 1024;
> +
> +	} else if (vi->speed < SPEED_40000) {
> +		rx_size = 1024 * 4;
> +		tx_size = 1024 * 4;
> +
> +	} else {
> +		rx_size = 1024 * 8;
> +		tx_size = 1024 * 8;
> +	}
> +
> +	for (i = 0; i < vi->max_queue_pairs; i++) {
> +		sizes[rxq2vq(i)] = rx_size;
> +		sizes[txq2vq(i)] = tx_size;
> +	}
> +}
> +
>   static int virtnet_find_vqs(struct virtnet_info *vi)
>   {
>   	vq_callback_t **callbacks;
> @@ -2984,6 +3007,7 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
>   	int ret = -ENOMEM;
>   	int i, total_vqs;
>   	const char **names;
> +	u32 *sizes;
>   	bool *ctx;
>   
>   	/* We expect 1 RX virtqueue followed by 1 TX virtqueue, followed by
> @@ -3011,10 +3035,15 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
>   		ctx = NULL;
>   	}
>   
> +	sizes = kmalloc_array(total_vqs, sizeof(*sizes), GFP_KERNEL);
> +	if (!sizes)
> +		goto err_sizes;
> +
>   	/* Parameters for control virtqueue, if any */
>   	if (vi->has_cvq) {
>   		callbacks[total_vqs - 1] = NULL;
>   		names[total_vqs - 1] = "control";
> +		sizes[total_vqs - 1] = 0;


Nit: Do we need a sane value for the control vq? (e.g 64)

Thanks


>   	}
>   
>   	/* Allocate/initialize parameters for send/receive virtqueues */
> @@ -3029,8 +3058,10 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
>   			ctx[rxq2vq(i)] = true;
>   	}
>   
> -	ret = virtio_find_vqs_ctx(vi->vdev, total_vqs, vqs, callbacks,
> -				  names, ctx, NULL);
> +	virtnet_config_sizes(vi, sizes);
> +
> +	ret = virtio_find_vqs_ctx_size(vi->vdev, total_vqs, vqs, callbacks,
> +				       names, ctx, NULL, sizes);
>   	if (ret)
>   		goto err_find;
>   
> @@ -3050,6 +3081,8 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
>   
>   
>   err_find:
> +	kfree(sizes);
> +err_sizes:
>   	kfree(ctx);
>   err_ctx:
>   	kfree(names);
> @@ -3368,6 +3401,9 @@ static int virtnet_probe(struct virtio_device *vdev)
>   		vi->curr_queue_pairs = num_online_cpus();
>   	vi->max_queue_pairs = max_queue_pairs;
>   
> +	virtnet_init_settings(dev);
> +	virtnet_update_settings(vi);
> +
>   	/* Allocate/initialize the rx/tx queues, and invoke find_vqs */
>   	err = init_vqs(vi);
>   	if (err)
> @@ -3380,8 +3416,6 @@ static int virtnet_probe(struct virtio_device *vdev)
>   	netif_set_real_num_tx_queues(dev, vi->curr_queue_pairs);
>   	netif_set_real_num_rx_queues(dev, vi->curr_queue_pairs);
>   
> -	virtnet_init_settings(dev);
> -
>   	if (virtio_has_feature(vdev, VIRTIO_NET_F_STANDBY)) {
>   		vi->failover = net_failover_create(vi->dev);
>   		if (IS_ERR(vi->failover)) {


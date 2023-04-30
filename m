Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A21BB6F290D
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 15:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbjD3N2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 09:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjD3N2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 09:28:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B51C19A2
        for <netdev@vger.kernel.org>; Sun, 30 Apr 2023 06:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682861250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ByfksgfAfk/uxpL9BVE+5FLntDZWZHVF8lQ+xy8gE0M=;
        b=bUoi0trEc84HXHvuu2ch53DEQBmLJpQpVJa/geOut2lpZ8zqmz7Iu7AyazxLT0w9eNttfI
        0s/DMXfuquYTRUDk07RR+GTl/sxZ+2suO0ZHsHCN0AqIRX4EtReIdYrqO5NzD2v+SZKr+t
        lkishIS6NnFFXljoPNVzTupWU3VuXlE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-2QMGikyoPY2l4evcQNFpLQ-1; Sun, 30 Apr 2023 09:27:28 -0400
X-MC-Unique: 2QMGikyoPY2l4evcQNFpLQ-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f1793d6363so4283385e9.1
        for <netdev@vger.kernel.org>; Sun, 30 Apr 2023 06:27:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682861247; x=1685453247;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ByfksgfAfk/uxpL9BVE+5FLntDZWZHVF8lQ+xy8gE0M=;
        b=R+SsbbemgpfXVPdcPGH1ClxCpHGZ/+ORQzCmUWe4Br7/ANOh201fuNRaI/y1poPoqP
         mcvtXuS9Qou+sDJGooheqd4s1Tg+cq+DfesdtXzFY6775ZOAHgtiCYFER22v7f1vDdf4
         mzbBfS+EsPttpl3Y0CuZxT1kAww8gWpeCh3Mw9d2NwPPb+h92eAn0qfW5rHqZy3Va5rK
         CrrO1MYhxPsNCK7Tm4qiZD8qElFqO42BV7vT6MZtOwM3n1b3TOmhA9cvjm6WHoyUuRwj
         dhYze0nVWWwiXOWyP6/C6W+j8SR8nTJTbDkb6JwxhOnx+Cq4HrE46lFP6GGLpu7MOSN/
         8uRA==
X-Gm-Message-State: AC+VfDwAP9CAJmSTQETCJh+dO7gUQ9o0ONG3xopT31P0hKwMNlyN/2Fh
        BS0NEiY137vrlL/xE6/92qGMo9tvqYC/BYYel7oyQRWy2cQQPeCKVO1MYGygEVA0em5tnuji3p6
        3Z3WDkDBYnagJLgzZ
X-Received: by 2002:a7b:c015:0:b0:3f1:662a:93d0 with SMTP id c21-20020a7bc015000000b003f1662a93d0mr8322122wmb.15.1682861247611;
        Sun, 30 Apr 2023 06:27:27 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7ETv6GryHgo+COy+D101D1I+zk9PjXqylCJcECyfbSbp4HpTMUDiTN0979D6XmXqcM12ZLdg==
X-Received: by 2002:a7b:c015:0:b0:3f1:662a:93d0 with SMTP id c21-20020a7bc015000000b003f1662a93d0mr8322115wmb.15.1682861247234;
        Sun, 30 Apr 2023 06:27:27 -0700 (PDT)
Received: from redhat.com ([2.52.139.131])
        by smtp.gmail.com with ESMTPSA id x8-20020a05600c21c800b003f2390bdd0csm21102744wmj.32.2023.04.30.06.27.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Apr 2023 06:27:26 -0700 (PDT)
Date:   Sun, 30 Apr 2023 09:27:22 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     jasowang@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xuanzhuo@linux.alibaba.com
Subject: Re: [RFC PATCH net 1/3] virtio: re-negotiate features if probe fails
 and features are blocked
Message-ID: <20230430092142-mutt-send-email-mst@kernel.org>
References: <20230430131518.2708471-1-alvaro.karsz@solid-run.com>
 <20230430131518.2708471-2-alvaro.karsz@solid-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230430131518.2708471-2-alvaro.karsz@solid-run.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 30, 2023 at 04:15:16PM +0300, Alvaro Karsz wrote:
> This patch exports a new virtio core function: virtio_block_feature.
> The function should be called during a virtio driver probe.
> 
> If a virtio driver blocks features during probe and fails probe, virtio
> core will reset the device, try to re-negotiate the new features and
> probe again.
> 
> Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
> ---
>  drivers/virtio/virtio.c | 73 ++++++++++++++++++++++++++++++-----------
>  include/linux/virtio.h  |  3 ++
>  2 files changed, 56 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> index 3893dc29eb2..eaad5b6a7a9 100644
> --- a/drivers/virtio/virtio.c
> +++ b/drivers/virtio/virtio.c
> @@ -167,6 +167,13 @@ void virtio_add_status(struct virtio_device *dev, unsigned int status)
>  }
>  EXPORT_SYMBOL_GPL(virtio_add_status);
>  
> +void virtio_block_feature(struct virtio_device *dev, unsigned int f)
> +{
> +	BUG_ON(f >= 64);
> +	dev->blocked_features |= (1ULL << f);
> +}
> +EXPORT_SYMBOL_GPL(virtio_block_feature);
> +

Let's add documentation please. Also pls call it __virtio_block_feature
since it has to be used in a special way - specifically only during
probe.

>  /* Do some validation, then set FEATURES_OK */
>  static int virtio_features_ok(struct virtio_device *dev)
>  {
> @@ -234,17 +241,13 @@ void virtio_reset_device(struct virtio_device *dev)
>  }
>  EXPORT_SYMBOL_GPL(virtio_reset_device);
>  
> -static int virtio_dev_probe(struct device *_d)
> +static int virtio_negotiate_features(struct virtio_device *dev)
>  {
> -	int err, i;
> -	struct virtio_device *dev = dev_to_virtio(_d);
>  	struct virtio_driver *drv = drv_to_virtio(dev->dev.driver);
>  	u64 device_features;
>  	u64 driver_features;
>  	u64 driver_features_legacy;
> -
> -	/* We have a driver! */
> -	virtio_add_status(dev, VIRTIO_CONFIG_S_DRIVER);
> +	int i, ret;
>  
>  	/* Figure out what features the device supports. */
>  	device_features = dev->config->get_features(dev);
> @@ -279,30 +282,61 @@ static int virtio_dev_probe(struct device *_d)
>  		if (device_features & (1ULL << i))
>  			__virtio_set_bit(dev, i);
>  
> -	err = dev->config->finalize_features(dev);
> -	if (err)
> -		goto err;
> +	/* Remove blocked features */
> +	dev->features &= ~dev->blocked_features;
> +
> +	ret = dev->config->finalize_features(dev);
> +	if (ret)
> +		goto exit;
>  
>  	if (drv->validate) {
>  		u64 features = dev->features;
>  
> -		err = drv->validate(dev);
> -		if (err)
> -			goto err;
> +		ret = drv->validate(dev);
> +		if (ret)
> +			goto exit;
>  
>  		/* Did validation change any features? Then write them again. */
>  		if (features != dev->features) {
> -			err = dev->config->finalize_features(dev);
> -			if (err)
> -				goto err;
> +			ret = dev->config->finalize_features(dev);
> +			if (ret)
> +				goto exit;
>  		}
>  	}
>  
> -	err = virtio_features_ok(dev);
> -	if (err)
> -		goto err;
> +	ret = virtio_features_ok(dev);
> +exit:
> +	return ret;
> +}
> +
> +static int virtio_dev_probe(struct device *_d)
> +{
> +	int err;
> +	struct virtio_device *dev = dev_to_virtio(_d);
> +	struct virtio_driver *drv = drv_to_virtio(dev->dev.driver);
> +	u64 blocked_features;
> +	bool renegotiate = true;
> +
> +	/* We have a driver! */
> +	virtio_add_status(dev, VIRTIO_CONFIG_S_DRIVER);
> +
> +	/* Store blocked features and attempt to negotiate features & probe.
> +	 * If the probe fails, we check if the driver has blocked any new features.
> +	 * If it has, we reset the device and try again with the new features.
> +	 */
> +	while (renegotiate) {
> +		blocked_features = dev->blocked_features;
> +		err = virtio_negotiate_features(dev);
> +		if (err)
> +			break;
> +
> +		err = drv->probe(dev);


there's no way to driver to clear blocked features, but
just in case, I'd add BUG_ON to check.

> +		if (err && blocked_features != dev->blocked_features)
> +			virtio_reset_device(dev);
> +		else
> +			renegotiate = false;
> +	}
>  
> -	err = drv->probe(dev);
>  	if (err)
>  		goto err;
>  
> @@ -319,7 +353,6 @@ static int virtio_dev_probe(struct device *_d)
>  err:
>  	virtio_add_status(dev, VIRTIO_CONFIG_S_FAILED);
>  	return err;
> -
>  }
>  
>  static void virtio_dev_remove(struct device *_d)
> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index b93238db94e..2de9b2d3ca4 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -109,6 +109,7 @@ int virtqueue_resize(struct virtqueue *vq, u32 num,
>   * @vringh_config: configuration ops for host vrings.
>   * @vqs: the list of virtqueues for this device.
>   * @features: the features supported by both driver and device.
> + * @blocked_features: the features blocked by the driver that can't be negotiated.
>   * @priv: private pointer for the driver's use.
>   */
>  struct virtio_device {
> @@ -124,6 +125,7 @@ struct virtio_device {
>  	const struct vringh_config_ops *vringh_config;
>  	struct list_head vqs;
>  	u64 features;
> +	u64 blocked_features;

add comment here too, explain purpose and rules of use

>  	void *priv;
>  };
>  
> @@ -133,6 +135,7 @@ void virtio_add_status(struct virtio_device *dev, unsigned int status);
>  int register_virtio_device(struct virtio_device *dev);
>  void unregister_virtio_device(struct virtio_device *dev);
>  bool is_virtio_device(struct device *dev);
> +void virtio_block_feature(struct virtio_device *dev, unsigned int f);
>  
>  void virtio_break_device(struct virtio_device *dev);
>  void __virtio_unbreak_device(struct virtio_device *dev);
> -- 
> 2.34.1


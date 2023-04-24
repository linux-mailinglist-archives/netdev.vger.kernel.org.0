Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D74886ED693
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 23:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232475AbjDXVKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 17:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232256AbjDXVKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 17:10:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4E249E4
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 14:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682370570;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l2DIw9E0DWGPudpd861Kjkn+cGauwIMc/nQBn5q2geI=;
        b=ZfnipAACu4Y+gzAn8d8ChCn6ivRv5P8CFPPDnUw4QPFOp46ex7utZuTQrGGnbnMzI4nV5G
        AQ4xFXzF+OvzLmUczXsGgOQeCOfuvPb3W27YLcLa3W+6jpmMME5Ts2wFU6CGObB1n/H9jT
        04exScTtKAmNrBYOnkBfWq0Jv4AUzVE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-637-OnvmHn5UMuChgcb8_3zLwg-1; Mon, 24 Apr 2023 17:09:29 -0400
X-MC-Unique: OnvmHn5UMuChgcb8_3zLwg-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-2fe3fb8e36bso2668044f8f.0
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 14:09:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682370568; x=1684962568;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l2DIw9E0DWGPudpd861Kjkn+cGauwIMc/nQBn5q2geI=;
        b=D06FVAd7RIyK3daCagefG08MwVAo0v2ZOC2XC/uiosM+4N6uCF3HVKmsYTMfBnK4mG
         j6p12wy657q3lxcEfkOH52W/Ym9N+dgOb8nkX0JFxu2Fieq2kO266pqkmicVmViiHEAS
         vc4bonSDnmPqQIx3uWuZvwIPV+iGI7+MQmfnA2TjesbaIqOv1sBh1wl7yiTrVQOmToc8
         hDRnd6Es0D4HZb44hR93giZcZiArn8obD99Xj+8mk1YQkSBCQ8ZI2onGGzK4F3HnQnM6
         8AFdO4yizw0EgYwVYSAwvNo5kLGx/7zfs3jykBU5/ekze+VwFWeZ9YeFUiUpZZ2XBvjg
         8a9A==
X-Gm-Message-State: AAQBX9dd2hLU1JjG9YXxfZARPP80qM+LefqG+fiD1u5K+zRBcJZDdXx6
        d1BhYrf4OcrF0+IAqAL5iyJy0TtMxaGfMB/x0OoPHnMOutiYq99LYAKMLtMQSj9lwFnXCRY6lts
        gcaXSOIR/2KsPSyvg
X-Received: by 2002:a5d:404e:0:b0:2f8:2d4:74ef with SMTP id w14-20020a5d404e000000b002f802d474efmr10698167wrp.43.1682370568254;
        Mon, 24 Apr 2023 14:09:28 -0700 (PDT)
X-Google-Smtp-Source: AKy350YHMM9T0V0+QlHyo0phBynPWZ5d4SFmalLRfzRfQMsm6PgmZ6pd6ITCa8CU1e9IDifaQL432g==
X-Received: by 2002:a5d:404e:0:b0:2f8:2d4:74ef with SMTP id w14-20020a5d404e000000b002f802d474efmr10698158wrp.43.1682370567918;
        Mon, 24 Apr 2023 14:09:27 -0700 (PDT)
Received: from redhat.com ([2.55.17.255])
        by smtp.gmail.com with ESMTPSA id j14-20020adfea4e000000b002fc3d8c134bsm11560929wrn.74.2023.04.24.14.09.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 14:09:27 -0700 (PDT)
Date:   Mon, 24 Apr 2023 17:09:23 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Mikhail Golubev-Ciuchea <Mikhail.Golubev-Ciuchea@opensynergy.com>,
        virtio-dev@lists.oasis-open.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Harald Mommer <harald.mommer@opensynergy.com>
Subject: Re: [PATCH] can: virtio-can: cleanups
Message-ID: <20230424170901-mutt-send-email-mst@kernel.org>
References: <20230424-modular-rebate-e54ac16374c8-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230424-modular-rebate-e54ac16374c8-mkl@pengutronix.de>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 09:47:58PM +0200, Marc Kleine-Budde wrote:
> Address the topics raised in
> 
> https://lore.kernel.org/20230424-footwear-daily-9339bd0ec428-mkl@pengutronix.de
> 
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

given base patch is rfc this should be too?

> ---
>  drivers/net/can/Makefile        |  4 +--
>  drivers/net/can/virtio_can.c    | 56 ++++++++++++++-------------------
>  include/uapi/linux/virtio_can.h |  4 +--
>  3 files changed, 28 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/net/can/Makefile b/drivers/net/can/Makefile
> index e409f61d8e93..19314adaff59 100644
> --- a/drivers/net/can/Makefile
> +++ b/drivers/net/can/Makefile
> @@ -17,8 +17,8 @@ obj-$(CONFIG_CAN_AT91)		+= at91_can.o
>  obj-$(CONFIG_CAN_BXCAN)		+= bxcan.o
>  obj-$(CONFIG_CAN_CAN327)	+= can327.o
>  obj-$(CONFIG_CAN_CC770)		+= cc770/
> -obj-$(CONFIG_CAN_C_CAN)		+= c_can/
>  obj-$(CONFIG_CAN_CTUCANFD)	+= ctucanfd/
> +obj-$(CONFIG_CAN_C_CAN)		+= c_can/
>  obj-$(CONFIG_CAN_FLEXCAN)	+= flexcan/
>  obj-$(CONFIG_CAN_GRCAN)		+= grcan.o
>  obj-$(CONFIG_CAN_IFI_CANFD)	+= ifi_canfd/
> @@ -30,7 +30,7 @@ obj-$(CONFIG_CAN_PEAK_PCIEFD)	+= peak_canfd/
>  obj-$(CONFIG_CAN_SJA1000)	+= sja1000/
>  obj-$(CONFIG_CAN_SUN4I)		+= sun4i_can.o
>  obj-$(CONFIG_CAN_TI_HECC)	+= ti_hecc.o
> -obj-$(CONFIG_CAN_XILINXCAN)	+= xilinx_can.o
>  obj-$(CONFIG_CAN_VIRTIO_CAN)	+= virtio_can.o
> +obj-$(CONFIG_CAN_XILINXCAN)	+= xilinx_can.o
>  
>  subdir-ccflags-$(CONFIG_CAN_DEBUG_DEVICES) += -DDEBUG
> diff --git a/drivers/net/can/virtio_can.c b/drivers/net/can/virtio_can.c
> index 23f9c1b6446d..c11a652613d0 100644
> --- a/drivers/net/can/virtio_can.c
> +++ b/drivers/net/can/virtio_can.c
> @@ -312,13 +312,12 @@ static netdev_tx_t virtio_can_start_xmit(struct sk_buff *skb,
>  	struct scatterlist sg_in[1];
>  	struct scatterlist *sgs[2];
>  	unsigned long flags;
> -	size_t len;
>  	u32 can_flags;
>  	int err;
>  	netdev_tx_t xmit_ret = NETDEV_TX_OK;
>  	const unsigned int hdr_size = offsetof(struct virtio_can_tx_out, sdu);
>  
> -	if (can_dropped_invalid_skb(dev, skb))
> +	if (can_dev_dropped_skb(dev, skb))
>  		goto kick; /* No way to return NET_XMIT_DROP here */
>  
>  	/* Virtio CAN does not support error message frames */
> @@ -338,27 +337,25 @@ static netdev_tx_t virtio_can_start_xmit(struct sk_buff *skb,
>  
>  	can_tx_msg->tx_out.msg_type = cpu_to_le16(VIRTIO_CAN_TX);
>  	can_flags = 0;
> -	if (cf->can_id & CAN_EFF_FLAG)
> +
> +	if (cf->can_id & CAN_EFF_FLAG) {
>  		can_flags |= VIRTIO_CAN_FLAGS_EXTENDED;
> +		can_tx_msg->tx_out.can_id = cpu_to_le32(cf->can_id & CAN_EFF_MASK);
> +	} else {
> +		can_tx_msg->tx_out.can_id = cpu_to_le32(cf->can_id & CAN_SFF_MASK);
> +	}
>  	if (cf->can_id & CAN_RTR_FLAG)
>  		can_flags |= VIRTIO_CAN_FLAGS_RTR;
> +	else
> +		memcpy(can_tx_msg->tx_out.sdu, cf->data, cf->len);
>  	if (can_is_canfd_skb(skb))
>  		can_flags |= VIRTIO_CAN_FLAGS_FD;
> +
>  	can_tx_msg->tx_out.flags = cpu_to_le32(can_flags);
> -	can_tx_msg->tx_out.can_id = cpu_to_le32(cf->can_id & CAN_EFF_MASK);
> -	len = cf->len;
> -	can_tx_msg->tx_out.length = len;
> -	if (len > sizeof(cf->data))
> -		len = sizeof(cf->data);
> -	if (len > sizeof(can_tx_msg->tx_out.sdu))
> -		len = sizeof(can_tx_msg->tx_out.sdu);
> -	if (!(can_flags & VIRTIO_CAN_FLAGS_RTR)) {
> -		/* Copy if not a RTR frame. RTR frames have a DLC but no payload */
> -		memcpy(can_tx_msg->tx_out.sdu, cf->data, len);
> -	}
> +	can_tx_msg->tx_out.length = cpu_to_le16(cf->len);
>  
>  	/* Prepare sending of virtio message */
> -	sg_init_one(&sg_out[0], &can_tx_msg->tx_out, hdr_size + len);
> +	sg_init_one(&sg_out[0], &can_tx_msg->tx_out, hdr_size + cf->len);
>  	sg_init_one(&sg_in[0], &can_tx_msg->tx_in, sizeof(can_tx_msg->tx_in));
>  	sgs[0] = sg_out;
>  	sgs[1] = sg_in;
> @@ -895,8 +892,8 @@ static int virtio_can_probe(struct virtio_device *vdev)
>  	priv->tx_putidx_list =
>  		kcalloc(echo_skb_max, sizeof(struct list_head), GFP_KERNEL);
>  	if (!priv->tx_putidx_list) {
> -		free_candev(dev);
> -		return -ENOMEM;
> +		err = -ENOMEM;
> +		goto on_failure;
>  	}
>  
>  	INIT_LIST_HEAD(&priv->tx_putidx_free);
> @@ -914,7 +911,6 @@ static int virtio_can_probe(struct virtio_device *vdev)
>  	vdev->priv = priv;
>  
>  	priv->can.do_set_mode = virtio_can_set_mode;
> -	priv->can.state = CAN_STATE_STOPPED;
>  	/* Set Virtio CAN supported operations */
>  	priv->can.ctrlmode_supported = CAN_CTRLMODE_BERR_REPORTING;
>  	if (virtio_has_feature(vdev, VIRTIO_CAN_F_CAN_FD)) {
> @@ -968,11 +964,10 @@ static int virtio_can_probe(struct virtio_device *vdev)
>  	return err;
>  }
>  
> -#ifdef CONFIG_PM_SLEEP
>  /* Compare with m_can.c/m_can_suspend(), virtio_net.c/virtnet_freeze() and
>   * virtio_card.c/virtsnd_freeze()
>   */
> -static int virtio_can_freeze(struct virtio_device *vdev)
> +static int __maybe_unused virtio_can_freeze(struct virtio_device *vdev)
>  {
>  	struct virtio_can_priv *priv = vdev->priv;
>  	struct net_device *ndev = priv->dev;
> @@ -996,7 +991,7 @@ static int virtio_can_freeze(struct virtio_device *vdev)
>  /* Compare with m_can.c/m_can_resume(), virtio_net.c/virtnet_restore() and
>   * virtio_card.c/virtsnd_restore()
>   */
> -static int virtio_can_restore(struct virtio_device *vdev)
> +static int __maybe_unused virtio_can_restore(struct virtio_device *vdev)
>  {
>  	struct virtio_can_priv *priv = vdev->priv;
>  	struct net_device *ndev = priv->dev;
> @@ -1020,7 +1015,6 @@ static int virtio_can_restore(struct virtio_device *vdev)
>  
>  	return 0;
>  }
> -#endif /* #ifdef CONFIG_PM_SLEEP */
>  
>  static struct virtio_device_id virtio_can_id_table[] = {
>  	{ VIRTIO_ID_CAN, VIRTIO_DEV_ANY_ID },
> @@ -1037,18 +1031,16 @@ static unsigned int features[] = {
>  static struct virtio_driver virtio_can_driver = {
>  	.feature_table = features,
>  	.feature_table_size = ARRAY_SIZE(features),
> -	.feature_table_legacy = NULL,
> -	.feature_table_size_legacy = 0,
> -	.driver.name =	KBUILD_MODNAME,
> -	.driver.owner =	THIS_MODULE,
> -	.id_table =	virtio_can_id_table,
> -	.validate =	virtio_can_validate,
> -	.probe =	virtio_can_probe,
> -	.remove =	virtio_can_remove,
> +	.driver.name = KBUILD_MODNAME,
> +	.driver.owner = THIS_MODULE,
> +	.id_table = virtio_can_id_table,
> +	.validate = virtio_can_validate,
> +	.probe = virtio_can_probe,
> +	.remove = virtio_can_remove,
>  	.config_changed = virtio_can_config_changed,
>  #ifdef CONFIG_PM_SLEEP
> -	.freeze =	virtio_can_freeze,
> -	.restore =	virtio_can_restore,
> +	.freeze = virtio_can_freeze,
> +	.restore = virtio_can_restore,
>  #endif
>  };
>  
> diff --git a/include/uapi/linux/virtio_can.h b/include/uapi/linux/virtio_can.h
> index de85918aa7dc..f59a2ca6ebd1 100644
> --- a/include/uapi/linux/virtio_can.h
> +++ b/include/uapi/linux/virtio_can.h
> @@ -35,7 +35,7 @@ struct virtio_can_config {
>  struct virtio_can_tx_out {
>  #define VIRTIO_CAN_TX                   0x0001
>  	__le16 msg_type;
> -	__le16 length; /* 0..8 CC, 0..64 CAN­FD, 0..2048 CAN­XL, 12 bits */
> +	__le16 length; /* 0..8 CC, 0..64 CAN-FD, 0..2048 CAN-XL, 12 bits */
>  	__le32 reserved; /* May be needed in part for CAN XL priority */
>  	__le32 flags;
>  	__le32 can_id;
> @@ -50,7 +50,7 @@ struct virtio_can_tx_in {
>  struct virtio_can_rx {
>  #define VIRTIO_CAN_RX                   0x0101
>  	__le16 msg_type;
> -	__le16 length; /* 0..8 CC, 0..64 CAN­FD, 0..2048 CAN­XL, 12 bits */
> +	__le16 length; /* 0..8 CC, 0..64 CAN-FD, 0..2048 CAN-XL, 12 bits */
>  	__le32 reserved; /* May be needed in part for CAN XL priority */
>  	__le32 flags;
>  	__le32 can_id;
> -- 
> 2.39.2
> 


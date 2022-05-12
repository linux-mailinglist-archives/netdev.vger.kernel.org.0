Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57AE652498A
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 11:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352043AbiELJzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 05:55:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348013AbiELJzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 05:55:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 31EC9118
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 02:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652349339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KTyi+QgtjaeLzBxP8UvvKb8hIDaqBweSpDuZFxbAFJ4=;
        b=GQ5h70tjAfiIsnJLwvnk/81P/0xg7Vq6XySba7QzJuBPat7S30mnFzBB+fJ31wptAr9jAo
        3K3rM6B3I/k0b3CALDK+mxaVchvdhsz79w/+Y96lcA+PJyCP3Wvn0q2Ogk62138kIS1Vyj
        OLrvA/VA4CSnCnsd+5d05ZJk5QWmINU=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-dEic5LgJMEKR1lyT3P1Jfw-1; Thu, 12 May 2022 05:55:38 -0400
X-MC-Unique: dEic5LgJMEKR1lyT3P1Jfw-1
Received: by mail-ej1-f71.google.com with SMTP id sh14-20020a1709076e8e00b006f4a5de6888so2597604ejc.8
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 02:55:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KTyi+QgtjaeLzBxP8UvvKb8hIDaqBweSpDuZFxbAFJ4=;
        b=2nDdHlVPkLewV7Rp8JxGdsHwoOAeZLn+dQcSPMNizHRf3V2jGUn/XQsLkigJ2IS/Ks
         Da0bSUGzrT8wpJaUfUYo1x4Kpb2MoI0oOv7b44CbPv7mSWorKUSssPorqEUktNQBQ/dF
         EtfX3FrIGj+DN/yaMiAQDCEt6qlELyf/AZWaV/ubjUQCQujcr0r1LpT9UdT8vYkiLu+P
         XWQ8CWaVg2sBuBHfW+xp6RxeufqxqHiWKkCkAy5Yji385T9YG2vvwX9BNvsz9qo/gQjz
         vS7+TPewT3nZf/u0NFq+xrucUAzhz3GEr5OzNiulbug03olwt3vxWPyAixgP5Tzyzrzq
         bpfw==
X-Gm-Message-State: AOAM532W07ZPn8wfyhVV5CEHsaMiPLku2EQ/hirFsuO7X4LSJdpdGz9H
        9G1AmKIubICnZpiftbucG4bMormr8NuksKJwd+VgohSghQchH4UanHHYeR7QPj/q1c6ZMPD9axD
        YKj1wd+WxcbYufDIV
X-Received: by 2002:a17:906:24db:b0:6f3:a29f:95dc with SMTP id f27-20020a17090624db00b006f3a29f95dcmr30632246ejb.520.1652349337078;
        Thu, 12 May 2022 02:55:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxJ/6j9W/MNfINIinLq5q1JqpXmXGJHbgRYzwfwXpm/gbXjhbK0fH+NnHlTkJ2he7f3mztKow==
X-Received: by 2002:a17:906:24db:b0:6f3:a29f:95dc with SMTP id f27-20020a17090624db00b006f3a29f95dcmr30632223ejb.520.1652349336799;
        Thu, 12 May 2022 02:55:36 -0700 (PDT)
Received: from redhat.com ([2.55.25.32])
        by smtp.gmail.com with ESMTPSA id b15-20020a170906660f00b006f39ffe23fdsm2018367ejp.0.2022.05.12.02.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 02:55:36 -0700 (PDT)
Date:   Thu, 12 May 2022 05:55:31 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     netdev@vger.kernel.org, rabeeh@solid-run.com,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH] net: virtio_net: support interrupt coalescing
Message-ID: <20220512055039-mutt-send-email-mst@kernel.org>
References: <20220512083523.1954281-1-alvaro.karsz@solid-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220512083523.1954281-1-alvaro.karsz@solid-run.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 12, 2022 at 11:35:23AM +0300, Alvaro Karsz wrote:
> Control a Virtio network device interrupt coalescing parameters
> using the control virtqueue.
> 
> New VirtIO network feature: VIRTIO_NET_F_INTR_COAL.
> 
> A device that supports this fetature can receive
> VIRTIO_NET_CTRL_INTR_COAL control commands.
> 
> * VIRTIO_NET_CTRL_INTR_COAL_USECS_SET:
> 	change the rx-usecs and tx-usecs parameters.
> 
> 	rx-usecs - Time to delay an RX interrupt after packet arrival in
> 		microseconds.
> 
> 	tx-usecs - Time to delay a TX interrupt after a sending a packet
> 		in microseconds.
> 
> * VIRTIO_NET_CTRL_INTR_COAL_FRAMES_SET:
> 	change the rx-max-frames and tx-max-frames parameters.
> 
> 	rx-max-frames: Number of packets to delay an RX interrupt after
> 		packet arrival.
> 
> 	tx-max-frames: Number of packets to delay a TX interrupt after
> 		sending a packet.
> 
> Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>

So first, please at least reserve the feature in the virtio spec.
Preferably add the specification as well.
Here's one way to do it:
https://github.com/oasis-tcs/virtio-spec#use-of-github-issues


> ---
>  drivers/net/virtio_net.c        | 108 ++++++++++++++++++++++++++++----
>  include/uapi/linux/virtio_net.h |  34 +++++++++-
>  2 files changed, 128 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index cbba9d2e8f3..4806c35ddd5 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -261,6 +261,12 @@ struct virtnet_info {
>  	u8 duplex;
>  	u32 speed;
> 
> +	/* Interrupt coalescing settings */
> +	u32 tx_usecs;
> +	u32 rx_usecs;
> +	u32 tx_frames_max;
> +	u32 rx_frames_max;
> +
>  	unsigned long guest_offloads;
>  	unsigned long guest_offloads_capable;
> 
> @@ -2594,19 +2600,75 @@ static int virtnet_set_coalesce(struct net_device *dev,
>  {
>  	struct virtnet_info *vi = netdev_priv(dev);
>  	int i, napi_weight;
> +	struct scatterlist sgs_usecs, sgs_frames;
> +	struct virtio_net_ctrl_coal_frames c_frames;
> +	struct virtio_net_ctrl_coal_usec c_usecs;
> +	bool update_napi,
> +	intr_coal = virtio_has_feature(vi->vdev, VIRTIO_NET_F_INTR_COAL);
> +
> +	/* rx_coalesce_usecs/tx_coalesce_usecs are supported only
> +	 * if VIRTIO_NET_F_INTR_COAL feature is set.
> +	 */
> +	if (!intr_coal && (ec->rx_coalesce_usecs || ec->tx_coalesce_usecs))
> +		return -EOPNOTSUPP;
> +
> +	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_INTR_COAL)) {
> +		/* Send usec command */
> +		c_usecs.tx_usecs = ec->tx_coalesce_usecs;
> +		c_usecs.rx_usecs = ec->rx_coalesce_usecs;
> +		sg_init_one(&sgs_usecs, &c_usecs, sizeof(c_usecs));
> +
> +		if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_INTR_COAL,
> +					  VIRTIO_NET_CTRL_INTR_COAL_USECS_SET,
> +					  &sgs_usecs))
> +			return -EINVAL;
> +
> +		/* Save parameters */
> +		vi->tx_usecs = ec->tx_coalesce_usecs;
> +		vi->rx_usecs = ec->rx_coalesce_usecs;
> +
> +		/* Send frames command */
> +		c_frames.tx_frames_max = ec->tx_max_coalesced_frames;
> +		c_frames.rx_frames_max = ec->rx_max_coalesced_frames;
> +		sg_init_one(&sgs_frames, &c_frames, sizeof(c_frames));
> +
> +		if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_INTR_COAL,
> +					  VIRTIO_NET_CTRL_INTR_COAL_FRAMES_SET,
> +					  &sgs_frames))
> +			return -EINVAL;
> +
> +		/* Save parameters */
> +		vi->tx_frames_max = ec->tx_max_coalesced_frames;
> +		vi->rx_frames_max = ec->rx_max_coalesced_frames;




> +	}
> +
> +	/* Should we update NAPI? */
> +	update_napi = ec->tx_max_coalesced_frames <= 1 &&
> +			ec->rx_max_coalesced_frames == 1;
> 
> -	if (ec->tx_max_coalesced_frames > 1 ||
> -	    ec->rx_max_coalesced_frames != 1)
> +	/* If interrupt coalesing feature is not set, and we can't update NAPI, return an error */
> +	if (!intr_coal && !update_napi)
>  		return -EINVAL;
> 
> -	napi_weight = ec->tx_max_coalesced_frames ? NAPI_POLL_WEIGHT : 0;
> -	if (napi_weight ^ vi->sq[0].napi.weight) {
> -		if (dev->flags & IFF_UP)
> -			return -EBUSY;
> -		for (i = 0; i < vi->max_queue_pairs; i++)
> -			vi->sq[i].napi.weight = napi_weight;
> +	if (update_napi) {
> +		napi_weight = ec->tx_max_coalesced_frames ? NAPI_POLL_WEIGHT : 0;
> +		if (napi_weight ^ vi->sq[0].napi.weight) {
> +			if (dev->flags & IFF_UP) {
> +				/* If Interrupt coalescing feature is not set, return an error.
> +				 * Otherwise exit without changing the NAPI paremeters
> +				 */
> +				if (!intr_coal)
> +					return -EBUSY;
> +
> +				goto exit;
> +			}
> +
> +			for (i = 0; i < vi->max_queue_pairs; i++)
> +				vi->sq[i].napi.weight = napi_weight;
> +		}
>  	}
> 
> +exit:
>  	return 0;
>  }
> 
> @@ -2616,14 +2678,25 @@ static int virtnet_get_coalesce(struct net_device *dev,
>  				struct netlink_ext_ack *extack)
>  {
>  	struct ethtool_coalesce ec_default = {
> -		.cmd = ETHTOOL_GCOALESCE,
> -		.rx_max_coalesced_frames = 1,
> +		.cmd = ETHTOOL_GCOALESCE
>  	};
> +
>  	struct virtnet_info *vi = netdev_priv(dev);
> +	bool intr_coal = virtio_has_feature(vi->vdev, VIRTIO_NET_F_INTR_COAL);
> +
> +	/* Add Interrupt coalescing settings */
> +	if (intr_coal) {
> +		ec_default.rx_coalesce_usecs = vi->rx_usecs;
> +		ec_default.tx_coalesce_usecs = vi->tx_usecs;
> +		ec_default.tx_max_coalesced_frames = vi->tx_frames_max;
> +		ec_default.rx_max_coalesced_frames = vi->rx_frames_max;
> +	} else {
> +		ec_default.rx_max_coalesced_frames = 1;
> +	}
> 
>  	memcpy(ec, &ec_default, sizeof(ec_default));
> 
> -	if (vi->sq[0].napi.weight)
> +	if (!intr_coal && vi->sq[0].napi.weight)
>  		ec->tx_max_coalesced_frames = 1;
> 
>  	return 0;
> @@ -2743,7 +2816,7 @@ static int virtnet_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *info)
>  }
> 
>  static const struct ethtool_ops virtnet_ethtool_ops = {
> -	.supported_coalesce_params = ETHTOOL_COALESCE_MAX_FRAMES,
> +	.supported_coalesce_params = ETHTOOL_COALESCE_MAX_FRAMES | ETHTOOL_COALESCE_USECS,
>  	.get_drvinfo = virtnet_get_drvinfo,
>  	.get_link = ethtool_op_get_link,
>  	.get_ringparam = virtnet_get_ringparam,
> @@ -3423,6 +3496,8 @@ static bool virtnet_validate_features(struct virtio_device *vdev)
>  	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_RSS,
>  			     "VIRTIO_NET_F_CTRL_VQ") ||
>  	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_HASH_REPORT,
> +			     "VIRTIO_NET_F_CTRL_VQ") ||
> +	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_INTR_COAL,
>  			     "VIRTIO_NET_F_CTRL_VQ"))) {
>  		return false;
>  	}
> @@ -3558,6 +3633,13 @@ static int virtnet_probe(struct virtio_device *vdev)
>  	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
>  		vi->mergeable_rx_bufs = true;
> 
> +	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_INTR_COAL)) {
> +		vi->rx_usecs = 0;
> +		vi->tx_usecs = 0;
> +		vi->tx_frames_max = 0;
> +		vi->rx_frames_max = 0;
> +	}
> +
>  	if (virtio_has_feature(vdev, VIRTIO_NET_F_HASH_REPORT))
>  		vi->has_rss_hash_report = true;
> 
> @@ -3786,7 +3868,7 @@ static struct virtio_device_id id_table[] = {
>  	VIRTIO_NET_F_CTRL_MAC_ADDR, \
>  	VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
>  	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
> -	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT
> +	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT, VIRTIO_NET_F_INTR_COAL
> 
>  static unsigned int features[] = {
>  	VIRTNET_FEATURES,
> diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
> index 3f55a4215f1..b65a4295270 100644
> --- a/include/uapi/linux/virtio_net.h
> +++ b/include/uapi/linux/virtio_net.h
> @@ -56,7 +56,7 @@
>  #define VIRTIO_NET_F_MQ	22	/* Device supports Receive Flow
>  					 * Steering */
>  #define VIRTIO_NET_F_CTRL_MAC_ADDR 23	/* Set MAC address */
> -
> +#define VIRTIO_NET_F_INTR_COAL	55	/* Guest can handle Interrupt coalescing */
>  #define VIRTIO_NET_F_HASH_REPORT  57	/* Supports hash report */
>  #define VIRTIO_NET_F_RSS	  60	/* Supports RSS RX steering */
>  #define VIRTIO_NET_F_RSC_EXT	  61	/* extended coalescing info */
> @@ -355,4 +355,36 @@ struct virtio_net_hash_config {
>  #define VIRTIO_NET_CTRL_GUEST_OFFLOADS   5
>  #define VIRTIO_NET_CTRL_GUEST_OFFLOADS_SET        0
> 
> +/*
> + * Control interrupt coalescing.
> + *
> + * Request the device to change the interrupt coalescing parameters.
> + *
> + * Available with the VIRTIO_NET_F_INTR_COAL feature bit.
> + */
> +#define VIRTIO_NET_CTRL_INTR_COAL		6
> +/*
> + * Set the rx-usecs/tx-usecs patameters.
> + * rx-usecs - Number of microseconds to delay an RX interrupt after packet arrival.
> + * tx-usecs - Number of microseconds to delay a TX interrupt after a sending a packet.
> + */
> +struct virtio_net_ctrl_coal_usec {
> +	__u32 tx_usecs;
> +	__u32 rx_usecs;
> +};
> +
> +#define VIRTIO_NET_CTRL_INTR_COAL_USECS_SET		0
> +
> +/*
> + * Set the rx-max-frames/tx-max-frames patameters.
> + * rx-max-frames - Number of packets to delay an RX interrupt after packet arrival.
> + * tx-max-frames - Number of packets to delay a TX interrupt after sending a packet.
> + */
> +struct virtio_net_ctrl_coal_frames {
> +	__u32 tx_frames_max;
> +	__u32 rx_frames_max;
> +};
> +

You want all these to be LE. Native endian's unpredictable in lots of
virt settings.


> +#define VIRTIO_NET_CTRL_INTR_COAL_FRAMES_SET		1
> +
>  #endif /* _UAPI_LINUX_VIRTIO_NET_H */
> --
> 2.32.0


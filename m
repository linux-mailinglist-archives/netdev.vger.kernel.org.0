Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 071F55793C4
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 09:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234838AbiGSHEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 03:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234784AbiGSHEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 03:04:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F004731DFF
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 00:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658214241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2JK1bjpDsVOvb4cyqJZ8D4eBUqVNYGTPjYqMjiZCT28=;
        b=JmLm9TesoFuoD1EqlQcc3EGlLHKeRYE/FA7u0Y8bXm0Fx11FuE1sPcqzIzf4VMjgRMdA0Z
        VNMOY4kopqbm3EG00gB4E/TpUoeTXTx9R/mgS8FG2YMvLMIz0MrTkvIcqD0CWclcN1zMGM
        lQhgs8Ty66Nl7iehOGTNWbg2egq9uqI=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-537-cwbvvI75NJekyAj_43aFZw-1; Tue, 19 Jul 2022 03:03:59 -0400
X-MC-Unique: cwbvvI75NJekyAj_43aFZw-1
Received: by mail-pj1-f69.google.com with SMTP id q5-20020a17090a7a8500b001f0253f5aa3so8356910pjf.4
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 00:03:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2JK1bjpDsVOvb4cyqJZ8D4eBUqVNYGTPjYqMjiZCT28=;
        b=Ox4g8iZ5aBplyVwq5gSL0JMO6yKpPNePoba+fIuhQEBy+JlYHBPsiQXEZna4gzVICy
         W00Gxe0763430SwPqtA0lugjHeH6JtmkSvDWmRshNNEvUqGSuFbeSIqk9+XMGVLopYhG
         OZLpyy2pwhwrD5IgWRR2zwDDwFrJzgWkKRLt63ZjbntMxeo6XyZGal9V5K3nnsliq+a6
         VhxAndRp4vv6H7JC5sAP9wMI7RRe00lR0oOYkjNJ3X0WbPPyj8hDl0N4USlOKg9oztN+
         eXo91RaTGmB5Eq5JeUG4JrAcLjehLqEnvfaor6+hTqbVmdD90UpccYj7RDzfTEk5HPvc
         XCOg==
X-Gm-Message-State: AJIora9AianyJGABc6YR4wzavFh+hUlANIv8IyunY8zi2TDqap8WsrKF
        80WI9bZhVBy3zME1eoGp1l6OsC+WpecooPsT2bb92R0pWM1QmmX0yuSqp8Po+KLNi5FBfZ0IkDo
        MCJW5vonHM5ipAffz
X-Received: by 2002:a17:90a:e7d1:b0:1f0:2304:f57f with SMTP id kb17-20020a17090ae7d100b001f02304f57fmr43648065pjb.133.1658214237958;
        Tue, 19 Jul 2022 00:03:57 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1thxhW7QSifnV6D/FuINF+il0+Gr9rRFAxHDrQYtiHZ/G3+P1XDop8OdeB/AoIDAwutGuGU5w==
X-Received: by 2002:a17:90a:e7d1:b0:1f0:2304:f57f with SMTP id kb17-20020a17090ae7d100b001f02304f57fmr43648046pjb.133.1658214237624;
        Tue, 19 Jul 2022 00:03:57 -0700 (PDT)
Received: from [10.72.13.162] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a201-20020a621ad2000000b0050dc76281e0sm10461113pfa.186.2022.07.19.00.03.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jul 2022 00:03:56 -0700 (PDT)
Message-ID: <d6423ae9-aa8b-7213-17c9-6027e9096143@redhat.com>
Date:   Tue, 19 Jul 2022 15:03:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v4] net: virtio_net: notifications coalescing
 support
Content-Language: en-US
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220718091102.498774-1-alvaro.karsz@solid-run.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220718091102.498774-1-alvaro.karsz@solid-run.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/7/18 17:11, Alvaro Karsz 写道:
> New VirtIO network feature: VIRTIO_NET_F_NOTF_COAL.
>
> Control a Virtio network device notifications coalescing parameters
> using the control virtqueue.
>
> A device that supports this fetature can receive
> VIRTIO_NET_CTRL_NOTF_COAL control commands.
>
> - VIRTIO_NET_CTRL_NOTF_COAL_TX_SET:
>    Ask the network device to change the following parameters:
>    - tx_usecs: Maximum number of usecs to delay a TX notification.
>    - tx_max_packets: Maximum number of packets to send before a
>      TX notification.
>
> - VIRTIO_NET_CTRL_NOTF_COAL_RX_SET:
>    Ask the network device to change the following parameters:
>    - rx_usecs: Maximum number of usecs to delay a RX notification.
>    - rx_max_packets: Maximum number of packets to receive before a
>      RX notification.
>
> VirtIO spec. patch:
> https://lists.oasis-open.org/archives/virtio-comment/202206/msg00100.html
>
> Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
> ---
> v2:
> 	- Fix type assignments warnings found with sparse.
> 	- Fix a few typos.
>
> v3:
>    - Change the coalescing parameters in a dedicated function.
>    - Return -EBUSY from the set coalescing function when the device's
>      link is up, even if the notifications coalescing feature is negotiated.
>
> v4:
>    - If link is up and we need to update NAPI weight, return -EBUSY before
>      sending the coalescing commands to the device
> ---
>   drivers/net/virtio_net.c        | 111 +++++++++++++++++++++++++++-----
>   include/uapi/linux/virtio_net.h |  34 +++++++++-
>   2 files changed, 129 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 356cf8dd416..4fde66bd511 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -261,6 +261,12 @@ struct virtnet_info {
>   	u8 duplex;
>   	u32 speed;
>
> +	/* Interrupt coalescing settings */
> +	u32 tx_usecs;
> +	u32 rx_usecs;
> +	u32 tx_max_packets;
> +	u32 rx_max_packets;
> +
>   	unsigned long guest_offloads;
>   	unsigned long guest_offloads_capable;
>
> @@ -2587,27 +2593,89 @@ static int virtnet_get_link_ksettings(struct net_device *dev,
>   	return 0;
>   }
>
> +static int virtnet_send_notf_coal_cmds(struct virtnet_info *vi,
> +				       struct ethtool_coalesce *ec)
> +{
> +	struct scatterlist sgs_tx, sgs_rx;
> +	struct virtio_net_ctrl_coal_tx coal_tx;
> +	struct virtio_net_ctrl_coal_rx coal_rx;
> +
> +	coal_tx.tx_usecs = cpu_to_le32(ec->tx_coalesce_usecs);
> +	coal_tx.tx_max_packets = cpu_to_le32(ec->tx_max_coalesced_frames);
> +	sg_init_one(&sgs_tx, &coal_tx, sizeof(coal_tx));
> +
> +	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_NOTF_COAL,
> +				  VIRTIO_NET_CTRL_NOTF_COAL_TX_SET,
> +				  &sgs_tx))
> +		return -EINVAL;
> +
> +	/* Save parameters */
> +	vi->tx_usecs = ec->tx_coalesce_usecs;
> +	vi->tx_max_packets = ec->tx_max_coalesced_frames;
> +
> +	coal_rx.rx_usecs = cpu_to_le32(ec->rx_coalesce_usecs);
> +	coal_rx.rx_max_packets = cpu_to_le32(ec->rx_max_coalesced_frames);
> +	sg_init_one(&sgs_rx, &coal_rx, sizeof(coal_rx));
> +
> +	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_NOTF_COAL,
> +				  VIRTIO_NET_CTRL_NOTF_COAL_RX_SET,
> +				  &sgs_rx))
> +		return -EINVAL;
> +
> +	/* Save parameters */
> +	vi->rx_usecs = ec->rx_coalesce_usecs;
> +	vi->rx_max_packets = ec->rx_max_coalesced_frames;
> +
> +	return 0;
> +}
> +
> +static int virtnet_coal_params_supported(struct ethtool_coalesce *ec)
> +{
> +	/* usecs coalescing is supported only if VIRTIO_NET_F_NOTF_COAL
> +	 * feature is negotiated.
> +	 */
> +	if (ec->rx_coalesce_usecs || ec->tx_coalesce_usecs)
> +		return -EOPNOTSUPP;


This seems an independent fix? I wonder what if we just leave it as before.

Other looks good to me.

Thanks


> +
> +	if (ec->tx_max_coalesced_frames > 1 ||
> +	    ec->rx_max_coalesced_frames != 1)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
>   static int virtnet_set_coalesce(struct net_device *dev,
>   				struct ethtool_coalesce *ec,
>   				struct kernel_ethtool_coalesce *kernel_coal,
>   				struct netlink_ext_ack *extack)
>   {
>   	struct virtnet_info *vi = netdev_priv(dev);
> -	int i, napi_weight;
> -
> -	if (ec->tx_max_coalesced_frames > 1 ||
> -	    ec->rx_max_coalesced_frames != 1)
> -		return -EINVAL;
> +	int ret, i, napi_weight;
> +	bool update_napi = false;
>
> +	/* Can't change NAPI weight if the link is up */
>   	napi_weight = ec->tx_max_coalesced_frames ? NAPI_POLL_WEIGHT : 0;
>   	if (napi_weight ^ vi->sq[0].napi.weight) {
>   		if (dev->flags & IFF_UP)
>   			return -EBUSY;
> +		else
> +			update_napi = true;
> +	}
> +
> +	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_NOTF_COAL))
> +		ret = virtnet_send_notf_coal_cmds(vi, ec);
> +	else
> +		ret = virtnet_coal_params_supported(ec);
> +
> +	if (ret)
> +		return ret;
> +
> +	if (update_napi) {
>   		for (i = 0; i < vi->max_queue_pairs; i++)
>   			vi->sq[i].napi.weight = napi_weight;
>   	}
>
> -	return 0;
> +	return ret;
>   }
>
>   static int virtnet_get_coalesce(struct net_device *dev,
> @@ -2615,16 +2683,19 @@ static int virtnet_get_coalesce(struct net_device *dev,
>   				struct kernel_ethtool_coalesce *kernel_coal,
>   				struct netlink_ext_ack *extack)
>   {
> -	struct ethtool_coalesce ec_default = {
> -		.cmd = ETHTOOL_GCOALESCE,
> -		.rx_max_coalesced_frames = 1,
> -	};
>   	struct virtnet_info *vi = netdev_priv(dev);
>
> -	memcpy(ec, &ec_default, sizeof(ec_default));
> +	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_NOTF_COAL)) {
> +		ec->rx_coalesce_usecs = vi->rx_usecs;
> +		ec->tx_coalesce_usecs = vi->tx_usecs;
> +		ec->tx_max_coalesced_frames = vi->tx_max_packets;
> +		ec->rx_max_coalesced_frames = vi->rx_max_packets;
> +	} else {
> +		ec->rx_max_coalesced_frames = 1;
>
> -	if (vi->sq[0].napi.weight)
> -		ec->tx_max_coalesced_frames = 1;
> +		if (vi->sq[0].napi.weight)
> +			ec->tx_max_coalesced_frames = 1;
> +	}
>
>   	return 0;
>   }
> @@ -2743,7 +2814,8 @@ static int virtnet_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *info)
>   }
>
>   static const struct ethtool_ops virtnet_ethtool_ops = {
> -	.supported_coalesce_params = ETHTOOL_COALESCE_MAX_FRAMES,
> +	.supported_coalesce_params = ETHTOOL_COALESCE_MAX_FRAMES |
> +		ETHTOOL_COALESCE_USECS,
>   	.get_drvinfo = virtnet_get_drvinfo,
>   	.get_link = ethtool_op_get_link,
>   	.get_ringparam = virtnet_get_ringparam,
> @@ -3411,6 +3483,8 @@ static bool virtnet_validate_features(struct virtio_device *vdev)
>   	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_RSS,
>   			     "VIRTIO_NET_F_CTRL_VQ") ||
>   	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_HASH_REPORT,
> +			     "VIRTIO_NET_F_CTRL_VQ") ||
> +	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_NOTF_COAL,
>   			     "VIRTIO_NET_F_CTRL_VQ"))) {
>   		return false;
>   	}
> @@ -3546,6 +3620,13 @@ static int virtnet_probe(struct virtio_device *vdev)
>   	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
>   		vi->mergeable_rx_bufs = true;
>
> +	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_NOTF_COAL)) {
> +		vi->rx_usecs = 0;
> +		vi->tx_usecs = 0;
> +		vi->tx_max_packets = 0;
> +		vi->rx_max_packets = 0;
> +	}
> +
>   	if (virtio_has_feature(vdev, VIRTIO_NET_F_HASH_REPORT))
>   		vi->has_rss_hash_report = true;
>
> @@ -3780,7 +3861,7 @@ static struct virtio_device_id id_table[] = {
>   	VIRTIO_NET_F_CTRL_MAC_ADDR, \
>   	VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
>   	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
> -	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT
> +	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT, VIRTIO_NET_F_NOTF_COAL
>
>   static unsigned int features[] = {
>   	VIRTNET_FEATURES,
> diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
> index 3f55a4215f1..29ced55514d 100644
> --- a/include/uapi/linux/virtio_net.h
> +++ b/include/uapi/linux/virtio_net.h
> @@ -56,7 +56,7 @@
>   #define VIRTIO_NET_F_MQ	22	/* Device supports Receive Flow
>   					 * Steering */
>   #define VIRTIO_NET_F_CTRL_MAC_ADDR 23	/* Set MAC address */
> -
> +#define VIRTIO_NET_F_NOTF_COAL	53	/* Guest can handle notifications coalescing */
>   #define VIRTIO_NET_F_HASH_REPORT  57	/* Supports hash report */
>   #define VIRTIO_NET_F_RSS	  60	/* Supports RSS RX steering */
>   #define VIRTIO_NET_F_RSC_EXT	  61	/* extended coalescing info */
> @@ -355,4 +355,36 @@ struct virtio_net_hash_config {
>   #define VIRTIO_NET_CTRL_GUEST_OFFLOADS   5
>   #define VIRTIO_NET_CTRL_GUEST_OFFLOADS_SET        0
>
> +/*
> + * Control notifications coalescing.
> + *
> + * Request the device to change the notifications coalescing parameters.
> + *
> + * Available with the VIRTIO_NET_F_NOTF_COAL feature bit.
> + */
> +#define VIRTIO_NET_CTRL_NOTF_COAL		6
> +/*
> + * Set the tx-usecs/tx-max-packets patameters.
> + * tx-usecs - Maximum number of usecs to delay a TX notification.
> + * tx-max-packets - Maximum number of packets to send before a TX notification.
> + */
> +struct virtio_net_ctrl_coal_tx {
> +	__le32 tx_max_packets;
> +	__le32 tx_usecs;
> +};
> +
> +#define VIRTIO_NET_CTRL_NOTF_COAL_TX_SET		0
> +
> +/*
> + * Set the rx-usecs/rx-max-packets patameters.
> + * rx-usecs - Maximum number of usecs to delay a RX notification.
> + * rx-max-frames - Maximum number of packets to receive before a RX notification.
> + */
> +struct virtio_net_ctrl_coal_rx {
> +	__le32 rx_max_packets;
> +	__le32 rx_usecs;
> +};
> +
> +#define VIRTIO_NET_CTRL_NOTF_COAL_RX_SET		1
> +
>   #endif /* _UAPI_LINUX_VIRTIO_NET_H */
> --
> 2.32.0
>


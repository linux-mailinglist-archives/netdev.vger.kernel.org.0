Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD8D55744DC
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 08:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233642AbiGNGJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 02:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233577AbiGNGJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 02:09:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 709BD1C12A
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 23:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657778930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A9muFnpCfqU1v1W+APUJGYYAcqQ0zhBkGm5bOYM+Qq4=;
        b=R/SGla9y5kYI1TGPJuyvWx9MFqHPYDhlC1RmDeMxb4XkXv/NTvCYnp4HmK16qCjQxvIX53
        I7i1fMzV1easH2iK8zlw1zy44ma9UMzn2GQksiXIWMMBfcAnWq1Vdq7um/4KfDuE4EbeMb
        1XLZZhVId42Y4TTm/oTzRLQeCzfq+jU=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-lqzid-dCMk2JTqqY8ypTzA-1; Thu, 14 Jul 2022 02:08:47 -0400
X-MC-Unique: lqzid-dCMk2JTqqY8ypTzA-1
Received: by mail-pg1-f197.google.com with SMTP id p35-20020a631e63000000b0041992866de0so605876pgm.19
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 23:08:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=A9muFnpCfqU1v1W+APUJGYYAcqQ0zhBkGm5bOYM+Qq4=;
        b=NpJp1DEOe0ftqQhJ1O4774ycYe2ELGy8cCV6sokK/hZgu81BywG3l/aozZd0QELF8Z
         zwXYcu2izPSolijqCERQ7LCOHMT0Kzf0pTgrhbJ5EPj8eEQdpf+ytmTGbugJRCaO8RBx
         l5oVsBajcZMLd5w/nZGw9nj0icACH2nW6uE5Yso9yTsMVybkyG25V21P6OgdTHeYjXO1
         o9L8R1U1JQN4kqpiDalUoIWmNLbb5YCH5HWBv1yK3KuRZEgXgyjRX4KMY+ThdGUStFdl
         jcqli+PUr9SPXhvOMYGi47LYx6GVIIEjODJHPYxy77rPmNXlNOWCNJF6etmwgvpa7ybB
         rFtw==
X-Gm-Message-State: AJIora8qEP8b0GwjImt4+jDLxPYvW7ySoNuiRQNQUuLos/kdRw/kdAJH
        xFhOMRfGquxfQtqxDEDCP1AqTx3ZsEZqDFLXjLyD5GA/y6P6LBVbPjNoWzZneruW2C1BEBcDVKr
        dnISpVVpgL6Bvnl5N
X-Received: by 2002:a17:90a:e547:b0:1ef:95c2:cefb with SMTP id ei7-20020a17090ae54700b001ef95c2cefbmr13942133pjb.225.1657778925901;
        Wed, 13 Jul 2022 23:08:45 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sGUIw6QAu96YofXuQ5ynTjZts0vTqxe7SfukrkYMsWWVPnn7qRx5pC34jhnCa7KrE6FOPM4A==
X-Received: by 2002:a17:90a:e547:b0:1ef:95c2:cefb with SMTP id ei7-20020a17090ae54700b001ef95c2cefbmr13942095pjb.225.1657778925495;
        Wed, 13 Jul 2022 23:08:45 -0700 (PDT)
Received: from [10.72.12.153] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q102-20020a17090a17ef00b001ef8407f6d2sm2658014pja.46.2022.07.13.23.08.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jul 2022 23:08:44 -0700 (PDT)
Message-ID: <3d89f89f-074a-8363-0119-5630d40b1685@redhat.com>
Date:   Thu, 14 Jul 2022 14:08:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v2] net: virtio_net: notifications coalescing support
Content-Language: en-US
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220712112210.2852777-1-alvaro.karsz@solid-run.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220712112210.2852777-1-alvaro.karsz@solid-run.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/7/12 19:22, Alvaro Karsz 写道:
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


Note that until this is merged, the patch should be tagged as RFC.

And it looks to me we should target this as net-next instead of net.


>
> Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
> ---
> v2:
> 	- Fix type assignments warnings found with sparse.
> 	- Fix a few typos.
> ---
>   drivers/net/virtio_net.c        | 110 ++++++++++++++++++++++++++++----
>   include/uapi/linux/virtio_net.h |  34 +++++++++-
>   2 files changed, 130 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 356cf8dd416..7837db0306f 100644
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
> @@ -2594,19 +2600,76 @@ static int virtnet_set_coalesce(struct net_device *dev,
>   {
>   	struct virtnet_info *vi = netdev_priv(dev);
>   	int i, napi_weight;
> +	struct scatterlist sgs_tx, sgs_rx;
> +	struct virtio_net_ctrl_coal_tx coal_tx;
> +	struct virtio_net_ctrl_coal_rx coal_rx;
> +	bool update_napi,
> +	notf_coal = virtio_has_feature(vi->vdev, VIRTIO_NET_F_NOTF_COAL);
> +
> +	/* rx_coalesce_usecs/tx_coalesce_usecs are supported only
> +	 * if VIRTIO_NET_F_NOTF_COAL feature is negotiated.
> +	 */
> +	if (!notf_coal && (ec->rx_coalesce_usecs || ec->tx_coalesce_usecs))
> +		return -EOPNOTSUPP;
> +
> +	if (notf_coal) {
> +		coal_tx.tx_usecs = cpu_to_le32(ec->tx_coalesce_usecs);
> +		coal_tx.tx_max_packets = cpu_to_le32(ec->tx_max_coalesced_frames);
> +		sg_init_one(&sgs_tx, &coal_tx, sizeof(coal_tx));
> +
> +		if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_NOTF_COAL,
> +					  VIRTIO_NET_CTRL_NOTF_COAL_TX_SET,
> +					  &sgs_tx))
> +			return -EINVAL;
> +
> +		/* Save parameters */
> +		vi->tx_usecs = ec->tx_coalesce_usecs;
> +		vi->tx_max_packets = ec->tx_max_coalesced_frames;
> +
> +		coal_rx.rx_usecs = cpu_to_le32(ec->rx_coalesce_usecs);
> +		coal_rx.rx_max_packets = cpu_to_le32(ec->rx_max_coalesced_frames);
> +		sg_init_one(&sgs_rx, &coal_rx, sizeof(coal_rx));
> +
> +		if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_NOTF_COAL,
> +					  VIRTIO_NET_CTRL_NOTF_COAL_RX_SET,
> +					  &sgs_rx))
> +			return -EINVAL;
> +
> +		/* Save parameters */
> +		vi->rx_usecs = ec->rx_coalesce_usecs;
> +		vi->rx_max_packets = ec->rx_max_coalesced_frames;
> +	}
> +
> +	/* Should we update NAPI? */
> +	update_napi = ec->tx_max_coalesced_frames <= 1 &&
> +			ec->rx_max_coalesced_frames == 1;
>   
> -	if (ec->tx_max_coalesced_frames > 1 ||
> -	    ec->rx_max_coalesced_frames != 1)
> +	/* If notifications coalesing feature is not negotiated,
> +	 * and we can't update NAPI, return an error
> +	 */
> +	if (!notf_coal && !update_napi)
>   		return -EINVAL;
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
> +				/* If notifications coalescing feature is not negotiated,
> +				 * return an error, otherwise exit without changing
> +				 * the NAPI parameters.
> +				 */
> +				if (!notf_coal)
> +					return -EBUSY;
> +
> +				goto exit;


I think we need to return -EBUSY here regardless whether or not 
interrupt coalescing is negotiated.

This is because the driver can work in two modes:

1) tx interrupt mode (tx_max_coalesced_frames = 1)
2) no tx interrupt mode (will do skb_orphan) (tx_max_coalesced_frames = 0)

Mode switching is more easier to be done when the interface is down.

When the coalescing is neogiated, we can stick the above logic:

1) tx interrupt mode (tx_max_coalesced_frames >= 1)
2) no tx interrupt mode (will do skb_orphan) (tx_max_coalesced_frames = 0)

So if no mode switching (no switching between zero and non zero value of 
tx_max_coalesced_frames), we don't need an update of napi_weight. But if 
it requires a switch, it still needs to be done when the interface is 
down (technically it's not a must but it should be another topic/patch).


> +			}
> +
> +			for (i = 0; i < vi->max_queue_pairs; i++)
> +				vi->sq[i].napi.weight = napi_weight;
> +		}
>   	}
>   
> +exit:
>   	return 0;
>   }
>   
> @@ -2616,14 +2679,25 @@ static int virtnet_get_coalesce(struct net_device *dev,
>   				struct netlink_ext_ack *extack)
>   {
>   	struct ethtool_coalesce ec_default = {
> -		.cmd = ETHTOOL_GCOALESCE,
> -		.rx_max_coalesced_frames = 1,


Nit: we can stick to this then we can remove the following "else".

Thanks


> +		.cmd = ETHTOOL_GCOALESCE
>   	};
> +
>   	struct virtnet_info *vi = netdev_priv(dev);
> +	bool notf_coal = virtio_has_feature(vi->vdev, VIRTIO_NET_F_NOTF_COAL);
> +
> +	/* Add notifications coalescing settings */
> +	if (notf_coal) {
> +		ec_default.rx_coalesce_usecs = vi->rx_usecs;
> +		ec_default.tx_coalesce_usecs = vi->tx_usecs;
> +		ec_default.tx_max_coalesced_frames = vi->tx_max_packets;
> +		ec_default.rx_max_coalesced_frames = vi->rx_max_packets;
> +	} else {
> +		ec_default.rx_max_coalesced_frames = 1;
> +	}
>   
>   	memcpy(ec, &ec_default, sizeof(ec_default));
>   
> -	if (vi->sq[0].napi.weight)
> +	if (!notf_coal && vi->sq[0].napi.weight)
>   		ec->tx_max_coalesced_frames = 1;
>   
>   	return 0;
> @@ -2743,7 +2817,8 @@ static int virtnet_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *info)
>   }
>   
>   static const struct ethtool_ops virtnet_ethtool_ops = {
> -	.supported_coalesce_params = ETHTOOL_COALESCE_MAX_FRAMES,
> +	.supported_coalesce_params = ETHTOOL_COALESCE_MAX_FRAMES |
> +		ETHTOOL_COALESCE_USECS,
>   	.get_drvinfo = virtnet_get_drvinfo,
>   	.get_link = ethtool_op_get_link,
>   	.get_ringparam = virtnet_get_ringparam,
> @@ -3411,6 +3486,8 @@ static bool virtnet_validate_features(struct virtio_device *vdev)
>   	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_RSS,
>   			     "VIRTIO_NET_F_CTRL_VQ") ||
>   	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_HASH_REPORT,
> +			     "VIRTIO_NET_F_CTRL_VQ") ||
> +	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_NOTF_COAL,
>   			     "VIRTIO_NET_F_CTRL_VQ"))) {
>   		return false;
>   	}
> @@ -3546,6 +3623,13 @@ static int virtnet_probe(struct virtio_device *vdev)
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
> @@ -3780,7 +3864,7 @@ static struct virtio_device_id id_table[] = {
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


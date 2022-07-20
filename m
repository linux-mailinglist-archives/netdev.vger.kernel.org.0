Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D73157B11E
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 08:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240054AbiGTG2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 02:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240037AbiGTG2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 02:28:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2216848CBB
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 23:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658298530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YZGPzwpvIYfQbkHBn65c65RlMzROy29qd2H7JXvdpTY=;
        b=CXwovcZj5mu9YeTNVO/3Qtt5n9U8BcMassq3f8qRKdetd03fJyH+sYvT6Q1pYXKod0KiBs
        Qtaq1nkUQzYa3eUgg6v+fCL8rPojLb1QoARLzcwROtYynYlQyJCXQYkhSgtTCkZNz77y7p
        xgAGk4Mhi+DYHg95L9ZqMLYhSlR2lSw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-567-LEqrkPqfMcOx1g7q--zhIQ-1; Wed, 20 Jul 2022 02:28:46 -0400
X-MC-Unique: LEqrkPqfMcOx1g7q--zhIQ-1
Received: by mail-wm1-f71.google.com with SMTP id n30-20020a05600c501e00b003a3264465ebso1058484wmr.1
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 23:28:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YZGPzwpvIYfQbkHBn65c65RlMzROy29qd2H7JXvdpTY=;
        b=Sl9AjO+hAM/yWyu7pxSkpANuIJRS8bI7aX36NbnbcH6fQb3AGmHveamAiJp5HkMAsG
         thi4XzmlWmoeV7ejINkxbkpdSM2IawJpkpnBkuSRO2/yLIfMEFq9vAaUzR7L/aZf80Vp
         lR7YX7/3Ag3HMnMY9hQxp3cPadr7eGlyVex/xvx+QI7UcaR4flJ2z7Z7URM6OFamR13x
         t2ghnbNoEXuRIKon7rNR97sr7Ll3MPmmC52l4D4b78mxhJUX6I/QCTeLssAGQslLIN5e
         3Bs9T2K0PcCsTO+JPIcjIEmNLTHfqzqbuAYVzW7PyPEgmmveGK/f1ANzHFC/0D6U9He0
         oHxQ==
X-Gm-Message-State: AJIora9stfxmYiBySAPw4VA1fCE1+k9xR3RwX97PQn5dyVexBLyn6PWH
        q9wXlOx/kqk8bUD7UKRA+zG399IRWwlaiEhygvfIJ/WMowlX+/OaExk6/daL2p1ZgxaMNrVcbrb
        CxQDcJj/20smAZcF3
X-Received: by 2002:a5d:5a15:0:b0:21d:630c:a609 with SMTP id bq21-20020a5d5a15000000b0021d630ca609mr29147184wrb.468.1658298525481;
        Tue, 19 Jul 2022 23:28:45 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v2BJP7o4IvrogamEhz/2bh6icbbNybrJk84xj5lg9qqNRNmrY/V5kuUmlN4KYHuDk62IPpdg==
X-Received: by 2002:a5d:5a15:0:b0:21d:630c:a609 with SMTP id bq21-20020a5d5a15000000b0021d630ca609mr29147166wrb.468.1658298525144;
        Tue, 19 Jul 2022 23:28:45 -0700 (PDT)
Received: from redhat.com ([2.55.25.63])
        by smtp.gmail.com with ESMTPSA id i24-20020a1c5418000000b003a3187a2d4csm1231426wmb.22.2022.07.19.23.28.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 23:28:44 -0700 (PDT)
Date:   Wed, 20 Jul 2022 02:28:41 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v4] net: virtio_net: notifications coalescing
 support
Message-ID: <20220720020744-mutt-send-email-mst@kernel.org>
References: <20220718091102.498774-1-alvaro.karsz@solid-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718091102.498774-1-alvaro.karsz@solid-run.com>
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 18, 2022 at 12:11:02PM +0300, Alvaro Karsz wrote:
> New VirtIO network feature: VIRTIO_NET_F_NOTF_COAL.
> 
> Control a Virtio network device notifications coalescing parameters
> using the control virtqueue.
> 
> A device that supports this fetature can receive
> VIRTIO_NET_CTRL_NOTF_COAL control commands.
> 
> - VIRTIO_NET_CTRL_NOTF_COAL_TX_SET:
>   Ask the network device to change the following parameters:
>   - tx_usecs: Maximum number of usecs to delay a TX notification.
>   - tx_max_packets: Maximum number of packets to send before a
>     TX notification.
> 
> - VIRTIO_NET_CTRL_NOTF_COAL_RX_SET:
>   Ask the network device to change the following parameters:
>   - rx_usecs: Maximum number of usecs to delay a RX notification.
>   - rx_max_packets: Maximum number of packets to receive before a
>     RX notification.
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
>   - Change the coalescing parameters in a dedicated function.
>   - Return -EBUSY from the set coalescing function when the device's
>     link is up, even if the notifications coalescing feature is negotiated.
> 
> v4:
>   - If link is up and we need to update NAPI weight, return -EBUSY before
>     sending the coalescing commands to the device

Thanks! some comments below

> ---
>  drivers/net/virtio_net.c        | 111 +++++++++++++++++++++++++++-----
>  include/uapi/linux/virtio_net.h |  34 +++++++++-
>  2 files changed, 129 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 356cf8dd416..4fde66bd511 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -261,6 +261,12 @@ struct virtnet_info {
>  	u8 duplex;
>  	u32 speed;
> 
> +	/* Interrupt coalescing settings */
> +	u32 tx_usecs;
> +	u32 rx_usecs;
> +	u32 tx_max_packets;
> +	u32 rx_max_packets;
> +
>  	unsigned long guest_offloads;
>  	unsigned long guest_offloads_capable;
> 
> @@ -2587,27 +2593,89 @@ static int virtnet_get_link_ksettings(struct net_device *dev,
>  	return 0;
>  }
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
> +
> +	if (ec->tx_max_coalesced_frames > 1 ||
> +	    ec->rx_max_coalesced_frames != 1)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
>  static int virtnet_set_coalesce(struct net_device *dev,
>  				struct ethtool_coalesce *ec,
>  				struct kernel_ethtool_coalesce *kernel_coal,
>  				struct netlink_ext_ack *extack)
>  {
>  	struct virtnet_info *vi = netdev_priv(dev);
> -	int i, napi_weight;
> -
> -	if (ec->tx_max_coalesced_frames > 1 ||
> -	    ec->rx_max_coalesced_frames != 1)
> -		return -EINVAL;
> +	int ret, i, napi_weight;
> +	bool update_napi = false;
> 
> +	/* Can't change NAPI weight if the link is up */
>  	napi_weight = ec->tx_max_coalesced_frames ? NAPI_POLL_WEIGHT : 0;

Hmm. we currently (ab)use tx_max_coalesced_frames values 0 and 1 to mean tx napi on/off.
However I am not sure we should treat any value != 1 as napi on.

I don't really have good ideas - I think abusing coalescing might
have been a mistake. But now that we are there, I feel we need
a way for userspace to at least be able to figure out whether
setting coalescing to 0 will have nasty side effects.

For example, here's a problem:

- according to spec, all values are reset to 0
- userspace reads coalescing values and gets 0

Does this mean napi is off?

And now that we support colescing, I wonder how is user going to control napi.

It's also a bit of a spec defect that it does not document corner cases
like what do 0 values do, are they different from 1? or what are max values.
Not too late to fix?


>  	if (napi_weight ^ vi->sq[0].napi.weight) {
>  		if (dev->flags & IFF_UP)
>  			return -EBUSY;
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
>  		for (i = 0; i < vi->max_queue_pairs; i++)
>  			vi->sq[i].napi.weight = napi_weight;
>  	}
> 
> -	return 0;
> +	return ret;


>  }
> 
>  static int virtnet_get_coalesce(struct net_device *dev,
> @@ -2615,16 +2683,19 @@ static int virtnet_get_coalesce(struct net_device *dev,
>  				struct kernel_ethtool_coalesce *kernel_coal,
>  				struct netlink_ext_ack *extack)
>  {
> -	struct ethtool_coalesce ec_default = {
> -		.cmd = ETHTOOL_GCOALESCE,
> -		.rx_max_coalesced_frames = 1,
> -	};
>  	struct virtnet_info *vi = netdev_priv(dev);
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
>  	return 0;
>  }
> @@ -2743,7 +2814,8 @@ static int virtnet_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *info)
>  }
> 
>  static const struct ethtool_ops virtnet_ethtool_ops = {
> -	.supported_coalesce_params = ETHTOOL_COALESCE_MAX_FRAMES,
> +	.supported_coalesce_params = ETHTOOL_COALESCE_MAX_FRAMES |
> +		ETHTOOL_COALESCE_USECS,
>  	.get_drvinfo = virtnet_get_drvinfo,
>  	.get_link = ethtool_op_get_link,
>  	.get_ringparam = virtnet_get_ringparam,
> @@ -3411,6 +3483,8 @@ static bool virtnet_validate_features(struct virtio_device *vdev)
>  	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_RSS,
>  			     "VIRTIO_NET_F_CTRL_VQ") ||
>  	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_HASH_REPORT,
> +			     "VIRTIO_NET_F_CTRL_VQ") ||
> +	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_NOTF_COAL,
>  			     "VIRTIO_NET_F_CTRL_VQ"))) {
>  		return false;
>  	}
> @@ -3546,6 +3620,13 @@ static int virtnet_probe(struct virtio_device *vdev)
>  	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
>  		vi->mergeable_rx_bufs = true;
> 
> +	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_NOTF_COAL)) {
> +		vi->rx_usecs = 0;
> +		vi->tx_usecs = 0;
> +		vi->tx_max_packets = 0;
> +		vi->rx_max_packets = 0;
> +	}
> +
>  	if (virtio_has_feature(vdev, VIRTIO_NET_F_HASH_REPORT))
>  		vi->has_rss_hash_report = true;
> 
> @@ -3780,7 +3861,7 @@ static struct virtio_device_id id_table[] = {
>  	VIRTIO_NET_F_CTRL_MAC_ADDR, \
>  	VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
>  	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
> -	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT
> +	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT, VIRTIO_NET_F_NOTF_COAL
> 
>  static unsigned int features[] = {
>  	VIRTNET_FEATURES,
> diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
> index 3f55a4215f1..29ced55514d 100644
> --- a/include/uapi/linux/virtio_net.h
> +++ b/include/uapi/linux/virtio_net.h
> @@ -56,7 +56,7 @@
>  #define VIRTIO_NET_F_MQ	22	/* Device supports Receive Flow
>  					 * Steering */
>  #define VIRTIO_NET_F_CTRL_MAC_ADDR 23	/* Set MAC address */
> -
> +#define VIRTIO_NET_F_NOTF_COAL	53	/* Guest can handle notifications coalescing */

So the spec says
	Device supports notifications coalescing.

which makes more sense - there's not a lot guest needs to do here.


>  #define VIRTIO_NET_F_HASH_REPORT  57	/* Supports hash report */
>  #define VIRTIO_NET_F_RSS	  60	/* Supports RSS RX steering */
>  #define VIRTIO_NET_F_RSC_EXT	  61	/* extended coalescing info */
> @@ -355,4 +355,36 @@ struct virtio_net_hash_config {
>  #define VIRTIO_NET_CTRL_GUEST_OFFLOADS   5
>  #define VIRTIO_NET_CTRL_GUEST_OFFLOADS_SET        0
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

parameters?

> + * tx-usecs - Maximum number of usecs to delay a TX notification.
> + * tx-max-packets - Maximum number of packets to send before a TX notification.

why with dash here? And why not just put the comments near the fields
themselves?

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

same comments

> +
> +#define VIRTIO_NET_CTRL_NOTF_COAL_RX_SET		1
> +
>  #endif /* _UAPI_LINUX_VIRTIO_NET_H */
> --
> 2.32.0


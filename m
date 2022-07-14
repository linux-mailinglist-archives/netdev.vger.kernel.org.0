Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7DC05741B0
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 05:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbiGNDCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 23:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbiGNDCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 23:02:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BBE520F60
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 20:02:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5D41B8222B
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 03:02:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F71C34114;
        Thu, 14 Jul 2022 03:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657767724;
        bh=Nts3vO/72vW9NBaklFJhMDVPO2DM7S5z7HZl1HGvT44=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=usBRs2KhBZxiYRREFCwlVwEG9uTaoFPnWxoI8K9mBPrs9PItEP8keYxuEa7BY7MMW
         zCalZw2CGgc5YbD0bw9aUaabwtuGoPANIzbv5eoLYp8nXQV+680PiQb0sZO8UWuzdY
         1OKLSHLmWcNseiod9B1rbT9tivEA1TU/XILXOnWbcwnq1jgZVsr8Tuft959u/GonI2
         W7YVn7ogfJQiAUHLheWWc3d1GU/kOABq8FIrA3nq2gf27EVXNCuaCI4tmFkEy2o2Tv
         4zg1Bg1nQj31X5N8UM5DwfTl9mquYjkXG0R8teQdk+p4wKBhbgdww1WCZ8n5S/pXAR
         jHsaCp1u5LBBQ==
Date:   Wed, 13 Jul 2022 20:02:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     netdev@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v2] net: virtio_net: notifications coalescing support
Message-ID: <20220713200203.4eb3a64e@kernel.org>
In-Reply-To: <20220712112210.2852777-1-alvaro.karsz@solid-run.com>
References: <20220712112210.2852777-1-alvaro.karsz@solid-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jul 2022 14:22:09 +0300 Alvaro Karsz wrote:
> @@ -2594,19 +2600,76 @@ static int virtnet_set_coalesce(struct net_device *dev,
>  {
>  	struct virtnet_info *vi = netdev_priv(dev);
>  	int i, napi_weight;
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

I'd vote for either interpreting the parameters in the new way (real
coalescing) or old way (NAPI update) but not both.

> -	if (ec->tx_max_coalesced_frames > 1 ||
> -	    ec->rx_max_coalesced_frames != 1)
> +	/* If notifications coalesing feature is not negotiated,
> +	 * and we can't update NAPI, return an error
> +	 */
> +	if (!notf_coal && !update_napi)
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
> +				/* If notifications coalescing feature is not negotiated,
> +				 * return an error, otherwise exit without changing
> +				 * the NAPI parameters.
> +				 */
> +				if (!notf_coal)
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

This function got long now, and large parts of it are under if()s
Feels like you'd be better of factoring out the USEC update and the
existing logic into separate functions and calling them as needed.

> @@ -2616,14 +2679,25 @@ static int virtnet_get_coalesce(struct net_device *dev,
>  				struct netlink_ext_ack *extack)
>  {
>  	struct ethtool_coalesce ec_default = {
> -		.cmd = ETHTOOL_GCOALESCE,
> -		.rx_max_coalesced_frames = 1,
> +		.cmd = ETHTOOL_GCOALESCE
>  	};

I think the structure was here for conciseness, since you're not
populating it now just remove it and write to ec directly. 
ec->cmd does not have to be written it's already set.

> +
>  	struct virtnet_info *vi = netdev_priv(dev);
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


> diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
> index 3f55a4215f1..29ced55514d 100644
> --- a/include/uapi/linux/virtio_net.h
> +++ b/include/uapi/linux/virtio_net.h

Is it typical for virtio to add the structures to uAPI even tho the
kernel does not consume them? I presume so, just wanted to flag it.

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D91C928AD76
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 07:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbgJLFCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 01:02:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30896 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726148AbgJLFCv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 01:02:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602478969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6VR+6M+UQjwu5GJv31x62ZjcTl58x8U8h5akrMCl4D0=;
        b=X/bw16I4B95HbicJnWsoZkwwrQC2Nf+fRp/eVQa1VW+CgyCKyp4bfbEhItCaB17TVlPRkf
        ypE/BT69T6uCS49WG6HM4YpzZx/+dEUbRbYP0XuyS+YoHlW7F7oU/br5scrNSybvjta+ZZ
        v4Jz89UrudC9+gGFp/xWHVgqCG+Mz4k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-33-FXyaQoylPrCN0gVC8K4Z1g-1; Mon, 12 Oct 2020 01:02:47 -0400
X-MC-Unique: FXyaQoylPrCN0gVC8K4Z1g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D710B107ACF8;
        Mon, 12 Oct 2020 05:02:44 +0000 (UTC)
Received: from [10.72.13.74] (ovpn-13-74.pek2.redhat.com [10.72.13.74])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0BD3C6198C;
        Mon, 12 Oct 2020 05:02:39 +0000 (UTC)
Subject: Re: [PATCH net-next v3] virtio-net: ethtool configurable RXCSUM
To:     xiangxia.m.yue@gmail.com, mst@redhat.com, willemb@google.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <20201012015820.62042-1-xiangxia.m.yue@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <fb819f6c-6115-e9c0-818e-159e7f7e8189@redhat.com>
Date:   Mon, 12 Oct 2020 13:02:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201012015820.62042-1-xiangxia.m.yue@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/10/12 上午9:58, xiangxia.m.yue@gmail.com wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> Allow user configuring RXCSUM separately with ethtool -K,
> reusing the existing virtnet_set_guest_offloads helper
> that configures RXCSUM for XDP. This is conditional on
> VIRTIO_NET_F_CTRL_GUEST_OFFLOADS.
>
> If Rx checksum is disabled, LRO should also be disabled.
>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>   drivers/net/virtio_net.c | 48 ++++++++++++++++++++++++++++++----------
>   1 file changed, 36 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 21b71148c532..d2d2c4a53cf2 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -68,6 +68,8 @@ static const unsigned long guest_offloads[] = {
>   				(1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
>   				(1ULL << VIRTIO_NET_F_GUEST_UFO))
>   
> +#define GUEST_OFFLOAD_CSUM_MASK (1ULL << VIRTIO_NET_F_GUEST_CSUM)
> +
>   struct virtnet_stat_desc {
>   	char desc[ETH_GSTRING_LEN];
>   	size_t offset;
> @@ -2522,29 +2524,48 @@ static int virtnet_get_phys_port_name(struct net_device *dev, char *buf,
>   	return 0;
>   }
>   
> +static netdev_features_t virtnet_fix_features(struct net_device *netdev,
> +					      netdev_features_t features)
> +{
> +	/* If Rx checksum is disabled, LRO should also be disabled. */
> +	if (!(features & NETIF_F_RXCSUM))
> +		features &= ~NETIF_F_LRO;
> +
> +	return features;
> +}
> +
>   static int virtnet_set_features(struct net_device *dev,
>   				netdev_features_t features)
>   {
>   	struct virtnet_info *vi = netdev_priv(dev);
> -	u64 offloads;
> +	u64 offloads = vi->guest_offloads;
>   	int err;
>   
> -	if ((dev->features ^ features) & NETIF_F_LRO) {
> -		if (vi->xdp_queue_pairs)
> -			return -EBUSY;
> +	/* Don't allow configuration while XDP is active. */
> +	if (vi->xdp_queue_pairs)
> +		return -EBUSY;
>   
> +	if ((dev->features ^ features) & NETIF_F_LRO) {
>   		if (features & NETIF_F_LRO)
> -			offloads = vi->guest_offloads_capable;
> +			offloads |= GUEST_OFFLOAD_LRO_MASK &
> +				    vi->guest_offloads_capable;
>   		else
> -			offloads = vi->guest_offloads_capable &
> -				   ~GUEST_OFFLOAD_LRO_MASK;
> +			offloads &= ~GUEST_OFFLOAD_LRO_MASK;
> +	}
>   
> -		err = virtnet_set_guest_offloads(vi, offloads);
> -		if (err)
> -			return err;
> -		vi->guest_offloads = offloads;
> +	if ((dev->features ^ features) & NETIF_F_RXCSUM) {
> +		if (features & NETIF_F_RXCSUM)
> +			offloads |= GUEST_OFFLOAD_CSUM_MASK &
> +				    vi->guest_offloads_capable;
> +		else
> +			offloads &= ~GUEST_OFFLOAD_CSUM_MASK;
>   	}
>   
> +	err = virtnet_set_guest_offloads(vi, offloads);
> +	if (err)
> +		return err;
> +
> +	vi->guest_offloads = offloads;
>   	return 0;
>   }
>   
> @@ -2563,6 +2584,7 @@ static const struct net_device_ops virtnet_netdev = {
>   	.ndo_features_check	= passthru_features_check,
>   	.ndo_get_phys_port_name	= virtnet_get_phys_port_name,
>   	.ndo_set_features	= virtnet_set_features,
> +	.ndo_fix_features	= virtnet_fix_features,
>   };
>   
>   static void virtnet_config_changed_work(struct work_struct *work)
> @@ -3013,8 +3035,10 @@ static int virtnet_probe(struct virtio_device *vdev)
>   	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
>   	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6))
>   		dev->features |= NETIF_F_LRO;
> -	if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
> +	if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS)) {
> +		dev->hw_features |= NETIF_F_RXCSUM;
>   		dev->hw_features |= NETIF_F_LRO;
> +	}
>   
>   	dev->vlan_features = dev->features;


Acked-by: Jason Wang <jasowang@redhat.com>


>   


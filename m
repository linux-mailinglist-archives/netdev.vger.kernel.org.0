Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29F41314772
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 05:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbhBIESn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 23:18:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36184 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230166AbhBIEPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 23:15:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612844008;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P3Fk0kCQV4hNVnBD5bD0ZZws3eKMcQkl4acgeHcBn5M=;
        b=CC3uU+RAhNmD3VVAd4Yypaa6h6C+Pl3cTiyk1RDzGkk7NCngVLsk2axDr/Vbd5Vj6E/2wo
        bLR1oot08pmmvJ7vnRnsloQ1xcrFvvjHgEvWKsEKZstxTsOc27OZupw8AM8Xxcwj+9G9JE
        VJ0w0nmtqPbdKmr8FFzTeiP9e+A1d7w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-Qn_Gk4L6ObSyGHxhowCBKw-1; Mon, 08 Feb 2021 23:13:24 -0500
X-MC-Unique: Qn_Gk4L6ObSyGHxhowCBKw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 63FBD1005501;
        Tue,  9 Feb 2021 04:13:23 +0000 (UTC)
Received: from [10.72.13.32] (ovpn-13-32.pek2.redhat.com [10.72.13.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C4F860C64;
        Tue,  9 Feb 2021 04:13:16 +0000 (UTC)
Subject: Re: [PATCH RFC v2 2/4] virtio-net: support receive timestamp
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        virtualization@lists.linux-foundation.org
Cc:     netdev@vger.kernel.org, mst@redhat.com, richardcochran@gmail.com,
        Willem de Bruijn <willemb@google.com>
References: <20210208185558.995292-1-willemdebruijn.kernel@gmail.com>
 <20210208185558.995292-3-willemdebruijn.kernel@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <c089cb3e-96cb-b42a-5ce1-d54d298987c4@redhat.com>
Date:   Tue, 9 Feb 2021 12:13:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210208185558.995292-3-willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/9 上午2:55, Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
>
> Add optional PTP hardware rx timestamp offload for virtio-net.
>
> Accurate RTT measurement requires timestamps close to the wire.
> Introduce virtio feature VIRTIO_NET_F_RX_TSTAMP. If negotiated, the
> virtio-net header is expanded with room for a timestamp.
>
> A device may pass receive timestamps for all or some packets. Flag
> VIRTIO_NET_HDR_F_TSTAMP signals whether a timestamp is recorded.
>
> A driver that supports hardware timestamping must also support
> ioctl SIOCSHWTSTAMP. Implement that, as well as information getters
> ioctl SIOCGHWTSTAMP and ethtool get_ts_info (`ethtool -T $DEV`).
>
> The timestamp straddles (virtual) hardware domains. Like PTP, use
> international atomic time (CLOCK_TAI) as global clock base. The driver
> must sync with the device, e.g., through kvm-clock.
>
> Tested:
>    guest: ./timestamping eth0 \
>            SOF_TIMESTAMPING_RAW_HARDWARE \
>            SOF_TIMESTAMPING_RX_HARDWARE
>    host: nc -4 -u 192.168.1.1 319
>
> Changes RFC -> RFCv2
>    - rename virtio_net_hdr_v12 to virtio_net_hdr_hash_ts
>    - add ethtool .get_ts_info to query capabilities
>    - add ioctl SIOC[GS]HWTSTAMP to configure feature
>    - add vi->enable_rx_tstamp to store configuration
>    - convert virtioXX_to_cpu to leXX_to_cpu
>    - convert reserved to __u32
>
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> ---
>   drivers/net/virtio_net.c        | 113 +++++++++++++++++++++++++++++++-
>   include/uapi/linux/virtio_net.h |  13 ++++
>   2 files changed, 124 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 7f822b2a5205..ac44c5efa0bc 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -204,6 +204,12 @@ struct virtnet_info {
>   	/* Driver will pass tx path info to the device */
>   	bool has_tx_hash;
>   
> +	/* Device can pass CLOCK_TAI receive time to the driver */
> +	bool has_rx_tstamp;
> +
> +	/* Device will pass rx timestamp. Requires has_rx_tstamp */
> +	bool enable_rx_tstamp;
> +
>   	/* Has control virtqueue */
>   	bool has_cvq;
>   
> @@ -292,6 +298,13 @@ static inline struct virtio_net_hdr_mrg_rxbuf *skb_vnet_hdr(struct sk_buff *skb)
>   	return (struct virtio_net_hdr_mrg_rxbuf *)skb->cb;
>   }
>   
> +static inline struct virtio_net_hdr_hash_ts *skb_vnet_hdr_ht(struct sk_buff *skb)
> +{
> +	BUILD_BUG_ON(sizeof(struct virtio_net_hdr_hash_ts) > sizeof(skb->cb));
> +
> +	return (void *)skb->cb;
> +}
> +
>   /*
>    * private is used to chain pages for big packets, put the whole
>    * most recent used list in the beginning for reuse
> @@ -1030,6 +1043,19 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>   	return NULL;
>   }
>   
> +static inline void virtnet_record_rx_tstamp(const struct virtnet_info *vi,
> +					    struct sk_buff *skb)
> +{
> +	const struct virtio_net_hdr_hash_ts *h = skb_vnet_hdr_ht(skb);
> +
> +	if (h->hdr.flags & VIRTIO_NET_HDR_F_TSTAMP &&
> +	    vi->enable_rx_tstamp) {
> +		u64 ts = le64_to_cpu(h->tstamp);
> +
> +		skb_hwtstamps(skb)->hwtstamp = ns_to_ktime(ts);
> +	}
> +}
> +
>   static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
>   			void *buf, unsigned int len, void **ctx,
>   			unsigned int *xdp_xmit,
> @@ -1076,6 +1102,7 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
>   		goto frame_err;
>   	}
>   
> +	virtnet_record_rx_tstamp(vi, skb);
>   	skb_record_rx_queue(skb, vq2rxq(rq->vq));
>   	skb->protocol = eth_type_trans(skb, dev);
>   	pr_debug("Receiving skb proto 0x%04x len %i type %i\n",
> @@ -2263,6 +2290,28 @@ static int virtnet_get_coalesce(struct net_device *dev,
>   	return 0;
>   }
>   
> +static int virtnet_get_ts_info(struct net_device *dev,
> +			       struct ethtool_ts_info *info)
> +{
> +	struct virtnet_info *vi = netdev_priv(dev);
> +
> +	/* setup default software timestamp */
> +	ethtool_op_get_ts_info(dev, info);
> +
> +	/* return rx capabilities (which may differ from current enable) */
> +	if (vi->has_rx_tstamp) {
> +		info->so_timestamping |= SOF_TIMESTAMPING_RX_HARDWARE |
> +					 SOF_TIMESTAMPING_RAW_HARDWARE;
> +		info->rx_filters = HWTSTAMP_FILTER_ALL;
> +	} else {
> +		info->rx_filters = HWTSTAMP_FILTER_NONE;
> +	}
> +
> +	info->tx_types = HWTSTAMP_TX_OFF;
> +
> +	return 0;
> +}
> +
>   static void virtnet_init_settings(struct net_device *dev)
>   {
>   	struct virtnet_info *vi = netdev_priv(dev);
> @@ -2300,7 +2349,7 @@ static const struct ethtool_ops virtnet_ethtool_ops = {
>   	.get_ethtool_stats = virtnet_get_ethtool_stats,
>   	.set_channels = virtnet_set_channels,
>   	.get_channels = virtnet_get_channels,
> -	.get_ts_info = ethtool_op_get_ts_info,
> +	.get_ts_info = virtnet_get_ts_info,
>   	.get_link_ksettings = virtnet_get_link_ksettings,
>   	.set_link_ksettings = virtnet_set_link_ksettings,
>   	.set_coalesce = virtnet_set_coalesce,
> @@ -2558,6 +2607,60 @@ static int virtnet_set_features(struct net_device *dev,
>   	return 0;
>   }
>   
> +static int virtnet_ioctl_set_hwtstamp(struct net_device *dev, struct ifreq *ifr)
> +{
> +	struct virtnet_info *vi = netdev_priv(dev);
> +	struct hwtstamp_config tsconf;
> +
> +	if (copy_from_user(&tsconf, ifr->ifr_data, sizeof(tsconf)))
> +		return -EFAULT;
> +	if (tsconf.flags)
> +		return -EINVAL;
> +	if (tsconf.tx_type != HWTSTAMP_TX_OFF)
> +		return -ERANGE;
> +	if (tsconf.rx_filter != HWTSTAMP_FILTER_NONE &&
> +	    tsconf.rx_filter != HWTSTAMP_FILTER_ALL)
> +		tsconf.rx_filter = HWTSTAMP_FILTER_ALL;
> +
> +	if (!vi->has_rx_tstamp)
> +		tsconf.rx_filter = HWTSTAMP_FILTER_NONE;
> +	else
> +		vi->enable_rx_tstamp = tsconf.rx_filter == HWTSTAMP_FILTER_ALL;
> +
> +	if (copy_to_user(ifr->ifr_data, &tsconf, sizeof(tsconf)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +static int virtnet_ioctl_get_hwtstamp(struct net_device *dev, struct ifreq *ifr)
> +{
> +	struct virtnet_info *vi = netdev_priv(dev);
> +	struct hwtstamp_config tsconf;
> +
> +	tsconf.flags = 0;
> +	tsconf.rx_filter = vi->enable_rx_tstamp ? HWTSTAMP_FILTER_ALL :
> +						  HWTSTAMP_FILTER_NONE;
> +	tsconf.tx_type = HWTSTAMP_TX_OFF;
> +
> +	if (copy_to_user(ifr->ifr_data, &tsconf, sizeof(tsconf)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
> +static int virtnet_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
> +{
> +	switch (cmd) {
> +	case SIOCSHWTSTAMP:
> +		return virtnet_ioctl_set_hwtstamp(dev, ifr);
> +
> +	case SIOCGHWTSTAMP:
> +		return virtnet_ioctl_get_hwtstamp(dev, ifr);
> +	}
> +	return -EOPNOTSUPP;
> +}
> +
>   static const struct net_device_ops virtnet_netdev = {
>   	.ndo_open            = virtnet_open,
>   	.ndo_stop   	     = virtnet_close,
> @@ -2573,6 +2676,7 @@ static const struct net_device_ops virtnet_netdev = {
>   	.ndo_features_check	= passthru_features_check,
>   	.ndo_get_phys_port_name	= virtnet_get_phys_port_name,
>   	.ndo_set_features	= virtnet_set_features,
> +	.ndo_do_ioctl		= virtnet_ioctl,
>   };
>   
>   static void virtnet_config_changed_work(struct work_struct *work)
> @@ -3069,6 +3173,11 @@ static int virtnet_probe(struct virtio_device *vdev)
>   		vi->hdr_len = sizeof(struct virtio_net_hdr_v1_hash);
>   	}
>   
> +	if (virtio_has_feature(vdev, VIRTIO_NET_F_RX_TSTAMP)) {
> +		vi->has_rx_tstamp = true;
> +		vi->hdr_len = sizeof(struct virtio_net_hdr_hash_ts);


Does this mean even if the device doesn't pass timestamp, the header 
still contains the timestamp fields.


> +	}
> +
>   	if (virtio_has_feature(vdev, VIRTIO_F_ANY_LAYOUT) ||
>   	    virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
>   		vi->any_header_sg = true;
> @@ -3260,7 +3369,7 @@ static struct virtio_device_id id_table[] = {
>   	VIRTIO_NET_F_CTRL_MAC_ADDR, \
>   	VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
>   	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
> -	VIRTIO_NET_F_TX_HASH
> +	VIRTIO_NET_F_TX_HASH, VIRTIO_NET_F_RX_TSTAMP
>   
>   static unsigned int features[] = {
>   	VIRTNET_FEATURES,
> diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
> index 273d43c35f59..a5c84410cf92 100644
> --- a/include/uapi/linux/virtio_net.h
> +++ b/include/uapi/linux/virtio_net.h
> @@ -57,6 +57,7 @@
>   					 * Steering */
>   #define VIRTIO_NET_F_CTRL_MAC_ADDR 23	/* Set MAC address */
>   
> +#define VIRTIO_NET_F_RX_TSTAMP	  55	/* Device sends TAI receive time */
>   #define VIRTIO_NET_F_TX_HASH	  56	/* Driver sends hash report */
>   #define VIRTIO_NET_F_HASH_REPORT  57	/* Supports hash report */
>   #define VIRTIO_NET_F_RSS	  60	/* Supports RSS RX steering */
> @@ -126,6 +127,7 @@ struct virtio_net_hdr_v1 {
>   #define VIRTIO_NET_HDR_F_NEEDS_CSUM	1	/* Use csum_start, csum_offset */
>   #define VIRTIO_NET_HDR_F_DATA_VALID	2	/* Csum is valid */
>   #define VIRTIO_NET_HDR_F_RSC_INFO	4	/* rsc info in csum_ fields */
> +#define VIRTIO_NET_HDR_F_TSTAMP		8	/* timestamp is recorded */
>   	__u8 flags;
>   #define VIRTIO_NET_HDR_GSO_NONE		0	/* Not a GSO frame */
>   #define VIRTIO_NET_HDR_GSO_TCPV4	1	/* GSO frame, IPv4 TCP (TSO) */
> @@ -181,6 +183,17 @@ struct virtio_net_hdr_v1_hash {
>   	};
>   };
>   
> +struct virtio_net_hdr_hash_ts {
> +	struct virtio_net_hdr_v1 hdr;
> +	struct {
> +		__le32 value;
> +		__le16 report;
> +		__le16 flow_state;
> +	} hash;


Any reason for not embedding structure virtio_net_hdr_v1_hash?

Thanks


> +	__u32 reserved;
> +	__le64 tstamp;
> +};
> +
>   #ifndef VIRTIO_NET_NO_LEGACY
>   /* This header comes first in the scatter-gather list.
>    * For legacy virtio, if VIRTIO_F_ANY_LAYOUT is not negotiated, it must


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A68066892D1
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 09:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbjBCIyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 03:54:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbjBCIyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 03:54:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 755821F4B9
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 00:53:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675414400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BXd/CWEjTAyESsDjdoE/IytKlBBoevwUsfZ/7cXj91E=;
        b=h96GpyPemEm2lL8LiZa1wtYWQm06ViYr3JdBpFhjkXohVnFdvGQmz/pKenhYpzY65vg9hK
        rqUcEFVyysYPGTbyMXLtKmNF6o/Qqhlk6vLMU2eB86LCfEtoJhWVm5O/HDKhj55MvKM2Ff
        Cq2BRUvaDZ4OydeGNzYUnNsKJ9OVJQU=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-479-77j0vzfaNaCIR5Yo2K38gQ-1; Fri, 03 Feb 2023 03:53:18 -0500
X-MC-Unique: 77j0vzfaNaCIR5Yo2K38gQ-1
Received: by mail-ed1-f71.google.com with SMTP id s26-20020a056402037a00b004a25c2875d6so3102606edw.8
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 00:53:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BXd/CWEjTAyESsDjdoE/IytKlBBoevwUsfZ/7cXj91E=;
        b=2+ZXaZf4hHE9yQQrZo3wZzwZk4QVe/8ia0Kelds4Mi4gs/uhkTZkFbp1AgCIP43tCE
         I3Djd6/HeNU0WfdanbaotlZQ3gc/f5ZpwnK4YHY4WQfpbHsSI+KfQz5QsG/9Kx7INwxn
         9EiUePXv7RkaydOOJVTyIT9+5TKgLXYpXgTmWnHmO4az0VI4Av/3q8EYuDjTCqldvU1M
         71SM9n332IxwRlTneNvVoPS6wYjkaELLrf3ZOi4bX5zHX4r+R1o34Fi36Qme+sShCH1J
         gVUTfUiEkIfOLo28BLj/CqN4ybV1AR/hLQgbyBl0ZFvDBOTlj5tLV7EiboUxk+q8lyHu
         oi8Q==
X-Gm-Message-State: AO0yUKWAP4zVSYSO3ROiLN/h87OnOtF91Be6jpC3Jb4EGScdUK2hOpF5
        x2oIXmDIJshfuKW3TXYBZIW0KEgjuE4JmijhIdNALV5uZ7RnnwBOneGAyhYSZsCng5Hd9TEXNe9
        v+0RV67Dh37l6yb+K
X-Received: by 2002:a05:6402:144:b0:4a0:e10d:fc0b with SMTP id s4-20020a056402014400b004a0e10dfc0bmr8925143edu.35.1675414397584;
        Fri, 03 Feb 2023 00:53:17 -0800 (PST)
X-Google-Smtp-Source: AK7set/9z5hqHCkudACs3CB9K2EkpCtRhHVfr/BZbJ/QPV/CJeOiBwvFRFLAkllHu2rL1Eqp5xOM6w==
X-Received: by 2002:a05:6402:144:b0:4a0:e10d:fc0b with SMTP id s4-20020a056402014400b004a0e10dfc0bmr8925118edu.35.1675414397319;
        Fri, 03 Feb 2023 00:53:17 -0800 (PST)
Received: from redhat.com ([2.52.156.122])
        by smtp.gmail.com with ESMTPSA id u19-20020a170906951300b008775d59dc80sm1051904ejx.80.2023.02.03.00.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 00:53:16 -0800 (PST)
Date:   Fri, 3 Feb 2023 03:53:12 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: Re: [PATCH 15/33] virtio_net: move to virtio_net.h
Message-ID: <20230203035028-mutt-send-email-mst@kernel.org>
References: <20230202110058.130695-1-xuanzhuo@linux.alibaba.com>
 <20230202110058.130695-16-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202110058.130695-16-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 07:00:40PM +0800, Xuan Zhuo wrote:
> Move some structure definitions and inline functions into the
> virtio_net.h file.
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>  drivers/net/virtio/main.c       | 247 +----------------------------
>  drivers/net/virtio/virtio_net.h | 265 ++++++++++++++++++++++++++++++++
>  2 files changed, 267 insertions(+), 245 deletions(-)
>  create mode 100644 drivers/net/virtio/virtio_net.h
> 
> diff --git a/drivers/net/virtio/main.c b/drivers/net/virtio/main.c
> index eb7f00194b5c..5683cb576474 100644
> --- a/drivers/net/virtio/main.c
> +++ b/drivers/net/virtio/main.c
> @@ -4,24 +4,8 @@
>   * Copyright 2007 Rusty Russell <rusty@rustcorp.com.au> IBM Corporation
>   */
>  //#define DEBUG
> -#include <linux/netdevice.h>
> -#include <linux/etherdevice.h>
> -#include <linux/ethtool.h>
> -#include <linux/module.h>
> -#include <linux/virtio.h>
> -#include <linux/virtio_net.h>
> -#include <linux/bpf.h>
> -#include <linux/bpf_trace.h>
> -#include <linux/scatterlist.h>
> -#include <linux/if_vlan.h>
> -#include <linux/slab.h>
> -#include <linux/cpu.h>
> -#include <linux/average.h>
> -#include <linux/filter.h>
> -#include <linux/kernel.h>
> -#include <net/route.h>
> -#include <net/xdp.h>
> -#include <net/net_failover.h>
> +
> +#include "virtio_net.h"
>  
>  static int napi_weight = NAPI_POLL_WEIGHT;
>  module_param(napi_weight, int, 0444);


You should only move the headers that are actually needed not
everything.


> @@ -44,15 +28,6 @@ module_param(napi_tx, bool, 0644);
>  #define VIRTIO_XDP_TX		BIT(0)
>  #define VIRTIO_XDP_REDIR	BIT(1)
>  
> -#define VIRTIO_XDP_FLAG	BIT(0)
> -
> -/* RX packet size EWMA. The average packet size is used to determine the packet
> - * buffer size when refilling RX rings. As the entire RX ring may be refilled
> - * at once, the weight is chosen so that the EWMA will be insensitive to short-
> - * term, transient changes in packet size.
> - */
> -DECLARE_EWMA(pkt_len, 0, 64)
> -
>  #define VIRTNET_DRIVER_VERSION "1.0.0"
>  
>  static const unsigned long guest_offloads[] = {
> @@ -72,36 +47,6 @@ static const unsigned long guest_offloads[] = {
>  				(1ULL << VIRTIO_NET_F_GUEST_USO4) | \
>  				(1ULL << VIRTIO_NET_F_GUEST_USO6))
>  
> -struct virtnet_stat_desc {
> -	char desc[ETH_GSTRING_LEN];
> -	size_t offset;
> -};
> -
> -struct virtnet_sq_stats {
> -	struct u64_stats_sync syncp;
> -	u64 packets;
> -	u64 bytes;
> -	u64 xdp_tx;
> -	u64 xdp_tx_drops;
> -	u64 kicks;
> -	u64 tx_timeouts;
> -};
> -
> -struct virtnet_rq_stats {
> -	struct u64_stats_sync syncp;
> -	u64 packets;
> -	u64 bytes;
> -	u64 drops;
> -	u64 xdp_packets;
> -	u64 xdp_tx;
> -	u64 xdp_redirects;
> -	u64 xdp_drops;
> -	u64 kicks;
> -};
> -
> -#define VIRTNET_SQ_STAT(m)	offsetof(struct virtnet_sq_stats, m)
> -#define VIRTNET_RQ_STAT(m)	offsetof(struct virtnet_rq_stats, m)
> -
>  static const struct virtnet_stat_desc virtnet_sq_stats_desc[] = {
>  	{ "packets",		VIRTNET_SQ_STAT(packets) },
>  	{ "bytes",		VIRTNET_SQ_STAT(bytes) },
> @@ -125,57 +70,6 @@ static const struct virtnet_stat_desc virtnet_rq_stats_desc[] = {
>  #define VIRTNET_SQ_STATS_LEN	ARRAY_SIZE(virtnet_sq_stats_desc)
>  #define VIRTNET_RQ_STATS_LEN	ARRAY_SIZE(virtnet_rq_stats_desc)
>  
> -/* Internal representation of a send virtqueue */
> -struct send_queue {
> -	/* Virtqueue associated with this send _queue */
> -	struct virtqueue *vq;
> -
> -	/* TX: fragments + linear part + virtio header */
> -	struct scatterlist sg[MAX_SKB_FRAGS + 2];
> -
> -	/* Name of the send queue: output.$index */
> -	char name[16];
> -
> -	struct virtnet_sq_stats stats;
> -
> -	struct napi_struct napi;
> -
> -	/* Record whether sq is in reset state. */
> -	bool reset;
> -};
> -
> -/* Internal representation of a receive virtqueue */
> -struct receive_queue {
> -	/* Virtqueue associated with this receive_queue */
> -	struct virtqueue *vq;
> -
> -	struct napi_struct napi;
> -
> -	struct bpf_prog __rcu *xdp_prog;
> -
> -	struct virtnet_rq_stats stats;
> -
> -	/* Chain pages by the private ptr. */
> -	struct page *pages;
> -
> -	/* Average packet length for mergeable receive buffers. */
> -	struct ewma_pkt_len mrg_avg_pkt_len;
> -
> -	/* Page frag for packet buffer allocation. */
> -	struct page_frag alloc_frag;
> -
> -	/* RX: fragments + linear part + virtio header */
> -	struct scatterlist sg[MAX_SKB_FRAGS + 2];
> -
> -	/* Min single buffer size for mergeable buffers case. */
> -	unsigned int min_buf_len;
> -
> -	/* Name of this receive queue: input.$index */
> -	char name[16];
> -
> -	struct xdp_rxq_info xdp_rxq;
> -};
> -
>  /* This structure can contain rss message with maximum settings for indirection table and keysize
>   * Note, that default structure that describes RSS configuration virtio_net_rss_config
>   * contains same info but can't handle table values.
> @@ -206,90 +100,6 @@ struct control_buf {
>  	struct virtio_net_ctrl_rss rss;
>  };
>  
> -struct virtnet_info {
> -	struct virtio_device *vdev;
> -	struct virtqueue *cvq;
> -	struct net_device *dev;
> -	struct send_queue *sq;
> -	struct receive_queue *rq;
> -	unsigned int status;
> -
> -	/* Max # of queue pairs supported by the device */
> -	u16 max_queue_pairs;
> -
> -	/* # of queue pairs currently used by the driver */
> -	u16 curr_queue_pairs;
> -
> -	/* # of XDP queue pairs currently used by the driver */
> -	u16 xdp_queue_pairs;
> -
> -	/* xdp_queue_pairs may be 0, when xdp is already loaded. So add this. */
> -	bool xdp_enabled;
> -
> -	/* I like... big packets and I cannot lie! */
> -	bool big_packets;
> -
> -	/* number of sg entries allocated for big packets */
> -	unsigned int big_packets_num_skbfrags;
> -
> -	/* Host will merge rx buffers for big packets (shake it! shake it!) */
> -	bool mergeable_rx_bufs;
> -
> -	/* Host supports rss and/or hash report */
> -	bool has_rss;
> -	bool has_rss_hash_report;
> -	u8 rss_key_size;
> -	u16 rss_indir_table_size;
> -	u32 rss_hash_types_supported;
> -	u32 rss_hash_types_saved;
> -
> -	/* Has control virtqueue */
> -	bool has_cvq;
> -
> -	/* Host can handle any s/g split between our header and packet data */
> -	bool any_header_sg;
> -
> -	/* Packet virtio header size */
> -	u8 hdr_len;
> -
> -	/* Work struct for delayed refilling if we run low on memory. */
> -	struct delayed_work refill;
> -
> -	/* Is delayed refill enabled? */
> -	bool refill_enabled;
> -
> -	/* The lock to synchronize the access to refill_enabled */
> -	spinlock_t refill_lock;
> -
> -	/* Work struct for config space updates */
> -	struct work_struct config_work;
> -
> -	/* Does the affinity hint is set for virtqueues? */
> -	bool affinity_hint_set;
> -
> -	/* CPU hotplug instances for online & dead */
> -	struct hlist_node node;
> -	struct hlist_node node_dead;
> -
> -	struct control_buf *ctrl;
> -
> -	/* Ethtool settings */
> -	u8 duplex;
> -	u32 speed;
> -
> -	/* Interrupt coalescing settings */
> -	u32 tx_usecs;
> -	u32 rx_usecs;
> -	u32 tx_max_packets;
> -	u32 rx_max_packets;
> -
> -	unsigned long guest_offloads;
> -	unsigned long guest_offloads_capable;
> -
> -	/* failover when STANDBY feature enabled */
> -	struct failover *failover;
> -};
> -
>  struct padded_vnet_hdr {
>  	struct virtio_net_hdr_v1_hash hdr;
>  	/*
> @@ -303,45 +113,11 @@ struct padded_vnet_hdr {
>  static void virtnet_rq_free_unused_buf(struct virtqueue *vq, void *buf);
>  static void virtnet_sq_free_unused_buf(struct virtqueue *vq, void *buf);
>  
> -static bool is_xdp_frame(void *ptr)
> -{
> -	return (unsigned long)ptr & VIRTIO_XDP_FLAG;
> -}
> -
>  static void *xdp_to_ptr(struct xdp_frame *ptr)
>  {
>  	return (void *)((unsigned long)ptr | VIRTIO_XDP_FLAG);
>  }
>  
> -static struct xdp_frame *ptr_to_xdp(void *ptr)
> -{
> -	return (struct xdp_frame *)((unsigned long)ptr & ~VIRTIO_XDP_FLAG);
> -}
> -
> -static void __free_old_xmit(struct send_queue *sq, bool in_napi,
> -			    struct virtnet_sq_stats *stats)
> -{
> -	unsigned int len;
> -	void *ptr;
> -
> -	while ((ptr = virtqueue_get_buf(sq->vq, &len)) != NULL) {
> -		if (!is_xdp_frame(ptr)) {
> -			struct sk_buff *skb = ptr;
> -
> -			pr_debug("Sent skb %p\n", skb);
> -
> -			stats->bytes += skb->len;
> -			napi_consume_skb(skb, in_napi);
> -		} else {
> -			struct xdp_frame *frame = ptr_to_xdp(ptr);
> -
> -			stats->bytes += xdp_get_frame_len(frame);
> -			xdp_return_frame(frame);
> -		}
> -		stats->packets++;
> -	}
> -}
> -
>  /* Converting between virtqueue no. and kernel tx/rx queue no.
>   * 0:rx0 1:tx0 2:rx1 3:tx1 ... 2N:rxN 2N+1:txN 2N+2:cvq
>   */
> @@ -411,15 +187,6 @@ static void disable_delayed_refill(struct virtnet_info *vi)
>  	spin_unlock_bh(&vi->refill_lock);
>  }
>  
> -static void virtqueue_napi_schedule(struct napi_struct *napi,
> -				    struct virtqueue *vq)
> -{
> -	if (napi_schedule_prep(napi)) {
> -		virtqueue_disable_cb(vq);
> -		__napi_schedule(napi);
> -	}
> -}
> -
>  static void virtqueue_napi_complete(struct napi_struct *napi,
>  				    struct virtqueue *vq, int processed)
>  {
> @@ -1740,16 +1507,6 @@ static void free_old_xmit(struct send_queue *sq, bool in_napi)
>  	u64_stats_update_end(&sq->stats.syncp);
>  }
>  
> -static bool is_xdp_raw_buffer_queue(struct virtnet_info *vi, int q)
> -{
> -	if (q < (vi->curr_queue_pairs - vi->xdp_queue_pairs))
> -		return false;
> -	else if (q < vi->curr_queue_pairs)
> -		return true;
> -	else
> -		return false;
> -}
> -
>  static void virtnet_poll_cleantx(struct receive_queue *rq)
>  {
>  	struct virtnet_info *vi = rq->vq->vdev->priv;
> diff --git a/drivers/net/virtio/virtio_net.h b/drivers/net/virtio/virtio_net.h
> new file mode 100644
> index 000000000000..8bf31429ae28
> --- /dev/null
> +++ b/drivers/net/virtio/virtio_net.h
> @@ -0,0 +1,265 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +
> +#ifndef __VIRTIO_NET_H__
> +#define __VIRTIO_NET_H__
> +#include <linux/netdevice.h>
> +#include <linux/etherdevice.h>
> +#include <linux/ethtool.h>
> +#include <linux/module.h>
> +#include <linux/virtio.h>
> +#include <linux/virtio_net.h>
> +#include <linux/bpf.h>
> +#include <linux/bpf_trace.h>
> +#include <linux/scatterlist.h>
> +#include <linux/if_vlan.h>
> +#include <linux/slab.h>
> +#include <linux/cpu.h>
> +#include <linux/average.h>
> +#include <linux/filter.h>
> +#include <linux/kernel.h>
> +#include <net/route.h>
> +#include <net/xdp.h>
> +#include <net/net_failover.h>
> +#include <net/xdp_sock_drv.h>
> +
> +#define VIRTIO_XDP_FLAG	BIT(0)
> +
> +struct virtnet_info {
> +	struct virtio_device *vdev;
> +	struct virtqueue *cvq;
> +	struct net_device *dev;
> +	struct send_queue *sq;
> +	struct receive_queue *rq;
> +	unsigned int status;
> +
> +	/* Max # of queue pairs supported by the device */
> +	u16 max_queue_pairs;
> +
> +	/* # of queue pairs currently used by the driver */
> +	u16 curr_queue_pairs;
> +
> +	/* # of XDP queue pairs currently used by the driver */
> +	u16 xdp_queue_pairs;
> +
> +	/* xdp_queue_pairs may be 0, when xdp is already loaded. So add this. */
> +	bool xdp_enabled;
> +
> +	/* I like... big packets and I cannot lie! */
> +	bool big_packets;
> +
> +	/* number of sg entries allocated for big packets */
> +	unsigned int big_packets_num_skbfrags;
> +
> +	/* Host will merge rx buffers for big packets (shake it! shake it!) */
> +	bool mergeable_rx_bufs;
> +
> +	/* Host supports rss and/or hash report */
> +	bool has_rss;
> +	bool has_rss_hash_report;
> +	u8 rss_key_size;
> +	u16 rss_indir_table_size;
> +	u32 rss_hash_types_supported;
> +	u32 rss_hash_types_saved;
> +
> +	/* Has control virtqueue */
> +	bool has_cvq;
> +
> +	/* Host can handle any s/g split between our header and packet data */
> +	bool any_header_sg;
> +
> +	/* Packet virtio header size */
> +	u8 hdr_len;
> +
> +	/* Work struct for delayed refilling if we run low on memory. */
> +	struct delayed_work refill;
> +
> +	/* Is delayed refill enabled? */
> +	bool refill_enabled;
> +
> +	/* The lock to synchronize the access to refill_enabled */
> +	spinlock_t refill_lock;
> +
> +	/* Work struct for config space updates */
> +	struct work_struct config_work;
> +
> +	/* Does the affinity hint is set for virtqueues? */
> +	bool affinity_hint_set;
> +
> +	/* CPU hotplug instances for online & dead */
> +	struct hlist_node node;
> +	struct hlist_node node_dead;
> +
> +	struct control_buf *ctrl;
> +
> +	/* Ethtool settings */
> +	u8 duplex;
> +	u32 speed;
> +
> +	/* Interrupt coalescing settings */
> +	u32 tx_usecs;
> +	u32 rx_usecs;
> +	u32 tx_max_packets;
> +	u32 rx_max_packets;
> +
> +	unsigned long guest_offloads;
> +	unsigned long guest_offloads_capable;
> +
> +	/* failover when STANDBY feature enabled */
> +	struct failover *failover;
> +};
> +
> +/* RX packet size EWMA. The average packet size is used to determine the packet
> + * buffer size when refilling RX rings. As the entire RX ring may be refilled
> + * at once, the weight is chosen so that the EWMA will be insensitive to short-
> + * term, transient changes in packet size.
> + */
> +DECLARE_EWMA(pkt_len, 0, 64)
> +
> +struct virtnet_stat_desc {
> +	char desc[ETH_GSTRING_LEN];
> +	size_t offset;
> +};
> +
> +struct virtnet_sq_stats {
> +	struct u64_stats_sync syncp;
> +	u64 packets;
> +	u64 bytes;
> +	u64 xdp_tx;
> +	u64 xdp_tx_drops;
> +	u64 kicks;
> +	u64 tx_timeouts;
> +};
> +
> +struct virtnet_rq_stats {
> +	struct u64_stats_sync syncp;
> +	u64 packets;
> +	u64 bytes;
> +	u64 drops;
> +	u64 xdp_packets;
> +	u64 xdp_tx;
> +	u64 xdp_redirects;
> +	u64 xdp_drops;
> +	u64 kicks;
> +};
> +
> +#define VIRTNET_SQ_STAT(m)	offsetof(struct virtnet_sq_stats, m)
> +#define VIRTNET_RQ_STAT(m)	offsetof(struct virtnet_rq_stats, m)
> +
> +/* Internal representation of a send virtqueue */
> +struct send_queue {
> +	/* Virtqueue associated with this send _queue */
> +	struct virtqueue *vq;
> +
> +	/* TX: fragments + linear part + virtio header */
> +	struct scatterlist sg[MAX_SKB_FRAGS + 2];
> +
> +	/* Name of the send queue: output.$index */
> +	char name[16];
> +
> +	struct virtnet_sq_stats stats;
> +
> +	struct napi_struct napi;
> +
> +	/* Record whether sq is in reset state. */
> +	bool reset;
> +};
> +
> +/* Internal representation of a receive virtqueue */
> +struct receive_queue {
> +	/* Virtqueue associated with this receive_queue */
> +	struct virtqueue *vq;
> +
> +	struct napi_struct napi;
> +
> +	struct bpf_prog __rcu *xdp_prog;
> +
> +	struct virtnet_rq_stats stats;
> +
> +	/* Chain pages by the private ptr. */
> +	struct page *pages;
> +
> +	/* Average packet length for mergeable receive buffers. */
> +	struct ewma_pkt_len mrg_avg_pkt_len;
> +
> +	/* Page frag for packet buffer allocation. */
> +	struct page_frag alloc_frag;
> +
> +	/* RX: fragments + linear part + virtio header */
> +	struct scatterlist sg[MAX_SKB_FRAGS + 2];
> +
> +	/* Min single buffer size for mergeable buffers case. */
> +	unsigned int min_buf_len;
> +
> +	/* Name of this receive queue: input.$index */
> +	char name[16];
> +
> +	struct xdp_rxq_info xdp_rxq;
> +};
> +
> +static inline bool is_xdp_raw_buffer_queue(struct virtnet_info *vi, int q)
> +{
> +	if (q < (vi->curr_queue_pairs - vi->xdp_queue_pairs))
> +		return false;
> +	else if (q < vi->curr_queue_pairs)
> +		return true;
> +	else
> +		return false;
> +}
> +
> +static inline void virtnet_return_xdp_frame(struct send_queue *sq,
> +					    struct xdp_frame *frame)
> +{
> +	struct virtnet_info *vi = sq->vq->vdev->priv;
> +	dma_addr_t *p_addr, addr;
> +
> +	p_addr = frame->data - sizeof(*p_addr);
> +	addr = *p_addr;
> +
> +	virtio_dma_unmap(&vi->vdev->dev, addr, frame->len, DMA_TO_DEVICE);
> +
> +	xdp_return_frame(frame);
> +}
> +
> +static inline void virtqueue_napi_schedule(struct napi_struct *napi,
> +					   struct virtqueue *vq)
> +{
> +	if (napi_schedule_prep(napi)) {
> +		virtqueue_disable_cb(vq);
> +		__napi_schedule(napi);
> +	}
> +}
> +
> +static inline bool is_xdp_frame(void *ptr)
> +{
> +	return (unsigned long)ptr & VIRTIO_XDP_FLAG;
> +}
> +
> +static struct xdp_frame *ptr_to_xdp(void *ptr)
> +{
> +	return (struct xdp_frame *)((unsigned long)ptr & ~VIRTIO_XDP_FLAG);
> +}
> +
> +static void __free_old_xmit(struct send_queue *sq, bool in_napi,
> +			    struct virtnet_sq_stats *stats)
> +{
> +	unsigned int len;
> +	void *ptr;
> +
> +	while ((ptr = virtqueue_get_buf(sq->vq, &len)) != NULL) {
> +		if (!is_xdp_frame(ptr)) {
> +			struct sk_buff *skb = ptr;
> +
> +			pr_debug("Sent skb %p\n", skb);
> +
> +			stats->bytes += skb->len;
> +			napi_consume_skb(skb, in_napi);
> +		} else {
> +			struct xdp_frame *frame = ptr_to_xdp(ptr);
> +
> +			stats->bytes += xdp_get_frame_len(frame);
> +			xdp_return_frame(frame);
> +		}
> +		stats->packets++;
> +	}
> +}
> +#endif

All these APIs not prefixed with virtnet were ok as internal
static functions. No longer ok in a header.


> -- 
> 2.32.0.3.g01195cf9f


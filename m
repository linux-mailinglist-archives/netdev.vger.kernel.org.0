Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC135A7E59
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 15:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbiHaNMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 09:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiHaNMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 09:12:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9909AC275E
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 06:12:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661951525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z/T15etvI12VltqvvTSCKLwx0EjkTTPcjNU7x17rAxU=;
        b=MwHvhmVqoqEsFKyQax35aydP5DGdePI23G/L2SSY50ToujhyDjWQCakvPA6v64lk1qiJfe
        UwBrr8NSuYo0mX6jhCROlz0KgGTne7AXjAGEpbblbEdkzdyS4952D4+yuQcwQRXmpuFOll
        Ztm9I1+CD8V6ChSq6S9YzXiW4e0hLUE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-127-O_LBQ4LyPNmwhSifMx5Qnw-1; Wed, 31 Aug 2022 09:12:01 -0400
X-MC-Unique: O_LBQ4LyPNmwhSifMx5Qnw-1
Received: by mail-wr1-f72.google.com with SMTP id m21-20020adfa3d5000000b00226d1478469so2169414wrb.21
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 06:12:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=z/T15etvI12VltqvvTSCKLwx0EjkTTPcjNU7x17rAxU=;
        b=Nu2ZbqN2FarZ5vvZ1DP8YTOYUN21pycpmhBFaoeOIsu5uDQil+pFXODbci8Igr6n77
         gwG80IDszaDoC+gv4ZCqs5CQIO61DxlFefwaoGSvKkrI5Uxj+Oqq18ExpvXe6z+iV64C
         q/XRltvP8Fn2GSwPhSfESqA2F0ga8EQT0TrvvokCbxWh3qAxJSTfm9C22K6qQtvG7XPD
         uPl7pCvO1C5Zx3gT3K9A8do6Dc2tRtokSqi18KXH4Qcoe+6jYTOKHzF6Qn8hdCD3mkCI
         OksnrZaJc2vI4ddlH45YBExp+gWmPhr8nJ6VL3gjl2mLukBcZ5YKz9aqKjLg9nCOLE6n
         DxwQ==
X-Gm-Message-State: ACgBeo3HeeY1SaE2Z2kI6NkVWn5IOT2q73w9bAmr3oM6T6FIsLvNjLNs
        TEp8au4ORNgtyAfIwGhtvw2HUWFnxdC6sfpITDv6on/lp3rg93G9pKBTNqd7vdOWh9uNX5oJvlH
        6mzr3xNLuQlflBV5f
X-Received: by 2002:a5d:6c62:0:b0:222:cda4:e09e with SMTP id r2-20020a5d6c62000000b00222cda4e09emr11718919wrz.449.1661951518850;
        Wed, 31 Aug 2022 06:11:58 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7ZSYkA7fjm+OZ6sn+qmpM5mhoBEcsS0wdTyllOziEPy0pfYIn3m8l0JSgMpQ2wkc0TAxe4RQ==
X-Received: by 2002:a5d:6c62:0:b0:222:cda4:e09e with SMTP id r2-20020a5d6c62000000b00222cda4e09emr11718900wrz.449.1661951518513;
        Wed, 31 Aug 2022 06:11:58 -0700 (PDT)
Received: from redhat.com ([2.55.191.225])
        by smtp.gmail.com with ESMTPSA id n5-20020a05600c3b8500b003a319b67f64sm7823457wms.0.2022.08.31.06.11.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 06:11:58 -0700 (PDT)
Date:   Wed, 31 Aug 2022 09:11:53 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Gavin Li <gavinl@nvidia.com>
Cc:     stephen@networkplumber.org, davem@davemloft.net,
        jesse.brandeburg@intel.com, alexander.h.duyck@intel.com,
        kuba@kernel.org, sridhar.samudrala@intel.com, jasowang@redhat.com,
        loseweigh@gmail.com, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        virtio-dev@lists.oasis-open.org, gavi@nvidia.com, parav@nvidia.com,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>
Subject: Re: [PATCH RESEND v4 2/2] virtio-net: use mtu size as buffer length
 for big packets
Message-ID: <20220831090907-mutt-send-email-mst@kernel.org>
References: <20220831130541.81217-1-gavinl@nvidia.com>
 <20220831130541.81217-3-gavinl@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831130541.81217-3-gavinl@nvidia.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 31, 2022 at 04:05:41PM +0300, Gavin Li wrote:
> Currently add_recvbuf_big() allocates MAX_SKB_FRAGS segments for big
> packets even when GUEST_* offloads are not present on the device.
> However, if guest GSO is not supported, it would be sufficient to
> allocate segments to cover just up the MTU size and no further.
> Allocating the maximum amount of segments results in a large waste of
> buffer space in the queue, which limits the number of packets that can
> be buffered and can result in reduced performance.
> 
> Therefore, if guest GSO is not supported, use the MTU to calculate the
> optimal amount of segments required.
> 
> When guest offload is enabled at runtime, RQ already has packets of bytes
> less than 64K. So when packet of 64KB arrives, all the packets of such
> size will be dropped. and RQ is now not usable.
> 
> So this means that during set_guest_offloads() phase, RQs have to be
> destroyed and recreated, which requires almost driver reload.
> 
> If VIRTIO_NET_F_CTRL_GUEST_OFFLOADS has been negotiated, then it should
> always treat them as GSO enabled.

a better way to put this last sentence:

Accordingly, for now we assume that if GSO has been negotiated
then it has been enabled, even if it's actually been disabled
at runtime through VIRTIO_NET_F_CTRL_GUEST_OFFLOADS.

> Below is the iperf TCP test results over a Mellanox NIC, using vDPA for
> 1 VQ, queue size 1024, before and after the change, with the iperf
> server running over the virtio-net interface.
> 
> MTU(Bytes)/Bandwidth (Gbit/s)
>              Before   After
>   1500        22.5     22.4
>   9000        12.8     25.9
> 
> Signed-off-by: Gavin Li <gavinl@nvidia.com>
> Reviewed-by: Gavi Teitz <gavi@nvidia.com>
> Reviewed-by: Parav Pandit <parav@nvidia.com>
> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>
> ---
> changelog:
> v3->v4
> - Addressed comments from Si-Wei
> - Rename big_packets_sg_num with big_packets_num_skbfrags
> v2->v3
> - Addressed comments from Si-Wei
> - Simplify the condition check to enable the optimization
> v1->v2
> - Addressed comments from Jason, Michael, Si-Wei.
> - Remove the flag of guest GSO support, set sg_num for big packets and
>   use it directly
> - Recalculate sg_num for big packets in virtnet_set_guest_offloads
> - Replace the round up algorithm with DIV_ROUND_UP
> ---
>  drivers/net/virtio_net.c | 37 ++++++++++++++++++++++++-------------
>  1 file changed, 24 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index e1904877d461..ba2852b41795 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -225,6 +225,9 @@ struct virtnet_info {
>  	/* I like... big packets and I cannot lie! */
>  	bool big_packets;
>  
> +	/* number of sg entries allocated for big packets */
> +	unsigned int big_packets_num_skbfrags;
> +
>  	/* Host will merge rx buffers for big packets (shake it! shake it!) */
>  	bool mergeable_rx_bufs;
>  
> @@ -1331,10 +1334,10 @@ static int add_recvbuf_big(struct virtnet_info *vi, struct receive_queue *rq,
>  	char *p;
>  	int i, err, offset;
>  
> -	sg_init_table(rq->sg, MAX_SKB_FRAGS + 2);
> +	sg_init_table(rq->sg, vi->big_packets_num_skbfrags + 2);
>  
> -	/* page in rq->sg[MAX_SKB_FRAGS + 1] is list tail */
> -	for (i = MAX_SKB_FRAGS + 1; i > 1; --i) {
> +	/* page in rq->sg[vi->big_packets_num_skbfrags + 1] is list tail */
> +	for (i = vi->big_packets_num_skbfrags + 1; i > 1; --i) {
>  		first = get_a_page(rq, gfp);
>  		if (!first) {
>  			if (list)
> @@ -1365,7 +1368,7 @@ static int add_recvbuf_big(struct virtnet_info *vi, struct receive_queue *rq,
>  
>  	/* chain first in list head */
>  	first->private = (unsigned long)list;
> -	err = virtqueue_add_inbuf(rq->vq, rq->sg, MAX_SKB_FRAGS + 2,
> +	err = virtqueue_add_inbuf(rq->vq, rq->sg, vi->big_packets_num_skbfrags + 2,
>  				  first, gfp);
>  	if (err < 0)
>  		give_pages(rq, first);
> @@ -3690,13 +3693,27 @@ static bool virtnet_check_guest_gso(const struct virtnet_info *vi)
>  		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO));
>  }
>  
> +static void virtnet_set_big_packets_fields(struct virtnet_info *vi, const int mtu)
> +{
> +	bool guest_gso = virtnet_check_guest_gso(vi);
> +
> +	/* If device can receive ANY guest GSO packets, regardless of mtu,
> +	 * allocate packets of maximum size, otherwise limit it to only
> +	 * mtu size worth only.
> +	 */
> +	if (mtu > ETH_DATA_LEN || guest_gso) {
> +		vi->big_packets = true;
> +		vi->big_packets_num_skbfrags = guest_gso ? MAX_SKB_FRAGS : DIV_ROUND_UP(mtu, PAGE_SIZE);
> +	}
> +}
> +
>  static int virtnet_probe(struct virtio_device *vdev)
>  {
>  	int i, err = -ENOMEM;
>  	struct net_device *dev;
>  	struct virtnet_info *vi;
>  	u16 max_queue_pairs;
> -	int mtu;
> +	int mtu = 0;
>  
>  	/* Find if host supports multiqueue/rss virtio_net device */
>  	max_queue_pairs = 1;
> @@ -3784,10 +3801,6 @@ static int virtnet_probe(struct virtio_device *vdev)
>  	INIT_WORK(&vi->config_work, virtnet_config_changed_work);
>  	spin_lock_init(&vi->refill_lock);
>  
> -	/* If we can receive ANY GSO packets, we must allocate large ones. */
> -	if (virtnet_check_guest_gso(vi))
> -		vi->big_packets = true;
> -
>  	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
>  		vi->mergeable_rx_bufs = true;
>  
> @@ -3853,12 +3866,10 @@ static int virtnet_probe(struct virtio_device *vdev)
>  
>  		dev->mtu = mtu;
>  		dev->max_mtu = mtu;
> -
> -		/* TODO: size buffers correctly in this case. */
> -		if (dev->mtu > ETH_DATA_LEN)
> -			vi->big_packets = true;
>  	}
>  
> +	virtnet_set_big_packets_fields(vi, mtu);
> +
>  	if (vi->any_header_sg)
>  		dev->needed_headroom = vi->hdr_len;
>  
> -- 
> 2.31.1


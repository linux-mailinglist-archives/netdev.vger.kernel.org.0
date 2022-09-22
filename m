Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34A055E5EAF
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 11:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbiIVJf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 05:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiIVJfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 05:35:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5CDD915D7
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 02:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663839322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vFyfWYLsYMXpv8ny44xrsUtzp/rwPKOEQAD5TjiUzpc=;
        b=ehH7YP89LcIoYj4ZdBFi0sk/TIHHOGS9LjHCJfgKXBiwV6I9rEgZEgMj+pQz/z10XJVLE4
        /xAksVFyEeD7FMLNVfPTlywE3se4iOyCZYVoGA7UnfueV4pYv2HQfOl2ky2Q/Hek8qKiEb
        SlMIYLetBFZUjyRHJBAiUx+whhFCcfY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-663-fOZbFIhMPPec2lBpYrPF9Q-1; Thu, 22 Sep 2022 05:35:20 -0400
X-MC-Unique: fOZbFIhMPPec2lBpYrPF9Q-1
Received: by mail-wm1-f70.google.com with SMTP id n32-20020a05600c3ba000b003b5054c71faso353637wms.9
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 02:35:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=vFyfWYLsYMXpv8ny44xrsUtzp/rwPKOEQAD5TjiUzpc=;
        b=z1dDGDrs0JRI2G+RWIxJZFUzUFrQgseMEl1rwopbkZk89BWnw46YksUkhDzm2DNNzi
         zbCUkdywKCMK9/tVo5b6u+jnjfy887MRhAw9JsQsfEBDtgbriOvLJqFLYTy8FYlW515N
         mjLvGKP22Ob7T8gPwbm99k9MsFwwvTeTrbAkZHESNhbCPr7exqJZhyYZvNOK1W+uc9Uc
         hwGdf7SheGusYUhgB348cUna6tdbPI4um2DbTklvD2aXwBcmDuFct26V6b9L3qlkpU2h
         AahpDR4/SA1V+q21IwMZhCy8ToEJihQLI27xX+p0dmHGraBknuIEyhIeJ6HyzZLloMdQ
         gx/A==
X-Gm-Message-State: ACrzQf2vSLwZGHGXvzv7fzgfREOWHhQ1nqlgIUrPGL+RAg5vouK7hQRC
        RpY0dkhTwgLzDa56TZkcpA78AV3WzWpBP5PI41tI6jTOgPQZsFGLGORUAOdS+gx1huq/HiuTiDa
        s2iwj0xSznDRZTR1i
X-Received: by 2002:a05:6000:1681:b0:22a:fc6b:f83c with SMTP id y1-20020a056000168100b0022afc6bf83cmr1319513wrd.507.1663839319537;
        Thu, 22 Sep 2022 02:35:19 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5EaOzioxiAsDYpFJCLfhSocIP5WBgmtoEgdzUe5H7ODazLtcqxLY9qIEfLUiqGDYr06WLnxQ==
X-Received: by 2002:a05:6000:1681:b0:22a:fc6b:f83c with SMTP id y1-20020a056000168100b0022afc6bf83cmr1319497wrd.507.1663839319246;
        Thu, 22 Sep 2022 02:35:19 -0700 (PDT)
Received: from redhat.com ([2.55.16.18])
        by smtp.gmail.com with ESMTPSA id l36-20020a05600c08a400b003b4727d199asm5082934wmp.15.2022.09.22.02.35.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 02:35:18 -0700 (PDT)
Date:   Thu, 22 Sep 2022 05:35:12 -0400
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
Subject: Re: [PATCH v5 2/2] virtio-net: use mtu size as buffer length for big
 packets
Message-ID: <20220922052734-mutt-send-email-mst@kernel.org>
References: <20220901021038.84751-1-gavinl@nvidia.com>
 <20220901021038.84751-3-gavinl@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220901021038.84751-3-gavinl@nvidia.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 01, 2022 at 05:10:38AM +0300, Gavin Li wrote:
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
> 
> Accordingly, for now the assumption is that if guest GSO has been
> negotiated then it has been enabled, even if it's actually been disabled
> at runtime through VIRTIO_NET_F_CTRL_GUEST_OFFLOADS.
> 
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

OK I think the logic is correct, it's just a bit harder to read
than necessary. Small improvement suggestions:


> ---
> changelog:
> v4->v5
> - Addressed comments from Michael S. Tsirkin
> - Improve commit message
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
> index f831a0290998..dbffd5f56fb8 100644
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

big_packets_num_skbfrags -> big_packet_num_skbfrags

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
>  		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO);
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

I think it's better to drop this and instead just put the code
where we already know the config. So:
  
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

    /* Size buffers to fit mtu. */
    if (mtu > ETH_DATA_LEN) {
                    vi->big_packets = true;
                    vi->big_packets_num_skbfrags = DIV_ROUND_UP(mtu, PAGE_SIZE);
    }

>  	}
>  
> +	virtnet_set_big_packets_fields(vi, mtu);
> +

and here:
        /* If device can receive guest GSO packets, allocate buffers for
         * packets of maximum size, regardless of mtu.
	 */

	if (virtnet_check_guest_gso(vi)) {
		vi->big_packets = true;
		vi->big_packets_num_skbfrags = MAX_SKB_FRAGS;
        }


>  	if (vi->any_header_sg)
>  		dev->needed_headroom = vi->hdr_len;
>  
> -- 
> 2.31.1


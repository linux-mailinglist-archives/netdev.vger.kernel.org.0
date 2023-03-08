Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67F216AFF22
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 07:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjCHGyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 01:54:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjCHGyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 01:54:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23EB8B072
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 22:53:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678258402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y86pDM0nF4SS/2l52+50ptoIaTxu1jy+95EBPWqW538=;
        b=a80conT1auGpAERooSXm2HuQGdLnDzsoI99IZTrvrtDTWs4Z76E6dkbPodxpiWTQqSndNH
        sI79vHO5ElNpl+0Med2O2KKOmDxA9Arx8lwKsdA/13SRJPTTdxEh6EBFyZhitposAZn1CQ
        RuBuM/TYfr0TvviZ4ldJZgudEMgxlAM=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-569-CdFfUScEPpqE7IDcFn7KSA-1; Wed, 08 Mar 2023 01:53:21 -0500
X-MC-Unique: CdFfUScEPpqE7IDcFn7KSA-1
Received: by mail-ed1-f72.google.com with SMTP id dn8-20020a05640222e800b004bd35dd76a9so22607286edb.13
        for <netdev@vger.kernel.org>; Tue, 07 Mar 2023 22:53:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678258400;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y86pDM0nF4SS/2l52+50ptoIaTxu1jy+95EBPWqW538=;
        b=PCntBVUHQmMsYaIKkvQBXaLNxH8c9eG+El19Eo26jMVL7f4+tryy5Fq6A1/KqXztzJ
         CiEfGyca3CW5nohqGQISUwO2+zPtmxh33XlS5kw2BYijmd4k1+BR1Qrqlq5BVW/8EE4Q
         NEVIU7HksAcVMwEiEcB5qq9EHzRF0JM2HN3sjda4EDhyK9GIb1FWS3aO5yB0MV/ejBfR
         DUXaEmA66h+33xWExZkUXdNHvKyaQBxTJgVkHyc0NxZmqmkfuu2U0SPnaN1ECZX2YxRf
         S8o+iYnE6tmEOHQ6hPdMnm8mWDxs6XlofcaMVpSDEIdp+0rbwmGzJdkU7z6qKM7An+9d
         uhSA==
X-Gm-Message-State: AO0yUKXyiTMO7gHoO4IpQP2DumqLH6QQnqUPhy/FicRZZOlt4jrFGDEG
        RZemJ8jf9DvK6aEsdDgOUGBwk2QT3/C5xjPCJO3E9QnEL8D6fdkyixVKxm6EOFvufNt3w6Nqlwc
        jA7BvNiXbauppL422
X-Received: by 2002:a17:907:72c7:b0:889:d156:616d with SMTP id du7-20020a17090772c700b00889d156616dmr21552341ejc.27.1678258400251;
        Tue, 07 Mar 2023 22:53:20 -0800 (PST)
X-Google-Smtp-Source: AK7set9xF4xRWiMSSCuL+dL3ONYy7crKcxfjeDDKfUoTwq1xZ/S/2EmD4jkVLapobwjXJ06W9xks2w==
X-Received: by 2002:a17:907:72c7:b0:889:d156:616d with SMTP id du7-20020a17090772c700b00889d156616dmr21552324ejc.27.1678258399943;
        Tue, 07 Mar 2023 22:53:19 -0800 (PST)
Received: from redhat.com ([2.52.138.216])
        by smtp.gmail.com with ESMTPSA id bn17-20020a170906c0d100b008f7f6943d1dsm7044130ejb.42.2023.03.07.22.53.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 22:53:19 -0800 (PST)
Date:   Wed, 8 Mar 2023 01:53:15 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        Yichun Zhang <yichun@openresty.com>,
        Alexander Duyck <alexanderduyck@fb.com>
Subject: Re: [PATCH net, stable v1 1/3] virtio_net: reorder some funcs
Message-ID: <20230308015204-mutt-send-email-mst@kernel.org>
References: <20230308024935.91686-1-xuanzhuo@linux.alibaba.com>
 <20230308024935.91686-2-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308024935.91686-2-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 08, 2023 at 10:49:33AM +0800, Xuan Zhuo wrote:
> The purpose of this is to facilitate the subsequent addition of new
> functions without introducing a separate declaration.
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

this one isn't for stable naturally, stable can use forward declarations
instead.

> ---
>  drivers/net/virtio_net.c | 92 ++++++++++++++++++++--------------------
>  1 file changed, 46 insertions(+), 46 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index fb5e68ed3ec2..8b31a04052f2 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -545,6 +545,52 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>  	return skb;
>  }
>  
> +static void free_old_xmit_skbs(struct send_queue *sq, bool in_napi)
> +{
> +	unsigned int len;
> +	unsigned int packets = 0;
> +	unsigned int bytes = 0;
> +	void *ptr;
> +
> +	while ((ptr = virtqueue_get_buf(sq->vq, &len)) != NULL) {
> +		if (likely(!is_xdp_frame(ptr))) {
> +			struct sk_buff *skb = ptr;
> +
> +			pr_debug("Sent skb %p\n", skb);
> +
> +			bytes += skb->len;
> +			napi_consume_skb(skb, in_napi);
> +		} else {
> +			struct xdp_frame *frame = ptr_to_xdp(ptr);
> +
> +			bytes += xdp_get_frame_len(frame);
> +			xdp_return_frame(frame);
> +		}
> +		packets++;
> +	}
> +
> +	/* Avoid overhead when no packets have been processed
> +	 * happens when called speculatively from start_xmit.
> +	 */
> +	if (!packets)
> +		return;
> +
> +	u64_stats_update_begin(&sq->stats.syncp);
> +	sq->stats.bytes += bytes;
> +	sq->stats.packets += packets;
> +	u64_stats_update_end(&sq->stats.syncp);
> +}
> +
> +static bool is_xdp_raw_buffer_queue(struct virtnet_info *vi, int q)
> +{
> +	if (q < (vi->curr_queue_pairs - vi->xdp_queue_pairs))
> +		return false;
> +	else if (q < vi->curr_queue_pairs)
> +		return true;
> +	else
> +		return false;
> +}
> +
>  static int __virtnet_xdp_xmit_one(struct virtnet_info *vi,
>  				   struct send_queue *sq,
>  				   struct xdp_frame *xdpf)
> @@ -1714,52 +1760,6 @@ static int virtnet_receive(struct receive_queue *rq, int budget,
>  	return stats.packets;
>  }
>  
> -static void free_old_xmit_skbs(struct send_queue *sq, bool in_napi)
> -{
> -	unsigned int len;
> -	unsigned int packets = 0;
> -	unsigned int bytes = 0;
> -	void *ptr;
> -
> -	while ((ptr = virtqueue_get_buf(sq->vq, &len)) != NULL) {
> -		if (likely(!is_xdp_frame(ptr))) {
> -			struct sk_buff *skb = ptr;
> -
> -			pr_debug("Sent skb %p\n", skb);
> -
> -			bytes += skb->len;
> -			napi_consume_skb(skb, in_napi);
> -		} else {
> -			struct xdp_frame *frame = ptr_to_xdp(ptr);
> -
> -			bytes += xdp_get_frame_len(frame);
> -			xdp_return_frame(frame);
> -		}
> -		packets++;
> -	}
> -
> -	/* Avoid overhead when no packets have been processed
> -	 * happens when called speculatively from start_xmit.
> -	 */
> -	if (!packets)
> -		return;
> -
> -	u64_stats_update_begin(&sq->stats.syncp);
> -	sq->stats.bytes += bytes;
> -	sq->stats.packets += packets;
> -	u64_stats_update_end(&sq->stats.syncp);
> -}
> -
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
> -- 
> 2.32.0.3.g01195cf9f


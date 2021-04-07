Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A41673573F8
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 20:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348285AbhDGSKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 14:10:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54279 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229876AbhDGSKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 14:10:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617819003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sIJdtqncyoAj6XEcbUfmwwq7YASSmOYsJ3oO6UTSf9Q=;
        b=h94phMiiYSNVKH825FyOFPp4vT4LGCKmRkfCckvthgqp8DmmoqsrYNDgAdr+7GN9TpJ/oN
        rp7kMJqgF3Bbu2kK83WtYriEgSGFuY++g2yit63rdY2MrIXpBg2GOOMgY/Aotl3J337zht
        KEr63TRVWP9HRX5wfk99syHWrsmwaLA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344--5n6HxgIOiumPSSI8fN5xw-1; Wed, 07 Apr 2021 14:10:02 -0400
X-MC-Unique: -5n6HxgIOiumPSSI8fN5xw-1
Received: by mail-wr1-f71.google.com with SMTP id z7so4004434wrs.17
        for <netdev@vger.kernel.org>; Wed, 07 Apr 2021 11:10:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sIJdtqncyoAj6XEcbUfmwwq7YASSmOYsJ3oO6UTSf9Q=;
        b=spLDNCsYCmFuVrSiR0DcgXcUfHtXucErzWryb4d8igEeUTWqimLCmO+my30K3xB/O4
         9ZLokT7nZ48RxlaKaZp8qzs3GZM8DKn8iMAniEn/rAoyMArLEPyJv4FNBNdVRHU3M5zS
         RBsHA1XuYU0i1HE5LyC61ZwnosPejtirqilEdwp3BvJ987OWIYhqiWlfvD7kqRboP5nM
         OW2O3F28XLffiOU1zvM0cKL8LwjWsTUhT0nEe+RtYMYaWcuOwocQ+0tLfUyrZk6CDa+7
         eF/to/8JtGcSWiZ3vIENM1ldVDdRQH1cct7TzkKRc9HdeArf7SHNx/17d/jc1K3h/0y5
         kLeQ==
X-Gm-Message-State: AOAM530n+knlpiZ1ujzOJ7QUdlvbCN5XGhlSOSRtKU5sz6x9q1UwRiil
        I9qCbHqj1rjGIWQUJ71W5unjKa08D/pt4fiwcDag2OA8j3w7yff7lefR1iVUOa4dP1gixlhybg1
        WNpmcG87fMEzW1p3Y
X-Received: by 2002:a05:6000:cd:: with SMTP id q13mr5880700wrx.346.1617818999734;
        Wed, 07 Apr 2021 11:09:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxmGWcbswH2Snjx8UwjwZags/B+Rm4ezDOG1zQdILuxIjW6cC2J/oKr2mnShnnrqIUdzuYpWw==
X-Received: by 2002:a05:6000:cd:: with SMTP id q13mr5880682wrx.346.1617818999543;
        Wed, 07 Apr 2021 11:09:59 -0700 (PDT)
Received: from redhat.com ([2a10:800e:f0d3:0:b69b:9fb8:3947:5636])
        by smtp.gmail.com with ESMTPSA id c16sm6422763wrx.46.2021.04.07.11.09.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 11:09:59 -0700 (PDT)
Date:   Wed, 7 Apr 2021 14:09:56 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH net] virtio_net: Do not pull payload in skb->head
Message-ID: <20210407140333-mutt-send-email-mst@kernel.org>
References: <20210402132602.3659282-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210402132602.3659282-1-eric.dumazet@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 02, 2021 at 06:26:02AM -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Xuan Zhuo reported that commit 3226b158e67c ("net: avoid 32 x truesize
> under-estimation for tiny skbs") brought  a ~10% performance drop.
> 
> The reason for the performance drop was that GRO was forced
> to chain sk_buff (using skb_shinfo(skb)->frag_list), which
> uses more memory but also cause packet consumers to go over
> a lot of overhead handling all the tiny skbs.
> 
> It turns out that virtio_net page_to_skb() has a wrong strategy :
> It allocates skbs with GOOD_COPY_LEN (128) bytes in skb->head, then
> copies 128 bytes from the page, before feeding the packet to GRO stack.
> 
> This was suboptimal before commit 3226b158e67c ("net: avoid 32 x truesize
> under-estimation for tiny skbs") because GRO was using 2 frags per MSS,
> meaning we were not packing MSS with 100% efficiency.
> 
> Fix is to pull only the ethernet header in page_to_skb()
> 
> Then, we change virtio_net_hdr_to_skb() to pull the missing
> headers, instead of assuming they were already pulled by callers.
> 
> This fixes the performance regression, but could also allow virtio_net
> to accept packets with more than 128bytes of headers.
> 
> Many thanks to Xuan Zhuo for his report, and his tests/help.
> 
> Fixes: 3226b158e67c ("net: avoid 32 x truesize under-estimation for tiny skbs")
> Reported-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Link: https://www.spinics.net/lists/netdev/msg731397.html
> Co-Developed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: virtualization@lists.linux-foundation.org

Acked-by: Michael S. Tsirkin <mst@redhat.com>

Thanks a lot for looking into this, Eric and Xuan Zhuo !

> ---
>  drivers/net/virtio_net.c   | 10 +++++++---
>  include/linux/virtio_net.h | 14 +++++++++-----
>  2 files changed, 16 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 82e520d2cb1229a0c7b9fd0def3e4a7135536478..0824e6999e49957f7aaf7c990f6259792d42f32b 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -406,9 +406,13 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>  	offset += hdr_padded_len;
>  	p += hdr_padded_len;
>  
> -	copy = len;
> -	if (copy > skb_tailroom(skb))
> -		copy = skb_tailroom(skb);
> +	/* Copy all frame if it fits skb->head, otherwise
> +	 * we let virtio_net_hdr_to_skb() and GRO pull headers as needed.
> +	 */
> +	if (len <= skb_tailroom(skb))
> +		copy = len;
> +	else
> +		copy = ETH_HLEN + metasize;
>  	skb_put_data(skb, p, copy);
>  
>  	if (metasize) {
> diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
> index 98775d7fa69632e2c2da30b581a666f7fbb94b64..b465f8f3e554f27ced45c35f54f113cf6dce1f07 100644
> --- a/include/linux/virtio_net.h
> +++ b/include/linux/virtio_net.h
> @@ -65,14 +65,18 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
>  	skb_reset_mac_header(skb);
>  
>  	if (hdr->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) {
> -		u16 start = __virtio16_to_cpu(little_endian, hdr->csum_start);
> -		u16 off = __virtio16_to_cpu(little_endian, hdr->csum_offset);
> +		u32 start = __virtio16_to_cpu(little_endian, hdr->csum_start);
> +		u32 off = __virtio16_to_cpu(little_endian, hdr->csum_offset);
> +		u32 needed = start + max_t(u32, thlen, off + sizeof(__sum16));
> +
> +		if (!pskb_may_pull(skb, needed))
> +			return -EINVAL;
>  
>  		if (!skb_partial_csum_set(skb, start, off))
>  			return -EINVAL;
>  
>  		p_off = skb_transport_offset(skb) + thlen;
> -		if (p_off > skb_headlen(skb))
> +		if (!pskb_may_pull(skb, p_off))
>  			return -EINVAL;
>  	} else {
>  		/* gso packets without NEEDS_CSUM do not set transport_offset.
> @@ -102,14 +106,14 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
>  			}
>  
>  			p_off = keys.control.thoff + thlen;
> -			if (p_off > skb_headlen(skb) ||
> +			if (!pskb_may_pull(skb, p_off) ||
>  			    keys.basic.ip_proto != ip_proto)
>  				return -EINVAL;
>  
>  			skb_set_transport_header(skb, keys.control.thoff);
>  		} else if (gso_type) {
>  			p_off = thlen;
> -			if (p_off > skb_headlen(skb))
> +			if (!pskb_may_pull(skb, p_off))
>  				return -EINVAL;
>  		}
>  	}
> -- 
> 2.31.0.208.g409f899ff0-goog


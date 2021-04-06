Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F33D5354AB6
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 04:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239414AbhDFCDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 22:03:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29508 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238649AbhDFCDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 22:03:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617674616;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NE0jWj+e38GjOmQ3dzCrwVMGgnT57rdacD0LpLJtGWM=;
        b=O9il0AjiCWAEBMB7fcPnLlgm8LINK1/10EW7gr0JSQ3z6dEf1uTe1c0QONrpwhvLtIgEBd
        7hHbDJ+YxIfrdJi8D0jXbuPam3iPO7cCTT3h5RSXIvpL8njtbFBQuryTRxevjbYTSNl1Ge
        c6Sf4kFQ/0n36OvYS2JuAasmO9AJgmA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271--1dPHH2oMvmRLN28cKfmKw-1; Mon, 05 Apr 2021 22:03:32 -0400
X-MC-Unique: -1dPHH2oMvmRLN28cKfmKw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AC20287A82A;
        Tue,  6 Apr 2021 02:03:30 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-96.pek2.redhat.com [10.72.13.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 586F21C4;
        Tue,  6 Apr 2021 02:03:24 +0000 (UTC)
Subject: Re: [PATCH net] virtio_net: Do not pull payload in skb->head
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org
References: <20210402132602.3659282-1-eric.dumazet@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <61d05135-3a25-b145-769f-ee7c72f46d7b@redhat.com>
Date:   Tue, 6 Apr 2021 10:03:22 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210402132602.3659282-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/4/2 ÏÂÎç9:26, Eric Dumazet Ð´µÀ:
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
> ---


Acked-by: Jason Wang <jasowang@redhat.com>


>   drivers/net/virtio_net.c   | 10 +++++++---
>   include/linux/virtio_net.h | 14 +++++++++-----
>   2 files changed, 16 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 82e520d2cb1229a0c7b9fd0def3e4a7135536478..0824e6999e49957f7aaf7c990f6259792d42f32b 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -406,9 +406,13 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>   	offset += hdr_padded_len;
>   	p += hdr_padded_len;
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
>   	skb_put_data(skb, p, copy);
>   
>   	if (metasize) {
> diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
> index 98775d7fa69632e2c2da30b581a666f7fbb94b64..b465f8f3e554f27ced45c35f54f113cf6dce1f07 100644
> --- a/include/linux/virtio_net.h
> +++ b/include/linux/virtio_net.h
> @@ -65,14 +65,18 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
>   	skb_reset_mac_header(skb);
>   
>   	if (hdr->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) {
> -		u16 start = __virtio16_to_cpu(little_endian, hdr->csum_start);
> -		u16 off = __virtio16_to_cpu(little_endian, hdr->csum_offset);
> +		u32 start = __virtio16_to_cpu(little_endian, hdr->csum_start);
> +		u32 off = __virtio16_to_cpu(little_endian, hdr->csum_offset);
> +		u32 needed = start + max_t(u32, thlen, off + sizeof(__sum16));
> +
> +		if (!pskb_may_pull(skb, needed))
> +			return -EINVAL;
>   
>   		if (!skb_partial_csum_set(skb, start, off))
>   			return -EINVAL;
>   
>   		p_off = skb_transport_offset(skb) + thlen;
> -		if (p_off > skb_headlen(skb))
> +		if (!pskb_may_pull(skb, p_off))
>   			return -EINVAL;
>   	} else {
>   		/* gso packets without NEEDS_CSUM do not set transport_offset.
> @@ -102,14 +106,14 @@ static inline int virtio_net_hdr_to_skb(struct sk_buff *skb,
>   			}
>   
>   			p_off = keys.control.thoff + thlen;
> -			if (p_off > skb_headlen(skb) ||
> +			if (!pskb_may_pull(skb, p_off) ||
>   			    keys.basic.ip_proto != ip_proto)
>   				return -EINVAL;
>   
>   			skb_set_transport_header(skb, keys.control.thoff);
>   		} else if (gso_type) {
>   			p_off = thlen;
> -			if (p_off > skb_headlen(skb))
> +			if (!pskb_may_pull(skb, p_off))
>   				return -EINVAL;
>   		}
>   	}


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22601656808
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 08:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbiL0H4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 02:56:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiL0H4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 02:56:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E22B3F
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 23:55:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672127752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xV7l+8VYiJaFZmcUPBmZ52ru+09AM8Gi4rJWK0hXomw=;
        b=GY09kJin6BceKNEarebsal/yllKrBRuXrkz42cjnF9FrXMmC4I3JVePkf9R4cLY3J7nTIk
        N/uwhez2FSHQn274588C5vNUBqmJD9tzL+G1mEjuEVDs9xAj51yFfBRGjRRWcV3zmnlkuv
        gjIE9y6YjxinvcY1hFEFMPYxtWBS6pQ=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-479-e2S2i9raPYqAKFtTdT02yQ-1; Tue, 27 Dec 2022 02:55:51 -0500
X-MC-Unique: e2S2i9raPYqAKFtTdT02yQ-1
Received: by mail-pj1-f72.google.com with SMTP id t15-20020a17090a4e4f00b00225a7107898so5351955pjl.9
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 23:55:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xV7l+8VYiJaFZmcUPBmZ52ru+09AM8Gi4rJWK0hXomw=;
        b=bWDwYe9Zwu+UEtcldOZBlvZGIWPqlugqaRbJLbRnn2QLF2HJcbOpZpLVOJfNq8af//
         PIH216ReZWsETiUxjkxnNS1oo44+h8X/A64BEygv71xirG5WfzYVfDwULGbGqIhHZCNR
         dkt6jCRGvB6qRp4fzET0JOYM3URJBlb125M5fjhCfT6jAysxiBRSNSB2dQZXMo+ladiP
         14uFSVs7nz2/9o8RLxepqTRJ9Vk9oVX5ernVxPAVRFfdtDRv0D7day5cgdp8Ya3e+2V0
         eLpge6cjz9TBcjjnF3IZAfvcNLPsAVhQ6Ry9sGbY9xxcg93oNk9CcqyJijxAaGJAZgla
         mHxg==
X-Gm-Message-State: AFqh2kqH+qt9D7Vsrjqej82D/cV0otwz3BuvrW0berufAb9Sc+HYBDax
        8RmrOTXMSBMCo/eTnQZA5E1ntScInBvcoRE9ifvJVUm2zTE8d7NJGQ5vDGoyzcYEJJM1+vCb0H7
        Xvxx4K4u7WjJfBYsK
X-Received: by 2002:a17:90b:4a8c:b0:225:a8f2:fa38 with SMTP id lp12-20020a17090b4a8c00b00225a8f2fa38mr21774823pjb.21.1672127750481;
        Mon, 26 Dec 2022 23:55:50 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsZXqOmVTLrlDijfx38V90ccDJjUgiNJV9sF7IAkUmpIxpdd6KS5N1aN75o6OdzPIWJyjraRA==
X-Received: by 2002:a17:90b:4a8c:b0:225:a8f2:fa38 with SMTP id lp12-20020a17090b4a8c00b00225a8f2fa38mr21774804pjb.21.1672127750230;
        Mon, 26 Dec 2022 23:55:50 -0800 (PST)
Received: from [10.72.13.143] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id ms2-20020a17090b234200b002194319662asm10070691pjb.42.2022.12.26.23.55.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Dec 2022 23:55:49 -0800 (PST)
Message-ID: <7ac52b7e-05ea-600b-bb8a-15124c6c007d@redhat.com>
Date:   Tue, 27 Dec 2022 15:55:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v2 8/9] virtio_net: remove xdp related info from
 page_to_skb()
Content-Language: en-US
To:     Heng Qi <hengqi@linux.alibaba.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
References: <20221220141449.115918-1-hengqi@linux.alibaba.com>
 <20221220141449.115918-9-hengqi@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20221220141449.115918-9-hengqi@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/12/20 22:14, Heng Qi 写道:
> For the clear construction of xdp_buff, we remove the xdp processing
> interleaved with page_to_skb(). Now, the logic of xdp and building
> skb from xdp are separate and independent.
>
> Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>


Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


> ---
>   drivers/net/virtio_net.c | 41 +++++++++-------------------------------
>   1 file changed, 9 insertions(+), 32 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 4e12196fcfd4..398ffe2a5084 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -439,9 +439,7 @@ static unsigned int mergeable_ctx_to_truesize(void *mrg_ctx)
>   static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>   				   struct receive_queue *rq,
>   				   struct page *page, unsigned int offset,
> -				   unsigned int len, unsigned int truesize,
> -				   bool hdr_valid, unsigned int metasize,
> -				   unsigned int headroom)
> +				   unsigned int len, unsigned int truesize)
>   {
>   	struct sk_buff *skb;
>   	struct virtio_net_hdr_mrg_rxbuf *hdr;
> @@ -459,21 +457,11 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>   	else
>   		hdr_padded_len = sizeof(struct padded_vnet_hdr);
>   
> -	/* If headroom is not 0, there is an offset between the beginning of the
> -	 * data and the allocated space, otherwise the data and the allocated
> -	 * space are aligned.
> -	 *
> -	 * Buffers with headroom use PAGE_SIZE as alloc size, see
> -	 * add_recvbuf_mergeable() + get_mergeable_buf_len()
> -	 */
> -	truesize = headroom ? PAGE_SIZE : truesize;
> -	tailroom = truesize - headroom;
> -	buf = p - headroom;
> -
> +	buf = p;
>   	len -= hdr_len;
>   	offset += hdr_padded_len;
>   	p += hdr_padded_len;
> -	tailroom -= hdr_padded_len + len;
> +	tailroom = truesize - hdr_padded_len - len;
>   
>   	shinfo_size = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
>   
> @@ -503,7 +491,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>   	if (len <= skb_tailroom(skb))
>   		copy = len;
>   	else
> -		copy = ETH_HLEN + metasize;
> +		copy = ETH_HLEN;
>   	skb_put_data(skb, p, copy);
>   
>   	len -= copy;
> @@ -542,19 +530,11 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>   		give_pages(rq, page);
>   
>   ok:
> -	/* hdr_valid means no XDP, so we can copy the vnet header */
> -	if (hdr_valid) {
> -		hdr = skb_vnet_hdr(skb);
> -		memcpy(hdr, hdr_p, hdr_len);
> -	}
> +	hdr = skb_vnet_hdr(skb);
> +	memcpy(hdr, hdr_p, hdr_len);
>   	if (page_to_free)
>   		put_page(page_to_free);
>   
> -	if (metasize) {
> -		__skb_pull(skb, metasize);
> -		skb_metadata_set(skb, metasize);
> -	}
> -
>   	return skb;
>   }
>   
> @@ -934,7 +914,7 @@ static struct sk_buff *receive_big(struct net_device *dev,
>   {
>   	struct page *page = buf;
>   	struct sk_buff *skb =
> -		page_to_skb(vi, rq, page, 0, len, PAGE_SIZE, true, 0, 0);
> +		page_to_skb(vi, rq, page, 0, len, PAGE_SIZE);
>   
>   	stats->bytes += len - vi->hdr_len;
>   	if (unlikely(!skb))
> @@ -1222,9 +1202,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>   				rcu_read_unlock();
>   				put_page(page);
>   				head_skb = page_to_skb(vi, rq, xdp_page, offset,
> -						       len, PAGE_SIZE, false,
> -						       metasize,
> -						       headroom);
> +						       len, PAGE_SIZE);
>   				return head_skb;
>   			}
>   			break;
> @@ -1289,8 +1267,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>   	rcu_read_unlock();
>   
>   skip_xdp:
> -	head_skb = page_to_skb(vi, rq, page, offset, len, truesize, !xdp_prog,
> -			       metasize, headroom);
> +	head_skb = page_to_skb(vi, rq, page, offset, len, truesize);
>   	curr_skb = head_skb;
>   
>   	if (unlikely(!curr_skb))


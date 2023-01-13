Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB3F6689D1
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 03:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240043AbjAMC7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 21:59:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232182AbjAMC7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 21:59:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8BA13C
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 18:59:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673578739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vnehgijj1wh6Ple8n3RB2SOOGt77zriwKOyPRfZHGzM=;
        b=CPeZS9tn+M0eoce72MtGk63oZ3nLHXHUTvQ/QgMRjmQg+KIL/OTlqfs/zHwFcNC8XQrFzX
        ps6nHcaIvf4JrkW+d1r6NLAl7xywHHjemmQDJ31SMQ8KfgGp3OaKcpFiSv5cbbHyEATq/T
        xrm513bQHrHJDeFJP7x3U580F5ZuSbs=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-617-fa1RDiStPseVVgp_xmDJQg-1; Thu, 12 Jan 2023 21:58:58 -0500
X-MC-Unique: fa1RDiStPseVVgp_xmDJQg-1
Received: by mail-pg1-f199.google.com with SMTP id j21-20020a63fc15000000b00476d6932baeso9189975pgi.23
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 18:58:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vnehgijj1wh6Ple8n3RB2SOOGt77zriwKOyPRfZHGzM=;
        b=fHpIjAMj7BebkzX1oYM5cUmeW1iEqpc9ApGBVo4U9/JsJbfCmN/KDJsdcc/NEv27Fq
         encxVgwgjMhK5Wz06YQgpoO8xopvxymHa8dbi5R9PqZN/pon2mBNFJIrgj1MphycJzUY
         9e/LQ+jCeaYYaBcoin/CVD5s5pF0Klurg2wLBvsS5EIruYEPvmztk9xMTSSXkJvsL+pF
         f2+QkFC+8A2HcDFtHpbth9sAU2O1ewq0Yx8ydcyCi8bgVf/33nkHR9fbO2J9xXzrElTl
         6dyMvmF4fdaybdQM/n15UK9P2hrd6hD257BaKN2iokobeYxNuYzHow2pYJthgB5jEjnJ
         vRuQ==
X-Gm-Message-State: AFqh2kqvdg/T/xHhb589+MMmhAZZFqmeg54u/1yqBGhtSfr4idd/bhX5
        1zJGgK4wR2dmXDGqNLXCCpjfiP+RdJymHvDWXU7ONgTM1+oQNPLSygnlVRXaIvuIkW2k+sG/tXf
        Mu75O5hSeWxiZnqt3
X-Received: by 2002:a05:6a20:c508:b0:af:82aa:49e with SMTP id gm8-20020a056a20c50800b000af82aa049emr75647802pzb.2.1673578737544;
        Thu, 12 Jan 2023 18:58:57 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsxIUUBl6qjJ1MWYPG8P/adgE8PV8aRRAzlhDO0wIR4TudlRKPwde1MnccNzg0YDCvmMDlpNg==
X-Received: by 2002:a05:6a20:c508:b0:af:82aa:49e with SMTP id gm8-20020a056a20c50800b000af82aa049emr75647791pzb.2.1673578737304;
        Thu, 12 Jan 2023 18:58:57 -0800 (PST)
Received: from [10.72.12.164] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id bm9-20020a656e89000000b00476dc914262sm10655513pgb.1.2023.01.12.18.58.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 18:58:56 -0800 (PST)
Message-ID: <57de1112-de01-04f0-fb62-0735472b9b5c@redhat.com>
Date:   Fri, 13 Jan 2023 10:58:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v3 4/9] virtio-net: build xdp_buff with multi buffers
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
References: <20230103064012.108029-1-hengqi@linux.alibaba.com>
 <20230103064012.108029-5-hengqi@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20230103064012.108029-5-hengqi@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2023/1/3 14:40, Heng Qi 写道:
> Support xdp for multi buffer packets in mergeable mode.
>
> Putting the first buffer as the linear part for xdp_buff,
> and the rest of the buffers as non-linear fragments to struct
> skb_shared_info in the tailroom belonging to xdp_buff.
>
> Let 'truesize' return to its literal meaning, that is, when
> xdp is set, it includes the length of headroom and tailroom.
>
> Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>


Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


> ---
>   drivers/net/virtio_net.c | 108 ++++++++++++++++++++++++++++++++++++---
>   1 file changed, 100 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 6fc5302ca5ff..699e376b8f8b 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -931,6 +931,91 @@ static struct sk_buff *receive_big(struct net_device *dev,
>   	return NULL;
>   }
>   
> +/* TODO: build xdp in big mode */
> +static int virtnet_build_xdp_buff_mrg(struct net_device *dev,
> +				      struct virtnet_info *vi,
> +				      struct receive_queue *rq,
> +				      struct xdp_buff *xdp,
> +				      void *buf,
> +				      unsigned int len,
> +				      unsigned int frame_sz,
> +				      u16 *num_buf,
> +				      unsigned int *xdp_frags_truesize,
> +				      struct virtnet_rq_stats *stats)
> +{
> +	struct virtio_net_hdr_mrg_rxbuf *hdr = buf;
> +	unsigned int headroom, tailroom, room;
> +	unsigned int truesize, cur_frag_size;
> +	struct skb_shared_info *shinfo;
> +	unsigned int xdp_frags_truesz = 0;
> +	struct page *page;
> +	skb_frag_t *frag;
> +	int offset;
> +	void *ctx;
> +
> +	xdp_init_buff(xdp, frame_sz, &rq->xdp_rxq);
> +	xdp_prepare_buff(xdp, buf - VIRTIO_XDP_HEADROOM,
> +			 VIRTIO_XDP_HEADROOM + vi->hdr_len, len - vi->hdr_len, true);
> +
> +	if (*num_buf > 1) {
> +		/* If we want to build multi-buffer xdp, we need
> +		 * to specify that the flags of xdp_buff have the
> +		 * XDP_FLAGS_HAS_FRAG bit.
> +		 */
> +		if (!xdp_buff_has_frags(xdp))
> +			xdp_buff_set_frags_flag(xdp);
> +
> +		shinfo = xdp_get_shared_info_from_buff(xdp);
> +		shinfo->nr_frags = 0;
> +		shinfo->xdp_frags_size = 0;
> +	}
> +
> +	if ((*num_buf - 1) > MAX_SKB_FRAGS)
> +		return -EINVAL;
> +
> +	while ((--*num_buf) >= 1) {
> +		buf = virtqueue_get_buf_ctx(rq->vq, &len, &ctx);
> +		if (unlikely(!buf)) {
> +			pr_debug("%s: rx error: %d buffers out of %d missing\n",
> +				 dev->name, *num_buf,
> +				 virtio16_to_cpu(vi->vdev, hdr->num_buffers));
> +			dev->stats.rx_length_errors++;
> +			return -EINVAL;
> +		}
> +
> +		stats->bytes += len;
> +		page = virt_to_head_page(buf);
> +		offset = buf - page_address(page);
> +
> +		truesize = mergeable_ctx_to_truesize(ctx);
> +		headroom = mergeable_ctx_to_headroom(ctx);
> +		tailroom = headroom ? sizeof(struct skb_shared_info) : 0;
> +		room = SKB_DATA_ALIGN(headroom + tailroom);
> +
> +		cur_frag_size = truesize;
> +		xdp_frags_truesz += cur_frag_size;
> +		if (unlikely(len > truesize - room || cur_frag_size > PAGE_SIZE)) {
> +			put_page(page);
> +			pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
> +				 dev->name, len, (unsigned long)(truesize - room));
> +			dev->stats.rx_length_errors++;
> +			return -EINVAL;
> +		}
> +
> +		frag = &shinfo->frags[shinfo->nr_frags++];
> +		__skb_frag_set_page(frag, page);
> +		skb_frag_off_set(frag, offset);
> +		skb_frag_size_set(frag, len);
> +		if (page_is_pfmemalloc(page))
> +			xdp_buff_set_frag_pfmemalloc(xdp);
> +
> +		shinfo->xdp_frags_size += len;
> +	}
> +
> +	*xdp_frags_truesize = xdp_frags_truesz;
> +	return 0;
> +}
> +
>   static struct sk_buff *receive_mergeable(struct net_device *dev,
>   					 struct virtnet_info *vi,
>   					 struct receive_queue *rq,
> @@ -949,15 +1034,17 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>   	unsigned int truesize = mergeable_ctx_to_truesize(ctx);
>   	unsigned int headroom = mergeable_ctx_to_headroom(ctx);
>   	unsigned int metasize = 0;
> +	unsigned int tailroom = headroom ? sizeof(struct skb_shared_info) : 0;
> +	unsigned int room = SKB_DATA_ALIGN(headroom + tailroom);
>   	unsigned int frame_sz;
>   	int err;
>   
>   	head_skb = NULL;
>   	stats->bytes += len - vi->hdr_len;
>   
> -	if (unlikely(len > truesize)) {
> +	if (unlikely(len > truesize - room)) {
>   		pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
> -			 dev->name, len, (unsigned long)ctx);
> +			 dev->name, len, (unsigned long)(truesize - room));
>   		dev->stats.rx_length_errors++;
>   		goto err_skb;
>   	}
> @@ -983,10 +1070,12 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>   		if (unlikely(hdr->hdr.gso_type))
>   			goto err_xdp;
>   
> -		/* Buffers with headroom use PAGE_SIZE as alloc size,
> -		 * see add_recvbuf_mergeable() + get_mergeable_buf_len()
> +		/* Now XDP core assumes frag size is PAGE_SIZE, but buffers
> +		 * with headroom may add hole in truesize, which
> +		 * make their length exceed PAGE_SIZE. So we disabled the
> +		 * hole mechanism for xdp. See add_recvbuf_mergeable().
>   		 */
> -		frame_sz = headroom ? PAGE_SIZE : truesize;
> +		frame_sz = truesize;
>   
>   		/* This happens when rx buffer size is underestimated
>   		 * or headroom is not enough because of the buffer
> @@ -1139,9 +1228,12 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>   		page = virt_to_head_page(buf);
>   
>   		truesize = mergeable_ctx_to_truesize(ctx);
> -		if (unlikely(len > truesize)) {
> +		headroom = mergeable_ctx_to_headroom(ctx);
> +		tailroom = headroom ? sizeof(struct skb_shared_info) : 0;
> +		room = SKB_DATA_ALIGN(headroom + tailroom);
> +		if (unlikely(len > truesize - room)) {
>   			pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
> -				 dev->name, len, (unsigned long)ctx);
> +				 dev->name, len, (unsigned long)(truesize - room));
>   			dev->stats.rx_length_errors++;
>   			goto err_skb;
>   		}
> @@ -1428,7 +1520,7 @@ static int add_recvbuf_mergeable(struct virtnet_info *vi,
>   	}
>   
>   	sg_init_one(rq->sg, buf, len);
> -	ctx = mergeable_len_to_ctx(len, headroom);
> +	ctx = mergeable_len_to_ctx(len + room, headroom);
>   	err = virtqueue_add_inbuf_ctx(rq->vq, rq->sg, 1, buf, ctx, gfp);
>   	if (err < 0)
>   		put_page(virt_to_head_page(buf));


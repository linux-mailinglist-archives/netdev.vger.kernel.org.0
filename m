Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB1E7656798
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 07:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiL0GrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 01:47:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiL0GrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 01:47:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F3B62FF
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 22:46:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672123592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m4knyHj+l+dqV7A2xi7Y3KkvtsMiwfyqUyq8r+c4Ks0=;
        b=SXxH4U1LeqXyZiEYgI3UavjNrgPVini2aUatYgeQNG3XlNhfD+Kt+ZDgrD/uOBNUsLk/dO
        WfUMZbUu3o/sItR6MVhj2mV8s0h7IyyugkXXAm8eZasfkiJLCG11QO4f+eMRSTyKbEu4+7
        YeKdnlN+rXKMRPu5jK57MljNfSZHsJs=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-328-Ya45SO3XOviWvR1GaQOcWQ-1; Tue, 27 Dec 2022 01:46:30 -0500
X-MC-Unique: Ya45SO3XOviWvR1GaQOcWQ-1
Received: by mail-pf1-f198.google.com with SMTP id s2-20020a056a00178200b005810f057e7cso2485444pfg.3
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 22:46:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m4knyHj+l+dqV7A2xi7Y3KkvtsMiwfyqUyq8r+c4Ks0=;
        b=uGDRWSDqW9+t3v0DcWqu1nACNqCZSh4stcuEY7RRYymWn5K/5TRjhXIoOsuHg+xYwZ
         d/8l+gzT3fayq9uGD107NsHTqD215z4cvQqwI6/OCQEF9OnQCD0ybVWwgZ7SqVRFdSlA
         4yZ58z7G9garz73NVAG3l1raRi17uWhewibb4h+3T962tX8rx+0/T4Qixru30ZkBIzto
         VODT57uV7CLX5x37ZMjxTHVSJiIhEeCGvPTRokrPySJCf48ogy6mgZUbaVAUBcnZXLaa
         83p4jJUELfXfmuOvI5UbxaiEhZKQgm4LjqwcjqDKhIqSu0nacsF95LZ1p+WbQVyvoGS2
         RHpw==
X-Gm-Message-State: AFqh2kqKX/0XKgzB93wq3G0xVLnU5m5pq/QtYJnUh9UL9kVT4Y30CkCQ
        lFZHqE7ZbEV90wdIAR53ETvVF+hu+qbD7tPth1kh+AZm7MyJ8+/ObgWAzbqazcM4y3KdzKVFoXV
        9p9TV3KJbNvM4fGIa
X-Received: by 2002:a05:6a20:4ca1:b0:af:f80a:140f with SMTP id fq33-20020a056a204ca100b000aff80a140fmr21768102pzb.8.1672123589815;
        Mon, 26 Dec 2022 22:46:29 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtcS8CB5Dz0rhzMhYmFskNnRWqL9BFLJ8Dy/ZIPT03QJHTATSOlBrbaVdEhccLpDLgc/ejmvA==
X-Received: by 2002:a05:6a20:4ca1:b0:af:f80a:140f with SMTP id fq33-20020a056a204ca100b000aff80a140fmr21768088pzb.8.1672123589540;
        Mon, 26 Dec 2022 22:46:29 -0800 (PST)
Received: from [10.72.13.143] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id x7-20020aa79a47000000b005800cb7cbcasm7867244pfj.120.2022.12.26.22.46.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Dec 2022 22:46:29 -0800 (PST)
Message-ID: <e0cf3f23-a173-778b-fc68-27de811f1aab@redhat.com>
Date:   Tue, 27 Dec 2022 14:46:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v2 4/9] virtio_net: build xdp_buff with multi buffers
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
 <20221220141449.115918-5-hengqi@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20221220141449.115918-5-hengqi@linux.alibaba.com>
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
> Support xdp for multi buffer packets in mergeable mode.
>
> Putting the first buffer as the linear part for xdp_buff,
> and the rest of the buffers as non-linear fragments to struct
> skb_shared_info in the tailroom belonging to xdp_buff.
>
> Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>   drivers/net/virtio_net.c | 78 ++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 78 insertions(+)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 08f209d7b0bf..8fc3b1841d92 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -931,6 +931,84 @@ static struct sk_buff *receive_big(struct net_device *dev,
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
> +	unsigned int tailroom = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> +	struct virtio_net_hdr_mrg_rxbuf *hdr = buf;
> +	unsigned int truesize, headroom;
> +	struct skb_shared_info *shinfo;
> +	unsigned int xdp_frags_truesz = 0;
> +	unsigned int cur_frag_size;
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
> +		if (!xdp_buff_has_frags(xdp))
> +			xdp_buff_set_frags_flag(xdp);


Any reason to put this inside the loop?


> +
> +		stats->bytes += len;
> +		page = virt_to_head_page(buf);
> +		offset = buf - page_address(page);
> +		truesize = mergeable_ctx_to_truesize(ctx);
> +		headroom = mergeable_ctx_to_headroom(ctx);
> +
> +		cur_frag_size = truesize + (headroom ? (headroom + tailroom) : 0);
> +		xdp_frags_truesz += cur_frag_size;


Not related to this patch, but it would easily confuse the future 
readers that the we need another math for truesize. I think at least we 
need some comments for this or

I guess the root cause is in get_mergeable_buf_len:

static unsigned int get_mergeable_buf_len(struct receive_queue *rq,
                                       struct ewma_pkt_len *avg_pkt_len,
                                           unsigned int room)
{
         struct virtnet_info *vi = rq->vq->vdev->priv;
         const size_t hdr_len = vi->hdr_len;
         unsigned int len;

         if (room)
         return PAGE_SIZE - room;

And we do

     len = get_mergeable_buf_len(rq, &rq->mrg_avg_pkt_len, room);

     ...

     ctx = mergeable_len_to_ctx(len, headroom);


I wonder if it's better to pack the real truesize (PAGE_SIZE) here. This 
may ease a lot of things.

Thanks


> +		if (unlikely(len > truesize || cur_frag_size > PAGE_SIZE)) {
> +			pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
> +				 dev->name, len, (unsigned long)ctx);
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


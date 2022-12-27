Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 531CF6567A4
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 08:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiL0HCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 02:02:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiL0HCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 02:02:54 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACDA02180
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 23:02:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672124526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wVu131QllezoebfVyhN8Nk6/nex2d1N5zJREbPMc8AM=;
        b=a7XExeIJ0PO2Pk/eIZhXbctDfgWuFJPxBt3hFB0/bWF4ELg1HQJ67igazH/Y7ddoSrYPLz
        zFIMQbn7ciX32AlENUXSQHebnbeb/IDlJBxel0PqcS0Sz1i9s26v3VE9pJsf1Oz4+w3I6z
        V75DVEowIP+ao8i8i1smhzOHmww3Gkk=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-462-t0_clRZONBGsbeKP4ZIcCQ-1; Tue, 27 Dec 2022 02:02:05 -0500
X-MC-Unique: t0_clRZONBGsbeKP4ZIcCQ-1
Received: by mail-pg1-f199.google.com with SMTP id k16-20020a635a50000000b0042986056df6so6291367pgm.2
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 23:02:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wVu131QllezoebfVyhN8Nk6/nex2d1N5zJREbPMc8AM=;
        b=pQjWLCxWMXUatNzTD/HCc0H94jzyyQL6UO2+0rZQ8mHpNwSEHQPrt+syaxDX5R7w+N
         424v3Fi3YK8dWv0NV24O0x3vREFusrIJKhG1uCIpf14/3oqBqlPT4uYcihHkTDSG/prP
         YqtZOfJFxO1R3bCTDFfnKmx0m2sl5V4qUj191eiC9wcdXvSS/rgtseJF3jgjqDCeUUFj
         mqUJbmIRY6P6ibLOR4JyBzbuEDMO8nWIYonkEr1i4oF+Jpz0HzOidY2sgANmTG7PDmOz
         zWmqbXlB5/+x03lzPUnhdGlbhVximB/RIGj6PSdXIvNKh7lVBzussemtEsPsLnA3jlpp
         oZOg==
X-Gm-Message-State: AFqh2kpJmjGhg0wLtJxprQt2Yl/s/Cd6MqZ8IaHrcHQlNBOcnS1GWUId
        XBdOgwX2O9pPzcIUV0cWXVUeykXWMjfQqqXGGkG5K9wwmHAh5833AZ0u6tMHPB5QxBjwAnxD9T/
        0W9wPpUofhn7Mdu98
X-Received: by 2002:a17:902:8302:b0:192:73c9:11bd with SMTP id bd2-20020a170902830200b0019273c911bdmr6963909plb.23.1672124524244;
        Mon, 26 Dec 2022 23:02:04 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuCqzBtCLf3IJfdK/YJ0e61yWD8mFv8T42oqr12Ud/ouEgKJfuvCct0f5fFjamtIy2RM5E66Q==
X-Received: by 2002:a17:902:8302:b0:192:73c9:11bd with SMTP id bd2-20020a170902830200b0019273c911bdmr6963886plb.23.1672124523928;
        Mon, 26 Dec 2022 23:02:03 -0800 (PST)
Received: from [10.72.13.143] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c10d00b0017f8094a52asm8285431pli.29.2022.12.26.23.02.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Dec 2022 23:02:03 -0800 (PST)
Message-ID: <5a03364e-c09e-63ff-7e73-1efec1ed8ca8@redhat.com>
Date:   Tue, 27 Dec 2022 15:01:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v2 5/9] virtio_net: construct multi-buffer xdp in
 mergeable
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
 <20221220141449.115918-6-hengqi@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20221220141449.115918-6-hengqi@linux.alibaba.com>
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
> Build multi-buffer xdp using virtnet_build_xdp_buff_mrg().
>
> For the prefilled buffer before xdp is set, we will probably use
> vq reset in the future. At the same time, virtio net currently
> uses comp pages, and bpf_xdp_frags_increase_tail() needs to calculate
> the tailroom of the last frag, which will involve the offset of the
> corresponding page and cause a negative value, so we disable tail
> increase by not setting xdp_rxq->frag_size.
>
> Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> ---
>   drivers/net/virtio_net.c | 60 +++++++++++++++++++++++++++++-----------
>   1 file changed, 44 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 8fc3b1841d92..40bc58fa57f5 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1018,6 +1018,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>   					 unsigned int *xdp_xmit,
>   					 struct virtnet_rq_stats *stats)
>   {
> +	unsigned int tailroom = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
>   	struct virtio_net_hdr_mrg_rxbuf *hdr = buf;
>   	u16 num_buf = virtio16_to_cpu(vi->vdev, hdr->num_buffers);
>   	struct page *page = virt_to_head_page(buf);
> @@ -1048,11 +1049,14 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>   	rcu_read_lock();
>   	xdp_prog = rcu_dereference(rq->xdp_prog);
>   	if (xdp_prog) {
> +		unsigned int xdp_frags_truesz = 0;
> +		struct skb_shared_info *shinfo;
>   		struct xdp_frame *xdpf;
>   		struct page *xdp_page;
>   		struct xdp_buff xdp;
>   		void *data;
>   		u32 act;
> +		int i;
>   
>   		/* Transient failure which in theory could occur if
>   		 * in-flight packets from before XDP was enabled reach
> @@ -1061,19 +1065,23 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
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
>   		frame_sz = headroom ? PAGE_SIZE : truesize;
>   
> -		/* This happens when rx buffer size is underestimated
> -		 * or headroom is not enough because of the buffer
> -		 * was refilled before XDP is set. This should only
> -		 * happen for the first several packets, so we don't
> -		 * care much about its performance.
> +		/* This happens when headroom is not enough because
> +		 * of the buffer was prefilled before XDP is set.
> +		 * This should only happen for the first several packets.
> +		 * In fact, vq reset can be used here to help us clean up
> +		 * the prefilled buffers, but many existing devices do not
> +		 * support it, and we don't want to bother users who are
> +		 * using xdp normally.
>   		 */
> -		if (unlikely(num_buf > 1 ||
> -			     headroom < virtnet_get_headroom(vi))) {
> +		if (!xdp_prog->aux->xdp_has_frags &&
> +		    (num_buf > 1 || headroom < virtnet_get_headroom(vi))) {
>   			/* linearize data for XDP */
>   			xdp_page = xdp_linearize_page(rq, &num_buf,
>   						      page, offset,
> @@ -1084,17 +1092,26 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>   			if (!xdp_page)
>   				goto err_xdp;
>   			offset = VIRTIO_XDP_HEADROOM;
> +		} else if (unlikely(headroom < virtnet_get_headroom(vi))) {


I believe we need to check xdp_prog->aux->xdp_has_frags at least since 
this may not work if it needs more than one frags?

Btw, I don't see a reason why we can't reuse xdp_linearize_page(), (we 
probably don't need error is the buffer exceeds PAGE_SIZE).

Other looks good.

Thanks


> +			if ((VIRTIO_XDP_HEADROOM + len + tailroom) > PAGE_SIZE)
> +				goto err_xdp;
> +
> +			xdp_page = alloc_page(GFP_ATOMIC);
> +			if (!xdp_page)
> +				goto err_xdp;
> +
> +			memcpy(page_address(xdp_page) + VIRTIO_XDP_HEADROOM,
> +			       page_address(page) + offset, len);
> +			frame_sz = PAGE_SIZE;
> +			offset = VIRTIO_XDP_HEADROOM;
>   		} else {
>   			xdp_page = page;
>   		}
> -
> -		/* Allow consuming headroom but reserve enough space to push
> -		 * the descriptor on if we get an XDP_TX return code.
> -		 */
>   		data = page_address(xdp_page) + offset;
> -		xdp_init_buff(&xdp, frame_sz - vi->hdr_len, &rq->xdp_rxq);
> -		xdp_prepare_buff(&xdp, data - VIRTIO_XDP_HEADROOM + vi->hdr_len,
> -				 VIRTIO_XDP_HEADROOM, len - vi->hdr_len, true);
> +		err = virtnet_build_xdp_buff_mrg(dev, vi, rq, &xdp, data, len, frame_sz,
> +						 &num_buf, &xdp_frags_truesz, stats);
> +		if (unlikely(err))
> +			goto err_xdp_frags;
>   
>   		act = bpf_prog_run_xdp(xdp_prog, &xdp);
>   		stats->xdp_packets++;
> @@ -1190,6 +1207,17 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>   				__free_pages(xdp_page, 0);
>   			goto err_xdp;
>   		}
> +err_xdp_frags:
> +		shinfo = xdp_get_shared_info_from_buff(&xdp);
> +
> +		if (unlikely(xdp_page != page))
> +			__free_pages(xdp_page, 0);
> +
> +		for (i = 0; i < shinfo->nr_frags; i++) {
> +			xdp_page = skb_frag_page(&shinfo->frags[i]);
> +			put_page(xdp_page);
> +		}
> +		goto err_xdp;
>   	}
>   	rcu_read_unlock();
>   


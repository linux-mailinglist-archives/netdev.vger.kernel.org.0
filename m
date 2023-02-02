Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68E29688537
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 18:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232280AbjBBRRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 12:17:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232218AbjBBRRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 12:17:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0538712E2
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 09:16:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675358208;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uy+Vya/fYh3PSRar8kQjLgK1zcHNT7rb/JLZXSZVFNA=;
        b=KfciQNzR8Gk5C1feiHyoKNdx36rbZx9M+AJc6gm1xmnYs+PRZXLRhpyL/7dvZ4hAZiw2Vh
        YsYQQ+Wf9svjMKYxNjEcoDiDWNKo5FrZpMcmQDnsDJnYPnWp7LwTZz/pa+hs0fJIYHsEYQ
        IUnKIC67HxqlNTOV4YXUPKJCMLj6GIw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-288-g3H-RpNXPqCX3PvB5_kG7Q-1; Thu, 02 Feb 2023 12:16:47 -0500
X-MC-Unique: g3H-RpNXPqCX3PvB5_kG7Q-1
Received: by mail-wr1-f72.google.com with SMTP id e9-20020a5d6d09000000b002c172f173a9so354618wrq.17
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 09:16:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uy+Vya/fYh3PSRar8kQjLgK1zcHNT7rb/JLZXSZVFNA=;
        b=WHTwXeJp2qLhB+k3BIjwAnRCZUBMgYTpIubQaghV1LK7iBmKMJxHIOzoUWX8ww99Ci
         kD1FbdeGGcYzgAgDgwwfzwEZgR/fZxeFBmRCMMBTx+769MxAdmJ6mkUmME2adQUnpEaA
         Mc6cN3WDEvtanEpCrL/NqoItdrU2DWzDyZUA8BmbNF5ZMa6gUXnm3nULOF8jKbCWrmMM
         5iXd52JrhFGXqq3M7oeiBff25Em1AYdZgi95zArSnn8exPkqLuec98AytPniC4x2hbgn
         9x9lCoMifKynzca0N+B5fKqDN/TLaOlVVrEUoK6HY9rH4jZAjFMGBMRDUd1ow0bh2LxI
         kpGw==
X-Gm-Message-State: AO0yUKXPr+pLff8p7/ZMAjOGt1NkwBRNpOW/4GOW7/t/JcpUGBgnV6k6
        VjdOncpp//ZkSv9OHDt55/aGucyNFxLdEsHd/t1nFxulrmQYo/qUum6I2yXBISCZ35SGlBHSam0
        4Gyz89HSWf0nFcrGw
X-Received: by 2002:a5d:678e:0:b0:2bc:aa67:28fb with SMTP id v14-20020a5d678e000000b002bcaa6728fbmr5237726wru.49.1675358206355;
        Thu, 02 Feb 2023 09:16:46 -0800 (PST)
X-Google-Smtp-Source: AK7set99wHFHlz7JJlOEHJxXx69qk5APn0sS5AATVtKlYWnjhoL70/xNO1BtCMLkdGIqpqEnGGDDLg==
X-Received: by 2002:a5d:678e:0:b0:2bc:aa67:28fb with SMTP id v14-20020a5d678e000000b002bcaa6728fbmr5237705wru.49.1675358206151;
        Thu, 02 Feb 2023 09:16:46 -0800 (PST)
Received: from redhat.com ([2.52.156.122])
        by smtp.gmail.com with ESMTPSA id t10-20020adff60a000000b002bbddb89c71sm12704wrp.67.2023.02.02.09.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 09:16:45 -0800 (PST)
Date:   Thu, 2 Feb 2023 12:16:40 -0500
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
Subject: Re: [PATCH 18/33] virtio_net: receive_merageable() use
 virtnet_xdp_handler()
Message-ID: <20230202121547-mutt-send-email-mst@kernel.org>
References: <20230202110058.130695-1-xuanzhuo@linux.alibaba.com>
 <20230202110058.130695-19-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202110058.130695-19-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 07:00:43PM +0800, Xuan Zhuo wrote:
> receive_merageable() use virtnet_xdp_handler()
> 
> Meanwhile, support Multi Buffer XDP.
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

typo

> ---
>  drivers/net/virtio/main.c | 88 +++++++++++++++------------------------
>  1 file changed, 33 insertions(+), 55 deletions(-)
> 
> diff --git a/drivers/net/virtio/main.c b/drivers/net/virtio/main.c
> index d7a856bd8862..fb82035a0b7f 100644
> --- a/drivers/net/virtio/main.c
> +++ b/drivers/net/virtio/main.c
> @@ -483,8 +483,10 @@ int virtnet_xdp_handler(struct bpf_prog *xdp_prog, struct xdp_buff *xdp,
>  			unsigned int *xdp_xmit,
>  			struct virtnet_rq_stats *stats)
>  {
> +	struct skb_shared_info *shinfo;
>  	struct xdp_frame *xdpf;
> -	int err;
> +	struct page *xdp_page;
> +	int err, i;
>  	u32 act;
>  
>  	act = bpf_prog_run_xdp(xdp_prog, xdp);
> @@ -527,6 +529,13 @@ int virtnet_xdp_handler(struct bpf_prog *xdp_prog, struct xdp_buff *xdp,
>  		trace_xdp_exception(dev, xdp_prog, act);
>  		fallthrough;
>  	case XDP_DROP:
> +		if (xdp_buff_has_frags(xdp)) {
> +			shinfo = xdp_get_shared_info_from_buff(xdp);
> +			for (i = 0; i < shinfo->nr_frags; i++) {
> +				xdp_page = skb_frag_page(&shinfo->frags[i]);
> +				put_page(xdp_page);
> +			}
> +		}
>  		return VIRTNET_XDP_RES_DROP;
>  	}
>  }
> @@ -809,7 +818,7 @@ static int virtnet_build_xdp_buff_mrg(struct net_device *dev,
>  	unsigned int xdp_frags_truesz = 0;
>  	struct page *page;
>  	skb_frag_t *frag;
> -	int offset;
> +	int offset, i;
>  	void *ctx;
>  
>  	xdp_init_buff(xdp, frame_sz, &rq->xdp_rxq);
> @@ -842,7 +851,7 @@ static int virtnet_build_xdp_buff_mrg(struct net_device *dev,
>  				 dev->name, *num_buf,
>  				 virtio16_to_cpu(vi->vdev, hdr->num_buffers));
>  			dev->stats.rx_length_errors++;
> -			return -EINVAL;
> +			goto err;
>  		}
>  
>  		stats->bytes += len;
> @@ -861,7 +870,7 @@ static int virtnet_build_xdp_buff_mrg(struct net_device *dev,
>  			pr_debug("%s: rx error: len %u exceeds truesize %lu\n",
>  				 dev->name, len, (unsigned long)(truesize - room));
>  			dev->stats.rx_length_errors++;
> -			return -EINVAL;
> +			goto err;
>  		}
>  
>  		frag = &shinfo->frags[shinfo->nr_frags++];
> @@ -876,6 +885,14 @@ static int virtnet_build_xdp_buff_mrg(struct net_device *dev,
>  
>  	*xdp_frags_truesize = xdp_frags_truesz;
>  	return 0;
> +
> +err:
> +	for (i = 0; i < shinfo->nr_frags; i++) {
> +		page = skb_frag_page(&shinfo->frags[i]);
> +		put_page(page);
> +	}
> +
> +	return -EINVAL;
>  }
>  
>  static struct sk_buff *receive_mergeable(struct net_device *dev,
> @@ -919,13 +936,10 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>  	xdp_prog = rcu_dereference(rq->xdp_prog);
>  	if (xdp_prog) {
>  		unsigned int xdp_frags_truesz = 0;
> -		struct skb_shared_info *shinfo;
> -		struct xdp_frame *xdpf;
>  		struct page *xdp_page;
>  		struct xdp_buff xdp;
>  		void *data;
>  		u32 act;
> -		int i;
>  
>  		/* Transient failure which in theory could occur if
>  		 * in-flight packets from before XDP was enabled reach
> @@ -983,69 +997,33 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>  		err = virtnet_build_xdp_buff_mrg(dev, vi, rq, &xdp, data, len, frame_sz,
>  						 &num_buf, &xdp_frags_truesz, stats);
>  		if (unlikely(err))
> -			goto err_xdp_frags;
> +			goto err_xdp;
>  
> -		act = bpf_prog_run_xdp(xdp_prog, &xdp);
> -		stats->xdp_packets++;
> +		act = virtnet_xdp_handler(xdp_prog, &xdp, dev, xdp_xmit, stats);
>  
>  		switch (act) {
> -		case XDP_PASS:
> +		case VIRTNET_XDP_RES_PASS:
>  			if (unlikely(xdp_page != page))
>  				put_page(page);
> +
>  			head_skb = build_skb_from_xdp_buff(dev, vi, &xdp, xdp_frags_truesz);
>  			rcu_read_unlock();
>  			return head_skb;
> -		case XDP_TX:
> -			stats->xdp_tx++;
> -			xdpf = xdp_convert_buff_to_frame(&xdp);
> -			if (unlikely(!xdpf)) {
> -				netdev_dbg(dev, "convert buff to frame failed for xdp\n");
> -				goto err_xdp_frags;
> -			}
> -			err = virtnet_xdp_xmit(dev, 1, &xdpf, 0);
> -			if (unlikely(!err)) {
> -				xdp_return_frame_rx_napi(xdpf);
> -			} else if (unlikely(err < 0)) {
> -				trace_xdp_exception(vi->dev, xdp_prog, act);
> -				goto err_xdp_frags;
> -			}
> -			*xdp_xmit |= VIRTIO_XDP_TX;
> -			if (unlikely(xdp_page != page))
> -				put_page(page);
> -			rcu_read_unlock();
> -			goto xdp_xmit;
> -		case XDP_REDIRECT:
> -			stats->xdp_redirects++;
> -			err = xdp_do_redirect(dev, &xdp, xdp_prog);
> -			if (err)
> -				goto err_xdp_frags;
> -			*xdp_xmit |= VIRTIO_XDP_REDIR;
> +
> +		case VIRTNET_XDP_RES_CONSUMED:
>  			if (unlikely(xdp_page != page))
>  				put_page(page);
> +
>  			rcu_read_unlock();
>  			goto xdp_xmit;
> -		default:
> -			bpf_warn_invalid_xdp_action(vi->dev, xdp_prog, act);
> -			fallthrough;
> -		case XDP_ABORTED:
> -			trace_xdp_exception(vi->dev, xdp_prog, act);
> -			fallthrough;
> -		case XDP_DROP:
> -			goto err_xdp_frags;
> -		}
> -err_xdp_frags:
> -		if (unlikely(xdp_page != page))
> -			__free_pages(xdp_page, 0);
>  
> -		if (xdp_buff_has_frags(&xdp)) {
> -			shinfo = xdp_get_shared_info_from_buff(&xdp);
> -			for (i = 0; i < shinfo->nr_frags; i++) {
> -				xdp_page = skb_frag_page(&shinfo->frags[i]);
> +		case VIRTNET_XDP_RES_DROP:
> +			if (unlikely(xdp_page != page))
>  				put_page(xdp_page);
> -			}
> -		}
>  
> -		goto err_xdp;
> +			rcu_read_unlock();
> +			goto err_xdp;
> +		}
>  	}
>  	rcu_read_unlock();
>  
> -- 
> 2.32.0.3.g01195cf9f


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF1C36EA9B5
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 13:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbjDULzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 07:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbjDULzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 07:55:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45AD94C34
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 04:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682078058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zTCkyNCDw87y9YK54Qoc5ZrsrCxJ0WjYKBdepsVglWA=;
        b=AlY5BJ6H7dGiKWc4m+ux0bhIaACaVRDTO+4UmWHXJ6CyBm58WfDUHclOdY7IiTTBoVfRTe
        /9WajgMQUmElU7FwrDY18iV4i7hLiGzpnGn0v2iQ1x9qbyeKKnOMlaeXB43RbeegRrppC4
        twkjxbn6RI/6kgbisdKusKP1ytnS7nk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563-2RWiSI2ROAm4B5NGMnh4dQ-1; Fri, 21 Apr 2023 07:54:17 -0400
X-MC-Unique: 2RWiSI2ROAm4B5NGMnh4dQ-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f195129aa4so2372845e9.2
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 04:54:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682078056; x=1684670056;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zTCkyNCDw87y9YK54Qoc5ZrsrCxJ0WjYKBdepsVglWA=;
        b=AiKOHOvgbkvwetQYtf2RtZDMmtxwDtiAgWSsCejc/3UETCfadxABUzNy1tRZQUC5W3
         MMFvD92VR8ZiYm9xF04gKausIg/ML1qJsm9ogLa4WcXpxMKTLiz+hDeJZ+k8vdVkiVyL
         8n91hC87xE6htPAYUuDKkVo2WJlp/YfHs4MwXMDc+vYONAZkuM7EqBEEm1CG8mcYfAn2
         5QzafdzuLjanJyb2CuAAxm2rVPbf4UJvc2W1AK9WnalONf7P3y5JVEMm+hjdm4vpYhUY
         6ABvTBtq3u4k+YEA0AG5NytGzoZ4YzSnKoBftOrbBx94TrHxXzc26yABXEJRCy3kCNUF
         fxQA==
X-Gm-Message-State: AAQBX9ehUeubiItlGX6/t+iCkpJL5oYaf83hKhwVr0AzSf+d1CdNS3Xg
        kDMEV4yxg9uAwpQZVJXsKPcSw9fc4yUxzPuZloj5aeX1bwUu6hC3iWF1vBN4fmoeCenzMH+/GI8
        VEzFxarkd76n8eCyJ
X-Received: by 2002:a1c:7c13:0:b0:3f0:7f4f:2aa8 with SMTP id x19-20020a1c7c13000000b003f07f4f2aa8mr1670981wmc.9.1682078055921;
        Fri, 21 Apr 2023 04:54:15 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZPNvlOLr5DD66tuuC869SwSykh15XqDk/3/Joiay1rlLh5HihRAE02lGMlMCGfFwYa2F40+Q==
X-Received: by 2002:a1c:7c13:0:b0:3f0:7f4f:2aa8 with SMTP id x19-20020a1c7c13000000b003f07f4f2aa8mr1670958wmc.9.1682078055497;
        Fri, 21 Apr 2023 04:54:15 -0700 (PDT)
Received: from redhat.com ([2.55.62.70])
        by smtp.gmail.com with ESMTPSA id m2-20020a056000008200b002f53fa16239sm4216306wrx.103.2023.04.21.04.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 04:54:15 -0700 (PDT)
Date:   Fri, 21 Apr 2023 07:54:11 -0400
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
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next v2 05/14] virtio_net: introduce xdp res enums
Message-ID: <20230421075119-mutt-send-email-mst@kernel.org>
References: <20230418065327.72281-1-xuanzhuo@linux.alibaba.com>
 <20230418065327.72281-6-xuanzhuo@linux.alibaba.com>
 <20230421025931-mutt-send-email-mst@kernel.org>
 <1682061840.4864874-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1682061840.4864874-1-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 21, 2023 at 03:24:00PM +0800, Xuan Zhuo wrote:
> On Fri, 21 Apr 2023 03:00:15 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > On Tue, Apr 18, 2023 at 02:53:18PM +0800, Xuan Zhuo wrote:
> > > virtnet_xdp_handler() is to process all the logic related to XDP. The
> > > caller only needs to care about how to deal with the buf. So this commit
> > > introduces new enums:
> > >
> > > 1. VIRTNET_XDP_RES_PASS: make skb by the buf
> > > 2. VIRTNET_XDP_RES_DROP: xdp return drop action or some error, caller
> > >    should release the buf
> > > 3. VIRTNET_XDP_RES_CONSUMED: xdp consumed the buf, the caller doesnot to
> > >    do anything
> > >
> > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> >
> >
> > I am not excited about using virtio specific enums then translating
> > to standard ones.
> 
> 
> My fault, my expression is not very complete.
> 
> This is not a replacement, but just want to say, there are only three cases of
> virtnet_xdp_handler. Caller only needs to handle this three cases. Instead
> of paying attention to the detailed return results of XDP.
> 
> In addition, virtnet_xdp_handler returns XDP_TX, but in fact, the work of XDP_TX
> is already done in Virtnet_xdp_handler. Caller does not need to do anything for
> XDP_TX, giving people a feeling, XDP_TX does not need to be processed. I think
> it is not good.
> 
> Thanks.

I don't really get it, sorry. If it's possible to stick to
XDP return codes, that is preferable.

> 
> 
> >
> > > ---
> > >  drivers/net/virtio_net.c | 42 ++++++++++++++++++++++++++--------------
> > >  1 file changed, 27 insertions(+), 15 deletions(-)
> > >
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index 0fa64c314ea7..4dfdc211d355 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -301,6 +301,15 @@ struct padded_vnet_hdr {
> > >  	char padding[12];
> > >  };
> > >
> > > +enum {
> > > +	/* xdp pass */
> > > +	VIRTNET_XDP_RES_PASS,
> > > +	/* drop packet. the caller needs to release the page. */
> > > +	VIRTNET_XDP_RES_DROP,
> > > +	/* packet is consumed by xdp. the caller needs to do nothing. */
> > > +	VIRTNET_XDP_RES_CONSUMED,
> > > +};
> > > +
> > >  static void virtnet_rq_free_unused_buf(struct virtqueue *vq, void *buf);
> > >  static void virtnet_sq_free_unused_buf(struct virtqueue *vq, void *buf);
> > >
> > > @@ -803,14 +812,14 @@ static int virtnet_xdp_handler(struct bpf_prog *xdp_prog, struct xdp_buff *xdp,
> > >
> > >  	switch (act) {
> > >  	case XDP_PASS:
> > > -		return act;
> > > +		return VIRTNET_XDP_RES_PASS;
> > >
> > >  	case XDP_TX:
> > >  		stats->xdp_tx++;
> > >  		xdpf = xdp_convert_buff_to_frame(xdp);
> > >  		if (unlikely(!xdpf)) {
> > >  			netdev_dbg(dev, "convert buff to frame failed for xdp\n");
> > > -			return XDP_DROP;
> > > +			return VIRTNET_XDP_RES_DROP;
> > >  		}
> > >
> > >  		err = virtnet_xdp_xmit(dev, 1, &xdpf, 0);
> > > @@ -818,19 +827,20 @@ static int virtnet_xdp_handler(struct bpf_prog *xdp_prog, struct xdp_buff *xdp,
> > >  			xdp_return_frame_rx_napi(xdpf);
> > >  		} else if (unlikely(err < 0)) {
> > >  			trace_xdp_exception(dev, xdp_prog, act);
> > > -			return XDP_DROP;
> > > +			return VIRTNET_XDP_RES_DROP;
> > >  		}
> > > +
> > >  		*xdp_xmit |= VIRTIO_XDP_TX;
> > > -		return act;
> > > +		return VIRTNET_XDP_RES_CONSUMED;
> > >
> > >  	case XDP_REDIRECT:
> > >  		stats->xdp_redirects++;
> > >  		err = xdp_do_redirect(dev, xdp, xdp_prog);
> > >  		if (err)
> > > -			return XDP_DROP;
> > > +			return VIRTNET_XDP_RES_DROP;
> > >
> > >  		*xdp_xmit |= VIRTIO_XDP_REDIR;
> > > -		return act;
> > > +		return VIRTNET_XDP_RES_CONSUMED;
> > >
> > >  	default:
> > >  		bpf_warn_invalid_xdp_action(dev, xdp_prog, act);
> > > @@ -839,7 +849,7 @@ static int virtnet_xdp_handler(struct bpf_prog *xdp_prog, struct xdp_buff *xdp,
> > >  		trace_xdp_exception(dev, xdp_prog, act);
> > >  		fallthrough;
> > >  	case XDP_DROP:
> > > -		return XDP_DROP;
> > > +		return VIRTNET_XDP_RES_DROP;
> > >  	}
> > >  }
> > >
> > > @@ -987,17 +997,18 @@ static struct sk_buff *receive_small(struct net_device *dev,
> > >  		act = virtnet_xdp_handler(xdp_prog, &xdp, dev, xdp_xmit, stats);
> > >
> > >  		switch (act) {
> > > -		case XDP_PASS:
> > > +		case VIRTNET_XDP_RES_PASS:
> > >  			/* Recalculate length in case bpf program changed it */
> > >  			delta = orig_data - xdp.data;
> > >  			len = xdp.data_end - xdp.data;
> > >  			metasize = xdp.data - xdp.data_meta;
> > >  			break;
> > > -		case XDP_TX:
> > > -		case XDP_REDIRECT:
> > > +
> > > +		case VIRTNET_XDP_RES_CONSUMED:
> > >  			rcu_read_unlock();
> > >  			goto xdp_xmit;
> > > -		default:
> > > +
> > > +		case VIRTNET_XDP_RES_DROP:
> > >  			goto err_xdp;
> > >  		}
> > >  	}
> > > @@ -1324,18 +1335,19 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
> > >  		act = virtnet_xdp_handler(xdp_prog, &xdp, dev, xdp_xmit, stats);
> > >
> > >  		switch (act) {
> > > -		case XDP_PASS:
> > > +		case VIRTNET_XDP_RES_PASS:
> > >  			head_skb = build_skb_from_xdp_buff(dev, vi, &xdp, xdp_frags_truesz);
> > >  			if (unlikely(!head_skb))
> > >  				goto err_xdp_frags;
> > >
> > >  			rcu_read_unlock();
> > >  			return head_skb;
> > > -		case XDP_TX:
> > > -		case XDP_REDIRECT:
> > > +
> > > +		case VIRTNET_XDP_RES_CONSUMED:
> > >  			rcu_read_unlock();
> > >  			goto xdp_xmit;
> > > -		default:
> > > +
> > > +		case VIRTNET_XDP_RES_DROP:
> > >  			break;
> > >  		}
> > >  err_xdp_frags:
> > > --
> > > 2.32.0.3.g01195cf9f
> >


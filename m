Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0A076EA436
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 09:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbjDUHBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 03:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjDUHBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 03:01:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E611BC1
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 00:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682060423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lpiVqfxPDVOVyIcQKLUY3sjIFaYVM+b/8XYAogBT64g=;
        b=ZDje3k/bSBa2znrhumRD2qwlseq5/w7RL3BG6uSZrQ0Dajy69yFy99QAvh4dRpdrgg4OsG
        z4+x1oz3+fAnfBOMxq6lExuIGIIa3DAtd8EiTj7q2SrqB/se6Om5faX9bntOqAzBr76623
        XOon2BaOkxTABYM6AnHQwkRtRm4/Ny0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-121-mYkO_p3vN5--4LFXzw6vdA-1; Fri, 21 Apr 2023 03:00:22 -0400
X-MC-Unique: mYkO_p3vN5--4LFXzw6vdA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-2fbb99cb2easo435951f8f.1
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 00:00:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682060421; x=1684652421;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lpiVqfxPDVOVyIcQKLUY3sjIFaYVM+b/8XYAogBT64g=;
        b=jhnWQ4lcrFR0m4gXpo2AWsjk/iXEliwbBNNtZsvAHH0CPu4Sh7DZGq5WnouG38dJNU
         PkRl+cP2yQ525k+wfqShtvHjItaIyBTctlWdRp7Mg+YNAbyswn6YHmvdLX8At6EJcdYo
         dvPyHpfZG92tWMPKlpthy7Fkkvlzade5s2bxUkpwxY5N8U7zk18y5PYEj8YAu3WtqyQ3
         VsnUw7+lUHvJRkC3//ASFDazYwwJsAouigiOqK7iG6ChWsOA1TDZ3tGxmyQEI2bwqIBS
         5iUR82Wzkec7/R2d+icz4ruM8Ul9ImeFVxZp/f+Vl5m5Ufh4EO9VTGS/0a6T98VbFHOi
         lhqw==
X-Gm-Message-State: AAQBX9f80Rj0C8rPyfiynXejNr4+/R05TSxpLEf6xsD1pNntfTT5lOXJ
        WxfLVu3IqYxf0LkuKratBnxbHzRCYTLjLLAAR1Z/5/fW7jum825/tX77MHo6mYcTCdcVreqvpql
        J1Qt4TFrLAXTScpA2
X-Received: by 2002:a5d:508c:0:b0:2f4:bc68:3493 with SMTP id a12-20020a5d508c000000b002f4bc683493mr3137922wrt.34.1682060420655;
        Fri, 21 Apr 2023 00:00:20 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZscfyWPk0FUaFkFq8X9xGWbsfYMR49h0BahBp10uWnCx5uwQ3l78RWokX6He4VumLzicsf2A==
X-Received: by 2002:a5d:508c:0:b0:2f4:bc68:3493 with SMTP id a12-20020a5d508c000000b002f4bc683493mr3137896wrt.34.1682060420318;
        Fri, 21 Apr 2023 00:00:20 -0700 (PDT)
Received: from redhat.com ([2.55.62.70])
        by smtp.gmail.com with ESMTPSA id e22-20020a5d5956000000b003012030a0c6sm3732010wri.18.2023.04.21.00.00.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 00:00:19 -0700 (PDT)
Date:   Fri, 21 Apr 2023 03:00:15 -0400
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
Message-ID: <20230421025931-mutt-send-email-mst@kernel.org>
References: <20230418065327.72281-1-xuanzhuo@linux.alibaba.com>
 <20230418065327.72281-6-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418065327.72281-6-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 02:53:18PM +0800, Xuan Zhuo wrote:
> virtnet_xdp_handler() is to process all the logic related to XDP. The
> caller only needs to care about how to deal with the buf. So this commit
> introduces new enums:
> 
> 1. VIRTNET_XDP_RES_PASS: make skb by the buf
> 2. VIRTNET_XDP_RES_DROP: xdp return drop action or some error, caller
>    should release the buf
> 3. VIRTNET_XDP_RES_CONSUMED: xdp consumed the buf, the caller doesnot to
>    do anything
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>


I am not excited about using virtio specific enums then translating
to standard ones.

> ---
>  drivers/net/virtio_net.c | 42 ++++++++++++++++++++++++++--------------
>  1 file changed, 27 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 0fa64c314ea7..4dfdc211d355 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -301,6 +301,15 @@ struct padded_vnet_hdr {
>  	char padding[12];
>  };
>  
> +enum {
> +	/* xdp pass */
> +	VIRTNET_XDP_RES_PASS,
> +	/* drop packet. the caller needs to release the page. */
> +	VIRTNET_XDP_RES_DROP,
> +	/* packet is consumed by xdp. the caller needs to do nothing. */
> +	VIRTNET_XDP_RES_CONSUMED,
> +};
> +
>  static void virtnet_rq_free_unused_buf(struct virtqueue *vq, void *buf);
>  static void virtnet_sq_free_unused_buf(struct virtqueue *vq, void *buf);
>  
> @@ -803,14 +812,14 @@ static int virtnet_xdp_handler(struct bpf_prog *xdp_prog, struct xdp_buff *xdp,
>  
>  	switch (act) {
>  	case XDP_PASS:
> -		return act;
> +		return VIRTNET_XDP_RES_PASS;
>  
>  	case XDP_TX:
>  		stats->xdp_tx++;
>  		xdpf = xdp_convert_buff_to_frame(xdp);
>  		if (unlikely(!xdpf)) {
>  			netdev_dbg(dev, "convert buff to frame failed for xdp\n");
> -			return XDP_DROP;
> +			return VIRTNET_XDP_RES_DROP;
>  		}
>  
>  		err = virtnet_xdp_xmit(dev, 1, &xdpf, 0);
> @@ -818,19 +827,20 @@ static int virtnet_xdp_handler(struct bpf_prog *xdp_prog, struct xdp_buff *xdp,
>  			xdp_return_frame_rx_napi(xdpf);
>  		} else if (unlikely(err < 0)) {
>  			trace_xdp_exception(dev, xdp_prog, act);
> -			return XDP_DROP;
> +			return VIRTNET_XDP_RES_DROP;
>  		}
> +
>  		*xdp_xmit |= VIRTIO_XDP_TX;
> -		return act;
> +		return VIRTNET_XDP_RES_CONSUMED;
>  
>  	case XDP_REDIRECT:
>  		stats->xdp_redirects++;
>  		err = xdp_do_redirect(dev, xdp, xdp_prog);
>  		if (err)
> -			return XDP_DROP;
> +			return VIRTNET_XDP_RES_DROP;
>  
>  		*xdp_xmit |= VIRTIO_XDP_REDIR;
> -		return act;
> +		return VIRTNET_XDP_RES_CONSUMED;
>  
>  	default:
>  		bpf_warn_invalid_xdp_action(dev, xdp_prog, act);
> @@ -839,7 +849,7 @@ static int virtnet_xdp_handler(struct bpf_prog *xdp_prog, struct xdp_buff *xdp,
>  		trace_xdp_exception(dev, xdp_prog, act);
>  		fallthrough;
>  	case XDP_DROP:
> -		return XDP_DROP;
> +		return VIRTNET_XDP_RES_DROP;
>  	}
>  }
>  
> @@ -987,17 +997,18 @@ static struct sk_buff *receive_small(struct net_device *dev,
>  		act = virtnet_xdp_handler(xdp_prog, &xdp, dev, xdp_xmit, stats);
>  
>  		switch (act) {
> -		case XDP_PASS:
> +		case VIRTNET_XDP_RES_PASS:
>  			/* Recalculate length in case bpf program changed it */
>  			delta = orig_data - xdp.data;
>  			len = xdp.data_end - xdp.data;
>  			metasize = xdp.data - xdp.data_meta;
>  			break;
> -		case XDP_TX:
> -		case XDP_REDIRECT:
> +
> +		case VIRTNET_XDP_RES_CONSUMED:
>  			rcu_read_unlock();
>  			goto xdp_xmit;
> -		default:
> +
> +		case VIRTNET_XDP_RES_DROP:
>  			goto err_xdp;
>  		}
>  	}
> @@ -1324,18 +1335,19 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
>  		act = virtnet_xdp_handler(xdp_prog, &xdp, dev, xdp_xmit, stats);
>  
>  		switch (act) {
> -		case XDP_PASS:
> +		case VIRTNET_XDP_RES_PASS:
>  			head_skb = build_skb_from_xdp_buff(dev, vi, &xdp, xdp_frags_truesz);
>  			if (unlikely(!head_skb))
>  				goto err_xdp_frags;
>  
>  			rcu_read_unlock();
>  			return head_skb;
> -		case XDP_TX:
> -		case XDP_REDIRECT:
> +
> +		case VIRTNET_XDP_RES_CONSUMED:
>  			rcu_read_unlock();
>  			goto xdp_xmit;
> -		default:
> +
> +		case VIRTNET_XDP_RES_DROP:
>  			break;
>  		}
>  err_xdp_frags:
> -- 
> 2.32.0.3.g01195cf9f


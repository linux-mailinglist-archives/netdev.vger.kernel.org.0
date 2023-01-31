Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F54168257A
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 08:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbjAaHVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 02:21:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbjAaHVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 02:21:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A792FCF9
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 23:20:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675149656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T1jjbjw0DKFNiI/gseIz5DotmobYeFjyLrM25aY2Ma4=;
        b=aQczNFxYtVaHq+AWqAdL6jnViQEZGOV4Eae09KUWUK/PuNrXG3mdVoHrzzFe1Ok7gI155w
        0uf7tYpoDy281+bUSJbplrtRqA1jDADk5BhWKWc/2jXaXEHkxIAFbu/k0XqE6UauF1HoT/
        zgwjKaXgOw6VvmSH9/1etesIyj/V8Cc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-249-8xX71Z0QODuYyYAoCLZ60Q-1; Tue, 31 Jan 2023 02:20:54 -0500
X-MC-Unique: 8xX71Z0QODuYyYAoCLZ60Q-1
Received: by mail-wm1-f70.google.com with SMTP id k17-20020a05600c1c9100b003dd41ad974bso391283wms.3
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 23:20:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T1jjbjw0DKFNiI/gseIz5DotmobYeFjyLrM25aY2Ma4=;
        b=mFLWUfUngYN9bNzoPBba2D+pskeZMhDIzHEzKNNSSKMVMtDo6SLZLhxDIJPap2paA2
         7ybPoxrg9Gxka8GGkUV3oefHhLALVyDJn1bfmjq+NL97QodqtmWzwqRi41L/4kVI/la7
         IKyq+0zjuZd8LKBOxSA0BZdXXTGsa08dzNU/OhHTkJwG2+RizP5iWmFi7M6qaLwcFDN7
         s9HOON6tPJAw5fWX2IagH0LxbLYBKdguNDrWu5WLQIBTuTB3BL/TrjReq/NK/QZygaSA
         t7bylCl9TlAzWEDn69dhKsxBKNpmnn+7DvFstTDvq78eoxVvF7+fDJdNh98U63QjP/d1
         wAOg==
X-Gm-Message-State: AFqh2kq4sZBV5SVKKfaijgAQ3r5siQfEqO9lmw1q7COkiArpJ20bE9LU
        y8XY0qvnnDwfu9+NUzcBCgiHOfWHAevU1Lv/oXJ+bBkWyd73xSHgkGqWtTsZgaZ1ksrzHRsKSBE
        ShXAAARCpM2AVkS5g
X-Received: by 2002:a5d:4350:0:b0:2be:5366:8cdf with SMTP id u16-20020a5d4350000000b002be53668cdfmr32908498wrr.20.1675149653635;
        Mon, 30 Jan 2023 23:20:53 -0800 (PST)
X-Google-Smtp-Source: AMrXdXutBR/nB59S6wXluMHGWtXkCS+vQ4StwyxWo83gvyA6/hYBFxSm1mRPmAqiipSmnxtkNa2jqw==
X-Received: by 2002:a5d:4350:0:b0:2be:5366:8cdf with SMTP id u16-20020a5d4350000000b002be53668cdfmr32908488wrr.20.1675149653386;
        Mon, 30 Jan 2023 23:20:53 -0800 (PST)
Received: from redhat.com ([2.52.144.173])
        by smtp.gmail.com with ESMTPSA id j9-20020a5d6189000000b002c285b4d2b5sm769061wru.101.2023.01.30.23.20.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 23:20:52 -0800 (PST)
Date:   Tue, 31 Jan 2023 02:20:49 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Heng Qi <hengqi@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net-next] virtio-net: fix possible unsigned integer
 overflow
Message-ID: <20230131021758-mutt-send-email-mst@kernel.org>
References: <20230131034337.55445-1-hengqi@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131034337.55445-1-hengqi@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 11:43:37AM +0800, Heng Qi wrote:
> When the single-buffer xdp is loaded and after xdp_linearize_page()
> is called, *num_buf becomes 0 and (*num_buf - 1) may overflow into
> a large integer in virtnet_build_xdp_buff_mrg(), resulting in
> unexpected packet dropping.
> 
> Fixes: ef75cb51f139 ("virtio-net: build xdp_buff with multi buffers")
> Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

Given the confusion, just make num_buf an int?

> ---
>  drivers/net/virtio_net.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index aaa6fe9b214a..a8e9462903fa 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1007,6 +1007,9 @@ static int virtnet_build_xdp_buff_mrg(struct net_device *dev,
>  	xdp_prepare_buff(xdp, buf - VIRTIO_XDP_HEADROOM,
>  			 VIRTIO_XDP_HEADROOM + vi->hdr_len, len - vi->hdr_len, true);
>  
> +	if (!*num_buf)
> +		return 0;
> +
>  	if (*num_buf > 1) {
>  		/* If we want to build multi-buffer xdp, we need
>  		 * to specify that the flags of xdp_buff have the


This means truesize won't be set.

> @@ -1020,10 +1023,10 @@ static int virtnet_build_xdp_buff_mrg(struct net_device *dev,
>  		shinfo->xdp_frags_size = 0;
>  	}
>  
> -	if ((*num_buf - 1) > MAX_SKB_FRAGS)
> +	if (*num_buf > MAX_SKB_FRAGS + 1)
>  		return -EINVAL;

Admittedly this is cleaner.

>  
> -	while ((--*num_buf) >= 1) {
> +	while (--*num_buf) {

A bit more fragile, > 0 would be better.

>  		buf = virtqueue_get_buf_ctx(rq->vq, &len, &ctx);
>  		if (unlikely(!buf)) {
>  			pr_debug("%s: rx error: %d buffers out of %d missing\n",
> -- 
> 2.19.1.6.gb485710b


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE00764D832
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 10:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiLOJDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 04:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiLOJDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 04:03:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57C463D931
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 01:02:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671094977;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uwD8NOGTwYs5ieTi5qX1aPfmwnbaS+5RWWUvD/filRE=;
        b=WKcxcGnDrRGVCmEfnImlEQ8do2JO5IuRT1xQwQuqSEYiu5e5lHk0KRpiSK2XV2P974Db0t
        1pRSs8ZWCHaZMHONfZw+G0RtErmZ+zdf/3u7zz0FPUPl/xw9lcVeMuZ/y7KEcLHyk/x6GX
        yNKRonKdic+HL+2qGIRS3V/RYvAnlvg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-591-WR5pPJPXPcWHJExUPXFw7A-1; Thu, 15 Dec 2022 04:02:56 -0500
X-MC-Unique: WR5pPJPXPcWHJExUPXFw7A-1
Received: by mail-wm1-f71.google.com with SMTP id x10-20020a05600c420a00b003cfa33f2e7cso7610892wmh.2
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 01:02:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uwD8NOGTwYs5ieTi5qX1aPfmwnbaS+5RWWUvD/filRE=;
        b=BW5TlW65oZMq3U/lTLjudGBlxHuh2mFBEH7Qucxu7g0MpwULFE8+ori3nfbvp9q/vK
         TUf/gbfGi9tov97hxsUENfA4eXSFjSIfKH1PO+/jdCbbT+d2Z5NtQ72gF6NLaUtqohN7
         RVJa/Fg8V66nucXmxlr9OCZf1BVNm4z67Nvrht0HB8NTysuMO4SV0MlW3seMs0Ft0uly
         TSiDZhqcFfvuOt6fEDyUJVNs0UTUfG3J7TpRGvhCusupMtSX+KkJPxJ+nbARyw9SeMFF
         1AKk6+6dB21ddc8WsVbGrMRnDKKwnp87DGJDgHv3+ZPle669nkZMctGxarbvypXNxZU0
         sIJQ==
X-Gm-Message-State: ANoB5pnfMhRhJ9ofdK2ScyfBldvgW1QYBA5VZ8CTXlEEmcIBxUfHuyfe
        ZfodOgKqxcvdUBxeN5c0cl9AKgqlETiWBeSOWzr9trP/5ewYwFtPLNvCay2Fvif5QPygCxJ2trM
        5J3Xlw9BSbNtQBS9E
X-Received: by 2002:a05:6000:1290:b0:242:733b:af28 with SMTP id f16-20020a056000129000b00242733baf28mr22015728wrx.5.1671094975063;
        Thu, 15 Dec 2022 01:02:55 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7qzb9+a/uvtxVcEC9zmWpJUTR422PGn73vR3sy+XJdK14+q15lG471pPpuDffznLF34RdQqg==
X-Received: by 2002:a05:6000:1290:b0:242:733b:af28 with SMTP id f16-20020a056000129000b00242733baf28mr22015704wrx.5.1671094974758;
        Thu, 15 Dec 2022 01:02:54 -0800 (PST)
Received: from redhat.com ([2a02:14f:179:247f:e426:6c6e:c44d:93b])
        by smtp.gmail.com with ESMTPSA id x12-20020a5d650c000000b002415dd45320sm5151669wru.112.2022.12.15.01.02.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 01:02:54 -0800 (PST)
Date:   Thu, 15 Dec 2022 04:02:49 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH net V2] virtio-net: correctly enable callback during
 start_xmit
Message-ID: <20221215034740-mutt-send-email-mst@kernel.org>
References: <20221215032719.72294-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215032719.72294-1-jasowang@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 15, 2022 at 11:27:19AM +0800, Jason Wang wrote:
> Commit a7766ef18b33("virtio_net: disable cb aggressively") enables
> virtqueue callback via the following statement:
> 
>         do {
>            ......
> 	} while (use_napi && kick &&
>                unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
> 
> When NAPI is used and kick is false, the callback won't be enabled
> here. And when the virtqueue is about to be full, the tx will be
> disabled, but we still don't enable tx interrupt which will cause a TX
> hang. This could be observed when using pktgen with burst enabled.
> 
> Fixing this by trying to enable tx interrupt after we disable TX when
> we're not using napi or kick is false.
> 
> Fixes: a7766ef18b33 ("virtio_net: disable cb aggressively")
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
> The patch is needed for -stable.
> Changes since V1:
> - enable tx interrupt after we disable tx
> ---
>  drivers/net/virtio_net.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 86e52454b5b5..dcf3a536d78a 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1873,7 +1873,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
>  	 */
>  	if (sq->vq->num_free < 2+MAX_SKB_FRAGS) {
>  		netif_stop_subqueue(dev, qnum);
> -		if (!use_napi &&
> +		if ((!use_napi || !kick) &&
>  		    unlikely(!virtqueue_enable_cb_delayed(sq->vq))) {
>  			/* More just got used, free them then recheck. */
>  			free_old_xmit_skbs(sq, false);

This will work but the following lines are:

                       if (sq->vq->num_free >= 2+MAX_SKB_FRAGS) {
                                netif_start_subqueue(dev, qnum);
                                virtqueue_disable_cb(sq->vq);
                        }


and I thought we are supposed to keep callbacks enabled with napi?
One of the ideas of napi is to free on napi callback, not here
immediately.

I think it is easier to just do a separate branch here. Along the
lines of:

		if (use_napi) {
			if (unlikely(!virtqueue_enable_cb_delayed(sq->vq)))
				virtqueue_napi_schedule(napi, vq);
		} else {
			... old code ...
		}

also reduces chances of regressions on !napi (which is not well tested)
and keeps callbacks off while we free skbs.

No?


> -- 
> 2.25.1


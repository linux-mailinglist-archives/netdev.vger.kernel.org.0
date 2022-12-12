Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDD5649B1A
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 10:27:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbiLLJ1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 04:27:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbiLLJ0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 04:26:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D34BF74
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 01:25:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670837131;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0JyfgukxH8Bj5hg68NAqVbpkGDDDowiV1dBqHPtCnSU=;
        b=PTcS22OeoLpUoxtT8vsG6Hopy+44QTFAa0Uv9j2VFM5+gJnK6MjmuRkr+pxfjui/r/WvMC
        Tfq/QRkemtA0aPVzgrWvPSLudVDxnbkBVsvhAxi2+5UK7/qGzePhRb9tJ5YPaPMGqRQn5g
        VOz+BsvQ570C++Jub3qk8jU27K+VU4E=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-459-yk6aqCeZMLW39AIHhVFQYA-1; Mon, 12 Dec 2022 04:25:30 -0500
X-MC-Unique: yk6aqCeZMLW39AIHhVFQYA-1
Received: by mail-qk1-f199.google.com with SMTP id v7-20020a05620a0f0700b006faffce43b2so13268115qkl.9
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 01:25:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0JyfgukxH8Bj5hg68NAqVbpkGDDDowiV1dBqHPtCnSU=;
        b=qupb4U5pjDatTW2UAioVPTGIxrxrc4F0yEynXUvX681m0LRFHTsSN8QpWL40SX0oLk
         weGVkB3szZZkpPbG8abJ6DFShM+wsg05dcm/yn/O60kQL9NwPzhUNjqsBaUM7dzr0Pei
         gCdOhIbLgJU5qfsJQSoxvzrqYBcw9ME048vWCBP/rY/e+s2Ids6IOPuf1dULxUVVIYFu
         PnnvRm1NSrrxMG1ch2CmD+x8o1XjZ4jQi/vBYtWvde9Wdhqwy3QhUvGMmtSN3ogG+E6k
         zbgT+F8x/s9WG8y1nKE9p3Ru0pbPHSsR+/WRredv55n4dqM84Mji4DswukqXmFjbvwNs
         oTUA==
X-Gm-Message-State: ANoB5pm3ManWdl2F8M6eP4GH4xvIsi2MsdLlf0ZxULkTiwykMH3xZwG9
        Jy1BEz2OUVXEnycjGFLY5o+ZeaIPEg75Epd9scJtoO6cddesV6FWsVAD0e/ut5GZn9EaCU9d/VS
        OgLmbb2UwuuPoBshm
X-Received: by 2002:a05:6214:e6c:b0:4c7:7257:68a2 with SMTP id jz12-20020a0562140e6c00b004c7725768a2mr28389039qvb.15.1670837129719;
        Mon, 12 Dec 2022 01:25:29 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4lascigSsPr+SAq9gF053iSTVg49y6qJ3To4iG3pwTTJT3W+tds28QF20QeElvO/N/q72GZg==
X-Received: by 2002:a05:6214:e6c:b0:4c7:7257:68a2 with SMTP id jz12-20020a0562140e6c00b004c7725768a2mr28389027qvb.15.1670837129491;
        Mon, 12 Dec 2022 01:25:29 -0800 (PST)
Received: from redhat.com ([185.199.102.21])
        by smtp.gmail.com with ESMTPSA id bs33-20020a05620a472100b006b61b2cb1d2sm5556345qkb.46.2022.12.12.01.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 01:25:29 -0800 (PST)
Date:   Mon, 12 Dec 2022 04:25:22 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] virtio-net: correctly enable callback during
 start_xmit
Message-ID: <20221212042144-mutt-send-email-mst@kernel.org>
References: <20221212091029.54390-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212091029.54390-1-jasowang@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 12, 2022 at 05:10:29PM +0800, Jason Wang wrote:
> Commit a7766ef18b33("virtio_net: disable cb aggressively") enables
> virtqueue callback via the following statement:
> 
>         do {
>            ......
> 	} while (use_napi && kick &&
>                unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
> 
> This will cause a missing call to virtqueue_enable_cb_delayed() when
> kick is false. Fixing this by removing the checking of the kick from
> the condition to make sure callback is enabled correctly.
> 
> Fixes: a7766ef18b33 ("virtio_net: disable cb aggressively")
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
> The patch is needed for -stable.

stable rules don't allow for theoretical fixes. Was a problem observed?

> ---
>  drivers/net/virtio_net.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 86e52454b5b5..44d7daf0267b 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1834,8 +1834,8 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
>  
>  		free_old_xmit_skbs(sq, false);
>  
> -	} while (use_napi && kick &&
> -	       unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
> +	} while (use_napi &&
> +		 unlikely(!virtqueue_enable_cb_delayed(sq->vq)));
>

A bit more explanation pls.  kick simply means !netdev_xmit_more -
if it's false we know there will be another packet, then transmissing
that packet will invoke virtqueue_enable_cb_delayed. No?




  
>  	/* timestamp packet in software */
>  	skb_tx_timestamp(skb);
> -- 
> 2.25.1


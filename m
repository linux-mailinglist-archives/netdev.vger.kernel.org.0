Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43A2D5BBC38
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 08:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiIRG4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 02:56:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiIRG4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 02:56:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E3627DC0
        for <netdev@vger.kernel.org>; Sat, 17 Sep 2022 23:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663484209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sG9TyI7RoPnjwpaWhat0D0T3kJaBGLVdSTh5KbAUUcc=;
        b=gVMvHDdRwceicYYF4WIdffpUzy3ffXzLyCmznZ9BveJ5wt3nrPF/hB9QZxB15lmh8fa4Za
        u0CQ5z2XSff9mt+8s5f7ISxTIKO3BrtiWs8ZZTLeo/KUNQLVYI5mv/yt4Z2c2YPSjJyCEB
        uAD2K3wicc5OyChB6mGBmDclRQd4H0M=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-619-DUtWgtxwO86s1HW3JHLdig-1; Sun, 18 Sep 2022 02:56:48 -0400
X-MC-Unique: DUtWgtxwO86s1HW3JHLdig-1
Received: by mail-wm1-f70.google.com with SMTP id p24-20020a05600c1d9800b003b4b226903dso2613623wms.4
        for <netdev@vger.kernel.org>; Sat, 17 Sep 2022 23:56:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=sG9TyI7RoPnjwpaWhat0D0T3kJaBGLVdSTh5KbAUUcc=;
        b=NwNMMjnQ5nju9PJ8j91aUFfq2L2f45kMAxJWQQhbTkFG78XXM7t0hkQwGhyWYLH4IN
         TJnpxsoxIv057kiwykaKNOjVQoJldkxapLbqRB87abnynqXSOWWC9hfVxWwccAIhIiFD
         +cJqRZarCA7xGqewEp8CrLbycX9IGMAeoJByhgJC31uYLb8H/FWX2nLBk11nzXRsdYzv
         6nxtuWGiLy7x4u8Ny/OSsP42tf4+bpsKL1IxfyWVW1K2DalMnFmFN7ipS/xzcFHd+0Jt
         3igEmRVZCOiMJnjQTAJA65LJtgiIm0JeWQgMvsLRnj+dFn8gGy26HIMWt69NfCvf8Jfp
         6N/g==
X-Gm-Message-State: ACrzQf0Rj+jvlBhk0dWP9plqiWfccJVSFnjL1GhylchldzLRhLNWsKau
        fqWpVnR6aF3YQrHPSiyUTaBMGizIoG3GMDYEkVhW1PpnQf3Hrokdvkw8xbNjHb6ifwIwH1pVXNs
        rzJ3yQYg3OpU6Nezx
X-Received: by 2002:a05:600c:3d0e:b0:3b4:9bd1:10be with SMTP id bh14-20020a05600c3d0e00b003b49bd110bemr8322599wmb.101.1663484207096;
        Sat, 17 Sep 2022 23:56:47 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5iIUW7rsfRxmxgbyvogqw0ojEaNVttP8YBNjx7GPrB3E7FfRzWRD1uIBXkiE/5kZG+Pd1Ykw==
X-Received: by 2002:a05:600c:3d0e:b0:3b4:9bd1:10be with SMTP id bh14-20020a05600c3d0e00b003b49bd110bemr8322576wmb.101.1663484206815;
        Sat, 17 Sep 2022 23:56:46 -0700 (PDT)
Received: from redhat.com ([2.52.4.6])
        by smtp.gmail.com with ESMTPSA id t12-20020a05600c128c00b003b4931eb435sm8312339wmd.26.2022.09.17.23.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Sep 2022 23:56:46 -0700 (PDT)
Date:   Sun, 18 Sep 2022 02:56:41 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     junbo4242@gmail.com
Cc:     Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] Do not name control queue for virtio-net
Message-ID: <20220918025033-mutt-send-email-mst@kernel.org>
References: <20220917092857.3752357-1-junbo4242@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220917092857.3752357-1-junbo4242@gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 17, 2022 at 09:28:57AM +0000, junbo4242@gmail.com wrote:
> From: Junbo <junbo4242@gmail.com>
> 
> In virtio drivers, the control queue always named <virtioX>-config.
> 
> Signed-off-by: Junbo <junbo4242@gmail.com>

I don't think that's right. config is the config interrupt.



> ---
>  drivers/net/virtio_net.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 9cce7dec7366..0b3e74cfe201 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3469,7 +3469,8 @@ static int virtnet_find_vqs(struct virtnet_info *vi)
>  	/* Parameters for control virtqueue, if any */
>  	if (vi->has_cvq) {
>  		callbacks[total_vqs - 1] = NULL;
> -		names[total_vqs - 1] = "control";
> +		/* control virtqueue always named <virtioX>-config */
> +		names[total_vqs - 1] = "";
>  	}
>  
>  	/* Allocate/initialize parameters for send/receive virtqueues */
> -- 
> 2.31.1


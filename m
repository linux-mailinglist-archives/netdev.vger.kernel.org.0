Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC475ACC71
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 09:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235337AbiIEHU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 03:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236482AbiIEHTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 03:19:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD1742AED
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 00:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662362133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hzFuvUdPT4weoAmQZYG6aUVzxxQfH1SK+qmfNddDCPs=;
        b=ZI+1QD149QX4K7P/ghPB47+bDb6OjnTFQRqlIvbjp5cRtz//Xsl5RHMlulemuGLTvjfTIO
        JiZ5CG3EIX2izWPwcPveZl9AaUPdfMMDklJV5O+xUxUvX3liSxhmHFD/cS4NXlQ5ROf+5e
        1vmZa6HPORtObafrOJOVPBdYvzE8wNk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-275-ulHzWy9IN_mFNQpw3sjrrg-1; Mon, 05 Sep 2022 03:15:29 -0400
X-MC-Unique: ulHzWy9IN_mFNQpw3sjrrg-1
Received: by mail-wm1-f69.google.com with SMTP id ay27-20020a05600c1e1b00b003a5bff0df8dso6039607wmb.0
        for <netdev@vger.kernel.org>; Mon, 05 Sep 2022 00:15:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=hzFuvUdPT4weoAmQZYG6aUVzxxQfH1SK+qmfNddDCPs=;
        b=avN7F6HqibGVHyCv0UT7C3qAID5xUSzBKhHEiY/BkcLQvqgifmk+l62QZP00oOkaSW
         VD/wU6Gp8xCog/fGoXHysMjD2aztTEmpao6YDIhBlM7lM3o/ZtD2GZ6yygjjD7yseHUT
         bMiRi3QhNJSAlTTtjdBsJhNkS5jDNaN9yhyH+NdYZPUAkgGwpVcTbvf4XvvEQbPiutrl
         Or3VkZ/Xfp4LYy3CyJtpS/sAqpZ4oBWxL5Bwcjm3/NsA8uZRiTpuckswh6ugznV9lCBA
         NdlBd08SuR3tlpDXFnChS/1U6NuI3r64b++YG1FbpJ8qs6LBiuBmhLJX5mTMUpCC8ZT9
         reVA==
X-Gm-Message-State: ACgBeo1EenBTpRT1wb8SGFoTUnR56YUHFeQxDegl/OshuReWTqOtUGJb
        vcBaMCLThPpHTS483ePKzRc8M4gwe58DD4ekwwaOlh18kzvelYOQh+3DsIrtFkiiEOFQzVGossK
        eLpgg+vWI0MLApqNe
X-Received: by 2002:a7b:c844:0:b0:3a9:70d2:bf23 with SMTP id c4-20020a7bc844000000b003a970d2bf23mr9738275wml.165.1662362128131;
        Mon, 05 Sep 2022 00:15:28 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7EtktGfU9VLNtKjgqj6Ye1h1XLW2E8fwnYaZd3O3gu/FYxDv2bAYX99j93n4GzCIeqkxwzdw==
X-Received: by 2002:a7b:c844:0:b0:3a9:70d2:bf23 with SMTP id c4-20020a7bc844000000b003a970d2bf23mr9738258wml.165.1662362127953;
        Mon, 05 Sep 2022 00:15:27 -0700 (PDT)
Received: from redhat.com ([2.52.135.118])
        by smtp.gmail.com with ESMTPSA id az19-20020a05600c601300b003a342933727sm17118233wmb.3.2022.09.05.00.15.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 00:15:27 -0700 (PDT)
Date:   Mon, 5 Sep 2022 03:15:24 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, gautam.dawar@xilinx.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] virtio-net: add cond_resched() to the command
 waiting loop
Message-ID: <20220905031405-mutt-send-email-mst@kernel.org>
References: <20220905045341.66191-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220905045341.66191-1-jasowang@redhat.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 05, 2022 at 12:53:41PM +0800, Jason Wang wrote:
> Adding cond_resched() to the command waiting loop for a better
> co-operation with the scheduler. This allows to give CPU a breath to
> run other task(workqueue) instead of busy looping when preemption is
> not allowed.
> 
> What's more important. This is a must for some vDPA parent to work
> since control virtqueue is emulated via a workqueue for those parents.
> 
> Fixes: bda324fd037a ("vdpasim: control virtqueue support")

That's a weird commit to fix. so it fixes the simulator?

> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/net/virtio_net.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index ece00b84e3a7..169368365d6a 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -2000,8 +2000,10 @@ static bool virtnet_send_command(struct virtnet_info *vi, u8 class, u8 cmd,
>  	 * into the hypervisor, so the request should be handled immediately.
>  	 */
>  	while (!virtqueue_get_buf(vi->cvq, &tmp) &&
> -	       !virtqueue_is_broken(vi->cvq))
> +	       !virtqueue_is_broken(vi->cvq)) {
> +		cond_resched();
>  		cpu_relax();
> +	}

with cond_resched do we still need cpu_relax?

>  	return vi->ctrl->status == VIRTIO_NET_OK;
>  }
> -- 
> 2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7968760191D
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 22:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbiJQUNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 16:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbiJQUMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 16:12:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6907CAB9
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 13:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666037393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tFELe6aznTe/GTRkqn1WfamvdAxLX3z1de1HiNewbYI=;
        b=Wj+6L4Df5q/feO9iFPD0eqllWcqqp64WwmwnuOXeaUrJuga50B0q285rL6Bnx1acwTp1GA
        nKS1rXTYTpcIovmvwk5Or0iAQoEqNNBOLTicIOVhr0ViWbai5/8xyWQ6KY0CTdc+KSMrIY
        pGWv+gCkhUZfDV9GXvNK/1+MUv8nRwQ=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-173-Wv8Ojd0iPEmF4okuzqp4aQ-1; Mon, 17 Oct 2022 16:09:52 -0400
X-MC-Unique: Wv8Ojd0iPEmF4okuzqp4aQ-1
Received: by mail-ej1-f70.google.com with SMTP id hc43-20020a17090716ab00b0078e28567ffbso3525665ejc.15
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 13:09:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tFELe6aznTe/GTRkqn1WfamvdAxLX3z1de1HiNewbYI=;
        b=HmJdQPrgwm5Qydxs7pS7FFILmx3lRnd2B3FSNvZBt5g7W2YvrTqWA1pdc6K2rmRQB3
         dQJAJ9Otl+mDitHTzkqzLjKGtwDlonVUqT1m0j7HDABjZ0z+8mgHKs7dahq8vwBMpmB0
         HN10JsLUkN349FN3wsVcu8SjjaRQ7n+4KhoeucuJwIbvG47MdCrinyEx07nFe87gFHgF
         orbJQvBlN/+55b8zQqA7m/svlQVZptELj2y02raixA3gd09iMc6auQ9SiAYCi1QtBLmd
         0rZh8SmFUf448ifyboRzITDBdT9AJLQ+nteXyuRknYrr5GITq/+sZinMJlUOc3nfxkqh
         bgnQ==
X-Gm-Message-State: ACrzQf3ORum+TE3oSRbbPNvksPSN5ZKeNcVeaOxaB0eqYtGMKyMCD/QV
        zUsQkepXg4qt4lQlG+5H3dE/B4ir9eVzk47/jWG8CtbI3JlW20/AiALYMCm57go9nu6157huY18
        /+i6Dv7dDyWMZ0IES
X-Received: by 2002:a17:906:3852:b0:78d:b3d2:97a9 with SMTP id w18-20020a170906385200b0078db3d297a9mr9642349ejc.565.1666037390721;
        Mon, 17 Oct 2022 13:09:50 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6Q6w0Yd3Ly3IvBoaGPiiCRRxkBu07y2HUssk6yJS+lWQ7Ff2UU9VnF10nTdkEX3BV7i7IJcA==
X-Received: by 2002:a17:906:3852:b0:78d:b3d2:97a9 with SMTP id w18-20020a170906385200b0078db3d297a9mr9642339ejc.565.1666037390474;
        Mon, 17 Oct 2022 13:09:50 -0700 (PDT)
Received: from redhat.com ([2.54.172.104])
        by smtp.gmail.com with ESMTPSA id y18-20020aa7d512000000b0044657ecfbb5sm7794413edq.13.2022.10.17.13.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 13:09:49 -0700 (PDT)
Date:   Mon, 17 Oct 2022 16:09:46 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, gautam.dawar@xilinx.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] virtio-net: add cond_resched() to the command
 waiting loop
Message-ID: <20221017160724-mutt-send-email-mst@kernel.org>
References: <20220905045341.66191-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220905045341.66191-1-jasowang@redhat.com>
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
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
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

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
>  
>  	return vi->ctrl->status == VIRTIO_NET_OK;
>  }
> -- 
> 2.25.1


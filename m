Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D20984CFAFB
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 11:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235134AbiCGKYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 05:24:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239530AbiCGKW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 05:22:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7782A5F67
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 02:00:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646647227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A0eAGIa8ZFoiGy0ltp+n8ALS+KZeFMfXfRLbv+BRamg=;
        b=isLMCGR2fndzFSbesRYIQbZavvAJpV4kWPPHzESwELb+pi7/hzimzk9qSIYgVjT1AWPQmi
        HEc74jIBE2JEYZ1FykH4VmrMXoV84xhOZ8bxwPnlqwPhxNoLMJSKECUOf84Zv8SRoZ0Va2
        EfgkCehn9TI6s7+AHXKbI8llko3YR+8=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-550-BdLukt2fNxOsYF1r8qyL0g-1; Mon, 07 Mar 2022 05:00:25 -0500
X-MC-Unique: BdLukt2fNxOsYF1r8qyL0g-1
Received: by mail-ej1-f70.google.com with SMTP id ga31-20020a1709070c1f00b006cec400422fso6731164ejc.22
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 02:00:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=A0eAGIa8ZFoiGy0ltp+n8ALS+KZeFMfXfRLbv+BRamg=;
        b=lH2AzOCvWR5U5WwSQWdKXzknZ0XZRlkkFD7XZNAqYJcp8Nm2XIG0/uOtk+/Aumm9aP
         deJVcnXTI44znVZY1MfbCkpjrbVG7h9kJ7Jdt6MF3Wztw85pcOEnF9ZZVpIjrrQ/Iohe
         XVCPouJpjkvEAfmzl+heL+mkSsCjezZMZYg1ae2UXTYtGmG6lPNu50OwmdvZLbfQn4dg
         4UibgRFztIw3f+8hwOgADhvFvKaFVMk8zI4MCo/1M9DoPkzp6AK8AbpWGP3SJNI25zfH
         HCwjOMIOYlIVzCdoDFo3Y1CTyY0vJWQZMbFUK9IK4kSIByZZu1IITiGiu+hhHMIC2Dxz
         jh9Q==
X-Gm-Message-State: AOAM530mL/50rR8iVBBmm4PKJHeJU189kjJkhU0bcrMoLSH/nYIJ6XEn
        4PK1NlAGkreiU1Dms9FFCp4cjwKEYih1XVOccvKF48aUq0UOKs40Uv/ATAENJFNZ5mX6meInAwm
        NUsucwmlKIHyZEsho
X-Received: by 2002:a50:9d8a:0:b0:410:d303:8af5 with SMTP id w10-20020a509d8a000000b00410d3038af5mr10365896ede.371.1646647223979;
        Mon, 07 Mar 2022 02:00:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyKtnzgZGNOoEz8OAiIExnA/bdilkwHBohftbq+PKv8FwwC5RapOUy2aAve0Y32kBXGfJ6ItQ==
X-Received: by 2002:a50:9d8a:0:b0:410:d303:8af5 with SMTP id w10-20020a509d8a000000b00410d3038af5mr10365886ede.371.1646647223740;
        Mon, 07 Mar 2022 02:00:23 -0800 (PST)
Received: from redhat.com ([2.55.138.228])
        by smtp.gmail.com with ESMTPSA id i6-20020a17090685c600b006daecf0b350sm2880444ejy.75.2022.03.07.02.00.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 02:00:23 -0800 (PST)
Date:   Mon, 7 Mar 2022 05:00:20 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH vhost] virtio_net: fix build warnings
Message-ID: <20220307045948-mutt-send-email-mst@kernel.org>
References: <20220307094042.22180-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220307094042.22180-1-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 07, 2022 at 05:40:42PM +0800, Xuan Zhuo wrote:
> These warnings appear on some platforms (arm multi_v7_defconfig). This
> patch fixes these warnings.
> 
> drivers/net/virtio_net.c: In function 'virtnet_rx_vq_reset':
> drivers/net/virtio_net.c:1823:63: warning: format '%ld' expects argument of type 'long int', but argument 3 has type 'int' [-Wformat=]
>  1823 |                    "reset rx reset vq fail: rx queue index: %ld err: %d\n",
>       |                                                             ~~^
>       |                                                               |
>       |                                                               long int
>       |                                                             %d
>  1824 |                    rq - vi->rq, err);
>       |                    ~~~~~~~~~~~
>       |                       |
>       |                       int
> drivers/net/virtio_net.c: In function 'virtnet_tx_vq_reset':
> drivers/net/virtio_net.c:1873:63: warning: format '%ld' expects argument of type 'long int', but argument 3 has type 'int' [-Wformat=]
>  1873 |                    "reset tx reset vq fail: tx queue index: %ld err: %d\n",
>       |                                                             ~~^
>       |                                                               |
>       |                                                               long int
>       |                                                             %d
>  1874 |                    sq - vi->sq, err);
>       |                    ~~~~~~~~~~~
>       |                       |
>       |                       int
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

I squashed this into the problematic patch. Take a look
at my tree to verify all's well pls.

> ---
>  drivers/net/virtio_net.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 1fa2d632a994..4d629d1ea894 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1820,7 +1820,7 @@ static int virtnet_rx_vq_reset(struct virtnet_info *vi,
>  
>  err:
>  	netdev_err(vi->dev,
> -		   "reset rx reset vq fail: rx queue index: %ld err: %d\n",
> +		   "reset rx reset vq fail: rx queue index: %td err: %d\n",
>  		   rq - vi->rq, err);
>  	virtnet_napi_enable(rq->vq, &rq->napi);
>  	return err;
> @@ -1870,7 +1870,7 @@ static int virtnet_tx_vq_reset(struct virtnet_info *vi,
>  
>  err:
>  	netdev_err(vi->dev,
> -		   "reset tx reset vq fail: tx queue index: %ld err: %d\n",
> +		   "reset tx reset vq fail: tx queue index: %td err: %d\n",
>  		   sq - vi->sq, err);
>  	virtnet_napi_tx_enable(vi, sq->vq, &sq->napi);
>  	return err;
> -- 
> 2.31.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64FAC60CB50
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 13:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbiJYLzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 07:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbiJYLzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 07:55:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472D910052
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 04:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666698925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=60KoSEJtdyP4csO4prhLVlSmVMFXsv78bMTFXEfeup0=;
        b=gSCy4ZZelOlISG9husTb7KTBqu7M+TAqt4u1dk3EKTjPYUWKQVgLMStQfCal2so5uMBBXf
        tSIx1d1WsPz7b+XMRyzFTI4zC6xowF6wWnDo+IxlPsvrUoZaX+JN+/epuTtYOIklSB+yOT
        28+r54bs4IYTUReDFNW+RvbRv1mwLB4=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-553-zB1K1m85MLCQidoJ7LPoaA-1; Tue, 25 Oct 2022 07:55:23 -0400
X-MC-Unique: zB1K1m85MLCQidoJ7LPoaA-1
Received: by mail-qv1-f69.google.com with SMTP id ok8-20020a0562143c8800b004b07e9ca57eso6856734qvb.19
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 04:55:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=60KoSEJtdyP4csO4prhLVlSmVMFXsv78bMTFXEfeup0=;
        b=qxIO4cqZy6/FB6tR8o9HOmrbbVeB/NGngzr2QhoZf3kZIYQeIK2Btp2BfP5TpqIkRX
         0T86nFCt6XQN/uSsKBZscRpnOaIWURqVeWK3DueadYGDbY2sUPRh4XzoufuvRXWdj7nb
         FKKYGcP85VI2N8mlaqCczjC2Xt0Vmj7ZTtrr3f5Saglm+fLxl84M8JF9Weyulya+08aU
         vk24QCwDj2g9wCmZUnlGAjzh5IlXf6xjojRmd5Xzf9gwayLdyVcpmA4YDwTC8RjjrbJW
         WPZIk9FZK4SK1WbkzmoYXbBf33jfkHzwCxeAxwi5s3SICVZMG/jH21nRqeaSKDCh0eHv
         89mg==
X-Gm-Message-State: ACrzQf13i+yxbvu7i+OFpBOC3bJRTvOHg9bxOhJMlyAc6FwKQzFH9gmU
        yqnUa8FknS/cUnb+X1IMtI0+kCVa+YGFPCOwZWNrpyAlM56j9VmZo+NHNmk6Qv/aGjcfzyGjMLu
        CVwzCBq8ebwckJWN6
X-Received: by 2002:a05:6214:411e:b0:4b1:a97e:454 with SMTP id kc30-20020a056214411e00b004b1a97e0454mr30951766qvb.118.1666698923377;
        Tue, 25 Oct 2022 04:55:23 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5bkmSsNJp+aQvxeVgnIQPmeAh0WtUGJe771r7tIdB5z+CtZmx3gcRPXFE0E93ny3E8vK4AIw==
X-Received: by 2002:a05:6214:411e:b0:4b1:a97e:454 with SMTP id kc30-20020a056214411e00b004b1a97e0454mr30951749qvb.118.1666698923122;
        Tue, 25 Oct 2022 04:55:23 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-103-235.dyn.eolo.it. [146.241.103.235])
        by smtp.gmail.com with ESMTPSA id e4-20020ac80644000000b0039d085a2571sm1489128qth.55.2022.10.25.04.55.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 04:55:22 -0700 (PDT)
Message-ID: <0ea0057771c623ca3a37a79fc953fd34c54aa815.camel@redhat.com>
Subject: Re: [PATCH net] net: ehea: fix possible memory leak in
 ehea_register_port()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Yang Yingliang <yangyingliang@huawei.com>, netdev@vger.kernel.org
Cc:     dougmill@linux.ibm.com, davem@davemloft.net, kuba@kernel.org
Date:   Tue, 25 Oct 2022 13:55:20 +0200
In-Reply-To: <20221022113722.3409846-1-yangyingliang@huawei.com>
References: <20221022113722.3409846-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Sat, 2022-10-22 at 19:37 +0800, Yang Yingliang wrote:
> dev_set_name() in ehea_register_port() allocates memory for name,
> it need be freed when of_device_register() fails, call put_device()
> to give up the reference that hold in device_initialize(), so that
> it can be freed in kobject_cleanup() when the refcount hit to 0.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/ibm/ehea/ehea_main.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethernet/ibm/ehea/ehea_main.c
> index 294bdbbeacc3..b4aff59b3eb4 100644
> --- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
> +++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
> @@ -2900,6 +2900,7 @@ static struct device *ehea_register_port(struct ehea_port *port,
>  	ret = of_device_register(&port->ofdev);
>  	if (ret) {
>  		pr_err("failed to register device. ret=%d\n", ret);
> +		put_device(&port->ofdev.dev);
>  		goto out;
>  	}

You need to include a suitable Fixes tag into the commit message.
Additionally, if you have a kmemleak splat handy, please include even
that in the commit message.

Thanks!

Paolo



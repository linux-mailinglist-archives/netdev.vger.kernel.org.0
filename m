Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE2C2620DC4
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 11:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233597AbiKHKvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 05:51:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233539AbiKHKvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 05:51:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0140450B7
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 02:50:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667904645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZLhp0guOTEOZgQzoqp/YSJVaOU4l+Lh/PemcPYg2zcc=;
        b=h2JsyLzOZwouJLR2RdN04/9GprgQNgecwtRaD5yCSfAlkxxmRcpUOEUFuIs/VRCaaaV0q7
        BxbfMdCb1wYXNZ4jeLeIc+pJmHvdj/AwpTBQWwH7ZaWZinxj0vFkHe8cjyVGK5tVaGofMR
        T6n1pmG/Ps+2G9SSFooaje5NlHtQpxU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-649-uuMlk6t7PyOtkal1nHFm3g-1; Tue, 08 Nov 2022 05:50:44 -0500
X-MC-Unique: uuMlk6t7PyOtkal1nHFm3g-1
Received: by mail-wr1-f71.google.com with SMTP id h18-20020adfa4d2000000b00236584fc8c7so3797604wrb.7
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 02:50:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZLhp0guOTEOZgQzoqp/YSJVaOU4l+Lh/PemcPYg2zcc=;
        b=vtr3WhMJ2dqYdaIx9RO7J5qf5AK6zwwMEijsFkBfYCXkVmu2U+4/VNoAVmMPFTPtAe
         HBwBNsTZTLBlsGtpTpHf/kTCTs1Wn8QEn4oUyAyUTiMygmWsqg3TXTvi3pniRAaQOmrb
         8gWkxxv0MrKkkB1mxT+TV4Dp1NVKXYqBJRa0xKyXqJ9kx/CjbIoWCNq/DgJSh/X21jWY
         D4sadXGP99j4dn72vJALemcYecqPyHEqy1Ctbe7ar+2odnbsxGJZb2+H+NrGlv573VA4
         WQ4cCepE5kP0GL5L1IGb546t0ksW2Hkbs+U21vJ9+7pDlLbqjAVubCf4aE22ArF2wm72
         I6Lw==
X-Gm-Message-State: ACrzQf0phEWO8H1tUX01ctWwgg8LUmv9O6+Dm99OpE5Q1NZYd3SNctvQ
        r6P7YbHLMM8JFXQX87G2TsJLGKlG/g7GaDknwRUezOjMFqQORWu53Fnc7WqbHPhwuwyjc0dfAUL
        k3TiH9AwBLaaNPhcf
X-Received: by 2002:a05:6000:719:b0:236:73ff:9ca3 with SMTP id bs25-20020a056000071900b0023673ff9ca3mr34539168wrb.603.1667904643407;
        Tue, 08 Nov 2022 02:50:43 -0800 (PST)
X-Google-Smtp-Source: AMsMyM70MxF9iqyGZsxSlE/NZBELF+csBNKpj71R4JCxTghs5SdCEFeJo2t5xgwDkAKnrNw1JZY82A==
X-Received: by 2002:a05:6000:719:b0:236:73ff:9ca3 with SMTP id bs25-20020a056000071900b0023673ff9ca3mr34539161wrb.603.1667904643154;
        Tue, 08 Nov 2022 02:50:43 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-112-250.dyn.eolo.it. [146.241.112.250])
        by smtp.gmail.com with ESMTPSA id l27-20020a05600c1d1b00b003b95ed78275sm11686424wms.20.2022.11.08.02.50.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 02:50:42 -0800 (PST)
Message-ID: <1098295a9515a9290083fade1facbfa6f09ca3a4.camel@redhat.com>
Subject: Re: [PATCH net 1/3] stmmac: dwmac-loongson: fix missing
 pci_disable_msi() while module exiting
From:   Paolo Abeni <pabeni@redhat.com>
To:     Yang Yingliang <yangyingliang@huawei.com>, netdev@vger.kernel.org
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, jiaxun.yang@flygoat.com,
        zhangqing@loongson.cn, liupeibao@loongson.cn, andrew@lunn.ch,
        kuba@kernel.org
Date:   Tue, 08 Nov 2022 11:50:41 +0100
In-Reply-To: <20221105121840.3654266-2-yangyingliang@huawei.com>
References: <20221105121840.3654266-1-yangyingliang@huawei.com>
         <20221105121840.3654266-2-yangyingliang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Sat, 2022-11-05 at 20:18 +0800, Yang Yingliang wrote:
> pci_enable_msi() has been called in loongson_dwmac_probe(),
> so pci_disable_msi() needs be called in remove path and error
> path of probe().
> 
> Fixes: 30bba69d7db4 ("stmmac: pci: Add dwmac support for Loongson")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
> index 79fa7870563b..dd292e71687b 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
> @@ -139,7 +139,15 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
>  		ret = -ENODEV;
>  	}
>  
> -	return stmmac_dvr_probe(&pdev->dev, plat, &res);
> +	ret = stmmac_dvr_probe(&pdev->dev, plat, &res);
> +	if (ret)
> +		goto err_disable_msi;
> +
> +	return ret;
> +
> +err_disable_msi:
> +	pci_disable_msi(pdev);
> +	return ret;
>  }

It looks like this patch is missing a couple of error paths, still
after pci_enable_msi(), which need 'goto err_disable_msi', too:

https://elixir.bootlin.com/linux/v6.1-rc4/source/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c#L127
https://elixir.bootlin.com/linux/v6.1-rc4/source/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c#L139

Cheers,

Paolo


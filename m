Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD7555FB92
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 11:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbiF2JQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 05:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiF2JQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 05:16:21 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD4B2C660;
        Wed, 29 Jun 2022 02:16:20 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 45647C0013;
        Wed, 29 Jun 2022 09:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1656494178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jkmESM416SslUHNUzzLOc5OQPCjAoAiRojL4STsH4VU=;
        b=fNliQTwONPTuoMJsnDb9UahqAmJ3jHbaFFsB4wuOrAHVu8bPD7mzobr9c1X+n3dfttWfWk
        y/zfYDyx5s1xMMTmASN31l8o/z78PFoClLu8foJwMG3TD49WI2a4N2N5mzSKX8M7V4VExB
        9OqVQKKyp6a6Iq341OZ+dZwPhEjaAkU0Zcbo1h/roWVKB56Bg7mGoNg0ZyeA0gb53RJUf3
        DfekaSnXgs8EyVHBZwo8oRdKf/CVg+iZp/Ht4UY25q9qU1nBo2MZUj9xc9sMeCLYyXDIFr
        EqzvDxqPGhtW/srfnejWTX08tgf4kftNwcQSw5gvOM4ipQG5MO/ZWiKqnYeSGg==
Date:   Wed, 29 Jun 2022 11:15:30 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-renesas-soc@vger.kernel.org>, <olteanv@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>
Subject: Re: [PATCH -next v2] net: pcs-rzn1-miic: fix return value check in
 miic_probe()
Message-ID: <20220629111530.3b74c014@fixe.home>
In-Reply-To: <20220628131259.3109124-1-yangyingliang@huawei.com>
References: <20220628131259.3109124-1-yangyingliang@huawei.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Tue, 28 Jun 2022 21:12:59 +0800,
Yang Yingliang <yangyingliang@huawei.com> a =C3=A9crit :

> On failure, devm_platform_ioremap_resource() returns a ERR_PTR() value
> and not NULL. Fix return value checking by using IS_ERR() and return
> PTR_ERR() as error value.
>=20
> Fixes: 7dc54d3b8d91 ("net: pcs: add Renesas MII converter driver")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
> v2:
>   change commit message as Cl=C3=A9ment suggested.
> ---
>  drivers/net/pcs/pcs-rzn1-miic.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/pcs/pcs-rzn1-miic.c b/drivers/net/pcs/pcs-rzn1-m=
iic.c
> index 8f5e910f443d..d896961e48cc 100644
> --- a/drivers/net/pcs/pcs-rzn1-miic.c
> +++ b/drivers/net/pcs/pcs-rzn1-miic.c
> @@ -461,8 +461,8 @@ static int miic_probe(struct platform_device *pdev)
>  	spin_lock_init(&miic->lock);
>  	miic->dev =3D dev;
>  	miic->base =3D devm_platform_ioremap_resource(pdev, 0);
> -	if (!miic->base)
> -		return -EINVAL;
> +	if (IS_ERR(miic->base))
> +		return PTR_ERR(miic->base);
> =20
>  	ret =3D devm_pm_runtime_enable(dev);
>  	if (ret < 0)

LGTM, thanks.

Reviewed-by: Cl=C3=A9ment L=C3=A9ger <clement.leger@bootlin.com>

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com

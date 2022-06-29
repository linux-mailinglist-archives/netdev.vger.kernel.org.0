Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 573B955FBFF
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 11:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231980AbiF2J2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 05:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbiF2J2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 05:28:13 -0400
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [217.70.178.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48002BF;
        Wed, 29 Jun 2022 02:28:11 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 03FBB240012;
        Wed, 29 Jun 2022 09:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1656494890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6n3CIs9RxVSb+aOC/z04UOZ6/DtdTS73o2Frum+oK/A=;
        b=aH1yGbnUXRqJ8259krN+JCkO6nhY0K7zbLcsxwc/NXGHrS++ob3xejpYmp9KuzZsCqvcYX
        VVjZbIxbKdSnVurEXvqmWAwll9mFDBn4qsYL48PwuGPv/3wV7NVJisWL5KAIOoaUkqr+XD
        y9RmiRfc20rJzRfW4FGXaFNRQyV3kaGaog3xzfZsGFV6IcjxXBzxOU30G5BgbI8eWdqMlL
        ttTWrXxIWyFCbI0HLr2newo7M5UMuUGylJI1Hnzll7lSqGB7Ai3PdFxdnZc+QS+ZF6ffTP
        y1jMlv1e6Q+6JjPXA1gSfblorwq9e/QpCV7SJMpoRijHouUauJ9R36rIT7zvGQ==
Date:   Wed, 29 Jun 2022 11:27:20 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Peng Wu <wupeng58@huawei.com>
Cc:     <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-renesas-soc@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <liwei391@huawei.com>
Subject: Re: [PATCH] net: dsa: rzn1-a5psw: fix a NULL vs IS_ERR() check in
 a5psw_probe()
Message-ID: <20220629112720.648619a8@fixe.home>
In-Reply-To: <20220628130920.49493-1-wupeng58@huawei.com>
References: <20220628130920.49493-1-wupeng58@huawei.com>
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

Le Tue, 28 Jun 2022 13:09:20 +0000,
Peng Wu <wupeng58@huawei.com> a =C3=A9crit :

> The devm_platform_ioremap_resource() function never returns NULL.
> It returns error pointers.
>=20
> Signed-off-by: Peng Wu <wupeng58@huawei.com>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> ---
>  drivers/net/dsa/rzn1_a5psw.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/dsa/rzn1_a5psw.c b/drivers/net/dsa/rzn1_a5psw.c
> index 3e910da98ae2..5b14e2ba9b79 100644
> --- a/drivers/net/dsa/rzn1_a5psw.c
> +++ b/drivers/net/dsa/rzn1_a5psw.c
> @@ -946,8 +946,8 @@ static int a5psw_probe(struct platform_device *pdev)
>  	mutex_init(&a5psw->lk_lock);
>  	spin_lock_init(&a5psw->reg_lock);
>  	a5psw->base =3D devm_platform_ioremap_resource(pdev, 0);
> -	if (!a5psw->base)
> -		return -EINVAL;
> +	if (IS_ERR(a5psw->base))
> +		return PTR_ERR(a5psw->base);
> =20
>  	ret =3D a5psw_pcs_get(a5psw);
>  	if (ret)

Thanks,

Reviewed-by: Cl=C3=A9ment L=C3=A9ger <clement.leger@bootlin.com>

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com

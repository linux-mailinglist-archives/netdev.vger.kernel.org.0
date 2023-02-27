Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4D2D6A43B5
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 15:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjB0OHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 09:07:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjB0OHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 09:07:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03EC01DB94
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 06:07:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677506825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aFTvFQ3q5aWSqvyw9AelhhhkIt6I0O9TBRHfypnLJlQ=;
        b=GEcndyobv9GWtT9DftMcqy+RVDZRHvLBaiVaAtQobRey6fEObKRbXNVtWyBX0Fp8xPS74b
        osEQO+vJJzJ4Oj1pLgA52/KFbxJIniJrjFvRFa6Qexk2VJbAm2SRLvMKi5kU8ZVFlN6rBb
        0mCfpP7j8wRb4gzwZgQjaWOWGiWnccw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-446-xmQybT-UMO251OuBJKpO2w-1; Mon, 27 Feb 2023 09:07:03 -0500
X-MC-Unique: xmQybT-UMO251OuBJKpO2w-1
Received: by mail-wm1-f69.google.com with SMTP id y16-20020a1c4b10000000b003dd1b5d2a36so2229298wma.1
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 06:07:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aFTvFQ3q5aWSqvyw9AelhhhkIt6I0O9TBRHfypnLJlQ=;
        b=D+YhZnBOXx8vocPf6plP0aZVBC+0Nbk4z6GGD8+bVpxWDk+VzVxCKUg1K5GEjUI7CV
         T5YlY6372F4xP9T9HdkrqYAaUeN4wbKN9v9lMfNLDogkEBmaR8wrb5LpjNDBHDo8Fe3Z
         MBpCsbt3N1XcQrNFGakl/VfRepd0931VP6uGLW2L8tVjK0eGAjgbQoyN4X1W74sIwqeV
         PdDrN4E2KLgzjeVSp+tKZTu4tpcH4hO2KuvL+sG1kLwE1NSEGgJUZq6HlWk8XtResjN1
         tpcoB0hBV0YokZf1GGUWN0RRHJdv6n2SahcDaWKORANxsr7stMNLBwZMQ2YL06VYVN8L
         yfTQ==
X-Gm-Message-State: AO0yUKWSFvcz+4zYeY557y4MRmAd4xNPMSd/4tgAHFzPhy2yqmAkS45k
        6Oh0X0NTIQkMqxqWPzce0lP6xMGCn0YtDAV2DzcEFzplFq/5nD44t/6VIjppOM6q47t8RDxtCWT
        iDuzGj/hM+QBHAJkd
X-Received: by 2002:a5d:4f89:0:b0:2c7:1d70:561 with SMTP id d9-20020a5d4f89000000b002c71d700561mr9516581wru.45.1677506821180;
        Mon, 27 Feb 2023 06:07:01 -0800 (PST)
X-Google-Smtp-Source: AK7set9ec/Yueab8Bvk6eJi8LCRz4+aeuNEBluM/tCSwA288dNuu0Nq41jbKDNy7uFxhcbonKrPSew==
X-Received: by 2002:a5d:4f89:0:b0:2c7:1d70:561 with SMTP id d9-20020a5d4f89000000b002c71d700561mr9516553wru.45.1677506820885;
        Mon, 27 Feb 2023 06:07:00 -0800 (PST)
Received: from localhost (net-188-216-77-84.cust.vodafonedsl.it. [188.216.77.84])
        by smtp.gmail.com with ESMTPSA id g9-20020a056000118900b002c794495f6fsm6993704wrx.117.2023.02.27.06.07.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 06:07:00 -0800 (PST)
Date:   Mon, 27 Feb 2023 15:06:58 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     void0red <void0red@gmail.com>
Cc:     angelogioacchino.delregno@collabora.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, kvalo@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-wireless@vger.kernel.org,
        lorenzo@kernel.org, matthias.bgg@gmail.com, nbd@nbd.name,
        netdev@vger.kernel.org, pabeni@redhat.com, ryder.lee@mediatek.com,
        sean.wang@mediatek.com, shayne.chen@mediatek.com
Subject: Re: [PATCH v2] wifi: mt76: add a check of vzalloc in
 mt7615_coredump_work
Message-ID: <Y/y5Asxw3T3m4jCw@lore-desk>
References: <Y/yxGMvBbMGiehC6@lore-desk>
 <20230227135241.947052-1-void0red@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="suqa0cLxZu8I2O6i"
Content-Disposition: inline
In-Reply-To: <20230227135241.947052-1-void0red@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--suqa0cLxZu8I2O6i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> From: Kang Chen <void0red@gmail.com>
>=20
> vzalloc may fails, dump might be null and will cause
> illegal address access later.
>=20
> Fixes: d2bf7959d9c0 ("mt76: mt7663: introduce coredump support")
> Signed-off-by: Kang Chen <void0red@gmail.com>
> ---
> v2 -> v1: add Fixes tag
>=20
>  drivers/net/wireless/mediatek/mt76/mt7615/mac.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/ne=
t/wireless/mediatek/mt76/mt7615/mac.c
> index a95602473..73d84c301 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
> @@ -2367,6 +2367,9 @@ void mt7615_coredump_work(struct work_struct *work)
>  	}
> =20
>  	dump =3D vzalloc(MT76_CONNAC_COREDUMP_SZ);
> +	if (!dump)
> +		return;
> +
>  	data =3D dump;
> =20
>  	while (true) {
> --=20
> 2.34.1
>=20

revieweing the code I guess the right approach would be the one used in
mt7921_coredump_work():
- free pending skbs
- not run dev_coredumpv()

What do you think?

Regards,
Lorenzo

--suqa0cLxZu8I2O6i
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY/y5AgAKCRA6cBh0uS2t
rNvNAQChxct9I9hvxziffNgrIyEvdXvuQxbOt0yeiX8oblnPWwEA4qXx39acNsg6
Q0MSG7S8eufwOP2IXUXhOgXTb9tFZQw=
=ErB1
-----END PGP SIGNATURE-----

--suqa0cLxZu8I2O6i--


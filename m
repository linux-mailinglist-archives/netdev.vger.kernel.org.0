Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16DC16936A8
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 10:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjBLJIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 04:08:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjBLJIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 04:08:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A0112F3E
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 01:07:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676192847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wcnMcgfIkYoPRGV997Pr1b4NEAun/DkLNXeP1OYpbPg=;
        b=Pov1BXK7fInQyIvYDgDjVzaiX+Xo78oowdD4w+NyDLH+H5CyYN8urulrw6XxvtrBC5vS2d
        Y5mwNCuWvjAKzXNDCNbIEx4uLdX1aTkdUVl5gTYvKlcdx+w9Ekr5VZt7MbTn43BSbmHI3f
        YT2wvjAM2LhUYyN7pFu0M2mboou7Oxw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-206-dvcZvUjCPPSJMuEzzIELKA-1; Sun, 12 Feb 2023 04:07:15 -0500
X-MC-Unique: dvcZvUjCPPSJMuEzzIELKA-1
Received: by mail-wm1-f72.google.com with SMTP id bg9-20020a05600c3c8900b003e1e7d3db06so711030wmb.5
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 01:07:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wcnMcgfIkYoPRGV997Pr1b4NEAun/DkLNXeP1OYpbPg=;
        b=uJIAcwt80c1H3Kpxh81ai3wiuW5HX4SzPXsN+wtLfAbuLtdE1o+bnMAoeth9T6wy1F
         LYVc4kWE+DIz3CXwzyNVRUK73yXt3YnjPbKUnVEnVQIkw1g3eEXGlr/vwba47YfEY+n2
         S4cmUZC4YHjYU5crZavB30iTYXDfGUaCKbP4WZy2oIsAsbwBqLuDeM8luCFPOdihhY/g
         xPPClsawwUswm1hrz7ttxGa9cQcxSzXPO90XA/+Usmk4HXzvSAvJUaMlG90Xdl8LY1P8
         0j8ikC3QkaDyGxaYYal+Le3EWUuleOJ9lCdNi4FYhPj4UJq51zGHIJ78j6EoB4XpLR8S
         fm6w==
X-Gm-Message-State: AO0yUKUv+SopFOk4FSc1AfajYAiX6G6vaHN7OuNL7OrZe0xCyYF4sMYt
        dMjL4jTbvOk3Zk0rhFL7nmLywPscKesbgdLfILTVpHBys9/3zmqARqGhTOO5b7Lbdrdd9Ulo/14
        MI0m3nL4xE+gBhluf
X-Received: by 2002:a05:600c:4d09:b0:3df:e549:bd27 with SMTP id u9-20020a05600c4d0900b003dfe549bd27mr18601075wmp.6.1676192834648;
        Sun, 12 Feb 2023 01:07:14 -0800 (PST)
X-Google-Smtp-Source: AK7set9ujDcuiMwp9QyR9Os39AOaQiwc+K/XDPSpOS4KnPtl9gg0vJQLS56ufc4n29Q4MTNJ2wtJng==
X-Received: by 2002:a05:600c:4d09:b0:3df:e549:bd27 with SMTP id u9-20020a05600c4d0900b003dfe549bd27mr18601062wmp.6.1676192834398;
        Sun, 12 Feb 2023 01:07:14 -0800 (PST)
Received: from localhost (net-188-216-77-84.cust.vodafonedsl.it. [188.216.77.84])
        by smtp.gmail.com with ESMTPSA id z4-20020a05600c220400b003dfe8c4c497sm13680055wml.39.2023.02.12.01.07.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 01:07:13 -0800 (PST)
Date:   Sun, 12 Feb 2023 10:07:11 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH bpf-next] net: lan966x: set xdp_features flag
Message-ID: <Y+isP2HNYKTHtHjf@lore-desk>
References: <01f4412f28899d97b0054c9c1a63694201301b42.1676055718.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="KCRzVampMKCckIPO"
Content-Disposition: inline
In-Reply-To: <01f4412f28899d97b0054c9c1a63694201301b42.1676055718.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--KCRzVampMKCckIPO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Set xdp_features netdevice flag if lan966x nic supports xdp mode.
>=20
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/driv=
ers/net/ethernet/microchip/lan966x/lan966x_main.c
> index 580c91d24a52..b24e55e61dc5 100644
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
> @@ -823,6 +823,11 @@ static int lan966x_probe_port(struct lan966x *lan966=
x, u32 p,
> =20
>  	port->phylink =3D phylink;
> =20
> +	if (lan966x->fdma)
> +		dev->xdp_features =3D NETDEV_XDP_ACT_BASIC |
> +				    NETDEV_XDP_ACT_REDIRECT |
> +				    NETDEV_XDP_ACT_NDO_XMIT;
> +
>  	err =3D register_netdev(dev);
>  	if (err) {
>  		dev_err(lan966x->dev, "register_netdev failed\n");

Since the xdp-features series is now merged in net-next, do you think it is
better to target this patch to net-next?

Regards,
Lorenzo

> --=20
> 2.39.1
>=20

--KCRzVampMKCckIPO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY+isPgAKCRA6cBh0uS2t
rJW0AQCIwl3rJF7AXotFgyQiHPiZ+KrH2dc3Nkkxg8u1KUO3ngEAhR3xyPnqfRvm
Z5MO6IiVENBWPKSnV0+1XHNk1aIx3Q8=
=UPwj
-----END PGP SIGNATURE-----

--KCRzVampMKCckIPO--


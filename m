Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A99D94C49C6
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 16:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242482AbiBYP5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 10:57:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242469AbiBYP5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 10:57:22 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B9E1DC989
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 07:56:50 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nNcxH-0003K9-Po; Fri, 25 Feb 2022 16:56:27 +0100
Received: from pengutronix.de (2a03-f580-87bc-d400-c8b7-5627-f914-a39f.ip6.dokom21.de [IPv6:2a03:f580:87bc:d400:c8b7:5627:f914:a39f])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 8C77E3D790;
        Fri, 25 Feb 2022 15:56:21 +0000 (UTC)
Date:   Fri, 25 Feb 2022 16:56:21 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     wg@grandegger.com, davem@davemloft.net, kuba@kernel.org,
        stefan.maetje@esd.eu, mailhol.vincent@wanadoo.fr,
        paskripkin@gmail.com, thunder.leizhen@huawei.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: usb: fix a possible memory leak in
 esd_usb2_start_xmit
Message-ID: <20220225155621.7zmfukra63qcxjo5@pengutronix.de>
References: <20220225060019.21220-1-hbh25y@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="pued4m6gminpxchp"
Content-Disposition: inline
In-Reply-To: <20220225060019.21220-1-hbh25y@gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--pued4m6gminpxchp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 25.02.2022 14:00:19, Hangyu Hua wrote:
> As in case of ems_usb_start_xmit, dev_kfree_skb needs to be called when
> usb_submit_urb fails to avoid possible refcount leaks.

Thanks for your patch. Have you tested that there is actually a mem
leak? Please have a look at the can_free_echo_skb() function that is
called a few lines earlier.

> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> ---
>  drivers/net/can/usb/esd_usb2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb=
2.c
> index 286daaaea0b8..7b5e6c250d00 100644
> --- a/drivers/net/can/usb/esd_usb2.c
> +++ b/drivers/net/can/usb/esd_usb2.c
> @@ -810,7 +810,7 @@ static netdev_tx_t esd_usb2_start_xmit(struct sk_buff=
 *skb,
>  		usb_unanchor_urb(urb);
> =20
>  		stats->tx_dropped++;
> -
> +		dev_kfree_skb(skb);
>  		if (err =3D=3D -ENODEV)
>  			netif_device_detach(netdev);
>  		else

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--pued4m6gminpxchp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmIY/B0ACgkQrX5LkNig
010abwf/bUMOxEyTJnGi9fpvefrrw+we+LekwHCyTh6UZtmlfpja5jCRUpVXrEoz
OBhKFad/LqwDjKe29Tfzyh0m16rTo/khP0ZaGENZ7R26n2S2dqxtKKAzSsEu/WKC
GXYcRZ+N9ZnITUDoskixvh2CN4YtU1jYgbnwBndWbmDAxk0gpWkfqxHKXprjwHrB
rgwlWCp0s5zyubIDWPxb4D7dbgEEA7CEhRScOHVHdt01EFwqv6HdlquzkGR+X3n7
mE4j12qffh8MAprRDjWQD//9v8suafQ++0gLoeNT88Tzy+46qoLhm9bp5fK5TyFD
RCzY+6AhdKW2EGdmTe9GQM73rStQdg==
=pavt
-----END PGP SIGNATURE-----

--pued4m6gminpxchp--

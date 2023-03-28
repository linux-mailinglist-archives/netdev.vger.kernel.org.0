Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48BC06CB71B
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 08:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbjC1G0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 02:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232558AbjC1G0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 02:26:24 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED0EE4EEF
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 23:25:50 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ph2lX-00081R-6e; Tue, 28 Mar 2023 08:25:07 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 25D5119DDFA;
        Tue, 28 Mar 2023 06:24:58 +0000 (UTC)
Date:   Tue, 28 Mar 2023 08:24:56 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     Peter Hong <peter_hong@fintek.com.tw>, wg@grandegger.com,
        michal.swiatkowski@linux.intel.com, Steen.Hegelund@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, frank.jungclaus@esd.eu,
        linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, hpeter+linux_kernel@gmail.com
Subject: Re: [PATCH V3] can: usb: f81604: add Fintek F81604 support
Message-ID: <20230328062456.wjk5gj4vbriu7fzq@pengutronix.de>
References: <20230327051048.11589-1-peter_hong@fintek.com.tw>
 <CAMZ6Rq+ps1tLii1VfYyAqfD4ck_TGWBUo_ouK_vLfhoNEg-BPg@mail.gmail.com>
 <5bdee736-7868-81c3-e63f-a28787bd0007@fintek.com.tw>
 <CAMZ6Rq++N9ui5srP2uBYz0FPXttBYd2m982K8X-ESCC=qu1dAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="rqa5tlkfbiozleiu"
Content-Disposition: inline
In-Reply-To: <CAMZ6Rq++N9ui5srP2uBYz0FPXttBYd2m982K8X-ESCC=qu1dAQ@mail.gmail.com>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--rqa5tlkfbiozleiu
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 28.03.2023 13:49:05, Vincent MAILHOL wrote:
[...]
> > >> +       int status, len;
> > >> +
> > >> +       if (can_dropped_invalid_skb(netdev, skb))
> > >> +               return NETDEV_TX_OK;
> > >> +
> > >> +       netif_stop_queue(netdev);
> > > In your driver, you send the CAN frames one at a time and wait for the
> > > rx_handler to restart the queue. This approach dramatically degrades
> > > the throughput. Is this a device limitation? Is the device not able to
> > > manage more than one frame at a time?
> > >
> >
> > This device will not NAK on TX frame not complete, it only NAK on TX
> > endpoint
> > memory not processed, so we'll send next frame unitl TX complete(TI)
> > interrupt
> > received.
> >
> > The device can polling status register via TX/RX endpoint, but it's more
> > complex.
> > We'll plan to do it when first driver landing in mainstream.
>=20
> OK for me to have this as a next step. Marc, what do you think?

Fine with me. First make it work, then make it fast.

But I think this will never be a fast and resource-efficient USB CAN
adapter. There are exiting drivers with an open and documented USB
interface (gs_usb) and Open Source =C2=B5C implementations (candlelight) wi=
th
better performance.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129  |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--rqa5tlkfbiozleiu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmQiiDUACgkQvlAcSiqK
BOh0cwf+OIsyfvXP3U85cp2q7trhkPiSxchYbsU7gUaDHBWKN1VDhNOwWYIyBpl3
8iCh88sGwjX0Q9Ib1qmNJvNibgf4kr0ekK0sUgHhVg3IJjA/nEatAXNDO9vtEjGt
vsHz+UPuLWWGnwxXmIAjbUiKpzvk7UO3uzlaQu4TKRMUKX0gG3ZzhVt1KNf5hj6J
P2XQO2/AfQ3ve1rEGLJBf4T0Y6Y+D7EDiYVV7070yYt43/N9Z8z+sdB/1YRDZ5RD
Fh7QDzGSM/91ZDlNpO120YyWX5Eu8UzDOaP7sCcwnd/Y+8Je3/fcyGXW6He1Sf6t
HW9clTQNLjK5nrQenqZymCyeOCj1+w==
=BXc1
-----END PGP SIGNATURE-----

--rqa5tlkfbiozleiu--

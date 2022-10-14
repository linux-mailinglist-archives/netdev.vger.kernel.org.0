Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62D725FED3F
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 13:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbiJNLgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 07:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiJNLg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 07:36:29 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C4D1C0705
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 04:36:29 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ojIz3-0008Bs-Ap; Fri, 14 Oct 2022 13:36:09 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 3B87BFE1ED;
        Fri, 14 Oct 2022 11:36:06 +0000 (UTC)
Date:   Fri, 14 Oct 2022 13:36:03 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vivek Yadav <vivek.2311@samsung.com>
Cc:     rcsekar@samsung.com, wg@grandegger.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        pankaj.dubey@samsung.com, ravi.patel@samsung.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] can: mcan: Add support for handling DLEC error on CAN
 FD
Message-ID: <20221014113603.hrg3ttsgofgq44ba@pengutronix.de>
References: <CGME20221014053017epcas5p359d337008999640fa140c691f47bc79c@epcas5p3.samsung.com>
 <20221014050332.45045-1-vivek.2311@samsung.com>
 <20221014071114.a6ls5ay56xk4cin3@pengutronix.de>
 <00db01d8dfbf$5e38fbd0$1aaaf370$@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mj7nepgaiz77tn2a"
Content-Disposition: inline
In-Reply-To: <00db01d8dfbf$5e38fbd0$1aaaf370$@samsung.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--mj7nepgaiz77tn2a
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14.10.2022 16:53:19, Vivek Yadav wrote:
> >=20
> >                 if (is_lec_err(lec))
> >                         work_done +=3D m_can_handle_lec_err(dev, lec);
> >=20
> >                 if (is_lec_err(dlec))
> >                         work_done +=3D m_can_handle_lec_err(dev, dlec);
> >=20
> > > +			u8 dlec =3D FIELD_GET(PSR_DLEC_MASK, psr);
> > > +
> > > +			if (is_lec_err(dlec)) {
> > > +				netdev_dbg(dev, "Data phase error
> > detected\n");
> >=20
> > If you add a debug, please add one for the Arbitration phase, too.
>
> I have added the debug print specially for dlec (data phase). So we
> can differentiate lec errors (for all type of frames except FD with
> BRS) and Data phase errors, as we are calling same handler function
> for both the errors.
>=20
> If I understood your comment correctly, you are asking something like bel=
ow:
>         /* handle protocol errors in arbitration phase */
>         if ((cdev->can.ctrlmode & CAN_CTRLMODE_BERR_REPORTING) &&
> -           m_can_is_protocol_err(irqstatus))
> +           m_can_is_protocol_err(irqstatus)) {
> +               netdev_dbg(dev, "Arbitration phase error detected\n");
>                 work_done +=3D m_can_handle_protocol_error(dev, irqstatus=
);
> +       }
>=20
> If the above implementation is correct as per your review comment, I
> think we don't need the above changes because Debug print for
> arbitration failure are already there in "
> m_can_handle_protocol_error" function.

Ok

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--mj7nepgaiz77tn2a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmNJSaEACgkQrX5LkNig
011yxgf/c6acNcBfDRfZ9nhxnau0jXG2K7yOwJb8Hi4SIxPO/63RPFT+lqGvm+Pn
eA75SQiGy8ojstW3XJyGDTm5hJ0YNHN1jEd00ZlY4LuBwTmoNrsdMigxjbpLOAdp
orkIkDcbsL6TNx37Ky38actcIhNVJ9MognLme0WG/2Z3AA9iEQHpV1RmBe1a3rxQ
TDpUo9iK8juT9CtH7A54MPEmeFJnIiHTC4sOBD5fX9e8iaTiqQS73UP8O6R3M8LG
AHDywbXMHeCVI8M/mPP2iY11q58D2omCh6J7lD0VpiycpWEycGaGp+n52S33FaEX
BFx4blHBGw7XsfT2KbGaZm52yweSWw==
=UAXg
-----END PGP SIGNATURE-----

--mj7nepgaiz77tn2a--

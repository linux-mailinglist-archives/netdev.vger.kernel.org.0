Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD543EFF01
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 10:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239148AbhHRIUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 04:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239551AbhHRIUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 04:20:15 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94EDEC06179A
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 01:19:40 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mGGnR-0005XT-8O; Wed, 18 Aug 2021 10:19:37 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:ed04:8488:5061:54d4])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 9AD836698D4;
        Wed, 18 Aug 2021 08:19:35 +0000 (UTC)
Date:   Wed, 18 Aug 2021 10:19:34 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     linux-can <linux-can@vger.kernel.org>,
        Stefan =?utf-8?B?TcOkdGpl?= <Stefan.Maetje@esd.eu>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 5/7] can: netlink: add interface for CAN-FD
 Transmitter Delay Compensation (TDC)
Message-ID: <20210818081934.6f23ghoom2dkv53m@pengutronix.de>
References: <20210815033248.98111-1-mailhol.vincent@wanadoo.fr>
 <20210815033248.98111-6-mailhol.vincent@wanadoo.fr>
 <20210817195551.wwgu7dnhb6qyvo7n@pengutronix.de>
 <CAMZ6RqLj94UU_b8dDAzinVsLaV6pBR-cWbHmjwGhx3vfWiKt_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3e3jncuyjzgfz6lc"
Content-Disposition: inline
In-Reply-To: <CAMZ6RqLj94UU_b8dDAzinVsLaV6pBR-cWbHmjwGhx3vfWiKt_g@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--3e3jncuyjzgfz6lc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 18.08.2021 17:08:51, Vincent MAILHOL wrote:
> On Wed 18 Aug 2021 at 04:55, Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> > On 15.08.2021 12:32:46, Vincent Mailhol wrote:
> > > +static int can_tdc_changelink(struct net_device *dev, const struct n=
lattr *nla,
> > > +                           struct netlink_ext_ack *extack)
> > > +{
> > > +     struct nlattr *tb_tdc[IFLA_CAN_TDC_MAX + 1];
> > > +     struct can_priv *priv =3D netdev_priv(dev);
> > > +     struct can_tdc *tdc =3D &priv->tdc;
> > > +     const struct can_tdc_const *tdc_const =3D priv->tdc_const;
> > > +     int err;
> > > +
> > > +     if (!tdc_const || !can_tdc_is_enabled(priv))
> > > +             return -EOPNOTSUPP;
> > > +
> > > +     if (dev->flags & IFF_UP)
> > > +             return -EBUSY;
> > > +
> > > +     err =3D nla_parse_nested(tb_tdc, IFLA_CAN_TDC_MAX, nla,
> > > +                            can_tdc_policy, extack);
> > > +     if (err)
> > > +             return err;
> > > +
> > > +     if (tb_tdc[IFLA_CAN_TDC_TDCV]) {
> > > +             u32 tdcv =3D nla_get_u32(tb_tdc[IFLA_CAN_TDC_TDCV]);
> > > +
> > > +             if (tdcv < tdc_const->tdcv_min || tdcv > tdc_const->tdc=
v_max)
> > > +                     return -EINVAL;
> > > +
> > > +             tdc->tdcv =3D tdcv;
> >
> > You have to assign to a temporary struct first, and set the priv->tdc
> > after complete validation, otherwise you end up with inconsistent
> > values.
>=20
> Actually, copying the temporary structure to priv->tdc is not an
> atomic operation. Here, you are only reducing the window, not
> closing it.

It's not a race I'm fixing.

>=20
> > > +     }
> > > +
> > > +     if (tb_tdc[IFLA_CAN_TDC_TDCO]) {
> > > +             u32 tdco =3D nla_get_u32(tb_tdc[IFLA_CAN_TDC_TDCO]);
> > > +
> > > +             if (tdco < tdc_const->tdco_min || tdco > tdc_const->tdc=
o_max)
> > > +                     return -EINVAL;
> > > +
> > > +             tdc->tdco =3D tdco;
> > > +     }
> > > +
> > > +     if (tb_tdc[IFLA_CAN_TDC_TDCF]) {
> > > +             u32 tdcf =3D nla_get_u32(tb_tdc[IFLA_CAN_TDC_TDCF]);
> > > +
> > > +             if (tdcf < tdc_const->tdcf_min || tdcf > tdc_const->tdc=
f_max)
> > > +                     return -EINVAL;
> > > +
> > > +             tdc->tdcf =3D tdcf;
> > > +     }
> > > +
> > > +     return 0;
> > > +}
> >
> > To reproduce (ip pseudo-code only :D ):
> >
> > ip down
> > ip up tdc-mode manual tdco 111 tdcv 33  # 111 is out of range, 33 is va=
lid
> > ip down
> > ip up                                   # results in tdco=3D0 tdcv=3D33=
 mode=3Dmanual
>=20
> I do not think that this PoC would work because, thankfully, the
> netlink interface uses a mutex to prevent this issue from
> occurring.

It works, I've tested it :)

> That mutex is defined in:
> https://elixir.bootlin.com/linux/latest/source/net/core/rtnetlink.c#L68
>=20
> Each time a netlink message is sent to the kernel, it would be
> dispatched by rtnetlink_rcv_msg() which will make sure to lock
> the mutex before doing so:
> https://elixir.bootlin.com/linux/latest/source/net/core/rtnetlink.c#L5551
>=20
> A funny note is that because the mutex is global, if you run two
> ip command in a row:
>=20
> | ip link set can0 type can bitrate 500000
> | ip link set can1 up
>=20
> the second one will wait for the first one to finish even if it
> is on a different network device.
>=20
> To conclude, I do not think this needs to be fixed.

It's not a race. Consider this command:

| ip up tdc-mode manual tdco 111 tdcv 33  # 111 is out of range, 33 is valid

tdcv is checked first and valid, then it's assigned to the priv->tdc.
tdco is checked second and invalid, then can_tdc_changelink() returns -EINV=
AL.

tdc ends up being half set :(

So the setting of tdc is inconsistent and when you do a "ip down" "ip
up" then it results in a tdco=3D0 tdcv=3D33 mode=3Dmanual.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--3e3jncuyjzgfz6lc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEcwpMACgkQqclaivrt
76mN8QgAqxSO4LyB4IjE16rxksejvFXamtoLW60WQkF+ssrYVu59sO0JnKxrrATU
izMnj78NfQPmm5JtzE6n+Yr0TwUKeyfBanMFcn6kjT3hVw5ZevdISOqHe7gScI5n
zbFjofkunuJDo8znOo2E4TNA7W1DR09XE4tLfCLUn3XN+5WcyZVJlHEmfHOeQkzG
Cnx6U/zS92DZNYvcx6a2+ftYaE+IuYuh/DOLXR2StwufDpKKFe9DCuDHvJscl8f4
PxD4kzMF3UJF7NuoLP6nC7eOzJ99eyDGZVfuWJwhXmXqtD2I/IFrqlCpOn+XPwbS
EmOl7nFj06vxn1CYw0ZB5XbxS5e2mw==
=kO5l
-----END PGP SIGNATURE-----

--3e3jncuyjzgfz6lc--

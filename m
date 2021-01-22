Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46C1D3001F2
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 12:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbhAVLtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 06:49:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727990AbhAVLsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 06:48:42 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9AA4C061788
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 03:48:01 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1l2uuw-0003BW-FO; Fri, 22 Jan 2021 12:47:54 +0100
Received: from hardanger.blackshift.org (unknown [IPv6:2a03:f580:87bc:d400:aed1:e241:8b32:9cc0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id EE4925CA7EE;
        Fri, 22 Jan 2021 11:47:51 +0000 (UTC)
Date:   Fri, 22 Jan 2021 12:47:51 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Robin van der Gracht <robin@protonic.nl>,
        syzbot+5138c4dd15a0401bec7b@syzkaller.appspotmail.com,
        kernel@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net 1/2] net: introduce CAN specific pointer in the
 struct net_device
Message-ID: <20210122114751.scp23qtyqmsol5h5@hardanger.blackshift.org>
References: <20210115143036.31275-1-o.rempel@pengutronix.de>
 <20210115160723.7abd75ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7lq5rzmnwt7rxwny"
Content-Disposition: inline
In-Reply-To: <20210115160723.7abd75ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--7lq5rzmnwt7rxwny
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 15, 2021 at 04:07:23PM -0800, Jakub Kicinski wrote:
> On Fri, 15 Jan 2021 15:30:35 +0100 Oleksij Rempel wrote:
> > Since 20dd3850bcf8 ("can: Speed up CAN frame receiption by using
> > ml_priv") the CAN framework uses per device specific data in the AF_CAN
> > protocol. For this purpose the struct net_device->ml_priv is used. Later
> > the ml_priv usage in CAN was extended for other users, one of them being
> > CAN_J1939.
> >=20
> > Later in the kernel ml_priv was converted to an union, used by other
> > drivers. E.g. the tun driver started storing it's stats pointer.
> >=20
> > Since tun devices can claim to be a CAN device, CAN specific protocols
> > will wrongly interpret this pointer, which will cause system crashes.
> > Mostly this issue is visible in the CAN_J1939 stack.
> >=20
> > To fix this issue, we request a dedicated CAN pointer within the
> > net_device struct.
>=20
> No strong objection, others already added their pointers, but=20
> I wonder if we can't save those couple of bytes by adding a
> ml_priv_type, to check instead of dev->type? And leave it 0
> for drivers using stats?

Sounds good.

If we want to save even more bytes, it might be possible, to move the
wireless and wpan pointers to ml_priv.

	struct wireless_dev	*ieee80211_ptr;
	struct wpan_dev		*ieee802154_ptr;

> That way other device types which are limited by all being=20
> ARPHDR_ETHER can start using ml_priv as well?
>=20
> > +#if IS_ENABLED(CONFIG_CAN)
> > +	struct can_ml_priv	*can;
> > +#endif
>=20
> Perhaps put it next to all the _ptr fields?

Makes sense. Oleksij will resping the series.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--7lq5rzmnwt7rxwny
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmAKu2QACgkQqclaivrt
76nqjgf/WQLZN1prQ6aSfMcYqQnSDRDOM9Ey3xx+A5Fu6VBsf5pbGFkDSykCVVqe
dNXGNgen6JqaJ2woIvKMzR4WOSy/8OIb1A8H3yhY6OCdaCaB0jyqFOx+25wrmGY9
VebJ7qel8Vs/xfijb/N25BQv7HWe6uJZtqpfQBX54rvNyRLpry1jCGkxkp5U8ylC
BrzEyd/ouKIbl5aEJDY5eWyZ7ZRVJ+scBc8JkHK7Ls4m1lj3z4isRR31X7h5cB2j
4PgCO/OEkvOiePj9K1NeziKwE6IY8HBlm3Ryop/EJeVcwg5T/plcM8RLi8+r0rKc
UqAdUnwgSZnPF4wWagZXe+PtPj80bA==
=6QPW
-----END PGP SIGNATURE-----

--7lq5rzmnwt7rxwny--

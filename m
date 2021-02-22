Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8AB321F71
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 19:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbhBVSyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 13:54:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232117AbhBVSwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 13:52:49 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F31C061793
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 10:51:58 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lEGJ6-0008Gn-TH; Mon, 22 Feb 2021 19:51:44 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:52ba:71b5:63be:d0d8])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 2A7515E71DB;
        Mon, 22 Feb 2021 18:51:42 +0000 (UTC)
Date:   Mon, 22 Feb 2021 19:51:41 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Robin van der Gracht <robin@protonic.nl>,
        kernel@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH net v1 3/3] [RFC] mac80211: ieee80211_store_ack_skb():
 make use of skb_clone_sk_optional()
Message-ID: <20210222185141.oma64d4uq64pys45@pengutronix.de>
References: <20210222151247.24534-1-o.rempel@pengutronix.de>
 <20210222151247.24534-4-o.rempel@pengutronix.de>
 <3823be537c3c138de90154835573113c6577188e.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qcmaz5my6wsby6p5"
Content-Disposition: inline
In-Reply-To: <3823be537c3c138de90154835573113c6577188e.camel@sipsolutions.net>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--qcmaz5my6wsby6p5
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 22.02.2021 17:30:59, Johannes Berg wrote:
> On Mon, 2021-02-22 at 16:12 +0100, Oleksij Rempel wrote:
> > This code is trying to clone the skb with optional skb->sk. But this
> > will fail to clone the skb if socket was closed just after the skb was
> > pushed into the networking stack.
>=20
> Which IMHO is completely fine. If we then still clone the SKB we can't
> do anything with it, since the point would be to ... send it back to the
> socket, but it's gone.

Ok, but why is the skb cloned if there is no socket linked in skb->sk?

| static u16 ieee80211_store_ack_skb(struct ieee80211_local *local,
| 				   struct sk_buff *skb,
| 				   u32 *info_flags,
| 				   u64 *cookie)
| {
| 	struct sk_buff *ack_skb;
| 	u16 info_id =3D 0;
|=20
| 	if (skb->sk)
| 		ack_skb =3D skb_clone_sk(skb);
| 	else
| 		ack_skb =3D skb_clone(skb, GFP_ATOMIC);

Looks like this is dead code, since both callers of
ieee80211_store_ack_skb() first check if there is a skb->sk

| 	if (unlikely(!multicast && ((skb->sk &&
| 		     skb_shinfo(skb)->tx_flags & SKBTX_WIFI_STATUS) ||
| 		     ctrl_flags & IEEE80211_TX_CTL_REQ_TX_STATUS)))
| 		info_id =3D ieee80211_store_ack_skb(local, skb, &info_flags,
| 						  cookie);

> Nothing to fix here, I'd think. If you wanted to get a copy back that
> gives you the status of the SKB, it should not come as a huge surprise
> that you have to keep the socket open for that :)
>=20
> Having the ACK skb will just make us do more work by handing it back
> to skb_complete_wifi_ack() at TX status time, which is supposed to put
> it into the socket's error queue, but if the socket is closed ... no
> point in that.

We haven't looked at the callers of ieee80211_store_ack_skb().

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--qcmaz5my6wsby6p5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmAz/ToACgkQqclaivrt
76m93wf/eWUzTatxExdw00AuLvib66LXKeD9tLGTQx/Lc7sJ66kOcJ91wO7VKTIY
2HRsx2m23gP1jkxX1fHFg2BsreVXHdZqE5TycY7FM2vW5dqhsKdZD7Ts43uc9pxI
XHYDmBlF7oUeoibHpKp5bp3hTruvAGQ/nw4UJ/vymQ8RLEZia8u1W3neQwBcQaTa
MS+fg4FzktN4VcDzMr5lLCuUsxFV7hUZF+PqPYeeHvF1ymdJHviuaqpIX/ZimpIR
X+/Ka56E9bgodvkLIFupXin4CTe01fCqRiHxyPLqVL0zHLIMbYqAKIp5d4aIpNMA
9ojbC9JrGBO0ku47jjTzB3ESXC6wRg==
=j/gi
-----END PGP SIGNATURE-----

--qcmaz5my6wsby6p5--

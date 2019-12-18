Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B16241243C4
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 10:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbfLRJzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 04:55:46 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:43069 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbfLRJzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 04:55:45 -0500
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ihW3R-0001NJ-RA; Wed, 18 Dec 2019 10:55:41 +0100
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1ihW3Q-0007x5-GX; Wed, 18 Dec 2019 10:55:40 +0100
Date:   Wed, 18 Dec 2019 10:55:40 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     dev.kurt@vandijck-laurijssen.be, mkl@pengutronix.de,
        wg@grandegger.com, netdev@vger.kernel.org, kernel@pengutronix.de,
        linux-can@vger.kernel.org
Subject: Re: [PATCH v1] can: j1939: transport: j1939_simple_recv(): ignore
 local J1939 messages send not by J1939 stack
Message-ID: <20191218095540.f2vo7mh6jist525h@pengutronix.de>
References: <20191218084355.24398-1-o.rempel@pengutronix.de>
 <c2e25142-8104-872e-3e33-63307a2d34ab@hartkopp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="dordl4f3qk6nk7a4"
Content-Disposition: inline
In-Reply-To: <c2e25142-8104-872e-3e33-63307a2d34ab@hartkopp.net>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:32:25 up 33 days, 51 min, 38 users,  load average: 0.29, 0.09,
 0.07
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--dordl4f3qk6nk7a4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 18, 2019 at 10:03:27AM +0100, Oliver Hartkopp wrote:
> Hi Oleksij,
>=20
> On 18/12/2019 09.43, Oleksij Rempel wrote:
> > In current J1939 stack implementation, we process all locally send
> > messages as own messages. Even if it was send by CAN_RAW socket.
> >=20
> > To reproduce it use following commands:
> > testj1939 -P -r can0:0x80 &
> > cansend can0 18238040#0123
> >=20
> > This step will trigger false positive not critical warning:
> > j1939_simple_recv: Received already invalidated message
> >=20
> > With this patch we add additional check to make sure, related skb is own
> > echo message.
>=20
> in net/can/raw.c we check whether the CAN has been sent from that socket =
(an
> by default suppress our own transmitted data):
>=20
> https://elixir.bootlin.com/linux/v5.4.3/source/net/can/raw.c#L124
>=20
> would checking against the 'sk' work for you too?

The J1939 stack work per interface. On each interface we have J1939
privat data with session list.
For each new transfer we register a new session and wait for echo
package to confirm the state of this session.
On recv, if skb->sk is set, we assume, it is echo message, so we searching =
for
related session to complete or continue with it. Since each session created=
 on
sendmsg path is bound to one of sockets, we won't be able to say if this sk=
b->sk
refers to valid but released socket. Or there is some kind of bug which nee=
d to
be fixed.

Searching for the session make sense only if message was handled/send by
the local kernel j1939 stack. If there are other, for example user space j1=
939
implementations, we should handle them as remote not local stacks. So,
there should be no difference to other j1939 devices on the CAN bus.

J1939 kernel stack cares about echo messages to guarantee proper
ordering of data and control packets on the bus.=20

>=20
> What happens if someone runs a J1939 implementation on a CAN_RAW socket in
> addition to the in-kernel implementation? Can they talk to each other?

Yes. This patch addressing exactly this use case. It is just eliminate
false positive echo handling.

Regards,
Oleksij
=20
> > Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> >   net/can/j1939/socket.c    | 1 +
> >   net/can/j1939/transport.c | 4 ++++
> >   2 files changed, 5 insertions(+)
> >=20
> > diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
> > index f7587428febd..b9a17c2ee16f 100644
> > --- a/net/can/j1939/socket.c
> > +++ b/net/can/j1939/socket.c
> > @@ -398,6 +398,7 @@ static int j1939_sk_init(struct sock *sk)
> >   	spin_lock_init(&jsk->sk_session_queue_lock);
> >   	INIT_LIST_HEAD(&jsk->sk_session_queue);
> >   	sk->sk_destruct =3D j1939_sk_sock_destruct;
> > +	sk->sk_protocol =3D CAN_J1939;
> >   	return 0;
> >   }
> > diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
> > index 9f99af5b0b11..b135c5e2a86e 100644
> > --- a/net/can/j1939/transport.c
> > +++ b/net/can/j1939/transport.c
> > @@ -2017,6 +2017,10 @@ void j1939_simple_recv(struct j1939_priv *priv, =
struct sk_buff *skb)
> >   	if (!skb->sk)
> >   		return;
> > +	if (skb->sk->sk_family !=3D AF_CAN ||
> > +	    skb->sk->sk_protocol !=3D CAN_J1939)
> > +		return;
> > +
> >   	j1939_session_list_lock(priv);
> >   	session =3D j1939_session_get_simple(priv, skb);
> >   	j1939_session_list_unlock(priv);
> >=20
>=20
>=20

--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--dordl4f3qk6nk7a4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl3595sACgkQ4omh9DUa
UbMW7BAAjXVtTOSm4PyNkSZDSaXtwPr5wUxzO7qff4Sb2HXJKUTb92aDuFMsAI3Z
693+/oeKjV1qs8YTjDyIDB4ogcgwkzj5Qi4oWekXWpd6dmoy80n17nV/MhmcywPZ
FRBK5lXsNpwBXETlCAwJ2+3WosrmicIrPE4kf0akdmkoLnd/gf5DudtFPWdxAE/Y
SdriZFCKYCfX0ostLR+uH9sJVdYfRFD/hTdqWPGq65BK/G21/E2083x9rY0cpr4Y
ejxomtAcCVWEQTYHue7ZqycjLisPIbYwfRtRgsC2aBbCqgV9Tgp8GPEEQaypNPHr
9l0+L5652MHHnSLDaQ3MS6AZ0Mn0tG9j9h5bHkRrytlXkQ2hJhbVjK98WOQGzhWt
pcc0SkI6z45Y+4uSY1e3OxxjOX+/1m6dqU5DdmlMIOu8t57vse9SMKSTPghN/5iN
jvlCexivbm+uL+AsgsPu7LlqlenYDZfqTz6wOnqbvoDX1tsGzqCqNqulooWAGmHd
91PcHcv04//scFnGQd/E3KEh9S2FRnyYJd3o45j7gTSA3+zPxmkAP6IXUB511oGM
E64w8ygWXmfRqO0s5GY4serWtwxGRQjhqIJLc9tEXD/ER41NWCQQutAwk/58zHeX
AAZSrDnTGNjtLmMRHaS+B3QdWWFURYTW+26SUa9tMbPGIHTBYlU=
=EV2p
-----END PGP SIGNATURE-----

--dordl4f3qk6nk7a4--

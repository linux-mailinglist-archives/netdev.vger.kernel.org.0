Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 476CC13DB3A
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 14:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgAPNM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 08:12:26 -0500
Received: from mail.katalix.com ([3.9.82.81]:52372 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726018AbgAPNM0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 08:12:26 -0500
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 84EF288CB1;
        Thu, 16 Jan 2020 13:12:24 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=katalix.com; s=mail;
        t=1579180344; bh=gZs7wA8fL0VOIYKvp+xkyVXk9f8xO9c4hwuBEM1SoJI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iEWF0L5fqD3drPmjW/ytYQ6GTCz6BKfgHJ58UBXO8MuGDSKGmnatvDodzg/67bHHz
         xacZb4Zu2afy8OcFVNbBOvq3p6oIwVobUDM249iYQjTbsdCuWlNF3HSHW50eOPniHo
         LgaeHQ1LPDamrz+dFONNu+GyAcYeF0q67yf/J3SDgyq/1kZjhSpncIzcyQE3Sn6OHg
         N6aEKBeF4IyWS83uP96tKS8O/IcJjXxGI2KaeiSKxvz3fo+HlHp6keSUd1BNTlqHVS
         8rnf16xPEmOJI6a8pJhphWPWaJroY0rL/yS44a3tg/Jcqdf1/RKWUiupxMEZ9SP0m3
         yYxTZ1KM7g6ig==
Date:   Thu, 16 Jan 2020 13:12:24 +0000
From:   Tom Parkin <tparkin@katalix.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Ridge Kennedy <ridge.kennedy@alliedtelesis.co.nz>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] l2tp: Allow duplicate session creation with UDP
Message-ID: <20200116131223.GB4028@jackdaw>
References: <20200115223446.7420-1-ridge.kennedy@alliedtelesis.co.nz>
 <20200116123854.GA23974@linux.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="uQr8t48UFsdbeI+V"
Content-Disposition: inline
In-Reply-To: <20200116123854.GA23974@linux.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--uQr8t48UFsdbeI+V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Thu, Jan 16, 2020 at 13:38:54 +0100, Guillaume Nault wrote:
> Well, I think we have a more fundamental problem here. By adding
> L2TPoUDP sessions to the global list, we allow cross-talks with L2TPoIP
> sessions. That is, if we have an L2TPv3 session X running over UDP and
> we receive an L2TP_IP packet targetted at session ID X, then
> l2tp_session_get() will return the L2TP_UDP session to l2tp_ip_recv().
>=20
> I guess l2tp_session_get() should be dropped and l2tp_ip_recv() should
> look up the session in the context of its socket, like in the UDP case.
>=20
> But for the moment, what about just not adding L2TP_UDP sessions to the
> global list? That should fix both your problem and the L2TP_UDP/L2TP_IP
> cross-talks.
>=20
> diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
> index f82ea12bac37..f70fea8d093d 100644
> --- a/net/l2tp/l2tp_core.c
> +++ b/net/l2tp/l2tp_core.c
> @@ -316,7 +316,7 @@ int l2tp_session_register(struct l2tp_session *sessio=
n,
>  			goto err_tlock;
>  		}
> =20
> -	if (tunnel->version =3D=3D L2TP_HDR_VER_3) {
> +	if (tunnel->encap =3D=3D L2TP_ENCAPTYPE_IP) {
>  		pn =3D l2tp_pernet(tunnel->l2tp_net);
>  		g_head =3D l2tp_session_id_hash_2(pn, session->session_id);
> =20
> @@ -1587,8 +1587,8 @@ void __l2tp_session_unhash(struct l2tp_session *ses=
sion)
>  		hlist_del_init(&session->hlist);
>  		write_unlock_bh(&tunnel->hlist_lock);
> =20
> -		/* For L2TPv3 we have a per-net hash: remove from there, too */
> -		if (tunnel->version !=3D L2TP_HDR_VER_2) {
> +		/* For IP encap we have a per-net hash: remove from there, too */
> +		if (tunnel->encap =3D=3D L2TP_ENCAPTYPE_IP) {
>  			struct l2tp_net *pn =3D l2tp_pernet(tunnel->l2tp_net);
>  			spin_lock_bh(&pn->l2tp_session_hlist_lock);
>  			hlist_del_init_rcu(&session->global_hlist);
>

I agree with you about the possibility for cross-talk, and I would
welcome l2tp_ip/ip6 doing more validation.  But I don't think we should
ditch the global list.

As per the RFC, for L2TPv3 the session ID should be a unique
identifier for the LCCE.  So it's reasonable that the kernel should
enforce that when registering sessions.

When you're referring to cross-talk, I wonder whether you have in mind
normal operation or malicious intent?  I suppose it would be possible
for someone to craft session data packets in order to disrupt a
session.

For normal operation, you just need to get the wrong packet on the
wrong socket to run into trouble of course.  In such a situation
having a unique session ID for v3 helps you to determine that
something has gone wrong, which is what the UDP encap recv path does
if the session data packet's session ID isn't found in the context of
the socket that receives it.

--uQr8t48UFsdbeI+V
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAl4gYTIACgkQlIwGZQq6
i9BUngf8DyOmTQNYvPCbwysawtB8Rb9TynQdzW+FMXSmkNLMMEpB2JT2mKDjhOn2
7ALro3OvNbJ4wCpDC4VQizhoBn2jYvdnwJMcOYTLqQX29WWKs7rlrDpk6mLtRtyB
HeIf1kmJcvvaLBrn3RhqhDJfRGqT3dNhn+OPHdjDZhuAWmxw43fqCIsRzbsYCyP8
sBMUucJ2mJ8brzvaZg7ZxdY1/unRAacto/aoiU0PJkM6WkVmfnanUpVq0fZuejYX
9e4miPb7u+1R52whxCQjqZV42iXA/kfHbngNjBu/PCiePDfx86zU5EzjwSrTLTg3
tzm6uu85ZV/vKN2IdojB7NX2HjjHQQ==
=AMdL
-----END PGP SIGNATURE-----

--uQr8t48UFsdbeI+V--

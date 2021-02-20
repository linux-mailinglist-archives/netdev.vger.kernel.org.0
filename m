Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE648320789
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 23:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbhBTWvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Feb 2021 17:51:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbhBTWvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Feb 2021 17:51:04 -0500
X-Greylist: delayed 2648 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 20 Feb 2021 14:50:21 PST
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D65EC061574
        for <netdev@vger.kernel.org>; Sat, 20 Feb 2021 14:50:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=K/HF3U+OLve6l1W68rd5VH1GOHjztmXZWlAk24m4ztg=; b=DL8NhJxl1Rw8NNF0q2qpil4k7/
        qgAHJjRFH31TY1br1QxwDwmJPXOrbC23WAimcXBMmJuilRv0hHMfr3CB+I+elbxiD+6GVAPNqlXCK
        sO5JptCXXKOzdIf5mA+0BZMxbSelNPfCb1ZDkjlzhWY4Q1YdzdWIN9Rd4kw3G+/taOT8zJcRTvXWO
        YS/MMWhIGTr8TaA9tE6qqMuoRVhwzARGmOvJm9o8FWSFF5AhqzyRVsjwfruOwbgmq/Bez55kVYwON
        o228d7rYWsdgFxLXFlK0BoXXLBmOwr+bYI2WECmVC89tT05IncNC0Y8pQc0j8yJxLTr8roRARyMeh
        1q8KO/3Q==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:7c7a:91ff:fe7e:d268] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1lDaO5-0006Zs-5R; Sat, 20 Feb 2021 22:06:05 +0000
Date:   Sat, 20 Feb 2021 22:06:03 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     David Miller <davem@davemloft.net>
Cc:     redsky110@gmail.com, edumazet@google.com, netdev@vger.kernel.org
Subject: Re: [PATCH] tcp: avoid unnecessary loop if even ports are used up
Message-ID: <YDGHyxkTUGcuQbNZ@azazel.net>
References: <20210220110356.84399-1-redsky110@gmail.com>
 <20210220.134402.2070871604757928182.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5qv8PKDBC35jhi28"
Content-Disposition: inline
In-Reply-To: <20210220.134402.2070871604757928182.davem@davemloft.net>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:7c7a:91ff:fe7e:d268
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--5qv8PKDBC35jhi28
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-02-20, at 13:44:02 -0800, David Miller wrote:
> From: Honglei Wang <redsky110@gmail.com>
> Date: Sat, 20 Feb 2021 19:03:56 +0800
>
> > We are getting port for connect() from even ports firstly now. This
> > makes bind() users have more available slots at odd part. But there is a
> > problem here when the even ports are used up. This happens when there
> > is a flood of short life cycle connections. In this scenario, it starts
> > getting ports from the odd part, but each requirement has to walk all of
> > the even port and the related hash buckets (it probably gets nothing
> > before the workload pressure's gone) before go to the odd part. This
> > makes the code path __inet_hash_connect()->__inet_check_established()
> > and the locks there hot.
> >
> > This patch tries to improve the strategy so we can go faster when the
> > even part is used up. It'll record the last gotten port was odd or even,
> > if it's an odd one, it means there is no available even port for us and
> > we probably can't get an even port this time, neither. So we just walk
> > 1/16 of the whole even ports. If we can get one in this way, it probably
> > means there are more available even part, we'll go back to the old
> > strategy and walk all of them when next connect() comes. If still can't
> > get even port in the 1/16 part, we just go to the odd part directly and
> > avoid doing unnecessary loop.
> >
> > Signed-off-by: Honglei Wang <redsky110@gmail.com>
> > ---
> >  net/ipv4/inet_hashtables.c | 21 +++++++++++++++++++--
> >  1 file changed, 19 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
> > index 45fb450b4522..c95bf5cf9323 100644
> > --- a/net/ipv4/inet_hashtables.c
> > +++ b/net/ipv4/inet_hashtables.c
> > @@ -721,9 +721,10 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
> >  	struct net *net = sock_net(sk);
> >  	struct inet_bind_bucket *tb;
> >  	u32 remaining, offset;
> > -	int ret, i, low, high;
> > +	int ret, i, low, high, span;
> >  	static u32 hint;
> >  	int l3mdev;
> > +	static bool last_port_is_odd;
> >
> >  	if (port) {
> >  		head = &hinfo->bhash[inet_bhashfn(net, port,
> > @@ -756,8 +757,19 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
> >  	 */
> >  	offset &= ~1U;
> >  other_parity_scan:
> > +	/* If the last available port is odd, it means
> > +	 * we walked all of the even ports, but got
> > +	 * nothing last time. It's telling us the even
> > +	 * part is busy to get available port. In this
> > +	 * case, we can go a bit faster.
> > +	 */
> > +	if (last_port_is_odd && !(offset & 1) && remaining > 32)
>
> The first time this executes, won't last_port_is_odd be uninitialized?

It's declared static, so it will be zero-initialized.

J.

--5qv8PKDBC35jhi28
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmAxh8QACgkQKYasCr3x
BA12xBAAoV5hZTbTZbnwJmZC1t9EtDZWZetLMLcclYW31YGp9ZSo7gvCOgHuTEJ1
wFiuuSQsFMgotnDD1qtklXuydK04rIGri2kTX3swFMwCz1cFad/VvFmXRk1I0MM/
KBLN+/JATAVjHNeMd0IdFHDe1GO78/1s9amsfZj7cLM2j7kJqR3wM/J5+yhEe8LD
s/AG07Up1hLTIY8ublE8hZ12jrqtGgT+Xm8Yv+y5bP7bgrRzkMHNIq4K1+sJ+QHV
UraypJjYrJcvfIMVNQTR3H4fc/f9yhzHoPn1lmrbGkVgTZ9czixE06zG2DlPfnhp
axk1AL63FNbv31jqaPjYQkIEMetNvhnV2Jwk2xrgZmiW+e4jfTHSS9DcyGsd62/5
KbTvTrJ37fHFv6Vth4wCimQ43nDgw4Fn+pKXJW6GsR+IWCBOjZnrR7+bYSHa0rcU
Pmk24eZ+1/yzEGjn4Oihg/BQ3YVymreY8u+iUMZrWbV8A9qnwyTjH1OM88iY11zx
uXdy0mrN0a2FP2aDueioVcTJu2VjphtMMk6boU4/7LTZzLln54c/86EwkfOw1s7C
Hlu2yosn9LnEVvjfBMhif9wJXevbhEcxysU6VDQK4q+/LzP1CTg8Hz7n8JGO5etM
L5P5uzmas7xCo+gHv7VZ/K3HaBEHDLOXfAsGwM1h7aq8VdytLao=
=GTCL
-----END PGP SIGNATURE-----

--5qv8PKDBC35jhi28--

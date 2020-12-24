Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7571A2E279F
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 15:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728334AbgLXOZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 09:25:14 -0500
Received: from mail.katalix.com ([3.9.82.81]:52450 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727144AbgLXOZO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Dec 2020 09:25:14 -0500
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 79B607D496;
        Thu, 24 Dec 2020 14:24:32 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1608819872; bh=jNOi0hSPHlJyw+NSkrS6mIuQu0x16xHp3SmhQ1urGto=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Thu,=2024=20Dec=202020=2014:24:32=20+0000|From:=20Tom=20P
         arkin=20<tparkin@katalix.com>|To:=20Guillaume=20Nault=20<gnault@re
         dhat.com>|Cc:=20netdev@vger.kernel.org,=20jchapman@katalix.com|Sub
         ject:=20Re:=20[PATCH=20net]=20ppp:=20hold=20mutex=20when=20unbridg
         ing=20channels=20in=0D=0A=20unregister=20path|Message-ID:=20<20201
         224142431.GA4594@katalix.com>|References:=20<20201223184730.30057-
         1-tparkin@katalix.com>=0D=0A=20<20201224102818.GA27423@linux.home>
         |MIME-Version:=201.0|Content-Disposition:=20inline|In-Reply-To:=20
         <20201224102818.GA27423@linux.home>;
        b=UYI9lny+5lhfP2FMDnIJXpyPNwafkJceMMDq8Nn4zWTdoAPYKCiJvnGDujGrh9vb7
         YTSZuiD4OGTFqbVZ9k+W9Q7vSulND7Zh5lxmCOmPDnbiiUaW/smKuG6IUvvM3jOccI
         XtajUVtTFL1TN+qVSyPey5kJF2zSQPQyLmj3qienouSe1vwmwkAjYUY5nvEm1jre/J
         uhIpvAzam9XDgE10VFn2SWAgXfyNbPTJyR/ftzlf2WolcI4Aa3b+jTn9j1UvwY+4OZ
         5cuO1rmmxr5OjVQ9jliZcKPS/fuSP9fS00sQ8HH+o8E8atAIq3ko3/I7vfsMcu1FNc
         o/vsqTmaqV7dw==
Date:   Thu, 24 Dec 2020 14:24:32 +0000
From:   Tom Parkin <tparkin@katalix.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     netdev@vger.kernel.org, jchapman@katalix.com
Subject: Re: [PATCH net] ppp: hold mutex when unbridging channels in
 unregister path
Message-ID: <20201224142431.GA4594@katalix.com>
References: <20201223184730.30057-1-tparkin@katalix.com>
 <20201224102818.GA27423@linux.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
In-Reply-To: <20201224102818.GA27423@linux.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Thu, Dec 24, 2020 at 11:28:18 +0100, Guillaume Nault wrote:
> On Wed, Dec 23, 2020 at 06:47:30PM +0000, Tom Parkin wrote:
> > Channels are bridged using the PPPIOCBRIDGECHAN ioctl, which executes
> > with the ppp_mutex held.
> >=20
> > Unbridging may occur in two code paths: firstly an explicit
> > PPPIOCUNBRIDGECHAN ioctl, and secondly on channel unregister.  The
> > latter may occur when closing the /dev/ppp instance or on teardown of
> > the channel itself.
> >=20
> > This opens up a refcount underflow bug if ppp_bridge_channels called vi=
a.
> > ioctl races with ppp_unbridge_channels called via. file release.
> >=20
> > The race is triggered by ppp_unbridge_channels taking the error path
>=20
> This is actually ppp_bridge_channels.
>=20

Will fix, thanks.

> > through the 'err_unset' label.  In this scenario, pch->bridge has been
> > set, but no reference will be taken on pch->file because the function
> > errors out.  Therefore, if ppp_unbridge_channels is called in the window
> > between pch->bridge being set and pch->bridge being unset, it will
> > erroneously drop the reference on pch->file and cause a refcount
> > underflow.
> >=20
> > To avoid this, hold the ppp_mutex while calling ppp_unbridge_channels in
> > the shutdown path.  This serialises the unbridge operation with any
> > concurrently executing ioctl.
> >=20
> > Signed-off-by: Tom Parkin <tparkin@katalix.com>
> > ---
> >  drivers/net/ppp/ppp_generic.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >=20
> > diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generi=
c.c
> > index 09c27f7773f9..e87a05fee2db 100644
> > --- a/drivers/net/ppp/ppp_generic.c
> > +++ b/drivers/net/ppp/ppp_generic.c
> > @@ -2938,7 +2938,9 @@ ppp_unregister_channel(struct ppp_channel *chan)
> >  	list_del(&pch->list);
> >  	spin_unlock_bh(&pn->all_channels_lock);
> > =20
> > +	mutex_lock(&ppp_mutex);
> >  	ppp_unbridge_channels(pch);
> > +	mutex_unlock(&ppp_mutex);
> > =20
> >  	pch->file.dead =3D 1;
> >  	wake_up_interruptible(&pch->file.rwait);
> > --=20
> > 2.17.1
> >=20
>=20
> The problem is that assigning ->bridge and taking a reference on that
> channel isn't atomic. Holding ppp_mutex looks like a workaround for
> this problem.

You're quite right -- that is the underlying issue.

> I think the refcount should be taken before unlocking ->upl in
> ppp_bridge_channels().

Aye, that's the other option :-)

I wasn't sure whether it was better to use the same locking structure
as the ioctl call, or to rework the code to make the two things
effectively atomic as you suggest.

I'll try this approach.

Thanks for your review!

>=20
> Something like this (completely untested):
>=20
> ---- 8< ----
>  static int ppp_bridge_channels(struct channel *pch, struct channel *pchb)
>  {
>  	write_lock_bh(&pch->upl);
>  	if (pch->ppp ||
>  	    rcu_dereference_protected(pch->bridge, lockdep_is_held(&pch->upl)))=
 {
>  		write_unlock_bh(&pch->upl);
>  		return -EALREADY;
>  	}
> +
> +	refcount_inc(&pchb->file.refcnt);
>  	rcu_assign_pointer(pch->bridge, pchb);
>  	write_unlock_bh(&pch->upl);
>=20
> 	write_lock_bh(&pchb->upl);
> 	if (pchb->ppp ||
> 	    rcu_dereference_protected(pchb->bridge, lockdep_is_held(&pchb->upl))=
) {
> 		write_unlock_bh(&pchb->upl);
> 		goto err_unset;
> 	}
> +
> +	refcount_inc(&pch->file.refcnt);
> 	rcu_assign_pointer(pchb->bridge, pch);
> 	write_unlock_bh(&pchb->upl);
>=20
> -	refcount_inc(&pch->file.refcnt);
> -	refcount_inc(&pchb->file.refcnt);
> -
> 	return 0;
>=20
> err_unset:
> 	write_lock_bh(&pch->upl);
> 	RCU_INIT_POINTER(pch->bridge, NULL);
> 	write_unlock_bh(&pch->upl);
> 	synchronize_rcu();
> +
> +	if (refcount_dec_and_test(&pchb->file.refcnt))
> +		ppp_destroy_channel(pchb);
> +
> 	return -EALREADY;
> }
>=20

--huq684BweRXVnRxX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAl/kpJsACgkQlIwGZQq6
i9A+Fwf/ahnyKKlJisYH/TYkSE02nFwVY9iyGcrGqz+7dN1IbVmqzljBvrDnhAne
/MUhk0DZWniiJdAtj5KrxdpYiUywvUfnanFPbUGC0i/P1Mzlm0z5ZTIA25IJAqKx
Os2rwI/szW3dEM8BXkUAezP70f7COtawbsTiivdQA7Qmz7n3gwYHxAj2+G1O8fst
SfwTVvaFtNJsjKUnQIobzSuX9zF6pzSUHfS8wNzmj1H6DjAuQB7b/z1dprWqTTlN
tLEpD81RGZRqMzz0CxmnlbzPSCrcHgpW3LPdYHjm3AFYcIkiVHqKFZwys8sW4OXI
DRFxxaGHI7SB5vif0Kt4lKDK6U2H9Q==
=o3gS
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--

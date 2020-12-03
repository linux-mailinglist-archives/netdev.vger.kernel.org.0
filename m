Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD8CB2CD4FD
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 12:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728141AbgLCL6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 06:58:01 -0500
Received: from mail.katalix.com ([3.9.82.81]:58760 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726360AbgLCL6A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 06:58:00 -0500
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 6DE09832DC;
        Thu,  3 Dec 2020 11:57:18 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1606996638; bh=NwkP1PRvbtFWnNlKlWk4wnQhkjwSusVCtXZTvj9yy5g=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Thu,=203=20Dec=202020=2011:57:18=20+0000|From:=20Tom=20Pa
         rkin=20<tparkin@katalix.com>|To:=20Guillaume=20Nault=20<gnault@red
         hat.com>|Cc:=20netdev@vger.kernel.org,=20jchapman@katalix.com|Subj
         ect:=20Re:=20[PATCH=20v2=20net-next=201/2]=20ppp:=20add=20PPPIOCBR
         IDGECHAN=20and=0D=0A=20PPPIOCUNBRIDGECHAN=20ioctls|Message-ID:=20<
         20201203115717.GA12568@katalix.com>|References:=20<20201201115250.
         6381-1-tparkin@katalix.com>=0D=0A=20<20201201115250.6381-2-tparkin
         @katalix.com>=0D=0A=20<20201203002318.GA31867@linux.home>|MIME-Ver
         sion:=201.0|Content-Disposition:=20inline|In-Reply-To:=20<20201203
         002318.GA31867@linux.home>;
        b=AYiPxjcabIIM+tdw7rJzSRVArzgTq4pYvw+nnwO6rZ43MfNzr3okpDQHJf+uBRMwz
         m3GHDKeDouLvp8EB+VoMKuKPAsoXZJ7wVuzEEv8Ebgbd/8dm/Zf2PDlyT+/spICiS5
         3nDd+kAs69JHtspavgkyYCcXJn1yqHDb7lpxtgX+Cpf3M2ROqN/9m+JG75jyYpZvl1
         OFNFIEwlJgX92/V7YdixeFc3WAk4GwCickAKkW1TDQDL0WeAB0MTJ7cyjEaUO+DO9e
         K7VE/bYHZ8eAUto4L03F99Y6yAaXOmqJbO+fEEVNdswvuAuigIDKVUirlJNGtLDlg/
         DJNk1fo/odp4Q==
Date:   Thu, 3 Dec 2020 11:57:18 +0000
From:   Tom Parkin <tparkin@katalix.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     netdev@vger.kernel.org, jchapman@katalix.com
Subject: Re: [PATCH v2 net-next 1/2] ppp: add PPPIOCBRIDGECHAN and
 PPPIOCUNBRIDGECHAN ioctls
Message-ID: <20201203115717.GA12568@katalix.com>
References: <20201201115250.6381-1-tparkin@katalix.com>
 <20201201115250.6381-2-tparkin@katalix.com>
 <20201203002318.GA31867@linux.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <20201203002318.GA31867@linux.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Thu, Dec 03, 2020 at 01:23:18 +0100, Guillaume Nault wrote:
> On Tue, Dec 01, 2020 at 11:52:49AM +0000, Tom Parkin wrote:
> > +static int ppp_bridge_channels(struct channel *pch, struct channel *pc=
hb)
> > +{
> > +	write_lock_bh(&pch->upl);
> > +	if (pch->ppp || pch->bridge) {
>=20
> Since ->bridge is RCU protected, it should be dereferenced with
> rcu_dereference_protected() here:
> rcu_dereference_protected(pch->bridge, lockdep_is_held(&pch->upl)).
>

Ack, thanks.

Ditto for the other callsites which should also be using=20
rcu_dereference_protected for access to the rcu-protected pointer.

<snip>

> > +	if (!pchb) {
> > +		write_unlock_bh(&pch->upl);
> > +		return -EINVAL;
>=20
> I'm not sure I'd consider this case as an error.

To be honest I'd probably tend agree with you, but I was seeking to
maintain consistency with how PPPIOCCONNECT/PPPIOCDISCONN behave.  The
latter returns EINVAL if the channel isn't connected to an interface.

If you feel strongly I'm happy to change it but IMO it's better to be
consistent with existing ioctl calls.

> If there's no bridged channel, there's just nothing to do.
> Furthermore, there might be situations where this is not really an
> error (see the possible race below).
>=20
> > +	}
> > +	RCU_INIT_POINTER(pch->bridge, NULL);
> > +	write_unlock_bh(&pch->upl);
> > +
> > +	write_lock_bh(&pchb->upl);
> > +	RCU_INIT_POINTER(pchb->bridge, NULL);
> > +	write_unlock_bh(&pchb->upl);
> > +
> > +	synchronize_rcu();
> > +
> > +	if (refcount_dec_and_test(&pch->file.refcnt))
> > +		ppp_destroy_channel(pch);
>=20
> I think that we could have a situation where pchb->bridge could be
> different from pch.
> If ppp_unbridge_channels() was also called concurrently on pchb, then
> pchb->bridge might have been already reset. And it might have dropped
> the reference it had on pch. In this case, we'd erroneously decrement
> the refcnt again.
>=20
> In theory, pchb->bridge might even have been reassigned to a different
> channel. So we'd reset pchb->bridge, but without decrementing the
> refcnt of the channel it pointed to (and again, we'd erroneously
> decrement pch's refcount instead).
>=20
> So I think we need to save pchb->bridge to a local variable while we
> hold pchb->upl, and then drop the refcount of that channel, instead of
> assuming that it's equal to pch.

Ack, yes.

The v1 series protected against this, although by nesting locks :-|

I think in the case that pchb->bridge !=3D pch, we probably want to
leave pchb alone, so:

 1. Don't unset the pchb->bridge pointer
 2. Don't drop the pch reference (pchb doesn't hold a reference on pch
    because pchb->bridge !=3D pch)

This is on the assumption that pchb has been reassigned -- in that
scenario we don't want to mess with pchb at all since it'll break the
other bridge instance.

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAl/I0pkACgkQlIwGZQq6
i9CdbAf/Wx7qyAetm7kLWV1c6jTcjqIYmMaC2oLX9VZGxMBSQAeAvvWpj2yxoVs1
GZ/uoWNNhQZW9+5lTeEOe5RffwL38A0h5ynIdFfcolS/nwgtasOBIputYmBTr+FF
b2f0PhbKIrnz0WxK/wsxC4tXymPFHcIIj3DV1zCw6svtCMX0h8hlJkZA4SRC9sY7
/P4a14tD4iFQTrNWVSR2ZpZV0yG48ydkGREX4PJSVZBH/oPHvcfN6tAlOdiYbyBa
Erv7QiioCm9m2zMlwfu0Vui2niJ8c0DbowOiV5xMK9MOY/9bmIBwdinZNwbUkyBc
jySZYMPJgxV5NhzcBu3u9pJX77+yYQ==
=xFRj
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--

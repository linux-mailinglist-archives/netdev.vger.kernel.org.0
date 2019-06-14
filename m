Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D20345A1E
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 12:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbfFNKNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 06:13:46 -0400
Received: from kadath.azazel.net ([81.187.231.250]:41998 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbfFNKNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 06:13:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=y+2SmSjytyTC5IVsWZZErE9+OucsHlIeGcUg5J1OkkQ=; b=FwcrZSLIFo5i3Yo9Geq7bl1wLy
        19JN+rnorpr49jEefeYJq+/iOoaVRbnCmnBchDvKbSmXkQmDMVd7g0eJA65boi/X+RmEESIbWF2gq
        SRAepySKY3HZepLO1E4kzP1m4UdvTmA7PhGJaFG+4lvKHkzOpDvvp9zjT5Hi7yEmvWesYEn339Y6I
        bFY17PFp0ZbZfLO+ufwjyVq7zQFpnvbeom7RrrCAqD+b0j0fp/jddLz0GDRTGbpoL77ktUGKPFIxe
        RkkKAuNqBkLNRtAYgH4hQzmVFfaln0NbwF+x4FAVm2pOdoUKdJfMEQq5yz/qj28zqf+4772+tx64B
        LrYcG1wQ==;
Received: from kadath.azazel.net ([2001:8b0:135f:bcd1:e2cb:4eff:fedf:e608] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <jeremy@azazel.net>)
        id 1hbjDI-0007fH-N4; Fri, 14 Jun 2019 11:13:40 +0100
Date:   Fri, 14 Jun 2019 11:13:38 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH] af_key: Fix memory leak in key_notify_policy.
Message-ID: <20190614101338.hia635sctr6qjmd2@azazel.net>
References: <1560500786-572-1-git-send-email-92siuyang@gmail.com>
 <20190614085346.GN17989@gauss3.secunet.de>
 <20190614095922.k5yzeyew2zhrfp7e@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rviigkadvxms4bsu"
Content-Disposition: inline
In-Reply-To: <20190614095922.k5yzeyew2zhrfp7e@azazel.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e2cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--rviigkadvxms4bsu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-06-14, at 10:59:22 +0100, Jeremy Sowden wrote:
> On 2019-06-14, at 10:53:46 +0200, Steffen Klassert wrote:
> > On Fri, Jun 14, 2019 at 04:26:26PM +0800, Young Xiao wrote:
> > > We leak the allocated out_skb in case pfkey_xfrm_policy2msg()
> > > fails.  Fix this by freeing it on error.
> > >
> > > Signed-off-by: Young Xiao <92siuyang@gmail.com>
> > > ---
> > >  net/key/af_key.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/net/key/af_key.c b/net/key/af_key.c
> > > index 4af1e1d..ec414f6 100644
> > > --- a/net/key/af_key.c
> > > +++ b/net/key/af_key.c
> > > @@ -2443,6 +2443,7 @@ static int key_pol_get_resp(struct sock *sk, struct xfrm_policy *xp, const struc
> > >  	}
> > >  	err = pfkey_xfrm_policy2msg(out_skb, xp, dir);
> > >  	if (err < 0)
> > > +		kfree_skb(out_skb);
> > >  		goto out;
> >
> > Did you test this?
> >
> > You need to add braces, otherwise 'goto out' will happen unconditionally.
> >
> > >
> > >  	out_hdr = (struct sadb_msg *) out_skb->data;
> > > @@ -2695,6 +2696,7 @@ static int dump_sp(struct xfrm_policy *xp, int dir, int count, void *ptr)
> > >
> > >  	err = pfkey_xfrm_policy2msg(out_skb, xp, dir);
> > >  	if (err < 0)
> > > +		kfree_skb(out_skb);
> > >  		return err;
> >
> > Same here.
>
> There's already a patch for this:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git/commit/?id=7c80eb1c7e2b8420477fbc998971d62a648035d9

That reminds me.  Stephen Rothwell reported a problem with the "Fixes:"
tag:

On 2019-05-29, at 07:48:12 +1000, Stephen Rothwell wrote:
> In commit
>
>   7c80eb1c7e2b ("af_key: fix leaks in key_pol_get_resp and dump_sp.")
>
> Fixes tag
>
>   Fixes: 55569ce256ce ("Fix conversion between IPSEC_MODE_xxx and XFRM_MODE_xxx.")
>
> has these problem(s):
>
>   - Subject does not match target commit subject
>     Just use
> 	git log -1 --format='Fixes: %h ("%s")'

What's the procedure for fixing this sort of thing?  Do you need me to
do anything?

J.

--rviigkadvxms4bsu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIyBAABCAAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl0Dc1EACgkQ0Z7UzfnX
9sO9Tg/2Lq+z+TSlIdlxJzt4GKU6dljPzSgkbG7OqpPlvtVHrvZnMO3cLvQ2V/vN
e4NXeZOg3HTXVdHe5s0gJ9twBwVKDqaxCGChCrczXtUfHTruupLJKOryupyUekHN
nXl1bshjFL6dAlFBu0q2TyTBjQYrR15g5N4sJJBOe2Njl2pVekBpBdXCGcPUcV+S
ykvhMM7pUxPK0fi47uFkyv2c5Tcbi2oDgK0oQkuA22R+xwlqxMvrin6nu7+ipvc1
OvEy197alTIlLXvjDMoV2SnJbTKr5/ji9mrmBxGhOpiJZFqJ98wDfiRCywXKHVyu
/zkhTvkuDaQ4qpJA00pJJ84NWrGHt3LNG0LaTFfZ67lfS07AdxEtBKq0TvLWEVpe
MHkO5TX9XSR2Dw6tFQ/iyqjGy7Utw2Pl7toZnKvfGnrpbpIkEwkSn61WAr18lGKd
hXP2yXYwJNPhwwDlxv9IEJz1Wkt0GD+0oZ351n6tUn8l9I+y2QYSFd9Cs48U7x1W
/U1doqNJZu2pXE/wxPyyGYDiAil7aoGD3PKYVUm3yIrT9Hf+kCQOdy+swPW4AX9z
GJ6RsmR1s+4kOj71/WoI0l136BEbC2WhS6PSRloOvnJvX4GC3qULXx1cKCoBkcs+
DvPrO21km2V8WwhxASUew6XcpqeBiArcf602iB/123d537utKA==
=hQ78
-----END PGP SIGNATURE-----

--rviigkadvxms4bsu--

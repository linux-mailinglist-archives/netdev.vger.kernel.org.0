Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5CD459C1
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 11:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbfFNJ7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 05:59:33 -0400
Received: from kadath.azazel.net ([81.187.231.250]:41598 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726767AbfFNJ7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 05:59:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+SqYUowZr52aqAdLPxRNaayVXCYX/FhSATpPUJOhNrw=; b=EJlBGeh1c7hJ9Ws6hHNTKAepg/
        tgaD0qi533U8Qu9foxsKUShJesrorJjYJNOgEqDWQUtG4vFR2Zb03OMDqWK8TdZGxhLCGQGwebKd8
        pq+euhq83cOJHmesuPoikyW7vzgsJP6jLvfXKVlIiDF4Ec4+o65kLduKheMcXMmWK869T85lagj2z
        3SniQ/Gz3ePrx+6k1+aKnO8JqJ/ZCHPTA3fNoNj66ncUYCeka+uEifFIKagcD4N2XBXCgmWTMyRRG
        7+sQ9vjH/WVuydB0MbDhki5nfmw8j4yc0+64HNCYqYf7yqbvNSNFeyLjkAlcqHR28qOg779JYaLeF
        DQsVL/0A==;
Received: from kadath.azazel.net ([2001:8b0:135f:bcd1:e2cb:4eff:fedf:e608] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <jeremy@azazel.net>)
        id 1hbizT-0006xV-OC; Fri, 14 Jun 2019 10:59:23 +0100
Date:   Fri, 14 Jun 2019 10:59:22 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Steffen Klassert <steffen.klassert@secunet.com>, g@azazel.net
Cc:     Young Xiao <92siuyang@gmail.com>, herbert@gondor.apana.org.au,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] af_key: Fix memory leak in key_notify_policy.
Message-ID: <20190614095922.k5yzeyew2zhrfp7e@azazel.net>
References: <1560500786-572-1-git-send-email-92siuyang@gmail.com>
 <20190614085346.GN17989@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="okvcvc2i7gz2dbyk"
Content-Disposition: inline
In-Reply-To: <20190614085346.GN17989@gauss3.secunet.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e2cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--okvcvc2i7gz2dbyk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-06-14, at 10:53:46 +0200, Steffen Klassert wrote:
> On Fri, Jun 14, 2019 at 04:26:26PM +0800, Young Xiao wrote:
> > We leak the allocated out_skb in case pfkey_xfrm_policy2msg() fails.
> > Fix this by freeing it on error.
> >
> > Signed-off-by: Young Xiao <92siuyang@gmail.com>
> > ---
> >  net/key/af_key.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/net/key/af_key.c b/net/key/af_key.c
> > index 4af1e1d..ec414f6 100644
> > --- a/net/key/af_key.c
> > +++ b/net/key/af_key.c
> > @@ -2443,6 +2443,7 @@ static int key_pol_get_resp(struct sock *sk, struct xfrm_policy *xp, const struc
> >  	}
> >  	err = pfkey_xfrm_policy2msg(out_skb, xp, dir);
> >  	if (err < 0)
> > +		kfree_skb(out_skb);
> >  		goto out;
>
> Did you test this?
>
> You need to add braces, otherwise 'goto out' will happen unconditionally.
>
> >
> >  	out_hdr = (struct sadb_msg *) out_skb->data;
> > @@ -2695,6 +2696,7 @@ static int dump_sp(struct xfrm_policy *xp, int dir, int count, void *ptr)
> >
> >  	err = pfkey_xfrm_policy2msg(out_skb, xp, dir);
> >  	if (err < 0)
> > +		kfree_skb(out_skb);
> >  		return err;
>
> Same here.

There's already a patch for this:

  https://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec.git/commit/?id=7c80eb1c7e2b8420477fbc998971d62a648035d9

J.

--okvcvc2i7gz2dbyk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl0Db/kACgkQ0Z7UzfnX
9sO+dg//X5IBarNnBL4+mJo1PVkihtoJNZib7SkyNpJjU74rQ5lfILTPWBKkxOHD
LFQt62krPp/IUE328UQthubS8BbJWSDJ7BF9HUtHlme2nZoxjgfPxvn3EvAkhQTn
DjoeP9hOrRgn1ufCqU09n+drVOl/tTxOZIuGK4XT0j0Ycp4PpW3fPng3gs5x4eNS
YPrLZU51nOU46GQW8b60BSgoG5h2YytLwJ4kicaJGjZxhZZOtKycrX5oc5YnnU8Z
ki7zUF/eU5Hni231wjhJBLs8uNTtll7g8Nl8oYogDlCo1EwFukScqS9dPXev7SKZ
4W9Xm8xP2aHAGvylJJhvFpqQ/gR5U9MkXr+gmc6uachuiZrbp3zCDyKgYt+hxZG9
lnLjLKxNm4Bc+Wwn38BvoBcg03q850BEUGdfANpM1l/aFS+va27MFGX0wnWFsVfV
ChOS0BfrqrOwpvLFUjFN7Ojvli+9Qs+KWiwHzp7dJFltnntif1J8i27T6v0cjQBL
irphre+3e96UgilQ/1+ygZQi/h4SwQzt8yEfGXo3Gx8sGb7VSaYS43oW3jzhH4Rm
WgQWyFnlzbUtaz/SZMXvj5vUaQhTUjpVHG/Ws5vkEE+ED7CGdu0r4J1j0+EfLQOi
TJPyklntEQv4rzJHQK18+InPJgQ7HTox2Yft8rfjEZ2dSa2R6UI=
=Llij
-----END PGP SIGNATURE-----

--okvcvc2i7gz2dbyk--

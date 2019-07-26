Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6307729D
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 22:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbfGZUQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 16:16:06 -0400
Received: from kadath.azazel.net ([81.187.231.250]:43578 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbfGZUQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 16:16:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=++d9OzFu4bcaSfReguJO8laE0J8Mf9ha36t3Tu6yPwM=; b=l2mWC2ZmRCzgwBpeeafFPMuXKJ
        mzfLPy690HuloO9JpUVs1kfuRcK6NxVGqYCSlaC8T7Hz/SBAj0x31HjsHJQg07koOrFCIk+Rrhn8p
        25C+hCLrwEO/UecYoUPj9ZRcSyr3TvDI8kf8HmqpBc7vdyWhdW/6zHWmgWcXyauek9r66ZyfXEnIn
        2UhQkkDStW6PnxWloxSwvDikCxu4BgJedhBzdOEcx62Sv/y1QOHgpdLdI7WglVNPNzvB3IT+jmEEA
        dX00S/3r/dqSEsqSK/Bf1/JPYQFvPCJkK7W4kSXPPAPGwZ2fh32lZH8XcViw/Hxr/2ncYNcrlExjH
        OaFlDDVA==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1hr6dA-000331-Tc; Fri, 26 Jul 2019 21:15:56 +0100
Date:   Fri, 26 Jul 2019 21:15:55 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Jia-Ju Bai <baijiaju1990@gmail.com>, herbert@gondor.apana.org.au,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: key: af_key: Fix possible null-pointer dereferences
 in pfkey_send_policy_notify()
Message-ID: <20190726201555.GA4745@azazel.net>
References: <20190724093509.1676-1-baijiaju1990@gmail.com>
 <20190726094514.GD14601@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
In-Reply-To: <20190726094514.GD14601@gauss3.secunet.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-07-26, at 11:45:14 +0200, Steffen Klassert wrote:
> On Wed, Jul 24, 2019 at 05:35:09PM +0800, Jia-Ju Bai wrote:
> > In pfkey_send_policy_notify(), there is an if statement on line 3081
> > to check whether xp is NULL:
> >     if (xp && xp->type != XFRM_POLICY_TYPE_MAIN)
> >
> > When xp is NULL, it is used by key_notify_policy() on line 3090:
> >     key_notify_policy(xp, ...)
> >         pfkey_xfrm_policy2msg_prep(xp) -- line 2211
> >             pfkey_xfrm_policy2msg_size(xp) -- line 2046
> >                 for (i=0; i<xp->xfrm_nr; i++) -- line 2026
> >                 t = xp->xfrm_vec + i; -- line 2027
> >     key_notify_policy(xp, ...)
> >         xp_net(xp) -- line 2231
> >             return read_pnet(&xp->xp_net); -- line 534
>
> Please don't quote random code lines, explain the problem instead.
>
> >
> > Thus, possible null-pointer dereferences may occur.
> >
> > To fix these bugs, xp is checked before calling key_notify_policy().
> >
> > These bugs are found by a static analysis tool STCheck written by
> > us.
> >
> > Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> > ---
> >  net/key/af_key.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/net/key/af_key.c b/net/key/af_key.c
> > index b67ed3a8486c..ced54144d5fd 100644
> > --- a/net/key/af_key.c
> > +++ b/net/key/af_key.c
> > @@ -3087,6 +3087,8 @@ static int pfkey_send_policy_notify(struct xfrm_policy *xp, int dir, const struc
> >  	case XFRM_MSG_DELPOLICY:
> >  	case XFRM_MSG_NEWPOLICY:
> >  	case XFRM_MSG_UPDPOLICY:
> > +		if (!xp)
> > +			break;
>
> I think this can not happen. Who sends one of these notifications
> without a pointer to the policy?

I had a quick grep and found two places where km_policy_notify is passed
NULL as the policy:

  $ grep -rn '\<km_policy_notify(NULL,' net/
  net/xfrm/xfrm_user.c:2154:      km_policy_notify(NULL, 0, &c);
  net/key/af_key.c:2788:  km_policy_notify(NULL, 0, &c);

They occur in xfrm_flush_policy() and pfkey_spdflush() respectively.

J.

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl07X18ACgkQ0Z7UzfnX
9sOaoRAAvKLpbuopo+hlUE9ONE3qQud6k9dgKtFWq6UYUlrFJbO3lZglmzUuAj/M
GrEiZNgUmwvtO7/uqzps4ajTvq2ZOhi3QtjqJtplp/qqZ36MILoaYWeLCANmA3Zq
eg2Tu6A+lAiuqYkmL9J+peCOe/0yoOW9BvcXuwNWs0Ca78zBQWYh0WnfiIbJ9nPJ
6Lj5OQpTJXEXU/Uidi1ZUo/S+woAP7f6DITUoPkBGJpNyxCxraPcaw1TARfNx+xW
TfP7/MQXmrJSsRetXy4WjNCENa752BPTZWRj6JmkDUQadVu+8GNvaamL5d+DJBh/
zAlKd6UOFVIe2SEnai/Zwx/jDjC5SIYoMLdJ8Gabl6sQ/5VCWrNlXU3EDUEdyT9h
H9GW8+No3EokPwPhu5EYm4sFfOPWLThvfSiQlrripuVKc9frlTEdbbQQNhHSuHy6
6U9+20JNQtBp/TzXA+sEqwE/Q+jCG7MemapIKyZTk+o0LSQYnWzMlCcPwPmDreOE
zmA0nwj8Zvss2fbuth9Agj5y+1LQORnRHLdUHBpfHds3cLGvKFHaFHIwwCiWimgC
ic69DH+BdC9ckML6/WZv0/e0Ku7RH4k3Gss4jLtYqudAfluc3AdLudBsbLiVK53x
V+YzNRsdzP9+wVNiuCUCgroCL/gTSN1sT77lYvXvIc+4tqFTPeE=
=RdeT
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--

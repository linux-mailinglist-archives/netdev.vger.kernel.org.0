Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9933D6811C
	for <lists+netdev@lfdr.de>; Sun, 14 Jul 2019 22:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbfGNUEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jul 2019 16:04:24 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36994 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728371AbfGNUEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jul 2019 16:04:24 -0400
Received: by mail-wm1-f66.google.com with SMTP id f17so13122862wme.2
        for <netdev@vger.kernel.org>; Sun, 14 Jul 2019 13:04:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=L74Hp2Md1/7GYbJXZgvp3T9BVkI8TzNnXd5I47nmZis=;
        b=DCG2RraOuLJpHLrdVaE45lf+mUbucScBPalx/sqf+j2eZIQ3IdCckOvh9v+fRy9bQ6
         kryYD3+CU5/MNXDrwuNe5sL3fDKmrLc+CSSoBiaSZ4wqoFttgW4GyhHAwjKVGnd4e4wI
         0R6ehJW3lp2ZL31jOlw3ljVpBWM7j4Ip5feoqFO9h43tF9692HDtVnB7enE80Wlf3POD
         itSxGUTvgLXYTmnghIE2tSOCwlu5dEPEqfjwWZJqHuu8iyoSUtHpZM0CcvMkDxnJWGL8
         5gqnyv3wf2Gc2b19KPKD6gOpgQu9VHjSnadQXGtzqrIs+1sO73mf86gCm+TA7CA/05fw
         JPTA==
X-Gm-Message-State: APjAAAXDPaOVG5ezOtDZtJ5rgRWBIi7lg02HtswCvILC4kkZXj4JFha3
        +tnmbBmBw4+phakVmXUYkWqR5A==
X-Google-Smtp-Source: APXvYqxVpE6RYLkehRdEl10Ki1gcyq4VjpZKH8wUJNnanE3lp9gx7rzmVWhgLuP3FY+t3QQQRTQABw==
X-Received: by 2002:a1c:f415:: with SMTP id z21mr21001389wma.34.1563134662572;
        Sun, 14 Jul 2019 13:04:22 -0700 (PDT)
Received: from localhost.localdomain ([151.66.36.246])
        by smtp.gmail.com with ESMTPSA id c11sm25972556wrq.45.2019.07.14.13.04.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 14 Jul 2019 13:04:21 -0700 (PDT)
Date:   Sun, 14 Jul 2019 22:04:18 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, marek@cloudflare.com
Subject: Re: [PATCH net v2] net: neigh: fix multiple neigh timer scheduling
Message-ID: <20190714200418.GA28813@localhost.localdomain>
References: <793a1166667e00a3553577e1505bebd435e22c88.1563041150.git.lorenzo.bianconi@redhat.com>
 <26f58e35-f1f8-9543-819f-ef7f52da1e49@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
In-Reply-To: <26f58e35-f1f8-9543-819f-ef7f52da1e49@gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 7/14/19 2:45 AM, Lorenzo Bianconi wrote:
> > @@ -1124,7 +1125,9 @@ int __neigh_event_send(struct neighbour *neigh, s=
truct sk_buff *skb)
> > =20
> >  			atomic_set(&neigh->probes,
> >  				   NEIGH_VAR(neigh->parms, UCAST_PROBES));
> > -			neigh->nud_state     =3D NUD_INCOMPLETE;
> > +			if (check_timer)
> > +				neigh_del_timer(neigh);
>=20
> Why not just always call neigh_del_timer and avoid the check_timer flag?
> Let the NUD_IN_TIMER flag handle whether anything needs to be done.

ack, I have been too paranoid here. I will post a v3 fixing it.

Regards,
Lorenzo

>=20
> > +			neigh->nud_state =3D NUD_INCOMPLETE;
> >  			neigh->updated =3D now;
> >  			next =3D now + max(NEIGH_VAR(neigh->parms, RETRANS_TIME),
> >  					 HZ/2);
> > @@ -1140,6 +1143,8 @@ int __neigh_event_send(struct neighbour *neigh, s=
truct sk_buff *skb)
> >  		}
> >  	} else if (neigh->nud_state & NUD_STALE) {
> >  		neigh_dbg(2, "neigh %p is delayed\n", neigh);
> > +		if (check_timer)
> > +			neigh_del_timer(neigh);
> >  		neigh->nud_state =3D NUD_DELAY;
> >  		neigh->updated =3D jiffies;
> >  		neigh_add_timer(neigh, jiffies +
>=20

--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXSuKvwAKCRA6cBh0uS2t
rDoeAP9Jq7VchZ5vzo/yJMaTnxtdhnq0Z9aeL2cs2HK/rguibgEAzrsHTvEe3k3Z
tVb06T1/yH+WtAXMvoF/Girf7sr2XAk=
=jOm/
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--

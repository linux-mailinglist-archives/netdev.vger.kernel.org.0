Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11A6236B018
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 10:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232377AbhDZI75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 04:59:57 -0400
Received: from mail.katalix.com ([3.9.82.81]:43726 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232068AbhDZI74 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Apr 2021 04:59:56 -0400
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 6A4087D442;
        Mon, 26 Apr 2021 09:59:14 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1619427554; bh=blQ2Yy8nnd5V1EGST4em1kvBGmK2/b1iXrd6f6HBp5c=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Mon,=2026=20Apr=202021=2009:59:14=20+0100|From:=20Tom=20P
         arkin=20<tparkin@katalix.com>|To:=20Cong=20Wang=20<xiyou.wangcong@
         gmail.com>|Cc:=20Sishuai=20Gong=20<sishuai@purdue.edu>,=20David=20
         Miller=20<davem@davemloft.net>,=0D=0A=09Jakub=20Kicinski=20<kuba@k
         ernel.org>,=0D=0A=09Matthias=20Schiffer=20<mschiffer@universe-fact
         ory.net>,=0D=0A=09Linux=20Kernel=20Network=20Developers=20<netdev@
         vger.kernel.org>|Subject:=20Re:=20[PATCH=20v3]=20net:=20fix=20a=20
         concurrency=20bug=20in=20l2tp_tunnel_register()|Message-ID:=20<202
         10426085913.GA4750@katalix.com>|References:=20<20210421192430.3036
         -1-sishuai@purdue.edu>=0D=0A=20<CAM_iQpUV-rmGdn1g7jn=3D=3D53wLQ0Mv
         M_bx4cJBo4AEDVZXPehRQ@mail.gmail.com>|MIME-Version:=201.0|Content-
         Disposition:=20inline|In-Reply-To:=20<CAM_iQpUV-rmGdn1g7jn=3D=3D53
         wLQ0MvM_bx4cJBo4AEDVZXPehRQ@mail.gmail.com>;
        b=yZ5IiJRiLZ56PGy71RYnsiKD7QQqpZjaXdQQTVFZZnG1SaHYEDFj4WCUFFLhT5Nx0
         GaP+E9zHmVoORD4lzD4psXTZDTepVU+EhtFESKFmUogRHWUeQNtoeeqDojrJmrR3JI
         ZXSVA3ydpjN0r7CwMnDIGFimB8641V+/lbpntniWHJOgAn3M2SityUuqhOhL05e0ZC
         OXGFlhzmVbW6usoSFqkQ63AX3ZXbT6JstYt3uiQzDaJgfev8mvP+xRphVW2ux3j/2O
         2Q+2JrSOkdv3Zy5PTF1SgtATdxU66N1ttkC0KaOU7xVa/ZpAVn2et2Jloqn4DCVS/x
         g8Kv3ExSJXSAg==
Date:   Mon, 26 Apr 2021 09:59:14 +0100
From:   Tom Parkin <tparkin@katalix.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Sishuai Gong <sishuai@purdue.edu>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Schiffer <mschiffer@universe-factory.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [PATCH v3] net: fix a concurrency bug in l2tp_tunnel_register()
Message-ID: <20210426085913.GA4750@katalix.com>
References: <20210421192430.3036-1-sishuai@purdue.edu>
 <CAM_iQpUV-rmGdn1g7jn==53wLQ0MvM_bx4cJBo4AEDVZXPehRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="rwEMma7ioTxnRzrJ"
Content-Disposition: inline
In-Reply-To: <CAM_iQpUV-rmGdn1g7jn==53wLQ0MvM_bx4cJBo4AEDVZXPehRQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Fri, Apr 23, 2021 at 10:38:45 -0700, Cong Wang wrote:
> On Wed, Apr 21, 2021 at 12:25 PM Sishuai Gong <sishuai@purdue.edu> wrote:
> >
> > l2tp_tunnel_register() registers a tunnel without fully
> > initializing its attribute. This can allow another kernel thread
> > running l2tp_xmit_core() to access the uninitialized data and
> > then cause a kernel NULL pointer dereference error, as shown below.
> >
> > Thread 1    Thread 2
> > //l2tp_tunnel_register()
> > list_add_rcu(&tunnel->list, &pn->l2tp_tunnel_list);
> >             //pppol2tp_connect()
> >             tunnel =3D l2tp_tunnel_get(sock_net(sk), info.tunnel_id);
> >             // Fetch the new tunnel
> >             ...
> >             //l2tp_xmit_core()
> >             struct sock *sk =3D tunnel->sock;
> >             ...
> >             bh_lock_sock(sk);
> >             //Null pointer error happens
> > tunnel->sock =3D sk;
> >
> > Fix this bug by initializing tunnel->sock before adding the
> > tunnel into l2tp_tunnel_list.
> >
> > Signed-off-by: Sishuai Gong <sishuai@purdue.edu>
> > Reported-by: Sishuai Gong <sishuai@purdue.edu>
>=20
> Reviewed-by: Cong Wang <cong.wang@bytedance.com>
>=20
> Thanks.

For some reason I've not been seeing these patches, just the replies.
I can't see it on lore.kernel.org either, unless I'm missing something
obvious.

Have the original mails cc'd netdev?

--rwEMma7ioTxnRzrJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAmCGgNwACgkQlIwGZQq6
i9Dn/gf/cSPj5xcOJOX087JFWfyCgAb47h0s7o+H94NpnwPeGAnjZXWz946EGuNv
zUCpz2WzTrxQ0vK6PWvF64tZvQJIgC6+/pSmWll18H1x1WH5d0ZSw2y8nAoJxLKw
lrvkN2OBA9Y5UXRZVNHlDS9MZOJKi4yza+xzwpslV/DCq9URZ6e9NqkI+z54eVt9
K8/kSHzK1pQQTYQMAzNOBCJPJSJGEPSEuXyhqmNN7mNNsOIEs6OMCStcLCT1fuXO
vMWmZEqTvT7TXbqizHle15+sW8uEDoxbd8T3kiYxWIZeBpk1gIlOqR0HBcL2YyGY
aFHfrobKUft+J1LdSNUmBRSOieGIYw==
=Zb/6
-----END PGP SIGNATURE-----

--rwEMma7ioTxnRzrJ--

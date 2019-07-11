Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 321E764FFC
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 03:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbfGKBvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 21:51:00 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:38453 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727188AbfGKBvA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 21:51:00 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45kfCg1qglz9sN6;
        Thu, 11 Jul 2019 11:50:55 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1562809857;
        bh=mugHbuqWraD1+aK2zG0Zb/wLM2BX5/bKzJm2crG3zls=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OpS1mLndMfZxHZ6BnBNmRFK8Acsn9ngjt5Zgpx2SGh+4lia0OsrmjWS9t3hDqg586
         4JzgjcjXtQry+vFxjV/35Krv3NCV5VGRAElmpqy2HcRZfCptltq03S/OL0C4dT9tBm
         ZrbnTJFS61/MvlkDlfIYuhPfyKi+0bw7ryqJzcG/KnxLQc2MM9JIZ85J7dgakIqQhH
         NexkYLxsuWN7H6lqKXEQkNA2qjLjNqtdAZkHf9zBCmuI1rBGsKuFiCbZWuBy5Sd+Gu
         uVWNkx7m8mSjY0s9KiYQXCpUzXbZXr8UYFYGoDsnvpAntVvE4wxLa/PJkDbjDU2XGu
         7RRO3LvcPjuxQ==
Date:   Thu, 11 Jul 2019 11:50:54 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Doug Ledford <dledford@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20190711115054.7d7f468c@canb.auug.org.au>
In-Reply-To: <20190710175212.GM2887@mellanox.com>
References: <20190709135636.4d36e19f@canb.auug.org.au>
        <20190709064346.GF7034@mtr-leonro.mtl.com>
        <20190710175212.GM2887@mellanox.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/zWqer.ymUPl5GdFzgX0ANsT"; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/zWqer.ymUPl5GdFzgX0ANsT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 10 Jul 2019 17:52:17 +0000 Jason Gunthorpe <jgg@mellanox.com> wrote:
>
> On Tue, Jul 09, 2019 at 09:43:46AM +0300, Leon Romanovsky wrote:
> > On Tue, Jul 09, 2019 at 01:56:36PM +1000, Stephen Rothwell wrote: =20
> > > Hi all,
> > >
> > > After merging the net-next tree, today's linux-next build (x86_64
> > > allmodconfig) failed like this:
> > >
> > > drivers/infiniband/sw/siw/siw_cm.c: In function 'siw_create_listen':
> > > drivers/infiniband/sw/siw/siw_cm.c:1978:3: error: implicit declaratio=
n of function 'for_ifa'; did you mean 'fork_idle'? [-Werror=3Dimplicit-func=
tion-declaration]
> > >    for_ifa(in_dev)
> > >    ^~~~~~~
> > >    fork_idle
> > > drivers/infiniband/sw/siw/siw_cm.c:1978:18: error: expected ';' befor=
e '{' token
> > >    for_ifa(in_dev)
> > >                   ^
> > >                   ;
> > >    {
> > >    ~
> > >
> > > Caused by commit
> > >
> > >   6c52fdc244b5 ("rdma/siw: connection management")
> > >
> > > from the rdma tree.  I don't know why this didn't fail after I mereged
> > > that tree. =20
> >=20
> > I had the same question, because I have this fix for a couple of days a=
lready.
> >=20
> > From 56c9e15ec670af580daa8c3ffde9503af3042d67 Mon Sep 17 00:00:00 2001
> > From: Leon Romanovsky <leonro@mellanox.com>
> > Date: Sun, 7 Jul 2019 10:43:42 +0300
> > Subject: [PATCH] Fixup to build SIW issue
> >=20
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> >  drivers/infiniband/sw/siw/siw_cm.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw=
/siw/siw_cm.c
> > index 8e618cb7261f..c883bf514341 100644
> > +++ b/drivers/infiniband/sw/siw/siw_cm.c
> > @@ -1954,6 +1954,7 @@ static void siw_drop_listeners(struct iw_cm_id *i=
d)
> >  int siw_create_listen(struct iw_cm_id *id, int backlog)
> >  {
> >  	struct net_device *dev =3D to_siw_dev(id->device)->netdev;
> > +	const struct in_ifaddr *ifa;
> >  	int rv =3D 0, listeners =3D 0;
> >=20
> >  	siw_dbg(id->device, "id 0x%p: backlog %d\n", id, backlog);
> > @@ -1975,8 +1976,7 @@ int siw_create_listen(struct iw_cm_id *id, int ba=
cklog)
> >  			id, &s_laddr.sin_addr, ntohs(s_laddr.sin_port),
> >  			&s_raddr->sin_addr, ntohs(s_raddr->sin_port));
> >=20
> > -		for_ifa(in_dev)
> > -		{
> > +		in_dev_for_each_ifa_rcu(ifa, in_dev) {
> >  			if (ipv4_is_zeronet(s_laddr.sin_addr.s_addr) || =20
>=20
> Hum. There is no rcu lock held here and we can't use RCU anyhow as
> siw_listen_address will sleep.
>=20
> I think this needs to use rtnl, as below. Bernard, please urgently
> confirm. Thanks
>=20
> diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/s=
iw/siw_cm.c
> index 8e618cb7261f62..ee98e96a5bfaba 100644
> --- a/drivers/infiniband/sw/siw/siw_cm.c
> +++ b/drivers/infiniband/sw/siw/siw_cm.c
> @@ -1965,6 +1965,7 @@ int siw_create_listen(struct iw_cm_id *id, int back=
log)
>  	 */
>  	if (id->local_addr.ss_family =3D=3D AF_INET) {
>  		struct in_device *in_dev =3D in_dev_get(dev);
> +		const struct in_ifaddr *ifa;
>  		struct sockaddr_in s_laddr, *s_raddr;
> =20
>  		memcpy(&s_laddr, &id->local_addr, sizeof(s_laddr));
> @@ -1975,8 +1976,8 @@ int siw_create_listen(struct iw_cm_id *id, int back=
log)
>  			id, &s_laddr.sin_addr, ntohs(s_laddr.sin_port),
>  			&s_raddr->sin_addr, ntohs(s_raddr->sin_port));
> =20
> -		for_ifa(in_dev)
> -		{
> +		rtnl_lock();
> +		in_dev_for_each_ifa_rtnl(ifa, in_dev) {
>  			if (ipv4_is_zeronet(s_laddr.sin_addr.s_addr) ||
>  			    s_laddr.sin_addr.s_addr =3D=3D ifa->ifa_address) {
>  				s_laddr.sin_addr.s_addr =3D ifa->ifa_address;
> @@ -1988,7 +1989,7 @@ int siw_create_listen(struct iw_cm_id *id, int back=
log)
>  					listeners++;
>  			}
>  		}
> -		endfor_ifa(in_dev);
> +		rtnl_unlock();
>  		in_dev_put(in_dev);
>  	} else if (id->local_addr.ss_family =3D=3D AF_INET6) {
>  		struct inet6_dev *in6_dev =3D in6_dev_get(dev);

So today this failed to build after I merged the rdma tree (previously
it didn;t until after the net-next tree was merged (I assume a
dependency changed).  It failed because in_dev_for_each_ifa_rcu (and
in_dev_for_each_ifa_rtnl) is only defined in a commit in the net-next
tree :-(

I have disabled the driver again.

--=20
Cheers,
Stephen Rothwell

--Sig_/zWqer.ymUPl5GdFzgX0ANsT
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0mlf4ACgkQAVBC80lX
0Gx1rggAlkl1kFtVwHZG0bs5T+kS+PRHZBvdYHXo44GXD23vLrwu0N9hVZEeHSIu
+g+SiptCEgtRPjFDrHydUZV5LnoHRCfu/SszQZ92RtaWm9fMDB9h8xCK4NQ+JwU4
nCI1f+tZQ6rsDB8eeFhWNxUrHI8CZVf1oE2Gv2zQ/+USnU0skE7RbOZPN8DAKSDG
vx1ugSopBzIch80xAHOKniPrAhUVq68jRieaENO0Q6ohbT+t9phkJlQ+a4P6PPH7
U3UZ6cS9SpdGDpe+DMD4U/7gnwj6FuZ0iRmUz9fb3fSsIK+JfyriXcdKYi189NnJ
MzGCVqKam30DsIBg15r5moLqrqUAXg==
=N2Fj
-----END PGP SIGNATURE-----

--Sig_/zWqer.ymUPl5GdFzgX0ANsT--

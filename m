Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34CE136C9C3
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 18:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237946AbhD0QvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 12:51:22 -0400
Received: from mail.katalix.com ([3.9.82.81]:59526 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237893AbhD0QvV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 12:51:21 -0400
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 4DF0A7D0C0;
        Tue, 27 Apr 2021 17:50:35 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1619542235; bh=HYfu9PE75oO3JoeHyZjTnIbKRqlA5rBZpXtISsaDGQA=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Tue,=2027=20Apr=202021=2017:50:35=20+0100|From:=20Tom=20P
         arkin=20<tparkin@katalix.com>|To:=20"Gong,=20Sishuai"=20<sishuai@p
         urdue.edu>|Cc:=20David=20Miller=20<davem@davemloft.net>,=20Jakub=2
         0Kicinski=20<kuba@kernel.org>,=0D=0A=09Matthias=20Schiffer=20<msch
         iffer@universe-factory.net>,=0D=0A=09Cong=20Wang=20<xiyou.wangcong
         @gmail.com>,=0D=0A=09Linux=20Kernel=20Network=20Developers=20<netd
         ev@vger.kernel.org>|Subject:=20Re:=20[PATCH]=20net:=20fix=20a=20co
         ncurrency=20bug=20in=20l2tp_tunnel_register()|Message-ID:=20<20210
         427165035.GB4585@katalix.com>|References:=20<1F82E994-8F0B-499F-BA
         1A-8F1B2EEF1BF2@purdue.edu>|MIME-Version:=201.0|Content-Dispositio
         n:=20inline|In-Reply-To:=20<1F82E994-8F0B-499F-BA1A-8F1B2EEF1BF2@p
         urdue.edu>;
        b=YjTTBLC/1Ut5DC/dATyXhge+VvphcwAUd7VvVeBDnwY9J5OGPQnEkHm0eMKJGiIZG
         u0tzv5Y33REBUO/JAyAr7F4Sc/xRsfl/A9W1N68XCMgQ76sJx1RxfRyLEEEZJ7tvkG
         X8KWwSaOy4DTFJ9OgSQckzpDXY/xKbjHKwbL+Rsd1WBSSr1IR8F4aogttd0j+vcxn6
         IKTyUApKjL2LxzyAA2eWYZag837Wz6lwSYwU7Y991AJ0DCnXKcAkL2GOtPaZew96br
         O+/wTBmOInL+sQBgYeY0eBtxY+O74h08dv/uh9D7388LyjEEL0xUEBU+/kq31N/qMj
         E6T2XyAgCGLlw==
Date:   Tue, 27 Apr 2021 17:50:35 +0100
From:   Tom Parkin <tparkin@katalix.com>
To:     "Gong, Sishuai" <sishuai@purdue.edu>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Schiffer <mschiffer@universe-factory.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: fix a concurrency bug in l2tp_tunnel_register()
Message-ID: <20210427165035.GB4585@katalix.com>
References: <1F82E994-8F0B-499F-BA1A-8F1B2EEF1BF2@purdue.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="neYutvxvOLaeuPCA"
Content-Disposition: inline
In-Reply-To: <1F82E994-8F0B-499F-BA1A-8F1B2EEF1BF2@purdue.edu>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--neYutvxvOLaeuPCA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Tue, Apr 27, 2021 at 15:04:24 +0000, Gong, Sishuai wrote:
> l2tp_tunnel_register() registers a tunnel without fully
> initializing its attribute. This can allow another kernel thread
> running l2tp_xmit_core() to access the uninitialized data and
> then cause a kernel NULL pointer dereference error, as shown below.
>=20
> Thread 1    Thread 2
> //l2tp_tunnel_register()
> list_add_rcu(&tunnel->list, &pn->l2tp_tunnel_list);
>            //pppol2tp_connect()
>            tunnel =3D l2tp_tunnel_get(sock_net(sk), info.tunnel_id);
>            // Fetch the new tunnel
>            ...
>            //l2tp_xmit_core()
>            struct sock *sk =3D tunnel->sock;
>            ...
>            bh_lock_sock(sk);
>            //Null pointer error happens
> tunnel->sock =3D sk;
>=20
> Fix this bug by initializing tunnel->sock before adding the
> tunnel into l2tp_tunnel_list.
>=20
> Reviewed-by: Cong Wang <cong.wang@bytedance.com>
> Signed-off-by: Sishuai Gong <sishuai@purdue.edu>
> Reported-by: Sishuai Gong <sishuai@purdue.edu>
> ---

It came through this time.  Mysterious.

Anyway, thank you for reposting.  This looks good to me :-)

--=20
Tom Parkin
Katalix Systems Ltd
https://katalix.com
Catalysts for your Embedded Linux software development

--neYutvxvOLaeuPCA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAmCIQNcACgkQlIwGZQq6
i9A3ZQf/S8K87jVYmkTJ4gUz1VfNZ21wRmyzqfQYgbuOwMc6ckivZPF8We9jjYBZ
0Y1Dqu3701DTMC1WJTg2YDmS550dj8/V8KsEuoh5gcjEdi9FH5uHFuoE1XUJD0p9
/O6Ki+tb9xIMhCcJLdX4iX9jahahrsGVrhHJfelVcoD/CcOryAu30Vv5iDTnXKLY
PDla6LYEPvU6Hmc6uClBwcGLTp/OHRY8VdeXQcMRjeNBOudsniNrLJvslHP4jez5
V9uJEueVki0kYc2RQET1snMRJmS11PI7izm3lc07VCNLF+G6znMvGCJj9SkfUrnw
iIVZQg5Eu5D6D6W05LD+YhkiMGXlyQ==
=T2Ue
-----END PGP SIGNATURE-----

--neYutvxvOLaeuPCA--

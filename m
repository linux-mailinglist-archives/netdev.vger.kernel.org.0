Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D335135FBB9
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 21:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349093AbhDNTiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 15:38:16 -0400
Received: from mail.katalix.com ([3.9.82.81]:58498 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237401AbhDNTiO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 15:38:14 -0400
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 98160841B2;
        Wed, 14 Apr 2021 20:37:49 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1618429069; bh=VFyNHjUya1Dr58SueDr5MKs8r4bqjdSVnC4CG1o5DSA=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Disposition:In-Reply-To:From;
        z=Date:=20Wed,=2014=20Apr=202021=2020:37:49=20+0100|From:=20Tom=20P
         arkin=20<tparkin@katalix.com>|To:=20"Gong,=20Sishuai"=20<sishuai@p
         urdue.edu>|Cc:=20"jchapman@katalix.com"=20<jchapman@katalix.com>,=
         0D=0A=09"netdev@vger.kernel.org"=20<netdev@vger.kernel.org>|Subjec
         t:=20Re:=20A=20concurrency=20bug=20between=20l2tp_tunnel_register(
         )=20and=0D=0A=20l2tp_xmit_core()|Message-ID:=20<20210414193749.GA4
         707@katalix.com>|References:=20<400E2FE1-A1E7-43EE-9ABA-41C65601C6
         EB@purdue.edu>|MIME-Version:=201.0|Content-Disposition:=20inline|I
         n-Reply-To:=20<400E2FE1-A1E7-43EE-9ABA-41C65601C6EB@purdue.edu>;
        b=Bs+UOulVfrUfAHKLNmunz8rBRE8ZdBSeuRUmp4HRSuOoVuqgPXK5IuK/0Z9YqsUk/
         XCy41YRZCF+nhKqcEAwrsXHWWUpF1gzQElkxB+oMUElb4VlZCWSBLaxMMhRn0aviou
         FmrLUxov4HZXF/JzmfG8f+NJkoVf6tdLsg1m8MZGPew47H17uFUL0GTc0V+rB32rKm
         BRw4Rquo4KwLXojq7730gufo4UKaI219uJ3ap7z2aO3PPjqDTzESBOPstfv/y7o0Lu
         HaxHCE6tWTh/dOjfDZyzKXo9HpfxKI+B6ZPtV866KvRbfzYr9lbhOhjGmlACvQ3O03
         Ef/Y1xWc23KKA==
Date:   Wed, 14 Apr 2021 20:37:49 +0100
From:   Tom Parkin <tparkin@katalix.com>
To:     "Gong, Sishuai" <sishuai@purdue.edu>
Cc:     "jchapman@katalix.com" <jchapman@katalix.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: A concurrency bug between l2tp_tunnel_register() and
 l2tp_xmit_core()
Message-ID: <20210414193749.GA4707@katalix.com>
References: <400E2FE1-A1E7-43EE-9ABA-41C65601C6EB@purdue.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
In-Reply-To: <400E2FE1-A1E7-43EE-9ABA-41C65601C6EB@purdue.edu>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On  Tue, Apr 13, 2021 at 17:30:17 +0000, Gong, Sishuai wrote:
> Hi,
>=20
> We found a concurrency bug in linux 5.12-rc3 and we are able to reproduce=
 it under x86. This bug happens when two l2tp functions l2tp_tunnel_registe=
r() and l2tp_xmit_core() are running in parallel. In general, l2tp_tunnel_r=
egister() registered a tunnel that hasn=E2=80=99t been fully initialized an=
d then l2tp_xmit_core() tries to access an uninitialized attribute. The int=
erleaving is shown below..
>=20
> ------------------------------------------
> Execution interleaving
>=20
> Thread 1												Thread 2
>=20
> l2tp_tunnel_register()
> 	spin_lock_bh(&pn->l2tp_tunnel_list_lock);
> 		=E2=80=A6
> 		list_add_rcu(&tunnel->list, &pn->l2tp_tunnel_list);
> 		// tunnel becomes visible
> 	spin_unlock_bh(&pn->l2tp_tunnel_list_lock);
> 													pppol2tp_connect()
> 														=E2=80=A6
> 														tunnel =3D l2tp_tunnel_get(sock_net(sk), info.tunnel_id);
> 														// Successfully get the new tunnel  			=09
> 													=E2=80=A6
> 													l2tp_xmit_core()
> 														struct sock *sk =3D tunnel->sock;
> 														// uninitialized, sk=3D0 =20
> 														=E2=80=A6
> 														bh_lock_sock(sk);
> 														// Null-pointer exception happens
> 	=E2=80=A6
> 	tunnel->sock =3D sk;
>=20
> ------------------------------------------
> Impact & fix
>=20
> This bug causes a kernel NULL pointer deference error, as attached below.=
 Currently, we think a potential fix is to initialize tunnel->sock before a=
dding the tunnel into l2tp_tunnel_list.
>=20
> ------------------------------------------
> Console output
>=20
> [  806.566775][T10805] BUG: kernel NULL pointer dereference, address: 000=
00070
> [  807.097222][T10805] #PF: supervisor read access in kernel mode
> [  807.647927][T10805] #PF: error_code(0x0000) - not-present page
> [  808.255377][T10805] *pde =3D 00000000
> [  808.757649][T10805] Oops: 0000 [#1] PREEMPT SMP
> [  809.367746][T10805] CPU: 1 PID: 10805 Comm: executor Not tainted 5.12.=
0-rc3 #3
> [  810.590670][T10805] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> [  811.126044][T10805] EIP: _raw_spin_lock+0x16/0x50
> [  811.671747][T10805] Code: 00 00 00 00 55 89 d0 89 e5 e8 26 8c 20 fe 5d=
 c3 8d 74 26 00 55 89 c1 89 e5 53 64 ff 05 0c 97 fb c3 31 d2 bb 01 00 00 00=
 89 d0 <f0> 0f b1 19 75 0c 8b 5d fc c9 c3 8d b4 26
> 00 00 00 00 8b 15 e8 7c
> [  813.375919][T10805] EAX: 00000000 EBX: 00000001 ECX: 00000070 EDX: 000=
00000
> [  813.989487][T10805] ESI: cbb59300 EDI: cbac8c00 EBP: cf54fd68 ESP: cf5=
4fd64
> [  814.629205][T10805] DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068 EFLAG=
S: 00000246
> [  815.811079][T10805] CR0: 80050033 CR2: 00000070 CR3: 0efd3000 CR4: 000=
00690
> [  816.526951][T10805] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 000=
00000
> [  817.158214][T10805] DR6: 00000000 DR7: 00000000
> [  817.762257][T10805] Call Trace:
> [  818.322192][T10805]  l2tp_xmit_skb+0x11a/0x530
> [  818.876097][T10805]  pppol2tp_sendmsg+0x160/0x290
> [  819.438224][T10805]  sock_sendmsg+0x2d/0x40
> [  820.077999][T10805]  ____sys_sendmsg+0x1a2/0x1d0
> [  820.694928][T10805]  ? import_iovec+0x13/0x20
> [  821.220194][T10805]  ___sys_sendmsg+0x98/0xd0
> [  821.927886][T10805]  ? file_update_time+0x4b/0x130
> [  822.458245][T10805]  ? vfs_write+0x32c/0x3f0
> [  823.002593][T10805]  __sys_sendmsg+0x39/0x80
>=20
>=20
>=20
> Thanks,
> Sishuai
>=20

Hi Sishuai,

Thanks for the report!

Your analysis looks correct to me, and the suggested fix sounds
reasonable too.

Is this something you plan to submit a patch for?

Best regards,
Tom

--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEsUkgyDzMwrj81nq0lIwGZQq6i9AFAmB3RIkACgkQlIwGZQq6
i9Aw8gf9FQuvI0xzHA88DvDhsgvnSTA0SGe6Yc/5Nn/+w+1ZJ9BSrFsYXxYMtn+l
9sM8lTIADdjFkSVgZGCEzh8MsT7FMD7jzDXyGwFPltH4iHnN+85C3d6Jg0Uj294N
cYs9bPSAJcOlbdzOYfbkGVBKMU+6KvbLq07NNn+k/0/QmtKgJcPePzh9m86TPiRy
sz5LqFdBWwtWeIbsMY4zivwQTBAoIqm8wBZ+cMZ84fVugyXC2/q732kRoxv6h8jU
JouaaDSGzm1ByYxpybFxJh7IhxPquTX+0B0ahkppqkkGcPJgZORuwwjGsS1gXS/Y
lEbVIyTJIUXC4fMhJIEug9Dad753fw==
=gx/S
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--

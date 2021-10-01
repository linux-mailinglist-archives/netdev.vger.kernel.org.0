Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDDD41E76F
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 08:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352109AbhJAGUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 02:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbhJAGUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 02:20:39 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F22C5C06176A;
        Thu, 30 Sep 2021 23:18:54 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HLKgc3M82z4xbQ;
        Fri,  1 Oct 2021 16:18:51 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1633069132;
        bh=FtDEQ6sQa+w0QICsIw2I0WfJjMFi2rKpIwYM1kIV+tc=;
        h=Date:From:To:Cc:Subject:From;
        b=lu1TqovdXmI40DJ1rcszuHV6A4xC363T/u3mY0cq1cF9oMz16yXfwHXrzc3nVM6fK
         dJhw0WSnhGc88Tcatl7//OV4y4eKB6TexvG4tU+lde3QN5RJRCx7zfFeSh0r5ljTaG
         9Bt5FAGShyu7fKs+ket8ruk9UpaslMZs6c3IbfNQzMn4TLoPUpzq+F/uuDczdL4RMH
         S++y4wXfBrcHLqxADyGMGblh5y2iNM4E5qt01eX6y7NRQofp2/fPYoslWYuyLjSaGN
         eLcslxRKfoXBuWa0XB+XheL4QDogw+LvjszeJRdtHqLeSn5MUNkTd1DS3q9ykJkvL6
         Y8NCY4sBBf5xQ==
Date:   Fri, 1 Oct 2021 16:18:49 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, Wei Wang <weiwan@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20211001161849.51b6deca@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/juQm59FPtUBQKGnQG5fzsSB";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/juQm59FPtUBQKGnQG5fzsSB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (sparc64
defconfig) failed like this:

net/core/sock.c: In function 'sock_setsockopt':
net/core/sock.c:1417:7: error: 'SO_RESERVE_MEM' undeclared (first use in th=
is function); did you mean 'IORESOURCE_MEM'?
  case SO_RESERVE_MEM:
       ^~~~~~~~~~~~~~
       IORESOURCE_MEM
net/core/sock.c:1417:7: note: each undeclared identifier is reported only o=
nce for each function it appears in
net/core/sock.c: In function 'sock_getsockopt':
net/core/sock.c:1817:7: error: 'SO_RESERVE_MEM' undeclared (first use in th=
is function); did you mean 'IORESOURCE_MEM'?
  case SO_RESERVE_MEM:
       ^~~~~~~~~~~~~~
       IORESOURCE_MEM

Caused by commit

  2bb2f5fb21b0 ("net: add new socket option SO_RESERVE_MEM")

arch/sparc/include/uapi/socket.h does not include uapi/asm/socket.h and
some other architectures do not as well.

I have added the following patch for today (I searched for SO_BUF_LOCK
and, of these architectures, I have only compile tested sparc64 and
sparc):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 1 Oct 2021 15:51:50 +1000
Subject: [PATCH] fix up for "net: add new socket option SO_RESERVE_MEM"

Some architectures do not include uapi/asm/socket.h

Fixes: 2bb2f5fb21b0 ("net: add new socket option SO_RESERVE_MEM")
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/alpha/include/uapi/asm/socket.h  | 2 ++
 arch/mips/include/uapi/asm/socket.h   | 2 ++
 arch/parisc/include/uapi/asm/socket.h | 2 ++
 arch/sparc/include/uapi/asm/socket.h  | 2 ++
 4 files changed, 8 insertions(+)

diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/include/uapi=
/asm/socket.h
index 1dd9baf4a6c2..284d28755b8d 100644
--- a/arch/alpha/include/uapi/asm/socket.h
+++ b/arch/alpha/include/uapi/asm/socket.h
@@ -131,6 +131,8 @@
=20
 #define SO_BUF_LOCK		72
=20
+#define SO_RESERVE_MEM		73
+
 #if !defined(__KERNEL__)
=20
 #if __BITS_PER_LONG =3D=3D 64
diff --git a/arch/mips/include/uapi/asm/socket.h b/arch/mips/include/uapi/a=
sm/socket.h
index 1eaf6a1ca561..24e0efb360f6 100644
--- a/arch/mips/include/uapi/asm/socket.h
+++ b/arch/mips/include/uapi/asm/socket.h
@@ -142,6 +142,8 @@
=20
 #define SO_BUF_LOCK		72
=20
+#define SO_RESERVE_MEM		73
+
 #if !defined(__KERNEL__)
=20
 #if __BITS_PER_LONG =3D=3D 64
diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/include/ua=
pi/asm/socket.h
index 8baaad52d799..845ddc63c882 100644
--- a/arch/parisc/include/uapi/asm/socket.h
+++ b/arch/parisc/include/uapi/asm/socket.h
@@ -123,6 +123,8 @@
=20
 #define SO_BUF_LOCK		0x4046
=20
+#define SO_RESERVE_MEM		0x4047
+
 #if !defined(__KERNEL__)
=20
 #if __BITS_PER_LONG =3D=3D 64
diff --git a/arch/sparc/include/uapi/asm/socket.h b/arch/sparc/include/uapi=
/asm/socket.h
index e80ee8641ac3..9e9ceee6358f 100644
--- a/arch/sparc/include/uapi/asm/socket.h
+++ b/arch/sparc/include/uapi/asm/socket.h
@@ -124,6 +124,8 @@
=20
 #define SO_BUF_LOCK              0x0051
=20
+#define SO_RESERVE_MEM           0x0052
+
 #if !defined(__KERNEL__)
=20
=20
--=20
2.33.0

--=20
Cheers,
Stephen Rothwell

--Sig_/juQm59FPtUBQKGnQG5fzsSB
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmFWqEkACgkQAVBC80lX
0GzURQf/Qb2+M65Vu7CVhw7LM8TnQWDV54GslYN4/danqEwXCP0w1siZZ8biRuZr
BlCxM/7L+9d5bg+vkHUiLgqLUVCAP8t1kIPs+Oa1hnZpxM4JW7Ui8xuF3nHL3apR
dnwDfWsK2C+wCpQz3XGwxRba5mMs2rh7bQG66VvRHqS3RiFVXJOq1xJgyOlqPdoK
sxdq0HGVKljoM4CC9oeakhMv797yaduPvwE7ub4VjATRi/BdxfZecGqRE2pe1rdy
SFmQHq52W9NMO0x4OTOkvbNunkpd0dQGdSNmeg/rmnKK4m9Eod3Arod79RkTaA4u
IOL2RLYK8CIq1Hl2ME3CnBCTomxvHw==
=c79C
-----END PGP SIGNATURE-----

--Sig_/juQm59FPtUBQKGnQG5fzsSB--

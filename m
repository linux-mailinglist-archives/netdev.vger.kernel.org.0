Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3405522E481
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 05:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbgG0Doi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 23:44:38 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:35563 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726666AbgG0Doh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jul 2020 23:44:37 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BFQfV5d2cz9sRR;
        Mon, 27 Jul 2020 13:44:34 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1595821476;
        bh=tSzjNT8u43gZrwdrTJb/CVyGDvl8I6ezLnCXyQXH9DU=;
        h=Date:From:To:Cc:Subject:From;
        b=JnAOtWJ2EmAulpLGuhw5AunWdiOMLN2qoPrSpZ5g/7Mwrh4OS/C4nJwYL2Jb97DUQ
         VKcwEGAhtiqZLw4qZZXRUUOVhgQhVyqfNCvxrINUYcHKpQUHr2oOjIgjTCpHeXsWvQ
         Ukpc2uLkEXlcVH/zyPOuDwExwdRg1XLq9ZVh7oDWvn3wXTPRJnYCycKAe3QaDxUBYh
         NDUOGK3kmXLXrlWuaeVYkFgQs2YTR4hjIHKN1W9FN3gbvQUcGdurK00LuO5XV7yGYC
         /FSwuNq9hjj7JXd2T/xQy18w9hCA+aJu60JIM7+Dy7lYpQckUungMP0A6n5Q69JW5G
         ogEpQemIWWHFg==
Date:   Mon, 27 Jul 2020 13:44:33 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alain Michaud <alainm@chromium.org>,
        Christoph Hellwig <hch@lst.de>
Subject: linux-next: build failure after merge of the bluetooth tree
Message-ID: <20200727134433.1c4ea34e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/i4OPhDal54JmQi0C2gX3Cv0";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/i4OPhDal54JmQi0C2gX3Cv0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the bluetooth tree, today's linux-next build (arm
multi_v7_defconfig) failed like this:

net/bluetooth/sco.c: In function 'sco_sock_setsockopt':
net/bluetooth/sco.c:862:3: error: cannot convert to a pointer type
  862 |   if (get_user(opt, (u32 __user *)optval)) {
      |   ^~
net/bluetooth/sco.c:862:3: error: cannot convert to a pointer type
net/bluetooth/sco.c:862:3: error: cannot convert to a pointer type

Caused by commit

  00398e1d5183 ("Bluetooth: Add support for BT_PKT_STATUS CMSG data for SCO=
 connections")

interacting with commit

  a7b75c5a8c41 ("net: pass a sockptr_t into ->setsockopt")

from the net-next tree.

I have applied the following merge fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 27 Jul 2020 13:41:30 +1000
Subject: [PATCH] Bluetooth: fix for introduction of sockptr_t

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 net/bluetooth/sco.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 6e6b03844a2a..dcf7f96ff417 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -859,7 +859,7 @@ static int sco_sock_setsockopt(struct socket *sock, int=
 level, int optname,
 		break;
=20
 	case BT_PKT_STATUS:
-		if (get_user(opt, (u32 __user *)optval)) {
+		if (copy_from_sockptr(&opt, optval, sizeof(u32))) {
 			err =3D -EFAULT;
 			break;
 		}
--=20
2.27.0

--=20
Cheers,
Stephen Rothwell

--Sig_/i4OPhDal54JmQi0C2gX3Cv0
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8eTaEACgkQAVBC80lX
0GxveAf9E0YoKtcwDaOdLI7Klv7Asr/se/R9oTCS//szh1Vp2vzEbGnnP7z5KKAG
RY2D7lSSgrF/UTzBtRc3atsNajtmO1ObBOkF7JlmG8A2un02Q2rV0OeKV9Kg8vs2
PWRi0NTOAddtqAMn/sdzMuXswKR/E8Jr79XTd4o2OxWZHmRXTb8QDjf4Lq0FrYw7
Yy1LqJmoHVrb3WKsxQjywTk0GfkUXyoFsZ4GLm8Aa+VX80HOPDydrBlhvcPsSMrY
8Dmq1u5ieG2JFBI5b9APr9zOkT38NE8YryA6oSSJ/cMJlUtn/pPFfqRuWvrPVW2G
AjclIANAIA7iX7X/0Lys8uZJq3TlKQ==
=/9Zv
-----END PGP SIGNATURE-----

--Sig_/i4OPhDal54JmQi0C2gX3Cv0--

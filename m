Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C001A4286E0
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 08:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234175AbhJKGg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 02:36:29 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:56923 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231425AbhJKGg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 02:36:27 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HSTXy2nXYz4xbL;
        Mon, 11 Oct 2021 17:34:25 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1633934066;
        bh=6GOk3nyhP0azIbPuESw0RXCw6kG6vR7AfVI2n4LS2fs=;
        h=Date:From:To:Cc:Subject:From;
        b=aB6bQ7y5FNQfHdhK5MJuK17rY6/BvtM8aZzu7EoV6qjXuandJM4qMbvrNIiSm64CO
         cK4PcOElis9B2ekbagKOcRjYROEJTEnro80e1ARg7REwnY2wPqClCqXTKZcqod9T2S
         XKoXKPlKCra+h9clq1o7Uj40d78XSO9SxFR0hLRT/dWS3wVR3xm5nMweShMQmh2Fet
         sVCdC/6xBYbEyCFb4pOaREPw3JCVdrngQI22zopBI7en5xi2lcHAgFEAq/2OxrGtfZ
         vW0oF5rehZDbUpn8RJqXndttCYV7fLQQ4ha74JlK5uidzmwKmkBqIUYothDCif57xh
         rxokJ32y2cjsQ==
Date:   Mon, 11 Oct 2021 17:34:24 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20211011173424.7743035d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/6=hlm7uJknGQV.an36uVEl.";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/6=hlm7uJknGQV.an36uVEl.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (sparc64
defconfig) failed like this:

drivers/net/ethernet/sun/ldmvsw.c: In function 'vsw_alloc_netdev':
drivers/net/ethernet/sun/ldmvsw.c:243:2: error: expected ';' before 'sprint=
f'
  sprintf(dev->name, "vif%d.%d", (int)handle, (int)port_id);
  ^~~~~~~

Caused by commit

  a7639279c93c ("ethernet: sun: remove direct netdev->dev_addr writes")

I have applied the following fix patch for today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 11 Oct 2021 17:24:43 +1100
Subject: [PATCH] ethernet: sun: fix for "remove direct netdev->dev_addr wri=
tes"

Fix for this build problem:

drivers/net/ethernet/sun/ldmvsw.c: In function 'vsw_alloc_netdev':
drivers/net/ethernet/sun/ldmvsw.c:243:2: error: expected ';' before 'sprint=
f'
  sprintf(dev->name, "vif%d.%d", (int)handle, (int)port_id);
  ^~~~~~~

Fixes: a7639279c93c ("ethernet: sun: remove direct netdev->dev_addr writes")
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/ethernet/sun/ldmvsw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sun/ldmvsw.c b/drivers/net/ethernet/sun/l=
dmvsw.c
index 074c5407c86b..6b59b14e74b1 100644
--- a/drivers/net/ethernet/sun/ldmvsw.c
+++ b/drivers/net/ethernet/sun/ldmvsw.c
@@ -238,7 +238,7 @@ static struct net_device *vsw_alloc_netdev(u8 hwaddr[],
 	dev->needed_tailroom =3D 8;
=20
 	eth_hw_addr_set(dev, hwaddr);
-	ether_addr_copy(dev->perm_addr, dev->dev_addr)
+	ether_addr_copy(dev->perm_addr, dev->dev_addr);
=20
 	sprintf(dev->name, "vif%d.%d", (int)handle, (int)port_id);
=20
--=20
2.33.0

--=20
Cheers,
Stephen Rothwell

--Sig_/6=hlm7uJknGQV.an36uVEl.
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmFj2vAACgkQAVBC80lX
0GwnZgf/Xfn9J6jrJmHmTec9x6RHfasJQ+ihUFHqxdfv9H58lNKkqCcNdUwdv/Kg
GQeuNpY/MyKMsstHTTtw6R/FIeBn06iAkn/A0UrLipzeVc+wNG8o7e5NcdouyzGO
HlxYR/L/9FX1vUV4xmRi71MfgJ25kdXsXFxuES504UZFpzSr+csbL4kor5HKuv4i
PYGv0Ix7pLyewI4fDf6KvwTZCkNokCORWR21+bdEdVbjQ5sqx7UkRi18qpDwSLQu
9QJwIh9ROyCRsJbcE7QJhywKl8/pUgMHaYxAQqNJa2LIPQG5rQaV+s26I+nDB4PJ
w8DtFO6wqLSH8AZxxcgKpv1SF1ALLw==
=OeAq
-----END PGP SIGNATURE-----

--Sig_/6=hlm7uJknGQV.an36uVEl.--

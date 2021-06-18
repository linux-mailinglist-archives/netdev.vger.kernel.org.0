Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA2A03AC7B8
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 11:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232217AbhFRJhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 05:37:37 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:49286 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhFRJhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 05:37:36 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 7FB4C1C0B7C; Fri, 18 Jun 2021 11:35:26 +0200 (CEST)
Date:   Fri, 18 Jun 2021 11:35:26 +0200
From:   Pavel Machek <pavel@denx.de>
To:     davem@davemloft.net
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Pavel Andrianov <andrianov@ispras.ru>,
        Michael Walle <michael@walle.cc>, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: net: pxa168_eth: Fix a potential data race in pxa168_eth_remove
Message-ID: <20210618093526.GA20534@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Commit 0571a753cb07 cancelled delayed work too late, keeping small
race. Cancel work sooner to close it completely.
   =20
Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
Fixes: 0571a753cb07 ("net: pxa168_eth: Fix a potential data race in pxa168_=
eth_remove")
   =20
diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethern=
et/marvell/pxa168_eth.c
index e967867828d8..9b48ae4bac39 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -1528,6 +1528,7 @@ static int pxa168_eth_remove(struct platform_device *=
pdev)
 	struct net_device *dev =3D platform_get_drvdata(pdev);
 	struct pxa168_eth_private *pep =3D netdev_priv(dev);
=20
+	cancel_work_sync(&pep->tx_timeout_task);
 	if (pep->htpr) {
 		dma_free_coherent(pep->dev->dev.parent, HASH_ADDR_TABLE_SIZE,
 				  pep->htpr, pep->htpr_dma);
@@ -1539,7 +1540,6 @@ static int pxa168_eth_remove(struct platform_device *=
pdev)
 	clk_disable_unprepare(pep->clk);
 	mdiobus_unregister(pep->smi_bus);
 	mdiobus_free(pep->smi_bus);
-	cancel_work_sync(&pep->tx_timeout_task);
 	unregister_netdev(dev);
 	free_netdev(dev);
 	return 0;

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYMxo3gAKCRAw5/Bqldv6
8lFRAJ9kIaYVP4lXFKJimdy6CrKO9qlscgCeISjtxlipTbN2RsmXD997erOtByc=
=OjMd
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--

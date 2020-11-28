Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45A612C6E41
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 02:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731114AbgK1Bow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 20:44:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730194AbgK1BmS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 20:42:18 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E36C0613D3;
        Fri, 27 Nov 2020 17:28:27 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4CjYm52j5Hz9s1l;
        Sat, 28 Nov 2020 12:28:21 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1606526904;
        bh=pizqWbx6kpcLHzpqpXf5UA/FRNefEUnZ0fLu0XqqZds=;
        h=Date:From:To:Cc:Subject:From;
        b=rUZMICqIkh9bteswcTjhiv3kijzQks3QgHUeEEd4HGX0WQz0cxguPHfQPWwPGmRuf
         C6PdreWjq9uaLYKYrvkv1EAnBUHVobo0SO0EVtjnGReL7pdgv2Lk2e0/34wzhicHvB
         fjMfnyasaDArAXSRgzTm/uKoS1TUJJqU7k0/nRiKZXfjeAS4HJIX2tHhRUoTq2+RAU
         NdiUWZneTnEmbcjcV8+SowD+xi4/W9mM8GCe3x5jVeVwT+3sRT0ozQ1OnfudQ5dYs+
         cOE+SBu2Kdt0oBLbIuqF4YJeEJXeNIrIS3gnvBwGsystqYvHA04TPN0PvaKfQQShtV
         23YK7YKH4F/tA==
Date:   Sat, 28 Nov 2020 12:28:19 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     PowerPC <linuxppc-dev@lists.ozlabs.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Daniel Axtens <dja@axtens.net>, Joel Stanley <joel@jms.id.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <linux-renesas-soc@vger.kernel.org>, <linux-clk@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH] powerpc: fix the allyesconfig build
Message-ID: <20201128122819.32187696@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/KuY.fQqVIIg2ziwEsNY9G9S";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/KuY.fQqVIIg2ziwEsNY9G9S
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

There are 2 drivers that have arrays of packed structures that contain
pointers that end up at unaligned offsets.  These produce warnings in
the PowerPC allyesconfig build like this:

WARNING: 148 bad relocations
c00000000e56510b R_PPC64_UADDR64   .rodata+0x0000000001c72378
c00000000e565126 R_PPC64_UADDR64   .rodata+0x0000000001c723c0

They are not drivers that are used on PowerPC (I assume), so mark them
to not be built on PPC64 when CONFIG_RELOCATABLE is enabled.

Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Michael Turquette <mturquette@baylibre.com>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Yisen Zhuang <yisen.zhuang@huawei.com>
Cc: Salil Mehta <salil.mehta@huawei.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Nicholas Piggin  <npiggin@gmail.com>
Cc: Daniel Axtens <dja@axtens.net>
Cc: Joel Stanley <joel@jms.id.au>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/clk/renesas/Kconfig            | 4 ++++
 drivers/net/ethernet/hisilicon/Kconfig | 4 ++++
 2 files changed, 8 insertions(+)

It might be easiest to put this through the PowerPC (fixes?) tree, if
people woulf just sned ACKs, please?

diff --git a/drivers/clk/renesas/Kconfig b/drivers/clk/renesas/Kconfig
index 18915d668a30..53f24a0cad7a 100644
--- a/drivers/clk/renesas/Kconfig
+++ b/drivers/clk/renesas/Kconfig
@@ -151,6 +151,10 @@ config CLK_R8A779A0
 	select CLK_RENESAS_CPG_MSSR
=20
 config CLK_R9A06G032
+	# PPC64 RELOCATABLE kernels cannot handle relocations to
+	# unaligned locations that are produced by the array of
+	# packed structures in this driver.
+	depends on !(PPC64 && RELOCATABLE)
 	bool "Renesas R9A06G032 clock driver"
 	help
 	  This is a driver for R9A06G032 clocks
diff --git a/drivers/net/ethernet/hisilicon/Kconfig b/drivers/net/ethernet/=
hisilicon/Kconfig
index 44f9279cdde1..bf47e504b365 100644
--- a/drivers/net/ethernet/hisilicon/Kconfig
+++ b/drivers/net/ethernet/hisilicon/Kconfig
@@ -102,6 +102,10 @@ config HNS3_HCLGE
 	tristate "Hisilicon HNS3 HCLGE Acceleration Engine & Compatibility Layer =
Support"
 	default m
 	depends on PCI_MSI
+	# PPC64 RELOCATABLE kernels cannot handle relocations to
+	# unaligned locations that are produced by the array of
+	# packed structures in this driver.
+	depends on !(PPC64 && RELOCATABLE)
 	help
 	  This selects the HNS3_HCLGE network acceleration engine & its hardware
 	  compatibility layer. The engine would be used in Hisilicon hip08 family=
 of
--=20
2.29.2

--=20
Cheers,
Stephen Rothwell

--Sig_/KuY.fQqVIIg2ziwEsNY9G9S
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl/Bp7MACgkQAVBC80lX
0GyPBQgAkMvCmiFhqnL7o7DUVRLmNMqGGyl4yTMxo8SW8iDwovOI5Lpejsoif1Js
pKQZtjlq5ToIWffxcAEs0XFr8LhSkOQb5pIBRit3YG/GfVFJCduwbwSFm+HYjaeN
1PVg9Y1//xbcNPCgRi3T9cvk1RYIy2UCSnmHEdyLqaQcBXISg+NNxtEELdIY/Bv9
BQ/rZ/etXC55M+Sn9rxtpKSRXptkqjipJkvUnQOBEGErwVV8lqvJP3KGEipvIESC
jMjNYqyL5sm2I534Qj37zx66tLcy9ptWaM0KCHJ0xQVzGHP9dN1cduVbnGlMd3JJ
7S0Fqhozs6aKsd9v+8Of9/ArMx3kuA==
=DZFT
-----END PGP SIGNATURE-----

--Sig_/KuY.fQqVIIg2ziwEsNY9G9S--

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE68A1560
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 12:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbfH2KFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 06:05:52 -0400
Received: from ozlabs.org ([203.11.71.1]:35671 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726330AbfH2KFw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 06:05:52 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46Jyt45h40z9s4Y;
        Thu, 29 Aug 2019 20:05:48 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1567073149;
        bh=tf1ypQjpP9xJVJX8gDPglx7QvW/vyQ5w0EeNCZAjaZk=;
        h=Date:From:To:Cc:Subject:From;
        b=Rf+LakrMJi3Ly9wRsysR6j+BSTKi1WG9tqSgbDFJwkPgEDTu9PeFF7MnAI28J3/+b
         IlJIqH6rOgVuBiszuRDpOl8krgh37lYuMWz9gAQuTwSzbX2Xa2LlxU7Kq7thtMfORQ
         tL8riXi/0eROZAGqgLph6Sh3pPS6+bummMgjX6//9VekptBpC8u5uIAAKnSvNps77Y
         z7CvlUZp3Re/VczRR5wmBv1jFwsQ2wXbV3FdK3rGkV/QneJI4VqKAB1UZr0doXsF0w
         H2tsdQmLk4KACN+sdbFsEpqCvUQRJszdkUQb7QBrrNi0n3RLG8X9tF1wE1QpTgovUq
         vaA5snTCxahAQ==
Date:   Thu, 29 Aug 2019 20:05:46 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: linux-next: build failure after merge of the net-next tree
Message-ID: <20190829200546.7b9af296@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/=Mx0oFyYb3enaJjPSrlGF8N";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/=Mx0oFyYb3enaJjPSrlGF8N
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the net-next tree, today's linux-next build (powepc
allmodconfig) failed like this:

ld: drivers/net/ethernet/stmicro/stmmac/stmmac_pci.o: in function `.stmmac_=
pci_remove':
stmmac_pci.c:(.text.stmmac_pci_remove+0x68): undefined reference to `.clk_u=
nregister_fixed_rate'
ld: drivers/net/ethernet/stmicro/stmmac/stmmac_pci.o: in function `.intel_m=
gbe_common_data':
stmmac_pci.c:(.text.intel_mgbe_common_data+0x2a8): undefined reference to `=
.clk_register_fixed_rate'

Caused by commit

  190f73ab4c43 ("net: stmmac: setup higher frequency clk support for EHL & =
TGL")

CONFIG_COMMON_CLK is not set for this build.

I have added the following patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 29 Aug 2019 19:49:27 +1000
Subject: [PATCH] net: stmmac: depend on COMMON_CLK

Fixes: 190f73ab4c43 ("net: stmmac: setup higher frequency clk support for E=
HL & TGL")
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/ethernet/stmicro/stmmac/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethe=
rnet/stmicro/stmmac/Kconfig
index 2325b40dff6e..338e25a6374e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
+++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
@@ -200,6 +200,7 @@ endif
 config STMMAC_PCI
 	tristate "STMMAC PCI bus support"
 	depends on STMMAC_ETH && PCI
+	depends on COMMON_CLK
 	---help---
 	  This selects the platform specific bus support for the stmmac driver.
 	  This driver was tested on XLINX XC2V3000 FF1152AMT0221
--=20
2.20.1

--=20
Cheers,
Stephen Rothwell

--Sig_/=Mx0oFyYb3enaJjPSrlGF8N
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl1no3oACgkQAVBC80lX
0GwYJQf5AW95Yd94wttbI+/ilAUaktT8zLlhPKRd3YkkIDeOsMxRrgnyseGd8hbS
xHLwNqbx0R8JGKZ2Dpi1d+KwR9vuSaOmK4bCM5DeS6j2WGDZeh/qpyiSaJOLfCqD
whVLXmwqoLLzAbLJ/nWwFlOqmMKJYXpc/rc6yGdmihjv8Sdl/YZarKhH9SvJavmY
TZpSNwN8PCIesO5ryTrMdlgDveRYzMFnJ+l2EWEMziH0iUOfPVdzivuaKmzPh8bV
Z3a1iAhLuUawtpngWfaLpot6Zt8InSYXvSN/frQyrMIqNeKkU3nA79OQlwqmMNOu
jbuw4/OtFyPXOwrj750ckXq/1trRuA==
=sMh9
-----END PGP SIGNATURE-----

--Sig_/=Mx0oFyYb3enaJjPSrlGF8N--

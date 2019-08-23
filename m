Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB2E79A58F
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 04:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390061AbfHWCfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 22:35:14 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:48211 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725856AbfHWCfN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 22:35:13 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 46F58r1Kg0z9s7T;
        Fri, 23 Aug 2019 12:35:08 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1566527710;
        bh=2w1O39fqBqmJqk2tKtjRcxFlQifasUHv32rpJh2IRwA=;
        h=Date:From:To:Cc:Subject:From;
        b=XfZZy0yZXUgWfHiKlwnCmKvR2luZQAumTBvqYfNTThPqJ3pV1r/DjeUFfknOrE8SG
         orHdQ/oOKYB0i8B7w6yOqtHKGp+Org4V/Wgi/HMts0TNPYnCMt8kBae0hBH+RBEQoZ
         plO0+Z/xIR4DBlSOJpU8THCCaabT1XCOXQsezEOLZLUYwW76fiGTyW9Pv7bYocLRBr
         LQixqqy7NSaBqcSAIMS0RswWq1s54XXkps9/dlC89LqPk/ca49BWBueXfOh6uK1hIo
         yXZr6vRJ8ezuWAfIoUiFGoicUa5i0NQao22H3fnwgEgyUJWBC+Do1fz17xPhig+8GM
         XXjB0sXTPLILQ==
Date:   Fri, 23 Aug 2019 12:35:07 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Subject: linux-next: manual merge of the net-next tree with the pci tree
Message-ID: <20190823123507.197cac03@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/tzrOwkngRKoyGZRQEgxv1R=";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/tzrOwkngRKoyGZRQEgxv1R=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got conflicts in:

  drivers/pci/Kconfig
  drivers/pci/controller/pci-hyperv.c

between commit:

  f58ba5e3f686 ("PCI: pci-hyperv: Fix build errors on non-SYSFS config")
  44b1ece783ff ("PCI: hv: Detect and fix Hyper-V PCI domain number collisio=
n")

from the pci tree and commit:

  348dd93e40c1 ("PCI: hv: Add a Hyper-V PCI interface driver for software b=
ackchannel interface")

from the net-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc drivers/pci/Kconfig
index 232042722261,c313de96a357..000000000000
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@@ -181,7 -181,8 +181,8 @@@ config PCI_LABE
 =20
  config PCI_HYPERV
          tristate "Hyper-V PCI Frontend"
 -        depends on X86 && HYPERV && PCI_MSI && PCI_MSI_IRQ_DOMAIN && X86_=
64
 +        depends on X86_64 && HYPERV && PCI_MSI && PCI_MSI_IRQ_DOMAIN && S=
YSFS
+ 	select PCI_HYPERV_INTERFACE
          help
            The PCI device frontend driver allows the kernel to import arbi=
trary
            PCI devices from a PCI backend to support PCI driver domains.
diff --cc drivers/pci/controller/pci-hyperv.c
index 3a56de6b2ec2,9c93ac2215b7..000000000000
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@@ -2810,9 -3050,11 +3113,14 @@@ static void __exit exit_hv_pci_drv(void
 =20
  static int __init init_hv_pci_drv(void)
  {
 +	/* Set the invalid domain number's bit, so it will not be used */
 +	set_bit(HVPCI_DOM_INVALID, hvpci_dom_map);
 +
+ 	/* Initialize PCI block r/w interface */
+ 	hvpci_block_ops.read_block =3D hv_read_config_block;
+ 	hvpci_block_ops.write_block =3D hv_write_config_block;
+ 	hvpci_block_ops.reg_blk_invalidate =3D hv_register_block_invalidate;
+=20
  	return vmbus_driver_register(&hv_pci_drv);
  }
 =20

--Sig_/tzrOwkngRKoyGZRQEgxv1R=
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl1fUNsACgkQAVBC80lX
0Gw0Sgf+LjUNk01+W+n9S8sWmfNWLqaKRFDu0zPU655BKTUdkNzw0VUPddKCO0UP
/aZwvRZpDp81htm41iBqe5NNi+jEO2CcLfgYoRgY8wNgYArIUKzbwqLfxNbAoO7X
4djAHjLFqqcVlfC72cqO++OERpZDDHDxn0qvqmXch7jKEMX9WMiW01hny3aXa1UN
pFkP7HEDwI4m1WR360dUWzI5tceuvreC8oeKjH05U7Nvs/Y3B6k664bnH5jHl6o+
VU1q56ZOrK2jBHRPohahnZCNzvByLciT+EaTndk/4c9YJnLzrvQZTdeOo6cxJ8uD
wYTRMY5NOkCr3/+BpHGojkgUBKXG7Q==
=V7ms
-----END PGP SIGNATURE-----

--Sig_/tzrOwkngRKoyGZRQEgxv1R=--

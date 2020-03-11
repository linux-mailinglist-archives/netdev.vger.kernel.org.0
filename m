Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70891180D92
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 02:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbgCKBdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 21:33:31 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:59475 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727484AbgCKBdb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 21:33:31 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48cZGs4NtWz9s3x;
        Wed, 11 Mar 2020 12:33:25 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1583890407;
        bh=qPTgb9mMJWX0JwqMPHT/IxZFbU+joOqwR/+5g2LF+kA=;
        h=Date:From:To:Cc:Subject:From;
        b=VfobzLcNZBoY4p6dRTXthkJwdLsZoMuuH0kraGYC+IoAyccYopAapvAawS6lzK0fs
         gq4MTPppkGRVwTc7sfGqdT/8NLaWngIhp6GDrzyGeFZHDxocXV/CvMmrJIQ35yQZTl
         3FELkK74xh5J1LUz4vgDCL4C+knvQNOfc3K4KW5UMO73pEjyoMLVVrduggpKLZY8Oc
         cfz2a5AL+stGOyDe2E9iFy2kFCWyEOgbuO+9IjQ92xRlM9UQAu9PTPrhTtIIETd3SL
         l9toRhFH/KBcKgLUEqOsWzph4MGpdci7y4KLW/CleTUFFeOt0zqxTLNsYwyaFU4fsi
         vehqvRQACFsPg==
Date:   Wed, 11 Mar 2020 12:33:18 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20200311123318.51eff802@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/JF2vUcnOrMs.cnYuTAW8+N6";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/JF2vUcnOrMs.cnYuTAW8+N6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/mscc/ocelot.c

between commit:

  a8015ded89ad ("net: mscc: ocelot: properly account for VLAN header length=
 when setting MRU")

from the net tree and commit:

  69df578c5f4b ("net: mscc: ocelot: eliminate confusion between CPU and NPI=
 port")

from the net-next tree.

I fixed it up (I think - see below) and can carry the fix as
necessary. This is now fixed as far as linux-next is concerned, but any
non trivial conflicts should be mentioned to your upstream maintainer
when your tree is submitted for merging.  You may also want to consider
cooperating with the maintainer of the conflicting tree to minimise any
particularly complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc drivers/net/ethernet/mscc/ocelot.c
index d3b7373c5961,06f9d013f807..000000000000
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@@ -2310,27 -2323,34 +2329,34 @@@ void ocelot_configure_cpu(struct ocelo
  			 ANA_PORT_PORT_CFG_PORTID_VAL(cpu),
  			 ANA_PORT_PORT_CFG, cpu);
 =20
- 	/* If the CPU port is a physical port, set up the port in Node
- 	 * Processor Interface (NPI) mode. This is the mode through which
- 	 * frames can be injected from and extracted to an external CPU.
- 	 * Only one port can be an NPI at the same time.
- 	 */
- 	if (cpu < ocelot->num_phys_ports) {
+ 	if (npi >=3D 0 && npi < ocelot->num_phys_ports) {
 -		int mtu =3D VLAN_ETH_FRAME_LEN + OCELOT_TAG_LEN;
 +		int sdu =3D ETH_DATA_LEN + OCELOT_TAG_LEN;
 =20
  		ocelot_write(ocelot, QSYS_EXT_CPU_CFG_EXT_CPUQ_MSK_M |
- 			     QSYS_EXT_CPU_CFG_EXT_CPU_PORT(cpu),
+ 			     QSYS_EXT_CPU_CFG_EXT_CPU_PORT(npi),
  			     QSYS_EXT_CPU_CFG);
 =20
  		if (injection =3D=3D OCELOT_TAG_PREFIX_SHORT)
 -			mtu +=3D OCELOT_SHORT_PREFIX_LEN;
 +			sdu +=3D OCELOT_SHORT_PREFIX_LEN;
  		else if (injection =3D=3D OCELOT_TAG_PREFIX_LONG)
 -			mtu +=3D OCELOT_LONG_PREFIX_LEN;
 +			sdu +=3D OCELOT_LONG_PREFIX_LEN;
 =20
- 		ocelot_port_set_maxlen(ocelot, cpu, sdu);
 -		ocelot_port_set_mtu(ocelot, npi, mtu);
++		ocelot_port_set_maxlen(ocelot, npi, sdu);
+=20
+ 		/* Enable NPI port */
+ 		ocelot_write_rix(ocelot,
+ 				 QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE |
+ 				 QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG(1) |
+ 				 QSYS_SWITCH_PORT_MODE_PORT_ENA,
+ 				 QSYS_SWITCH_PORT_MODE, npi);
+ 		/* NPI port Injection/Extraction configuration */
+ 		ocelot_write_rix(ocelot,
+ 				 SYS_PORT_MODE_INCL_XTR_HDR(extraction) |
+ 				 SYS_PORT_MODE_INCL_INJ_HDR(injection),
+ 				 SYS_PORT_MODE, npi);
  	}
 =20
- 	/* CPU port Injection/Extraction configuration */
+ 	/* Enable CPU port module */
  	ocelot_write_rix(ocelot, QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE |
  			 QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG(1) |
  			 QSYS_SWITCH_PORT_MODE_PORT_ENA,

--Sig_/JF2vUcnOrMs.cnYuTAW8+N6
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl5oP94ACgkQAVBC80lX
0Gz0aQf/dc9xZsfmIau6hOVEzrinZzgwQfXpIhsqp5P4IWh+eRV/ZPi8NHFUCIZq
BrjKVCXV1EdADDHXOkUlzyw3MsAAgPhC5uZqJQh10JX9pZChF9LAqnsIsu9S7CKQ
Wf3YR6Zr3Y81fB4kgLhOxgdq09fb8yzEYdnUc/s2RfqkRh0F1fi09LBLGp9hifh/
fxsTuxo3QUKWtwoCpGkREJmVr/c9anFI9ti2+pGj8+krh37t6qagaM8s3hXhY/O8
KSpRLzWugfhR0ttWOkXI8JbJxV5A/pCJBzG2TGzVkbB6NVXatUF3NhjZEoaPuH0M
nJuQY+ux86PhIvR6kTjK8XJCrMT6Ew==
=4lSb
-----END PGP SIGNATURE-----

--Sig_/JF2vUcnOrMs.cnYuTAW8+N6--

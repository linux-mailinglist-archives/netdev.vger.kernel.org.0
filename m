Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF6B3253B1E
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 02:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgH0Aek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 20:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgH0Aek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 20:34:40 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D17ACC061574;
        Wed, 26 Aug 2020 17:34:39 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BcNz009m4z9sSJ;
        Thu, 27 Aug 2020 10:34:35 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1598488476;
        bh=9J3Z/RzmtRQDyJKD7cxNHhVKPsEKKjMqAhiaCqWxv2I=;
        h=Date:From:To:Cc:Subject:From;
        b=UFWD8x2L2olBkNTpbRRIUM7dWECWZiMc99uPAX0WIoRISLai8zFPDCV+WMnFvdtjg
         PBPnqHOGQuswyRV5R3QBTQ4ePO44EFHGcWbK+2bZj8ZrqvuqKSEvNtLZD5kHhfp7vs
         T3DAagGDrblUZXvu//6DxFHLKolN+rn3EXzAkepV9Cyau7hV4t4ZumTOqiDteRgJZQ
         IS64ek5kA4O5UDuct0UHeCQXd3xen99XGXPmnRSP9vJXxRM8cqU68QBONvPuIeopHe
         5/BceKJjs+6D7SUCXdKQRpUZZBIGc+nargChAR+0jJg1qsE6shXKfXkrPBLmelwQZb
         WY82hQatXfuJQ==
Date:   Thu, 27 Aug 2020 10:34:33 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mingming Cao <mmc@linux.vnet.ibm.com>,
        Dany Madden <drt@linux.ibm.com>,
        Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20200827103433.43d384c8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/eFsjpf3wj2EBY0NwhpmDa5W";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/eFsjpf3wj2EBY0NwhpmDa5W
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/ibm/ibmvnic.c

between commit:

  9f1345737790 ("ibmvnic fix NULL tx_pools and rx_tools issue at do_reset")

from the net tree and commit:

  507ebe6444a4 ("ibmvnic: Fix use-after-free of VNIC login response buffer")

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

diff --cc drivers/net/ethernet/ibm/ibmvnic.c
index d3a774331afc,86a83e53dce5..000000000000
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@@ -475,17 -467,12 +467,15 @@@ static int init_stats_token(struct ibmv
  static int reset_rx_pools(struct ibmvnic_adapter *adapter)
  {
  	struct ibmvnic_rx_pool *rx_pool;
+ 	u64 buff_size;
  	int rx_scrqs;
  	int i, j, rc;
- 	u64 *size_array;
 =20
 +	if (!adapter->rx_pool)
 +		return -1;
 +
- 	size_array =3D (u64 *)((u8 *)(adapter->login_rsp_buf) +
- 		be32_to_cpu(adapter->login_rsp_buf->off_rxadd_buff_size));
-=20
- 	rx_scrqs =3D be32_to_cpu(adapter->login_rsp_buf->num_rxadd_subcrqs);
+ 	buff_size =3D adapter->cur_rx_buf_sz;
+ 	rx_scrqs =3D adapter->num_active_rx_pools;
  	for (i =3D 0; i < rx_scrqs; i++) {
  		rx_pool =3D &adapter->rx_pool[i];
 =20
@@@ -652,10 -637,7 +640,10 @@@ static int reset_tx_pools(struct ibmvni
  	int tx_scrqs;
  	int i, rc;
 =20
 +	if (!adapter->tx_pool)
 +		return -1;
 +
- 	tx_scrqs =3D be32_to_cpu(adapter->login_rsp_buf->num_txsubm_subcrqs);
+ 	tx_scrqs =3D adapter->num_active_tx_pools;
  	for (i =3D 0; i < tx_scrqs; i++) {
  		rc =3D reset_one_tx_pool(adapter, &adapter->tso_pool[i]);
  		if (rc)

--Sig_/eFsjpf3wj2EBY0NwhpmDa5W
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl9G/5kACgkQAVBC80lX
0GyqeAf9HUzAizW3e60JQkmaqI4HiLYdWb2Ko5Tig93cGN46SZ3PaO3W6zSoPsaY
j2xUQMcn9YNl6P7Cw35va+NB5QorhswnpvlnT4CMx+dslgX3O1tHatypCITvzd7J
VwaZPjIqbapdNMq+e99Wc8aVsV89FNm4N75/q4JDi/VITgfA/gbzCXO0ZK7ekhir
y/vT4uHekS/zKCgKT3Mv5Uw99B52RbKrLaLswI6nWyG79D19uuR4r5LpmY/1Iel8
XxfvPgtgNUVfDqCam4HKG6qsTng706AJ0gNQ/6xvvSFKJVBvDlvcwHCIrQqFX0rS
4MID+hlXGoY11nhJ4s0wls4h9LAPjQ==
=1LSu
-----END PGP SIGNATURE-----

--Sig_/eFsjpf3wj2EBY0NwhpmDa5W--

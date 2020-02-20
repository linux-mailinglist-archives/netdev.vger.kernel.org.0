Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22AA4166AD2
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 00:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729335AbgBTXMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 18:12:40 -0500
Received: from ozlabs.org ([203.11.71.1]:38461 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729027AbgBTXMk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 18:12:40 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48Nr382l3Sz9sPk;
        Fri, 21 Feb 2020 10:12:36 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1582240356;
        bh=9q6mRNIp03dcqTokBVM+57+us+Lfs23/8GR9JHEgJnI=;
        h=Date:From:To:Cc:Subject:From;
        b=TdDjBgqCXTJ+Q4VMJ95puLVMlZFFgOjsIMfbnW2+V2udyMnmoLqhuiq9wnXdla900
         xAU5WkUQU9cJpCehqNaKUK1s3MiaapJYz2nNake0RUtR9FFTQaePylNynrzCJhLYfa
         os21j+z89s87vSZjjjDzq2z+2tB9pXds/xAktfWSYpUOdQ5IRryaV5Co6XfJkoPLv7
         +K0c3iOJDmuOnIagX7re0Nd46pSNuadcn7RYRFAAsHm5PgEfwhBhd1vU7WxHULGYTg
         t70mGoHTpf+PpKfSK+fXfod2VCAps1mxh24nh8YNgm0zYeBWazAd5boRIK5DbT8feV
         wTeFUaRSG9mKw==
Date:   Fri, 21 Feb 2020 10:12:35 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Brett Creeley <brett.creeley@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20200221101235.3db4fc56@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/8kFVcoFSaXg35pzhBJbQ1WN";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/8kFVcoFSaXg35pzhBJbQ1WN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in:

  drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c

between commit:

  c54d209c78b8 ("ice: Wait for VF to be reset/ready before configuration")

from the net tree and commits:

  b093841f9ac9 ("ice: Refactor port vlan configuration for the VF")
  61c9ce86a6f5 ("ice: Fix Port VLAN priority bits")

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

diff --cc drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 75c70d432c72,a21f9d2edbbb..000000000000
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@@ -2738,7 -2786,8 +2828,8 @@@ ice_set_vf_port_vlan(struct net_device=20
  	struct ice_vsi *vsi;
  	struct device *dev;
  	struct ice_vf *vf;
+ 	u16 vlanprio;
 -	int ret =3D 0;
 +	int ret;
 =20
  	dev =3D ice_pf_to_dev(pf);
  	if (ice_validate_vf_id(pf, vf_id))
@@@ -2756,47 -2806,58 +2848,59 @@@
 =20
  	vf =3D &pf->vf[vf_id];
  	vsi =3D pf->vsi[vf->lan_vsi_idx];
 -	if (ice_check_vf_init(pf, vf))
 -		return -EBUSY;
 +
 +	ret =3D ice_check_vf_ready_for_cfg(vf);
 +	if (ret)
 +		return ret;
 =20
- 	if (le16_to_cpu(vsi->info.pvid) =3D=3D vlanprio) {
+ 	vlanprio =3D vlan_id | (qos << VLAN_PRIO_SHIFT);
+=20
+ 	if (vf->port_vlan_info =3D=3D vlanprio) {
  		/* duplicate request, so just return success */
  		dev_dbg(dev, "Duplicate pvid %d request\n", vlanprio);
 -		return ret;
 +		return 0;
  	}
 =20
- 	/* If PVID, then remove all filters on the old VLAN */
- 	if (vsi->info.pvid)
- 		ice_vsi_kill_vlan(vsi, (le16_to_cpu(vsi->info.pvid) &
- 				  VLAN_VID_MASK));
-=20
  	if (vlan_id || qos) {
+ 		/* remove VLAN 0 filter set by default when transitioning from
+ 		 * no port VLAN to a port VLAN. No change to old port VLAN on
+ 		 * failure.
+ 		 */
+ 		ret =3D ice_vsi_kill_vlan(vsi, 0);
+ 		if (ret)
+ 			return ret;
  		ret =3D ice_vsi_manage_pvid(vsi, vlanprio, true);
  		if (ret)
  			return ret;
  	} else {
- 		ice_vsi_manage_pvid(vsi, 0, false);
- 		vsi->info.pvid =3D 0;
+ 		/* add VLAN 0 filter back when transitioning from port VLAN to
+ 		 * no port VLAN. No change to old port VLAN on failure.
+ 		 */
+ 		ret =3D ice_vsi_add_vlan(vsi, 0);
+ 		if (ret)
+ 			return ret;
+ 		ret =3D ice_vsi_manage_pvid(vsi, 0, false);
+ 		if (ret)
 -			goto error_manage_pvid;
++			return ret;
  	}
 =20
  	if (vlan_id) {
  		dev_info(dev, "Setting VLAN %d, QoS 0x%x on VF %d\n",
  			 vlan_id, qos, vf_id);
 =20
- 		/* add new VLAN filter for each MAC */
+ 		/* add VLAN filter for the port VLAN */
  		ret =3D ice_vsi_add_vlan(vsi, vlan_id);
  		if (ret)
 -			goto error_manage_pvid;
 +			return ret;
  	}
+ 	/* remove old port VLAN filter with valid VLAN ID or QoS fields */
+ 	if (vf->port_vlan_info)
+ 		ice_vsi_kill_vlan(vsi, vf->port_vlan_info & VLAN_VID_MASK);
 =20
- 	/* The Port VLAN needs to be saved across resets the same as the
- 	 * default LAN MAC address.
- 	 */
- 	vf->port_vlan_id =3D le16_to_cpu(vsi->info.pvid);
+ 	/* keep port VLAN information persistent on resets */
+ 	vf->port_vlan_info =3D le16_to_cpu(vsi->info.pvid);
 =20
 -error_manage_pvid:
 -	return ret;
 +	return 0;
  }
 =20
  /**

--Sig_/8kFVcoFSaXg35pzhBJbQ1WN
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl5PEmMACgkQAVBC80lX
0Gzoqwf9FP4eMWnPBiWV08yZ3C7pb8dz5+Azf24h1tq8kFFCrDYcB/F7H3QDEUFk
gKie/4sunhaV93GKs9nQwJLwV0IQU1CbtZAdIj4vqK/ERzr8MwxgBNFA05PFjiUm
51UkjkMNDBSBxwsDXpFMpZS4VJw8EvVAmT3cC9VrlwU1wnJQiPmFSIFq7I9ZD//k
BPqbPCGlDI0g4hBN/DO10vfsFM382UVlrqEy9jj8xgfO3ccmkaG+ZyGZ8pN8kMKf
ad2Wq5oRvtZ75gdM9AAvCw7hCer7qrOHj46tjUBcJOLo/S5WqWu7XdPAGwsnCPSX
mubFsy0nZRZ1DZwR+KFCdohrAUpyog==
=OU+m
-----END PGP SIGNATURE-----

--Sig_/8kFVcoFSaXg35pzhBJbQ1WN--

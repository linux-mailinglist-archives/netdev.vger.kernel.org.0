Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F42668CA6E
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 00:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjBFXT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 18:19:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbjBFXTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 18:19:55 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A199A23DB7;
        Mon,  6 Feb 2023 15:19:54 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4P9j0840nlz4wgv;
        Tue,  7 Feb 2023 10:19:52 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1675725593;
        bh=ni+bLM6l7ZkTck+F3T4d2YIdoOVQvjtejmkcOYZePOU=;
        h=Date:From:To:Cc:Subject:From;
        b=eKRlzXq8KKU9teDIlnQo2POgDWpoyjxDu8J091pnc+cYSxbcWudHKwwrp1iib9B8s
         clYXeTMRFuMw2x+uFDOSxkRWegEi30aimjsfKLYD9yvoMXd3cHFmtNw9jl6RscbmAs
         DsFZD1cDyk7qChXtzbjovaB66gKHU7Mt351WbkdDj3Y+pADmozNr15XtNSks0zidVS
         wgXrS7FPr3zeWJYQOKSB5IhrUjHfc6h0W6Yw/JTnD3cTGlGeeea9yUccyxHW0PRf1u
         dNvXue9YLCsN/a8u5cBRjwyAQ+/QCorlC1RjSNCsGXnsfctFOF4BruMwsYU0+VQ4zh
         ///hZ30M7Lk1g==
Date:   Tue, 7 Feb 2023 10:19:51 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Marek Majtyka <alardam@gmail.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: linux-next: manual merge of the bpf-next tree with the net-next
 tree
Message-ID: <20230207101951.21a114fa@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ncoCfePRb/8QXm18p12O9Kq";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/ncoCfePRb/8QXm18p12O9Kq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the bpf-next tree got a conflict in:

  drivers/net/ethernet/intel/ice/ice_main.c

between commit:

  5b246e533d01 ("ice: split probe into smaller functions")

from the net-next tree and commit:

  66c0e13ad236 ("drivers: net: turn on XDP features")

from the bpf-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc drivers/net/ethernet/intel/ice/ice_main.c
index 433298d0014a,074b0e6d0e2d..000000000000
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@@ -4485,116 -4619,6 +4501,118 @@@ static int ice_register_netdev(struct i
  		return -EIO;
 =20
  	err =3D register_netdev(vsi->netdev);
 +	if (err)
 +		return err;
 +
 +	set_bit(ICE_VSI_NETDEV_REGISTERED, vsi->state);
 +	netif_carrier_off(vsi->netdev);
 +	netif_tx_stop_all_queues(vsi->netdev);
 +
 +	return 0;
 +}
 +
 +static void ice_unregister_netdev(struct ice_vsi *vsi)
 +{
 +	if (!vsi || !vsi->netdev)
 +		return;
 +
 +	unregister_netdev(vsi->netdev);
 +	clear_bit(ICE_VSI_NETDEV_REGISTERED, vsi->state);
 +}
 +
 +/**
 + * ice_cfg_netdev - Allocate, configure and register a netdev
 + * @vsi: the VSI associated with the new netdev
 + *
 + * Returns 0 on success, negative value on failure
 + */
 +static int ice_cfg_netdev(struct ice_vsi *vsi)
 +{
 +	struct ice_netdev_priv *np;
 +	struct net_device *netdev;
 +	u8 mac_addr[ETH_ALEN];
 +
 +	netdev =3D alloc_etherdev_mqs(sizeof(*np), vsi->alloc_txq,
 +				    vsi->alloc_rxq);
 +	if (!netdev)
 +		return -ENOMEM;
 +
 +	set_bit(ICE_VSI_NETDEV_ALLOCD, vsi->state);
 +	vsi->netdev =3D netdev;
 +	np =3D netdev_priv(netdev);
 +	np->vsi =3D vsi;
 +
 +	ice_set_netdev_features(netdev);
++	netdev->xdp_features =3D NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
++			       NETDEV_XDP_ACT_XSK_ZEROCOPY;
 +	ice_set_ops(netdev);
 +
 +	if (vsi->type =3D=3D ICE_VSI_PF) {
 +		SET_NETDEV_DEV(netdev, ice_pf_to_dev(vsi->back));
 +		ether_addr_copy(mac_addr, vsi->port_info->mac.perm_addr);
 +		eth_hw_addr_set(netdev, mac_addr);
 +	}
 +
 +	netdev->priv_flags |=3D IFF_UNICAST_FLT;
 +
 +	/* Setup netdev TC information */
 +	ice_vsi_cfg_netdev_tc(vsi, vsi->tc_cfg.ena_tc);
 +
 +	netdev->max_mtu =3D ICE_MAX_MTU;
 +
 +	return 0;
 +}
 +
 +static void ice_decfg_netdev(struct ice_vsi *vsi)
 +{
 +	clear_bit(ICE_VSI_NETDEV_ALLOCD, vsi->state);
 +	free_netdev(vsi->netdev);
 +	vsi->netdev =3D NULL;
 +}
 +
 +static int ice_start_eth(struct ice_vsi *vsi)
 +{
 +	int err;
 +
 +	err =3D ice_init_mac_fltr(vsi->back);
 +	if (err)
 +		return err;
 +
 +	rtnl_lock();
 +	err =3D ice_vsi_open(vsi);
 +	rtnl_unlock();
 +
 +	return err;
 +}
 +
 +static int ice_init_eth(struct ice_pf *pf)
 +{
 +	struct ice_vsi *vsi =3D ice_get_main_vsi(pf);
 +	int err;
 +
 +	if (!vsi)
 +		return -EINVAL;
 +
 +	/* init channel list */
 +	INIT_LIST_HEAD(&vsi->ch_list);
 +
 +	err =3D ice_cfg_netdev(vsi);
 +	if (err)
 +		return err;
 +	/* Setup DCB netlink interface */
 +	ice_dcbnl_setup(vsi);
 +
 +	err =3D ice_init_mac_fltr(pf);
 +	if (err)
 +		goto err_init_mac_fltr;
 +
 +	err =3D ice_devlink_create_pf_port(pf);
 +	if (err)
 +		goto err_devlink_create_pf_port;
 +
 +	SET_NETDEV_DEVLINK_PORT(vsi->netdev, &pf->devlink_port);
 +
 +	err =3D ice_register_netdev(vsi);
  	if (err)
  		goto err_register_netdev;
 =20

--Sig_/ncoCfePRb/8QXm18p12O9Kq
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmPhixcACgkQAVBC80lX
0GyOrQf/WjUIV9sxXfz6tzSy1t581UV9rgMLQYWFP50vbEM6F72r189CjT8WpmcK
fQTyAJ3S501Y3Eo47WbP5txvmefEe6/FvO3Y3ZKdvBv0EiIR9T5YlcZlMw4iOjXC
rGMZOeR9xV550CDiylzw+ZhIwba85OK/lE/HapVPXdX6V6rU4+FkUsMKAu8cA5vL
xiU0/2xvTkKDTA8igVG47GfIuu5KL8a6OdWwQUdCPsvotm6dHaIA1m8Q+CWKPYhH
kEqPSZwgM4s88SlRU2bVBXKGW+NbdYXkQmICdhD3Qxp3oQxgyCFZ8AEovS8Z5u0o
S2eHIhtmly3NMY5IC01RyLD6tTahKQ==
=pEET
-----END PGP SIGNATURE-----

--Sig_/ncoCfePRb/8QXm18p12O9Kq--

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B20A58FD6
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 03:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfF1BpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 21:45:10 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:58969 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726500AbfF1BpK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 21:45:10 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 45Zfhx4QTcz9s3Z;
        Fri, 28 Jun 2019 11:45:05 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1561686305;
        bh=4aAH+l1+X6slCnnOWZAlgZ4hfMF/p/4CgqBa64BdBdg=;
        h=Date:From:To:Cc:Subject:From;
        b=FTihH1TCGpy9WKHLi3K5cMZdGcxDG2AOj8ASRNNxt11FtW0R/IFYTShPOFIs02TwS
         YKyqK23OVmYVz1nsPemfcETk9qjU9swhLnIgXOPRsVR5p5CyV8RvV4jp4v8d8ka0R6
         ZWGZOQNq9spzSRpjTiO8duWYJbYzUqyL7EwTtUN1TQUJ+VTJLrt/1zq1ufy4LAY4Tq
         2PvzjhxhmTde/pGmOWNYgFRi7CsE5ph7VRzW328WAhbGXIaLIOptt9zhPIU+oPlfRn
         m0N+VoLR9feb8JrH3NX4UCAdE7DDeTHxqivRP6jOAjD0eVesqe3NSt0aZx9twAUFcT
         rrIhHXomSmJjQ==
Date:   Fri, 28 Jun 2019 11:45:04 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>,
        Igor Russkikh <igor.russkikh@aquantia.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20190628114504.52d3fe65@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/KTqn5qH3d8uD5y73ynfmeX="; protocol="application/pgp-signature"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/KTqn5qH3d8uD5y73ynfmeX=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got conflicts in:

  drivers/net/ethernet/aquantia/atlantic/aq_nic.c
  drivers/net/ethernet/aquantia/atlantic/aq_nic.h

between commit:

  48dd73d08d4d ("net: aquantia: fix vlans not working over bridged network")

from the net tree and commit:

  d3ed7c5cf79b ("net: aquantia: adding fields and device features for vlan =
offload")

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

diff --cc drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 41172fbebddd,746f85e6de13..000000000000
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@@ -126,7 -126,8 +126,9 @@@ void aq_nic_cfg_start(struct aq_nic_s *
 =20
  	cfg->link_speed_msk &=3D cfg->aq_hw_caps->link_speed_msk;
  	cfg->features =3D cfg->aq_hw_caps->hw_features;
 +	cfg->is_vlan_force_promisc =3D true;
+ 	cfg->is_vlan_rx_strip =3D !!(cfg->features & NETIF_F_HW_VLAN_CTAG_RX);
+ 	cfg->is_vlan_tx_insert =3D !!(cfg->features & NETIF_F_HW_VLAN_CTAG_TX);
  }
 =20
  static int aq_nic_update_link_status(struct aq_nic_s *self)
diff --cc drivers/net/ethernet/aquantia/atlantic/aq_nic.h
index 0f22f5d5691b,26c72f298684..000000000000
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
@@@ -35,7 -35,8 +35,9 @@@ struct aq_nic_cfg_s=20
  	u32 flow_control;
  	u32 link_speed_msk;
  	u32 wol;
 +	bool is_vlan_force_promisc;
+ 	u8 is_vlan_rx_strip;
+ 	u8 is_vlan_tx_insert;
  	u16 is_mc_list_enabled;
  	u16 mc_list_count;
  	bool is_autoneg;

--Sig_/KTqn5qH3d8uD5y73ynfmeX=
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl0VcSAACgkQAVBC80lX
0GwEwgf9F59Mr2vpug7MbUet63z2io8N+oOHPXiygDfcGpDg/UW/OqxucjJi+8PG
GRgtbMi3iD6WKIwkFYFQ+58OZW9XX5GX6c6FrtXL3l/+HdC78R5exwBDR/DDGHWo
ewi86VkLvY8AJBc8rQuOAOMfly4lpmMMt7pOoDaubG2eOLuurDKzQ/d+jNXF3a2Z
4bDLOjQopG3bN4HC+5YwXYwRt9STssRole9nxjm26sFIjqzBqV9P8dfz5r9a0NDr
FNVAL9HvQZFKEIks7bGzIevleXyVdyfkFfRI+b5uCCKbvfiBDILVVjatPuL6xvUv
5NWKquzlTbFjObk1mMViRfsUB/PRBg==
=RNk3
-----END PGP SIGNATURE-----

--Sig_/KTqn5qH3d8uD5y73ynfmeX=--

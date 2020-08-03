Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F39B239D9B
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 05:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbgHCDFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 23:05:34 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:58303 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725820AbgHCDFe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Aug 2020 23:05:34 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4BKjS94QYcz9sTX;
        Mon,  3 Aug 2020 13:05:29 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1596423931;
        bh=McqvNsZTich5yNdwdrEuQyo7JQmSsgYuQqaKmpJV98E=;
        h=Date:From:To:Cc:Subject:From;
        b=G4kNA36xMUznfWAEg7LY4OKz2NiDDUDY594gOBQ7szFKt7+6ROUQzynEYtU/Cj3id
         iPVcxxlp7Ku1OFbTH9szVLt/iTDtQqm/wFGMONopArPjgZBTITW7O/PLHOsaLXr4VZ
         kgdjY7J1zVJrNomb464qfhxDd2+tO3kOxb+W8VL9LRDQ+WNxeYnM1oMhPpjr77d6Xj
         vn9/T2AD10d5MLZMBW0UMjmokzC2R2P///pHRPOQ4kG8cKBS7xZsZKw3HwLS7lkwDE
         2k6M4CHBzl3pUn8uEzIz7iy8rZK1ErmQruuR8OrReUwco4DcnFdwlUODjKk9betQh3
         Hu8WQnCb5sYEw==
Date:   Mon, 3 Aug 2020 13:05:26 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: linux-next: manual merge of the bpf-next tree with the net-next
 tree
Message-ID: <20200803130526.5a1519e2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/2W0N1U4_IJj+gYzUQWfA8RM";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/2W0N1U4_IJj+gYzUQWfA8RM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the bpf-next tree got a conflict in:

  net/core/dev.c

between commit:

  829eb208e80d ("rtnetlink: add support for protodown reason")

from the net-next tree and commits:

  7f0a838254bd ("bpf, xdp: Maintain info on attached XDP BPF programs in ne=
t_device")
  aa8d3a716b59 ("bpf, xdp: Add bpf_link-based XDP attachment API")

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

diff --cc net/core/dev.c
index f7ef0f5c5569,c8b911b10187..000000000000
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@@ -8715,54 -8712,75 +8711,100 @@@ int dev_change_proto_down_generic(struc
  }
  EXPORT_SYMBOL(dev_change_proto_down_generic);
 =20
 +/**
 + *	dev_change_proto_down_reason - proto down reason
 + *
 + *	@dev: device
 + *	@mask: proto down mask
 + *	@value: proto down value
 + */
 +void dev_change_proto_down_reason(struct net_device *dev, unsigned long m=
ask,
 +				  u32 value)
 +{
 +	int b;
 +
 +	if (!mask) {
 +		dev->proto_down_reason =3D value;
 +	} else {
 +		for_each_set_bit(b, &mask, 32) {
 +			if (value & (1 << b))
 +				dev->proto_down_reason |=3D BIT(b);
 +			else
 +				dev->proto_down_reason &=3D ~BIT(b);
 +		}
 +	}
 +}
 +EXPORT_SYMBOL(dev_change_proto_down_reason);
 +
- u32 __dev_xdp_query(struct net_device *dev, bpf_op_t bpf_op,
- 		    enum bpf_netdev_command cmd)
+ struct bpf_xdp_link {
+ 	struct bpf_link link;
+ 	struct net_device *dev; /* protected by rtnl_lock, no refcnt held */
+ 	int flags;
+ };
+=20
+ static enum bpf_xdp_mode dev_xdp_mode(u32 flags)
  {
- 	struct netdev_bpf xdp;
+ 	if (flags & XDP_FLAGS_HW_MODE)
+ 		return XDP_MODE_HW;
+ 	if (flags & XDP_FLAGS_DRV_MODE)
+ 		return XDP_MODE_DRV;
+ 	return XDP_MODE_SKB;
+ }
 =20
- 	if (!bpf_op)
- 		return 0;
+ static bpf_op_t dev_xdp_bpf_op(struct net_device *dev, enum bpf_xdp_mode =
mode)
+ {
+ 	switch (mode) {
+ 	case XDP_MODE_SKB:
+ 		return generic_xdp_install;
+ 	case XDP_MODE_DRV:
+ 	case XDP_MODE_HW:
+ 		return dev->netdev_ops->ndo_bpf;
+ 	default:
+ 		return NULL;
+ 	};
+ }
 =20
- 	memset(&xdp, 0, sizeof(xdp));
- 	xdp.command =3D cmd;
+ static struct bpf_xdp_link *dev_xdp_link(struct net_device *dev,
+ 					 enum bpf_xdp_mode mode)
+ {
+ 	return dev->xdp_state[mode].link;
+ }
+=20
+ static struct bpf_prog *dev_xdp_prog(struct net_device *dev,
+ 				     enum bpf_xdp_mode mode)
+ {
+ 	struct bpf_xdp_link *link =3D dev_xdp_link(dev, mode);
+=20
+ 	if (link)
+ 		return link->link.prog;
+ 	return dev->xdp_state[mode].prog;
+ }
+=20
+ u32 dev_xdp_prog_id(struct net_device *dev, enum bpf_xdp_mode mode)
+ {
+ 	struct bpf_prog *prog =3D dev_xdp_prog(dev, mode);
 =20
- 	/* Query must always succeed. */
- 	WARN_ON(bpf_op(dev, &xdp) < 0 && cmd =3D=3D XDP_QUERY_PROG);
+ 	return prog ? prog->aux->id : 0;
+ }
 =20
- 	return xdp.prog_id;
+ static void dev_xdp_set_link(struct net_device *dev, enum bpf_xdp_mode mo=
de,
+ 			     struct bpf_xdp_link *link)
+ {
+ 	dev->xdp_state[mode].link =3D link;
+ 	dev->xdp_state[mode].prog =3D NULL;
  }
 =20
- static int dev_xdp_install(struct net_device *dev, bpf_op_t bpf_op,
- 			   struct netlink_ext_ack *extack, u32 flags,
- 			   struct bpf_prog *prog)
+ static void dev_xdp_set_prog(struct net_device *dev, enum bpf_xdp_mode mo=
de,
+ 			     struct bpf_prog *prog)
+ {
+ 	dev->xdp_state[mode].link =3D NULL;
+ 	dev->xdp_state[mode].prog =3D prog;
+ }
+=20
+ static int dev_xdp_install(struct net_device *dev, enum bpf_xdp_mode mode,
+ 			   bpf_op_t bpf_op, struct netlink_ext_ack *extack,
+ 			   u32 flags, struct bpf_prog *prog)
  {
- 	bool non_hw =3D !(flags & XDP_FLAGS_HW_MODE);
- 	struct bpf_prog *prev_prog =3D NULL;
  	struct netdev_bpf xdp;
  	int err;
 =20

--Sig_/2W0N1U4_IJj+gYzUQWfA8RM
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl8nfvYACgkQAVBC80lX
0Gz1JAgAlLGhtWva8wq9s6tJB4+eCW1XdNaXAdC7n4McmgCyb7NTsis/CpnIGzDI
iVKOLGlm1XOIxVnYrjY5W7/TTHhAibuxmWLp/IBWwvIypsBQ4Y256PJskdqn2fJM
Vpe3XXy796GJxwi5ea6gPPRhSyV0+2HlseckHnAETHRofb+dn30S5OzeSegn8CM6
7CXvhq5M0PiVSQzTGlnTUEErosLZ0O9UUjkjDa1MIqW2Jlbc+U3Z2Z++H3r0C8fG
TkgsUgD8+cyAt4eVuMp96cDMDc/2yd1JLnLzaoEUlCNImFUyR0r704WA9gyVW2mu
/zcl6sW9B59XFw/wZK5NolGDRMlx5g==
=hCy4
-----END PGP SIGNATURE-----

--Sig_/2W0N1U4_IJj+gYzUQWfA8RM--

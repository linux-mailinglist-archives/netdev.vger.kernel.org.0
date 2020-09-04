Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C27F25D285
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 09:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgIDHkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 03:40:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:42636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726089AbgIDHj4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 03:39:56 -0400
Received: from localhost (unknown [151.66.86.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C6FD20722;
        Fri,  4 Sep 2020 07:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599205195;
        bh=aNicXxD0kKm4pn3GYI6T/dj7nZz2ndDPsV16nrapy6s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Uz0iL0xqt8spw8sLI5stFzL2RMrdw0g3VpeXXcCJc2eb3UCv1MVmSFlxEOlrSk4H/
         u2ObOhBguMf0Gq2c5UPHZf6g8RN5JvtXY3q8uJBq1bNF2sqDEIj+VORxYpHLHOahBS
         JNKKCOCVgjjKKFYo3d48hb/+g6J3CoBNdQ+TZQpw=
Date:   Fri, 4 Sep 2020 09:39:50 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com,
        echaudro@redhat.com, sameehj@amazon.com, kuba@kernel.org,
        daniel@iogearbox.net, ast@kernel.org, shayagr@amazon.com
Subject: Re: [PATCH v2 net-next 0/9] mvneta: introduce XDP multi-buffer
 support
Message-ID: <20200904073950.GA2884@lore-desk>
References: <cover.1599165031.git.lorenzo@kernel.org>
 <5f51d3869b4a4_3eceb20847@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
In-Reply-To: <5f51d3869b4a4_3eceb20847@john-XPS-13-9370.notmuch>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Lorenzo Bianconi wrote:
> > - Finalize XDP multi-buffer support for mvneta driver introducing the
> >   capability to map non-linear buffers on tx side.
> > - Introduce multi-buffer bit (mb) in xdp_frame/xdp_buffer to specify if
> >   shared_info area has been properly initialized.
> > - Initialize multi-buffer bit (mb) to 0 in all XDP-capable drivers.
> > - Add multi-buff support to xdp_return_{buff/frame} utility routines.
> > - Introduce bpf_xdp_adjust_mb_header helper to adjust frame headers mov=
ing
> >   *offset* bytes from/to the second buffer to/from the first one.
> >   This helper can be used to move headers when the hw DMA SG is not able
> >   to copy all the headers in the first fragment and split header and da=
ta
> >   pages. A possible use case for bpf_xdp_adjust_mb_header is described
> >   here [0]
>=20
> Are those slides available anywhere? [0] is just a link to the abstract.

Yes, sorry. I would point out where we got the idea for this helper.
I do not think the slides are available yet but I guess they will be soon.

>=20
> > - Introduce bpf_xdp_get_frag_count and bpf_xdp_get_frags_total_size hel=
pers to
> >   report the total number/size of frags for a given xdp multi-buff.
> >=20
> > XDP multi-buffer design principles are described here [1]
> > For the moment we have not implemented any self-test for the introduced=
 the bpf
> > helpers. We can address this in a follow up series if the proposed appr=
oach
> > is accepted.
>=20
> Will need to include selftests with series.

Sure, I will add selftests in v3.

Regards,
Lorenzo

>=20
> >=20
> > Changes since v1:
> > - Fix use-after-free in xdp_return_{buff/frame}
> > - Introduce bpf helpers
> > - Introduce xdp_mb sample program
> > - access skb_shared_info->nr_frags only on the last fragment
> >=20
> > Changes since RFC:
> > - squash multi-buffer bit initialization in a single patch
> > - add mvneta non-linear XDP buff support for tx side
> >=20
> > [0] https://netdevconf.info/0x14/session.html?talk-the-path-to-tcp-4k-m=
tu-and-rx-zerocopy
> > [1] https://github.com/xdp-project/xdp-project/blob/master/areas/core/x=
dp-multi-buffer01-design.org
> >=20
> > Lorenzo Bianconi (7):
> >   xdp: introduce mb in xdp_buff/xdp_frame
> >   xdp: initialize xdp_buff mb bit to 0 in all XDP drivers
> >   net: mvneta: update mb bit before passing the xdp buffer to eBPF layer
> >   xdp: add multi-buff support to xdp_return_{buff/frame}
> >   net: mvneta: add multi buffer support to XDP_TX
> >   bpf: helpers: add bpf_xdp_adjust_mb_header helper
> >   net: mvneta: enable jumbo frames for XDP
> >=20
> > Sameeh Jubran (2):
> >   bpf: helpers: add multibuffer support
> >   samples/bpf: add bpf program that uses xdp mb helpers
> >=20
> >  drivers/net/ethernet/amazon/ena/ena_netdev.c  |   1 +
> >  drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |   1 +
> >  .../net/ethernet/cavium/thunder/nicvf_main.c  |   1 +
> >  .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |   1 +
> >  drivers/net/ethernet/intel/i40e/i40e_txrx.c   |   1 +
> >  drivers/net/ethernet/intel/ice/ice_txrx.c     |   1 +
> >  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   1 +
> >  .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |   1 +
> >  drivers/net/ethernet/marvell/mvneta.c         | 126 ++++++------
> >  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |   1 +
> >  drivers/net/ethernet/mellanox/mlx4/en_rx.c    |   1 +
> >  .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   1 +
> >  .../ethernet/netronome/nfp/nfp_net_common.c   |   1 +
> >  drivers/net/ethernet/qlogic/qede/qede_fp.c    |   1 +
> >  drivers/net/ethernet/sfc/rx.c                 |   1 +
> >  drivers/net/ethernet/socionext/netsec.c       |   1 +
> >  drivers/net/ethernet/ti/cpsw.c                |   1 +
> >  drivers/net/ethernet/ti/cpsw_new.c            |   1 +
> >  drivers/net/hyperv/netvsc_bpf.c               |   1 +
> >  drivers/net/tun.c                             |   2 +
> >  drivers/net/veth.c                            |   1 +
> >  drivers/net/virtio_net.c                      |   2 +
> >  drivers/net/xen-netfront.c                    |   1 +
> >  include/net/xdp.h                             |  26 ++-
> >  include/uapi/linux/bpf.h                      |  39 +++-
> >  net/core/dev.c                                |   1 +
> >  net/core/filter.c                             |  93 +++++++++
> >  net/core/xdp.c                                |  40 ++++
> >  samples/bpf/Makefile                          |   3 +
> >  samples/bpf/xdp_mb_kern.c                     |  68 +++++++
> >  samples/bpf/xdp_mb_user.c                     | 182 ++++++++++++++++++
> >  tools/include/uapi/linux/bpf.h                |  40 +++-
> >  32 files changed, 572 insertions(+), 70 deletions(-)
> >  create mode 100644 samples/bpf/xdp_mb_kern.c
> >  create mode 100644 samples/bpf/xdp_mb_user.c
> >=20
> > --=20
> > 2.26.2
> >=20
>=20
>=20

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX1HvRAAKCRA6cBh0uS2t
rCBFAQDpnCX7duA7K95euW9vaOgKO0zw4wkNzws0rrgGr3GDtwD8DZPaH5YyRdxp
iLH8Z9FN04JjSbKE5vTUJWIzqfqI9Qc=
=bAcp
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--

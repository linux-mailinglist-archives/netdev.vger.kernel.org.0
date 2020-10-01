Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F08F727FC2A
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 11:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731657AbgJAJEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 05:04:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:45208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725921AbgJAJEV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 05:04:21 -0400
Received: from localhost (unknown [176.207.245.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB5FE20B1F;
        Thu,  1 Oct 2020 09:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601543060;
        bh=HQjoEcOv8KwEfpAXjiY8y6TCpgLSyjHKGWFELU9g2YY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RS5MA3n8y2Nh2jiSlK3gngSrTWZ2qjjG9kwhb1JSCt+fSTnCYA6pXaq47G4mrh/6a
         js0l9WxkNOqT10sPDsO5gr78Qxtdgp3UgSecO2+xMYDMZx4+xnpYSop+k90ZRUFPo4
         WyBMqdUT2hKbaOjXLVMLbLtLFdwkDtxL145Ol7kE=
Date:   Thu, 1 Oct 2020 11:04:15 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        sameehj@amazon.com, kuba@kernel.org, daniel@iogearbox.net,
        ast@kernel.org, shayagr@amazon.com, brouer@redhat.com,
        echaudro@redhat.com, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org
Subject: Re: [PATCH v3 net-next 00/12] mvneta: introduce XDP multi-buffer
 support
Message-ID: <20201001090415.GB13449@lore-desk>
References: <cover.1601478613.git.lorenzo@kernel.org>
 <5f74e0cc804fa_364f8208d4@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="LyciRD1jyfeSSjG0"
Content-Disposition: inline
In-Reply-To: <5f74e0cc804fa_364f8208d4@john-XPS-13-9370.notmuch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--LyciRD1jyfeSSjG0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Lorenzo Bianconi wrote:
> > This series introduce XDP multi-buffer support. The mvneta driver is
> > the first to support these new "non-linear" xdp_{buff,frame}. Reviewers
> > please focus on how these new types of xdp_{buff,frame} packets
> > traverse the different layers and the layout design. It is on purpose
> > that BPF-helpers are kept simple, as we don't want to expose the
> > internal layout to allow later changes.
> >=20
> > For now, to keep the design simple and to maintain performance, the XDP
> > BPF-prog (still) only have access to the first-buffer. It is left for
> > later (another patchset) to add payload access across multiple buffers.
> > This patchset should still allow for these future extensions. The goal
> > is to lift the XDP MTU restriction that comes with XDP, but maintain
> > same performance as before.
> >=20
> > The main idea for the new multi-buffer layout is to reuse the same
> > layout used for non-linear SKB. This rely on the "skb_shared_info"
> > struct at the end of the first buffer to link together subsequent
> > buffers. Keeping the layout compatible with SKBs is also done to ease
> > and speedup creating an SKB from an xdp_{buff,frame}. Converting
> > xdp_frame to SKB and deliver it to the network stack is shown in cpumap
> > code (patch 12/12).
>=20
> Couple questions I think we want in the cover letter. How I read above
> is if mb is enabled every frame received at the end of the first buffer
> there will be skb_shared_info field.

setting mb bit the driver notifies the current xdp_frame is a "non-linear"
one and the skb_shared_info is properly populated. As you said below,
the info is per-frame, so we can receive linear frames (mb =3D 0) and
non-linear ones (mb =3D 1). For a linear frame we do not need to access
the skb_shared_info, so we will not introduce any penalty.

>=20
> First just to be clear a driver may have mb support but the mb bit
> should only be used per frame so a frame with only a single buffer
> will not have any extra cost even when driver/network layer support
> mb. This way I can receive both multibuffer and single buffer frames
> in the same stack without extra overhead on single buffer frames. I
> think we want to put the details here in the cover letter so we don't
> have to read mvneta driver to learn these details. I'll admit we've
> sort of flung features like this with minimal descriptions in the
> past, but this is important so lets get it described here.

ack, I will add the info above in cover letter. Thanks for pointing this ou=
t.

>=20
> Or put the details in the patch commits those are pretty terse for
> a new feature that has impacts for all xdp driver writers.
> >=20
> > In order to provide to userspace some metdata about the non-linear
> > xdp_{buff,frame}, we introduced 2 bpf helpers:
> > - bpf_xdp_get_frag_count:
> >   get the number of fragments for a given xdp multi-buffer.
> > - bpf_xdp_get_frags_total_size:
> >   get the total size of fragments for a given xdp multi-buffer.
> >=20
> > Typical use cases for this series are:
> > - Jumbo-frames
> > - Packet header split (please see Google=EF=BF=BD=EF=BF=BD=EF=BF=BDs us=
e-case @ NetDevConf 0x14, [0])
> > - TSO
> >=20
> > More info about the main idea behind this approach can be found here [1=
][2].
> >=20
> > We carried out some throughput tests in order to verify we did not intr=
oduced
> > any performance regression adding xdp multi-buff support to mvneta:
> >=20
> > offered load is ~ 1000Kpps, packet size is 64B
> >=20
> > commit: 879456bedbe5 ("net: mvneta: avoid possible cache misses in mvne=
ta_rx_swbm")
> > - xdp-pass:     ~162Kpps
> > - xdp-drop:     ~701Kpps
> > - xdp-tx:       ~185Kpps
> > - xdp-redirect: ~202Kpps
> >=20
> > mvneta xdp multi-buff:
> > - xdp-pass:     ~163Kpps
> > - xdp-drop:     ~739Kpps
> > - xdp-tx:       ~182Kpps
> > - xdp-redirect: ~202Kpps
>=20
> But these are fairly low rates?  Also why can't we push line rate
> here on xdp-tx and xdp-redirect, 1gbps should be no problem unless
> we have a very small core or something? Finally, can you explain

I am using a marvell EspressoBin to develop this feature.
The Espressobin runs a cortex a53 and it is not able to push line rate.
The tests above want to prove there is no penalty introducing xdp multi-buff
for linear case (I will point out clearly in the next cover-letter,
the tests above refer to linear case (mb =3D 0))

> why the huge hit between xdp-drop and xdp-tx?

not sure at the moment, the difference is not due to xdp multi-buff

>=20
> I'm a bit wary of touching the end of a buffer on 40/100Gbps nic
> with DDIO and getting a cache miss. Do you have some argument why
> this wouldn't be the case? Do we need someone to step up with a
> 10/40/100gbps nic and implement the feature as well so we can verify
> this?

It would be interesting to have the implementation on a high-end device.
IIRC intel folks are working on it for AF_XDP.

Regards,
Lorenzo

>=20
> >=20
> > This series is based on "bpf: cpumap: remove rcpu pointer from cpu_map_=
build_skb signature"
> > https://patchwork.ozlabs.org/project/netdev/patch/33cb9b7dc447de3ea6fd6=
ce713ac41bca8794423.1601292015.git.lorenzo@kernel.org/
> >=20
> > Changes since v2:
> > - add throughput measurements
> > - drop bpf_xdp_adjust_mb_header bpf helper
> > - introduce selftest for xdp multibuffer
> > - addressed comments on bpf_xdp_get_frag_count
> > - introduce xdp multi-buff support to cpumaps
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
> > [0] https://netdevconf.info/0x14/pub/slides/62/Implementing%20TCP%20RX%=
20zero%20copy.pdf
> > [1] https://github.com/xdp-project/xdp-project/blob/master/areas/core/x=
dp-multi-buffer01-design.org
> > [2] https://netdevconf.info/0x14/pub/slides/10/add-xdp-on-driver.pdf (X=
DPmulti-buffers section)
> >=20
> > Lorenzo Bianconi (10):
> >   xdp: introduce mb in xdp_buff/xdp_frame
> >   xdp: initialize xdp_buff mb bit to 0 in all XDP drivers
> >   net: mvneta: update mb bit before passing the xdp buffer to eBPF layer
> >   xdp: add multi-buff support to xdp_return_{buff/frame}
> >   net: mvneta: add multi buffer support to XDP_TX
> >   bpf: move user_size out of bpf_test_init
> >   bpf: introduce multibuff support to bpf_prog_test_run_xdp()
> >   bpf: add xdp multi-buffer selftest
> >   net: mvneta: enable jumbo frames for XDP
> >   bpf: cpumap: introduce xdp multi-buff support
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
> >  drivers/net/ethernet/marvell/mvneta.c         | 131 +++++++------
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
> >  include/net/xdp.h                             |  31 ++-
> >  include/uapi/linux/bpf.h                      |  14 ++
> >  kernel/bpf/cpumap.c                           |  45 +----
> >  net/bpf/test_run.c                            |  45 ++++-
> >  net/core/dev.c                                |   1 +
> >  net/core/filter.c                             |  42 ++++
> >  net/core/xdp.c                                | 104 ++++++++++
> >  samples/bpf/Makefile                          |   3 +
> >  samples/bpf/xdp_mb_kern.c                     |  68 +++++++
> >  samples/bpf/xdp_mb_user.c                     | 182 ++++++++++++++++++
> >  tools/include/uapi/linux/bpf.h                |  14 ++
> >  .../testing/selftests/bpf/prog_tests/xdp_mb.c |  77 ++++++++
> >  .../selftests/bpf/progs/test_xdp_multi_buff.c |  24 +++
> >  36 files changed, 691 insertions(+), 114 deletions(-)
> >  create mode 100644 samples/bpf/xdp_mb_kern.c
> >  create mode 100644 samples/bpf/xdp_mb_user.c
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_mb.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_multi_bu=
ff.c
> >=20
> > --=20
> > 2.26.2
> >=20
>=20
>=20

--LyciRD1jyfeSSjG0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX3WbjQAKCRA6cBh0uS2t
rCARAQCZAsQr+KSYL2L7r2JKPLxJp7mE+tJ+wCn8UOhe2m2fhQD/QLBZlVfnnPU8
mPh59FdoES7vq+6sd4LQp/qhx2qClwk=
=lNg1
-----END PGP SIGNATURE-----

--LyciRD1jyfeSSjG0--

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A01133DDB47
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 16:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233981AbhHBOmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 10:42:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:46782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233925AbhHBOmj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 10:42:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B8DB60E97;
        Mon,  2 Aug 2021 14:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627915350;
        bh=gAYTIfd4urGs1EQECbVjMA8ICTd0p4bEa4uUj+Ds7wo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZyWj6vsZBQ39MVGvVZolCLEIq7H4HYfWxAecSeCAKE7GYaEWURTKx7w9UrNhQOJGh
         5BgsPnayMejLkKuHa/kLqempM0b9mGSunTBKrOiYLvYIc1HttczqwhONsID3HrSxXS
         a8LmB1mv7o84MMoV3rbk+kFkkW/tueBNDeKgCuBtWbl/3nMykvOMhXkBpU0K+cnD4C
         3FG+1BIDAHqMyd8bwrr8tx6+jWl4Yhf3OrdRHk843r11stCqu1gsi8cdd2zqW20amy
         +RoZYS9SNB563zTB2U8UDcP+J8uIqwDfBqC5ny/PM1vjVd9BInSWBPl5+I3SPY3ctL
         qr9Ru8tBnbV0g==
Date:   Mon, 2 Aug 2021 16:42:25 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Lorenzo Bianconi <me@lorenzobianconi.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Shay Agroskin <shayagr@amazon.com>,
        john fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        tirthendu.sarkar@intel.com,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH v10 bpf-next 00/18] mvneta: introduce XDP multi-buffer
 support
Message-ID: <YQgEUX5JQ5UGep55@lore-desk>
References: <cover.1627463617.git.lorenzo@kernel.org>
 <YQEnsALmUCp2w/fL@lore-desk>
 <CAEf4BzYpOxegBwBWAfhn-2eq6DXkph7LiiCNN=HmgqN3ng6hAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1hkC3QtxpgKrHRIQ"
Content-Disposition: inline
In-Reply-To: <CAEf4BzYpOxegBwBWAfhn-2eq6DXkph7LiiCNN=HmgqN3ng6hAg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--1hkC3QtxpgKrHRIQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[...]
> > > bpf_xdp_adjust_tail and bpf_xdp_copy helpers have been modified to ta=
ke into
> > > account xdp multi-buff frames.
> > >
>=20
> Seems like your changes are breaking selftests in no-alu32 mode ([0]).
> Please take a look.
>=20
>   [0] https://github.com/kernel-patches/bpf/runs/3197530080?check_suite_f=
ocus=3Dtrue

Hi Andrii,

for no-alu32 mode, it seems the verifiers is complaining when the program is
trying to access the packet payload using the updated value for offset:

if (data[offset] !=3D 0xaa) /* marker *
 ...

as double check, if I use the proper constant value for
offset (1480 =3D 5000 (original offset) - 3520 (buff0 length))
the test if fine. I need to understand the root cause of the issue.

Regards,
Lorenzo

>=20
> > > More info about the main idea behind this approach can be found here =
[1][2].
> > >
> > > Changes since v9:
> > > - introduce bpf_xdp_adjust_data helper and related selftest
> > > - add xdp_frags_size and xdp_frags_tsize fields in skb_shared_info
> > > - introduce xdp_update_skb_shared_info utility routine in ordere to n=
ot reset
> > >   frags array in skb_shared_info converting from a xdp_buff/xdp_frame=
 to a skb
> > > - simplify bpf_xdp_copy routine
> > >
> > > Changes since v8:
> > > - add proper dma unmapping if XDP_TX fails on mvneta for a xdp multi-=
buff
> > > - switch back to skb_shared_info implementation from previous xdp_sha=
red_info
> > >   one
> > > - avoid using a bietfield in xdp_buff/xdp_frame since it introduces p=
erformance
> > >   regressions. Tested now on 10G NIC (ixgbe) to verify there are no p=
erformance
> > >   penalties for regular codebase
> > > - add bpf_xdp_get_buff_len helper and remove frame_length field in xd=
p ctx
> > > - add data_len field in skb_shared_info struct
> > > - introduce XDP_FLAGS_FRAGS_PF_MEMALLOC flag
> > >
> > > Changes since v7:
> > > - rebase on top of bpf-next
> > > - fix sparse warnings
> > > - improve comments for frame_length in include/net/xdp.h
> > >
> > > Changes since v6:
> > > - the main difference respect to previous versions is the new approac=
h proposed
> > >   by Eelco to pass full length of the packet to eBPF layer in XDP con=
text
> > > - reintroduce multi-buff support to eBPF kself-tests
> > > - reintroduce multi-buff support to bpf_xdp_adjust_tail helper
> > > - introduce multi-buffer support to bpf_xdp_copy helper
> > > - rebase on top of bpf-next
> > >
> > > Changes since v5:
> > > - rebase on top of bpf-next
> > > - initialize mb bit in xdp_init_buff() and drop per-driver initializa=
tion
> > > - drop xdp->mb initialization in xdp_convert_zc_to_xdp_frame()
> > > - postpone introduction of frame_length field in XDP ctx to another s=
eries
> > > - minor changes
> > >
> > > Changes since v4:
> > > - rebase ontop of bpf-next
> > > - introduce xdp_shared_info to build xdp multi-buff instead of using =
the
> > >   skb_shared_info struct
> > > - introduce frame_length in xdp ctx
> > > - drop previous bpf helpers
> > > - fix bpf_xdp_adjust_tail for xdp multi-buff
> > > - introduce xdp multi-buff self-tests for bpf_xdp_adjust_tail
> > > - fix xdp_return_frame_bulk for xdp multi-buff
> > >
> > > Changes since v3:
> > > - rebase ontop of bpf-next
> > > - add patch 10/13 to copy back paged data from a xdp multi-buff frame=
 to
> > >   userspace buffer for xdp multi-buff selftests
> > >
> > > Changes since v2:
> > > - add throughput measurements
> > > - drop bpf_xdp_adjust_mb_header bpf helper
> > > - introduce selftest for xdp multibuffer
> > > - addressed comments on bpf_xdp_get_frags_count
> > > - introduce xdp multi-buff support to cpumaps
> > >
> > > Changes since v1:
> > > - Fix use-after-free in xdp_return_{buff/frame}
> > > - Introduce bpf helpers
> > > - Introduce xdp_mb sample program
> > > - access skb_shared_info->nr_frags only on the last fragment
> > >
> > > Changes since RFC:
> > > - squash multi-buffer bit initialization in a single patch
> > > - add mvneta non-linear XDP buff support for tx side
> > >
> > > [0] https://netdevconf.info/0x14/session.html?talk-the-path-to-tcp-4k=
-mtu-and-rx-zerocopy
> > > [1] https://github.com/xdp-project/xdp-project/blob/master/areas/core=
/xdp-multi-buffer01-design.org
> > > [2] https://netdevconf.info/0x14/session.html?tutorial-add-XDP-suppor=
t-to-a-NIC-driver (XDPmulti-buffers section)
> > >
> > > Eelco Chaudron (3):
> > >   bpf: add multi-buff support to the bpf_xdp_adjust_tail() API
> > >   bpf: add multi-buffer support to xdp copy helpers
> > >   bpf: update xdp_adjust_tail selftest to include multi-buffer
> > >
> > > Lorenzo Bianconi (15):
> > >   net: skbuff: add size metadata to skb_shared_info for xdp
> > >   xdp: introduce flags field in xdp_buff/xdp_frame
> > >   net: mvneta: update mb bit before passing the xdp buffer to eBPF la=
yer
> > >   net: mvneta: simplify mvneta_swbm_add_rx_fragment management
> > >   net: xdp: add xdp_update_skb_shared_info utility routine
> > >   net: marvell: rely on xdp_update_skb_shared_info utility routine
> > >   xdp: add multi-buff support to xdp_return_{buff/frame}
> > >   net: mvneta: add multi buffer support to XDP_TX
> > >   net: mvneta: enable jumbo frames for XDP
> > >   bpf: introduce bpf_xdp_get_buff_len helper
> > >   bpf: move user_size out of bpf_test_init
> > >   bpf: introduce multibuff support to bpf_prog_test_run_xdp()
> > >   bpf: test_run: add xdp_shared_info pointer in bpf_test_finish
> > >     signature
> > >   net: xdp: introduce bpf_xdp_adjust_data helper
> > >   bpf: add bpf_xdp_adjust_data selftest
> > >
> > >  drivers/net/ethernet/marvell/mvneta.c         | 213 ++++++++++------=
--
> > >  include/linux/skbuff.h                        |   6 +-
> > >  include/net/xdp.h                             |  95 +++++++-
> > >  include/uapi/linux/bpf.h                      |  38 ++++
> > >  kernel/trace/bpf_trace.c                      |   3 +
> > >  net/bpf/test_run.c                            | 117 ++++++++--
> > >  net/core/filter.c                             | 210 ++++++++++++++++-
> > >  net/core/xdp.c                                |  76 ++++++-
> > >  tools/include/uapi/linux/bpf.h                |  38 ++++
> > >  .../bpf/prog_tests/xdp_adjust_data.c          |  55 +++++
> > >  .../bpf/prog_tests/xdp_adjust_tail.c          | 118 ++++++++++
> > >  .../selftests/bpf/prog_tests/xdp_bpf2bpf.c    | 151 +++++++++----
> > >  .../bpf/progs/test_xdp_adjust_tail_grow.c     |  10 +-
> > >  .../bpf/progs/test_xdp_adjust_tail_shrink.c   |  32 ++-
> > >  .../selftests/bpf/progs/test_xdp_bpf2bpf.c    |   2 +-
> > >  .../bpf/progs/test_xdp_update_frags.c         |  49 ++++
> > >  16 files changed, 1044 insertions(+), 169 deletions(-)
> > >  create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_adjust=
_data.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_update=
_frags.c
> > >
> > > --
> > > 2.31.1
> > >

--1hkC3QtxpgKrHRIQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYQgETwAKCRA6cBh0uS2t
rAuJAP9VEMn5mgXiLD4ZhXPX3zky7TJEb3k9ooT867x/Ai2bgAD/bEx8At0pRtO9
bwXnlUpUqZczOEn9nKUyRxFK3qBJEAQ=
=7Yvz
-----END PGP SIGNATURE-----

--1hkC3QtxpgKrHRIQ--

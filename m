Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9187E495D50
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 11:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349778AbiAUKKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 05:10:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238237AbiAUKKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 05:10:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3CFC061574;
        Fri, 21 Jan 2022 02:10:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C57B5B81ED8;
        Fri, 21 Jan 2022 10:10:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D9BCC340E1;
        Fri, 21 Jan 2022 10:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642759835;
        bh=Zr/AMjKO7kDAFqpkZiOZNgJKLINZsLfM8U2xGEIjz1A=;
        h=From:To:Cc:Subject:Date:From;
        b=RkrHVtPbU8sjjxje6OHkA3lcRjj4Jyr9GpwzYv6ZNEA/OSdsgyzZQBpL4E+OQYReo
         ncKAQoaDfAlYGq6HvyTbypFOJlHgZA8p0YEBZtgnL80frjGIvfyOqJ9R0ClPUpEVJv
         KLDyXv01YZSZfTg8jv7OQPeOWgjduPt18H9iOSzerYlzTOKyv0EeiB2/Qz2hw67bbl
         kZzLADTGq9+qnTaAcmAKt7Ddsdg8emhcbr4j+IDNklVJzJHenoEAU15hbWuu3QFJe1
         shz1FtxeYN9O/lLJP2d63uf0O6QgmVEjIxOrkJJlHjFkaaCxZ99f5/8BSqBFk6vLc9
         I1BSVM/t6uXWw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com,
        andrii.nakryiko@gmail.com
Subject: [PATCH v23 bpf-next 00/23] mvneta: introduce XDP multi-buffer support
Date:   Fri, 21 Jan 2022 11:09:43 +0100
Message-Id: <cover.1642758637.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series introduces XDP frags support. The mvneta driver is
the first to support these new "non-linear" xdp_{buff,frame}. Reviewers
please focus on how these new types of xdp_{buff,frame} packets
traverse the different layers and the layout design. It is on purpose
that BPF-helpers are kept simple, as we don't want to expose the
internal layout to allow later changes.

The main idea for the new XDP frags layout is to reuse the same
structure used for non-linear SKB. This rely on the "skb_shared_info"
struct at the end of the first buffer to link together subsequent
buffers. Keeping the layout compatible with SKBs is also done to ease
and speedup creating a SKB from an xdp_{buff,frame}.
Converting xdp_frame to SKB and deliver it to the network stack is shown
in patch 05/18 (e.g. cpumaps).

A frags bit (XDP_FLAGS_HAS_FRAGS) has been introduced in the flags
field of xdp_{buff,frame} structure to notify the bpf/network layer if
this is a non-linear xdp frame (XDP_FLAGS_HAS_FRAGS set) or not
(XDP_FLAGS_HAS_FRAGS not set).
The frags bit will be set by a xdp frags capable driver only
for non-linear frames maintaining the capability to receive linear frames
without any extra cost since the skb_shared_info structure at the end
of the first buffer will be initialized only if XDP_FLAGS_HAS_FRAGS bit
is set. Moreover the flags field in xdp_{buff,frame} will be reused even for
xdp rx csum offloading in future series.

Typical use cases for this series are:
- Jumbo-frames
- Packet header split (please see Google’s use-case @ NetDevConf 0x14, [0])
- TSO/GRO for XDP_REDIRECT

The three following ebpf helpers (and related selftests) has been introduced:
- bpf_xdp_load_bytes:
  This helper is provided as an easy way to load data from a xdp buffer. It
  can be used to load len bytes from offset from the frame associated to
  xdp_md, into the buffer pointed by buf.
- bpf_xdp_store_bytes:
  Store len bytes from buffer buf into the frame associated to xdp_md, at
  offset.
- bpf_xdp_get_buff_len:
  Return the total frame size (linear + paged parts)

bpf_xdp_adjust_tail and bpf_xdp_copy helpers have been modified to take into
account non-linear xdp frames.
Moreover, similar to skb_header_pointer, we introduced bpf_xdp_pointer utility
routine to return a pointer to a given position in the xdp_buff if the
requested area (offset + len) is contained in a contiguous memory area
otherwise it must be copied in a bounce buffer provided by the caller running
bpf_xdp_copy_buf().

BPF_F_XDP_HAS_FRAGS flag has been introduced to notify the kernel the
eBPF program fully support xdp frags.
SEC("xdp.frags"), SEC_DEF("xdp.frags/devmap") and SEC_DEF("xdp.frags/cpumap")
have been introduced to declare xdp frags support.
The NIC driver is expected to reject an eBPF program if it is running in
XDP frags mode and the program does not support XDP frags.
In the same way it is not possible to mix XDP frags and XDP legacy
programs in a CPUMAP/DEVMAP or tailcall a XDP frags/legacy program from
a legacy/frags one.

More info about the main idea behind this approach can be found here [1][2].

Changes since v22:
- remove leftover CHECK macro usage
- reintroduce SEC_XDP_FRAGS flag in sec_def_flags
- rename xdp multi_frags in xdp frags
- do not report xdp_frags support in fdinfo

Changes since v21:
- rename *_mb in *_frags: e.g:
  s/xdp_buff_is_mb/xdp_buff_has_frags
- rely on ASSERT_* and not on CHECK in
  bpf_xdp_load_bytes/bpf_xdp_store_bytes self-tests
- change new multi.frags SEC definitions to use the following schema:
  prog_type.prog_flags/attach_place
- get rid of unnecessary properties in new multi.frags SEC definitions
- rebase on top of bpf-next

Changes since v20:
- rebase to current bpf-next

Changes since v19:
- do not run deprecated bpf_prog_load()
- rely on skb_frag_size_add/skb_frag_size_sub in
  bpf_xdp_mb_increase_tail/bpf_xdp_mb_shrink_tail
- rely on sinfo->nr_frags in bpf_xdp_mb_shrink_tail to check if the frame has
  been shrunk to a single-buffer one
- allow XDP_REDIRECT of a xdp-mb frame into a CPUMAP

Changes since v18:
- fix bpf_xdp_copy_buf utility routine when we want to load/store data
  contained in frag<n>
- add a selftest for bpf_xdp_load_bytes/bpf_xdp_store_bytes when the caller
  accesses data contained in frag<n> and frag<n+1>

Changes since v17:
- rework bpf_xdp_copy to squash base and frag management
- remove unused variable in bpf_xdp_mb_shrink_tail()
- move bpf_xdp_copy_buf() out of bpf_xdp_pointer()
- add sanity check for len in bpf_xdp_pointer()
- remove EXPORT_SYMBOL for __xdp_return()
- introduce frag_size field in xdp_rxq_info to let the driver specify max value
  for xdp fragments. frag_size set to 0 means the tail increase of last the
  fragment is not supported.

Changes since v16:
- do not allow tailcalling a xdp multi-buffer/legacy program from a
  legacy/multi-buff one.
- do not allow mixing xdp multi-buffer and xdp legacy programs in a
  CPUMAP/DEVMAP
- add selftests for CPUMAP/DEVMAP xdp mb compatibility
- disable XDP_REDIRECT for xdp multi-buff for the moment
- set max offset value to 0xffff in bpf_xdp_pointer
- use ARG_PTR_TO_UNINIT_MEM and ARG_CONST_SIZE for arg3_type and arg4_type
  of bpf_xdp_store_bytes/bpf_xdp_load_bytes

Changes since v15:
- let the verifier check buf is not NULL in
  bpf_xdp_load_bytes/bpf_xdp_store_bytes helpers
- return an error if offset + length is over frame boundaries in
  bpf_xdp_pointer routine
- introduce BPF_F_XDP_MB flag for bpf_attr to notify the kernel the eBPF
  program fully supports xdp multi-buffer.
- reject a non XDP multi-buffer program if the driver is running in
  XDP multi-buffer mode.

Changes since v14:
- intrudce bpf_xdp_pointer utility routine and
  bpf_xdp_load_bytes/bpf_xdp_store_bytes helpers
- drop bpf_xdp_adjust_data helper
- drop xdp_frags_truesize in skb_shared_info
- explode bpf_xdp_mb_adjust_tail in bpf_xdp_mb_increase_tail and
  bpf_xdp_mb_shrink_tail

Changes since v13:
- use u32 for xdp_buff/xdp_frame flags field
- rename xdp_frags_tsize in xdp_frags_truesize
- fixed comments

Changes since v12:
- fix bpf_xdp_adjust_data helper for single-buffer use case
- return -EFAULT in bpf_xdp_adjust_{head,tail} in case the data pointers are not
  properly reset
- collect ACKs from John

Changes since v11:
- add missing static to bpf_xdp_get_buff_len_proto structure
- fix bpf_xdp_adjust_data helper when offset is smaller than linear area length.

Changes since v10:
- move xdp->data to the requested payload offset instead of to the beginning of
  the fragment in bpf_xdp_adjust_data()

Changes since v9:
- introduce bpf_xdp_adjust_data helper and related selftest
- add xdp_frags_size and xdp_frags_tsize fields in skb_shared_info
- introduce xdp_update_skb_shared_info utility routine in ordere to not reset
  frags array in skb_shared_info converting from a xdp_buff/xdp_frame to a skb 
- simplify bpf_xdp_copy routine

Changes since v8:
- add proper dma unmapping if XDP_TX fails on mvneta for a xdp multi-buff
- switch back to skb_shared_info implementation from previous xdp_shared_info
  one
- avoid using a bietfield in xdp_buff/xdp_frame since it introduces performance
  regressions. Tested now on 10G NIC (ixgbe) to verify there are no performance
  penalties for regular codebase
- add bpf_xdp_get_buff_len helper and remove frame_length field in xdp ctx
- add data_len field in skb_shared_info struct
- introduce XDP_FLAGS_FRAGS_PF_MEMALLOC flag

Changes since v7:
- rebase on top of bpf-next
- fix sparse warnings
- improve comments for frame_length in include/net/xdp.h

Changes since v6:
- the main difference respect to previous versions is the new approach proposed
  by Eelco to pass full length of the packet to eBPF layer in XDP context
- reintroduce multi-buff support to eBPF kself-tests
- reintroduce multi-buff support to bpf_xdp_adjust_tail helper
- introduce multi-buffer support to bpf_xdp_copy helper
- rebase on top of bpf-next

Changes since v5:
- rebase on top of bpf-next
- initialize mb bit in xdp_init_buff() and drop per-driver initialization
- drop xdp->mb initialization in xdp_convert_zc_to_xdp_frame()
- postpone introduction of frame_length field in XDP ctx to another series
- minor changes

Changes since v4:
- rebase ontop of bpf-next
- introduce xdp_shared_info to build xdp multi-buff instead of using the
  skb_shared_info struct
- introduce frame_length in xdp ctx
- drop previous bpf helpers
- fix bpf_xdp_adjust_tail for xdp multi-buff
- introduce xdp multi-buff self-tests for bpf_xdp_adjust_tail
- fix xdp_return_frame_bulk for xdp multi-buff

Changes since v3:
- rebase ontop of bpf-next
- add patch 10/13 to copy back paged data from a xdp multi-buff frame to
  userspace buffer for xdp multi-buff selftests

Changes since v2:
- add throughput measurements
- drop bpf_xdp_adjust_mb_header bpf helper
- introduce selftest for xdp multibuffer
- addressed comments on bpf_xdp_get_frags_count
- introduce xdp multi-buff support to cpumaps

Changes since v1:
- Fix use-after-free in xdp_return_{buff/frame}
- Introduce bpf helpers
- Introduce xdp_mb sample program
- access skb_shared_info->nr_frags only on the last fragment

Changes since RFC:
- squash multi-buffer bit initialization in a single patch
- add mvneta non-linear XDP buff support for tx side

[0] https://netdevconf.info/0x14/session.html?talk-the-path-to-tcp-4k-mtu-and-rx-zerocopy
[1] https://github.com/xdp-project/xdp-project/blob/master/areas/core/xdp-multi-buffer01-design.org
[2] https://netdevconf.info/0x14/session.html?tutorial-add-XDP-support-to-a-NIC-driver (XDPmulti-buffers section)

Eelco Chaudron (3):
  bpf: add frags support to the bpf_xdp_adjust_tail() API
  bpf: add frags support to xdp copy helpers
  bpf: selftests: update xdp_adjust_tail selftest to include xdp frags

Lorenzo Bianconi (19):
  net: skbuff: add size metadata to skb_shared_info for xdp
  xdp: introduce flags field in xdp_buff/xdp_frame
  net: mvneta: update frags bit before passing the xdp buffer to eBPF
    layer
  net: mvneta: simplify mvneta_swbm_add_rx_fragment management
  net: xdp: add xdp_update_skb_shared_info utility routine
  net: marvell: rely on xdp_update_skb_shared_info utility routine
  xdp: add frags support to xdp_return_{buff/frame}
  net: mvneta: add frags support to XDP_TX
  bpf: introduce BPF_F_XDP_HAS_FRAGS flag in prog_flags loading the ebpf
    program
  net: mvneta: enable jumbo frames if the loaded XDP program support
    frags
  bpf: introduce bpf_xdp_get_buff_len helper
  bpf: move user_size out of bpf_test_init
  bpf: introduce frags support to bpf_prog_test_run_xdp()
  bpf: test_run: add xdp_shared_info pointer in bpf_test_finish
    signature
  libbpf: Add SEC name for xdp frags programs
  net: xdp: introduce bpf_xdp_pointer utility routine
  bpf: selftests: introduce bpf_xdp_{load,store}_bytes selftest
  bpf: selftests: add CPUMAP/DEVMAP selftests for xdp frags
  xdp: disable XDP_REDIRECT for xdp frags

Toke Hoiland-Jorgensen (1):
  bpf: generalise tail call map compatibility check

 drivers/net/ethernet/marvell/mvneta.c         | 204 +++++++++------
 include/linux/bpf.h                           |  31 ++-
 include/linux/skbuff.h                        |   1 +
 include/net/xdp.h                             | 108 +++++++-
 include/uapi/linux/bpf.h                      |  30 +++
 kernel/bpf/arraymap.c                         |   4 +-
 kernel/bpf/core.c                             |  28 +-
 kernel/bpf/cpumap.c                           |   8 +-
 kernel/bpf/devmap.c                           |   3 +-
 kernel/bpf/syscall.c                          |  19 +-
 kernel/trace/bpf_trace.c                      |   3 +
 net/bpf/test_run.c                            | 115 ++++++--
 net/core/filter.c                             | 245 +++++++++++++++++-
 net/core/xdp.c                                |  78 +++++-
 tools/include/uapi/linux/bpf.h                |  30 +++
 tools/lib/bpf/libbpf.c                        |   8 +
 .../bpf/prog_tests/xdp_adjust_frags.c         | 104 ++++++++
 .../bpf/prog_tests/xdp_adjust_tail.c          | 125 +++++++++
 .../selftests/bpf/prog_tests/xdp_bpf2bpf.c    | 111 +++++---
 .../bpf/prog_tests/xdp_cpumap_attach.c        |  64 ++++-
 .../bpf/prog_tests/xdp_devmap_attach.c        |  55 ++++
 .../bpf/progs/test_xdp_adjust_tail_grow.c     |  10 +-
 .../bpf/progs/test_xdp_adjust_tail_shrink.c   |  32 ++-
 .../selftests/bpf/progs/test_xdp_bpf2bpf.c    |   2 +-
 .../bpf/progs/test_xdp_update_frags.c         |  42 +++
 .../test_xdp_with_cpumap_frags_helpers.c      |  27 ++
 .../bpf/progs/test_xdp_with_cpumap_helpers.c  |   6 +
 .../test_xdp_with_devmap_frags_helpers.c      |  27 ++
 .../bpf/progs/test_xdp_with_devmap_helpers.c  |   7 +
 29 files changed, 1326 insertions(+), 201 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_update_frags.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_with_cpumap_frags_helpers.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_with_devmap_frags_helpers.c

-- 
2.34.1


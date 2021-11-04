Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF9A445889
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 18:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbhKDRil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 13:38:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231667AbhKDRii (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 13:38:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8ECF361186;
        Thu,  4 Nov 2021 17:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636047359;
        bh=y1BLKL+C/Bdm8D69oL83O981oAUYNhr+9XDO+A+B6vY=;
        h=From:To:Cc:Subject:Date:From;
        b=hVFXyRME1pzy9QN2+SVvKKpOXIT4hGIsDAtwAe62eA+sBm7g8ni2DVLt9ky79+XD4
         QzR9BexuxMSIamtyT4eesxELgki00IfnJo0LlfWS6xhwLd9ehg58afTnlIP7QFpV1G
         Aha51LWdvl8vWUd/+b3m9VkxzsitEOZX1cueP1EA4WWvsG+gFHFUDtn+BcvE9Dv6Qw
         zVqW//MCV0vFOYx3zR2NdrLT4fe977t3d37/6QL+VBikF0FAnpeAA0bAd7Kmz4OmNU
         /Exk/HOMX2M/LnY+376EYYf+ZbiENetCUlYQ8VcoIAA1Owdtg51WhKSwHKL9UgBBC9
         zHGdoJSFDtTNA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: [PATCH v17 bpf-next 00/23] mvneta: introduce XDP multi-buffer support
Date:   Thu,  4 Nov 2021 18:35:20 +0100
Message-Id: <cover.1636044387.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series introduce XDP multi-buffer support. The mvneta driver is
the first to support these new "non-linear" xdp_{buff,frame}. Reviewers
please focus on how these new types of xdp_{buff,frame} packets
traverse the different layers and the layout design. It is on purpose
that BPF-helpers are kept simple, as we don't want to expose the
internal layout to allow later changes.

The main idea for the new multi-buffer layout is to reuse the same
structure used for non-linear SKB. This rely on the "skb_shared_info"
struct at the end of the first buffer to link together subsequent
buffers. Keeping the layout compatible with SKBs is also done to ease
and speedup creating a SKB from an xdp_{buff,frame}.
Converting xdp_frame to SKB and deliver it to the network stack is shown
in patch 05/18 (e.g. cpumaps).

A multi-buffer bit (mb) has been introduced in the flags field of xdp_{buff,frame}
structure to notify the bpf/network layer if this is a xdp multi-buffer frame
(mb = 1) or not (mb = 0).
The mb bit will be set by a xdp multi-buffer capable driver only for
non-linear frames maintaining the capability to receive linear frames
without any extra cost since the skb_shared_info structure at the end
of the first buffer will be initialized only if mb is set.
Moreover the flags field in xdp_{buff,frame} will be reused even for
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
account xdp multi-buff frames.
Moreover, similar to skb_header_pointer, we introduced bpf_xdp_pointer utility
routine to return a pointer to a given position in the xdp_buff if the
requested area (offset + len) is contained in a contiguous memory area
otherwise it will be copied in a bounce buffer provided by the caller.

BPF_F_XDP_MB flag for bpf_attr has been introduced to notify the kernel the
eBPF program fully support xdp multi-buffer.
SEC("xdp_mb/"), SEC_DEF("xdp_devmap_mb/") and SEC_DEF("xdp_cpumap_mb/" have been
introduced to declare xdp multi-buffer support.
The NIC driver is expected to reject an eBPF program if it is running in XDP
multi-buffer mode and the program does not support XDP multi-buffer.
In the same way it is not possible to mix xdp multi-buffer and xdp legacy
programs in a CPUMAP/DEVMAP or tailcall a xdp multi-buffer/legacy program from
a legacy/multi-buff one.

More info about the main idea behind this approach can be found here [1][2].

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
  bpf: add multi-buff support to the bpf_xdp_adjust_tail() API
  bpf: add multi-buffer support to xdp copy helpers
  bpf: selftests: update xdp_adjust_tail selftest to include
    multi-buffer

Lorenzo Bianconi (19):
  net: skbuff: add size metadata to skb_shared_info for xdp
  xdp: introduce flags field in xdp_buff/xdp_frame
  net: mvneta: update mb bit before passing the xdp buffer to eBPF layer
  net: mvneta: simplify mvneta_swbm_add_rx_fragment management
  net: xdp: add xdp_update_skb_shared_info utility routine
  net: marvell: rely on xdp_update_skb_shared_info utility routine
  xdp: add multi-buff support to xdp_return_{buff/frame}
  net: mvneta: add multi buffer support to XDP_TX
  bpf: introduce BPF_F_XDP_MB flag in prog_flags loading the ebpf
    program
  net: mvneta: enable jumbo frames if the loaded XDP program support mb
  bpf: introduce bpf_xdp_get_buff_len helper
  bpf: move user_size out of bpf_test_init
  bpf: introduce multibuff support to bpf_prog_test_run_xdp()
  bpf: test_run: add xdp_shared_info pointer in bpf_test_finish
    signature
  libbpf: Add SEC name for xdp_mb programs
  net: xdp: introduce bpf_xdp_pointer utility routine
  bpf: selftests: introduce bpf_xdp_{load,store}_bytes selftest
  bpf: selftests: add CPUMAP/DEVMAP selftests for xdp multi-buff
  xdp: disable XDP_REDIRECT for xdp multi-buff

Toke Hoiland-Jorgensen (1):
  bpf: generalise tail call map compatibility check

 drivers/net/ethernet/marvell/mvneta.c         | 201 ++++++++-----
 include/linux/bpf.h                           |  32 +-
 include/linux/skbuff.h                        |   1 +
 include/net/xdp.h                             |  94 +++++-
 include/uapi/linux/bpf.h                      |  30 ++
 kernel/bpf/arraymap.c                         |   4 +-
 kernel/bpf/core.c                             |  28 +-
 kernel/bpf/cpumap.c                           |   8 +-
 kernel/bpf/devmap.c                           |   3 +-
 kernel/bpf/syscall.c                          |  25 +-
 kernel/trace/bpf_trace.c                      |   3 +
 net/bpf/test_run.c                            | 111 +++++--
 net/core/filter.c                             | 280 +++++++++++++++++-
 net/core/xdp.c                                |  71 ++++-
 tools/include/uapi/linux/bpf.h                |  30 ++
 tools/lib/bpf/libbpf.c                        |   8 +
 .../bpf/prog_tests/xdp_adjust_frags.c         |  81 +++++
 .../bpf/prog_tests/xdp_adjust_tail.c          | 118 ++++++++
 .../selftests/bpf/prog_tests/xdp_bpf2bpf.c    | 151 +++++++---
 .../bpf/prog_tests/xdp_cpumap_attach.c        |  65 +++-
 .../bpf/prog_tests/xdp_devmap_attach.c        |  56 ++++
 .../bpf/progs/test_xdp_adjust_tail_grow.c     |  10 +-
 .../bpf/progs/test_xdp_adjust_tail_shrink.c   |  32 +-
 .../selftests/bpf/progs/test_xdp_bpf2bpf.c    |   2 +-
 .../bpf/progs/test_xdp_update_frags.c         |  42 +++
 .../bpf/progs/test_xdp_with_cpumap_helpers.c  |   6 +
 .../progs/test_xdp_with_cpumap_mb_helpers.c   |  27 ++
 .../bpf/progs/test_xdp_with_devmap_helpers.c  |   7 +
 .../progs/test_xdp_with_devmap_mb_helpers.c   |  27 ++
 29 files changed, 1349 insertions(+), 204 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_update_frags.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_with_cpumap_mb_helpers.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_with_devmap_mb_helpers.c

-- 
2.31.1


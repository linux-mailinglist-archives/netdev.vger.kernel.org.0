Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB773427FE
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 22:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbhCSVsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 17:48:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:45334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229990AbhCSVry (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 17:47:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 951AD61956;
        Fri, 19 Mar 2021 21:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616190473;
        bh=9FIcvLntJe3A9uUip8oyrRCbcPJM0FEFLR+LsKa5t0s=;
        h=From:To:Cc:Subject:Date:From;
        b=CCNhUt5MOKBApYHMBucId0Oam24F4Olkr3rF6dMUKQfnV4RXDiROuqb3/JsrNTHGU
         VfeStpuOLSHdPy9dX2WXh4q4gaejwzqaAWp75EUrY9BInSGJ/0UvPW3YeGJ1/2FT/c
         /4TgHSBZdU4A64D3Gn6l+f8W7/POa993nQcXIgggWXOG/D6U2jQbAKivpRdFaR9A8S
         eON73FGY6nwL3iqgYXTEQcw14RUqjA7orguXmKO8RL4e4mLCtDMOjseBiDARc9ebVt
         0WOzy6wnyV9qNVuVc8Ss+XUmjf+ViyB4Z0/I3BG9es/HLJpkKpuo7fMBMnOHBnHsib
         Sv3T9f5bYO+uw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, sameehj@amazon.com
Subject: [PATCH v7 bpf-next 00/14] mvneta: introduce XDP multi-buffer support
Date:   Fri, 19 Mar 2021 22:47:14 +0100
Message-Id: <cover.1616179034.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.30.2
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

For now, to keep the design simple and to maintain performance, the XDP
BPF-prog (still) only have access to the first-buffer. It is left for
later (another patchset) to add payload access across multiple buffers.
This patchset should still allow for these future extensions. The goal
is to lift the XDP MTU restriction that comes with XDP, but maintain
same performance as before.

The main idea for the new multi-buffer layout is to reuse the same
layout used for non-linear SKB. We introduced a "xdp_shared_info" data
structure at the end of the first buffer to link together subsequent buffers.
xdp_shared_info will alias skb_shared_info allowing to keep most of the frags
in the same cache-line (while with skb_shared_info only the first fragment will
be placed in the first "shared_info" cache-line). Moreover we introduced some
xdp_shared_info helpers aligned to skb_frag* ones.
Converting xdp_frame to SKB and deliver it to the network stack is shown in
patch 07/14. Building the SKB, the xdp_shared_info structure will be converted
in a skb_shared_info one.

A multi-buffer bit (mb) has been introduced in xdp_{buff,frame} structure
to notify the bpf/network layer if this is a xdp multi-buffer frame (mb = 1)
or not (mb = 0).
The mb bit will be set by a xdp multi-buffer capable driver only for
non-linear frames maintaining the capability to receive linear frames
without any extra cost since the xdp_shared_info structure at the end
of the first buffer will be initialized only if mb is set.

Typical use cases for this series are:
- Jumbo-frames
- Packet header split (please see Google’s use-case @ NetDevConf 0x14, [0])
- TSO

A new frame_length field has been introduce in XDP ctx in order to notify the
eBPF layer about the total frame size (linear + paged parts).

bpf_xdp_adjust_tail and bpf_xdp_copy helpers have been modified to take info
account xdp multi-buff frames.

More info about the main idea behind this approach can be found here [1][2].

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

Eelco Chaudron (4):
  bpf: add multi-buff support to the bpf_xdp_adjust_tail() API
  bpd: add multi-buffer support to xdp copy helpers
  bpf: add new frame_length field to the XDP ctx
  bpf: update xdp_adjust_tail selftest to include multi-buffer

Lorenzo Bianconi (10):
  xdp: introduce mb in xdp_buff/xdp_frame
  xdp: add xdp_shared_info data structure
  net: mvneta: update mb bit before passing the xdp buffer to eBPF layer
  xdp: add multi-buff support to xdp_return_{buff/frame}
  net: mvneta: add multi buffer support to XDP_TX
  net: mvneta: enable jumbo frames for XDP
  net: xdp: add multi-buff support to xdp_build_skb_from_fram
  bpf: move user_size out of bpf_test_init
  bpf: introduce multibuff support to bpf_prog_test_run_xdp()
  bpf: test_run: add xdp_shared_info pointer in bpf_test_finish
    signature

 drivers/net/ethernet/marvell/mvneta.c         | 179 ++++++++++--------
 include/linux/filter.h                        |   7 +
 include/net/xdp.h                             | 100 +++++++++-
 include/uapi/linux/bpf.h                      |   1 +
 net/bpf/test_run.c                            | 109 +++++++++--
 net/core/filter.c                             | 131 ++++++++++++-
 net/core/xdp.c                                | 103 +++++++++-
 tools/include/uapi/linux/bpf.h                |   1 +
 .../bpf/prog_tests/xdp_adjust_tail.c          | 105 ++++++++++
 .../selftests/bpf/prog_tests/xdp_bpf2bpf.c    | 127 +++++++++----
 .../bpf/progs/test_xdp_adjust_tail_grow.c     |  16 +-
 .../bpf/progs/test_xdp_adjust_tail_shrink.c   |  32 +++-
 .../selftests/bpf/progs/test_xdp_bpf2bpf.c    |   3 +-
 13 files changed, 755 insertions(+), 159 deletions(-)

-- 
2.30.2


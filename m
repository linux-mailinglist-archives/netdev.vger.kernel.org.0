Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5D8A2FC15F
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 21:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388296AbhASUjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 15:39:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:55828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730059AbhASUVJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 15:21:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B80DE23107;
        Tue, 19 Jan 2021 20:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611087629;
        bh=m9+rIC2OGptHDRFb/JBt1YzzuS/e/I6IPQSPwwRyoRc=;
        h=From:To:Cc:Subject:Date:From;
        b=ZXPqRo4/uxlOI9RVHBQgj4X7XYRrZfAB2hUeTzKJR1k29DAEo2sgaPMhBJro2RWQG
         X2PO8ZFd/gVPhk/tmoVNCjOrqnMqw1qRm25GoNuib0KcLV++9iVe7luo6l6fhnZBVu
         yx7fIarY8R9gjVY2G6hdiQGXmTeDvAm1ZtyOo73WZ0ZpuGZqz3fINhS+/UE6fyWV6g
         6ex1oX1tlG+DF3tSXix7eTj5JRQWlbQkVQC3dUEw8IKZEn7zHLo7hs75PvlzKDABw+
         J963dleRM0vzwEue7pIRf7xaSeS/1bYLi1J1t+d76J8YF0yKOdL2KMyzehHu7uAWap
         2I3k2wmgtRPog==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, sameehj@amazon.com
Subject: [PATCH v6 bpf-next 0/8] mvneta: introduce XDP multi-buffer support
Date:   Tue, 19 Jan 2021 21:20:06 +0100
Message-Id: <cover.1611086134.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.29.2
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
cpumap code (patch 7/8). Building the SKB, the xdp_shared_info structure
will be converted in a skb_shared_info one.

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

bpf_xdp_adjust_tail helper has been modified to take info account xdp
multi-buff frames.

More info about the main idea behind this approach can be found here [1][2].

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

Eelco Chaudron (1):
  bpf: add multi-buff support to the bpf_xdp_adjust_tail() API

Lorenzo Bianconi (7):
  xdp: introduce mb in xdp_buff/xdp_frame
  xdp: add xdp_shared_info data structure
  net: mvneta: update mb bit before passing the xdp buffer to eBPF layer
  xdp: add multi-buff support to xdp_return_{buff/frame}
  net: mvneta: add multi buffer support to XDP_TX
  net: mvneta: enable jumbo frames for XDP
  net: xdp: add multi-buff support to xdp_build_skb_from_fram

 drivers/net/ethernet/marvell/mvneta.c | 182 +++++++++++++++-----------
 include/net/xdp.h                     |  88 +++++++++++--
 net/core/filter.c                     |  63 +++++++++
 net/core/xdp.c                        | 102 ++++++++++++++-
 4 files changed, 349 insertions(+), 86 deletions(-)

-- 
2.29.2


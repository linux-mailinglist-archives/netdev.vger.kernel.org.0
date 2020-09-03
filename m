Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BED0C25CB9B
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 22:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbgICU7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 16:59:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726088AbgICU7H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Sep 2020 16:59:07 -0400
Received: from lore-desk.redhat.com (unknown [151.66.86.87])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA944206B8;
        Thu,  3 Sep 2020 20:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599166747;
        bh=eNqYbb2UwOFJOvg8nHjHg56kZ9XVLK+ZfxCwWscomT0=;
        h=From:To:Cc:Subject:Date:From;
        b=kZIgUr895BUcIAPmCIidt3UE9H44i+OZO7OPtbF8slSvdU5mXUc4nhs+dfpG211L4
         Lwg3UvbbK5EPpo2yWoXiEM6ZBjq162GG94eOQti9OQcWyt7l08niCOeNtSLDhO8Vd7
         AVuNsDxXwT+58QOFuWjtLRrgOkx2u4Rg0rjj1e7I=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, davem@davemloft.net,
        lorenzo.bianconi@redhat.com, brouer@redhat.com,
        echaudro@redhat.com, sameehj@amazon.com, kuba@kernel.org,
        john.fastabend@gmail.com, daniel@iogearbox.net, ast@kernel.org,
        shayagr@amazon.com
Subject: [PATCH v2 net-next 0/9] mvneta: introduce XDP multi-buffer support
Date:   Thu,  3 Sep 2020 22:58:44 +0200
Message-Id: <cover.1599165031.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- Finalize XDP multi-buffer support for mvneta driver introducing the
  capability to map non-linear buffers on tx side.
- Introduce multi-buffer bit (mb) in xdp_frame/xdp_buffer to specify if
  shared_info area has been properly initialized.
- Initialize multi-buffer bit (mb) to 0 in all XDP-capable drivers.
- Add multi-buff support to xdp_return_{buff/frame} utility routines.
- Introduce bpf_xdp_adjust_mb_header helper to adjust frame headers moving
  *offset* bytes from/to the second buffer to/from the first one.
  This helper can be used to move headers when the hw DMA SG is not able
  to copy all the headers in the first fragment and split header and data
  pages. A possible use case for bpf_xdp_adjust_mb_header is described
  here [0]
- Introduce bpf_xdp_get_frag_count and bpf_xdp_get_frags_total_size helpers to
  report the total number/size of frags for a given xdp multi-buff.

XDP multi-buffer design principles are described here [1]
For the moment we have not implemented any self-test for the introduced the bpf
helpers. We can address this in a follow up series if the proposed approach
is accepted.

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

Lorenzo Bianconi (7):
  xdp: introduce mb in xdp_buff/xdp_frame
  xdp: initialize xdp_buff mb bit to 0 in all XDP drivers
  net: mvneta: update mb bit before passing the xdp buffer to eBPF layer
  xdp: add multi-buff support to xdp_return_{buff/frame}
  net: mvneta: add multi buffer support to XDP_TX
  bpf: helpers: add bpf_xdp_adjust_mb_header helper
  net: mvneta: enable jumbo frames for XDP

Sameeh Jubran (2):
  bpf: helpers: add multibuffer support
  samples/bpf: add bpf program that uses xdp mb helpers

 drivers/net/ethernet/amazon/ena/ena_netdev.c  |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |   1 +
 .../net/ethernet/cavium/thunder/nicvf_main.c  |   1 +
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |   1 +
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   |   1 +
 drivers/net/ethernet/intel/ice/ice_txrx.c     |   1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   1 +
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c |   1 +
 drivers/net/ethernet/marvell/mvneta.c         | 126 ++++++------
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |   1 +
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    |   1 +
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   1 +
 .../ethernet/netronome/nfp/nfp_net_common.c   |   1 +
 drivers/net/ethernet/qlogic/qede/qede_fp.c    |   1 +
 drivers/net/ethernet/sfc/rx.c                 |   1 +
 drivers/net/ethernet/socionext/netsec.c       |   1 +
 drivers/net/ethernet/ti/cpsw.c                |   1 +
 drivers/net/ethernet/ti/cpsw_new.c            |   1 +
 drivers/net/hyperv/netvsc_bpf.c               |   1 +
 drivers/net/tun.c                             |   2 +
 drivers/net/veth.c                            |   1 +
 drivers/net/virtio_net.c                      |   2 +
 drivers/net/xen-netfront.c                    |   1 +
 include/net/xdp.h                             |  26 ++-
 include/uapi/linux/bpf.h                      |  39 +++-
 net/core/dev.c                                |   1 +
 net/core/filter.c                             |  93 +++++++++
 net/core/xdp.c                                |  40 ++++
 samples/bpf/Makefile                          |   3 +
 samples/bpf/xdp_mb_kern.c                     |  68 +++++++
 samples/bpf/xdp_mb_user.c                     | 182 ++++++++++++++++++
 tools/include/uapi/linux/bpf.h                |  40 +++-
 32 files changed, 572 insertions(+), 70 deletions(-)
 create mode 100644 samples/bpf/xdp_mb_kern.c
 create mode 100644 samples/bpf/xdp_mb_user.c

-- 
2.26.2


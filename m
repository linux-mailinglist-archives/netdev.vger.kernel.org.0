Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FFFD4D4E0
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 19:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732476AbfFTRYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 13:24:36 -0400
Received: from mga12.intel.com ([192.55.52.136]:64663 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732425AbfFTRYf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 13:24:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Jun 2019 10:24:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,397,1557212400"; 
   d="scan'208";a="359020306"
Received: from silpixa00399838.ir.intel.com (HELO silpixa00399838.ger.corp.intel.com) ([10.237.223.110])
  by fmsmga006.fm.intel.com with ESMTP; 20 Jun 2019 10:24:32 -0700
From:   Kevin Laatz <kevin.laatz@intel.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com
Cc:     bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        bruce.richardson@intel.com, ciara.loftus@intel.com,
        Kevin Laatz <kevin.laatz@intel.com>
Subject: [PATCH 00/11] XDP unaligned chunk placement support
Date:   Thu, 20 Jun 2019 09:09:47 +0000
Message-Id: <20190620090958.2135-1-kevin.laatz@intel.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds the ability to use unaligned chunks in the XDP umem.

Currently, all chunk addresses passed to the umem are masked to be chunk
size aligned (default is 2k, max is PAGE_SIZE). This limits where we can
place chunks within the umem as well as limiting the packet sizes that are
supported.

The changes in this patchset removes these restrictions, allowing XDP to be
more flexible in where it can place a chunk within a umem. By relaxing where
the chunks can be placed, it allows us to use an arbitrary buffer size and
place that wherever we have a free address in the umem. These changes add the
ability to support jumboframes and make it easy to integrate with other
existing frameworks that have their own memory management systems, such as
DPDK.

Structure of the patchset:
Patch 1:
  - Remove unnecessary masking and headroom addition during zero-copy Rx
    buffer recycling in i40e. This change is required in order for the
    buffer recycling to work in the unaligned chunk mode.

Patch 2:
  - Remove unnecessary masking and headroom addition during
    zero-copy Rx buffer recycling in ixgbe. This change is required in
    order for the  buffer recycling to work in the unaligned chunk mode.

Patch 3:
  - Adds an offset parameter to zero_copy_allocator. This change will
    enable us to calculate the original handle in zca_free. This will be
    required for unaligned chunk mode since we can't easily mask back to
    the original handle.

Patch 4:
  - Adds the offset parameter to i40e_zca_free. This change is needed for
    calculating the handle since we can't easily mask back to the original
    handle like we can in the aligned case.

Patch 5:
  - Adds the offset parameter to ixgbe_zca_free. This change is needed for
    calculating the handle since we can't easily mask back to the original
    handle like we can in the aligned case.


Patch 6:
  - Add infrastructure for unaligned chunks. Since we are dealing
    with unaligned chunks that could potentially cross a physical page
    boundary, we add checks to keep track of that information. We can
    later use this information to correctly handle buffers that are
    placed at an address where they cross a page boundary.

Patch 7:
  - Add flags for umem configuration to libbpf

Patch 8:
  - Modify xdpsock application to add a command line option for
    unaligned chunks

Patch 9:
  - Addition of command line argument to pass in a desired buffer size
    and buffer recycling for unaligned mode. Passing in a buffer size will
    allow the application to use unaligned chunks with the unaligned chunk
    mode. Since we are now using unaligned chunks, we need to recycle our
    buffers in a slightly different way.

Patch 10:
  - Adds hugepage support to the xdpsock application

Patch 11:
  - Documentation update to include the unaligned chunk scenario. We need
    to explicitly state that the incoming addresses are only masked in the
    aligned chunk mode and not the unaligned chunk mode.

Kevin Laatz (11):
  i40e: simplify Rx buffer recycle
  ixgbe: simplify Rx buffer recycle
  xdp: add offset param to zero_copy_allocator
  i40e: add offset to zca_free
  ixgbe: add offset to zca_free
  xsk: add support to allow unaligned chunk placement
  libbpf: add flags to umem config
  samples/bpf: add unaligned chunks mode support to xdpsock
  samples/bpf: add buffer recycling for unaligned chunks to xdpsock
  samples/bpf: use hugepages in xdpsock app
  doc/af_xdp: include unaligned chunk case

 Documentation/networking/af_xdp.rst           | 10 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    | 21 ++--
 drivers/net/ethernet/intel/i40e/i40e_xsk.h    |  3 +-
 .../ethernet/intel/ixgbe/ixgbe_txrx_common.h  |  3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  | 21 ++--
 include/net/xdp.h                             |  3 +-
 include/net/xdp_sock.h                        |  2 +
 include/uapi/linux/if_xdp.h                   |  4 +
 net/core/xdp.c                                | 11 ++-
 net/xdp/xdp_umem.c                            | 17 ++--
 net/xdp/xsk.c                                 | 60 +++++++++--
 net/xdp/xsk_queue.h                           | 60 +++++++++--
 samples/bpf/xdpsock_user.c                    | 99 ++++++++++++++-----
 tools/include/uapi/linux/if_xdp.h             |  4 +
 tools/lib/bpf/xsk.c                           |  7 ++
 tools/lib/bpf/xsk.h                           |  2 +
 16 files changed, 241 insertions(+), 86 deletions(-)

-- 
2.17.1


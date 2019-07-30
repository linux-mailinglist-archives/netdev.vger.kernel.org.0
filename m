Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A48CA7AEFC
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 19:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729470AbfG3RJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 13:09:34 -0400
Received: from mga05.intel.com ([192.55.52.43]:33179 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729330AbfG3RJe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 13:09:34 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jul 2019 10:09:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,327,1559545200"; 
   d="scan'208";a="183192461"
Received: from silpixa00399838.ir.intel.com (HELO silpixa00399838.ger.corp.intel.com) ([10.237.223.140])
  by orsmga002.jf.intel.com with ESMTP; 30 Jul 2019 10:09:29 -0700
From:   Kevin Laatz <kevin.laatz@intel.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        jakub.kicinski@netronome.com, jonathan.lemon@gmail.com,
        saeedm@mellanox.com, maximmi@mellanox.com,
        stephen@networkplumber.org
Cc:     bruce.richardson@intel.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        Kevin Laatz <kevin.laatz@intel.com>
Subject: [PATCH bpf-next v4 00/11] XDP unaligned chunk placement support 
Date:   Tue, 30 Jul 2019 08:53:49 +0000
Message-Id: <20190730085400.10376-1-kevin.laatz@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190724051043.14348-1-kevin.laatz@intel.com>
References: <20190724051043.14348-1-kevin.laatz@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds the ability to use unaligned chunks in the XDP umem.

Currently, all chunk addresses passed to the umem are masked to be chunk
size aligned (max is PAGE_SIZE). This limits where we can place chunks
within the umem as well as limiting the packet sizes that are supported.

The changes in this patch set removes these restrictions, allowing XDP to
be more flexible in where it can place a chunk within a umem. By relaxing
where the chunks can be placed, it allows us to use an arbitrary buffer
size and place that wherever we have a free address in the umem. These
changes add the ability to support arbitrary frame sizes up to 4k
(PAGE_SIZE) and make it easy to integrate with other existing frameworks
that have their own memory management systems, such as DPDK.
In DPDK, for example, there is already support for AF_XDP with zero-copy.
However, with this patch set the integration will be much more seamless.
You can find the DPDK AF_XDP driver at:
https://git.dpdk.org/dpdk/tree/drivers/net/af_xdp

Since we are now dealing with arbitrary frame sizes, we need also need to
update how we pass around addresses. Currently, the addresses can simply be
masked to 2k to get back to the original address. This becomes less trivial
when using frame sizes that are not a 'power of 2' size. This patch set
modifies the Rx/Tx descriptor format to use the upper 16-bits of the addr
field for an offset value, leaving the lower 48-bits for the address (this
leaves us with 256 Terabytes, which should be enough!). We only need to use
the upper 16-bits to store the offset when running in unaligned mode.
Rather than adding the offset (headroom etc) to the address, we will store
it in the upper 16-bits of the address field. This way, we can easily add
the offset to the address where we need it, using some bit manipulation and
addition, and we can also easily get the original address wherever we need
it (for example in i40e_zca_free) by simply masking to get the lower
48-bits of the address field.

The numbers below were recorded with the following set up:
  - Intel(R) Xeon(R) Gold 6140 CPU @ 2.30GHz
  - Intel Corporation Ethernet Controller XXV710 for 25GbE SFP28 (rev 02)
  - Driver: i40e
  - Application: xdpsock with l2fwd (single interface)
  - Turbo disabled in BIOS

These are solely for comparing performance with and without the patches.
The largest drop was ~1.5% (in zero-copy mode).

+-------------------------+-------------+-----------------+-------------+
| Buffer size: 2048       | SKB mode    | Zero-copy       | Copy        |
+-------------------------+-------------+-----------------+-------------+
| Aligned (baseline)      | 1.25 Mpps   | 10.0 Mpps       | 1.66 Mpps   |
+-------------------------+-------------+-----------------+-------------+
| Aligned (with patches)  | 1.25 Mpps   | 9.85 Mpps       | 1.66 Mpps   |
+-------------------------+-------------+-----------------+-------------+
| Unaligned               | 1.25 Mpps   | 9.65 Mpps       | 1.66 Mpps   |
+-------------------------+-------------+-----------------+-------------+

This patch set has been applied against
commit 475e31f8da1b("Merge branch 'revamp-test_progs'")

Structure of the patch set:
Patch 1:
  - Remove unnecessary masking and headroom addition during zero-copy Rx
    buffer recycling in i40e. This change is required in order for the
    buffer recycling to work in the unaligned chunk mode.

Patch 2:
  - Remove unnecessary masking and headroom addition during
    zero-copy Rx buffer recycling in ixgbe. This change is required in
    order for the  buffer recycling to work in the unaligned chunk mode.

Patch 3:
  - Add flags for umem configuration to libbpf

Patch 4:
  - Add infrastructure for unaligned chunks. Since we are dealing with
    unaligned chunks that could potentially cross a physical page boundary,
    we add checks to keep track of that information. We can later use this
    information to correctly handle buffers that are placed at an address
    where they cross a page boundary.  This patch also modifies the
    existing Rx and Tx functions to use the new descriptor format. To
    handle addresses correctly, we need to mask appropriately based on
    whether we are in aligned or unaligned mode.

Patch 5:
  - This patch updates the i40e driver to make use of the new descriptor
    format.

Patch 6:
  - This patch updates the ixgbe driver to make use of the new descriptor
    format.

Patch 7:
  - This patch updates the mlx5e driver to make use of the new descriptor
    format. These changes are required to handle the new descriptor format
    and for unaligned chunks support.

Patch 8:
  - Modify xdpsock application to add a command line option for
    unaligned chunks

Patch 9:
  - Since we can now run the application in unaligned chunk mode, we need
    to make sure we recycle the buffers appropriately.

Patch 10:
  - Adds hugepage support to the xdpsock application

Patch 11:
  - Documentation update to include the unaligned chunk scenario. We need
    to explicitly state that the incoming addresses are only masked in the
    aligned chunk mode and not the unaligned chunk mode.

---
v2:
  - fixed checkpatch issues
  - fixed Rx buffer recycling for unaligned chunks in xdpsock
  - removed unused defines
  - fixed how chunk_size is calculated in xsk_diag.c
  - added some performance numbers to cover letter
  - modified descriptor format to make it easier to retrieve original
    address
  - removed patch adding off_t off to the zero copy allocator. This is no
    longer needed with the new descriptor format.

v3:
  - added patch for mlx5 driver changes needed for unaligned chunks
  - moved offset handling to new helper function
  - changed value used for the umem chunk_mask. Now using the new
    descriptor format to save us doing the calculations in a number of
    places meaning more of the code is left unchanged while adding
    unaligned chunk support.

v4:
  - reworked the next_pg_contig field in the xdp_umem_page struct. We now
    use the low 12 bits of the addr for flags rather than adding an extra
    field in the struct.
  - modified unaligned chunks flag define
  - fixed page_start calculation in __xsk_rcv_memcpy().
  - move offset handling to the xdp_umem_get_* functions
  - modified the len field in xdp_umem_reg struct. We now use 16 bits from
    this for the flags field.
  - removed next_pg_contig field from xdp_umem_page struct. Using low 12
    bits of addr to store flags instead.
  - fixed headroom addition to handle in the mlx5e driver
  - other minor changes based on review comments

Kevin Laatz (11):
  i40e: simplify Rx buffer recycle
  ixgbe: simplify Rx buffer recycle
  libbpf: add flags to umem config
  xsk: add support to allow unaligned chunk placement
  i40e: modify driver for handling offsets
  ixgbe: modify driver for handling offsets
  mlx5e: modify driver for handling offsets
  samples/bpf: add unaligned chunks mode support to xdpsock
  samples/bpf: add buffer recycling for unaligned chunks to xdpsock
  samples/bpf: use hugepages in xdpsock app
  doc/af_xdp: include unaligned chunk case

 Documentation/networking/af_xdp.rst           | 10 ++-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    | 26 +++---
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  | 26 +++---
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  8 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   |  3 +-
 include/net/xdp_sock.h                        | 40 +++++++++-
 include/uapi/linux/if_xdp.h                   | 14 +++-
 net/xdp/xdp_umem.c                            | 18 +++--
 net/xdp/xsk.c                                 | 79 +++++++++++++++----
 net/xdp/xsk_diag.c                            |  2 +-
 net/xdp/xsk_queue.h                           | 69 ++++++++++++++--
 samples/bpf/xdpsock_user.c                    | 59 ++++++++++----
 tools/include/uapi/linux/if_xdp.h             |  9 ++-
 tools/lib/bpf/xsk.c                           |  3 +
 tools/lib/bpf/xsk.h                           |  2 +
 15 files changed, 280 insertions(+), 88 deletions(-)

-- 
2.17.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB5625565D
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 10:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728677AbgH1I0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 04:26:44 -0400
Received: from mga05.intel.com ([192.55.52.43]:43584 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728274AbgH1I0h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Aug 2020 04:26:37 -0400
IronPort-SDR: n++ct4+AgGw2VvX2M9DUEY/T0h0XNP5UcD5rjh8EEBp06IS/Pyb/nsrmjXT/i/Wp3UIL60ZP+y
 OZTJTL0yWjkg==
X-IronPort-AV: E=McAfee;i="6000,8403,9726"; a="241444314"
X-IronPort-AV: E=Sophos;i="5.76,363,1592895600"; 
   d="scan'208";a="241444314"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2020 01:26:36 -0700
IronPort-SDR: Vipww6Z4wixlbKzwS+EX8ADpeZk8fGFiHHhMmeV3PdLaMIapm9TrwZ6q8eC5TnDTooU/kLaTbN
 Yny0FYQKfBKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,363,1592895600"; 
   d="scan'208";a="444762396"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.249.36.33])
  by orsmga004.jf.intel.com with ESMTP; 28 Aug 2020 01:26:32 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maximmi@mellanox.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, cristian.dumitrescu@intel.com
Subject: [PATCH bpf-next v5 00/15] xsk: support shared umems between devices and queues
Date:   Fri, 28 Aug 2020 10:26:14 +0200
Message-Id: <1598603189-32145-1-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds support to share a umem between AF_XDP sockets
bound to different queue ids on the same device or even between
devices. It has already been possible to do this by registering the
umem multiple times, but this wastes a lot of memory. Just imagine
having 10 threads each having 10 sockets open sharing a single
umem. This means that you would have to register the umem 100 times
consuming large quantities of memory.

Instead, we extend the existing XDP_SHARED_UMEM flag to also work when
sharing a umem between different queue ids as well as devices. If you
would like to share umem between two sockets, just create the first
one as would do normally. For the second socket you would not register
the same umem using the XDP_UMEM_REG setsockopt. Instead attach one
new fill ring and one new completion ring to this second socket and
then use the XDP_SHARED_UMEM bind flag supplying the file descriptor of
the first socket in the sxdp_shared_umem_fd field to signify that it
is the umem of the first socket you would like to share.

One important thing to note in this example, is that there needs to be
one fill ring and one completion ring per unique device and queue id
bound to. This so that the single-producer and single-consumer semantics
of the rings can be upheld. To recap, if you bind multiple sockets to
the same device and queue id (already supported without this patch
set), you only need one pair of fill and completion rings. If you bind
multiple sockets to multiple different queues or devices, you need one
fill and completion ring pair per unique device,queue_id tuple.

The implementation is based around extending the buffer pool in the
core xsk code. This is a structure that exists on a per unique device
and queue id basis. So, a number of entities that can now be shared
are moved from the umem to the buffer pool. Information about DMA
mappings are also moved from the buffer pool, but as these are per
device independent of the queue id, they are now hanging off the umem
in list. However, the pool is set up to point directly to the
dma_addr_t array that it needs. In summary after this patch set, there
is one xdp_sock struct per socket created. This points to an
xsk_buff_pool for which there is one per unique device and queue
id. The buffer pool points to a DMA mapping structure for which there
is one per device that a umem has been bound to. And finally, the
buffer pool also points to a xdp_umem struct, for which there is only
one per umem registration.

Before:

XSK -> UMEM -> POOL

Now:

XSK -> POOL -> DMA
            \
	     > UMEM

Patches 1-8 only rearrange internal structures to support the buffer
pool carrying this new information, while patches 9 and 10 improve
performance. Finally, patches 11-15 introduce the new functionality
together with libbpf support, samples, and documentation.

Libbpf has also been extended to support sharing of umems between
sockets bound to different devices and queue ids by introducing a new
function called xsk_socket__create_shared(). The difference between
this and the existing xsk_socket__create() is that the former takes a
reference to a fill ring and a completion ring as these need to be
created. This new function needs to be used for the second and
following sockets that binds to the same umem. The first socket can be
created by either function as it will also have called
xsk_umem__create().

There is also a new sample xsk_fwd that demonstrates this new
interface and capability.

Performance for the non-shared umem case is up 3% for the l2fwd xdpsock
sample application with this patch set. For workloads that share a
umem, this patch set can give rise to added performance benefits due
to the decrease in memory usage.

v4 -> v5:

* Fixed performance problem with sharing a umem between different
  queues on the same netdev. Sharing the dma_pages array between
  buffer pool instances was a bad idea. It led to many cross-core
  snoop traffic messages that degraded performance. The solution: only
  map the dma mappings once as before, but copy the dma_addr_t to a per
  buffer pool array so that this sharing dissappears.
* Added patch 10 that improves performance with 3% for l2fwd with a
  simple fix that is now possible, as we pass the buffer pool to the driver.
* xp_dma_unmap() did not honor the refcount. Fixed. [Maxim]
* Fixed bisectabilty problem in patch 5 [Maxim]

v3 -> v4:

* Fixed compilation error when CONFIG_XDP_SOCKETS_DIAG is set [lkp robot]

v2 -> v3:

* Clean up of fq_tmp and cq_tmp in xsk_release [Maxim]
* Fixed bug when bind failed that caused pool to be freed twice [Ciara]

v1 -> v2:

* Tx need_wakeup init bug fixed. Missed to set the cached_need_wakeup
  flag for Tx.
* Need wakeup turned on for xsk_fwd sample [Cristian]
* Commit messages cleaned up
* Moved dma mapping list from netdev to umem [Maxim]
* Now the buffer pool is only created once. Fill ring and completion
  ring pointers are stored in the socket during initialization (before
  bind) and at bind these pointers are moved over to the buffer pool
  which is used all the time after that. [Maxim]

This patch has been applied against commit 2e80be60c465 ("libbpf: Fix compilation warnings for 64-bit printf args")

Structure of the patch set:

Patch 1: Pass the buffer pool to the driver instead of the umem. This
         because the driver needs one buffer pool per napi context
         when we later introduce sharing of the umem between queue ids
         and devices.
Patch 2: Rename the xsk driver interface so they have better names
         after the move to the buffer pool
Patch 3: There is one buffer pool per device and queue, while there is
         only one umem per registration. The buffer pool needs to be
         created and destroyed independently of the umem.
Patch 4: Move fill and completion rings to the buffer pool as there will
         be one set of these per device and queue
Patch 5: Move queue_id, dev and need_wakeup to buffer pool again as these
         will now be per buffer pool as the umem can be shared between
         devices and queues
Patch 6: Move xsk_tx_list and its lock to buffer pool
Patch 7: Move the creation/deletion of addrs from buffer pool to umem
Patch 8: Enable sharing of DMA mappings when multiple queues of the
         same device are bound
Patch 9: Rearrange internal structs for better performance as these
         have been substantially scrambled by the previous patches
Patch 10: Improve performance by testing for dma_need_synch earlier.
          This is now possible, since we pass the buffer pool to the
          driver. Improves performance with 3% for the l2fwd sample app.
Patch 11: Add shared umem support between queue ids
Patch 12: Add shared umem support between devices
Patch 13: Add support for this in libbpf
Patch 14: Add a new sample that demonstrates this new feature by
          forwarding packets between different netdevs and queues
Patch 15: Add documentation

Thanks: Magnus

Cristian Dumitrescu (1):
  samples/bpf: add new sample xsk_fwd.c

Magnus Karlsson (14):
  xsk: i40e: ice: ixgbe: mlx5: pass buffer pool to driver instead of
    umem
  xsk: i40e: ice: ixgbe: mlx5: rename xsk zero-copy driver interfaces
  xsk: create and free buffer pool independently from umem
  xsk: move fill and completion rings to buffer pool
  xsk: move queue_id, dev and need_wakeup to buffer pool
  xsk: move xsk_tx_list and its lock to buffer pool
  xsk: move addrs from buffer pool to umem
  xsk: enable sharing of dma mappings
  xsk: rearrange internal structs for better performance
  xsk: i40e: ice: ixgbe: mlx5: test for dma_need_sync earlier for better
    performance
  xsk: add shared umem support between queue ids
  xsk: add shared umem support between devices
  libbpf: support shared umems between queues and devices
  xsk: documentation for XDP_SHARED_UMEM between queues and netdevs

 Documentation/networking/af_xdp.rst                |   68 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |    2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   29 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |   10 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.h        |    2 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |   81 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.h         |    4 +-
 drivers/net/ethernet/intel/ice/ice.h               |   18 +-
 drivers/net/ethernet/intel/ice/ice_base.c          |   16 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |    2 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |   10 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c          |    8 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h          |    2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |  138 +--
 drivers/net/ethernet/intel/ice/ice_xsk.h           |    7 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h           |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   34 +-
 .../net/ethernet/intel/ixgbe/ixgbe_txrx_common.h   |    7 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |   63 +-
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   19 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |    5 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/pool.c  |  217 ++++
 .../net/ethernet/mellanox/mlx5/core/en/xsk/pool.h  |   27 +
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.c    |    4 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.h    |   10 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |   12 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.h |    2 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    |   14 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.h    |    6 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/umem.c  |  217 ----
 .../net/ethernet/mellanox/mlx5/core/en/xsk/umem.h  |   29 -
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |    2 +-
 .../ethernet/mellanox/mlx5/core/en_fs_ethtool.c    |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   49 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   16 +-
 include/linux/netdevice.h                          |   10 +-
 include/net/xdp_sock.h                             |   30 +-
 include/net/xdp_sock_drv.h                         |  122 ++-
 include/net/xsk_buff_pool.h                        |   53 +-
 net/ethtool/channels.c                             |    2 +-
 net/ethtool/ioctl.c                                |    2 +-
 net/xdp/xdp_umem.c                                 |  225 +---
 net/xdp/xdp_umem.h                                 |    6 -
 net/xdp/xsk.c                                      |  213 ++--
 net/xdp/xsk.h                                      |   10 +-
 net/xdp/xsk_buff_pool.c                            |  380 ++++++-
 net/xdp/xsk_diag.c                                 |   16 +-
 net/xdp/xsk_queue.h                                |   12 +-
 samples/bpf/Makefile                               |    3 +
 samples/bpf/xsk_fwd.c                              | 1085 ++++++++++++++++++++
 tools/lib/bpf/libbpf.map                           |    1 +
 tools/lib/bpf/xsk.c                                |  376 ++++---
 tools/lib/bpf/xsk.h                                |    9 +
 54 files changed, 2578 insertions(+), 1113 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.h
 create mode 100644 samples/bpf/xsk_fwd.c

--
2.7.4

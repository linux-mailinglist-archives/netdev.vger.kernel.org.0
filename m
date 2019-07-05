Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E516A5F861
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 14:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbfGDMm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 08:42:57 -0400
Received: from mga04.intel.com ([192.55.52.120]:48071 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725860AbfGDMm4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 08:42:56 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jul 2019 05:42:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,451,1557212400"; 
   d="scan'208";a="315854941"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.252.32.218])
  by orsmga004.jf.intel.com with ESMTP; 04 Jul 2019 05:42:51 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, brouer@redhat.com
Cc:     bpf@vger.kernel.org, bruce.richardson@intel.com,
        ciara.loftus@intel.com, jakub.kicinski@netronome.com,
        xiaolong.ye@intel.com, qi.z.zhang@intel.com, maximmi@mellanox.com,
        sridhar.samudrala@intel.com, kevin.laatz@intel.com,
        ilias.apalodimas@linaro.org, kiran.patil@intel.com,
        axboe@kernel.dk, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org
Subject: [PATCH bpf-next v3 0/6] add need_wakeup flag to the AF_XDP rings
Date:   Thu,  4 Jul 2019 14:42:08 +0200
Message-Id: <1562244134-19069-1-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds support for a new flag called need_wakeup in the
AF_XDP Tx and fill rings. When this flag is set by the driver, it
means that the application has to explicitly wake up the kernel Rx
(for the bit in the fill ring) or kernel Tx (for bit in the Tx ring)
processing by issuing a syscall. Poll() can wake up both and sendto()
will wake up Tx processing only.

The main reason for introducing this new flag is to be able to
efficiently support the case when application and driver is executing
on the same core. Previously, the driver was just busy-spinning on the
fill ring if it ran out of buffers in the HW and there were none to
get from the fill ring. This approach works when the application and
driver is running on different cores as the application can replenish
the fill ring while the driver is busy-spinning. Though, this is a
lousy approach if both of them are running on the same core as the
probability of the fill ring getting more entries when the driver is
busy-spinning is zero. With this new feature the driver now sets the
need_wakeup flag and returns to the application. The application can
then replenish the fill queue and then explicitly wake up the Rx
processing in the kernel using the syscall poll(). For Tx, the flag is
only set to one if the driver has no outstanding Tx completion
interrupts. If it has some, the flag is zero as it will be woken up by
a completion interrupt anyway. This flag can also be used in other
situations where the driver needs to be woken up explicitly.

As a nice side effect, this new flag also improves the Tx performance
of the case where application and driver are running on two different
cores as it reduces the number of syscalls to the kernel. The kernel
tells user space if it needs to be woken up by a syscall, and this
eliminates many of the syscalls. The Rx performance of the 2-core case
is on the other hand slightly worse, since there is a need to use a
syscall now to wake up the driver, instead of the driver
busy-spinning. It does waste less CPU cycles though, which might lead
to better overall system performance.

This new flag needs some simple driver support. If the driver does not
support it, the Rx flag is always zero and the Tx flag is always
one. This makes any application relying on this feature default to the
old behavior of not requiring any syscalls in the Rx path and always
having to call sendto() in the Tx path.

For backwards compatibility reasons, this feature has to be explicitly
turned on using a new bind flag (XDP_USE_NEED_WAKEUP). I recommend
that you always turn it on as it has a large positive performance
impact for the one core case and does not degrade 2 core performance
and actually improves it for Tx heavy workloads.

Here are some performance numbers measured on my local,
non-performance optimized development system. That is why you are
seeing numbers lower than the ones from Björn and Jesper. 64 byte
packets at 40Gbit/s line rate. All results in Mpps. Cores == 1 means
that both application and driver is executing on the same core. Cores
== 2 that they are on different cores.

                              Applications
need_wakeup  cores    txpush    rxdrop      l2fwd
---------------------------------------------------------------
     n         1       0.07      0.06        0.03
     y         1       21.6      8.2         6.5
     n         2       32.3      11.7        8.7
     y         2       33.1      11.7        8.7

Overall, the need_wakeup flag provides the same or better performance
in all the micro-benchmarks. The reduction of sendto() calls in txpush
is large. Only a few per second is needed. For l2fwd, the drop is 50%
for the 1 core case and more than 99.9% for the 2 core case. Do not
know why I am not seeing the same drop for the 1 core case yet.

The name and inspiration of the flag has been taken from io_uring by
Jens Axboe. Details about this feature in io_uring can be found in
http://kernel.dk/io_uring.pdf, section 8.3. It also addresses most of
the denial of service and sendto() concerns raised by Maxim
Mikityanskiy in https://www.spinics.net/lists/netdev/msg554657.html.

The typical Tx part of an application will have to change from:

ret = sendto(fd,....)

to:

if (xsk_ring_prod__needs_wakeup(&xsk->tx))
       ret = sendto(fd,....)

and th Rx part from:

rcvd = xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE, &idx_rx);
if (!rcvd)
       return;

to:

rcvd = xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE, &idx_rx);
if (!rcvd) {
       if (xsk_ring_prod__needs_wakeup(&xsk->umem->fq))
              ret = poll(fd,.....);
       return;
}

v2 -> v3:
* Converted the Mellanox driver to the new ndo in patch 1 as pointed out
  by Maxim
* Fixed the compatibility code of XDP_MMAP_OFFSETS so it now works.

v1 -> v2:
* Fixed bisectability problem pointed out by Jakub
* Added missing initiliztion of the Tx need_wakeup flag to 1

This patch has been applied against commit e5a3e259ef23 ("Merge branch 'bpf-tcp-rtt-hook'")

Structure of the patch set:

Patch 1: Replaces the ndo_xsk_async_xmit with ndo_xsk_wakeup to
         support waking up both Rx and Tx processing
Patch 2: Implements the need_wakeup functionality in common code
Patch 3-4: Add need_wakeup support to the i40e and ixgbe drivers
Patch 5: Add need_wakeup support to libbpf
Patch 6: Add need_wakeup support to the xdpsock sample application

Thanks: Magnus

Magnus Karlsson (6):
  xsk: replace ndo_xsk_async_xmit with ndo_xsk_wakeup
  xsk: add support for need_wakeup flag in AF_XDP rings
  i40e: add support for AF_XDP need_wakup feature
  ixgbe: add support for AF_XDP need_wakup feature
  libbpf: add support for need_wakeup flag in AF_XDP part
  samples/bpf: add use of need_sleep flag in xdpsock

 drivers/net/ethernet/intel/i40e/i40e_main.c        |   5 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |  23 ++-
 drivers/net/ethernet/intel/i40e/i40e_xsk.h         |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   5 +-
 .../net/ethernet/intel/ixgbe/ixgbe_txrx_common.h   |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |  20 ++-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.h    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   2 +-
 include/linux/netdevice.h                          |  18 +-
 include/net/xdp_sock.h                             |  33 +++-
 include/uapi/linux/if_xdp.h                        |  13 ++
 net/xdp/xdp_umem.c                                 |  12 +-
 net/xdp/xsk.c                                      | 149 +++++++++++++---
 net/xdp/xsk.h                                      |  13 ++
 net/xdp/xsk_queue.h                                |   1 +
 samples/bpf/xdpsock_user.c                         | 192 +++++++++++++--------
 tools/include/uapi/linux/if_xdp.h                  |  13 ++
 tools/lib/bpf/xsk.c                                |   4 +
 tools/lib/bpf/xsk.h                                |   6 +
 20 files changed, 406 insertions(+), 111 deletions(-)

--
2.7.4

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 356B111591
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 10:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfEBIjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 04:39:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:64457 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725951AbfEBIjm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 04:39:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 May 2019 01:39:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,421,1549958400"; 
   d="scan'208";a="296322364"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO VM.isw.intel.com) ([10.103.211.43])
  by orsmga004.jf.intel.com with ESMTP; 02 May 2019 01:39:36 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, brouer@redhat.com
Cc:     bpf@vger.kernel.org, bruce.richardson@intel.com,
        ciara.loftus@intel.com, jakub.kicinski@netronome.com,
        xiaolong.ye@intel.com, qi.z.zhang@intel.com, maximmi@mellanox.com,
        sridhar.samudrala@intel.com, kevin.laatz@intel.com
Subject: [RFC bpf-next 0/7] busy poll support for AF_XDP sockets
Date:   Thu,  2 May 2019 10:39:16 +0200
Message-Id: <1556786363-28743-1-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This RFC proposes to add busy-poll support to AF_XDP sockets. With
busy-poll, the driver is executed in process context by calling the
poll() syscall. The main advantage with this is that all processing
occurs on a single core. This eliminates the core-to-core cache
transfers that occur between the application and the softirqd
processing on another core, that occurs without busy-poll. From a
systems point of view, it also provides an advatage that we do not
have to provision extra cores in the system to handle
ksoftirqd/softirq processing, as all processing is done on the single
core that executes the application. The drawback of busy-poll is that
max throughput seen from a single application will be lower (due to
the syscall), but on a per core basis it will often be higher as
the normal mode runs on two cores and busy-poll on a single one.

The semantics of busy-poll from the application point of view are the
following:

* The application is required to call poll() to drive rx and tx
  processing. There is no guarantee that softirq and interrupts will
  do this for you. This is in contrast with the current
  implementations of busy-poll that are opportunistic in the sense
  that packets might be received/transmitted by busy-poll or
  softirqd. (In this patch set, softirq/ksoftirqd will kick in at high
  loads just as the current opportunistic implementations, but I would
  like to get to a point where this is not the case for busy-poll
  enabled XDP sockets, as this slows down performance considerably and
  starts to use one more core for the softirq processing. The end goal
  is for only poll() to drive the napi loop when busy-poll is enabled
  on an AF_XDP socket. More about this later.)

* It should be enabled on a per socket basis. No global enablement, i.e.
  the XDP socket busy-poll will not care about the current
  /proc/sys/net/core/busy_poll and busy_read global enablement
  mechanisms.

* The batch size (how many packets that are processed every time the
  napi function in the driver is called, i.e. the weight parameter)
  should be configurable. Currently, the busy-poll size of AF_INET
  sockets is set to 8, but for AF_XDP sockets this is too small as the
  amount of processing per packet is much smaller with AF_XDP. This
  should be configurable on a per socket basis.

* If you put multiple AF_XDP busy-poll enabled sockets into a poll()
  call the napi contexts of all of them should be executed. This is in
  contrast to the AF_INET busy-poll that quits after the fist one that
  finds any packets. We need all napi contexts to be executed due to
  the first requirement in this list. The behaviour we want is much more
  like regular sockets in that all of them are checked in the poll
  call.

* Should be possible to mix AF_XDP busy-poll sockets with any other
  sockets including busy-poll AF_INET ones in a single poll() call
  without any change to semantics or the behaviour of any of those
  socket types.

* As suggested by Maxim Mikityanskiy, poll() will in the busy-poll
  mode return POLLERR if the fill ring is empty or the completion
  queue is full.

Busy-poll support is enabled by calling a new setsockopt called
XDP_BUSY_POLL_BATCH_SIZE that takes batch size as an argument. A value
between 1 and NAPI_WEIGHT (64) will turn it on, 0 will turn it off and
any other value will return an error.

A typical packet processing rxdrop loop with busy-poll will look something
like this:

for (i = 0; i < num_socks; i++) {
    fds[i].fd = xsk_socket__fd(xsks[i]->xsk);
    fds[i].events = POLLIN;
}

for (;;) {
    ret = poll(fds, num_socks, 0);
    if (ret <= 0)
            continue;

    for (i = 0; i < num_socks; i++)
        rx_drop(xsks[i], fds); /* The actual application */
}

Need some advice around this issue please:

In this patch set, softirq/ksoftirqd will kick in at high loads and
render the busy poll support useless as the execution is now happening
in the same way as without busy-poll support. Everything works from an
application perspective but this defeats the purpose of the support
and also consumes an extra core. What I would like to accomplish when
XDP socket busy-poll is enabled is that softirq/ksoftirq is never
invoked for the traffic that goes to this socket. This way, we would
get better performance on a per core basis and also get the same
behaviour independent of load.

To accomplish this, the driver would need to create a napi context
containing the busy-poll enabled XDP socket queues (not shared with
any other traffic) that do not have an interrupt associated with
it.

Does this sound like an avenue worth pursuing and if so, should it be
part of this RFC/PATCH or separate?

Epoll() is not supported at this point in time. Since it was designed
for handling a very large number of sockets, I thought it was better
to leave this for later if the need will arise.

To do:

* Move over all drivers to the new xdp_[rt]xq_info functions. If you
  think this is the right way to go forward, I will move over
  Mellanox, Netronome, etc for the proper patch.

* Performance measurements

* Test SW drivers like virtio, veth and tap. Actually, test anything
  that is not i40e.

* Test multiple sockets of different types in the same poll() call

* Check bisectability of each patch

* Versioning of the libbpf interface since we add an entry to the
  socket configuration struct

This RFC has been applied against commit 2b5bc3c8ebce ("r8169: remove manual autoneg restart workaround")

Structure of the patch set:
Patch 1: Makes the busy poll batch size configurable inside the kernel
Patch 2: Adds napi id to struct xdp_rxq_info, adds this to the
         xdp_rxq_reg_info function and changes the interface and
	 implementation so that we only need a single copy of the
	 xdp_rxq_info struct that resides in _rx. Previously there was
	 another one in the driver, but now the driver uses the one in
	 _rx. All XDP enabled drivers are converted to these new
	 functions.
Patch 3: Adds a struct xdp_txq_info with corresponding functions to
         xdp_rxq_info that is used to store information about the tx
	 queue. The use of these are added to all AF_XDP enabled drivers.
Patch 4: Introduce a new setsockopt/getsockopt in the uapi for
         enabling busy_poll.
Patch 5: Implements busy poll in the xsk code.
Patch 6: Add busy-poll support to libbpf.
Patch 7: Add busy-poll support to the xdpsock sample application.

Thanks: Magnus

Magnus Karlsson (7):
  net: fs: make busy poll budget configurable in napi_busy_loop
  net: i40e: ixgbe: tun: veth: virtio-net: centralize xdp_rxq_info and
    add napi id
  net: i40e: ixgbe: add xdp_txq_info structure
  netdevice: introduce busy-poll setsockopt for AF_XDP
  net: add busy-poll support for XDP sockets
  libbpf: add busy-poll support to XDP sockets
  samples/bpf: add busy-poll support to xdpsock sample

 drivers/net/ethernet/intel/i40e/i40e_ethtool.c |   2 -
 drivers/net/ethernet/intel/i40e/i40e_main.c    |   8 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c    |  37 ++++-
 drivers/net/ethernet/intel/i40e/i40e_txrx.h    |   2 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c     |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h       |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c  |  48 ++++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c   |   2 +-
 drivers/net/tun.c                              |  14 +-
 drivers/net/veth.c                             |  10 +-
 drivers/net/virtio_net.c                       |   8 +-
 fs/eventpoll.c                                 |   5 +-
 include/linux/netdevice.h                      |   1 +
 include/net/busy_poll.h                        |   7 +-
 include/net/xdp.h                              |  23 ++-
 include/net/xdp_sock.h                         |   3 +
 include/uapi/linux/if_xdp.h                    |   1 +
 net/core/dev.c                                 |  43 ++----
 net/core/xdp.c                                 | 103 ++++++++++---
 net/xdp/Kconfig                                |   1 +
 net/xdp/xsk.c                                  | 122 ++++++++++++++-
 net/xdp/xsk_queue.h                            |  18 ++-
 samples/bpf/xdpsock_user.c                     | 203 +++++++++++++++----------
 tools/include/uapi/linux/if_xdp.h              |   1 +
 tools/lib/bpf/xsk.c                            |  23 +--
 tools/lib/bpf/xsk.h                            |   1 +
 26 files changed, 495 insertions(+), 195 deletions(-)

--
2.7.4

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10C975AEC7
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 08:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbfF3GFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 02:05:46 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33553 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725959AbfF3GFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 02:05:45 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 5785221B7C;
        Sun, 30 Jun 2019 02:05:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 30 Jun 2019 02:05:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=GtAf1OLMNdDETsUJG
        msUNbfhGWQUWz+5LYFrZ8QvfTc=; b=AiBY606PrHBf2oOPJaZgKxtr6/asPD8Ib
        54lGYN6FU+hVP22j89HwNTzd+CjlPlDGC9WVJd1MRobZXFiAJ7lWT/PWF2EMu/am
        wWF4xb5V5xiryyq9D1MaGZNQp7HKSNWTzCwbAlY96gypKOaatDA0Rodd0bUafyhu
        NQ+hbTYr9O3Ysaj5z9crumAKhUbVlOKPLaT1LDgcPiVFvoOTUYTD/B+TEaOETimC
        E01LoGFBP/W8b4GrdB3HaGDMT5Fzqr0oGzOgAtbdirmEvRfYFbEO85R7kpbGH/vI
        B7NqtWpeWJzektpg/s+EuIoqZYUVA+PD4xeOnswNqOIR4rvuoZaYg==
X-ME-Sender: <xms:N1EYXT5BGxLzeMhe7WT4tOk8QDGCfJvPz4VP0n7HLIKKZataVXdRHw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrvdefgddutddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:N1EYXdJwhbzbCGfmnpuWduhCWS-5ocvLrAJ54ENs4MYA9Mf5j5kJQw>
    <xmx:N1EYXVeicAe4oCBnSF4CxElYot4mOWtTecNXxmG3T6AUq1bwTEOzHw>
    <xmx:N1EYXYdSAoblgc2eRjUKA4gueBSn9YW4ncQuCZ44oS3d1l6CFFUgbw>
    <xmx:OFEYXRKR2vxMMe9sMUXGXKe7boEFTjJeBqeOPzHHYp3YhWgmfZyrKw>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id A4B7F8005A;
        Sun, 30 Jun 2019 02:05:41 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, richardcochran@gmail.com, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 00/16] mlxsw: PTP timestamping support
Date:   Sun, 30 Jun 2019 09:04:44 +0300
Message-Id: <20190630060500.7882-1-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

This is the second patchset adding PTP support in mlxsw. Next patchset
will add PTP shapers which are required to maintain accuracy under rates
lower than 40Gb/s, while subsequent patchsets will add tracepoints and
selftests.

Petr says:

This patch set introduces support for retrieving and processing hardware
timestamps for PTP packets.

The way PTP timestamping works on Spectrum-1 is that there are two queues
associated with each front panel port. When a packet is timestamped, the
timestamp is put to one of the queues: timestamps for transmitted packets
to one and for received packets to the other. Activity on these queues is
signaled through the events PTP_ING_FIFO and PTP_EGR_FIFO.

Packets themselves arrive through two traps: PTP0 and PTP1. It is possible
to configure which PTP messages should be trapped under which PTP trap. On
Spectrum systems, mlxsw will use PTP0 for event messages (which need
timestamping), and PTP1 for general messages (which do not).

There are therefore four relevant traps: receive of PTP event resp. general
message, and receive of timestamp for a transmitted resp. received PTP
packet. The obvious point where to put the new logic is a custom listener
to the mentioned traps.

Besides handling ingress traffic (be in packets or timestamps), the driver
also needs to handle timestamping of transmitted packets. One option would
be to invoke the relevant logic from mlxsw_core_ptp_transmitted(). However
on Spectrum-2, the timestamps are actually delivered through the completion
queue, and for that reason this patchset opts to invoke the logic from the
PCI code, via core and the driver, to a chip-specific operation. That way
the invocation will be done in a place where a Spectrum-2 implementation
will have an opportunity to extract the timestamp.

As indicated above, the PTP FIFO signaling happens independently from
packet delivery. A packet corresponding to any given timestamp could be
delivered sooner or later than the timestamp itself. Additionally, the
queues are only four elements deep, and it is therefore possible that the
timestamp for a delivered packet never arrives at all. Similarly a PTP
packet might be dropped due to CPU traffic pressure, and never be delivered
even if the corresponding timestamp was.

The driver thus needs to hold a cache of as-yet-unmatched SKBs and
timestamps. The first piece to arrive (be it timestamp or SKB) is put to
this cache. When the other piece arrives, the timestamp is attached to the
SKB and that is passed on. A delayed work is run at regular intervals to
prune the old unmatched entries.

As mentioned above, the mechanism for timestamp delivery changes on
Spectrum-2, where timestamps are part of completion queue elements, and all
packets are timestamped. All this bookkeeping is therefore unnecessary on
Spectrum-2. For this reason, this patchset spends some time introducing
Spectrum-1 specific artifacts such as a possibility to register a given
trap only on Spectrum-1.

Patches #1-#4 describe new registers.

Patches #5 and #6 introduce the possibility to register certain traps
only on some systems. The list of Spectrum-1 specific traps is left empty
at this point.

Patch #7 hooks into packet receive path by registering PTP traps
and appropriate handlers (that however do nothing of substance yet).

Patch #8 adds a helper to allow storing custom data to SKB->cb.

Patch #9 adds a call into the PCI completion queue handler that invokes,
via core and spectrum code, a PTP transmit handler. (Which also does not do
anything interesting yet.)

Patch #10 introduces code to invoke PTP initialization and adds data types
for the cache of unmatched entries.

Patches #11 and #12 implement the timestamping itself. In #11, the PHC
spin_locks are converted to _bh variants, because unlike normal PHC path,
which runs in process context, timestamp processing runs as soft interrupt.
Then #12 introduces the code for saving and retrieval of unmatched entries,
invokes PTP classifier to identify packets of interest, registers timestamp
FIFO events, and handles decoding and attaching timestamps to packets.

Patch #13 introduces a garbage collector for left-behind entries that have
not been matched for about a second.

In patch #14, PTP message types are configured to arrive as PTP0
(events) or PTP1 (everything else) as appropriate. At this point, the PTP
packets start arriving through the traps, but because PTP is disabled and
there is no way to enable it yet, they are always just passed to the usual
receive path right away.

Finally patches #15 and #16 add the plumbing to actually make it possible
to enable this code through SIOCSHWTSTAMP ioctl, and to advertise the
hardware timestamping capabilities through ethtool.

v2:
- Patch #12:
    - In mlxsw_sp1_ptp_fifo_event_func(), post-increment when iterating over PTP
      FIFO records.
- Patch #14:
    - Change namespace of message type enumerators from MLXSW_ to MLXSW_SP_.

Petr Machata (16):
  mlxsw: reg: Add Monitoring Time Precision Packet Port Configuration
    Register
  mlxsw: reg: Add Monitoring Precision Time Protocol Trap Register
  mlxsw: reg: Add Time Precision Packet Timestamping Reading
  mlxsw: reg: Add Monitoring Global Configuration Register
  mlxsw: spectrum: Extract a helper for trap registration
  mlxsw: spectrum: Add support for traps specific to Spectrum-1
  mlxsw: spectrum: PTP: Hook into packet receive path
  mlxsw: core: Add support for using SKB control buffer
  mlxsw: pci: PTP: Hook into packet transmit path
  mlxsw: spectrum: PTP: Add PTP initialization / finalization
  mlxsw: spectrum: PTP: Disable BH when working with PHC
  mlxsw: spectrum: PTP: Support timestamping on Spectrum-1
  mlxsw: spectrum: PTP: Garbage-collect unmatched entries
  mlxsw: spectrum: PTP: Configure PTP traps and FIFO events
  mlxsw: spectrum: PTP: Support SIOCGHWTSTAMP, SIOCSHWTSTAMP ioctls
  mlxsw: spectrum: PTP: Support ethtool get_ts_info

 drivers/net/ethernet/mellanox/mlxsw/Kconfig   |   1 +
 drivers/net/ethernet/mellanox/mlxsw/core.c    |   9 +
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  19 +
 drivers/net/ethernet/mellanox/mlxsw/pci.c     |  17 +-
 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 216 ++++++
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 290 ++++++-
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  11 +
 .../ethernet/mellanox/mlxsw/spectrum_ptp.c    | 711 +++++++++++++++++-
 .../ethernet/mellanox/mlxsw/spectrum_ptp.h    | 136 +++-
 .../net/ethernet/mellanox/mlxsw/switchx2.c    |   2 +
 drivers/net/ethernet/mellanox/mlxsw/trap.h    |   6 +
 11 files changed, 1378 insertions(+), 40 deletions(-)

-- 
2.20.1


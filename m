Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45CBA1167BA
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 08:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbfLIH4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 02:56:45 -0500
Received: from mga05.intel.com ([192.55.52.43]:35290 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727122AbfLIH4p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 02:56:45 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Dec 2019 23:56:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,294,1571727600"; 
   d="scan'208";a="362846859"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO localhost.localdomain) ([10.249.32.126])
  by orsmga004.jf.intel.com with ESMTP; 08 Dec 2019 23:56:41 -0800
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org, saeedm@mellanox.com,
        jeffrey.t.kirsher@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com
Subject: [PATCH bpf-next 00/12] xsk: clean up ring access functions
Date:   Mon,  9 Dec 2019 08:56:17 +0100
Message-Id: <1575878189-31860-1-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set cleans up the ring access functions of AF_XDP in hope
that it will now be easier to understand and maintain. I used to get a
headache every time I looked at this code in order to really understand it,
but now I do think it is a lot less painful.

The code has been simplified a lot and as a bonus we get better
performance. On my 2.0 GHz Broadwell machine with a standard default
config plus AF_XDP support and CONFIG_PREEMPT on I get the following
results in percent performance increases with this patch set compared
to without it:

Zero-copy (-N):
          rxdrop        txpush        l2fwd
1 core:     4%            5%            4%
2 cores:    1%            0%            2%

Zero-copy with poll() (-N -p):
          rxdrop        txpush        l2fwd
1 core:     1%            3%            3%
2 cores:   22%            0%            5%

Skb mode (-S):
Shows a 0% to 1% performance improvement over the same benchmarks as
above.

Here 1 core means that we are running the driver processing and the
application on the same core, while 2 cores means that they execute on
separate cores. The applications are from the xdpsock sample app.

When a results says 22% better, as in the case of poll mode with 2
cores and rxdrop, my first reaction is that it must be a
bug. Everything else shows between 0% and 5% performance
improvement. What is giving rise to 22%? A quick bisect indicates that
it is patches 2, 3, 4, 5, and 6 that are giving rise to most of this
improvement. So not one patch in particular, but something around 4%
improvement from each one of them. Note that exactly this benchmark
has previously had an extraordinary slow down compared to when running
without poll syscalls. For all the other poll tests above, the
slowdown has always been around 4% for using poll syscalls. But with
the bad performing test in question, it was above 25%. Interestingly,
after this clean up, the slow down is 4%, just like all the other poll
tests. Please take an extra peek at this so I have not messed up
something.

The 0% for txpush with two cores is due to the test bottlenecking on
a non-CPU HW resource. If I eliminated that bottleneck on my system,
I would expect to see an increase there too.

This patch has been applied against commit e7096c131e51 ("net: WireGuard secure network tunnel")

Structure of the patch set:

Patch 1: Eliminate the lazy update threshold used when preallocating
         entries in the completion ring
Patch 2: Consolidate the two local producer pointers into one
Patch 3: Standardize the naming of the producer ring access functions
Patch 4: Simplify the detection of empty and full rings
Patch 5: Eliminate the Rx batch size used for the fill ring
Patch 6: Simplify the functions xskq_nb_avail and xskq_nb_free
Patch 7: Simplify and standardize the naming of the consumer ring
         access functions
Patch 8: Change the names of the validation functions to improve
         readability and also the return value of these functions
Patch 9: Change the name of xsk_umem_discard_addr() to
         xsk_umem_release_addr() to better reflect the new
         names. Requires a name change in the drivers that support AF_XDP
         zero-copy.
Patch 10: Remove unnecessary READ_ONCE of data in the ring
Patch 11: Add overall function naming comment and reorder the functions
          for easier reference
Patch 12: Use the struct_size helper function when allocating rings

Thanks: Magnus

Magnus Karlsson (12):
  xsk: eliminate the lazy update threshold
  xsk: consolidate to one single cached producer pointer
  xsk: standardize naming of producer ring access functions
  xsk: simplify detection of empty and full rings
  xsk: eliminate the RX batch size
  xsk: simplify xskq_nb_avail and xskq_nb_free
  xsk: simplify the consumer ring access functions
  xsk: change names of validation functions
  xsk: ixgbe: i40e: ice: mlx5: xsk_umem_discard_addr to
    xsk_umem_release_addr
  xsk: remove unnecessary READ_ONCE of data
  xsk: add function naming comments and reorder functions
  xsk: use struct_size() helper

 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |   4 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |   4 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.c    |   2 +-
 include/net/xdp_sock.h                             |  14 +-
 net/xdp/xsk.c                                      |  62 ++--
 net/xdp/xsk_queue.c                                |  15 +-
 net/xdp/xsk_queue.h                                | 370 +++++++++++----------
 8 files changed, 245 insertions(+), 230 deletions(-)

--
2.7.4

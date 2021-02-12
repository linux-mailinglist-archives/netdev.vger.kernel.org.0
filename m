Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7233B31A7ED
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 23:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbhBLWmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 17:42:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:44260 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231991AbhBLWjn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 17:39:43 -0500
IronPort-SDR: YtQO7SkhYR1NpspnBZqvThSqx9yOcmdQx+8fQqN1tuUmczhgnMl1oaKa+cXqbZ/mVVMYGcudlT
 JWHnRdmR66SQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9893"; a="169617152"
X-IronPort-AV: E=Sophos;i="5.81,174,1610438400"; 
   d="scan'208";a="169617152"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 14:38:59 -0800
IronPort-SDR: T26hi3q1bW4anj61wzKRY4tZm758cX2YV6RptCAXheiD+tDbzpAxtbNyQ7PgbQBzV9R66jPLEV
 /neruZYcAlJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,174,1610438400"; 
   d="scan'208";a="381885342"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 12 Feb 2021 14:38:59 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com
Subject: [PATCH net-next 00/11][pull request] 40GbE Intel Wired LAN Driver Updates 2021-02-12
Date:   Fri, 12 Feb 2021 14:39:41 -0800
Message-Id: <20210212223952.1172568-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to i40e, ice, and ixgbe drivers.

Maciej does cleanups on the following drivers.
For i40e, removes redundant check for XDP prog, cleans up no longer
relevant information, and removes an unused function argument.
For ice, removes local variable use, instead returning values directly.
Moves skb pointer from buffer to ring and removes an unneeded check for
xdp_prog in zero copy path. Also removes a redundant MTU check when
changing it.
For i40e, ice, and ixgbe, stores the rx_offset in the Rx ring as
the value is constant so there's no need for continual calls.

Bjorn folds a decrement into a while statement.

The following are changes since commit 3c5a2fd042d0bfac71a2dfb99515723d318df47b:
  tcp: Sanitize CMSG flags and reserved args in tcp_zerocopy_receive.
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 40GbE

Björn Töpel (1):
  i40e: Simplify the do-while allocation loop

Maciej Fijalkowski (10):
  i40e: drop redundant check when setting xdp prog
  i40e: drop misleading function comments
  i40e: adjust i40e_is_non_eop
  ice: simplify ice_run_xdp
  ice: move skb pointer from rx_buf to rx_ring
  ice: remove redundant checks in ice_change_mtu
  ice: skip NULL check against XDP prog in ZC path
  i40e: store the result of i40e_rx_offset() onto i40e_ring
  ice: store the result of ice_rx_offset() onto ice_ring
  ixgbe: store the result of ixgbe_rx_offset() onto ixgbe_ring

 drivers/net/ethernet/intel/i40e/i40e_main.c   |  3 -
 drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 91 ++++++-------------
 drivers/net/ethernet/intel/i40e/i40e_txrx.h   |  1 +
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    |  4 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |  9 --
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 88 ++++++++----------
 drivers/net/ethernet/intel/ice/ice_txrx.h     |  3 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c      |  7 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h      |  1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 15 +--
 10 files changed, 86 insertions(+), 136 deletions(-)

-- 
2.26.2


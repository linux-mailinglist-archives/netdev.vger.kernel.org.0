Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F25949B82D
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 17:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357660AbiAYQHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 11:07:09 -0500
Received: from mga18.intel.com ([134.134.136.126]:4805 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378583AbiAYQFl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jan 2022 11:05:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643126734; x=1674662734;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CnlZMqcGxfG17qng5ojVFTXiEjhmUc0dIKX37XwxteY=;
  b=NXZH8XDYE9V2+g878bP1LL80LHE60iwU3Qr9s/ll2y5q+jFBfpRluADw
   3AJFlscxA+PsPv9GEGhKjx4h+ox+SfFQmMGYdIRqouvm4WQUvBSRcYwKj
   G+p1D/J/wtwMgnZ+y2NlTDJ7NaRc/gUJ9eXmNY1e6wUHRnyAr1RAgZxW0
   PqFslbJykRqxX4ckm7CdNrKuh9JTrv06bLnSPh71CmbzwS3fZAXxcbwLE
   P15WSGK2NupXClmRKFm2rYfxWMkzkZyyiaBVbucoSNGVTLOzMu9RjRB9T
   Qqk3LAeMLBdp0hY1h2frOsHrf/RcvtPAEYFHb1TCDKgUP8ZSP2f2oLNh9
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10237"; a="229911548"
X-IronPort-AV: E=Sophos;i="5.88,315,1635231600"; 
   d="scan'208";a="229911548"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 08:04:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,315,1635231600"; 
   d="scan'208";a="534789198"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga008.jf.intel.com with ESMTP; 25 Jan 2022 08:04:48 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v5 bpf-next 0/8] xsk: Intel driver improvements
Date:   Tue, 25 Jan 2022 17:04:38 +0100
Message-Id: <20220125160446.78976-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Unfortunately, similar scalability issues that were addressed for XDP
processing in ice, exist for XDP in the zero-copy driver used by AF_XDP.
Let's resolve them in mostly the same way as we did in [0] and utilize
the Tx batching API from XSK buffer pool.

Move the array of Tx descriptors that is used with batching approach to
the XSK buffer pool. This means that future users of this API will not
have carry the array on their own side, they can simple refer to pool's
tx_desc array.

We also improve the Rx side where we extend ice_alloc_rx_buf_zc() to
handle the ring wrap and bump Rx tail more frequently. By doing so,
Rx side is adjusted to Tx and it was needed for l2fwd scenario.

Here are the improvements of performance numbers that this set brings
measured with xdpsock app in busy poll mode for 1 and 2 core modes.
Both Tx and Rx rings were sized to 1k length and busy poll budget was
256.

----------------------------------------------------------------
     |      txonly:      |      l2fwd      |      rxdrop
----------------------------------------------------------------
1C   |       149%        |       14%       |        3%
----------------------------------------------------------------
2C   |       134%        |       20%       |        5%
----------------------------------------------------------------

Next step will be to introduce batching onto Rx side.


v5:
* collect acks
* fix typos
* correct comments showing cache line boundaries in ice_tx_ring struct
v4 - address Alexandr's review:
* new patch (2) for making sure ring size is pow(2) when attaching
  xsk socket
* don't open code ALIGN_DOWN (patch 3)
* resign from storing tx_thresh in ice_tx_ring (patch 4)
* scope variables in a better way for Tx batching (patch 7)
v3:
* drop likely() that was wrapping napi_complete_done (patch 1)
* introduce configurable Tx threshold (patch 2)
* handle ring wrap on Rx side when allocating buffers (patch 3)
* respect NAPI budget when cleaning Tx descriptors in ZC (patch 6)
v2:
* introduce new patch that resets @next_dd and @next_rs fields
* use batching API for AF_XDP Tx on ice side

Thanks,
Maciej

[0]: https://lore.kernel.org/bpf/20211015162908.145341-8-anthony.l.nguyen@intel.com/


Maciej Fijalkowski (7):
  ice: remove likely for napi_complete_done
  ice: xsk: force rings to be sized to power of 2
  ice: xsk: handle SW XDP ring wrap and bump tail more often
  ice: make Tx threshold dependent on ring length
  ice: xsk: avoid potential dead AF_XDP Tx processing
  ice: xsk: improve AF_XDP ZC Tx and use batching API
  ice: xsk: borrow xdp_tx_active logic from i40e

Magnus Karlsson (1):
  i40e: xsk: move tmp desc array from driver to pool

 drivers/net/ethernet/intel/i40e/i40e_txrx.c   |  11 -
 drivers/net/ethernet/intel/i40e/i40e_txrx.h   |   1 -
 drivers/net/ethernet/intel/i40e/i40e_xsk.c    |   4 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |   2 +
 drivers/net/ethernet/intel/ice/ice_main.c     |   4 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c     |   6 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h     |  10 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  15 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c      | 374 ++++++++++++------
 drivers/net/ethernet/intel/ice/ice_xsk.h      |  27 +-
 include/net/xdp_sock_drv.h                    |   5 +-
 include/net/xsk_buff_pool.h                   |   1 +
 net/xdp/xsk.c                                 |  13 +-
 net/xdp/xsk_buff_pool.c                       |   7 +
 net/xdp/xsk_queue.h                           |  12 +-
 15 files changed, 330 insertions(+), 162 deletions(-)

-- 
2.33.1


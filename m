Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431BB495EBA
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 13:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350190AbiAUMAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 07:00:42 -0500
Received: from mga01.intel.com ([192.55.52.88]:36375 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348969AbiAUMAj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jan 2022 07:00:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642766439; x=1674302439;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zdk96Zk52dXWNRzGR0+mbBMfATC+DA02xij7Rn3fxho=;
  b=a19uhQhuol+hpsrxpOucR1FNdVG/6SPojepn+4Uq5tJWgFLbaFGvUS9P
   ib1Z8Fut6CgVUg9iOL9zUcbgi4deoAa97A01g2yeAZzhWOEhCtxiirqJ8
   TWTqmvcc1c40OkcOoNTp7OCWrG6AJHH8MTHzO3I3GYM1kx9lBnkbG/ROA
   oSlWFmkLMoHoWgEMiyozmtyNUeK/CMaoiXE0VtJNLOA8lFqu3senLjjd6
   vC+0PQIQe34XIfISHYBogYclnL+weoywwpOJcMrN63FiHgdzrCr4H/tXf
   tyDgepObssuADBJ11z1f33HdShC8KJJ1GwNidBhijB80E2qKB7aNfyIzK
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10233"; a="270058943"
X-IronPort-AV: E=Sophos;i="5.88,304,1635231600"; 
   d="scan'208";a="270058943"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2022 04:00:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,304,1635231600"; 
   d="scan'208";a="475924931"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga003.jf.intel.com with ESMTP; 21 Jan 2022 04:00:27 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v3 bpf-next 0/7] xsk: Intel driver improvements
Date:   Fri, 21 Jan 2022 13:00:04 +0100
Message-Id: <20220121120011.49316-1-maciej.fijalkowski@intel.com>
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
the Tx batching API from xsk buffer pool.

Move the array of Tx descriptors that is used with batching approach to
the xsk buffer pool. This means that future users of this API will not
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

Maciej Fijalkowski (6):
  ice: remove likely for napi_complete_done
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
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |   3 +
 drivers/net/ethernet/intel/ice/ice_main.c     |   5 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c     |   7 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h     |  12 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  15 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c      | 366 ++++++++++++------
 drivers/net/ethernet/intel/ice/ice_xsk.h      |  27 +-
 include/net/xdp_sock_drv.h                    |   5 +-
 include/net/xsk_buff_pool.h                   |   1 +
 net/xdp/xsk.c                                 |  13 +-
 net/xdp/xsk_buff_pool.c                       |   7 +
 net/xdp/xsk_queue.h                           |  12 +-
 15 files changed, 327 insertions(+), 162 deletions(-)

-- 
2.33.1


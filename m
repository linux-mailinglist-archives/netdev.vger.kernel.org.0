Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1C7EF021
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 23:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729965AbfKDW0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 17:26:05 -0500
Received: from mga17.intel.com ([192.55.52.151]:57657 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730512AbfKDVv0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 16:51:26 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Nov 2019 13:51:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,268,1569308400"; 
   d="scan'208";a="219818347"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by FMSMGA003.fm.intel.com with ESMTP; 04 Nov 2019 13:51:26 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com
Subject: [net-next v2 0/9][pull request] 100GbE Intel Wired LAN Driver Updates 2019-11-04
Date:   Mon,  4 Nov 2019 13:51:16 -0800
Message-Id: <20191104215125.16745-1-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains updates to the ice driver only.

Anirudh refactors the code to reduce the kernel configuration flags and
introduces ice_base.c file.

Maciej does additional refactoring on the configuring of transmit
rings so that we are not configuring per each traffic class flow.
Added support for XDP in the ice driver.  Provides additional
re-organizing of the code in preparation for adding build_skb() support
in the driver.  Adjusted the computational padding logic for headroom
and tailroom to better support build_skb(), which also aligns with the
logic in other Intel LAN drivers.  Added build_skb support and make use
of the XDP's data_meta.

Krzysztof refactors the driver to prepare for AF_XDP support in the
driver and then adds support for AF_XDP.

v2: Updated patch 3 of the series based on community feedback with the
    following changes...
    - return -EOPNOTSUPP instead of ENOTSUPP for too large MTU which makes
      it impossible to attach XDP prog
    - don't check for case when there's no XDP prog currently on interface
      and ice_xdp() is called with NULL bpf_prog; this happens when user
      does "ip link set eth0 xdp off" and no prog is present on VSI; no need
      for that as it is handled by higher layer
    - drop the extack message for unknown xdp->command
    - use the smp_processor_id() for accessing the XDP Tx ring for XDP_TX
      action
    - don't leave the interface in downed state in case of any failure
      during the XDP Tx resources handling
    - undo rename of ice_build_ctob
    The above changes caused a ripple effect in patches 4 & 5 to update
    references to ice_build_ctob() which are now build_ctob()

The following are changes since commit 1574cf83c7a069f5f29295170ed8a568ccebcb7b:
  Merge tag 'mlx5-updates-2019-11-01' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Anirudh Venkataramanan (1):
  ice: Introduce ice_base.c

Krzysztof Kazimierczak (2):
  ice: Move common functions to ice_txrx_lib.c
  ice: Add support for AF_XDP

Maciej Fijalkowski (6):
  ice: get rid of per-tc flow in Tx queue configuration routines
  ice: Add support for XDP
  ice: introduce legacy Rx flag
  ice: introduce frame padding computation logic
  ice: add build_skb() support
  ice: allow 3k MTU for XDP

 drivers/net/ethernet/intel/ice/Makefile       |    3 +
 drivers/net/ethernet/intel/ice/ice.h          |   59 +-
 drivers/net/ethernet/intel/ice/ice_base.c     |  857 ++++++++++++
 drivers/net/ethernet/intel/ice/ice_base.h     |   31 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h  |    1 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c  |   65 +-
 drivers/net/ethernet/intel/ice/ice_lib.c      |  984 ++------------
 drivers/net/ethernet/intel/ice/ice_lib.h      |   49 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |  355 +++++
 drivers/net/ethernet/intel/ice/ice_txrx.c     |  573 ++++----
 drivers/net/ethernet/intel/ice/ice_txrx.h     |  140 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  273 ++++
 drivers/net/ethernet/intel/ice/ice_txrx_lib.h |   59 +
 .../net/ethernet/intel/ice/ice_virtchnl_pf.c  |    1 +
 drivers/net/ethernet/intel/ice/ice_xsk.c      | 1181 +++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_xsk.h      |   72 +
 16 files changed, 3553 insertions(+), 1150 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_base.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_base.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_txrx_lib.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_txrx_lib.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_xsk.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_xsk.h

-- 
2.21.0


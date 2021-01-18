Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDEBA2FA48B
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 16:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393400AbhARPXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 10:23:44 -0500
Received: from mga02.intel.com ([134.134.136.20]:63476 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393385AbhARPXi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 10:23:38 -0500
IronPort-SDR: +c8B0rwdhkq4K96qMGidGCM6JpnmI1zGu1yrm+dTxoGUYeVBFFhti+C5iqqIFAMR19r+9gG8h1
 UQS/UY0NGrew==
X-IronPort-AV: E=McAfee;i="6000,8403,9867"; a="165905494"
X-IronPort-AV: E=Sophos;i="5.79,356,1602572400"; 
   d="scan'208";a="165905494"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2021 07:22:54 -0800
IronPort-SDR: 30U+n3iALOaiOFOL0prCiNqmVU7aJdQXT673T12J5TqN9XBUB1MyWda2biRUzwwEgeXgH/N75M
 QecKOdeERX0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,356,1602572400"; 
   d="scan'208";a="500676287"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga004.jf.intel.com with ESMTP; 18 Jan 2021 07:22:52 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v3 net-next 00/11] intel driver cleanups
Date:   Mon, 18 Jan 2021 16:13:07 +0100
Message-Id: <20210118151318.12324-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series is mostly about the cleanups on Rx (ZC/normal) paths both in
ice and i40e drivers. Things that stand out are the simplifactions of
ice_change_mtu and i40e_xdp_setup.

Third iteration of this includes patches that optimize the handling of
*_rx_offset() calls per each processed frame. Some cycles can be saved
by storing the result of that function onto rx ring. For that, I am
using existing holes within ring structs (checked with pahole).

Thanks!

v3: rebase, fix handling rx offset
v2: fix kdoc in patch 5 (Jakub)


Björn Töpel (1):
  i40e, xsk: Simplify the do-while allocation loop

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
2.20.1


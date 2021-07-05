Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17AF93BC1DF
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 18:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbhGERAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 13:00:34 -0400
Received: from mga05.intel.com ([192.55.52.43]:50091 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229652AbhGERAe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Jul 2021 13:00:34 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10036"; a="294646398"
X-IronPort-AV: E=Sophos;i="5.83,325,1616482800"; 
   d="scan'208";a="294646398"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2021 09:57:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,325,1616482800"; 
   d="scan'208";a="562686263"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga001.fm.intel.com with ESMTP; 05 Jul 2021 09:57:54 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn@kernel.org,
        magnus.karlsson@intel.com, joamaki@gmail.com, toke@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 intel-next 0/4] XDP_TX improvements for ice
Date:   Mon,  5 Jul 2021 18:43:34 +0200
Message-Id: <20210705164338.58313-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this is a second revision of a series around XDP_TX improvements for ice
driver. When compared to v1 (which can be found under [1]), two new
patches are introduced that are focused on improving the performance for
XDP_TX as Jussi reported that the numbers were pretty low on his side.
Furthermore the fallback path is now based on static branch, as
suggested by Toke on v1. This means that there's no further need for a
standalone net_device_ops that were serving the locked version of
ndo_xdp_xmit callback.

Idea from 2nd patch is borrowed from a joint work that was done against
OOT driver among with Sridhar Samudrala, Jesse Brandeburg and Piotr
Raczynski, where we working on fixing the scaling issues for Tx AF_XDP
ZC path.

Last but not least, with this series I observe the improvement of
performance by around 30%.

Thanks!
Maciej

[1] : https://lore.kernel.org/bpf/20210601113236.42651-1-maciej.fijalkowski@intel.com/

Maciej Fijalkowski (4):
  ice: unify xdp_rings accesses
  ice: optimize XDP_TX descriptor processing
  ice: do not create xdp_frame on XDP_TX
  ice: introduce XDP_TX fallback path

 drivers/net/ethernet/intel/ice/ice.h          |   3 +
 drivers/net/ethernet/intel/ice/ice_lib.c      |   4 +-
 drivers/net/ethernet/intel/ice/ice_main.c     |  45 ++++++-
 drivers/net/ethernet/intel/ice/ice_txrx.c     | 123 +++++++++++++++---
 drivers/net/ethernet/intel/ice/ice_txrx.h     |   6 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c |  29 +++--
 drivers/net/ethernet/intel/ice/ice_txrx_lib.h |  16 +++
 7 files changed, 190 insertions(+), 36 deletions(-)

-- 
2.20.1


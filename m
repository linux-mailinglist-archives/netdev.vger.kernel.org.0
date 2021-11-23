Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F383045AA00
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 18:24:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239261AbhKWR1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 12:27:55 -0500
Received: from mga14.intel.com ([192.55.52.115]:2272 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239224AbhKWR1y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 12:27:54 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10177"; a="235306877"
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="235306877"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 09:20:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,258,1631602800"; 
   d="scan'208";a="606890295"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga004.jf.intel.com with ESMTP; 23 Nov 2021 09:20:11 -0800
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 1ANHK9Qe024401;
        Tue, 23 Nov 2021 17:20:09 GMT
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/9] intel: switch to napi_build_skb()
Date:   Tue, 23 Nov 2021 18:18:31 +0100
Message-Id: <20211123171840.157471-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

napi_build_skb() I introduced earlier this year ([0]) aims
to decrease MM pressure and the overhead from in-place
kmem_cache_alloc() on each Rx entry processing by decaching
skbuff_heads from NAPI per-cpu cache filled prior to that by
napi_consume_skb() (so it is sort of a direct shortcut for
free -> mm -> alloc cycle).
Currently, no in-tree drivers use it. Switch all Intel Ethernet
drivers to it to get slight-to-medium perf boosts depending on
the frame size.

ice driver, 50 Gbps link, pktgen + XDP_PASS (local in) sample:

frame_size/nthreads  64/42  128/20  256/8  512/4  1024/2  1532/1

net-next (Kpps)      46062  34654   18248  9830   5343    2714
series               47438  34708   18330  9875   5435    2777
increase             2.9%   0.15%   0.45%  0.46%  1.72%   2.32%

Additionally, e1000's been switched to napi_consume_skb() as it's
safe and works fine there, and there's no point in napi_build_skb()
without paired NAPI cache feeding point.

[0] https://lore.kernel.org/all/20210213141021.87840-1-alobakin@pm.me

Alexander Lobakin (9):
  e1000: switch to napi_consume_skb()
  e1000: switch to napi_build_skb()
  i40e: switch to napi_build_skb()
  iavf: switch to napi_build_skb()
  ice: switch to napi_build_skb()
  igb: switch to napi_build_skb()
  igc: switch to napi_build_skb()
  ixgbe: switch to napi_build_skb()
  ixgbevf: switch to napi_build_skb()

 drivers/net/ethernet/intel/e1000/e1000_main.c     | 14 ++++++++------
 drivers/net/ethernet/intel/i40e/i40e_txrx.c       |  2 +-
 drivers/net/ethernet/intel/iavf/iavf_txrx.c       |  2 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c         |  2 +-
 drivers/net/ethernet/intel/igb/igb_main.c         |  2 +-
 drivers/net/ethernet/intel/igc/igc_main.c         |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c     |  2 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |  2 +-
 8 files changed, 15 insertions(+), 13 deletions(-)

--
2.33.1


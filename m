Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71524480C38
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 18:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233509AbhL1R7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 12:59:04 -0500
Received: from mga02.intel.com ([134.134.136.20]:41226 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233510AbhL1R7D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Dec 2021 12:59:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640714343; x=1672250343;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Pm9V+H+w7mFBiPTYdaWXp7OKXIO31fdNqQ+iRRpAv+E=;
  b=LFrSzE1a1mKfl2PmX132KmDx3CLsGlaZFiqaRgHiKOzgCcpEpa6Bxwwy
   31/KAfd8AoJM1UTmgHyM7KAUzpweUfvVAibXpfRbDtAzUhxQMYp+/bybD
   yxmcOMBtu2DjRIElNgMhW+rp+cZNsYhMM4/ThuZCN+2PY1/aZBUXn9GDl
   2ZGvD5t9Na2kqfMpA5AORBu4oftBjZIg1et0T6unPrbocv3fDrHz2LpMN
   sHBCZLEsLQeDOeocRKaQtQMmoLJT+Jv/jOUUGmxhYr6zhCpCxPSGKjyqL
   iaOZuK4BhDWWpGpcdUGu6P5DyEU5/clf47sgAfyx3yQ7MCOBOXGdM1/Ko
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10211"; a="228705143"
X-IronPort-AV: E=Sophos;i="5.88,242,1635231600"; 
   d="scan'208";a="228705143"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2021 09:59:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,242,1635231600"; 
   d="scan'208";a="589071985"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 28 Dec 2021 09:59:02 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, netdev@vger.kernel.org,
        alexandr.lobakin@intel.com
Subject: [PATCH net-next 0/9][pull request] 10GbE Intel Wired LAN Driver Updates 2021-12-28
Date:   Tue, 28 Dec 2021 09:58:06 -0800
Message-Id: <20211228175815.281449-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Lobakin says:

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

The following are changes since commit 0f1eae8e565e632f64670a5730894f22819fcaad:
  net: caif: remove redundant assignment to variable expectlen
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 10GbE

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
2.31.1


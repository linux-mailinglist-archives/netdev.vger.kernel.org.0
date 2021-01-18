Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1DFC2FA4D4
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 16:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405950AbhARPce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 10:32:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:63476 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393446AbhARPYk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 10:24:40 -0500
IronPort-SDR: lpoVsIsfUiXb1fQlvyqoE4pOc7xx1xMBa/yaxLdXbGlfRROcbFokb0Jnwl2iFoj4hOGIB3fkK8
 +fCPEAUh2EeA==
X-IronPort-AV: E=McAfee;i="6000,8403,9867"; a="165905532"
X-IronPort-AV: E=Sophos;i="5.79,356,1602572400"; 
   d="scan'208";a="165905532"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2021 07:23:09 -0800
IronPort-SDR: Ia6Ihj9or7sidCKiG6tg7M2o7yrzuvbc58f8Xtvfp+12CwWNYl4xCIO+eqT8TacTkQHrsPbyWS
 FIejOUD/Gueg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,356,1602572400"; 
   d="scan'208";a="500676363"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga004.jf.intel.com with ESMTP; 18 Jan 2021 07:23:07 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v3 net-next 07/11] ice: skip NULL check against XDP prog in ZC path
Date:   Mon, 18 Jan 2021 16:13:14 +0100
Message-Id: <20210118151318.12324-8-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210118151318.12324-1-maciej.fijalkowski@intel.com>
References: <20210118151318.12324-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Whole zero-copy variant of clean Rx irq is executed when xsk_pool is
attached to rx_ring and it can happen only when XDP program is present
on interface. Therefore it is safe to assume that program is always
!NULL and there is no need for checking it in ice_run_xdp_zc.

Reviewed-by: Björn Töpel <bjorn.topel@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 1782146db644..b926ca9c4f4f 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -517,11 +517,10 @@ ice_run_xdp_zc(struct ice_ring *rx_ring, struct xdp_buff *xdp)
 	u32 act;
 
 	rcu_read_lock();
+	/* ZC patch is enabled only when XDP program is set,
+	 * so here it can not be NULL
+	 */
 	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
-	if (!xdp_prog) {
-		rcu_read_unlock();
-		return ICE_XDP_PASS;
-	}
 
 	act = bpf_prog_run_xdp(xdp_prog, xdp);
 	switch (act) {
-- 
2.20.1


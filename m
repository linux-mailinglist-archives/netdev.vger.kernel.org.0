Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A7C31A808
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 23:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbhBLWsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 17:48:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:44260 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232421AbhBLWoq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 17:44:46 -0500
IronPort-SDR: fax+gpGBdmalccQIQHh2/E5vmYEVCXTnFacF0qUk4bq5EJrF+2YmomwF5mswn01PrtboRVsL81
 4MGf6y4m8Rpw==
X-IronPort-AV: E=McAfee;i="6000,8403,9893"; a="169617164"
X-IronPort-AV: E=Sophos;i="5.81,174,1610438400"; 
   d="scan'208";a="169617164"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2021 14:39:01 -0800
IronPort-SDR: hU/Rp02VjOyd3uJj/Bf/ROKc/cndQ300xjrjgtdTHzysQ7dQlZBhw3s1D22LNX+nnxc44+vMGF
 vw+e5WzEfZCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,174,1610438400"; 
   d="scan'208";a="381885375"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 12 Feb 2021 14:39:01 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Kiran Bhandare <kiranx.bhandare@intel.com>
Subject: [PATCH net-next 07/11] ice: skip NULL check against XDP prog in ZC path
Date:   Fri, 12 Feb 2021 14:39:48 -0800
Message-Id: <20210212223952.1172568-8-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210212223952.1172568-1-anthony.l.nguyen@intel.com>
References: <20210212223952.1172568-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Whole zero-copy variant of clean Rx IRQ is executed when xsk_pool is
attached to rx_ring and it can happen only when XDP program is present
on interface. Therefore it is safe to assume that program is always
!NULL and there is no need for checking it in ice_run_xdp_zc.

Reviewed-by: Björn Töpel <bjorn.topel@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 875fa0cbef56..83f3c9574ed1 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -467,11 +467,10 @@ ice_run_xdp_zc(struct ice_ring *rx_ring, struct xdp_buff *xdp)
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
2.26.2


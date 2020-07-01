Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86DF21161E
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 00:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728087AbgGAWeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 18:34:36 -0400
Received: from mga18.intel.com ([134.134.136.126]:25457 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727992AbgGAWec (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 18:34:32 -0400
IronPort-SDR: IiLUCXveecKBUYWTaObY1kKUzBf6H7W+YRtdGDvYN2J+8+8uo18E9ENMnk9vzkiu4uoKGOdRBQ
 43/xI1vhreEw==
X-IronPort-AV: E=McAfee;i="6000,8403,9669"; a="134178607"
X-IronPort-AV: E=Sophos;i="5.75,302,1589266800"; 
   d="scan'208";a="134178607"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2020 15:34:22 -0700
IronPort-SDR: yjmeqsx2IpkhNL53XXXUbbafDyE2mBzSVcKtE1/6WhB9EAExk5uctKJ7Ly/myENf+FrDiznWO3
 g2HuUOumOn/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,302,1589266800"; 
   d="scan'208";a="455276123"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga005.jf.intel.com with ESMTP; 01 Jul 2020 15:34:22 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Ciara Loftus <ciara.loftus@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, anthony.nguyen@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [net-next 08/12] i40e: add XDP ring statistics to dump VSI debug output
Date:   Wed,  1 Jul 2020 15:34:08 -0700
Message-Id: <20200701223412.2675606-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200701223412.2675606-1-anthony.l.nguyen@intel.com>
References: <20200701223412.2675606-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ciara Loftus <ciara.loftus@intel.com>

Prior to this, only the Rx and Tx ring statistics were dumped. The XDP
ring statistics are now dumped as well.

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/i40e/i40e_debugfs.c    | 41 +++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
index 9cb9b781451c..41a4cf8e3d61 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
@@ -319,6 +319,47 @@ static void i40e_dbg_dump_vsi_seid(struct i40e_pf *pf, int seid)
 			 i, tx_ring->itr_setting,
 			 ITR_IS_DYNAMIC(tx_ring->itr_setting) ? "dynamic" : "fixed");
 	}
+	if (i40e_enabled_xdp_vsi(vsi)) {
+		for (i = 0; i < vsi->num_queue_pairs; i++) {
+			struct i40e_ring *xdp_ring = READ_ONCE(vsi->xdp_rings[i]);
+
+			if (!xdp_ring)
+				continue;
+
+			dev_info(&pf->pdev->dev,
+				 "    xdp_rings[%i]: state = %lu, queue_index = %d, reg_idx = %d\n",
+				 i, *xdp_ring->state,
+				 xdp_ring->queue_index,
+				 xdp_ring->reg_idx);
+			dev_info(&pf->pdev->dev,
+				 "    xdp_rings[%i]: next_to_use = %d, next_to_clean = %d, ring_active = %i\n",
+				 i,
+				 xdp_ring->next_to_use,
+				 xdp_ring->next_to_clean,
+				 xdp_ring->ring_active);
+			dev_info(&pf->pdev->dev,
+				 "    xdp_rings[%i]: tx_stats: packets = %lld, bytes = %lld, restart_queue = %lld\n",
+				 i, xdp_ring->stats.packets,
+				 xdp_ring->stats.bytes,
+				 xdp_ring->tx_stats.restart_queue);
+			dev_info(&pf->pdev->dev,
+				 "    xdp_rings[%i]: tx_stats: tx_busy = %lld, tx_done_old = %lld\n",
+				 i,
+				 xdp_ring->tx_stats.tx_busy,
+				 xdp_ring->tx_stats.tx_done_old);
+			dev_info(&pf->pdev->dev,
+				 "    xdp_rings[%i]: size = %i\n",
+				 i, xdp_ring->size);
+			dev_info(&pf->pdev->dev,
+				 "    xdp_rings[%i]: DCB tc = %d\n",
+				 i, xdp_ring->dcb_tc);
+			dev_info(&pf->pdev->dev,
+				 "    xdp_rings[%i]: itr_setting = %d (%s)\n",
+				 i, xdp_ring->itr_setting,
+				 ITR_IS_DYNAMIC(xdp_ring->itr_setting) ?
+				 "dynamic" : "fixed");
+		}
+	}
 	rcu_read_unlock();
 	dev_info(&pf->pdev->dev,
 		 "    work_limit = %d\n",
-- 
2.26.2


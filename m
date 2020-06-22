Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4425320377B
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 15:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728450AbgFVNHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 09:07:41 -0400
Received: from mga12.intel.com ([192.55.52.136]:14869 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728403AbgFVNHj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 09:07:39 -0400
IronPort-SDR: szHXWWdIuwfWOugNdNhkxa2GueqLyaJsyAxABzsL28Ptf5I3IiyegSMTL0sRZKCjOA1HvNKzrw
 k1Ymfc1AnUoQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9659"; a="123400595"
X-IronPort-AV: E=Sophos;i="5.75,266,1589266800"; 
   d="scan'208";a="123400595"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 06:07:39 -0700
IronPort-SDR: bvQ71dH41y3YW65ytrKt+Pi3AN0MgVr7GQ4WfnPtEg6D/p8p5Tlf2O4u/GbB7kimnjItoVd5AN
 /EePUlo04ISg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,266,1589266800"; 
   d="scan'208";a="318774412"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.8])
  by FMSMGA003.fm.intel.com with ESMTP; 22 Jun 2020 06:07:38 -0700
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH net-next 2/3] i40e: add xdp ring statistics to dump vsi debug output
Date:   Mon, 22 Jun 2020 12:46:23 +0000
Message-Id: <20200622124624.18847-2-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200622124624.18847-1-ciara.loftus@intel.com>
References: <20200622124624.18847-1-ciara.loftus@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prior to this, only the rx and tx ring statistics were dumped. The xdp
ring statistics are now dumped as well.

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
---
 .../net/ethernet/intel/i40e/i40e_debugfs.c    | 41 +++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
index 99ea543dd245..1c8285fce33f 100644
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
2.17.1


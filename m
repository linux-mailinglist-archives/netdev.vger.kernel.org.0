Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 868EAAAD1C
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 22:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404017AbfIEUeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 16:34:37 -0400
Received: from mga06.intel.com ([134.134.136.31]:45343 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391657AbfIEUeO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 16:34:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Sep 2019 13:34:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,471,1559545200"; 
   d="scan'208";a="267136548"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga001.jf.intel.com with ESMTP; 05 Sep 2019 13:34:10 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 07/16] ice: change work limit to a constant
Date:   Thu,  5 Sep 2019 13:33:57 -0700
Message-Id: <20190905203406.4152-8-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190905203406.4152-1-jeffrey.t.kirsher@intel.com>
References: <20190905203406.4152-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

The driver has supported a transmit work limit
that was configurable from ethtool for a long time, but
there are no good use cases for having it be a variable
that can be changed at run time.  In addition, this
variable was noted to be causing performance overhead
due to cache misses.

Just remove the variable and let the code use a constant
so that the functionality is maintained (a limit on the
number of transmits that will be cleaned in any one call
to the clean routines) without the cache miss.

Removes code, removes a variable, removes testing surface. Yay.

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h         |  3 ---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 14 ++------------
 drivers/net/ethernet/intel/ice/ice_lib.c     |  2 +-
 3 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index bbb3c290a0bf..c7f234688499 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -247,9 +247,6 @@ struct ice_vsi {
 	u16 vsi_num;			/* HW (absolute) index of this VSI */
 	u16 idx;			/* software index in pf->vsi[] */
 
-	/* Interrupt thresholds */
-	u16 work_lmt;
-
 	s16 vf_id;			/* VF ID for SR-IOV VSIs */
 
 	u16 ethtype;			/* Ethernet protocol for pause frame */
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index edba5bd79097..ae9921b7de7b 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3214,12 +3214,6 @@ __ice_get_coalesce(struct net_device *netdev, struct ethtool_coalesce *ec,
 	if (ice_get_q_coalesce(vsi, ec, q_num))
 		return -EINVAL;
 
-	if (q_num < vsi->num_txq)
-		ec->tx_max_coalesced_frames_irq = vsi->work_lmt;
-
-	if (q_num < vsi->num_rxq)
-		ec->rx_max_coalesced_frames_irq = vsi->work_lmt;
-
 	return 0;
 }
 
@@ -3399,17 +3393,13 @@ __ice_set_coalesce(struct net_device *netdev, struct ethtool_coalesce *ec,
 			if (ice_set_q_coalesce(vsi, ec, i))
 				return -EINVAL;
 		}
-		goto set_work_lmt;
+		goto set_complete;
 	}
 
 	if (ice_set_q_coalesce(vsi, ec, q_num))
 		return -EINVAL;
 
-set_work_lmt:
-
-	if (ec->tx_max_coalesced_frames_irq || ec->rx_max_coalesced_frames_irq)
-		vsi->work_lmt = max(ec->tx_max_coalesced_frames_irq,
-				    ec->rx_max_coalesced_frames_irq);
+set_complete:
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 6cc01ebc0b01..5f7c75c3b24b 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -548,8 +548,8 @@ ice_vsi_alloc(struct ice_pf *pf, enum ice_vsi_type type, u16 vf_id)
 	vsi->type = type;
 	vsi->back = pf;
 	set_bit(__ICE_DOWN, vsi->state);
+
 	vsi->idx = pf->next_vsi;
-	vsi->work_lmt = ICE_DFLT_IRQ_WORK;
 
 	if (type == ICE_VSI_VF)
 		ice_vsi_set_num_qs(vsi, vf_id);
-- 
2.21.0


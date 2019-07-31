Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 046447CEEB
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 22:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730949AbfGaUmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 16:42:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:2709 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726400AbfGaUlv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 16:41:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jul 2019 13:41:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,331,1559545200"; 
   d="scan'208";a="323901031"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga004.jf.intel.com with ESMTP; 31 Jul 2019 13:41:48 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Akeem G Abodunrin <akeem.g.abodunrin@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 09/16] ice: Set up Tx scheduling tree based on alloc VSI Tx queues
Date:   Wed, 31 Jul 2019 13:41:40 -0700
Message-Id: <20190731204147.8582-10-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190731204147.8582-1-jeffrey.t.kirsher@intel.com>
References: <20190731204147.8582-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>

This patch uses allocated number of Tx queues per VSI to set up its
scheduling tree instead of using total number of available Tx queues.
Only PF VSIs have total number of allocated Tx queues equal to number
of available Tx queues, other VSIs have different number of queues
configured.

Signed-off-by: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 01f38abd4277..e28478215810 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2511,7 +2511,7 @@ ice_vsi_setup(struct ice_pf *pf, struct ice_port_info *pi,
 
 	/* configure VSI nodes based on number of queues and TC's */
 	for (i = 0; i < vsi->tc_cfg.numtc; i++)
-		max_txqs[i] = pf->num_lan_tx;
+		max_txqs[i] = vsi->alloc_txq;
 
 	status = ice_cfg_vsi_lan(vsi->port_info, vsi->idx, vsi->tc_cfg.ena_tc,
 				 max_txqs);
@@ -3020,7 +3020,7 @@ int ice_vsi_rebuild(struct ice_vsi *vsi)
 
 	/* configure VSI nodes based on number of queues and TC's */
 	for (i = 0; i < vsi->tc_cfg.numtc; i++)
-		max_txqs[i] = pf->num_lan_tx;
+		max_txqs[i] = vsi->alloc_txq;
 
 	status = ice_cfg_vsi_lan(vsi->port_info, vsi->idx, vsi->tc_cfg.ena_tc,
 				 max_txqs);
@@ -3137,7 +3137,7 @@ int ice_vsi_cfg_tc(struct ice_vsi *vsi, u8 ena_tc)
 		if (ena_tc & BIT(i))
 			num_tc++;
 		/* populate max_txqs per TC */
-		max_txqs[i] = pf->num_lan_tx;
+		max_txqs[i] = vsi->alloc_txq;
 	}
 
 	vsi->tc_cfg.ena_tc = ena_tc;
-- 
2.21.0


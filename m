Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E93C311609
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 11:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbfEBJGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 05:06:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:47594 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726387AbfEBJG0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 05:06:26 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 May 2019 02:06:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,421,1549958400"; 
   d="scan'208";a="147615358"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 02 May 2019 02:06:24 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 09/15] ice: Remove unnecessary wait when disabling/enabling Rx queues
Date:   Thu,  2 May 2019 02:06:14 -0700
Message-Id: <20190502090620.21281-10-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190502090620.21281-1-jeffrey.t.kirsher@intel.com>
References: <20190502090620.21281-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

In ice_vsi_ctrl_rx_rings() we are unnecessarily waiting for
QRX_CTRL_QENA_REQ and QRX_CTRL_QENA_STAT to be the same value prior to
disabling each Rx queue. There is no reason to do this so remove
this wait loop as we already have a wait loop after disabling/enabling
the Rx queue through the QRX_CTRL register to make sure it gets
successfully disabled/enabled.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 4c6ecc25aaa0..8e0a23e6b563 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -197,19 +197,13 @@ static int ice_vsi_ctrl_rx_rings(struct ice_vsi *vsi, bool ena)
 {
 	struct ice_pf *pf = vsi->back;
 	struct ice_hw *hw = &pf->hw;
-	int i, j, ret = 0;
+	int i, ret = 0;
 
 	for (i = 0; i < vsi->num_rxq; i++) {
 		int pf_q = vsi->rxq_map[i];
 		u32 rx_reg;
 
-		for (j = 0; j < ICE_Q_WAIT_MAX_RETRY; j++) {
-			rx_reg = rd32(hw, QRX_CTRL(pf_q));
-			if (((rx_reg >> QRX_CTRL_QENA_REQ_S) & 1) ==
-			    ((rx_reg >> QRX_CTRL_QENA_STAT_S) & 1))
-				break;
-			usleep_range(1000, 2000);
-		}
+		rx_reg = rd32(hw, QRX_CTRL(pf_q));
 
 		/* Skip if the queue is already in the requested state */
 		if (ena == !!(rx_reg & QRX_CTRL_QENA_STAT_M))
-- 
2.20.1


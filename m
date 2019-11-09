Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39DB3F5C72
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 01:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbfKIAod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 19:44:33 -0500
Received: from mga09.intel.com ([134.134.136.24]:25215 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726281AbfKIAod (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 19:44:33 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Nov 2019 16:44:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,283,1569308400"; 
   d="scan'208";a="215111196"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga002.jf.intel.com with ESMTP; 08 Nov 2019 16:44:31 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Nicholas Nunley <nicholas.d.nunley@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net 2/6] iavf: initialize ITRN registers with correct values
Date:   Fri,  8 Nov 2019 16:44:26 -0800
Message-Id: <20191109004430.7219-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191109004430.7219-1-jeffrey.t.kirsher@intel.com>
References: <20191109004430.7219-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicholas Nunley <nicholas.d.nunley@intel.com>

Since commit 92418fb14750 ("i40e/i40evf: Use usec value instead of reg
value for ITR defines") the driver tracks the interrupt throttling
intervals in single usec units, although the actual ITRN registers are
programmed in 2 usec units. Most register programming flows in the driver
correctly handle the conversion, although it is currently not applied when
the registers are initialized to their default values. Most of the time
this doesn't present a problem since the default values are usually
immediately overwritten through the standard adaptive throttling mechanism,
or updated manually by the user, but if adaptive throttling is disabled and
the interval values are left alone then the incorrect value will persist.

Since the intended default interval of 50 usecs (vs. 100 usecs as
programmed) performs better for most traffic workloads, this can lead to
performance regressions.

This patch adds the correct conversion when writing the initial values to
the ITRN registers.

Signed-off-by: Nicholas Nunley <nicholas.d.nunley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 8f310e520b06..821987da5698 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -314,7 +314,7 @@ iavf_map_vector_to_rxq(struct iavf_adapter *adapter, int v_idx, int r_idx)
 	q_vector->rx.target_itr = ITR_TO_REG(rx_ring->itr_setting);
 	q_vector->ring_mask |= BIT(r_idx);
 	wr32(hw, IAVF_VFINT_ITRN1(IAVF_RX_ITR, q_vector->reg_idx),
-	     q_vector->rx.current_itr);
+	     q_vector->rx.current_itr >> 1);
 	q_vector->rx.current_itr = q_vector->rx.target_itr;
 }
 
@@ -340,7 +340,7 @@ iavf_map_vector_to_txq(struct iavf_adapter *adapter, int v_idx, int t_idx)
 	q_vector->tx.target_itr = ITR_TO_REG(tx_ring->itr_setting);
 	q_vector->num_ringpairs++;
 	wr32(hw, IAVF_VFINT_ITRN1(IAVF_TX_ITR, q_vector->reg_idx),
-	     q_vector->tx.target_itr);
+	     q_vector->tx.target_itr >> 1);
 	q_vector->tx.current_itr = q_vector->tx.target_itr;
 }
 
-- 
2.21.0


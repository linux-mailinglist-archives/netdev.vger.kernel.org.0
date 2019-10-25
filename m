Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 737BBE554D
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 22:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbfJYUmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 16:42:55 -0400
Received: from mga14.intel.com ([192.55.52.115]:63954 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728601AbfJYUmq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 16:42:46 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Oct 2019 13:42:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,229,1569308400"; 
   d="scan'208";a="202713969"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga006.jf.intel.com with ESMTP; 25 Oct 2019 13:42:44 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Nicholas Nunley <nicholas.d.nunley@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 5/9] i40e: initialize ITRN registers with correct values
Date:   Fri, 25 Oct 2019 13:42:38 -0700
Message-Id: <20191025204242.10535-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191025204242.10535-1-jeffrey.t.kirsher@intel.com>
References: <20191025204242.10535-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicholas Nunley <nicholas.d.nunley@intel.com>

Since commit 92418fb14750 ("i40e/i40evf: Use usec value instead of reg
value for ITR defines") the driver tracks the interrupt throttling
intervals in single usec units, although the actual ITRN/ITR0 registers are
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
 drivers/net/ethernet/intel/i40e/i40e_main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 6031223eafab..339925af0206 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -3534,14 +3534,14 @@ static void i40e_vsi_configure_msix(struct i40e_vsi *vsi)
 		q_vector->rx.target_itr =
 			ITR_TO_REG(vsi->rx_rings[i]->itr_setting);
 		wr32(hw, I40E_PFINT_ITRN(I40E_RX_ITR, vector - 1),
-		     q_vector->rx.target_itr);
+		     q_vector->rx.target_itr >> 1);
 		q_vector->rx.current_itr = q_vector->rx.target_itr;
 
 		q_vector->tx.next_update = jiffies + 1;
 		q_vector->tx.target_itr =
 			ITR_TO_REG(vsi->tx_rings[i]->itr_setting);
 		wr32(hw, I40E_PFINT_ITRN(I40E_TX_ITR, vector - 1),
-		     q_vector->tx.target_itr);
+		     q_vector->tx.target_itr >> 1);
 		q_vector->tx.current_itr = q_vector->tx.target_itr;
 
 		wr32(hw, I40E_PFINT_RATEN(vector - 1),
@@ -3646,11 +3646,11 @@ static void i40e_configure_msi_and_legacy(struct i40e_vsi *vsi)
 	/* set the ITR configuration */
 	q_vector->rx.next_update = jiffies + 1;
 	q_vector->rx.target_itr = ITR_TO_REG(vsi->rx_rings[0]->itr_setting);
-	wr32(hw, I40E_PFINT_ITR0(I40E_RX_ITR), q_vector->rx.target_itr);
+	wr32(hw, I40E_PFINT_ITR0(I40E_RX_ITR), q_vector->rx.target_itr >> 1);
 	q_vector->rx.current_itr = q_vector->rx.target_itr;
 	q_vector->tx.next_update = jiffies + 1;
 	q_vector->tx.target_itr = ITR_TO_REG(vsi->tx_rings[0]->itr_setting);
-	wr32(hw, I40E_PFINT_ITR0(I40E_TX_ITR), q_vector->tx.target_itr);
+	wr32(hw, I40E_PFINT_ITR0(I40E_TX_ITR), q_vector->tx.target_itr >> 1);
 	q_vector->tx.current_itr = q_vector->tx.target_itr;
 
 	i40e_enable_misc_int_causes(pf);
@@ -11396,7 +11396,7 @@ static int i40e_setup_misc_vector(struct i40e_pf *pf)
 
 	/* associate no queues to the misc vector */
 	wr32(hw, I40E_PFINT_LNKLST0, I40E_QUEUE_END_OF_LIST);
-	wr32(hw, I40E_PFINT_ITR0(I40E_RX_ITR), I40E_ITR_8K);
+	wr32(hw, I40E_PFINT_ITR0(I40E_RX_ITR), I40E_ITR_8K >> 1);
 
 	i40e_flush(hw);
 
-- 
2.21.0


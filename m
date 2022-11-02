Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7913616F61
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 22:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbiKBVK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 17:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231460AbiKBVKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 17:10:23 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7EE9E004
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 14:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667423419; x=1698959419;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JQFw7Dch3/pLJ3lAu7Y6ORmgniQJkQQHrfQAXEF0mew=;
  b=HjKWH3baplpC0AC9vNvXkVA00t93Qzu9VmRhQk1+txapA4pek5ALo5qQ
   hsKvzb/FH24w56uJu7NgDzVAP5eXgFmxesDJQx+9qSCNQm2C3bVbpgfs6
   ZT2RMjRC+lXBAlabsmu2fV32P9shUiJrMw7fUIYcYkfPsdlK8oHm5eyTE
   IEDNA4DbpPSN3ZQjMBc+6R6aTepSZHcQL2wZ/j0H1muNGSvWl2OEsVxEg
   BhgbDgSvlpK78evQdiO0TL6XR41b3hWOaoNc8D/8GjWiPmtU2WsSauA6o
   qf3XoZwBGZHVbrx1of6t+y6/q7zsAnDoxRpiwKbxbnCIMVRefWuNgKF/5
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="311245985"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="311245985"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 14:10:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="629102992"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="629102992"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 02 Nov 2022 14:10:18 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Joe Damato <jdamato@fastly.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 2/7] i40e: Record number TXes cleaned during NAPI
Date:   Wed,  2 Nov 2022 14:10:06 -0700
Message-Id: <20221102211011.2944983-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221102211011.2944983-1-anthony.l.nguyen@intel.com>
References: <20221102211011.2944983-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Damato <jdamato@fastly.com>

Update i40e_clean_tx_irq to take an out parameter (tx_cleaned) which stores
the number TXs cleaned.

No XDP related TX code is touched. Care has been taken to avoid changing
the control flow of i40e_clean_tx_irq and i40e_napi_poll.

Signed-off-by: Joe Damato <jdamato@fastly.com>
Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Acked-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index b97c95f89fa0..75a3218d94a3 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -923,11 +923,13 @@ void i40e_detect_recover_hung(struct i40e_vsi *vsi)
  * @vsi: the VSI we care about
  * @tx_ring: Tx ring to clean
  * @napi_budget: Used to determine if we are in netpoll
+ * @tx_cleaned: Out parameter set to the number of TXes cleaned
  *
  * Returns true if there's any budget left (e.g. the clean is finished)
  **/
 static bool i40e_clean_tx_irq(struct i40e_vsi *vsi,
-			      struct i40e_ring *tx_ring, int napi_budget)
+			      struct i40e_ring *tx_ring, int napi_budget,
+			      unsigned int *tx_cleaned)
 {
 	int i = tx_ring->next_to_clean;
 	struct i40e_tx_buffer *tx_buf;
@@ -1048,6 +1050,7 @@ static bool i40e_clean_tx_irq(struct i40e_vsi *vsi,
 		}
 	}
 
+	*tx_cleaned = total_packets;
 	return !!budget;
 }
 
@@ -2689,6 +2692,8 @@ int i40e_napi_poll(struct napi_struct *napi, int budget)
 			       container_of(napi, struct i40e_q_vector, napi);
 	struct i40e_vsi *vsi = q_vector->vsi;
 	struct i40e_ring *ring;
+	bool tx_clean_complete = true;
+	unsigned int tx_cleaned = 0;
 	bool clean_complete = true;
 	bool arm_wb = false;
 	int budget_per_ring;
@@ -2705,10 +2710,10 @@ int i40e_napi_poll(struct napi_struct *napi, int budget)
 	i40e_for_each_ring(ring, q_vector->tx) {
 		bool wd = ring->xsk_pool ?
 			  i40e_clean_xdp_tx_irq(vsi, ring) :
-			  i40e_clean_tx_irq(vsi, ring, budget);
+			  i40e_clean_tx_irq(vsi, ring, budget, &tx_cleaned);
 
 		if (!wd) {
-			clean_complete = false;
+			clean_complete = tx_clean_complete = false;
 			continue;
 		}
 		arm_wb |= ring->arm_wb;
-- 
2.35.1


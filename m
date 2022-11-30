Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48DB263E0F5
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 20:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbiK3Toh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 14:44:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbiK3Tn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 14:43:59 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 881B899F1E
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 11:43:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669837427; x=1701373427;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AeeEQ1eCFq0lIm/w8v3X4i8107NNYTByyH11V3SjCFw=;
  b=Y8VbJgnKLCQP6UMHUoPHxt3Vze2ryacfvpKOK/0VwLPifKl0C5g/UHDI
   bNFoIC4f0Q6Lnj0sEF7AkNSLrNpzATgU/VOr/Xb2l+mJv++JqrWCGkVmt
   WJywCGfADDVMAFKVF9laU4pFiRJsyExS8t82EWShfQEpfBUccT94hGlAK
   GnvIEz7IRD5Z3bohplYiGYifmUZq6FFs/qI6s0EhUEc0pYBQ/N0UGJnYx
   Fsx6ZTV11PIKkUrGczTLO8V1yRSk5/AuWRWEoMhxG9MVS+tS9g2Mk8WLV
   knfOpKyUVXu64wfCqyLfKY8wP0Z2Ob4QrvyW/rHBe02+hGMnw5fGgBfcz
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="303098437"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="303098437"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 11:43:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="818752316"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="818752316"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 30 Nov 2022 11:43:42 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        Siddaraju DH <siddaraju.dh@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 14/14] ice: reschedule ice_ptp_wait_for_offset_valid during reset
Date:   Wed, 30 Nov 2022 11:43:30 -0800
Message-Id: <20221130194330.3257836-15-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221130194330.3257836-1-anthony.l.nguyen@intel.com>
References: <20221130194330.3257836-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

If the ice_ptp_wait_for_offest_valid function is scheduled to run while the
driver is resetting, it will exit without completing calibration. The work
function gets scheduled by ice_ptp_port_phy_restart which will be called as
part of the reset recovery process.

It is possible for the first execution to occur before the driver has
completely cleared its resetting flags. Ensure calibration completes by
rescheduling the task until reset is fully completed.

Reported-by: Siddaraju DH <siddaraju.dh@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index bb3f5f952667..4b43d6f6279a 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1265,8 +1265,13 @@ static void ice_ptp_wait_for_offsets(struct kthread_work *work)
 	pf = ptp_port_to_pf(port);
 	hw = &pf->hw;
 
-	if (ice_is_reset_in_progress(pf->state))
+	if (ice_is_reset_in_progress(pf->state)) {
+		/* wait for device driver to complete reset */
+		kthread_queue_delayed_work(pf->ptp.kworker,
+					   &port->ov_work,
+					   msecs_to_jiffies(100));
 		return;
+	}
 
 	tx_err = ice_ptp_check_tx_fifo(port);
 	if (!tx_err)
-- 
2.35.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE006647827
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 22:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiLHVkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 16:40:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiLHVjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 16:39:55 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 788EF2FBD4
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 13:39:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670535584; x=1702071584;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jobfXkyQ+o9W5PKQEuU2Ae4yV/TuvCybM74G/Q8Bx14=;
  b=Jdp4JYb8DkRhsBMO2yCx6u7nRqeZDSRWkgLpgW6GQ73pSWOTpqOhvlCr
   /5zHhBMLWJm+bCb61Vh63h9IWXMYa/LVnrrQBq/28qqtMojxjiB4QQG1X
   rb4gxDqZ6otIWEsOcc+J2bXntwA7TGcNPWhCzGEXydpR/JpvCkIg6NZvJ
   2h32hdJl4kIhpkiSSXhszl5dWBtpyxiijX1tpKCqrAnKMK/4dXBNgWvLc
   ZQ4FtbWLYPVc0FX/zqMCphS/nAxFKsEfqd3yo8x7IPna08nZ+aBKn3R30
   CkOKWJGjH+bnG/Uc0NU1NA6m+QRQnDX727TBpJxl1ykdAc8zp6gbtdWts
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="317328237"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="317328237"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 13:39:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="624874009"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="624874009"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 08 Dec 2022 13:39:40 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        leon@kernel.org, saeed@kernel.org,
        Siddaraju DH <siddaraju.dh@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next v3 14/14] ice: reschedule ice_ptp_wait_for_offset_valid during reset
Date:   Thu,  8 Dec 2022 13:39:32 -0800
Message-Id: <20221208213932.1274143-15-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221208213932.1274143-1-anthony.l.nguyen@intel.com>
References: <20221208213932.1274143-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index 7b5120906d3f..d63161d73eb1 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1240,8 +1240,13 @@ static void ice_ptp_wait_for_offsets(struct kthread_work *work)
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


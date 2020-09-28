Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08DE927B3CF
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 19:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgI1R7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 13:59:44 -0400
Received: from mga18.intel.com ([134.134.136.126]:32952 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726596AbgI1R7a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 13:59:30 -0400
IronPort-SDR: VDXQyWNLEz9GNx5Cysy9xq/LxmHfUc9jZLfSJqjdFAJCV2xMT7enfaWVb2KxOSDicAQg7jxtpX
 KmqFGqG1rVjw==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="149810270"
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="149810270"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 10:59:22 -0700
IronPort-SDR: y7nK3rcxrHpoItfUv0jTnnhYiF9ERVZkat+sxBaMwJEOL6SBW+LpMi01l8Qao/3ImOqokB0U8R
 ei16c6l0V4Zw==
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="340505396"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 10:59:21 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next 09/15] igc: Remove references to SYSTIMR register
Date:   Mon, 28 Sep 2020 10:59:02 -0700
Message-Id: <20200928175908.318502-10-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200928175908.318502-1-anthony.l.nguyen@intel.com>
References: <20200928175908.318502-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

In i225, it's no longer necessary to use the SYSTIMR register to
latch the timer value, the timestamp is latched when SYSTIML is read.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ptp.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 61852c99815d..0300b45b36e2 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -22,11 +22,7 @@ static void igc_ptp_read_i225(struct igc_adapter *adapter,
 	struct igc_hw *hw = &adapter->hw;
 	u32 sec, nsec;
 
-	/* The timestamp latches on lowest register read. For I210/I211, the
-	 * lowest register is SYSTIMR. Since we only need to provide nanosecond
-	 * resolution, we can ignore it.
-	 */
-	rd32(IGC_SYSTIMR);
+	/* The timestamp is latched when SYSTIML is read. */
 	nsec = rd32(IGC_SYSTIML);
 	sec = rd32(IGC_SYSTIMH);
 
@@ -39,9 +35,6 @@ static void igc_ptp_write_i225(struct igc_adapter *adapter,
 {
 	struct igc_hw *hw = &adapter->hw;
 
-	/* Writing the SYSTIMR register is not necessary as it only
-	 * provides sub-nanosecond resolution.
-	 */
 	wr32(IGC_SYSTIML, ts->tv_nsec);
 	wr32(IGC_SYSTIMH, ts->tv_sec);
 }
@@ -102,10 +95,9 @@ static int igc_ptp_gettimex64_i225(struct ptp_clock_info *ptp,
 	spin_lock_irqsave(&igc->tmreg_lock, flags);
 
 	ptp_read_system_prets(sts);
-	rd32(IGC_SYSTIMR);
-	ptp_read_system_postts(sts);
 	ts->tv_nsec = rd32(IGC_SYSTIML);
 	ts->tv_sec = rd32(IGC_SYSTIMH);
+	ptp_read_system_postts(sts);
 
 	spin_unlock_irqrestore(&igc->tmreg_lock, flags);
 
-- 
2.26.2


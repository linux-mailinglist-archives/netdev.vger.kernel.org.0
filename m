Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCC7C4FFC27
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 19:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237231AbiDMRNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 13:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237292AbiDMRNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 13:13:30 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7305E5EBC9
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 10:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649869868; x=1681405868;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pNTLhHKOxT8SGdcvuhw7SM977fNcmq8REgmGR3PBQOM=;
  b=kNCS9otc5K2Vr0MZbOQypphv2+wvgG4FNmviHmomksfKBBAwYTrKVc0Q
   74vos0E78eR1Uvh6MQHuHsul7i4VMmfmIb/piJ5l7eX3n4LNsl7vgszh3
   CAP78Me+j4zbSbLFq1KrrS1jVC8OJDPUtIZmFKfIsIJ/PveZNgBKf1PAp
   SLEKIsBPfsihXDsJp8v2+D9vLHsKotLKzy68TGoq6J07usaJ5bT8M5dIF
   9TsyJgDfXeK8+oBPkD/sYRthOhXZWaUE6qidxI3zpsAs1CzM6cLTTz0IP
   w+nS8UNbBhDH4LCRgbsSD4nYdSP+LayCiUAFYHoe0TNdGwtmt9QvMhb//
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10316"; a="349158019"
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="349158019"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2022 10:11:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,257,1643702400"; 
   d="scan'208";a="573360510"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 13 Apr 2022 10:11:05 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Dima Ruinskiy <dima.ruinskiy@intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net 1/4] igc: Fix infinite loop in release_swfw_sync
Date:   Wed, 13 Apr 2022 10:08:11 -0700
Message-Id: <20220413170814.2066855-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220413170814.2066855-1-anthony.l.nguyen@intel.com>
References: <20220413170814.2066855-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

An infinite loop may occur if we fail to acquire the HW semaphore,
which is needed for resource release.
This will typically happen if the hardware is surprise-removed.
At this stage there is nothing to do, except log an error and quit.

Fixes: c0071c7aa5fe ("igc: Add HW initialization code")
Suggested-by: Dima Ruinskiy <dima.ruinskiy@intel.com>
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_i225.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_i225.c b/drivers/net/ethernet/intel/igc/igc_i225.c
index 66ea566488d1..59d5c467ea6e 100644
--- a/drivers/net/ethernet/intel/igc/igc_i225.c
+++ b/drivers/net/ethernet/intel/igc/igc_i225.c
@@ -156,8 +156,15 @@ void igc_release_swfw_sync_i225(struct igc_hw *hw, u16 mask)
 {
 	u32 swfw_sync;
 
-	while (igc_get_hw_semaphore_i225(hw))
-		; /* Empty */
+	/* Releasing the resource requires first getting the HW semaphore.
+	 * If we fail to get the semaphore, there is nothing we can do,
+	 * except log an error and quit. We are not allowed to hang here
+	 * indefinitely, as it may cause denial of service or system crash.
+	 */
+	if (igc_get_hw_semaphore_i225(hw)) {
+		hw_dbg("Failed to release SW_FW_SYNC.\n");
+		return;
+	}
 
 	swfw_sync = rd32(IGC_SW_FW_SYNC);
 	swfw_sync &= ~mask;
-- 
2.31.1


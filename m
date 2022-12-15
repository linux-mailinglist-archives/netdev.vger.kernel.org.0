Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F50064E47D
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 00:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiLOXJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 18:09:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbiLOXI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 18:08:57 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAAE44A078
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 15:08:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671145735; x=1702681735;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M6aEPPZHJ9fMscoYq6DuPoDMxlfBZHdgi2iq15wYtV0=;
  b=fTgaMaLejsrnBZwwk/eogWmvqOybS/NERm4bxiNj0wiX6RXTdsdrj1WU
   PomtNc3FQCa5ojHvR6najtPOy5C+9awPM3vmJtJAGt9Ge+g/KbaIAfL5j
   dnOm7f+vCMZCBsym+sfKrGD62lAPSzKVhPSmIDEU6SRoWWWwu5YdtRIC8
   HEynpN7OD5YyvIN6r5ymS498qNCfjrvq29B3zfA/OllnBy8oplQ9Zoliy
   BLeRZnEFqvrK1oWjrjW9LlvJAuPciALk4+v38wmsuPruo9qWamiIhzFUW
   qDt4mCGMaoIKlj0GvXUC0WEpclqbunWT86+18lj21ZO8jF1kqS3jCYCE+
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="316469440"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="316469440"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2022 15:08:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="718172570"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="718172570"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga004.fm.intel.com with ESMTP; 15 Dec 2022 15:08:08 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tan Tee Min <tee.min.tan@linux.intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sasha.neftin@intel.com,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net 5/6] igc: recalculate Qbv end_time by considering cycle time
Date:   Thu, 15 Dec 2022 15:07:57 -0800
Message-Id: <20221215230758.3595578-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221215230758.3595578-1-anthony.l.nguyen@intel.com>
References: <20221215230758.3595578-1-anthony.l.nguyen@intel.com>
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

From: Tan Tee Min <tee.min.tan@linux.intel.com>

Qbv users can specify a cycle time that is not equal to the total GCL
intervals. Hence, recalculation is necessary here to exclude the time
interval that exceeds the cycle time. As those GCL which exceeds the
cycle time will be truncated.

According to IEEE Std. 802.1Q-2018 section 8.6.9.2, once the end of
the list is reached, it will switch to the END_OF_CYCLE state and
leave the gates in the same state until the next cycle is started.

Fixes: ec50a9d437f0 ("igc: Add support for taprio offloading")
Signed-off-by: Tan Tee Min <tee.min.tan@linux.intel.com>
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 6c98f3402f8c..86e46208d95c 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6067,6 +6067,21 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
 
 		end_time += e->interval;
 
+		/* If any of the conditions below are true, we need to manually
+		 * control the end time of the cycle.
+		 * 1. Qbv users can specify a cycle time that is not equal
+		 * to the total GCL intervals. Hence, recalculation is
+		 * necessary here to exclude the time interval that
+		 * exceeds the cycle time.
+		 * 2. According to IEEE Std. 802.1Q-2018 section 8.6.9.2,
+		 * once the end of the list is reached, it will switch
+		 * to the END_OF_CYCLE state and leave the gates in the
+		 * same state until the next cycle is started.
+		 */
+		if (end_time > adapter->cycle_time ||
+		    n + 1 == qopt->num_entries)
+			end_time = adapter->cycle_time;
+
 		for (i = 0; i < adapter->num_tx_queues; i++) {
 			struct igc_ring *ring = adapter->tx_ring[i];
 
-- 
2.35.1


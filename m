Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D573E6436CC
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 22:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233946AbiLEVZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 16:25:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233431AbiLEVYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 16:24:34 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D362CC99
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 13:24:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670275472; x=1701811472;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=a2uLCOBAQXL0ck5XzCFYertwfNsVUQBEFPCOy3vhzBE=;
  b=HxFPp5ByU4BPUGHliZk5+yimB5bZqEeBTIQeJy/gm6pvWJLnK3mEfA3F
   YMMdOlFT5sXcuLJWKUVIHIBafPmHVfAxBw4rL+LtVylZDBgs20u1UjPgw
   s8F+cUnQ0wrfm5XHNc1zDAMQjcYzB++H54JprYFXZq8HNyPn1ge0G0HiC
   yg0TDw5VdBl9Hl/ry4zguvqFuKGhAUDT2iEa7V76jbQuL1YiLgFCHxsXE
   eTsPaTDAMqU0OCHv/42tFcTRdbsGhit1vC/+D1BsxxlKI6/SqfShhydlS
   fFgq1WMWj4k+dVV5NsAB2fEs5gICXDO23e+vx2nWsJii/wGVcZZjQVIHj
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="296157814"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="296157814"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2022 13:24:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="734744962"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="734744962"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Dec 2022 13:24:29 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tan Tee Min <tee.min.tan@linux.intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sasha.neftin@intel.com,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net-next 4/8] igc: recalculate Qbv end_time by considering cycle time
Date:   Mon,  5 Dec 2022 13:24:10 -0800
Message-Id: <20221205212414.3197525-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221205212414.3197525-1-anthony.l.nguyen@intel.com>
References: <20221205212414.3197525-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

Signed-off-by: Tan Tee Min <tee.min.tan@linux.intel.com>
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 35c473703950..5aa72eac2a35 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -5952,6 +5952,21 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
 
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


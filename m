Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1C256436D1
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 22:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233960AbiLEVZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 16:25:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233419AbiLEVYf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 16:24:35 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 794FC2CCA0
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 13:24:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670275472; x=1701811472;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qjc2dkoqDB72Fmn18inb4ahL1Kq2cHM4/kWsEbIR+uc=;
  b=E1XkR/SDwVbTi5H44UBWnCp3m7DNkd9Ro5LPPiBkysBhgj2iMlRXQ+E3
   kS2SjIShCBiSZ0dKkUcS5kUeUIjGWVRB4wD+jZadrkJBsQy/NL1fGF0NN
   EdSD8n2b2MHtZSnplq4Gpw1nfem1OcU2JntsJ3BEQPyGM6wGnLb84W9s7
   pjlglkpoPUg1u0yYCTjsZ60jFmTcJ2mizD87wN17sibl+TU8VGEXiAPv5
   J4O2YY1NTXYTxMR/1ZECmy25IjbLIxSLSoZdPXTxWsUQXmSY2c9fGsu9e
   umSDPuwgQTcq5DXJV1VDqfYsysyRWXUQ3BLQR07n8IlFboNIGyuX7hcPJ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="296157831"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="296157831"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2022 13:24:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10552"; a="734744970"
X-IronPort-AV: E=Sophos;i="5.96,220,1665471600"; 
   d="scan'208";a="734744970"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Dec 2022 13:24:30 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Tan Tee Min <tee.min.tan@linux.intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sasha.neftin@intel.com,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net-next 6/8] igc: Set Qbv start_time and end_time to end_time if not being configured in GCL
Date:   Mon,  5 Dec 2022 13:24:12 -0800
Message-Id: <20221205212414.3197525-7-anthony.l.nguyen@intel.com>
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

The default setting of end_time minus start_time is whole 1 second.
Thus, if it's not being configured in any GCL entry then it will be
staying at original 1 second.

This patch is changing the start_time and end_time to be end_time as
if setting zero will be having weird HW behavior where the gate will
not be fully closed.

Signed-off-by: Tan Tee Min <tee.min.tan@linux.intel.com>
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 480b814dc18c..e9cd306ac79c 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -5929,6 +5929,7 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
 	struct igc_hw *hw = &adapter->hw;
 	u32 start_time = 0, end_time = 0;
 	size_t n;
+	int i;
 
 	adapter->qbv_enable = qopt->enable;
 
@@ -5949,7 +5950,6 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
 
 	for (n = 0; n < qopt->num_entries; n++) {
 		struct tc_taprio_sched_entry *e = &qopt->entries[n];
-		int i;
 
 		end_time += e->interval;
 
@@ -5988,6 +5988,18 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
 		start_time += e->interval;
 	}
 
+	/* Check whether a queue gets configured.
+	 * If not, set the start and end time to be end time.
+	 */
+	for (i = 0; i < adapter->num_tx_queues; i++) {
+		if (!queue_configured[i]) {
+			struct igc_ring *ring = adapter->tx_ring[i];
+
+			ring->start_time = end_time;
+			ring->end_time = end_time;
+		}
+	}
+
 	return 0;
 }
 
-- 
2.35.1


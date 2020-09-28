Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8457327B888
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 01:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727214AbgI1Xzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 19:55:46 -0400
Received: from mga17.intel.com ([192.55.52.151]:45599 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727186AbgI1Xzo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 19:55:44 -0400
IronPort-SDR: PyrEwJAe6UWtlKEu7uO7WzL6yj7jFZJS4gkv5J8OCV5t1GU7pLotQ3qvahZpmiBf6TX5mAdFhw
 OOuduSmfQO8w==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="142086323"
X-IronPort-AV: E=Sophos;i="5.77,315,1596524400"; 
   d="scan'208";a="142086323"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 14:50:29 -0700
IronPort-SDR: vNBusu56BoHpyuQ8iEifmodVjn/m180gRUg0gXFqWjodfJ26K8XhwHWZZ1eBoAtVP8pYVZ/GK4
 UraohE3FWTjQ==
X-IronPort-AV: E=Sophos;i="5.77,315,1596524400"; 
   d="scan'208";a="311962108"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 14:50:28 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next v2 05/15] igc: Don't reschedule ptp_tx work
Date:   Mon, 28 Sep 2020 14:50:08 -0700
Message-Id: <20200928215018.952991-6-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200928215018.952991-1-anthony.l.nguyen@intel.com>
References: <20200928215018.952991-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

The ptp_tx work is scheduled only if TSICR.TXTS bit is set, therefore
TSYNCTXCTL.TXTT_0 bit is expected to be set when we check it igc_ptp_tx_
work(). If it isn't, something is really off and rescheduling the ptp_tx
work to check it later doesn't help much. This patch changes the code to
WARN_ON_ONCE() if this situation ever happens.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ptp.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index dbe0776a7f2f..791f406f1314 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -429,11 +429,10 @@ static void igc_ptp_tx_work(struct work_struct *work)
 	}
 
 	tsynctxctl = rd32(IGC_TSYNCTXCTL);
-	if (tsynctxctl & IGC_TSYNCTXCTL_TXTT_0)
-		igc_ptp_tx_hwtstamp(adapter);
-	else
-		/* reschedule to check later */
-		schedule_work(&adapter->ptp_tx_work);
+	if (WARN_ON_ONCE(!(tsynctxctl & IGC_TSYNCTXCTL_TXTT_0)))
+		return;
+
+	igc_ptp_tx_hwtstamp(adapter);
 }
 
 /**
-- 
2.26.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFD327B3C6
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 19:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgI1R7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 13:59:24 -0400
Received: from mga18.intel.com ([134.134.136.126]:32955 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726589AbgI1R7X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 13:59:23 -0400
IronPort-SDR: 37Tb5VMicQflNaKgZG2Vcu9WGH3es7Bx16M9WyyiDBJfy2AFUnkMpQFCmBfzA061OzO8aEwOnx
 e/RXJWcbUuOw==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="149810267"
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="149810267"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 10:59:22 -0700
IronPort-SDR: bYfoeWydflDOV/axbhkozq5NOwP/Y08voM5vmMQoHL5CC4ZSNYuJ/VNEKjqSK+JTVlLr4jr3PN
 AaO25uQxT+lA==
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="340505386"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 10:59:21 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next 06/15] igc: Remove timeout check from ptp_tx work
Date:   Mon, 28 Sep 2020 10:58:59 -0700
Message-Id: <20200928175908.318502-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200928175908.318502-1-anthony.l.nguyen@intel.com>
References: <20200928175908.318502-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

The Tx timestamp timeout is already checked by the watchdog_task
which runs periodically. In addition to that, from the ptp_tx work
perspective, if __IGC_PTP_TX_IN_PROGRESS flag is set we always want
handle the timestamp stored in hardware and update the skb. So remove
the timeout check in igc_ptp_tx_work() function.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ptp.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 791f406f1314..61852c99815d 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -422,12 +422,6 @@ static void igc_ptp_tx_work(struct work_struct *work)
 	if (!test_bit(__IGC_PTP_TX_IN_PROGRESS, &adapter->state))
 		return;
 
-	if (time_is_before_jiffies(adapter->ptp_tx_start +
-				   IGC_PTP_TX_TIMEOUT)) {
-		igc_ptp_tx_timeout(adapter);
-		return;
-	}
-
 	tsynctxctl = rd32(IGC_TSYNCTXCTL);
 	if (WARN_ON_ONCE(!(tsynctxctl & IGC_TSYNCTXCTL_TXTT_0)))
 		return;
-- 
2.26.2


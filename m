Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E08371D4009
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 23:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbgENVbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 17:31:22 -0400
Received: from mga05.intel.com ([192.55.52.43]:5472 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726316AbgENVbU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 17:31:20 -0400
IronPort-SDR: hdUoFiN6TBNxbVX4S0pGb9p+6juPTdmCFNBWxsVBRCn+FXivXJMbu1ZcMDbFoxGShlU0d1NFw2
 O+P4mAghTLfw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2020 14:31:19 -0700
IronPort-SDR: gAeF8oRXyHO+o/tre/ZVgeUjaeUm2BrrjvK2mdmWGXZ/CtNzfjDDebuPFhcpZrv02R3LAZGN6x
 grY+s/rr3nVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,392,1583222400"; 
   d="scan'208";a="438069913"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga005.jf.intel.com with ESMTP; 14 May 2020 14:31:18 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 5/9] igc: Use netdev log helpers in igc_ptp.c
Date:   Thu, 14 May 2020 14:31:13 -0700
Message-Id: <20200514213117.4099065-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200514213117.4099065-1-jeffrey.t.kirsher@intel.com>
References: <20200514213117.4099065-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

In igc_ptp.c we print log messages using dev_* helpers, generating
inconsistent output with the rest of the driver. Since this is a network
device driver, we should preferably use netdev_* helpers because they
append the interface name to the message, helping making sense out of
the logs.

This patch converts all dev_* calls to netdev_*. It also takes this
opportunity to remove the '\n' character at the end of messages since it
is automatically added by netdev_* log helpers.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ptp.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index f99c514ad0f4..1bf016398b9d 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -466,7 +466,7 @@ void igc_ptp_tx_hang(struct igc_adapter *adapter)
 		 * interrupt
 		 */
 		rd32(IGC_TXSTMPH);
-		dev_warn(&adapter->pdev->dev, "clearing Tx timestamp hang\n");
+		netdev_warn(adapter->netdev, "Clearing Tx timestamp hang\n");
 	}
 }
 
@@ -529,7 +529,7 @@ static void igc_ptp_tx_work(struct work_struct *work)
 		 * interrupt
 		 */
 		rd32(IGC_TXSTMPH);
-		dev_warn(&adapter->pdev->dev, "clearing Tx timestamp hang\n");
+		netdev_warn(adapter->netdev, "Clearing Tx timestamp hang\n");
 		return;
 	}
 
@@ -626,10 +626,9 @@ void igc_ptp_init(struct igc_adapter *adapter)
 						&adapter->pdev->dev);
 	if (IS_ERR(adapter->ptp_clock)) {
 		adapter->ptp_clock = NULL;
-		dev_err(&adapter->pdev->dev, "ptp_clock_register failed\n");
+		netdev_err(netdev, "ptp_clock_register failed\n");
 	} else if (adapter->ptp_clock) {
-		dev_info(&adapter->pdev->dev, "added PHC on %s\n",
-			 adapter->netdev->name);
+		netdev_info(netdev, "PHC added\n");
 		adapter->ptp_flags |= IGC_PTP_ENABLED;
 	}
 }
@@ -666,8 +665,7 @@ void igc_ptp_stop(struct igc_adapter *adapter)
 
 	if (adapter->ptp_clock) {
 		ptp_clock_unregister(adapter->ptp_clock);
-		dev_info(&adapter->pdev->dev, "removed PHC on %s\n",
-			 adapter->netdev->name);
+		netdev_info(adapter->netdev, "PHC removed\n");
 		adapter->ptp_flags &= ~IGC_PTP_ENABLED;
 	}
 }
-- 
2.26.2


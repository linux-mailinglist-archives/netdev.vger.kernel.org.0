Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A830F131C3E
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 00:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbgAFXUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 18:20:08 -0500
Received: from mga05.intel.com ([192.55.52.43]:21026 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727339AbgAFXUD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jan 2020 18:20:03 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jan 2020 15:20:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,404,1571727600"; 
   d="scan'208";a="303013030"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.74])
  by orsmga001.jf.intel.com with ESMTP; 06 Jan 2020 15:20:00 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 5/5] igc: Use Start of Packet signal from PHY for timestamping
Date:   Mon,  6 Jan 2020 15:19:56 -0800
Message-Id: <20200106231956.549255-6-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200106231956.549255-1-jeffrey.t.kirsher@intel.com>
References: <20200106231956.549255-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

For better accuracy, i225 is able to do timestamping using the Start of
Packet signal from the PHY.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_defines.h | 2 ++
 drivers/net/ethernet/intel/igc/igc_ptp.c     | 5 ++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index 586fa14098eb..2121fc34e300 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -395,6 +395,7 @@
 #define IGC_TSYNCRXCTL_TYPE_EVENT_V2	0x0A
 #define IGC_TSYNCRXCTL_ENABLED		0x00000010  /* enable Rx timestamping */
 #define IGC_TSYNCRXCTL_SYSCFI		0x00000020  /* Sys clock frequency */
+#define IGC_TSYNCRXCTL_RXSYNSIG		0x00000400  /* Sample RX tstamp in PHY sop */
 
 /* Time Sync Receive Configuration */
 #define IGC_TSYNCRXCFG_PTP_V1_CTRLT_MASK	0x000000FF
@@ -418,6 +419,7 @@
 #define IGC_TSYNCTXCTL_SYNC_COMP_ERR		0x20000000  /* sync err */
 #define IGC_TSYNCTXCTL_SYNC_COMP		0x40000000  /* sync complete */
 #define IGC_TSYNCTXCTL_START_SYNC		0x80000000  /* initiate sync */
+#define IGC_TSYNCTXCTL_TXSYNSIG			0x00000020  /* Sample TX tstamp in PHY sop */
 
 /* Receive Checksum Control */
 #define IGC_RXCSUM_CRCOFL	0x00000800   /* CRC32 offload enable */
diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 79ffb833aa80..693506587198 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -368,6 +368,7 @@ static int igc_ptp_set_timestamp_mode(struct igc_adapter *adapter,
 	if (tsync_rx_ctl) {
 		tsync_rx_ctl = IGC_TSYNCRXCTL_ENABLED;
 		tsync_rx_ctl |= IGC_TSYNCRXCTL_TYPE_ALL;
+		tsync_rx_ctl |= IGC_TSYNCRXCTL_RXSYNSIG;
 		config->rx_filter = HWTSTAMP_FILTER_ALL;
 		is_l2 = true;
 		is_l4 = true;
@@ -384,8 +385,10 @@ static int igc_ptp_set_timestamp_mode(struct igc_adapter *adapter,
 		}
 	}
 
-	if (tsync_tx_ctl)
+	if (tsync_tx_ctl) {
 		tsync_tx_ctl = IGC_TSYNCTXCTL_ENABLED;
+		tsync_tx_ctl |= IGC_TSYNCTXCTL_TXSYNSIG;
+	}
 
 	/* enable/disable TX */
 	regval = rd32(IGC_TSYNCTXCTL);
-- 
2.24.1


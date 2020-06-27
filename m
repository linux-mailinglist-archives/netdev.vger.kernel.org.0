Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45EC620BDA9
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 03:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgF0Byo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 21:54:44 -0400
Received: from mga03.intel.com ([134.134.136.65]:29248 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726486AbgF0Byl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 21:54:41 -0400
IronPort-SDR: 2ImOny+07ZVov9GbxrMgNJk5YbM9SlEup+9WjnmO0rJxeFGDNOY4vY7yv3Di5rzk//b04HxPIm
 KO2ZDXbSElLA==
X-IronPort-AV: E=McAfee;i="6000,8403,9664"; a="145588577"
X-IronPort-AV: E=Sophos;i="5.75,285,1589266800"; 
   d="scan'208";a="145588577"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2020 18:54:37 -0700
IronPort-SDR: hWsqXmE88atRS1C2naCpPkJYIEEnexu856ukhI/Z4IKyi7odD3DMGpOWjunV1HScLndTBE1MH7
 IXvXOHdnaXEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,285,1589266800"; 
   d="scan'208";a="312495107"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 26 Jun 2020 18:54:36 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 04/13] igc: Remove duplicate code in Tx timestamp handling
Date:   Fri, 26 Jun 2020 18:54:22 -0700
Message-Id: <20200627015431.3579234-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200627015431.3579234-1-jeffrey.t.kirsher@intel.com>
References: <20200627015431.3579234-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

The functions igc_ptp_tx_hang() and igc_ptp_tx_work() have duplicate
code which handles Tx timestamp timeouts. This patch does a trivial
refactoring by moving that code to its own function and reusing it.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ptp.c | 34 +++++++++++-------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 82e6c6c962d5..b1b23c6bf689 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -386,11 +386,23 @@ static int igc_ptp_set_timestamp_mode(struct igc_adapter *adapter,
 	return 0;
 }
 
+static void igc_ptp_tx_timeout(struct igc_adapter *adapter)
+{
+	struct igc_hw *hw = &adapter->hw;
+
+	dev_kfree_skb_any(adapter->ptp_tx_skb);
+	adapter->ptp_tx_skb = NULL;
+	adapter->tx_hwtstamp_timeouts++;
+	clear_bit_unlock(__IGC_PTP_TX_IN_PROGRESS, &adapter->state);
+	/* Clear the tx valid bit in TSYNCTXCTL register to enable interrupt. */
+	rd32(IGC_TXSTMPH);
+	netdev_warn(adapter->netdev, "Tx timestamp timeout\n");
+}
+
 void igc_ptp_tx_hang(struct igc_adapter *adapter)
 {
 	bool timeout = time_is_before_jiffies(adapter->ptp_tx_start +
 					      IGC_PTP_TX_TIMEOUT);
-	struct igc_hw *hw = &adapter->hw;
 
 	if (!adapter->ptp_tx_skb)
 		return;
@@ -404,15 +416,7 @@ void igc_ptp_tx_hang(struct igc_adapter *adapter)
 	 */
 	if (timeout) {
 		cancel_work_sync(&adapter->ptp_tx_work);
-		dev_kfree_skb_any(adapter->ptp_tx_skb);
-		adapter->ptp_tx_skb = NULL;
-		clear_bit_unlock(__IGC_PTP_TX_IN_PROGRESS, &adapter->state);
-		adapter->tx_hwtstamp_timeouts++;
-		/* Clear the Tx valid bit in TSYNCTXCTL register to enable
-		 * interrupt
-		 */
-		rd32(IGC_TXSTMPH);
-		netdev_warn(adapter->netdev, "Clearing Tx timestamp hang\n");
+		igc_ptp_tx_timeout(adapter);
 	}
 }
 
@@ -467,15 +471,7 @@ static void igc_ptp_tx_work(struct work_struct *work)
 
 	if (time_is_before_jiffies(adapter->ptp_tx_start +
 				   IGC_PTP_TX_TIMEOUT)) {
-		dev_kfree_skb_any(adapter->ptp_tx_skb);
-		adapter->ptp_tx_skb = NULL;
-		clear_bit_unlock(__IGC_PTP_TX_IN_PROGRESS, &adapter->state);
-		adapter->tx_hwtstamp_timeouts++;
-		/* Clear the tx valid bit in TSYNCTXCTL register to enable
-		 * interrupt
-		 */
-		rd32(IGC_TXSTMPH);
-		netdev_warn(adapter->netdev, "Clearing Tx timestamp hang\n");
+		igc_ptp_tx_timeout(adapter);
 		return;
 	}
 
-- 
2.26.2


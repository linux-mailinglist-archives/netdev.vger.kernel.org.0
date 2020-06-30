Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDA6420EAEA
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 03:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbgF3B2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 21:28:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:52168 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728622AbgF3B16 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 21:27:58 -0400
IronPort-SDR: gF6t358yu6UpZxOzXi95hsznPFVv2lGj574F5bY2d1PTjkSBNE7DFkKRONOgT6a3jjpWazgI7n
 ss084LbXKbMg==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="144305924"
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="144305924"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 18:27:50 -0700
IronPort-SDR: /nnwLPZQzBS97sLSaNEQvdwR7NR0OF3kX4uPQo9LN7J/tM57OUT5ymG2436+ISCNe8Pd4zNwwc
 UvbIE1RGvvsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="425017702"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga004.jf.intel.com with ESMTP; 29 Jun 2020 18:27:50 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 04/13] igc: Remove duplicate code in Tx timestamp handling
Date:   Mon, 29 Jun 2020 18:27:39 -0700
Message-Id: <20200630012748.518705-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200630012748.518705-1-jeffrey.t.kirsher@intel.com>
References: <20200630012748.518705-1-jeffrey.t.kirsher@intel.com>
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


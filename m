Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E3920BDAD
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 03:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgF0BzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 21:55:09 -0400
Received: from mga03.intel.com ([134.134.136.65]:29242 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726146AbgF0Byl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 21:54:41 -0400
IronPort-SDR: ktvtMwm6swilkQJjLVFTIgsEW0esml0xZyqEUImALaTq/tbpTuklfHEZci+wIh5JzTnoHFOuEH
 0+SqJ8gL9Jqw==
X-IronPort-AV: E=McAfee;i="6000,8403,9664"; a="145588579"
X-IronPort-AV: E=Sophos;i="5.75,285,1589266800"; 
   d="scan'208";a="145588579"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2020 18:54:37 -0700
IronPort-SDR: scM7XZejYP9ZPzn2oqOnPMDDBlbnx7ZI4SCmGIg+OtSyR+6C963ifKnudUXOk6JZ45HCFgk8Dg
 voyG/Q6M3wkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,285,1589266800"; 
   d="scan'208";a="312495110"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 26 Jun 2020 18:54:36 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 05/13] igc: Check __IGC_PTP_TX_IN_PROGRESS instead of ptp_tx_skb
Date:   Fri, 26 Jun 2020 18:54:23 -0700
Message-Id: <20200627015431.3579234-6-jeffrey.t.kirsher@intel.com>
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

The __IGC_PTP_TX_IN_PROGRESS flag indicates we have a pending Tx
timestamp. In some places, instead of checking that flag, we check
adapter->ptp_tx_skb. This patch fixes those places to use the flag.

Quick note about igc_ptp_tx_hwtstamp() change: when that function is
called, adapter->ptp_tx_skb is expected to be valid always so we
WARN_ON_ONCE() in case it is not.

Quick note about igc_ptp_suspend() change: when suspending, we don't
really need to check if there is a pending timestamp. We can simply
clear it unconditionally.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ptp.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index b1b23c6bf689..e65fdcf966b2 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -404,9 +404,6 @@ void igc_ptp_tx_hang(struct igc_adapter *adapter)
 	bool timeout = time_is_before_jiffies(adapter->ptp_tx_start +
 					      IGC_PTP_TX_TIMEOUT);
 
-	if (!adapter->ptp_tx_skb)
-		return;
-
 	if (!test_bit(__IGC_PTP_TX_IN_PROGRESS, &adapter->state))
 		return;
 
@@ -435,6 +432,9 @@ static void igc_ptp_tx_hwtstamp(struct igc_adapter *adapter)
 	struct igc_hw *hw = &adapter->hw;
 	u64 regval;
 
+	if (WARN_ON_ONCE(!skb))
+		return;
+
 	regval = rd32(IGC_TXSTMPL);
 	regval |= (u64)rd32(IGC_TXSTMPH) << 32;
 	igc_ptp_systim_to_hwtstamp(adapter, &shhwtstamps, regval);
@@ -466,7 +466,7 @@ static void igc_ptp_tx_work(struct work_struct *work)
 	struct igc_hw *hw = &adapter->hw;
 	u32 tsynctxctl;
 
-	if (!adapter->ptp_tx_skb)
+	if (!test_bit(__IGC_PTP_TX_IN_PROGRESS, &adapter->state))
 		return;
 
 	if (time_is_before_jiffies(adapter->ptp_tx_start +
@@ -588,11 +588,9 @@ void igc_ptp_suspend(struct igc_adapter *adapter)
 		return;
 
 	cancel_work_sync(&adapter->ptp_tx_work);
-	if (adapter->ptp_tx_skb) {
-		dev_kfree_skb_any(adapter->ptp_tx_skb);
-		adapter->ptp_tx_skb = NULL;
-		clear_bit_unlock(__IGC_PTP_TX_IN_PROGRESS, &adapter->state);
-	}
+	dev_kfree_skb_any(adapter->ptp_tx_skb);
+	adapter->ptp_tx_skb = NULL;
+	clear_bit_unlock(__IGC_PTP_TX_IN_PROGRESS, &adapter->state);
 }
 
 /**
-- 
2.26.2


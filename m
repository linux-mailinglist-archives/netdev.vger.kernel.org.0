Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0CF520EAE6
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 03:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728688AbgF3B2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 21:28:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:52168 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728636AbgF3B17 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 21:27:59 -0400
IronPort-SDR: ALQSWB8KA/RcxKtA39sRVqKBGrikDmH8FNvzp40eX1nmXcP5BdKiL1+TuXt0okewV/oA7d2Fow
 lfLWWyHncovw==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="144305925"
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="144305925"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 18:27:50 -0700
IronPort-SDR: Tnu1p8vuoFBc1sb3iD9IFjY+yZLUPgDI+rsPcoQFzPH9dpd9Ovey1n8zw7Kgq0iux+N+ZHjPZp
 XFcHxatP95iA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,296,1589266800"; 
   d="scan'208";a="425017705"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga004.jf.intel.com with ESMTP; 29 Jun 2020 18:27:50 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 05/13] igc: Check __IGC_PTP_TX_IN_PROGRESS instead of ptp_tx_skb
Date:   Mon, 29 Jun 2020 18:27:40 -0700
Message-Id: <20200630012748.518705-6-jeffrey.t.kirsher@intel.com>
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


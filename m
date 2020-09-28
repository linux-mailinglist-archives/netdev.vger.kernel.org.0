Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35DE127B3D4
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 19:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgI1R7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 13:59:44 -0400
Received: from mga18.intel.com ([134.134.136.126]:32958 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726670AbgI1R7a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 13:59:30 -0400
IronPort-SDR: zWRnZxZYQ+M0W6L4VghDNwfys6IkbBawZyMpPW5NqOeFUsot1FvC7FSYcH6d30jhPUbiTQwKy/
 SXAxaaQrgahw==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="149810271"
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="149810271"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 10:59:22 -0700
IronPort-SDR: phyDu2UxFbQnQxp5yELwCW12pmBr0M5+0E4BQ38RNmp2BMS4bviZKGblwMhAytt8yhxzmgrCMr
 Yf+58EfkT9UA==
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="340505400"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 10:59:22 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next 10/15] igc: Save PTP time before a reset
Date:   Mon, 28 Sep 2020 10:59:03 -0700
Message-Id: <20200928175908.318502-11-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200928175908.318502-1-anthony.l.nguyen@intel.com>
References: <20200928175908.318502-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

Many TSN features depend on the internal PTP clock, so the internal
PTP jumping when the adapter is reset can cause problems, usually in
the form of "TX Hangs" warnings in the driver.

The solution is to save the PTP time before a reset and restore it
after the reset is done. The value of the PTP time is saved before a
reset and we use the difference from CLOCK_MONOTONIC from reset time
to now, to correct what's going to be the new PTP time.

This is heavily inspired by commit bf4bf09bdd91 ("i40e: save PTP time
before a device reset").

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h      |  2 ++
 drivers/net/ethernet/intel/igc/igc_main.c |  2 ++
 drivers/net/ethernet/intel/igc/igc_ptp.c  | 28 ++++++++++++++++++++---
 3 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 2d566f3c827b..2e5720d34a16 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -215,6 +215,8 @@ struct igc_adapter {
 	spinlock_t tmreg_lock;
 	struct cyclecounter cc;
 	struct timecounter tc;
+	struct timespec64 prev_ptp_time; /* Pre-reset PTP clock */
+	ktime_t ptp_reset_start; /* Reset time in clock mono */
 };
 
 void igc_up(struct igc_adapter *adapter);
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 7576dbfdac99..1c16cd35c81c 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -3778,6 +3778,8 @@ void igc_down(struct igc_adapter *adapter)
 
 	set_bit(__IGC_DOWN, &adapter->state);
 
+	igc_ptp_suspend(adapter);
+
 	/* disable receives in the hardware */
 	rctl = rd32(IGC_RCTL);
 	wr32(IGC_RCTL, rctl & ~IGC_RCTL_EN);
diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 0300b45b36e2..49abefdab26c 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -8,6 +8,7 @@
 #include <linux/pci.h>
 #include <linux/ptp_classify.h>
 #include <linux/clocksource.h>
+#include <linux/ktime.h>
 
 #define INCVALUE_MASK		0x7fffffff
 #define ISGN			0x80000000
@@ -500,6 +501,9 @@ void igc_ptp_init(struct igc_adapter *adapter)
 	adapter->tstamp_config.rx_filter = HWTSTAMP_FILTER_NONE;
 	adapter->tstamp_config.tx_type = HWTSTAMP_TX_OFF;
 
+	adapter->prev_ptp_time = ktime_to_timespec64(ktime_get_real());
+	adapter->ptp_reset_start = ktime_get();
+
 	adapter->ptp_clock = ptp_clock_register(&adapter->ptp_caps,
 						&adapter->pdev->dev);
 	if (IS_ERR(adapter->ptp_clock)) {
@@ -511,6 +515,24 @@ void igc_ptp_init(struct igc_adapter *adapter)
 	}
 }
 
+static void igc_ptp_time_save(struct igc_adapter *adapter)
+{
+	igc_ptp_read_i225(adapter, &adapter->prev_ptp_time);
+	adapter->ptp_reset_start = ktime_get();
+}
+
+static void igc_ptp_time_restore(struct igc_adapter *adapter)
+{
+	struct timespec64 ts = adapter->prev_ptp_time;
+	ktime_t delta;
+
+	delta = ktime_sub(ktime_get(), adapter->ptp_reset_start);
+
+	timespec64_add_ns(&ts, ktime_to_ns(delta));
+
+	igc_ptp_write_i225(adapter, &ts);
+}
+
 /**
  * igc_ptp_suspend - Disable PTP work items and prepare for suspend
  * @adapter: Board private structure
@@ -527,6 +549,8 @@ void igc_ptp_suspend(struct igc_adapter *adapter)
 	dev_kfree_skb_any(adapter->ptp_tx_skb);
 	adapter->ptp_tx_skb = NULL;
 	clear_bit_unlock(__IGC_PTP_TX_IN_PROGRESS, &adapter->state);
+
+	igc_ptp_time_save(adapter);
 }
 
 /**
@@ -576,9 +600,7 @@ void igc_ptp_reset(struct igc_adapter *adapter)
 
 	/* Re-initialize the timer. */
 	if (hw->mac.type == igc_i225) {
-		struct timespec64 ts64 = ktime_to_timespec64(ktime_get_real());
-
-		igc_ptp_write_i225(adapter, &ts64);
+		igc_ptp_time_restore(adapter);
 	} else {
 		timecounter_init(&adapter->tc, &adapter->cc,
 				 ktime_to_ns(ktime_get_real()));
-- 
2.26.2


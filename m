Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C23227B3D1
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 19:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgI1R7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 13:59:46 -0400
Received: from mga18.intel.com ([134.134.136.126]:32958 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726461AbgI1R7o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 13:59:44 -0400
IronPort-SDR: 8f01PDdxDOXcxJOwWaO+OS7mdwcOIaOqNDPqxFThvHE5IS8kjsAVXxGOb5WdYSamvXOAcbgmhp
 E1wSmH80+tLw==
X-IronPort-AV: E=McAfee;i="6000,8403,9758"; a="149810273"
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="149810273"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 10:59:22 -0700
IronPort-SDR: Vpo4ev9aJcQ+wf7SxnugwfzEWThKQysznj3fzhko+cY/jpnDtCvJymKu+eQ29iKBRiIVjef//r
 ieCl7cQrGL3A==
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="340505404"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 10:59:22 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next 12/15] igc: Export a way to read the PTP timer
Date:   Mon, 28 Sep 2020 10:59:05 -0700
Message-Id: <20200928175908.318502-13-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200928175908.318502-1-anthony.l.nguyen@intel.com>
References: <20200928175908.318502-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

The next patch will need a way to retrieve the current timestamp from
the NIC's PTP clock.

The 'i225' suffix is removed, if anything model specific is needed,
those specifics should be hidden by this function.

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h     | 1 +
 drivers/net/ethernet/intel/igc/igc_ptp.c | 7 +++----
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 2e5720d34a16..35baae900c1f 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -550,6 +550,7 @@ void igc_ptp_rx_pktstamp(struct igc_q_vector *q_vector, void *va,
 int igc_ptp_set_ts_config(struct net_device *netdev, struct ifreq *ifr);
 int igc_ptp_get_ts_config(struct net_device *netdev, struct ifreq *ifr);
 void igc_ptp_tx_hang(struct igc_adapter *adapter);
+void igc_ptp_read(struct igc_adapter *adapter, struct timespec64 *ts);
 
 #define igc_rx_pg_size(_ring) (PAGE_SIZE << igc_rx_pg_order(_ring))
 
diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 49abefdab26c..ac0b9c85da7c 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -17,8 +17,7 @@
 #define IGC_PTP_TX_TIMEOUT		(HZ * 15)
 
 /* SYSTIM read access for I225 */
-static void igc_ptp_read_i225(struct igc_adapter *adapter,
-			      struct timespec64 *ts)
+void igc_ptp_read(struct igc_adapter *adapter, struct timespec64 *ts)
 {
 	struct igc_hw *hw = &adapter->hw;
 	u32 sec, nsec;
@@ -75,7 +74,7 @@ static int igc_ptp_adjtime_i225(struct ptp_clock_info *ptp, s64 delta)
 
 	spin_lock_irqsave(&igc->tmreg_lock, flags);
 
-	igc_ptp_read_i225(igc, &now);
+	igc_ptp_read(igc, &now);
 	now = timespec64_add(now, then);
 	igc_ptp_write_i225(igc, (const struct timespec64 *)&now);
 
@@ -517,7 +516,7 @@ void igc_ptp_init(struct igc_adapter *adapter)
 
 static void igc_ptp_time_save(struct igc_adapter *adapter)
 {
-	igc_ptp_read_i225(adapter, &adapter->prev_ptp_time);
+	igc_ptp_read(adapter, &adapter->prev_ptp_time);
 	adapter->ptp_reset_start = ktime_get();
 }
 
-- 
2.26.2


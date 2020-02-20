Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C13E41653F0
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 01:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbgBTA5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 19:57:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:33266 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727429AbgBTA5S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 19:57:18 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2020 16:57:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,462,1574150400"; 
   d="scan'208";a="408621365"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.76])
  by orsmga005.jf.intel.com with ESMTP; 19 Feb 2020 16:57:15 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 09/12] igc: Complete to commit Add basic skeleton for PTP
Date:   Wed, 19 Feb 2020 16:57:10 -0800
Message-Id: <20200220005713.682605-10-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200220005713.682605-1-jeffrey.t.kirsher@intel.com>
References: <20200220005713.682605-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

commit 5f2958052c58 ("igc: Add basic skeleton for PTP") added basic
support for PTP, what's missing is support for suspending.
Legacy power management has been added. Now we can add
the suspend method to the igc_shutdown.
By cleaning the runtime storage for timestamp this avoids a possible
invalid memory access when the system comes back from suspend state.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h      | 1 +
 drivers/net/ethernet/intel/igc/igc_main.c | 2 ++
 drivers/net/ethernet/intel/igc/igc_ptp.c  | 2 +-
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index cb1362188c2a..5e9c2dd8b8e4 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -556,6 +556,7 @@ int igc_erase_filter(struct igc_adapter *adapter,
 
 void igc_ptp_init(struct igc_adapter *adapter);
 void igc_ptp_reset(struct igc_adapter *adapter);
+void igc_ptp_suspend(struct igc_adapter *adapter);
 void igc_ptp_stop(struct igc_adapter *adapter);
 void igc_ptp_rx_rgtstamp(struct igc_q_vector *q_vector, struct sk_buff *skb);
 void igc_ptp_rx_pktstamp(struct igc_q_vector *q_vector, void *va,
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 3c748d239423..b805323e1be6 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4899,6 +4899,8 @@ static int __igc_shutdown(struct pci_dev *pdev, bool *enable_wake,
 	if (netif_running(netdev))
 		__igc_close(netdev, true);
 
+	igc_ptp_suspend(adapter);
+
 	igc_clear_interrupt_scheme(adapter);
 	rtnl_unlock();
 
diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 389a969fe5f4..f99c514ad0f4 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -641,7 +641,7 @@ void igc_ptp_init(struct igc_adapter *adapter)
  * This function stops the overflow check work and PTP Tx timestamp work, and
  * will prepare the device for OS suspend.
  */
-static void igc_ptp_suspend(struct igc_adapter *adapter)
+void igc_ptp_suspend(struct igc_adapter *adapter)
 {
 	if (!(adapter->ptp_flags & IGC_PTP_ENABLED))
 		return;
-- 
2.24.1


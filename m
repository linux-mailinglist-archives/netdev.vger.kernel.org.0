Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A97144655F7
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 19:58:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244342AbhLATCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 14:02:02 -0500
Received: from mga04.intel.com ([192.55.52.120]:44534 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241163AbhLATCC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Dec 2021 14:02:02 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10185"; a="235261293"
X-IronPort-AV: E=Sophos;i="5.87,279,1631602800"; 
   d="scan'208";a="235261293"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2021 10:58:41 -0800
X-IronPort-AV: E=Sophos;i="5.87,279,1631602800"; 
   d="scan'208";a="500371301"
Received: from ammonk-mobl.amr.corp.intel.com (HELO vcostago-mobl3.intel.com) ([10.212.205.220])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2021 10:58:40 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     roots@gmx.de
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>, kuba@kernel.org,
        greg@kroah.com, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, stable@vger.kernel.org,
        regressions@lists.linux.dev
Subject: [PATCH] igc: Avoid possible deadlock during suspend/resume
Date:   Wed,  1 Dec 2021 10:57:31 -0800
Message-Id: <20211201185731.236130-1-vinicius.gomes@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <87r1awtdx3.fsf@intel.com>
References: <87r1awtdx3.fsf@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Inspired by:
https://bugzilla.kernel.org/show_bug.cgi?id=215129

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
Just to see if it's indeed the same problem as the bug report above.

 drivers/net/ethernet/intel/igc/igc_main.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 0e19b4d02e62..c58bf557a2a1 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6619,7 +6619,7 @@ static void igc_deliver_wake_packet(struct net_device *netdev)
 	netif_rx(skb);
 }
 
-static int __maybe_unused igc_resume(struct device *dev)
+static int __maybe_unused __igc_resume(struct device *dev, bool rpm)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct net_device *netdev = pci_get_drvdata(pdev);
@@ -6661,20 +6661,27 @@ static int __maybe_unused igc_resume(struct device *dev)
 
 	wr32(IGC_WUS, ~0);
 
-	rtnl_lock();
+	if (!rpm)
+		rtnl_lock();
 	if (!err && netif_running(netdev))
 		err = __igc_open(netdev, true);
 
 	if (!err)
 		netif_device_attach(netdev);
-	rtnl_unlock();
+	if (!rpm)
+		rtnl_unlock();
 
 	return err;
 }
 
 static int __maybe_unused igc_runtime_resume(struct device *dev)
 {
-	return igc_resume(dev);
+	return __igc_resume(dev, true);
+}
+
+static int __maybe_unused igc_resume(struct device *dev)
+{
+	return __igc_resume(dev, false);
 }
 
 static int __maybe_unused igc_suspend(struct device *dev)
@@ -6738,7 +6745,7 @@ static pci_ers_result_t igc_io_error_detected(struct pci_dev *pdev,
  *  @pdev: Pointer to PCI device
  *
  *  Restart the card from scratch, as if from a cold-boot. Implementation
- *  resembles the first-half of the igc_resume routine.
+ *  resembles the first-half of the __igc_resume routine.
  **/
 static pci_ers_result_t igc_io_slot_reset(struct pci_dev *pdev)
 {
@@ -6777,7 +6784,7 @@ static pci_ers_result_t igc_io_slot_reset(struct pci_dev *pdev)
  *
  *  This callback is called when the error recovery driver tells us that
  *  its OK to resume normal operation. Implementation resembles the
- *  second-half of the igc_resume routine.
+ *  second-half of the __igc_resume routine.
  */
 static void igc_io_resume(struct pci_dev *pdev)
 {
-- 
2.33.1


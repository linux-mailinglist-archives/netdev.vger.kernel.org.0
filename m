Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC60B152777
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 09:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbgBEIQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 03:16:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50606 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbgBEIQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 03:16:33 -0500
Received: from 61-220-137-37.hinet-ip.hinet.net ([61.220.137.37] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1izFrF-0008R1-Lf; Wed, 05 Feb 2020 08:16:26 +0000
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     davem@davemloft.ne, mkubecek@suse.cz, jeffrey.t.kirsher@intel.com
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org (moderated list:INTEL ETHERNET DRIVERS),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 1/2] igb: Use device_lock() insead of rtnl_lock()
Date:   Wed,  5 Feb 2020 16:16:15 +0800
Message-Id: <20200205081616.18378-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 9474933caf21 ("igb: close/suspend race in netif_device_detach")
fixed race condition between close and power management ops by using
rtnl_lock().

However we can achieve the same by using device_lock() since all power
management ops are protected by device_lock().

This fix is a preparation for next patch, to prevent a dead lock under
rtnl_lock() when calling runtime resume routine.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
v2:
 - No change.

 drivers/net/ethernet/intel/igb/igb_main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index b46bff8fe056..3750e2b926b1 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -4026,8 +4026,13 @@ static int __igb_close(struct net_device *netdev, bool suspending)
 
 int igb_close(struct net_device *netdev)
 {
+	struct igb_adapter *adapter = netdev_priv(netdev);
+	struct device *dev = &adapter->pdev->dev;
+
+	device_lock(dev);
 	if (netif_device_present(netdev) || netdev->dismantle)
 		return __igb_close(netdev, false);
+	device_unlock(dev);
 	return 0;
 }
 
@@ -8760,7 +8765,6 @@ static int __igb_shutdown(struct pci_dev *pdev, bool *enable_wake,
 	u32 wufc = runtime ? E1000_WUFC_LNKC : adapter->wol;
 	bool wake;
 
-	rtnl_lock();
 	netif_device_detach(netdev);
 
 	if (netif_running(netdev))
@@ -8769,7 +8773,6 @@ static int __igb_shutdown(struct pci_dev *pdev, bool *enable_wake,
 	igb_ptp_suspend(adapter);
 
 	igb_clear_interrupt_scheme(adapter);
-	rtnl_unlock();
 
 	status = rd32(E1000_STATUS);
 	if (status & E1000_STATUS_LU)
@@ -8897,13 +8900,11 @@ static int __maybe_unused igb_resume(struct device *dev)
 
 	wr32(E1000_WUS, ~0);
 
-	rtnl_lock();
 	if (!err && netif_running(netdev))
 		err = __igb_open(netdev, true);
 
 	if (!err)
 		netif_device_attach(netdev);
-	rtnl_unlock();
 
 	return err;
 }
-- 
2.17.1


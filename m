Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 280D4193D12
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 11:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbgCZKjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 06:39:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34648 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727948AbgCZKjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 06:39:43 -0400
Received: from 61-220-137-37.hinet-ip.hinet.net ([61.220.137.37] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1jHPvD-0003yo-Eu; Thu, 26 Mar 2020 10:39:36 +0000
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     jeffrey.t.kirsher@intel.com
Cc:     aaron.f.brown@intel.com,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org (moderated list:INTEL ETHERNET DRIVERS),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] igb: Use a sperate mutex insead of rtnl_lock()
Date:   Thu, 26 Mar 2020 18:39:26 +0800
Message-Id: <20200326103926.20888-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 9474933caf21 ("igb: close/suspend race in netif_device_detach")
fixed race condition between close and power management ops by using
rtnl_lock().

This fix is a preparation for next patch, to prevent a dead lock under
rtnl_lock() when calling runtime resume routine.

However, we can't use device_lock() in igb_close() because when module
is getting removed, the lock is already held for igb_remove(), and
igb_close() gets called during unregistering the netdev, hence causing a
deadlock. So let's introduce a new mutex so we don't cause a deadlock
with driver core or netdev core.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index b46bff8fe056..dc7ed5dd216b 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -288,6 +288,8 @@ static const struct igb_reg_info igb_reg_info_tbl[] = {
 	{}
 };
 
+static DEFINE_MUTEX(igb_mutex);
+
 /* igb_regdump - register printout routine */
 static void igb_regdump(struct e1000_hw *hw, struct igb_reg_info *reginfo)
 {
@@ -4026,9 +4028,14 @@ static int __igb_close(struct net_device *netdev, bool suspending)
 
 int igb_close(struct net_device *netdev)
 {
+	int err = 0;
+
+	mutex_lock(&igb_mutex);
 	if (netif_device_present(netdev) || netdev->dismantle)
-		return __igb_close(netdev, false);
-	return 0;
+		err = __igb_close(netdev, false);
+	mutex_unlock(&igb_mutex);
+
+	return err;
 }
 
 /**
@@ -8760,7 +8767,7 @@ static int __igb_shutdown(struct pci_dev *pdev, bool *enable_wake,
 	u32 wufc = runtime ? E1000_WUFC_LNKC : adapter->wol;
 	bool wake;
 
-	rtnl_lock();
+	mutex_lock(&igb_mutex);
 	netif_device_detach(netdev);
 
 	if (netif_running(netdev))
@@ -8769,7 +8776,7 @@ static int __igb_shutdown(struct pci_dev *pdev, bool *enable_wake,
 	igb_ptp_suspend(adapter);
 
 	igb_clear_interrupt_scheme(adapter);
-	rtnl_unlock();
+	mutex_unlock(&igb_mutex);
 
 	status = rd32(E1000_STATUS);
 	if (status & E1000_STATUS_LU)
@@ -8897,13 +8904,13 @@ static int __maybe_unused igb_resume(struct device *dev)
 
 	wr32(E1000_WUS, ~0);
 
-	rtnl_lock();
+	mutex_lock(&igb_mutex);
 	if (!err && netif_running(netdev))
 		err = __igb_open(netdev, true);
 
 	if (!err)
 		netif_device_attach(netdev);
-	rtnl_unlock();
+	mutex_unlock(&igb_mutex);
 
 	return err;
 }
-- 
2.17.1


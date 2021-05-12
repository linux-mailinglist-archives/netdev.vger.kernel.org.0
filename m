Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C904837BA36
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 12:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbhELKVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 06:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbhELKVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 06:21:06 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19AE5C061574
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 03:19:58 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lgly7-007u3c-Hi; Wed, 12 May 2021 12:19:55 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     netdev@vger.kernel.org
Cc:     Nikolai Zhubr <zhubr.2@gmail.com>
Subject: [PATCH net-next] alx: use fine-grained locking instead of RTNL
Date:   Wed, 12 May 2021 12:19:50 +0200
Message-Id: <20210512121950.c93ce92d90b3.I085a905dea98ed1db7f023405860945ea3ac82d5@changeid>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the alx driver, all locking depended on the RTNL, but
that causes issues with ipconfig ("ip=..." command line)
because that waits for the netdev to have a carrier while
holding the RTNL, but the alx workers etc. require RTNL,
so the carrier won't be set until the RTNL is dropped and
can be acquired by alx workers. This causes long delays
at boot, as reported by Nikolai Zhubr.

Really the only sensible thing to do here is to not use
the RTNL for everything, but instead have fine-grained
locking for just the driver. Do that, it's not that hard.

Reported-by: Nikolai Zhubr <zhubr.2@gmail.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/ethernet/atheros/alx/alx.h     |  2 +
 drivers/net/ethernet/atheros/alx/ethtool.c | 17 ++++-
 drivers/net/ethernet/atheros/alx/main.c    | 86 +++++++++++++++-------
 3 files changed, 76 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/atheros/alx/alx.h b/drivers/net/ethernet/atheros/alx/alx.h
index 9d0e74f6b089..693006c5a498 100644
--- a/drivers/net/ethernet/atheros/alx/alx.h
+++ b/drivers/net/ethernet/atheros/alx/alx.h
@@ -137,6 +137,8 @@ struct alx_priv {
 
 	/* protects hw.stats */
 	spinlock_t stats_lock;
+
+	struct mutex mtx;
 };
 
 extern const struct ethtool_ops alx_ethtool_ops;
diff --git a/drivers/net/ethernet/atheros/alx/ethtool.c b/drivers/net/ethernet/atheros/alx/ethtool.c
index 2f4eabf652e8..f3627157a38a 100644
--- a/drivers/net/ethernet/atheros/alx/ethtool.c
+++ b/drivers/net/ethernet/atheros/alx/ethtool.c
@@ -163,8 +163,10 @@ static int alx_get_link_ksettings(struct net_device *netdev,
 		}
 	}
 
+	mutex_lock(&alx->mtx);
 	cmd->base.speed = hw->link_speed;
 	cmd->base.duplex = hw->duplex;
+	mutex_unlock(&alx->mtx);
 
 	ethtool_convert_legacy_u32_to_link_mode(cmd->link_modes.supported,
 						supported);
@@ -181,8 +183,7 @@ static int alx_set_link_ksettings(struct net_device *netdev,
 	struct alx_hw *hw = &alx->hw;
 	u32 adv_cfg;
 	u32 advertising;
-
-	ASSERT_RTNL();
+	int ret;
 
 	ethtool_convert_link_mode_to_legacy_u32(&advertising,
 						cmd->link_modes.advertising);
@@ -200,7 +201,12 @@ static int alx_set_link_ksettings(struct net_device *netdev,
 	}
 
 	hw->adv_cfg = adv_cfg;
-	return alx_setup_speed_duplex(hw, adv_cfg, hw->flowctrl);
+
+	mutex_lock(&alx->mtx);
+	ret = alx_setup_speed_duplex(hw, adv_cfg, hw->flowctrl);
+	mutex_unlock(&alx->mtx);
+
+	return ret;
 }
 
 static void alx_get_pauseparam(struct net_device *netdev,
@@ -209,10 +215,12 @@ static void alx_get_pauseparam(struct net_device *netdev,
 	struct alx_priv *alx = netdev_priv(netdev);
 	struct alx_hw *hw = &alx->hw;
 
+	mutex_lock(&alx->mtx);
 	pause->autoneg = !!(hw->flowctrl & ALX_FC_ANEG &&
 			    hw->adv_cfg & ADVERTISED_Autoneg);
 	pause->tx_pause = !!(hw->flowctrl & ALX_FC_TX);
 	pause->rx_pause = !!(hw->flowctrl & ALX_FC_RX);
+	mutex_unlock(&alx->mtx);
 }
 
 
@@ -232,7 +240,7 @@ static int alx_set_pauseparam(struct net_device *netdev,
 	if (pause->autoneg)
 		fc |= ALX_FC_ANEG;
 
-	ASSERT_RTNL();
+	mutex_lock(&alx->mtx);
 
 	/* restart auto-neg for auto-mode */
 	if (hw->adv_cfg & ADVERTISED_Autoneg) {
@@ -254,6 +262,7 @@ static int alx_set_pauseparam(struct net_device *netdev,
 		alx_cfg_mac_flowcontrol(hw, fc);
 
 	hw->flowctrl = fc;
+	mutex_unlock(&alx->mtx);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index 9e02f8864593..e61956805ee5 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2013 Johannes Berg <johannes@sipsolutions.net>
+ * Copyright (c) 2013, 2021 Johannes Berg <johannes@sipsolutions.net>
  *
  *  This file is free software: you may copy, redistribute and/or modify it
  *  under the terms of the GNU General Public License as published by the
@@ -1091,8 +1091,9 @@ static int alx_init_sw(struct alx_priv *alx)
 		      ALX_MAC_CTRL_RXFC_EN |
 		      ALX_MAC_CTRL_TXFC_EN |
 		      7 << ALX_MAC_CTRL_PRMBLEN_SHIFT;
+	mutex_init(&alx->mtx);
 
-	return err;
+	return 0;
 }
 
 
@@ -1122,6 +1123,8 @@ static void alx_halt(struct alx_priv *alx)
 {
 	struct alx_hw *hw = &alx->hw;
 
+	lockdep_assert_held(&alx->mtx);
+
 	alx_netif_stop(alx);
 	hw->link_speed = SPEED_UNKNOWN;
 	hw->duplex = DUPLEX_UNKNOWN;
@@ -1147,6 +1150,8 @@ static void alx_configure(struct alx_priv *alx)
 
 static void alx_activate(struct alx_priv *alx)
 {
+	lockdep_assert_held(&alx->mtx);
+
 	/* hardware setting lost, restore it */
 	alx_reinit_rings(alx);
 	alx_configure(alx);
@@ -1161,7 +1166,7 @@ static void alx_activate(struct alx_priv *alx)
 
 static void alx_reinit(struct alx_priv *alx)
 {
-	ASSERT_RTNL();
+	lockdep_assert_held(&alx->mtx);
 
 	alx_halt(alx);
 	alx_activate(alx);
@@ -1249,6 +1254,8 @@ static int __alx_open(struct alx_priv *alx, bool resume)
 
 static void __alx_stop(struct alx_priv *alx)
 {
+	lockdep_assert_held(&alx->mtx);
+
 	alx_free_irq(alx);
 
 	cancel_work_sync(&alx->link_check_wk);
@@ -1284,6 +1291,8 @@ static void alx_check_link(struct alx_priv *alx)
 	int old_speed;
 	int err;
 
+	lockdep_assert_held(&alx->mtx);
+
 	/* clear PHY internal interrupt status, otherwise the main
 	 * interrupt status will be asserted forever
 	 */
@@ -1338,12 +1347,24 @@ static void alx_check_link(struct alx_priv *alx)
 
 static int alx_open(struct net_device *netdev)
 {
-	return __alx_open(netdev_priv(netdev), false);
+	struct alx_priv *alx = netdev_priv(netdev);
+	int ret;
+
+	mutex_lock(&alx->mtx);
+	ret = __alx_open(alx, false);
+	mutex_unlock(&alx->mtx);
+
+	return ret;
 }
 
 static int alx_stop(struct net_device *netdev)
 {
-	__alx_stop(netdev_priv(netdev));
+	struct alx_priv *alx = netdev_priv(netdev);
+
+	mutex_lock(&alx->mtx);
+	__alx_stop(alx);
+	mutex_unlock(&alx->mtx);
+
 	return 0;
 }
 
@@ -1353,18 +1374,18 @@ static void alx_link_check(struct work_struct *work)
 
 	alx = container_of(work, struct alx_priv, link_check_wk);
 
-	rtnl_lock();
+	mutex_lock(&alx->mtx);
 	alx_check_link(alx);
-	rtnl_unlock();
+	mutex_unlock(&alx->mtx);
 }
 
 static void alx_reset(struct work_struct *work)
 {
 	struct alx_priv *alx = container_of(work, struct alx_priv, reset_wk);
 
-	rtnl_lock();
+	mutex_lock(&alx->mtx);
 	alx_reinit(alx);
-	rtnl_unlock();
+	mutex_unlock(&alx->mtx);
 }
 
 static int alx_tpd_req(struct sk_buff *skb)
@@ -1771,6 +1792,8 @@ static int alx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_unmap;
 	}
 
+	mutex_lock(&alx->mtx);
+
 	alx_reset_pcie(hw);
 
 	phy_configured = alx_phy_configured(hw);
@@ -1781,7 +1804,7 @@ static int alx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	err = alx_reset_mac(hw);
 	if (err) {
 		dev_err(&pdev->dev, "MAC Reset failed, error = %d\n", err);
-		goto out_unmap;
+		goto out_unlock;
 	}
 
 	/* setup link to put it in a known good starting state */
@@ -1791,7 +1814,7 @@ static int alx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			dev_err(&pdev->dev,
 				"failed to configure PHY speed/duplex (err=%d)\n",
 				err);
-			goto out_unmap;
+			goto out_unlock;
 		}
 	}
 
@@ -1824,9 +1847,11 @@ static int alx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!alx_get_phy_info(hw)) {
 		dev_err(&pdev->dev, "failed to identify PHY\n");
 		err = -EIO;
-		goto out_unmap;
+		goto out_unlock;
 	}
 
+	mutex_unlock(&alx->mtx);
+
 	INIT_WORK(&alx->link_check_wk, alx_link_check);
 	INIT_WORK(&alx->reset_wk, alx_reset);
 	netif_carrier_off(netdev);
@@ -1834,7 +1859,7 @@ static int alx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	err = register_netdev(netdev);
 	if (err) {
 		dev_err(&pdev->dev, "register netdevice failed\n");
-		goto out_unmap;
+		goto out_unlock;
 	}
 
 	netdev_info(netdev,
@@ -1843,6 +1868,8 @@ static int alx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	return 0;
 
+out_unlock:
+	mutex_unlock(&alx->mtx);
 out_unmap:
 	iounmap(hw->hw_addr);
 out_free_netdev:
@@ -1869,6 +1896,8 @@ static void alx_remove(struct pci_dev *pdev)
 	pci_disable_pcie_error_reporting(pdev);
 	pci_disable_device(pdev);
 
+	mutex_destroy(&alx->mtx);
+
 	free_netdev(alx->dev);
 }
 
@@ -1880,7 +1909,11 @@ static int alx_suspend(struct device *dev)
 	if (!netif_running(alx->dev))
 		return 0;
 	netif_device_detach(alx->dev);
+
+	mutex_lock(&alx->mtx);
 	__alx_stop(alx);
+	mutex_unlock(&alx->mtx);
+
 	return 0;
 }
 
@@ -1890,20 +1923,23 @@ static int alx_resume(struct device *dev)
 	struct alx_hw *hw = &alx->hw;
 	int err;
 
+	mutex_lock(&alx->mtx);
 	alx_reset_phy(hw);
 
-	if (!netif_running(alx->dev))
-		return 0;
+	if (!netif_running(alx->dev)) {
+		err = 0;
+		goto unlock;
+	}
 
-	rtnl_lock();
 	err = __alx_open(alx, true);
-	rtnl_unlock();
 	if (err)
-		return err;
+		goto unlock;
 
 	netif_device_attach(alx->dev);
 
-	return 0;
+unlock:
+	mutex_unlock(&alx->mtx);
+	return err;
 }
 
 static SIMPLE_DEV_PM_OPS(alx_pm_ops, alx_suspend, alx_resume);
@@ -1922,7 +1958,7 @@ static pci_ers_result_t alx_pci_error_detected(struct pci_dev *pdev,
 
 	dev_info(&pdev->dev, "pci error detected\n");
 
-	rtnl_lock();
+	mutex_lock(&alx->mtx);
 
 	if (netif_running(netdev)) {
 		netif_device_detach(netdev);
@@ -1934,7 +1970,7 @@ static pci_ers_result_t alx_pci_error_detected(struct pci_dev *pdev,
 	else
 		pci_disable_device(pdev);
 
-	rtnl_unlock();
+	mutex_unlock(&alx->mtx);
 
 	return rc;
 }
@@ -1947,7 +1983,7 @@ static pci_ers_result_t alx_pci_error_slot_reset(struct pci_dev *pdev)
 
 	dev_info(&pdev->dev, "pci error slot reset\n");
 
-	rtnl_lock();
+	mutex_lock(&alx->mtx);
 
 	if (pci_enable_device(pdev)) {
 		dev_err(&pdev->dev, "Failed to re-enable PCI device after reset\n");
@@ -1960,7 +1996,7 @@ static pci_ers_result_t alx_pci_error_slot_reset(struct pci_dev *pdev)
 	if (!alx_reset_mac(hw))
 		rc = PCI_ERS_RESULT_RECOVERED;
 out:
-	rtnl_unlock();
+	mutex_unlock(&alx->mtx);
 
 	return rc;
 }
@@ -1972,14 +2008,14 @@ static void alx_pci_error_resume(struct pci_dev *pdev)
 
 	dev_info(&pdev->dev, "pci error resume\n");
 
-	rtnl_lock();
+	mutex_lock(&alx->mtx);
 
 	if (netif_running(netdev)) {
 		alx_activate(alx);
 		netif_device_attach(netdev);
 	}
 
-	rtnl_unlock();
+	mutex_unlock(&alx->mtx);
 }
 
 static const struct pci_error_handlers alx_err_handlers = {
-- 
2.31.1


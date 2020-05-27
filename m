Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7860A1E4447
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 15:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388716AbgE0Nrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 09:47:36 -0400
Received: from mout.kundenserver.de ([212.227.126.135]:36665 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388082AbgE0Nrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 09:47:35 -0400
Received: from threadripper.lan ([149.172.98.151]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1N0nzR-1iqnfB1yGD-00wljD; Wed, 27 May 2020 15:47:20 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vitaly Lifshits <vitaly.lifshits@intel.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Detlev Casanova <detlev.casanova@gmail.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [net-next] e1000e: fix unused-function warning
Date:   Wed, 27 May 2020 15:47:00 +0200
Message-Id: <20200527134716.948148-1-arnd@arndb.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:U0mKtKTjWJcCkHiwKPi9Mh65377Hpmc77oEjPdqAFTu1tfJI3j5
 tQ6qhoFQt3VrltJF1OQAZvSCEi5jiXDLXneeEtt2tYoGulYW/CDGQtb89g2bHJUJ/w1LAik
 vIs2GxtV6aTDuWMBLBgIGK5xEW1J7i/jAm9wYXcKSEyCbp7nrbd8Rty5jSQY+5hArziNzw3
 jy7nL7AY5luwKFm7YGBUA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:fVIXS7/sr1M=:7+CEaDh/RQcJZ9+oHHDRCA
 jGgnId2Eh18Nx4Vc2d9p2ntA3gVJoJC13L9xRw+3ALBvTKDImWYcrAvVM2skxYOUcmBIsk/15
 ykarw3foUHHsbo5uxQhoF2/FDKLf04cgrW7yVLTuKX6a1F7Qy6xEH9GL9W7wu3MPCxjo7wfqu
 4i+RxGc+in1TayP2yisk1FswPj83O49YHoWV/XjbaqaxI76R47bKs6RYUQC0spixKJV3eDRkF
 UjKJRlHKhjY48Z6xvWggE2ckNMeE33kQBjsX/DbCW0tvFzeKfq6DrwxhEQzdLFdOnxry8MFlk
 D3hmE5yukdvkligEfgciGCgyYHINbBIL1WkAjok7DZFj5SiQFRcPIkJFKDeL0tsihQxvNiHJ8
 s1hEhMHSdhA5MQanrvjhcKGL5fb5nyqCUs6HICiQtlDTLBUImIApNtoPl7Ai6uP7ESBkoFvHb
 YScFHKzepRUhzSa7E7wIijOk2OCqFHKEQBWchcP5tpdsAaLb0X/Jx4bwglGBRKsi2jYHGDd00
 0ypJAuKP+cjgSdbVBa78G7FFgYgj68X2GQojBh5yZZVjtA5d8dR6Ko8g0wbeSa7IWKT109FJ1
 mhG9xQsenBnIVzqqVV8MQutz50mCLvuH4HLCKQppguZg7un/uMCSdZB/m9gCUEwOXjqxxsPwa
 9CiQAzzIZ/397cEH5q4bNOg+KIQ1ZR+kQACyN/ggykcUqN0bnGuIHxki8G6g15FAWLOlGRPbb
 j31v+NBus5GeRoBJ39ulocxn9VMzJBqaJND9StWQVB1fRSje3AcQ/+IejDuvREnOVJBbZAwEm
 ZUJIw+8x5FMAZQV+3MLJqTbcK0D1h04UY+JPHp3K4ZP9p0htwU=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The CONFIG_PM_SLEEP #ifdef checks in this file are inconsistent,
leading to a warning about sometimes unused function:

drivers/net/ethernet/intel/e1000e/netdev.c:137:13: error: unused function 'e1000e_check_me' [-Werror,-Wunused-function]

Rather than adding more #ifdefs, just remove them completely
and mark the PM functions as __maybe_unused to let the compiler
work it out on it own.

Fixes: e086ba2fccda ("e1000e: disable s0ix entry and exit flows for ME systems")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 9cc8ec5421d5..66ca083b95f9 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6351,7 +6351,6 @@ static void e1000e_flush_lpic(struct pci_dev *pdev)
 	pm_runtime_put_sync(netdev->dev.parent);
 }
 
-#ifdef CONFIG_PM_SLEEP
 /* S0ix implementation */
 static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
 {
@@ -6573,7 +6572,6 @@ static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
 	mac_data &= ~E1000_CTRL_EXT_FORCE_SMBUS;
 	ew32(CTRL_EXT, mac_data);
 }
-#endif /* CONFIG_PM_SLEEP */
 
 static int e1000e_pm_freeze(struct device *dev)
 {
@@ -6871,7 +6869,6 @@ static int e1000e_pm_thaw(struct device *dev)
 	return rc;
 }
 
-#ifdef CONFIG_PM
 static int __e1000_resume(struct pci_dev *pdev)
 {
 	struct net_device *netdev = pci_get_drvdata(pdev);
@@ -6937,8 +6934,7 @@ static int __e1000_resume(struct pci_dev *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM_SLEEP
-static int e1000e_pm_suspend(struct device *dev)
+static __maybe_unused int e1000e_pm_suspend(struct device *dev)
 {
 	struct net_device *netdev = pci_get_drvdata(to_pci_dev(dev));
 	struct e1000_adapter *adapter = netdev_priv(netdev);
@@ -6962,7 +6958,7 @@ static int e1000e_pm_suspend(struct device *dev)
 	return rc;
 }
 
-static int e1000e_pm_resume(struct device *dev)
+static __maybe_unused int e1000e_pm_resume(struct device *dev)
 {
 	struct net_device *netdev = pci_get_drvdata(to_pci_dev(dev));
 	struct e1000_adapter *adapter = netdev_priv(netdev);
@@ -6981,9 +6977,8 @@ static int e1000e_pm_resume(struct device *dev)
 
 	return e1000e_pm_thaw(dev);
 }
-#endif /* CONFIG_PM_SLEEP */
 
-static int e1000e_pm_runtime_idle(struct device *dev)
+static __maybe_unused int e1000e_pm_runtime_idle(struct device *dev)
 {
 	struct net_device *netdev = dev_get_drvdata(dev);
 	struct e1000_adapter *adapter = netdev_priv(netdev);
@@ -6999,7 +6994,7 @@ static int e1000e_pm_runtime_idle(struct device *dev)
 	return -EBUSY;
 }
 
-static int e1000e_pm_runtime_resume(struct device *dev)
+static __maybe_unused int e1000e_pm_runtime_resume(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct net_device *netdev = pci_get_drvdata(pdev);
@@ -7016,7 +7011,7 @@ static int e1000e_pm_runtime_resume(struct device *dev)
 	return rc;
 }
 
-static int e1000e_pm_runtime_suspend(struct device *dev)
+static __maybe_unused int e1000e_pm_runtime_suspend(struct device *dev)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct net_device *netdev = pci_get_drvdata(pdev);
@@ -7041,7 +7036,6 @@ static int e1000e_pm_runtime_suspend(struct device *dev)
 
 	return 0;
 }
-#endif /* CONFIG_PM */
 
 static void e1000_shutdown(struct pci_dev *pdev)
 {
-- 
2.26.2


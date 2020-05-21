Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77E281DD55E
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729214AbgEUR7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:59:01 -0400
Received: from mga14.intel.com ([192.55.52.115]:28245 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727883AbgEUR7B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 13:59:01 -0400
IronPort-SDR: RInbv4lMcUtgEVxcX8hHsrfYxF89txVykwTNpqs3uQ/FMtjSL9uS5n0DLgp6o5RAWzAyhnPIdw
 fxf5ac0lfVbQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 10:59:01 -0700
IronPort-SDR: vfZIJeCGZ+wuj1JpsKcKRlwabLNciBmrm7H/gke8Nz1ctfBKilF6hmUvudflKRDrPWEJVhXROm
 AzdpwRYBsNyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,418,1583222400"; 
   d="scan'208";a="412486010"
Received: from chenyu-office.sh.intel.com ([10.239.158.173])
  by orsmga004.jf.intel.com with ESMTP; 21 May 2020 10:58:55 -0700
From:   Chen Yu <yu.c.chen@intel.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Auke Kok <auke-jan.h.kok@intel.com>,
        Jeff Garzik <jeff@garzik.org>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Shevchenko, Andriy" <andriy.shevchenko@intel.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>,
        Chen Yu <yu.c.chen@intel.com>, Stable@vger.kernel.org
Subject: [PATCH 1/2] e1000e: Do not wake up the system via WOL if device wakeup is disabled
Date:   Fri, 22 May 2020 01:59:00 +0800
Message-Id: <9f7ede2e2e8152704258fc11ba3755ae93f50741.1590081982.git.yu.c.chen@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1590081982.git.yu.c.chen@intel.com>
References: <cover.1590081982.git.yu.c.chen@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the system will be woken up via WOL(Wake On Lan) even if the
device wakeup ability has been disabled via sysfs:
 cat /sys/devices/pci0000:00/0000:00:1f.6/power/wakeup
 disabled

The system should not be woken up if the user has explicitly
disabled the wake up ability for this device.

This patch clears the WOL ability of this network device if the
user has disabled the wake up ability in sysfs.

Fixes: bc7f75fa9788 ("[E1000E]: New pci-express e1000 driver")
Reported-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 177c6da80c57..f6f730388705 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6516,11 +6516,17 @@ static int __e1000_shutdown(struct pci_dev *pdev, bool runtime)
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct e1000_hw *hw = &adapter->hw;
-	u32 ctrl, ctrl_ext, rctl, status;
-	/* Runtime suspend should only enable wakeup for link changes */
-	u32 wufc = runtime ? E1000_WUFC_LNKC : adapter->wol;
+	u32 ctrl, ctrl_ext, rctl, status, wufc;
 	int retval = 0;
 
+	/* Runtime suspend should only enable wakeup for link changes */
+	if (runtime)
+		wufc = E1000_WUFC_LNKC;
+	else if (device_may_wakeup(&pdev->dev))
+		wufc = adapter->wol;
+	else
+		wufc = 0;
+
 	status = er32(STATUS);
 	if (status & E1000_STATUS_LU)
 		wufc &= ~E1000_WUFC_LNKC;
@@ -6577,7 +6583,7 @@ static int __e1000_shutdown(struct pci_dev *pdev, bool runtime)
 	if (adapter->hw.phy.type == e1000_phy_igp_3) {
 		e1000e_igp3_phy_powerdown_workaround_ich8lan(&adapter->hw);
 	} else if (hw->mac.type >= e1000_pch_lpt) {
-		if (!(wufc & (E1000_WUFC_EX | E1000_WUFC_MC | E1000_WUFC_BC)))
+		if (wufc && !(wufc & (E1000_WUFC_EX | E1000_WUFC_MC | E1000_WUFC_BC)))
 			/* ULP does not support wake from unicast, multicast
 			 * or broadcast.
 			 */
-- 
2.17.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D351D18AC31
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 06:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgCSF1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 01:27:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43139 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgCSF1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 01:27:13 -0400
Received: from 61-220-137-37.hinet-ip.hinet.net ([61.220.137.37] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1jEnha-00032L-70; Thu, 19 Mar 2020 05:26:42 +0000
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     jeffrey.t.kirsher@intel.com
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org (moderated list:INTEL ETHERNET DRIVERS),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/1] e1000e: Disable s0ix flow for X1 Carbon 7th
Date:   Thu, 19 Mar 2020 13:26:29 +0800
Message-Id: <20200319052629.7282-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The s0ix flow makes X1 Carbon 7th can only run S2Idle for only once.

Temporarily disable it until Intel found a solution.

Link: https://lists.osuosl.org/pipermail/intel-wired-lan/Week-of-Mon-20200316/019222.html
BugLink: https://bugs.launchpad.net/bugs/1865570
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index db4ea58bac82..3e090aa993ee 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -25,6 +25,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/aer.h>
 #include <linux/prefetch.h>
+#include <linux/dmi.h>
 
 #include "e1000.h"
 
@@ -6843,6 +6844,17 @@ static int __e1000_resume(struct pci_dev *pdev)
 }
 
 #ifdef CONFIG_PM_SLEEP
+static const struct dmi_system_id s0ix_blacklist[] = {
+	{
+		.ident = "LENOVO ThinkPad X1 Carbon 7th",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad X1 Carbon 7th"),
+		},
+	},
+	{}
+};
+
 static int e1000e_pm_suspend(struct device *dev)
 {
 	struct net_device *netdev = pci_get_drvdata(to_pci_dev(dev));
@@ -6860,7 +6872,7 @@ static int e1000e_pm_suspend(struct device *dev)
 		e1000e_pm_thaw(dev);
 
 	/* Introduce S0ix implementation */
-	if (hw->mac.type >= e1000_pch_cnp)
+	if (hw->mac.type >= e1000_pch_cnp && !dmi_check_system(s0ix_blacklist))
 		e1000e_s0ix_entry_flow(adapter);
 
 	return rc;
@@ -6875,7 +6887,7 @@ static int e1000e_pm_resume(struct device *dev)
 	int rc;
 
 	/* Introduce S0ix implementation */
-	if (hw->mac.type >= e1000_pch_cnp)
+	if (hw->mac.type >= e1000_pch_cnp && !dmi_check_system(s0ix_blacklist))
 		e1000e_s0ix_exit_flow(adapter);
 
 	rc = __e1000_resume(pdev);
-- 
2.17.1


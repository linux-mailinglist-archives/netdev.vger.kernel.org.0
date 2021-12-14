Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F189A473AE2
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 03:50:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244046AbhLNCt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 21:49:59 -0500
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:40036
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232754AbhLNCt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 21:49:58 -0500
Received: from localhost.localdomain (unknown [10.101.196.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 7E33F3F1DF;
        Tue, 14 Dec 2021 02:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1639450196;
        bh=TBSCieeD6Xyn5pgNSxOXJQgpkjb8JVmyX9CU3ONx7Zg=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=hnCsJ+twkygp79OS1+YODpfpAa3dNkzCiK3evw4N0O18DgSo02UAYfB5lNO7TW69V
         PQ2v4eqbV910GOaKEnbdA8FFeoJNkXJj/h1fSoKyq979lzYLEFV60EDPUsFT7/yGJp
         Nji99DPhCIjrydHgRnl1yMLIauLAdmwxNREcMxVyfRX9MErr0B9ci4oNrLEMmhM8w4
         euqf9XgLEyQtiYH3A9y7wIXmp/G31oylacGg/8J8WeOon7UCwLwOJ8FdOSEpiBbuo/
         VJEyHjY9cDrKUaDMYKwXp0w8LDmfozPgLoKWre9yXfSLkhGghMGdHIfj6OrFTjgf6O
         av2fGZB0FuWFg==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     tony0620emma@gmail.com, pkshih@realtek.com
Cc:     jian-hong@endlessm.com,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        Po-Hao Huang <phhuang@realtek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] rtw88: Disable PCIe ASPM while doing NAPI poll on 8821CE
Date:   Tue, 14 Dec 2021 10:49:00 +0800
Message-Id: <20211214024901.223603-1-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Many Intel based platforms face system random freeze after commit
9e2fd29864c5 ("rtw88: add napi support").

The commit itself shouldn't be the culprit. My guess is that the 8821CE
only leaves ASPM L1 for a short period when IRQ is raised. Since IRQ is
masked during NAPI polling, the PCIe link stays at L1 and makes RX DMA
extremely slow. Eventually the RX ring becomes messed up:
[ 1133.194697] rtw_8821ce 0000:02:00.0: pci bus timeout, check dma status

Since the 8821CE hardware may fail to leave ASPM L1, manually do it in
the driver to resolve the issue.

Fixes: 9e2fd29864c5 ("rtw88: add napi support")
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=215131
BugLink: https://bugs.launchpad.net/bugs/1927808
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 74 ++++++++----------------
 drivers/net/wireless/realtek/rtw88/pci.h |  1 +
 2 files changed, 24 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index 3b367c9085eba..f09eb5e2437a9 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -2,7 +2,6 @@
 /* Copyright(c) 2018-2019  Realtek Corporation
  */
 
-#include <linux/dmi.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include "main.h"
@@ -16,10 +15,13 @@
 
 static bool rtw_disable_msi;
 static bool rtw_pci_disable_aspm;
+static int rtw_rx_aspm;
 module_param_named(disable_msi, rtw_disable_msi, bool, 0644);
 module_param_named(disable_aspm, rtw_pci_disable_aspm, bool, 0644);
+module_param_named(rx_aspm, rtw_rx_aspm, int, 0444);
 MODULE_PARM_DESC(disable_msi, "Set Y to disable MSI interrupt support");
 MODULE_PARM_DESC(disable_aspm, "Set Y to disable PCI ASPM support");
+MODULE_PARM_DESC(rx_aspm, "Use PCIe ASPM for RX (0=disable, 1=enable, -1=default)");
 
 static u32 rtw_pci_tx_queue_idx_addr[] = {
 	[RTW_TX_QUEUE_BK]	= RTK_PCI_TXBD_IDX_BKQ,
@@ -1409,7 +1411,11 @@ static void rtw_pci_link_ps(struct rtw_dev *rtwdev, bool enter)
 	 * throughput. This is probably because the ASPM behavior slightly
 	 * varies from different SOC.
 	 */
-	if (rtwpci->link_ctrl & PCI_EXP_LNKCTL_ASPM_L1)
+	if (!(rtwpci->link_ctrl & PCI_EXP_LNKCTL_ASPM_L1))
+		return;
+
+	if ((enter && atomic_dec_return(&rtwpci->link_usage) == 0) ||
+	    (!enter && atomic_inc_return(&rtwpci->link_usage) == 1))
 		rtw_pci_aspm_set(rtwdev, enter);
 }
 
@@ -1658,6 +1664,9 @@ static int rtw_pci_napi_poll(struct napi_struct *napi, int budget)
 					      priv);
 	int work_done = 0;
 
+	if (!rtw_rx_aspm)
+		rtw_pci_link_ps(rtwdev, false);
+
 	while (work_done < budget) {
 		u32 work_done_once;
 
@@ -1681,6 +1690,8 @@ static int rtw_pci_napi_poll(struct napi_struct *napi, int budget)
 		if (rtw_pci_get_hw_rx_ring_nr(rtwdev, rtwpci))
 			napi_schedule(napi);
 	}
+	if (!rtw_rx_aspm)
+		rtw_pci_link_ps(rtwdev, true);
 
 	return work_done;
 }
@@ -1702,59 +1713,13 @@ static void rtw_pci_napi_deinit(struct rtw_dev *rtwdev)
 	netif_napi_del(&rtwpci->napi);
 }
 
-enum rtw88_quirk_dis_pci_caps {
-	QUIRK_DIS_PCI_CAP_MSI,
-	QUIRK_DIS_PCI_CAP_ASPM,
-};
-
-static int disable_pci_caps(const struct dmi_system_id *dmi)
-{
-	uintptr_t dis_caps = (uintptr_t)dmi->driver_data;
-
-	if (dis_caps & BIT(QUIRK_DIS_PCI_CAP_MSI))
-		rtw_disable_msi = true;
-	if (dis_caps & BIT(QUIRK_DIS_PCI_CAP_ASPM))
-		rtw_pci_disable_aspm = true;
-
-	return 1;
-}
-
-static const struct dmi_system_id rtw88_pci_quirks[] = {
-	{
-		.callback = disable_pci_caps,
-		.ident = "Protempo Ltd L116HTN6SPW",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Protempo Ltd"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "L116HTN6SPW"),
-		},
-		.driver_data = (void *)BIT(QUIRK_DIS_PCI_CAP_ASPM),
-	},
-	{
-		.callback = disable_pci_caps,
-		.ident = "HP HP Pavilion Laptop 14-ce0xxx",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion Laptop 14-ce0xxx"),
-		},
-		.driver_data = (void *)BIT(QUIRK_DIS_PCI_CAP_ASPM),
-	},
-	{
-		.callback = disable_pci_caps,
-		.ident = "HP HP 250 G7 Notebook PC",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "HP 250 G7 Notebook PC"),
-		},
-		.driver_data = (void *)BIT(QUIRK_DIS_PCI_CAP_ASPM),
-	},
-	{}
-};
-
 int rtw_pci_probe(struct pci_dev *pdev,
 		  const struct pci_device_id *id)
 {
+	struct pci_dev *bridge = pci_upstream_bridge(pdev);
 	struct ieee80211_hw *hw;
 	struct rtw_dev *rtwdev;
+	struct rtw_pci *rtwpci;
 	int drv_data_size;
 	int ret;
 
@@ -1772,6 +1737,9 @@ int rtw_pci_probe(struct pci_dev *pdev,
 	rtwdev->hci.ops = &rtw_pci_ops;
 	rtwdev->hci.type = RTW_HCI_TYPE_PCIE;
 
+	rtwpci = (struct rtw_pci *)rtwdev->priv;
+	atomic_set(&rtwpci->link_usage, 1);
+
 	ret = rtw_core_init(rtwdev);
 	if (ret)
 		goto err_release_hw;
@@ -1800,7 +1768,11 @@ int rtw_pci_probe(struct pci_dev *pdev,
 		goto err_destroy_pci;
 	}
 
-	dmi_check_system(rtw88_pci_quirks);
+	/* Disable PCIe ASPM L1 while doing NAPI poll for 8821CE */
+	if (pdev->device == 0xc821 && bridge->vendor == PCI_VENDOR_ID_INTEL &&
+	    rtw_rx_aspm == -1)
+		rtw_rx_aspm = 0;
+
 	rtw_pci_phy_cfg(rtwdev);
 
 	ret = rtw_register_hw(rtwdev, hw);
diff --git a/drivers/net/wireless/realtek/rtw88/pci.h b/drivers/net/wireless/realtek/rtw88/pci.h
index 66f78eb7757c5..0aaa12ea03739 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.h
+++ b/drivers/net/wireless/realtek/rtw88/pci.h
@@ -223,6 +223,7 @@ struct rtw_pci {
 	struct rtw_pci_tx_ring tx_rings[RTK_MAX_TX_QUEUE_NUM];
 	struct rtw_pci_rx_ring rx_rings[RTK_MAX_RX_QUEUE_NUM];
 	u16 link_ctrl;
+	atomic_t link_usage;
 	DECLARE_BITMAP(flags, NUM_OF_RTW_PCI_FLAGS);
 
 	void __iomem *mmap;
-- 
2.33.1


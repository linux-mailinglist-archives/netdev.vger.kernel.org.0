Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE44475333
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 07:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240247AbhLOG4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 01:56:02 -0500
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:43188
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240111AbhLOG4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 01:56:01 -0500
Received: from localhost.localdomain (unknown [10.101.196.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 9F2C03F101;
        Wed, 15 Dec 2021 06:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1639551357;
        bh=EIA0fGoQFdQnbnAmf6z60M2mk673OnLBqk9TEiykP5k=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=J0EKCOL5bEycUtBr47Lq8Ds52f1wCmqgOZk6KlIH0aCjKK8UlH2Xb47ImdSk1Tfip
         qy+pIizsZ/Zy+sx+WcXKMjvDGbsDhGNGJWNkha5Hcxn+kKbmqV0baYSjHfqQMVzcHM
         AwNXNBxedb7p/xxOmnTNHHPAYxxVmbLwBk0M/6HDOBygcEL9RqR05Rph5q4xUFaSzf
         DzzEgGu3D6AMVm62tNz3oYVRwhzKfz28LkEHNwzv1T3/1RLYw7YhA6Oxq/TPd1xUWj
         Pa5k4N3U0yXjgNmPfFw3yWSnSphsNhGipsdIGHuDgNaJSzfSZepZzq1Tqqm/CALO/n
         wlSW/mDWezDXw==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     tony0620emma@gmail.com, pkshih@realtek.com
Cc:     jian-hong@endlessm.com,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Po-Hao Huang <phhuang@realtek.com>,
        Brian Norris <briannorris@chromium.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] rtw88: Disable PCIe ASPM while doing NAPI poll on 8821CE
Date:   Wed, 15 Dec 2021 14:55:07 +0800
Message-Id: <20211215065508.313330-1-kai.heng.feng@canonical.com>
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
v3:
 - Move the module parameter to be part of private struct.
 - Ensure link_usage never goes below zero.

v2:
 - Add default value for module parameter.

 drivers/net/wireless/realtek/rtw88/pci.c | 61 ++++++++----------------
 drivers/net/wireless/realtek/rtw88/pci.h |  2 +
 2 files changed, 21 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index a7a6ebfaa203c..08cf66141889b 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -2,7 +2,6 @@
 /* Copyright(c) 2018-2019  Realtek Corporation
  */
 
-#include <linux/dmi.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include "main.h"
@@ -1409,7 +1408,11 @@ static void rtw_pci_link_ps(struct rtw_dev *rtwdev, bool enter)
 	 * throughput. This is probably because the ASPM behavior slightly
 	 * varies from different SOC.
 	 */
-	if (rtwpci->link_ctrl & PCI_EXP_LNKCTL_ASPM_L1)
+	if (!(rtwpci->link_ctrl & PCI_EXP_LNKCTL_ASPM_L1))
+		return;
+
+	if ((enter && atomic_dec_if_positive(&rtwpci->link_usage) == 0) ||
+	    (!enter && atomic_inc_return(&rtwpci->link_usage) == 1))
 		rtw_pci_aspm_set(rtwdev, enter);
 }
 
@@ -1658,6 +1661,9 @@ static int rtw_pci_napi_poll(struct napi_struct *napi, int budget)
 					      priv);
 	int work_done = 0;
 
+	if (rtwpci->rx_no_aspm)
+		rtw_pci_link_ps(rtwdev, false);
+
 	while (work_done < budget) {
 		u32 work_done_once;
 
@@ -1681,6 +1687,8 @@ static int rtw_pci_napi_poll(struct napi_struct *napi, int budget)
 		if (rtw_pci_get_hw_rx_ring_nr(rtwdev, rtwpci))
 			napi_schedule(napi);
 	}
+	if (rtwpci->rx_no_aspm)
+		rtw_pci_link_ps(rtwdev, true);
 
 	return work_done;
 }
@@ -1702,50 +1710,13 @@ static void rtw_pci_napi_deinit(struct rtw_dev *rtwdev)
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
 
@@ -1763,6 +1734,9 @@ int rtw_pci_probe(struct pci_dev *pdev,
 	rtwdev->hci.ops = &rtw_pci_ops;
 	rtwdev->hci.type = RTW_HCI_TYPE_PCIE;
 
+	rtwpci = (struct rtw_pci *)rtwdev->priv;
+	atomic_set(&rtwpci->link_usage, 1);
+
 	ret = rtw_core_init(rtwdev);
 	if (ret)
 		goto err_release_hw;
@@ -1791,7 +1765,10 @@ int rtw_pci_probe(struct pci_dev *pdev,
 		goto err_destroy_pci;
 	}
 
-	dmi_check_system(rtw88_pci_quirks);
+	/* Disable PCIe ASPM L1 while doing NAPI poll for 8821CE */
+	if (pdev->device == 0xc821 && bridge->vendor == PCI_VENDOR_ID_INTEL)
+		rtwpci->rx_no_aspm = true;
+
 	rtw_pci_phy_cfg(rtwdev);
 
 	ret = rtw_register_hw(rtwdev, hw);
diff --git a/drivers/net/wireless/realtek/rtw88/pci.h b/drivers/net/wireless/realtek/rtw88/pci.h
index 66f78eb7757c5..0c37efd8c66fa 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.h
+++ b/drivers/net/wireless/realtek/rtw88/pci.h
@@ -223,6 +223,8 @@ struct rtw_pci {
 	struct rtw_pci_tx_ring tx_rings[RTK_MAX_TX_QUEUE_NUM];
 	struct rtw_pci_rx_ring rx_rings[RTK_MAX_RX_QUEUE_NUM];
 	u16 link_ctrl;
+	atomic_t link_usage;
+	bool rx_no_aspm;
 	DECLARE_BITMAP(flags, NUM_OF_RTW_PCI_FLAGS);
 
 	void __iomem *mmap;
-- 
2.33.1


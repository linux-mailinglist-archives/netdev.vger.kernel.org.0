Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB2873BCDC5
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234005AbhGFLXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:23:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:55702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233483AbhGFLVI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:21:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E4A561C6E;
        Tue,  6 Jul 2021 11:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570260;
        bh=LrqA3Q5ctTV6K0harTnES9skPEHmU3d24hQ7WI8iNiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MYhFxY9DVn/reLKyjtV91/729pQYaYHeTW41OpBnfXdArJgTq86Ae9MmdjKQur0Cq
         oJ0kgU9erUMrA+msD/FeQHeXCs9S9SYHypIiHxV5f0dRULncJtwSdsd+IG859JzKyi
         BWLP+uKKoTb3UE9M3zpoT3mfjiK7QDJCUD5VP5fBZarb0VkFR5Ru7r5eL43La2DK8h
         PYlH9ycpXsqmyRBlqpO6vdo4VJbIsdsy6OvIzNlXsLYBb4ZQdqd62DWbmY1W+KCfx/
         FFy6Ze0PDLpg8Su2ByWNMCAz3CWhBUUKjfkj3Dvu5I3Zrc3nlyGJWvfj/LlvuK8Tsy
         TeC78sOVrhC8Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ping-Ke Shih <pkshih@realtek.com>, Paul Szabo <psz2036@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 156/189] rtw88: add quirks to disable pci capabilities
Date:   Tue,  6 Jul 2021 07:13:36 -0400
Message-Id: <20210706111409.2058071-156-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 956c6d4f20c5446727e0c912dd8f527f2dc7b779 ]

8821CE with ASPM cannot work properly on Protempo Ltd L116HTN6SPW. Add a
quirk to disable the cap.

The reporter describes the symptom is that this module (driver) causes
frequent freezes, randomly but usually within a few minutes of running
(thus very soon after boot): screen display remains frozen, no response
to either keyboard or mouse input. All I can do is to hold the power
button to power off, then reboot.

Reported-by: Paul Szabo <psz2036@gmail.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210607012254.6306-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 32 ++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index f59a4c462e3b..e7d17ab8f113 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2018-2019  Realtek Corporation
  */
 
+#include <linux/dmi.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include "main.h"
@@ -1673,6 +1674,36 @@ static void rtw_pci_napi_deinit(struct rtw_dev *rtwdev)
 	netif_napi_del(&rtwpci->napi);
 }
 
+enum rtw88_quirk_dis_pci_caps {
+	QUIRK_DIS_PCI_CAP_MSI,
+	QUIRK_DIS_PCI_CAP_ASPM,
+};
+
+static int disable_pci_caps(const struct dmi_system_id *dmi)
+{
+	uintptr_t dis_caps = (uintptr_t)dmi->driver_data;
+
+	if (dis_caps & BIT(QUIRK_DIS_PCI_CAP_MSI))
+		rtw_disable_msi = true;
+	if (dis_caps & BIT(QUIRK_DIS_PCI_CAP_ASPM))
+		rtw_pci_disable_aspm = true;
+
+	return 1;
+}
+
+static const struct dmi_system_id rtw88_pci_quirks[] = {
+	{
+		.callback = disable_pci_caps,
+		.ident = "Protempo Ltd L116HTN6SPW",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Protempo Ltd"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "L116HTN6SPW"),
+		},
+		.driver_data = (void *)BIT(QUIRK_DIS_PCI_CAP_ASPM),
+	},
+	{}
+};
+
 int rtw_pci_probe(struct pci_dev *pdev,
 		  const struct pci_device_id *id)
 {
@@ -1723,6 +1754,7 @@ int rtw_pci_probe(struct pci_dev *pdev,
 		goto err_destroy_pci;
 	}
 
+	dmi_check_system(rtw88_pci_quirks);
 	rtw_pci_phy_cfg(rtwdev);
 
 	ret = rtw_register_hw(rtwdev, hw);
-- 
2.30.2


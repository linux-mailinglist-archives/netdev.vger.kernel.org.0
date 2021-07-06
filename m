Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AEC53BD071
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235074AbhGFLd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:33:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:42564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235530AbhGFLaK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:30:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DF6B61DB2;
        Tue,  6 Jul 2021 11:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570479;
        bh=u8Ivap6Yz4KRmQsyQWImKIcEhtJI8QScwssbNbl8UkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JroNzpBZ1oPrWm28ZHgYoJ1yZ/fyreohwh6IuDxSxRVqDa0YRpLxU44b5lj6yOZqJ
         Sepw+Y6jQyvxFQx7aoiGo3Qnq3t1lG6FmqVFpprRhzjQQsLQd3XDXqV2gzyZyx2cVH
         9dahBzRZLOmKGSS4LeAhjUYW5xrApotpaTeq/Vk8xdShusvK/UclNaWK91wk51wiK4
         YpIZxGSZfA7cS1HJkRWnZzRYrOSKjdwgLCYvaUuOWyxWQYO54HUBYolN+fsgzK+oAJ
         rGi8Og/sJA4WdTEyaq1pztx+D12xrrKCm6Wct8KCxYTluCXzwo27HMrpgLY7wxI9Uk
         C2wBy/evEMwvw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ping-Ke Shih <pkshih@realtek.com>, Paul Szabo <psz2036@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 128/160] rtw88: add quirks to disable pci capabilities
Date:   Tue,  6 Jul 2021 07:17:54 -0400
Message-Id: <20210706111827.2060499-128-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
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
index 6b5c885798a4..e5110d2cbc1d 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2018-2019  Realtek Corporation
  */
 
+#include <linux/dmi.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include "main.h"
@@ -1598,6 +1599,36 @@ static void rtw_pci_napi_deinit(struct rtw_dev *rtwdev)
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
@@ -1648,6 +1679,7 @@ int rtw_pci_probe(struct pci_dev *pdev,
 		goto err_destroy_pci;
 	}
 
+	dmi_check_system(rtw88_pci_quirks);
 	rtw_pci_phy_cfg(rtwdev);
 
 	ret = rtw_register_hw(rtwdev, hw);
-- 
2.30.2


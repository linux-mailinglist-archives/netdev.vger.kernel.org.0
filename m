Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EEE129E2F7
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbgJ1Vdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 17:33:49 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46794 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbgJ1Vdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:33:47 -0400
Received: by mail-pf1-f194.google.com with SMTP id y14so510537pfp.13;
        Wed, 28 Oct 2020 14:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O16ozSgNVeUbZNwvfhn7rD7cA+u7qcU4L0YeQ5QzNhI=;
        b=jOYQNnY9IfokAO0ZMFdny3vr+8MYjeJt17M9HL/enN+XfZ5GFHdYKdxBOn3lbJnUIv
         jFQLU3BAla+q4MLprOD6h42sZW0i2YqaYK+FoXD6CV+I+Il4mazbkzfJpIbnI3JFcYge
         uoFtOgLD6CwiGAnAE8bN32EQkiHaC5Y4d5gD3rFWxTFYUGfDTbqRHNGuKNZot00dTX/6
         zMpS3roJ7892WDowTxKa16WKk3TUYrCUPeHc/pjE+G5jCI6zCXwRVkujD5O5cis1sfwX
         bPpn7sn8o+VsbOSDoz7/w22rwF/rR1/AUz1RhQuq24Kgt30cXGst1G4ejvHNgt8RQ16L
         5/8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O16ozSgNVeUbZNwvfhn7rD7cA+u7qcU4L0YeQ5QzNhI=;
        b=cXqbabA1gleTjpnoXnSgVhMqYOrz5+Sik703VWqTEY0WG5YBn8cBYC3upFpZPNOcSM
         TNN93yhRZhJ7d8i3GuLPXBfb62Y/lpK6XBs/83Yji5daQRpKE1Elfc0TulGsc2ZTHoqm
         wD5qcAGFPk8v9iSLdpzlB6FRVNY1uPZ0A9tQQv0OEa8/1hjDwFLIyNh+uaL6jWblGyEG
         0ldXpei0P1oZusFnUeBe2H4dIEJ7nDMZvEYCl7Eo6NC4n4QJ8s0C+bB4DnWSZN/q/X1C
         9nuCYPthx4gARLp2Y7uZ9Da9fHfz96sqL/66CwQCKgWmlnoYa0VZ5Y20Hoo1NVHK6WM0
         UGlQ==
X-Gm-Message-State: AOAM533ISeN18wJaFdxY6o5bG2bZbWd2qLbrlav4BozYxcgutgRrlwcA
        5DQD214iBZv/c40tZpn6xHr1fc1GXtnyt9oY
X-Google-Smtp-Source: ABdhPJyxd0WqzPwiTiazqJqvnqrghz5YeFG+0daHa8O+g7tvBTOBB0Ji13PCAj0J9kgGD6HyIODEYQ==
X-Received: by 2002:a17:902:bd43:b029:d6:820d:cb85 with SMTP id b3-20020a170902bd43b02900d6820dcb85mr240758plx.37.1603895314671;
        Wed, 28 Oct 2020 07:28:34 -0700 (PDT)
Received: from k5-sbwpb.flets-east.jp (i60-35-254-237.s41.a020.ap.plala.or.jp. [60.35.254.237])
        by smtp.gmail.com with ESMTPSA id g67sm6581754pfb.9.2020.10.28.07.28.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 07:28:34 -0700 (PDT)
From:   Tsuchiya Yuto <kitakar@gmail.com>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@intel.com>, verdre@v0yd.nl,
        Tsuchiya Yuto <kitakar@gmail.com>
Subject: [RFC PATCH 2/3] mwifiex: pcie: add reset_d3cold quirk for Surface gen4+ devices
Date:   Wed, 28 Oct 2020 23:27:52 +0900
Message-Id: <20201028142753.18855-3-kitakar@gmail.com>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201028142753.18855-1-kitakar@gmail.com>
References: <20201028142753.18855-1-kitakar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To reset mwifiex on Surface gen4+ (Pro 4 or later gen) devices, it
seems that putting the wifi device into D3cold is required according
to errata.inf file on Windows installation (Windows/INF/errata.inf).

This patch adds a function that performs power-cycle (put into D3cold
then D0) and call the function at the end of reset_prepare().

Note: Need to also reset the parent device (bridge) of wifi on SB1;
it might be because the bridge of wifi always reports it's in D3hot.
When I tried to reset only the wifi device (not touching parent), it gave
the following error and the reset failed:

    acpi device:4b: Cannot transition to power state D0 for parent in D3hot
    mwifiex_pcie 0000:03:00.0: can't change power state from D3cold to D0 (config space inaccessible)

Signed-off-by: Tsuchiya Yuto <kitakar@gmail.com>
---
Current issue:
* After reset with this quirk, ASPM settings don't get restored.

Below is the "sudo lspci -nnvvv" diff before/after fw reset on Surface Book 1:

    #
    # 03:00.0 Ethernet controller [0200]: Marvell Technology Group Ltd. 88W8897 [AVASTAR] 802.11ac Wireless [11ab:2b38]
    #
    @@ -574,9 +574,9 @@
            Capabilities: [168 v1] L1 PM Substates
                    L1SubCap: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+ L1_PM_Substates+
                              PortCommonModeRestoreTime=70us PortTPowerOnTime=10us
    -               L1SubCtl1: PCI-PM_L1.2+ PCI-PM_L1.1+ ASPM_L1.2+ ASPM_L1.1+
    -                          T_CommonMode=0us LTR1.2_Threshold=163840ns
    -               L1SubCtl2: T_PwrOn=44us
    +               L1SubCtl1: PCI-PM_L1.2- PCI-PM_L1.1- ASPM_L1.2- ASPM_L1.1-
    +                          T_CommonMode=0us LTR1.2_Threshold=0ns
    +               L1SubCtl2: T_PwrOn=10us
            Kernel driver in use: mwifiex_pcie
            Kernel modules: mwifiex_pcie
    
    #
    # no changes on root port of wifi regarding ASPM
    #

As you see, all of the L1 substates are disabled after fw reset. LTR
value is also changed.

 drivers/net/wireless/marvell/mwifiex/pcie.c   |  7 ++
 .../wireless/marvell/mwifiex/pcie_quirks.c    | 73 +++++++++++++++++--
 .../wireless/marvell/mwifiex/pcie_quirks.h    |  3 +-
 3 files changed, 74 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 362cf10debfa0..c0c4b5a9149ab 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -529,6 +529,13 @@ static void mwifiex_pcie_reset_prepare(struct pci_dev *pdev)
 	mwifiex_shutdown_sw(adapter);
 	clear_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &card->work_flags);
 	clear_bit(MWIFIEX_IFACE_WORK_CARD_RESET, &card->work_flags);
+
+	/* For Surface gen4+ devices, we need to put wifi into D3cold right
+	 * before performing FLR
+	 */
+	if (card->quirks & QUIRK_FW_RST_D3COLD)
+		mwifiex_pcie_reset_d3cold_quirk(pdev);
+
 	mwifiex_dbg(adapter, INFO, "%s, successful\n", __func__);
 }
 
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
index 929aee2b0a60a..edc739c542fea 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.c
@@ -21,7 +21,7 @@ static const struct dmi_system_id mwifiex_quirk_table[] = {
 			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
 			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Pro 4"),
 		},
-		.driver_data = 0,
+		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
 	},
 	{
 		.ident = "Surface Pro 5",
@@ -30,7 +30,7 @@ static const struct dmi_system_id mwifiex_quirk_table[] = {
 			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
 			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "Surface_Pro_1796"),
 		},
-		.driver_data = 0,
+		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
 	},
 	{
 		.ident = "Surface Pro 5 (LTE)",
@@ -39,7 +39,7 @@ static const struct dmi_system_id mwifiex_quirk_table[] = {
 			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
 			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "Surface_Pro_1807"),
 		},
-		.driver_data = 0,
+		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
 	},
 	{
 		.ident = "Surface Pro 6",
@@ -47,7 +47,7 @@ static const struct dmi_system_id mwifiex_quirk_table[] = {
 			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
 			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Pro 6"),
 		},
-		.driver_data = 0,
+		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
 	},
 	{
 		.ident = "Surface Book 1",
@@ -55,7 +55,7 @@ static const struct dmi_system_id mwifiex_quirk_table[] = {
 			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
 			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Book"),
 		},
-		.driver_data = 0,
+		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
 	},
 	{
 		.ident = "Surface Book 2",
@@ -63,7 +63,7 @@ static const struct dmi_system_id mwifiex_quirk_table[] = {
 			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
 			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Book 2"),
 		},
-		.driver_data = 0,
+		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
 	},
 	{
 		.ident = "Surface Laptop 1",
@@ -71,7 +71,7 @@ static const struct dmi_system_id mwifiex_quirk_table[] = {
 			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
 			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Laptop"),
 		},
-		.driver_data = 0,
+		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
 	},
 	{
 		.ident = "Surface Laptop 2",
@@ -79,7 +79,7 @@ static const struct dmi_system_id mwifiex_quirk_table[] = {
 			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
 			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Surface Laptop 2"),
 		},
-		.driver_data = 0,
+		.driver_data = (void *)QUIRK_FW_RST_D3COLD,
 	},
 	{
 		.ident = "Surface 3",
@@ -111,4 +111,61 @@ void mwifiex_initialize_quirks(struct pcie_service_card *card)
 
 	if (!card->quirks)
 		dev_info(&pdev->dev, "no quirks enabled\n");
+	if (card->quirks & QUIRK_FW_RST_D3COLD)
+		dev_info(&pdev->dev, "quirk reset_d3cold enabled\n");
+}
+
+static void mwifiex_pcie_set_power_d3cold(struct pci_dev *pdev)
+{
+	dev_info(&pdev->dev, "putting into D3cold...\n");
+
+	pci_save_state(pdev);
+	if (pci_is_enabled(pdev))
+		pci_disable_device(pdev);
+	pci_set_power_state(pdev, PCI_D3cold);
+}
+
+static int mwifiex_pcie_set_power_d0(struct pci_dev *pdev)
+{
+	int ret;
+
+	dev_info(&pdev->dev, "putting into D0...\n");
+
+	pci_set_power_state(pdev, PCI_D0);
+	ret = pci_enable_device(pdev);
+	if (ret) {
+		dev_err(&pdev->dev, "pci_enable_device failed\n");
+		return ret;
+	}
+	pci_restore_state(pdev);
+
+	return 0;
+}
+
+int mwifiex_pcie_reset_d3cold_quirk(struct pci_dev *pdev)
+{
+	struct pci_dev *parent_pdev = pci_upstream_bridge(pdev);
+	int ret;
+
+	/* Power-cycle (put into D3cold then D0) */
+	dev_info(&pdev->dev, "Using reset_d3cold quirk to perform FW reset\n");
+
+	/* We need to perform power-cycle also for bridge of wifi because
+	 * on some devices (e.g. Surface Book 1), the OS for some reasons
+	 * can't know the real power state of the bridge.
+	 * When tried to power-cycle only wifi, the reset failed with the
+	 * following dmesg log:
+	 * "Cannot transition to power state D0 for parent in D3hot".
+	 */
+	mwifiex_pcie_set_power_d3cold(pdev);
+	mwifiex_pcie_set_power_d3cold(parent_pdev);
+
+	ret = mwifiex_pcie_set_power_d0(parent_pdev);
+	if (ret)
+		return ret;
+	ret = mwifiex_pcie_set_power_d0(pdev);
+	if (ret)
+		return ret;
+
+	return 0;
 }
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h
index 5326ae7e56713..8b9dcb5070d87 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h
+++ b/drivers/net/wireless/marvell/mwifiex/pcie_quirks.h
@@ -6,6 +6,7 @@
 #include "pcie.h"
 
 /* quirks */
-// quirk flags can be added here
+#define QUIRK_FW_RST_D3COLD	BIT(0)
 
 void mwifiex_initialize_quirks(struct pcie_service_card *card);
+int mwifiex_pcie_reset_d3cold_quirk(struct pci_dev *pdev);
-- 
2.29.1


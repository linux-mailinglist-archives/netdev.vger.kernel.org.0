Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5D7483CF0
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 08:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233660AbiADHch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 02:32:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233680AbiADHcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 02:32:19 -0500
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3BBCC061396;
        Mon,  3 Jan 2022 23:32:18 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 0D2AF4206F;
        Tue,  4 Jan 2022 07:32:09 +0000 (UTC)
From:   Hector Martin <marcan@marcan.st>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Dmitry Osipenko <digetx@gmail.com>
Cc:     Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Subject: [PATCH v2 34/35] brcmfmac: pcie: Load and provide TxCap blobs
Date:   Tue,  4 Jan 2022 16:26:57 +0900
Message-Id: <20220104072658.69756-35-marcan@marcan.st>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220104072658.69756-1-marcan@marcan.st>
References: <20220104072658.69756-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These blobs are named .txcap_blob, and exist alongside the existing
.clm_blob files. Use the existing firmware machinery to provide them to
the core.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Hector Martin <marcan@marcan.st>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 18903906de55..ee0b68f5e28e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -73,6 +73,7 @@ MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-pcie.*.txt");
 /* per-board firmware binaries */
 MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-pcie.*.bin");
 MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-pcie.*.clm_blob");
+MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-pcie.*.txcap_blob");
 
 static const struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
 	BRCMF_FW_ENTRY(BRCM_CC_43602_CHIP_ID, 0xFFFFFFFF, 43602),
@@ -325,7 +326,9 @@ struct brcmf_pciedev_info {
 	char fw_name[BRCMF_FW_NAME_LEN];
 	char nvram_name[BRCMF_FW_NAME_LEN];
 	char clm_name[BRCMF_FW_NAME_LEN];
+	char txcap_name[BRCMF_FW_NAME_LEN];
 	const struct firmware *clm_fw;
+	const struct firmware *txcap_fw;
 	const struct brcmf_pcie_reginfo *reginfo;
 	void __iomem *regs;
 	void __iomem *tcm;
@@ -1499,6 +1502,10 @@ static int brcmf_pcie_get_blob(struct device *dev, const struct firmware **fw,
 		*fw = devinfo->clm_fw;
 		devinfo->clm_fw = NULL;
 		break;
+	case BRCMF_BLOB_TXCAP:
+		*fw = devinfo->txcap_fw;
+		devinfo->txcap_fw = NULL;
+		break;
 	default:
 		return -ENOENT;
 	}
@@ -2088,6 +2095,7 @@ static int brcmf_pcie_read_otp(struct brcmf_pciedev_info *devinfo)
 #define BRCMF_PCIE_FW_CODE	0
 #define BRCMF_PCIE_FW_NVRAM	1
 #define BRCMF_PCIE_FW_CLM	2
+#define BRCMF_PCIE_FW_TXCAP	3
 
 static void brcmf_pcie_setup(struct device *dev, int ret,
 			     struct brcmf_fw_request *fwreq)
@@ -2113,6 +2121,7 @@ static void brcmf_pcie_setup(struct device *dev, int ret,
 	nvram = fwreq->items[BRCMF_PCIE_FW_NVRAM].nv_data.data;
 	nvram_len = fwreq->items[BRCMF_PCIE_FW_NVRAM].nv_data.len;
 	devinfo->clm_fw = fwreq->items[BRCMF_PCIE_FW_CLM].binary;
+	devinfo->txcap_fw = fwreq->items[BRCMF_PCIE_FW_TXCAP].binary;
 	kfree(fwreq);
 
 	ret = brcmf_chip_get_raminfo(devinfo->ci);
@@ -2189,6 +2198,7 @@ brcmf_pcie_prepare_fw_request(struct brcmf_pciedev_info *devinfo)
 		{ ".bin", devinfo->fw_name },
 		{ ".txt", devinfo->nvram_name },
 		{ ".clm_blob", devinfo->clm_name },
+		{ ".txcap_blob", devinfo->txcap_name },
 	};
 
 	fwreq = brcmf_fw_alloc_request(devinfo->ci->chip, devinfo->ci->chiprev,
@@ -2203,6 +2213,8 @@ brcmf_pcie_prepare_fw_request(struct brcmf_pciedev_info *devinfo)
 	fwreq->items[BRCMF_PCIE_FW_NVRAM].flags = BRCMF_FW_REQF_OPTIONAL;
 	fwreq->items[BRCMF_PCIE_FW_CLM].type = BRCMF_FW_TYPE_BINARY;
 	fwreq->items[BRCMF_PCIE_FW_CLM].flags = BRCMF_FW_REQF_OPTIONAL;
+	fwreq->items[BRCMF_PCIE_FW_TXCAP].type = BRCMF_FW_TYPE_BINARY;
+	fwreq->items[BRCMF_PCIE_FW_TXCAP].flags = BRCMF_FW_REQF_OPTIONAL;
 	/* NVRAM reserves PCI domain 0 for Broadcom's SDK faked bus */
 	fwreq->domain_nr = pci_domain_nr(devinfo->pdev->bus) + 1;
 	fwreq->bus_nr = devinfo->pdev->bus->number;
@@ -2412,6 +2424,7 @@ brcmf_pcie_remove(struct pci_dev *pdev)
 	brcmf_pcie_reset_device(devinfo);
 	brcmf_pcie_release_resource(devinfo);
 	release_firmware(devinfo->clm_fw);
+	release_firmware(devinfo->txcap_fw);
 
 	if (devinfo->ci)
 		brcmf_chip_detach(devinfo->ci);
-- 
2.33.0


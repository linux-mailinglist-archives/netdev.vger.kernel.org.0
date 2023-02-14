Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B821695F18
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 10:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbjBNJ1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 04:27:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231817AbjBNJ0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 04:26:52 -0500
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F78A2412E;
        Tue, 14 Feb 2023 01:26:19 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sendonly@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id AEDC541EF0;
        Tue, 14 Feb 2023 09:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1676366772; bh=0MNx/xAg+051NT7qim3e5S9789fRX1Q/YPUrHgcdw1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=NFjHuCaLJPz6oFNpgJ2Tz0GfqC6RJ42TYCM3pw3J+JBt89ysc8y4SyiykLiDoVxQ+
         K2L3PMeh46NBV8y1w2PG9wcyeJPEJxPiXMM+3n8FHg9z5Rn1C+IyPB6C0ii98DRLMd
         8J8L+MLSxPNhEsfvRlBgRxhdNK1+Hg4AU6inhET/z7osOA5SaCW2ZoX88dPoQtckoi
         O38z0/kAdIDV59gvO4yC0+YydL7GK8ljTuaVuWyOgHSTOouY0MdfmQXir/Hm7hjieR
         9GofDLN7YV3csGTD3fqtf7uOevZB7xbQ1cdz5vz2skCOh4VQ7IRgg+1sLiIObMAaqM
         u94NZZWwEQvSg==
From:   Hector Martin <marcan@marcan.st>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Linus Walleij <linus.walleij@linaro.org>,
        asahi@lists.linux.dev, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hector Martin <marcan@marcan.st>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 09/10] brcmfmac: pcie: Load and provide TxCap blobs
Date:   Tue, 14 Feb 2023 18:24:22 +0900
Message-Id: <20230214092423.15175-9-marcan@marcan.st>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230214091651.10178-1-marcan@marcan.st>
References: <20230214091651.10178-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These blobs are named .txcap_blob, and exist alongside the existing
.clm_blob files. Use the existing firmware machinery to provide them to
the core.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Hector Martin <marcan@marcan.st>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 09076a3cc4de..7ee532ab8e85 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -75,6 +75,7 @@ MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-pcie.*.txt");
 /* per-board firmware binaries */
 MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-pcie.*.bin");
 MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-pcie.*.clm_blob");
+MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-pcie.*.txcap_blob");
 
 static const struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
 	BRCMF_FW_ENTRY(BRCM_CC_43602_CHIP_ID, 0xFFFFFFFF, 43602),
@@ -328,7 +329,9 @@ struct brcmf_pciedev_info {
 	char fw_name[BRCMF_FW_NAME_LEN];
 	char nvram_name[BRCMF_FW_NAME_LEN];
 	char clm_name[BRCMF_FW_NAME_LEN];
+	char txcap_name[BRCMF_FW_NAME_LEN];
 	const struct firmware *clm_fw;
+	const struct firmware *txcap_fw;
 	const struct brcmf_pcie_reginfo *reginfo;
 	void __iomem *regs;
 	void __iomem *tcm;
@@ -1519,6 +1522,10 @@ static int brcmf_pcie_get_blob(struct device *dev, const struct firmware **fw,
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
@@ -2080,6 +2087,7 @@ static int brcmf_pcie_read_otp(struct brcmf_pciedev_info *devinfo)
 #define BRCMF_PCIE_FW_CODE	0
 #define BRCMF_PCIE_FW_NVRAM	1
 #define BRCMF_PCIE_FW_CLM	2
+#define BRCMF_PCIE_FW_TXCAP	3
 
 static void brcmf_pcie_setup(struct device *dev, int ret,
 			     struct brcmf_fw_request *fwreq)
@@ -2106,6 +2114,7 @@ static void brcmf_pcie_setup(struct device *dev, int ret,
 	nvram = fwreq->items[BRCMF_PCIE_FW_NVRAM].nv_data.data;
 	nvram_len = fwreq->items[BRCMF_PCIE_FW_NVRAM].nv_data.len;
 	devinfo->clm_fw = fwreq->items[BRCMF_PCIE_FW_CLM].binary;
+	devinfo->txcap_fw = fwreq->items[BRCMF_PCIE_FW_TXCAP].binary;
 	kfree(fwreq);
 
 	ret = brcmf_chip_get_raminfo(devinfo->ci);
@@ -2187,6 +2196,7 @@ brcmf_pcie_prepare_fw_request(struct brcmf_pciedev_info *devinfo)
 		{ ".bin", devinfo->fw_name },
 		{ ".txt", devinfo->nvram_name },
 		{ ".clm_blob", devinfo->clm_name },
+		{ ".txcap_blob", devinfo->txcap_name },
 	};
 
 	fwreq = brcmf_fw_alloc_request(devinfo->ci->chip, devinfo->ci->chiprev,
@@ -2201,6 +2211,8 @@ brcmf_pcie_prepare_fw_request(struct brcmf_pciedev_info *devinfo)
 	fwreq->items[BRCMF_PCIE_FW_NVRAM].flags = BRCMF_FW_REQF_OPTIONAL;
 	fwreq->items[BRCMF_PCIE_FW_CLM].type = BRCMF_FW_TYPE_BINARY;
 	fwreq->items[BRCMF_PCIE_FW_CLM].flags = BRCMF_FW_REQF_OPTIONAL;
+	fwreq->items[BRCMF_PCIE_FW_TXCAP].type = BRCMF_FW_TYPE_BINARY;
+	fwreq->items[BRCMF_PCIE_FW_TXCAP].flags = BRCMF_FW_REQF_OPTIONAL;
 	/* NVRAM reserves PCI domain 0 for Broadcom's SDK faked bus */
 	fwreq->domain_nr = pci_domain_nr(devinfo->pdev->bus) + 1;
 	fwreq->bus_nr = devinfo->pdev->bus->number;
@@ -2498,6 +2510,7 @@ brcmf_pcie_remove(struct pci_dev *pdev)
 	brcmf_pcie_reset_device(devinfo);
 	brcmf_pcie_release_resource(devinfo);
 	release_firmware(devinfo->clm_fw);
+	release_firmware(devinfo->txcap_fw);
 
 	if (devinfo->ci)
 		brcmf_chip_detach(devinfo->ci);
-- 
2.35.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE7F33007C
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 12:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbhCGLrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 06:47:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbhCGLrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 06:47:00 -0500
X-Greylist: delayed 576 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 07 Mar 2021 03:46:59 PST
Received: from relay03.th.seeweb.it (relay03.th.seeweb.it [IPv6:2001:4b7a:2000:18::164])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2CD7C06174A
        for <netdev@vger.kernel.org>; Sun,  7 Mar 2021 03:46:59 -0800 (PST)
Received: from localhost.localdomain (abac94.neoplus.adsl.tpnet.pl [83.6.166.94])
        by m-r1.th.seeweb.it (Postfix) with ESMTPA id B0C891F50F;
        Sun,  7 Mar 2021 12:37:11 +0100 (CET)
From:   Konrad Dybcio <konrad.dybcio@somainline.org>
To:     phone-devel@vger.kernel.org
Cc:     ~postmarketos/upstreaming@lists.sr.ht, martin.botka@somainline.org,
        angelogioacchino.delregno@somainline.org,
        marijn.suijten@somainline.org,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] brcmfmac: Add support for BCM43596 PCIe Wi-Fi
Date:   Sun,  7 Mar 2021 12:35:45 +0100
Message-Id: <20210307113550.7720-1-konrad.dybcio@somainline.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for BCM43596 dual-band AC chip, found in
SONY Xperia X Performance, XZ and XZs smartphones (and
*possibly* other devices from other manufacturers).
The chip doesn't require any special handling and seems to work
just fine OOTB.

PCIe IDs taken from: https://github.com/sonyxperiadev/kernel/commit/9e43fefbac8e43c3d7792e73ca52a052dd86d7e3.patch

Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c       | 2 ++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c       | 4 ++++
 drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h | 4 ++++
 3 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index 45037decba40..38ca0517f3cf 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -723,6 +723,7 @@ static u32 brcmf_chip_tcm_rambase(struct brcmf_chip_priv *ci)
 	case BRCM_CC_43666_CHIP_ID:
 		return 0x200000;
 	case BRCM_CC_4359_CHIP_ID:
+	case BRCM_CC_43596_CHIP_ID:
 		return (ci->pub.chiprev < 9) ? 0x180000 : 0x160000;
 	case BRCM_CC_4364_CHIP_ID:
 	case CY_CC_4373_CHIP_ID:
@@ -1411,6 +1412,7 @@ bool brcmf_chip_sr_capable(struct brcmf_chip *pub)
 		reg = chip->ops->read32(chip->ctx, addr);
 		return (reg & CC_SR_CTL0_ENABLE_MASK) != 0;
 	case BRCM_CC_4359_CHIP_ID:
+	case BRCM_CC_43596_CHIP_ID:
 	case CY_CC_43012_CHIP_ID:
 		addr = CORE_CC_REG(pmu->base, retention_ctl);
 		reg = chip->ops->read32(chip->ctx, addr);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index ad79e3b7e74a..da604fa17f94 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -71,6 +71,7 @@ static const struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
 	BRCMF_FW_ENTRY(BRCM_CC_43570_CHIP_ID, 0xFFFFFFFF, 43570),
 	BRCMF_FW_ENTRY(BRCM_CC_4358_CHIP_ID, 0xFFFFFFFF, 4358),
 	BRCMF_FW_ENTRY(BRCM_CC_4359_CHIP_ID, 0xFFFFFFFF, 4359),
+	BRCMF_FW_ENTRY(BRCM_CC_43596_CHIP_ID, 0xFFFFFFFF, 4359),
 	BRCMF_FW_ENTRY(BRCM_CC_4364_CHIP_ID, 0xFFFFFFFF, 4364),
 	BRCMF_FW_ENTRY(BRCM_CC_4365_CHIP_ID, 0x0000000F, 4365B),
 	BRCMF_FW_ENTRY(BRCM_CC_4365_CHIP_ID, 0xFFFFFFF0, 4365C),
@@ -2107,6 +2108,9 @@ static const struct pci_device_id brcmf_pcie_devid_table[] = {
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43570_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4358_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_4359_DEVICE_ID),
+	BRCMF_PCIE_DEVICE(BRCM_PCIE_43596_DEVICE_ID),
+	BRCMF_PCIE_DEVICE(BRCM_PCIE_43596_2G_DEVICE_ID),
+	BRCMF_PCIE_DEVICE(BRCM_PCIE_43596_5G_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43602_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43602_2G_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43602_5G_DEVICE_ID),
diff --git a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
index 00309b272a0e..03542c096e40 100644
--- a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
+++ b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
@@ -43,6 +43,7 @@
 #define BRCM_CC_43570_CHIP_ID		43570
 #define BRCM_CC_4358_CHIP_ID		0x4358
 #define BRCM_CC_4359_CHIP_ID		0x4359
+#define BRCM_CC_43596_CHIP_ID		43596
 #define BRCM_CC_43602_CHIP_ID		43602
 #define BRCM_CC_4364_CHIP_ID		0x4364
 #define BRCM_CC_4365_CHIP_ID		0x4365
@@ -72,6 +73,9 @@
 #define BRCM_PCIE_43570_DEVICE_ID	0x43d9
 #define BRCM_PCIE_4358_DEVICE_ID	0x43e9
 #define BRCM_PCIE_4359_DEVICE_ID	0x43ef
+#define BRCM_PCIE_43596_DEVICE_ID	0x4415
+#define BRCM_PCIE_43596_2G_DEVICE_ID	0x4416
+#define BRCM_PCIE_43596_5G_DEVICE_ID	0x4417
 #define BRCM_PCIE_43602_DEVICE_ID	0x43ba
 #define BRCM_PCIE_43602_2G_DEVICE_ID	0x43bb
 #define BRCM_PCIE_43602_5G_DEVICE_ID	0x43bc
-- 
2.30.1


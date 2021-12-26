Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D825547F7A2
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 16:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233954AbhLZPiD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 10:38:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233947AbhLZPhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Dec 2021 10:37:50 -0500
X-Greylist: delayed 72 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 26 Dec 2021 07:37:50 PST
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CCABC06175B;
        Sun, 26 Dec 2021 07:37:50 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 882EB44B42;
        Sun, 26 Dec 2021 15:37:41 +0000 (UTC)
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
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>
Cc:     Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Daniel (Deognyoun) Kim" <dekim@broadcom.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Subject: [PATCH 09/34] brcmfmac: pcie: Perform firmware selection for Apple platforms
Date:   Mon, 27 Dec 2021 00:35:59 +0900
Message-Id: <20211226153624.162281-10-marcan@marcan.st>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211226153624.162281-1-marcan@marcan.st>
References: <20211226153624.162281-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Apple platforms, firmware selection uses the following elements:

  Property         Example   Source
  ==============   =======   ========================
* Chip name        4378      Device ID
* Chip revision    B1        OTP
* Platform         shikoku   DT (ARM64) or ACPI (x86)
* Module type      RASP      OTP
* Module vendor    m         OTP
* Module version   6.11      OTP
* Antenna SKU      X3        DT (ARM64) or ??? (x86)

In macOS, these firmwares are stored using filenames in this format
under /usr/share/firmware/wifi:

    C-4378__s-B1/P-shikoku-X3_M-RASP_V-m__m-6.11.txt

To prepare firmwares for Linux, we rename these to a scheme following
the existing brcmfmac convention:

    brcmfmac<chip><lower(rev)>-pcie.apple,<platform>-<mod_type>-\
	<mod_vendor>-<mod_version>-<antenna_sku>.txt

The NVRAM uses all the components, while the firmware and CLM blob only
use the chip/revision/platform/antenna_sku:

    brcmfmac<chip><lower(rev)>-pcie.apple,<platform>-<antenna_sku>.bin

e.g.

    brcm/brcmfmac4378b1-pcie.apple,shikoku-RASP-m-6.11-X3.txt
    brcm/brcmfmac4378b1-pcie.apple,shikoku-X3.bin

In addition, since there are over 1000 files in total, many of which are
symlinks or outright duplicates, we deduplicate and prune the firmware
tree to reduce firmware filenames to fewer dimensions. For example, the
shikoku platform (MacBook Air M1 2020) simplifies to just 4 files:

    brcm/brcmfmac4378b1-pcie.apple,shikoku.clm_blob
    brcm/brcmfmac4378b1-pcie.apple,shikoku.bin
    brcm/brcmfmac4378b1-pcie.apple,shikoku-RASP-m.txt
    brcm/brcmfmac4378b1-pcie.apple,shikoku-RASP-u.txt

This reduces the total file count to around 170, of which 75 are
symlinks and 95 are regular files: 7 firmware blobs, 27 CLM blobs, and
61 NVRAM config files. We also slightly process NVRAM files to correct
some formatting issues and add a missing default macaddr= property.

To handle this, the driver must try the following path formats when
looking for firmware files:

    brcm/brcmfmac4378b1-pcie.apple,shikoku-RASP-m-6.11-X3.txt
    brcm/brcmfmac4378b1-pcie.apple,shikoku-RASP-m-6.11.txt
    brcm/brcmfmac4378b1-pcie.apple,shikoku-RASP-m.txt
    brcm/brcmfmac4378b1-pcie.apple,shikoku-RASP.txt
    brcm/brcmfmac4378b1-pcie.apple,shikoku-X3.txt *
    brcm/brcmfmac4378b1-pcie.apple,shikoku.txt

* Not relevant for NVRAM, only for firmware/CLM.

The chip revision nominally comes from OTP on Apple platforms, but it
can be mapped to the PCI revision number, so we ignore the OTP revision
and continue to use the existing PCI revision mechanism to identify chip
revisions, as the driver already does for other chips. Unfortunately,
the mapping is not consistent between different chip types, so this has
to be determined experimentally.

Signed-off-by: Hector Martin <marcan@marcan.st>
---
 .../broadcom/brcm80211/brcmfmac/pcie.c        | 68 +++++++++++++++++--
 1 file changed, 63 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 49cb5254fa6e..d31f5a668cec 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -2094,11 +2094,69 @@ brcmf_pcie_prepare_fw_request(struct brcmf_pciedev_info *devinfo)
 	fwreq->domain_nr = pci_domain_nr(devinfo->pdev->bus) + 1;
 	fwreq->bus_nr = devinfo->pdev->bus->number;
 
-	brcmf_dbg(PCIE, "Board: %s\n", devinfo->settings->board_type);
-	fwreq->board_types = devm_kzalloc(&devinfo->pdev->dev,
-					  sizeof(const char *) * 2,
-					  GFP_KERNEL);
-	fwreq->board_types[0] = devinfo->settings->board_type;
+	/* Apple platforms with fancy firmware/NVRAM selection */
+	if (devinfo->settings->board_type &&
+	    devinfo->settings->antenna_sku &&
+	    devinfo->otp.valid) {
+		char *buf;
+		int len;
+
+		brcmf_dbg(PCIE, "Apple board: %s\n",
+			  devinfo->settings->board_type);
+
+		/* Example: apple,shikoku-RASP-m-6.11-X3 */
+		len = (strlen(devinfo->settings->board_type) + 1 +
+		       strlen(devinfo->otp.module) + 1 +
+		       strlen(devinfo->otp.vendor) + 1 +
+		       strlen(devinfo->otp.version) + 1 +
+		       strlen(devinfo->settings->antenna_sku) + 1);
+
+		fwreq->board_types = devm_kzalloc(&devinfo->pdev->dev,
+						  sizeof(const char *) * 7,
+						  GFP_KERNEL);
+
+		/* apple,shikoku */
+		fwreq->board_types[5] = devinfo->settings->board_type;
+
+		buf = devm_kzalloc(&devinfo->pdev->dev, len, GFP_KERNEL);
+
+		strscpy(buf, devinfo->settings->board_type, len);
+		strlcat(buf, "-", len);
+		strlcat(buf, devinfo->settings->antenna_sku, len);
+		/* apple,shikoku-X3 */
+		fwreq->board_types[4] = devm_kstrdup(&devinfo->pdev->dev, buf,
+						     GFP_KERNEL);
+
+		strscpy(buf, devinfo->settings->board_type, len);
+		strlcat(buf, "-", len);
+		strlcat(buf, devinfo->otp.module, len);
+		/* apple,shikoku-RASP */
+		fwreq->board_types[3] = devm_kstrdup(&devinfo->pdev->dev, buf,
+						     GFP_KERNEL);
+
+		strlcat(buf, "-", len);
+		strlcat(buf, devinfo->otp.vendor, len);
+		/* apple,shikoku-RASP-m */
+		fwreq->board_types[2] = devm_kstrdup(&devinfo->pdev->dev, buf,
+						     GFP_KERNEL);
+
+		strlcat(buf, "-", len);
+		strlcat(buf, devinfo->otp.version, len);
+		/* apple,shikoku-RASP-m-6.11 */
+		fwreq->board_types[1] = devm_kstrdup(&devinfo->pdev->dev, buf,
+						     GFP_KERNEL);
+
+		strlcat(buf, "-", len);
+		strlcat(buf, devinfo->settings->antenna_sku, len);
+		/* apple,shikoku-RASP-m-6.11-X3 */
+		fwreq->board_types[0] = buf;
+	} else {
+		brcmf_dbg(PCIE, "Board: %s\n", devinfo->settings->board_type);
+		fwreq->board_types = devm_kzalloc(&devinfo->pdev->dev,
+						  sizeof(const char *) * 2,
+						  GFP_KERNEL);
+		fwreq->board_types[0] = devinfo->settings->board_type;
+	}
 
 	return fwreq;
 }
-- 
2.33.0


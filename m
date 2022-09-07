Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A73D25AFDFE
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 09:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbiIGHsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 03:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbiIGHsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 03:48:24 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF31F98599;
        Wed,  7 Sep 2022 00:48:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=bPX+uqeK6px1YmSY7Y/iCrKTcmfMkH7nw/MI8hhnjQ4=; b=uy9JitVJt9wc/OTIlQT+TaTBl0
        9BHt559mQJ2uWtm8S1qtIoXRQ5oaT6a+yQsqoaLsYb4+AK7hfdVx/tlJPxZ3pEOoRLrsBlW5tXl/y
        22jG7maLnF2J4IrKlqja2BepZv9p/W8FaOpCdx2BwP9MFFQeCtkqLlTFI3H+E+pXZox54FnqyvbbP
        h6siaZbFED4gtfUNXJZfd/UaQPbPRw2d7mXPedGfOqpd5XxMz0hqtXRTgaCdDFHkkpT0uP3Rn/h0+
        vqNBYAW6AT0bcbw6AvKaXzEtmW58IsPqq1mCV7kTz6olTdhR/pYpcQVn2eIryfRsQrZ1db16LDphB
        kZyXlTHg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:46842 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1oVpnF-0004wD-QN; Wed, 07 Sep 2022 08:48:17 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1oVpnF-005LBw-3I; Wed, 07 Sep 2022 08:48:17 +0100
In-Reply-To: <YxhMaYOfnM+7FG+W@shell.armlinux.org.uk>
References: <YxhMaYOfnM+7FG+W@shell.armlinux.org.uk>
From:   Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
Cc:     Alyssa Rosenzweig <alyssa@rosenzweig.io>, asahi@lists.linux.dev,
        brcm80211-dev-list.pdl@broadcom.com,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Hector Martin <marcan@marcan.st>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        "Rafa__ Mi__ecki" <zajec5@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        SHA-cyfmac-dev-list@infineon.com, Sven Peter <sven@svenpeter.dev>
Subject: [PATCH net-next 07/12] brcmfmac: pcie: Perform firmware selection for
 Apple platforms
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1oVpnF-005LBw-3I@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 07 Sep 2022 08:48:17 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hector Martin <marcan@marcan.st>

On Apple platforms, firmware selection uses the following elements:

  Property         Example   Source
  ==============   =======   ========================
* Chip name        4378      Device ID
* Chip revision    B1        OTP
* Platform         shikoku   DT (ARM64) or ACPI (x86)
* Module type      RASP      OTP
* Module vendor    m         OTP
* Module version   6.11      OTP
* Antenna SKU      X3        DT (ARM64) or ACPI (x86)

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
some formatting issues.

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

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 .../broadcom/brcm80211/brcmfmac/pcie.c        | 41 ++++++++++++++++++-
 1 file changed, 39 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 17d0353e9105..86807d990cc7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -2068,8 +2068,45 @@ brcmf_pcie_prepare_fw_request(struct brcmf_pciedev_info *devinfo)
 	fwreq->domain_nr = pci_domain_nr(devinfo->pdev->bus) + 1;
 	fwreq->bus_nr = devinfo->pdev->bus->number;
 
-	brcmf_dbg(PCIE, "Board: %s\n", devinfo->settings->board_type);
-	fwreq->board_types[0] = devinfo->settings->board_type;
+	/* Apple platforms with fancy firmware/NVRAM selection */
+	if (devinfo->settings->board_type &&
+	    devinfo->settings->antenna_sku &&
+	    devinfo->otp.valid) {
+		const struct brcmf_otp_params *otp = &devinfo->otp;
+		struct device *dev = &devinfo->pdev->dev;
+		const char **bt = fwreq->board_types;
+
+		brcmf_dbg(PCIE, "Apple board: %s\n",
+			  devinfo->settings->board_type);
+
+		/* Example: apple,shikoku-RASP-m-6.11-X3 */
+		bt[0] = devm_kasprintf(dev, GFP_KERNEL, "%s-%s-%s-%s-%s",
+				       devinfo->settings->board_type,
+				       otp->module, otp->vendor, otp->version,
+				       devinfo->settings->antenna_sku);
+		bt[1] = devm_kasprintf(dev, GFP_KERNEL, "%s-%s-%s-%s",
+				       devinfo->settings->board_type,
+				       otp->module, otp->vendor, otp->version);
+		bt[2] = devm_kasprintf(dev, GFP_KERNEL, "%s-%s-%s",
+				       devinfo->settings->board_type,
+				       otp->module, otp->vendor);
+		bt[3] = devm_kasprintf(dev, GFP_KERNEL, "%s-%s",
+				       devinfo->settings->board_type,
+				       otp->module);
+		bt[4] = devm_kasprintf(dev, GFP_KERNEL, "%s-%s",
+				       devinfo->settings->board_type,
+				       devinfo->settings->antenna_sku);
+		bt[5] = devinfo->settings->board_type;
+
+		if (!bt[0] || !bt[1] || !bt[2] || !bt[3] || !bt[4]) {
+			kfree(fwreq);
+			return NULL;
+		}
+
+	} else {
+		brcmf_dbg(PCIE, "Board: %s\n", devinfo->settings->board_type);
+		fwreq->board_types[0] = devinfo->settings->board_type;
+	}
 
 	return fwreq;
 }
-- 
2.30.2


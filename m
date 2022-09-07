Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 028A75AFDF4
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 09:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbiIGHs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 03:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbiIGHsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 03:48:10 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1060A74D8;
        Wed,  7 Sep 2022 00:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cvVJF0JXcP/ZWbKj49MftlcjBgXeXS9yy6BYozL9waM=; b=LoAMHKzBygaI0b1GctfL+0dR0/
        Kl4B+HoqbuykQ7jRrcwO3CH62xUUlK7CwHdtMBhry2+8dNbfgyFwl7KAnjnTRVjguC2iGHoINLGbt
        lXWPNeHkMrcc5SfpnE3MFaUA+4SdC2Chx4mE5jCd6Kuqmin+swDrRYDQYd/WmzLkBfvt2zMnxH6Cl
        aNU6fJTG2lVkisZzHnEnqPqAaQDe2V5QvaXnpOptzKj9TgZQeWEQO6FUHfyymwQ64hXEwEfitGWQI
        5ay7mEhuY/aEPoR3lE3njlvCGxuqAs3Pr2BL0Is+9jhg5HXqZNODcbmkEy1wTYrxywIWi9Qphghq4
        vmN635QA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:38218 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1oVpmv-0004uk-6g; Wed, 07 Sep 2022 08:47:57 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1oVpmu-005LBY-F3; Wed, 07 Sep 2022 08:47:56 +0100
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
Subject: [PATCH net-next 03/12] brcmfmac: pcie/sdio/usb: Get CLM blob via
 standard firmware mechanism
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1oVpmu-005LBY-F3@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 07 Sep 2022 08:47:56 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hector Martin <marcan@marcan.st>

Now that the firmware fetcher can handle per-board CLM files, load the
CLM blob alongside the other firmware files and change the bus API to
just return the existing blob, instead of fetching the filename.

This enables per-board CLM blobs, which are required on Apple platforms.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 .../broadcom/brcm80211/brcmfmac/bus.h         | 19 ++++++---
 .../broadcom/brcm80211/brcmfmac/common.c      | 12 +-----
 .../broadcom/brcm80211/brcmfmac/pcie.c        | 39 ++++++++++++-------
 .../broadcom/brcm80211/brcmfmac/sdio.c        | 36 ++++++++++-------
 .../broadcom/brcm80211/brcmfmac/sdio.h        |  2 +
 .../broadcom/brcm80211/brcmfmac/usb.c         | 23 +++--------
 6 files changed, 69 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
index ae5af76e2568..2208ab3aa795 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
@@ -6,6 +6,8 @@
 #ifndef BRCMFMAC_BUS_H
 #define BRCMFMAC_BUS_H
 
+#include <linux/kernel.h>
+#include <linux/firmware.h>
 #include "debug.h"
 
 /* IDs of the 6 default common rings of msgbuf protocol */
@@ -34,6 +36,11 @@ enum brcmf_bus_protocol_type {
 	BRCMF_PROTO_MSGBUF
 };
 
+/* Firmware blobs that may be available */
+enum brcmf_blob_type {
+	BRCMF_BLOB_CLM,
+};
+
 struct brcmf_mp_device;
 
 struct brcmf_bus_dcmd {
@@ -60,7 +67,7 @@ struct brcmf_bus_dcmd {
  * @wowl_config: specify if dongle is configured for wowl when going to suspend
  * @get_ramsize: obtain size of device memory.
  * @get_memdump: obtain device memory dump in provided buffer.
- * @get_fwname: obtain firmware name.
+ * @get_blob: obtain a firmware blob.
  *
  * This structure provides an abstract interface towards the
  * bus specific driver. For control messages to common driver
@@ -77,8 +84,8 @@ struct brcmf_bus_ops {
 	void (*wowl_config)(struct device *dev, bool enabled);
 	size_t (*get_ramsize)(struct device *dev);
 	int (*get_memdump)(struct device *dev, void *data, size_t len);
-	int (*get_fwname)(struct device *dev, const char *ext,
-			  unsigned char *fw_name);
+	int (*get_blob)(struct device *dev, const struct firmware **fw,
+			enum brcmf_blob_type type);
 	void (*debugfs_create)(struct device *dev);
 	int (*reset)(struct device *dev);
 };
@@ -220,10 +227,10 @@ int brcmf_bus_get_memdump(struct brcmf_bus *bus, void *data, size_t len)
 }
 
 static inline
-int brcmf_bus_get_fwname(struct brcmf_bus *bus, const char *ext,
-			 unsigned char *fw_name)
+int brcmf_bus_get_blob(struct brcmf_bus *bus, const struct firmware **fw,
+		       enum brcmf_blob_type type)
 {
-	return bus->ops->get_fwname(bus->dev, ext, fw_name);
+	return bus->ops->get_blob(bus->dev, fw, type);
 }
 
 static inline
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index 372deeb69477..74020fa10065 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -123,7 +123,6 @@ static int brcmf_c_process_clm_blob(struct brcmf_if *ifp)
 	struct brcmf_bus *bus = drvr->bus_if;
 	struct brcmf_dload_data_le *chunk_buf;
 	const struct firmware *clm = NULL;
-	u8 clm_name[BRCMF_FW_NAME_LEN];
 	u32 chunk_len;
 	u32 datalen;
 	u32 cumulative_len;
@@ -133,15 +132,8 @@ static int brcmf_c_process_clm_blob(struct brcmf_if *ifp)
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	memset(clm_name, 0, sizeof(clm_name));
-	err = brcmf_bus_get_fwname(bus, ".clm_blob", clm_name);
-	if (err) {
-		bphy_err(drvr, "get CLM blob file name failed (%d)\n", err);
-		return err;
-	}
-
-	err = firmware_request_nowarn(&clm, clm_name, bus->dev);
-	if (err) {
+	err = brcmf_bus_get_blob(bus, &clm, BRCMF_BLOB_CLM);
+	if (err || !clm) {
 		brcmf_info("no clm_blob available (err=%d), device may have limited channels available\n",
 			   err);
 		return 0;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 97f0f13dfe50..ec73d2620ec9 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -66,6 +66,7 @@ MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-pcie.*.txt");
 
 /* per-board firmware binaries */
 MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-pcie.*.bin");
+MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-pcie.*.clm_blob");
 
 static const struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
 	BRCMF_FW_ENTRY(BRCM_CC_43602_CHIP_ID, 0xFFFFFFFF, 43602),
@@ -261,6 +262,8 @@ struct brcmf_pciedev_info {
 	struct pci_dev *pdev;
 	char fw_name[BRCMF_FW_NAME_LEN];
 	char nvram_name[BRCMF_FW_NAME_LEN];
+	char clm_name[BRCMF_FW_NAME_LEN];
+	const struct firmware *clm_fw;
 	void __iomem *regs;
 	void __iomem *tcm;
 	u32 ram_base;
@@ -1382,23 +1385,25 @@ static int brcmf_pcie_get_memdump(struct device *dev, void *data, size_t len)
 	return 0;
 }
 
-static
-int brcmf_pcie_get_fwname(struct device *dev, const char *ext, u8 *fw_name)
+static int brcmf_pcie_get_blob(struct device *dev, const struct firmware **fw,
+			       enum brcmf_blob_type type)
 {
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
-	struct brcmf_fw_request *fwreq;
-	struct brcmf_fw_name fwnames[] = {
-		{ ext, fw_name },
-	};
+	struct brcmf_pciedev *buspub = bus_if->bus_priv.pcie;
+	struct brcmf_pciedev_info *devinfo = buspub->devinfo;
 
-	fwreq = brcmf_fw_alloc_request(bus_if->chip, bus_if->chiprev,
-				       brcmf_pcie_fwnames,
-				       ARRAY_SIZE(brcmf_pcie_fwnames),
-				       fwnames, ARRAY_SIZE(fwnames));
-	if (!fwreq)
-		return -ENOMEM;
+	switch (type) {
+	case BRCMF_BLOB_CLM:
+		*fw = devinfo->clm_fw;
+		devinfo->clm_fw = NULL;
+		break;
+	default:
+		return -ENOENT;
+	}
+
+	if (!*fw)
+		return -ENOENT;
 
-	kfree(fwreq);
 	return 0;
 }
 
@@ -1445,7 +1450,7 @@ static const struct brcmf_bus_ops brcmf_pcie_bus_ops = {
 	.wowl_config = brcmf_pcie_wowl_config,
 	.get_ramsize = brcmf_pcie_get_ramsize,
 	.get_memdump = brcmf_pcie_get_memdump,
-	.get_fwname = brcmf_pcie_get_fwname,
+	.get_blob = brcmf_pcie_get_blob,
 	.reset = brcmf_pcie_reset,
 };
 
@@ -1731,6 +1736,7 @@ static const struct brcmf_buscore_ops brcmf_pcie_buscore_ops = {
 
 #define BRCMF_PCIE_FW_CODE	0
 #define BRCMF_PCIE_FW_NVRAM	1
+#define BRCMF_PCIE_FW_CLM	2
 
 static void brcmf_pcie_setup(struct device *dev, int ret,
 			     struct brcmf_fw_request *fwreq)
@@ -1755,6 +1761,7 @@ static void brcmf_pcie_setup(struct device *dev, int ret,
 	fw = fwreq->items[BRCMF_PCIE_FW_CODE].binary;
 	nvram = fwreq->items[BRCMF_PCIE_FW_NVRAM].nv_data.data;
 	nvram_len = fwreq->items[BRCMF_PCIE_FW_NVRAM].nv_data.len;
+	devinfo->clm_fw = fwreq->items[BRCMF_PCIE_FW_CLM].binary;
 	kfree(fwreq);
 
 	ret = brcmf_chip_get_raminfo(devinfo->ci);
@@ -1830,6 +1837,7 @@ brcmf_pcie_prepare_fw_request(struct brcmf_pciedev_info *devinfo)
 	struct brcmf_fw_name fwnames[] = {
 		{ ".bin", devinfo->fw_name },
 		{ ".txt", devinfo->nvram_name },
+		{ ".clm_blob", devinfo->clm_name },
 	};
 
 	fwreq = brcmf_fw_alloc_request(devinfo->ci->chip, devinfo->ci->chiprev,
@@ -1842,6 +1850,8 @@ brcmf_pcie_prepare_fw_request(struct brcmf_pciedev_info *devinfo)
 	fwreq->items[BRCMF_PCIE_FW_CODE].type = BRCMF_FW_TYPE_BINARY;
 	fwreq->items[BRCMF_PCIE_FW_NVRAM].type = BRCMF_FW_TYPE_NVRAM;
 	fwreq->items[BRCMF_PCIE_FW_NVRAM].flags = BRCMF_FW_REQF_OPTIONAL;
+	fwreq->items[BRCMF_PCIE_FW_CLM].type = BRCMF_FW_TYPE_BINARY;
+	fwreq->items[BRCMF_PCIE_FW_CLM].flags = BRCMF_FW_REQF_OPTIONAL;
 	fwreq->board_type = devinfo->settings->board_type;
 	/* NVRAM reserves PCI domain 0 for Broadcom's SDK faked bus */
 	fwreq->domain_nr = pci_domain_nr(devinfo->pdev->bus) + 1;
@@ -1981,6 +1991,7 @@ brcmf_pcie_remove(struct pci_dev *pdev)
 	brcmf_pcie_release_ringbuffers(devinfo);
 	brcmf_pcie_reset_device(devinfo);
 	brcmf_pcie_release_resource(devinfo);
+	release_firmware(devinfo->clm_fw);
 
 	if (devinfo->ci)
 		brcmf_chip_detach(devinfo->ci);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 8968809399c7..73a74635a77d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4129,23 +4129,24 @@ brcmf_sdio_watchdog(struct timer_list *t)
 	}
 }
 
-static
-int brcmf_sdio_get_fwname(struct device *dev, const char *ext, u8 *fw_name)
+static int brcmf_sdio_get_blob(struct device *dev, const struct firmware **fw,
+			       enum brcmf_blob_type type)
 {
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
-	struct brcmf_fw_request *fwreq;
-	struct brcmf_fw_name fwnames[] = {
-		{ ext, fw_name },
-	};
+	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 
-	fwreq = brcmf_fw_alloc_request(bus_if->chip, bus_if->chiprev,
-				       brcmf_sdio_fwnames,
-				       ARRAY_SIZE(brcmf_sdio_fwnames),
-				       fwnames, ARRAY_SIZE(fwnames));
-	if (!fwreq)
-		return -ENOMEM;
+	switch (type) {
+	case BRCMF_BLOB_CLM:
+		*fw = sdiodev->clm_fw;
+		sdiodev->clm_fw = NULL;
+		break;
+	default:
+		return -ENOENT;
+	}
+
+	if (!*fw)
+		return -ENOENT;
 
-	kfree(fwreq);
 	return 0;
 }
 
@@ -4180,13 +4181,14 @@ static const struct brcmf_bus_ops brcmf_sdio_bus_ops = {
 	.wowl_config = brcmf_sdio_wowl_config,
 	.get_ramsize = brcmf_sdio_bus_get_ramsize,
 	.get_memdump = brcmf_sdio_bus_get_memdump,
-	.get_fwname = brcmf_sdio_get_fwname,
+	.get_blob = brcmf_sdio_get_blob,
 	.debugfs_create = brcmf_sdio_debugfs_create,
 	.reset = brcmf_sdio_bus_reset
 };
 
 #define BRCMF_SDIO_FW_CODE	0
 #define BRCMF_SDIO_FW_NVRAM	1
+#define BRCMF_SDIO_FW_CLM	2
 
 static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 					 struct brcmf_fw_request *fwreq)
@@ -4209,6 +4211,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 	code = fwreq->items[BRCMF_SDIO_FW_CODE].binary;
 	nvram = fwreq->items[BRCMF_SDIO_FW_NVRAM].nv_data.data;
 	nvram_len = fwreq->items[BRCMF_SDIO_FW_NVRAM].nv_data.len;
+	sdiod->clm_fw = fwreq->items[BRCMF_SDIO_FW_CLM].binary;
 	kfree(fwreq);
 
 	/* try to download image and nvram to the dongle */
@@ -4407,6 +4410,7 @@ brcmf_sdio_prepare_fw_request(struct brcmf_sdio *bus)
 	struct brcmf_fw_name fwnames[] = {
 		{ ".bin", bus->sdiodev->fw_name },
 		{ ".txt", bus->sdiodev->nvram_name },
+		{ ".clm_blob", bus->sdiodev->clm_name },
 	};
 
 	fwreq = brcmf_fw_alloc_request(bus->ci->chip, bus->ci->chiprev,
@@ -4418,6 +4422,8 @@ brcmf_sdio_prepare_fw_request(struct brcmf_sdio *bus)
 
 	fwreq->items[BRCMF_SDIO_FW_CODE].type = BRCMF_FW_TYPE_BINARY;
 	fwreq->items[BRCMF_SDIO_FW_NVRAM].type = BRCMF_FW_TYPE_NVRAM;
+	fwreq->items[BRCMF_SDIO_FW_CLM].type = BRCMF_FW_TYPE_BINARY;
+	fwreq->items[BRCMF_SDIO_FW_CLM].flags = BRCMF_FW_REQF_OPTIONAL;
 	fwreq->board_type = bus->sdiodev->settings->board_type;
 
 	return fwreq;
@@ -4574,6 +4580,8 @@ void brcmf_sdio_remove(struct brcmf_sdio *bus)
 		if (bus->sdiodev->settings)
 			brcmf_release_module_param(bus->sdiodev->settings);
 
+		release_firmware(bus->sdiodev->clm_fw);
+		bus->sdiodev->clm_fw = NULL;
 		kfree(bus->rxbuf);
 		kfree(bus->hdrbuf);
 		kfree(bus);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
index 47351ff458ca..b76d34d36bde 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
@@ -186,9 +186,11 @@ struct brcmf_sdio_dev {
 	struct sg_table sgtable;
 	char fw_name[BRCMF_FW_NAME_LEN];
 	char nvram_name[BRCMF_FW_NAME_LEN];
+	char clm_name[BRCMF_FW_NAME_LEN];
 	bool wowl_enabled;
 	enum brcmf_sdiod_state state;
 	struct brcmf_sdiod_freezer *freezer;
+	const struct firmware *clm_fw;
 };
 
 /* sdio core registers */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index 9fb68c2dc7e3..85e18fb9c497 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -1154,24 +1154,11 @@ struct brcmf_usbdev *brcmf_usb_attach(struct brcmf_usbdev_info *devinfo,
 	return NULL;
 }
 
-static
-int brcmf_usb_get_fwname(struct device *dev, const char *ext, u8 *fw_name)
+static int brcmf_usb_get_blob(struct device *dev, const struct firmware **fw,
+			      enum brcmf_blob_type type)
 {
-	struct brcmf_bus *bus = dev_get_drvdata(dev);
-	struct brcmf_fw_request *fwreq;
-	struct brcmf_fw_name fwnames[] = {
-		{ ext, fw_name },
-	};
-
-	fwreq = brcmf_fw_alloc_request(bus->chip, bus->chiprev,
-				       brcmf_usb_fwnames,
-				       ARRAY_SIZE(brcmf_usb_fwnames),
-				       fwnames, ARRAY_SIZE(fwnames));
-	if (!fwreq)
-		return -ENOMEM;
-
-	kfree(fwreq);
-	return 0;
+	/* No blobs for USB devices... */
+	return -ENOENT;
 }
 
 static const struct brcmf_bus_ops brcmf_usb_bus_ops = {
@@ -1180,7 +1167,7 @@ static const struct brcmf_bus_ops brcmf_usb_bus_ops = {
 	.txdata = brcmf_usb_tx,
 	.txctl = brcmf_usb_tx_ctlpkt,
 	.rxctl = brcmf_usb_rx_ctlpkt,
-	.get_fwname = brcmf_usb_get_fwname,
+	.get_blob = brcmf_usb_get_blob,
 };
 
 #define BRCMF_USB_FW_CODE	0
-- 
2.30.2


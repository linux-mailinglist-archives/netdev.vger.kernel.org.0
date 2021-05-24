Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD36F38EB63
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 17:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234439AbhEXPCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 11:02:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234513AbhEXPAA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 11:00:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F273761445;
        Mon, 24 May 2021 14:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621867791;
        bh=dutP2hyGs4F8Z4v+JyMkt+banxkxYy0tH1KYmtDZQTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aj7NgbMIIYHZS+rOaaXgHktE1VVn33zW/Bf4TiRdecTRb35+xCIlDFtBbJ6Adr1Bp
         yE7L+bGG5wROaNZpW2MQYE0c4GVpaHfzU/5p1UoCCjv2kqPGroBd92U9dkeed35NcA
         ZdcvsY/wRjpK9XneQMQOrlvaAQrWF9DgkCh6EEct7eMgi2JEBunUaCRLIC0Ip3EH/H
         oPO94rt1Q6i+fQ2g5DlAT5caWdZYS1xBmRhmShZGdSTzxOFgjbh5C/aI/Lrj718N15
         agAvfBCfiaaVehI2Pc/PcDMuvXR6e42JUVnsEBSdFp24J6ZbLNXf5DDn61HJbPZzQE
         mYGREl92geHQw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 39/52] brcmfmac: properly check for bus register errors
Date:   Mon, 24 May 2021 10:48:49 -0400
Message-Id: <20210524144903.2498518-39-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210524144903.2498518-1-sashal@kernel.org>
References: <20210524144903.2498518-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 419b4a142a7ece36cebcd434f8ce2af59ef94b85 ]

The brcmfmac driver ignores any errors on initialization with the
different busses by deferring the initialization to a workqueue and
ignoring all possible errors that might happen.  Fix up all of this by
only allowing the module to load if all bus registering worked properly.

Cc: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210503115736.2104747-70-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../broadcom/brcm80211/brcmfmac/bcmsdh.c      |  8 +---
 .../broadcom/brcm80211/brcmfmac/bus.h         | 19 ++++++++-
 .../broadcom/brcm80211/brcmfmac/core.c        | 42 ++++++++-----------
 .../broadcom/brcm80211/brcmfmac/pcie.c        |  9 +---
 .../broadcom/brcm80211/brcmfmac/pcie.h        |  5 ---
 .../broadcom/brcm80211/brcmfmac/usb.c         |  4 +-
 6 files changed, 41 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index fc12598b2dd3..c492d2d2db1d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -1168,13 +1168,9 @@ static struct sdio_driver brcmf_sdmmc_driver = {
 	},
 };
 
-void brcmf_sdio_register(void)
+int brcmf_sdio_register(void)
 {
-	int ret;
-
-	ret = sdio_register_driver(&brcmf_sdmmc_driver);
-	if (ret)
-		brcmf_err("sdio_register_driver failed: %d\n", ret);
+	return sdio_register_driver(&brcmf_sdmmc_driver);
 }
 
 void brcmf_sdio_exit(void)
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
index 623c0168da79..8b27494a5d3d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
@@ -274,11 +274,26 @@ void brcmf_bus_add_txhdrlen(struct device *dev, uint len);
 
 #ifdef CONFIG_BRCMFMAC_SDIO
 void brcmf_sdio_exit(void);
-void brcmf_sdio_register(void);
+int brcmf_sdio_register(void);
+#else
+static inline void brcmf_sdio_exit(void) { }
+static inline int brcmf_sdio_register(void) { return 0; }
 #endif
+
 #ifdef CONFIG_BRCMFMAC_USB
 void brcmf_usb_exit(void);
-void brcmf_usb_register(void);
+int brcmf_usb_register(void);
+#else
+static inline void brcmf_usb_exit(void) { }
+static inline int brcmf_usb_register(void) { return 0; }
+#endif
+
+#ifdef CONFIG_BRCMFMAC_PCIE
+void brcmf_pcie_exit(void);
+int brcmf_pcie_register(void);
+#else
+static inline void brcmf_pcie_exit(void) { }
+static inline int brcmf_pcie_register(void) { return 0; }
 #endif
 
 #endif /* BRCMFMAC_BUS_H */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index e9bb8dbdc9aa..edb79e9665dc 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -1438,40 +1438,34 @@ void brcmf_bus_change_state(struct brcmf_bus *bus, enum brcmf_bus_state state)
 	}
 }
 
-static void brcmf_driver_register(struct work_struct *work)
-{
-#ifdef CONFIG_BRCMFMAC_SDIO
-	brcmf_sdio_register();
-#endif
-#ifdef CONFIG_BRCMFMAC_USB
-	brcmf_usb_register();
-#endif
-#ifdef CONFIG_BRCMFMAC_PCIE
-	brcmf_pcie_register();
-#endif
-}
-static DECLARE_WORK(brcmf_driver_work, brcmf_driver_register);
-
 int __init brcmf_core_init(void)
 {
-	if (!schedule_work(&brcmf_driver_work))
-		return -EBUSY;
+	int err;
+
+	err = brcmf_sdio_register();
+	if (err)
+		return err;
+
+	err = brcmf_usb_register();
+	if (err)
+		goto error_usb_register;
 
+	err = brcmf_pcie_register();
+	if (err)
+		goto error_pcie_register;
 	return 0;
+
+error_pcie_register:
+	brcmf_usb_exit();
+error_usb_register:
+	brcmf_sdio_exit();
+	return err;
 }
 
 void __exit brcmf_core_exit(void)
 {
-	cancel_work_sync(&brcmf_driver_work);
-
-#ifdef CONFIG_BRCMFMAC_SDIO
 	brcmf_sdio_exit();
-#endif
-#ifdef CONFIG_BRCMFMAC_USB
 	brcmf_usb_exit();
-#endif
-#ifdef CONFIG_BRCMFMAC_PCIE
 	brcmf_pcie_exit();
-#endif
 }
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index cb68f54a9c56..bda042138e96 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -2137,15 +2137,10 @@ static struct pci_driver brcmf_pciedrvr = {
 };
 
 
-void brcmf_pcie_register(void)
+int brcmf_pcie_register(void)
 {
-	int err;
-
 	brcmf_dbg(PCIE, "Enter\n");
-	err = pci_register_driver(&brcmf_pciedrvr);
-	if (err)
-		brcmf_err(NULL, "PCIE driver registration failed, err=%d\n",
-			  err);
+	return pci_register_driver(&brcmf_pciedrvr);
 }
 
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.h
index d026401d2001..8e6c227e8315 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.h
@@ -11,9 +11,4 @@ struct brcmf_pciedev {
 	struct brcmf_pciedev_info *devinfo;
 };
 
-
-void brcmf_pcie_exit(void);
-void brcmf_pcie_register(void);
-
-
 #endif /* BRCMFMAC_PCIE_H */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index 6f41d28930e4..3b897f040371 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -1558,8 +1558,8 @@ void brcmf_usb_exit(void)
 	usb_deregister(&brcmf_usbdrvr);
 }
 
-void brcmf_usb_register(void)
+int brcmf_usb_register(void)
 {
 	brcmf_dbg(USB, "Enter\n");
-	usb_register(&brcmf_usbdrvr);
+	return usb_register(&brcmf_usbdrvr);
 }
-- 
2.30.2


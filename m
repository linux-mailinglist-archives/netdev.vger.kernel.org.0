Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8AFFBDF3D
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 15:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406835AbfIYNo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 09:44:58 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:58004 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406650AbfIYNo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 09:44:57 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: aratiu)
        with ESMTPSA id 8EFA628BCCF
From:   Adrian Ratiu <adrian.ratiu@collabora.com>
To:     brcm80211-dev-list.pdl@broadcom.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [PATCH 2/2] brcmfmac: fix suspend/resume when power is cut off
Date:   Wed, 25 Sep 2019 16:44:58 +0300
Message-Id: <20190925134458.1413790-2-adrian.ratiu@collabora.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190925134458.1413790-1-adrian.ratiu@collabora.com>
References: <20190925134458.1413790-1-adrian.ratiu@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

brcmfmac assumed the wifi device always remains powered on and thus
hardcoded the MMC_PM_KEEP_POWER flag expecting the wifi device to
remain on even during suspend/resume cycles.

This is not always the case, some appliances cut power to everything
connected via SDIO for efficiency reasons and this leads to wifi not
being usable after coming out of suspend because the device was not
correctly reinitialized.

So we check for the keep_power capability and if it's not present then
we remove the device and probe it again during resume to mirror what's
happening in hardware and ensure correct reinitialization in the case
when MMC_PM_KEEP_POWER is not supported.

Suggested-by: Gustavo Padovan <gustavo.padovan@collabora.com>
Signed-off-by: Adrian Ratiu <adrian.ratiu@collabora.com>
---
 .../broadcom/brcm80211/brcmfmac/bcmsdh.c      | 53 ++++++++++++++-----
 1 file changed, 39 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index fc12598b2dd3..96fd8e2bf773 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -1108,7 +1108,8 @@ static int brcmf_ops_sdio_suspend(struct device *dev)
 	struct sdio_func *func;
 	struct brcmf_bus *bus_if;
 	struct brcmf_sdio_dev *sdiodev;
-	mmc_pm_flag_t sdio_flags;
+	mmc_pm_flag_t pm_caps, sdio_flags;
+	int ret = 0;
 
 	func = container_of(dev, struct sdio_func, dev);
 	brcmf_dbg(SDIO, "Enter: F%d\n", func->num);
@@ -1119,19 +1120,33 @@ static int brcmf_ops_sdio_suspend(struct device *dev)
 	bus_if = dev_get_drvdata(dev);
 	sdiodev = bus_if->bus_priv.sdio;
 
-	brcmf_sdiod_freezer_on(sdiodev);
-	brcmf_sdio_wd_timer(sdiodev->bus, 0);
+	pm_caps = sdio_get_host_pm_caps(func);
+
+	if (pm_caps & MMC_PM_KEEP_POWER) {
+		/* preserve card power during suspend */
+		brcmf_sdiod_freezer_on(sdiodev);
+		brcmf_sdio_wd_timer(sdiodev->bus, 0);
+
+		sdio_flags = MMC_PM_KEEP_POWER;
+		if (sdiodev->wowl_enabled) {
+			if (sdiodev->settings->bus.sdio.oob_irq_supported)
+				enable_irq_wake(sdiodev->settings->bus.sdio.oob_irq_nr);
+			else
+				sdio_flags |= MMC_PM_WAKE_SDIO_IRQ;
+		}
+
+		if (sdio_set_host_pm_flags(sdiodev->func1, sdio_flags))
+			brcmf_err("Failed to set pm_flags %x\n", sdio_flags);
 
-	sdio_flags = MMC_PM_KEEP_POWER;
-	if (sdiodev->wowl_enabled) {
-		if (sdiodev->settings->bus.sdio.oob_irq_supported)
-			enable_irq_wake(sdiodev->settings->bus.sdio.oob_irq_nr);
-		else
-			sdio_flags |= MMC_PM_WAKE_SDIO_IRQ;
+	} else {
+		/* power will be cut so remove device, probe again in resume */
+		brcmf_sdiod_intr_unregister(sdiodev);
+		ret = brcmf_sdiod_remove(sdiodev);
+		if (ret)
+			brcmf_err("Failed to remove device on suspend\n");
 	}
-	if (sdio_set_host_pm_flags(sdiodev->func1, sdio_flags))
-		brcmf_err("Failed to set pm_flags %x\n", sdio_flags);
-	return 0;
+
+	return ret;
 }
 
 static int brcmf_ops_sdio_resume(struct device *dev)
@@ -1139,13 +1154,23 @@ static int brcmf_ops_sdio_resume(struct device *dev)
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 	struct sdio_func *func = container_of(dev, struct sdio_func, dev);
+	mmc_pm_flag_t pm_caps = sdio_get_host_pm_caps(func);
+	int ret = 0;
 
 	brcmf_dbg(SDIO, "Enter: F%d\n", func->num);
 	if (func->num != 2)
 		return 0;
 
-	brcmf_sdiod_freezer_off(sdiodev);
-	return 0;
+	if (!(pm_caps & MMC_PM_KEEP_POWER)) {
+		/* bus was powered off and device removed, probe again */
+		ret = brcmf_sdiod_probe(sdiodev);
+		if (ret)
+			brcmf_err("Failed to probe device on resume\n");
+	} else {
+		brcmf_sdiod_freezer_off(sdiodev);
+	}
+
+	return ret;
 }
 
 static const struct dev_pm_ops brcmf_sdio_pm_ops = {
-- 
2.23.0


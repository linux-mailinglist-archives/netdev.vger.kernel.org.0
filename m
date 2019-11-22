Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69CC810662B
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 07:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728404AbfKVG3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 01:29:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:54376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727322AbfKVFuB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 00:50:01 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B37E20718;
        Fri, 22 Nov 2019 05:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401800;
        bh=VnSpNutR+HYM6dXHXuOieaAsfuez/ZwHMECRQRp7HeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S6hdi8XJtw6a8vHR7hsb22TPejm6r3YqxucCGlcbxFgoWKHVmuPAkpoEDAxOZdgEH
         XRA6BMULnJSwY5LXZiPb2v6uWyN3uzVOP2B0tx+3Gx9DXzYs9bWfImvmaDHt6bEaGn
         J1aDOTbaRCjpgjc/xp72uah3ODPf/e5+gWR+iJak=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wright Feng <wright.feng@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 046/219] brcmfmac: set F2 watermark to 256 for 4373
Date:   Fri, 22 Nov 2019 00:46:18 -0500
Message-Id: <20191122054911.1750-39-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wright Feng <wright.feng@cypress.com>

[ Upstream commit e1a08730eeb0bad4d82c3bc40e74854872de618d ]

We got SDIO_CRC_ERROR with 4373 on SDR104 when doing bi-directional
throughput test. Enable watermark to 256 to guarantee the operation
stability.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Wright Feng <wright.feng@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../broadcom/brcm80211/brcmfmac/sdio.c        | 26 +++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 53e4962ceb8ae..e487dd78cc024 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -49,6 +49,10 @@
 #define DCMD_RESP_TIMEOUT	msecs_to_jiffies(2500)
 #define CTL_DONE_TIMEOUT	msecs_to_jiffies(2500)
 
+/* watermark expressed in number of words */
+#define DEFAULT_F2_WATERMARK    0x8
+#define CY_4373_F2_WATERMARK    0x40
+
 #ifdef DEBUG
 
 #define BRCMF_TRAP_INFO_SIZE	80
@@ -138,6 +142,8 @@ struct rte_console {
 /* 1: isolate internal sdio signals, put external pads in tri-state; requires
  * sdio bus power cycle to clear (rev 9) */
 #define SBSDIO_DEVCTL_PADS_ISO		0x08
+/* 1: enable F2 Watermark */
+#define SBSDIO_DEVCTL_F2WM_ENAB		0x10
 /* Force SD->SB reset mapping (rev 11) */
 #define SBSDIO_DEVCTL_SB_RST_CTL	0x30
 /*   Determined by CoreControl bit */
@@ -4060,6 +4066,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 	void *nvram;
 	u32 nvram_len;
 	u8 saveclk;
+	u8 devctl;
 
 	brcmf_dbg(TRACE, "Enter: dev=%s, err=%d\n", dev_name(dev), err);
 
@@ -4115,8 +4122,23 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 		brcmf_sdiod_writel(sdiod, core->base + SD_REG(hostintmask),
 				   bus->hostintmask, NULL);
 
-
-		brcmf_sdiod_writeb(sdiod, SBSDIO_WATERMARK, 8, &err);
+		switch (sdiod->func1->device) {
+		case SDIO_DEVICE_ID_CYPRESS_4373:
+			brcmf_dbg(INFO, "set F2 watermark to 0x%x*4 bytes\n",
+				  CY_4373_F2_WATERMARK);
+			brcmf_sdiod_writeb(sdiod, SBSDIO_WATERMARK,
+					   CY_4373_F2_WATERMARK, &err);
+			devctl = brcmf_sdiod_readb(sdiod, SBSDIO_DEVICE_CTL,
+						   &err);
+			devctl |= SBSDIO_DEVCTL_F2WM_ENAB;
+			brcmf_sdiod_writeb(sdiod, SBSDIO_DEVICE_CTL, devctl,
+					   &err);
+			break;
+		default:
+			brcmf_sdiod_writeb(sdiod, SBSDIO_WATERMARK,
+					   DEFAULT_F2_WATERMARK, &err);
+			break;
+		}
 	} else {
 		/* Disable F2 again */
 		sdio_disable_func(sdiod->func2);
-- 
2.20.1


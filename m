Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9A05106623
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 07:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbfKVFuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 00:50:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:54422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727455AbfKVFuC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 00:50:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A209D20717;
        Fri, 22 Nov 2019 05:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401801;
        bh=i2TUQ1gesl9JwdNVYVse27uEquLrDG/YSkiLYku2988=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FNn3khnMwLuX5gK0khhs6DSczHp+RZhAYTLRgWKDyNbpqM6bfUOmi4lOJmWpxYp5M
         akMaTHOtr3CjekeYZr+X4JiMRqS0DSc1v50uCjD8pWxgnQHpU5FXATJCIyqup88m2Z
         gLbFhrBbF8nNgqk6vFFYSQorFgUkjKtA+ogA9IM8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Madhan Mohan R <MadhanMohan.R@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Madhan Mohan R <madhanmohan.r@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 047/219] brcmfmac: set SDIO F1 MesBusyCtrl for CYW4373
Date:   Fri, 22 Nov 2019 00:46:19 -0500
Message-Id: <20191122054911.1750-40-sashal@kernel.org>
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

From: Madhan Mohan R <MadhanMohan.R@cypress.com>

[ Upstream commit 58e4bbea0c1d9b5ace11df968c5dc096ce052a73 ]

Along with F2 watermark (existing) configuration, F1 MesBusyCtrl
should be enabled & sdio device RX FIFO watermark should be
configured to avoid overflow errors.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Madhan Mohan R <madhanmohan.r@cypress.com>
Signed-off-by: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 3 +++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h | 9 ++++++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index e487dd78cc024..abaed2fa2defd 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4133,6 +4133,9 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 			devctl |= SBSDIO_DEVCTL_F2WM_ENAB;
 			brcmf_sdiod_writeb(sdiod, SBSDIO_DEVICE_CTL, devctl,
 					   &err);
+			brcmf_sdiod_writeb(sdiod, SBSDIO_FUNC1_MESBUSYCTRL,
+					   CY_4373_F2_WATERMARK |
+					   SBSDIO_MESBUSYCTRL_ENAB, &err);
 			break;
 		default:
 			brcmf_sdiod_writeb(sdiod, SBSDIO_WATERMARK,
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
index 7faed831f07d5..34b031154da93 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
@@ -77,7 +77,7 @@
 #define SBSDIO_GPIO_OUT			0x10006
 /* gpio enable */
 #define SBSDIO_GPIO_EN			0x10007
-/* rev < 7, watermark for sdio device */
+/* rev < 7, watermark for sdio device TX path */
 #define SBSDIO_WATERMARK		0x10008
 /* control busy signal generation */
 #define SBSDIO_DEVICE_CTL		0x10009
@@ -104,6 +104,13 @@
 #define SBSDIO_FUNC1_RFRAMEBCHI		0x1001C
 /* MesBusyCtl (rev 11) */
 #define SBSDIO_FUNC1_MESBUSYCTRL	0x1001D
+/* Watermark for sdio device RX path */
+#define SBSDIO_MESBUSY_RXFIFO_WM_MASK	0x7F
+#define SBSDIO_MESBUSY_RXFIFO_WM_SHIFT	0
+/* Enable busy capability for MES access */
+#define SBSDIO_MESBUSYCTRL_ENAB		0x80
+#define SBSDIO_MESBUSYCTRL_ENAB_SHIFT	7
+
 /* Sdio Core Rev 12 */
 #define SBSDIO_FUNC1_WAKEUPCTRL		0x1001E
 #define SBSDIO_FUNC1_WCTRL_ALPWAIT_MASK		0x1
-- 
2.20.1


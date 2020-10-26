Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E70A9299FF1
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 01:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442455AbgJ0A0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 20:26:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409947AbgJZXxE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 19:53:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56C3B21655;
        Mon, 26 Oct 2020 23:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756383;
        bh=BmqIYeNVJGSaXqSpMDnF4k9Qr8Mglw/qDSNx+xCnxdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ynp+GhTuDN1yU7bUHXT4MqxRJdN/9HWQ3q5pkKGu8HntjOcZeOlqbqweOMM/PP671
         rvK0bqaeQaePtCjJ+HaJAbpgexlON3+BCo/N4yLBKmM7GnP7kOjyEJDMe+RXAS+Q0S
         rKvMTMCMft7AuDeS1VzIwTqBxFCwNWBo68e5IZ+0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 047/132] brcmfmac: increase F2 watermark for BCM4329
Date:   Mon, 26 Oct 2020 19:50:39 -0400
Message-Id: <20201026235205.1023962-47-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235205.1023962-1-sashal@kernel.org>
References: <20201026235205.1023962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit 317da69d10b0247c4042354eb90c75b81620ce9d ]

This patch fixes SDHCI CRC errors during of RX throughput testing on
BCM4329 chip if SDIO BUS is clocked above 25MHz. In particular the
checksum problem is observed on NVIDIA Tegra20 SoCs. The good watermark
value is borrowed from downstream BCMDHD driver and it's matching to the
value that is already used for the BCM4339 chip, hence let's re-use it
for BCM4329.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200830191439.10017-2-digetx@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index bc02168ebb536..9ac9e6085a0c5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4227,6 +4227,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 			brcmf_sdiod_writeb(sdiod, SBSDIO_FUNC1_MESBUSYCTRL,
 					   CY_43012_MESBUSYCTRL, &err);
 			break;
+		case SDIO_DEVICE_ID_BROADCOM_4329:
 		case SDIO_DEVICE_ID_BROADCOM_4339:
 			brcmf_dbg(INFO, "set F2 watermark to 0x%x*4 bytes for 4339\n",
 				  CY_4339_F2_WATERMARK);
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC0F0FA637
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 03:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730102AbfKMC1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 21:27:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:37778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727513AbfKMBus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 20:50:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 459B8222D4;
        Wed, 13 Nov 2019 01:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609847;
        bh=urMkjndaCFT8P0B6YUlwM2kbeo3+BVId8Tiq7RtV6pc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WO11k3vp2fVr03jpwqpfwQhS5W20EGSk+f+3jombbSG6t24gXI+qrhO5QIGqt2rNq
         0oLcTeea88soWfB/4mPw0YRRmqmtZHg0nvp9/hGIADtYxpoFZnqQsTzyXCo3maWmUc
         /t8U+a7JcUS0O8X29ZX31nxVOCwR8i24s7RzlfaI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 019/209] mt76x2: disable WLAN core before probe
Date:   Tue, 12 Nov 2019 20:47:15 -0500
Message-Id: <20191113015025.9685-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 62e04f8a31fcc375c978b7f83b4229a10c3e746d ]

If the WLAN core is still active during initialization, it might cause
the MCU or DMA to hang. This can happen during soft reboot, so disable
the core + clock early to avoid this issue.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c | 4 ++++
 drivers/net/wireless/mediatek/mt76/mt76x2_pci.c         | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c
index 324b2a4b8b67c..54a9e1dfaf7a4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init_common.c
@@ -72,6 +72,9 @@ void mt76x2_reset_wlan(struct mt76x2_dev *dev, bool enable)
 {
 	u32 val;
 
+	if (!enable)
+		goto out;
+
 	val = mt76_rr(dev, MT_WLAN_FUN_CTRL);
 
 	val &= ~MT_WLAN_FUN_CTRL_FRC_WL_ANT_SEL;
@@ -87,6 +90,7 @@ void mt76x2_reset_wlan(struct mt76x2_dev *dev, bool enable)
 	mt76_wr(dev, MT_WLAN_FUN_CTRL, val);
 	udelay(20);
 
+out:
 	mt76x2_set_wlan_state(dev, enable);
 }
 EXPORT_SYMBOL_GPL(mt76x2_reset_wlan);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_pci.c b/drivers/net/wireless/mediatek/mt76/mt76x2_pci.c
index e66f047ea4481..26cfda24ce085 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_pci.c
@@ -53,6 +53,7 @@ mt76pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return -ENOMEM;
 
 	mt76_mmio_init(&dev->mt76, pcim_iomap_table(pdev)[0]);
+	mt76x2_reset_wlan(dev, false);
 
 	dev->mt76.rev = mt76_rr(dev, MT_ASIC_VERSION);
 	dev_info(dev->mt76.dev, "ASIC revision: %08x\n", dev->mt76.rev);
-- 
2.20.1


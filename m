Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF403741A2
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234590AbhEEQkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:40:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:38090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234858AbhEEQid (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:38:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E196061412;
        Wed,  5 May 2021 16:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232423;
        bh=WxiO4EXeA5EqQoSx5olH+tfFxfI2Xf4bWODHUl7UKeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HHcs2TG1XPUtV17b9vYGSigKgsjRSwdQ9OdmwzOrB1HcMkM5c3KrR9lRo7BDuErGV
         gOP0bGl7nkL07KfOLJxAKILIiM9SonDMHPquwVZnIX7muJtzoZ7g9lrVWw994OOk/I
         nMyxKfgRBFSyACZrIKzgPkoNJurILC3GDgC7Rb9JS+CxfKZTv0CjqOQzWVOgwxF4T6
         A6HCYZ16gsVUK8+h+8VRAovOb8CytRgvVmZVWV2Pb1qQq5DDQ+gp1i74Q8vUR2wSRu
         MnEOk0+cdqf+ngdSt4VPzmw6V9Qv+288eTUmj8LUgjVaxczXouDvvmfqdgqfh4xNJr
         mHavanr7uNeiA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 098/116] mt76: mt7615: fix entering driver-own state on mt7663
Date:   Wed,  5 May 2021 12:31:06 -0400
Message-Id: <20210505163125.3460440-98-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 5c7d374444afdeb9dd534a37c4f6c13af032da0c ]

Fixes hardware wakeup issues

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index 4ecbd5406e2a..198e9025b681 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -291,12 +291,20 @@ static int mt7615_mcu_drv_pmctrl(struct mt7615_dev *dev)
 	u32 addr;
 	int err;
 
-	addr = is_mt7663(mdev) ? MT_PCIE_DOORBELL_PUSH : MT_CFG_LPCR_HOST;
+	if (is_mt7663(mdev)) {
+		/* Clear firmware own via N9 eint */
+		mt76_wr(dev, MT_PCIE_DOORBELL_PUSH, MT_CFG_LPCR_HOST_DRV_OWN);
+		mt76_poll(dev, MT_CONN_ON_MISC, MT_CFG_LPCR_HOST_FW_OWN, 0, 3000);
+
+		addr = MT_CONN_HIF_ON_LPCTL;
+	} else {
+		addr = MT_CFG_LPCR_HOST;
+	}
+
 	mt76_wr(dev, addr, MT_CFG_LPCR_HOST_DRV_OWN);
 
 	mt7622_trigger_hif_int(dev, true);
 
-	addr = is_mt7663(mdev) ? MT_CONN_HIF_ON_LPCTL : MT_CFG_LPCR_HOST;
 	err = !mt76_poll_msec(dev, addr, MT_CFG_LPCR_HOST_FW_OWN, 0, 3000);
 
 	mt7622_trigger_hif_int(dev, false);
-- 
2.30.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 733A51F2F83
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731293AbgFIAvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:51:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728588AbgFHXKV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:10:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92B29214D8;
        Mon,  8 Jun 2020 23:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657821;
        bh=CvFeTCugHHRONHTP2eRlFRtgrbQbpBoVKDgXt7fTF8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vSKrxqq/jtcMevL97hTB6bCGq0S0X0UTz84n3hgMISpqJI9QK9T8dN6GEiCipIsMO
         dAgAaX0Rtd4vyT7R4BOJFxkH3RFpWqmdnOZJPnoyOjWne5oDZ1YjR09g/cw0NkkIVd
         krfl9aJZQryqEGd5JSCgSdcJfx6VE1jTP1v68uGI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 194/274] mt76: mt7615: fix mt7615_firmware_own for mt7663e
Date:   Mon,  8 Jun 2020 19:04:47 -0400
Message-Id: <20200608230607.3361041-194-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit becdf0d5d7a46f5ed1f12405ffae4b04764fe27c ]

Check the firmware-own configuration has been applied polling
MT_CONN_HIF_ON_LPCTL register

Fixes: f40ac0f3d3c0 ("mt76: mt7615: introduce mt7663e support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index a19fb0cb7794..0d56e0834bde 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -1550,9 +1550,8 @@ static int mt7615_firmware_own(struct mt7615_dev *dev)
 
 	mt76_wr(dev, addr, MT_CFG_LPCR_HOST_FW_OWN);
 
-	if (is_mt7622(&dev->mt76) &&
-	    !mt76_poll_msec(dev, MT_CFG_LPCR_HOST,
-			    MT_CFG_LPCR_HOST_FW_OWN,
+	if (!is_mt7615(&dev->mt76) &&
+	    !mt76_poll_msec(dev, addr, MT_CFG_LPCR_HOST_FW_OWN,
 			    MT_CFG_LPCR_HOST_FW_OWN, 3000)) {
 		dev_err(dev->mt76.dev, "Timeout for firmware own\n");
 		return -EIO;
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5B20291F28
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 21:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388348AbgJRT54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 15:57:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:57792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728117AbgJRTTO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 15:19:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BA4F222EB;
        Sun, 18 Oct 2020 19:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048754;
        bh=Il9Br0hKPkszm54/JVjOqIIyHlDSaKWZbOXM3vOFJvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HrC3Ta7h63uoW5XzmWTx3N8H3yStHqAznV4wgv5uYUyoGNcFe1y/BQ/pPbJ3lRXRx
         iejzdq4By1kPP4mUsVMFFZz+chZtC/O0cqw9/vHW+DGgxy41FbLL9Rkaa6hdcBA5rX
         7VLN7rdnz3cthD1RhCrC10eV2NDfxpuCk2JC1lz8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.9 055/111] mt76: mt7915: do not do any work in napi poll after calling napi_complete_done()
Date:   Sun, 18 Oct 2020 15:17:11 -0400
Message-Id: <20201018191807.4052726-55-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018191807.4052726-1-sashal@kernel.org>
References: <20201018191807.4052726-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 38b04398c532e9bb9aa90fc07846ad0b0845fe94 ]

Fixes a race condition where multiple tx cleanup or sta poll tasks could run
in parallel.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/dma.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/dma.c b/drivers/net/wireless/mediatek/mt76/mt7915/dma.c
index a8832c5e60041..8a1ae08d9572e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/dma.c
@@ -95,16 +95,13 @@ static int mt7915_poll_tx(struct napi_struct *napi, int budget)
 	dev = container_of(napi, struct mt7915_dev, mt76.tx_napi);
 
 	mt7915_tx_cleanup(dev);
-
-	if (napi_complete_done(napi, 0))
-		mt7915_irq_enable(dev, MT_INT_TX_DONE_ALL);
-
-	mt7915_tx_cleanup(dev);
-
 	mt7915_mac_sta_poll(dev);
 
 	tasklet_schedule(&dev->mt76.tx_tasklet);
 
+	if (napi_complete_done(napi, 0))
+		mt7915_irq_enable(dev, MT_INT_TX_DONE_ALL);
+
 	return 0;
 }
 
-- 
2.25.1


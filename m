Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21B80491795
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347616AbiARCmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:42:19 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55572 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344971AbiARCiJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:38:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5665F61118;
        Tue, 18 Jan 2022 02:38:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A2CC36B04;
        Tue, 18 Jan 2022 02:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473488;
        bh=G+He0CBs0oY7cJsck3Uiaa6jdKC0I2296gCo9uHeeZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lnfwM9/wYh48ivkbzQeDlcm1673TKh6O/t1G/QBj+e2+ftUxJSjIZHmUlhCJ76plR
         CGBzqjFgVFEylAENUhY8+PdvEuvWKF1eh+znFxlwL/xmITn4y3YpYFFjZ8Vm8+re3k
         AprYQCtP3EaWVck9TJBzVzYQgiARHw55XYH8ln8pYAQXfFBh9hEc4PyY8q144GXArD
         4wyp3paajypsSyZnE/0c+j7T9YCAtm1QGMYym7Yudy7T/gzP9C4PVD+BZIlJpX1Orv
         WigCqFJN08S3xYOjgixyeOYlqj8SWFIIvQpAmYmzCgwwYFL2LvSvZt3q/hD7rhmjld
         TVOUTiillZOKw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthias.bgg@gmail.com, sean.wang@mediatek.com,
        shayne.chen@mediatek.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 132/188] mt76: mt7615: improve wmm index allocation
Date:   Mon, 17 Jan 2022 21:30:56 -0500
Message-Id: <20220118023152.1948105-132-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 70fb028707c8871ef9e56b3ffa3d895e14956cc4 ]

Typically all AP interfaces on a PHY will share the same WMM settings, while
sta/mesh interfaces will usually inherit the settings from a remote device.
In order minimize the likelihood of conflicting WMM settings, make all AP
interfaces share one slot, and all non-AP interfaces another one.

This also fixes running multiple AP interfaces on MT7613, which only has 3
WMM slots.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/main.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/main.c b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
index 51260a669d166..fc266da54fe7b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
@@ -211,11 +211,9 @@ static int mt7615_add_interface(struct ieee80211_hw *hw,
 	mvif->mt76.omac_idx = idx;
 
 	mvif->mt76.band_idx = ext_phy;
-	if (mt7615_ext_phy(dev))
-		mvif->mt76.wmm_idx = ext_phy * (MT7615_MAX_WMM_SETS / 2) +
-				mvif->mt76.idx % (MT7615_MAX_WMM_SETS / 2);
-	else
-		mvif->mt76.wmm_idx = mvif->mt76.idx % MT7615_MAX_WMM_SETS;
+	mvif->mt76.wmm_idx = vif->type != NL80211_IFTYPE_AP;
+	if (ext_phy)
+		mvif->mt76.wmm_idx += 2;
 
 	dev->mt76.vif_mask |= BIT(mvif->mt76.idx);
 	dev->omac_mask |= BIT_ULL(mvif->mt76.omac_idx);
-- 
2.34.1


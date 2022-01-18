Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22158491601
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346005AbiARCcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:32:25 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45060 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245485AbiARC1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:27:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E29C660AAF;
        Tue, 18 Jan 2022 02:27:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE99C36AE3;
        Tue, 18 Jan 2022 02:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472871;
        bh=d/Y/dKHv4FKlCXeMXYlteoOcfs+yj883sgrx/JUCzZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FjuBrf7qSJ+kvKvsrOOVAF4jg2NiUFsJDabYvTPRZkueFrp1rfxRBbWgxPUaqXprH
         SzPX0y216qgbP2QM7z6pa/jlR0lhUYSGds3xxQ0lXcQ44KDqVTmDI5xsEq4STt6h2G
         XPaZKFOVu5oFopnoFr4yncnRrRixgI2YOlxkWji/1blKDx5a/HOwcfB060UiDldqK3
         ShHBuaD2AP1cRKkw1U/tWDYVINmuoKh0WSbl7qTuu3D8P48oPHEK2tJdYH4P5i7qWP
         ja2XCD/q8y3tRJqD0u4YQZZbbUjkHX3FtakEQhKcd4hWJI+VViMb1b7Rzl5S5YrhyF
         BT9rSFJcTclgw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthias.bgg@gmail.com, sean.wang@mediatek.com,
        shayne.chen@mediatek.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.16 156/217] mt76: mt7615: improve wmm index allocation
Date:   Mon, 17 Jan 2022 21:18:39 -0500
Message-Id: <20220118021940.1942199-156-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
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
index 890d9b07e1563..b308d5ab5f9a6 100644
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


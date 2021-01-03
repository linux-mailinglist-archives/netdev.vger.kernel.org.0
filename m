Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C00322E8C6F
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 15:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbhACN65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 08:58:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:35316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbhACN64 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Jan 2021 08:58:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7521B20782;
        Sun,  3 Jan 2021 13:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609682296;
        bh=GJ3TiDbcI7Vu/JRfRThabclQjLmoFf/NfkaYgzUh29A=;
        h=From:To:Cc:Subject:Date:From;
        b=XILYV6zSwLXgZzW2kxk7c5CgaTvvA9NqMcRtliWJ8emVmxcIHNTio8+2Cwqlmsr0x
         HGjeo8uMQYAHzy4Kf7I2GDRgwztbb1EudBf+qCLlEKR2GQwzSNzwENeB6BSefyLszR
         ImwG+2Y8EktwUuOUlc3p0C/6DUf5+M3BK9mD1b77oNviaUrBMqwXGOSrWzjIspIgU6
         WYt79zuHJYKbzRJM7lvomLbg2L5gdejeC6J/w4TFboMNTJl+AFefMdC0Tt7ScuQtHV
         +wVxC9DcPHtEMVgwabrHeucIO/4TwD3I7XQvYyA7x5DjLGLB3y/DCkMLEUYdjj6QVA
         VdT2/fRnJbYyw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Ryder Lee <ryder.lee@mediatek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Yiwei Chung <yiwei.chung@mediatek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mt76: mt7915: fix misplaced #ifdef
Date:   Sun,  3 Jan 2021 14:57:55 +0100
Message-Id: <20210103135811.3749775-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The lone '|' at the end of a line causes a build failure:

drivers/net/wireless/mediatek/mt76/mt7915/init.c:47:2: error: expected expression before '}' token

Replace the #ifdef with an equivalent IS_ENABLED() check.

Fixes: af901eb4ab80 ("mt76: mt7915: get rid of dbdc debugfs knob")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/mediatek/mt76/mt7915/init.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index ed4635bd151a..f1fb3ae0f7f2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -40,10 +40,9 @@ static const struct ieee80211_iface_limit if_limits[] = {
 		.types = BIT(NL80211_IFTYPE_ADHOC)
 	}, {
 		.max = 16,
-		.types = BIT(NL80211_IFTYPE_AP) |
-#ifdef CONFIG_MAC80211_MESH
-			 BIT(NL80211_IFTYPE_MESH_POINT)
-#endif
+		.types = BIT(NL80211_IFTYPE_AP)
+			 | IS_ENABLED(CONFIG_MAC80211_MESH) ?
+			   BIT(NL80211_IFTYPE_MESH_POINT) : 0
 	}, {
 		.max = MT7915_MAX_INTERFACES,
 		.types = BIT(NL80211_IFTYPE_STATION)
-- 
2.29.2


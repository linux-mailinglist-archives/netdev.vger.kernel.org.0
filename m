Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B52483251E8
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 16:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbhBYPBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 10:01:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:36056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232296AbhBYPBH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 10:01:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7024464F17;
        Thu, 25 Feb 2021 15:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614265226;
        bh=a/04c2nTy0GlyhPSNi1+WMgFD2zAC0g91qf3en1lMLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LEDUqRTCMenTu9MnNcW1qob6RYDrqs1gz1VtBztoWFVDSpAvVZf6RE6B5qU+6cBjk
         E5A8uOpoJvPVDZhA1IAMy2tUVFJQtfqQLp7LRPNIHbxOk2cRaS61LpZHyWdumt/P+B
         rWlN1QvnRZkoVsDDP2HjPlbTl5qVm/kU7hb78IywItFArL2p00/n9Sq/7UrkyzGcvH
         cPbVmKao7NukQmUDujfQcneYHhKc/QWLt10ZMrk8ZHFLEiJo4Gu82nZvidg4q+bdAq
         ar7EvPI7N8wpkhMcwlUkhr/KdtGe5YaxLdm0qhoq9xB83cMehBHqpRd194JPxe+zQq
         S6qMO9MKOCzzQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Ryder Lee <ryder.lee@mediatek.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Soul Huang <Soul.Huang@mediatek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH 2/2] mt76: mt7921: remove incorrect error handling
Date:   Thu, 25 Feb 2021 15:59:15 +0100
Message-Id: <20210225145953.404859-2-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210225145953.404859-1-arnd@kernel.org>
References: <20210225145953.404859-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Clang points out a mistake in the error handling in
mt7921_mcu_tx_rate_report(), which tries to dereference a pointer that
cannot be initialized because of the error that is being handled:

drivers/net/wireless/mediatek/mt76/mt7921/mcu.c:409:3: warning: variable 'stats' is uninitialized when used here [-Wuninitialized]
                stats->tx_rate = rate;
                ^~~~~
drivers/net/wireless/mediatek/mt76/mt7921/mcu.c:401:32: note: initialize the variable 'stats' to silence this warning
        struct mt7921_sta_stats *stats;
                                      ^
Just remove the obviously incorrect line.

Fixes: 1c099ab44727 ("mt76: mt7921: add MCU support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index db125cd22b91..b5cc72e7e81c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -405,10 +405,8 @@ mt7921_mcu_tx_rate_report(struct mt7921_dev *dev, struct sk_buff *skb,
 	if (wlan_idx >= MT76_N_WCIDS)
 		return;
 	wcid = rcu_dereference(dev->mt76.wcid[wlan_idx]);
-	if (!wcid) {
-		stats->tx_rate = rate;
+	if (!wcid)
 		return;
-	}
 
 	msta = container_of(wcid, struct mt7921_sta, wcid);
 	stats = &msta->stats;
-- 
2.29.2


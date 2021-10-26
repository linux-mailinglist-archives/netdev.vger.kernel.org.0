Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9693443AE23
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 10:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233475AbhJZIf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 04:35:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:55956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233224AbhJZIfz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 04:35:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9F4760F46;
        Tue, 26 Oct 2021 08:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635237212;
        bh=QzdqZpiGX5vzH78kafZN2BbBbWTTTjlj04OaCvEnSO4=;
        h=From:To:Cc:Subject:Date:From;
        b=R9M5fmXvJV81R3cbYtLS61achVk1fflWq5UM7WAJsoXmeXYqovJFGY+hKKhi/NjOz
         okDNBwMnoJS8nGkqv94Mw3cmjfKeFa+rutVIvemZyguKtUnvFKhX5N4c22c3zetN6k
         TVcRYDGeV5+6e6VHypheEiXP5KuPkfcNfFDZ8gSOqziQwpBjzAS7ajqhEFOad9ie3L
         Wtiju9TeSmJBSh6hIhQuaQuKp6WAxoEZ3qYayR4QE1Lx5zhZK53W/dZzP1IdM+C4cG
         +9amLZemg9pze/PISe5rYSitGz9U2Txa1tGRy6fCHtAgLtjGB73npXsL4mYw1zXr+m
         w9fNQ05xDxofA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        YN Chen <YN.Chen@mediatek.com>,
        Deren Wu <deren.wu@mediatek.com>,
        Leon Yen <Leon.Yen@mediatek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mt76: mt7663s: fix link error with CONFIG_PM=n
Date:   Tue, 26 Oct 2021 10:33:09 +0200
Message-Id: <20211026083326.3421663-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The generic register access functions are compiled conditionally,
causing a link failure in some randconfig builds:

ERROR: modpost: "mt76_connac_mcu_reg_wr" [drivers/net/wireless/mediatek/mt76/mt7615/mt7663s.ko] undefined!
ERROR: modpost: "mt76_connac_mcu_reg_rr" [drivers/net/wireless/mediatek/mt76/mt7615/mt7663s.ko] undefined!

Move them out of the #ifdef block.

Fixes: 02fbf8199f6e ("mt76: mt7663s: rely on mcu reg access utility")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index 32e25180fc1e..26b4b875dcc0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -2477,6 +2477,7 @@ void mt76_connac_mcu_set_suspend_iter(void *priv, u8 *mac,
 	mt76_connac_mcu_set_wow_ctrl(phy, vif, suspend, wowlan);
 }
 EXPORT_SYMBOL_GPL(mt76_connac_mcu_set_suspend_iter);
+#endif /* CONFIG_PM */
 
 u32 mt76_connac_mcu_reg_rr(struct mt76_dev *dev, u32 offset)
 {
@@ -2505,7 +2506,6 @@ void mt76_connac_mcu_reg_wr(struct mt76_dev *dev, u32 offset, u32 val)
 	mt76_mcu_send_msg(dev, MCU_CMD_REG_WRITE, &req, sizeof(req), false);
 }
 EXPORT_SYMBOL_GPL(mt76_connac_mcu_reg_wr);
-#endif /* CONFIG_PM */
 
 MODULE_AUTHOR("Lorenzo Bianconi <lorenzo@kernel.org>");
 MODULE_LICENSE("Dual BSD/GPL");
-- 
2.29.2


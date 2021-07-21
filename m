Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F213D11F3
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 17:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239493AbhGUO1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 10:27:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239021AbhGUO1O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 10:27:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0795A60FE9;
        Wed, 21 Jul 2021 15:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626880071;
        bh=CohVxwuDisL11y0VTlPi65KYI3TaQeWuxldXen3M5sg=;
        h=From:To:Cc:Subject:Date:From;
        b=uzxaFRjrHeoZnGWliZY4qiD5WImC1kwJEK+DEsojPYsYt4ghnLHJGO2g12/4Pfz8A
         t7DXoip/4x5NlJ0PVCcf4In0/m+fVcR5Xpf5ji7bAG65ZqeAbLoYjok/vXwDDsVLb5
         /cAvzD+otHDHdg7UoOlUrkRJvRyUANq6+KfWtmLwAAJ8uxO2WK9ZTeQvzWeo9Ji/lA
         NbpkNcjSKhyEftbOnMMDSRq2nviUHzNPfnIirSddM/vkYuRzlVmKoUPfLcD5hhdJYI
         4OLP55IHOTYFYzsHiAiOx42K/4bSYAT7ZRJ9LdZLEuVbcIP+o5CMPoPa1//9+L4Te5
         +Q7Ih4NOMUk2Q==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Ryder Lee <ryder.lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Soul Huang <Soul.Huang@mediatek.com>,
        Deren Wu <deren.wu@mediatek.com>,
        Xing Song <xing.song@mediatek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mt76: fix enum type mismatch
Date:   Wed, 21 Jul 2021 17:06:56 +0200
Message-Id: <20210721150745.1914829-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

There is no 'NONE' version of 'enum mcu_cipher_type', and returning
'MT_CIPHER_NONE' causes a warning:

drivers/net/wireless/mediatek/mt76/mt7921/mcu.c: In function 'mt7921_mcu_get_cipher':
drivers/net/wireless/mediatek/mt76/mt7921/mcu.c:114:24: error: implicit conversion from 'enum mt76_cipher_type' to 'enum mcu_cipher_type' [-Werror=enum-conversion]
  114 |                 return MT_CIPHER_NONE;
      |                        ^~~~~~~~~~~~~~

Add the missing MCU_CIPHER_NONE defintion that fits in here with
the same value.

Fixes: c368362c36d3 ("mt76: fix iv and CCMP header insertion")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
This problem currently exists in 5.14-rc2, please ignore my patch
if a fix is already queued up elsewhere.
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h | 3 ++-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.h | 3 ++-
 4 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 863aa18b3024..43960770a9af 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -111,7 +111,7 @@ mt7915_mcu_get_cipher(int cipher)
 	case WLAN_CIPHER_SUITE_SMS4:
 		return MCU_CIPHER_WAPI;
 	default:
-		return MT_CIPHER_NONE;
+		return MCU_CIPHER_NONE;
 	}
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.h
index edd3ba3a0c2d..e68a562cc5b4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.h
@@ -1073,7 +1073,8 @@ enum {
 };
 
 enum mcu_cipher_type {
-	MCU_CIPHER_WEP40 = 1,
+	MCU_CIPHER_NONE = 0,
+	MCU_CIPHER_WEP40,
 	MCU_CIPHER_WEP104,
 	MCU_CIPHER_WEP128,
 	MCU_CIPHER_TKIP,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index cd690c64f65b..9fbaacc67cfa 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -111,7 +111,7 @@ mt7921_mcu_get_cipher(int cipher)
 	case WLAN_CIPHER_SUITE_SMS4:
 		return MCU_CIPHER_WAPI;
 	default:
-		return MT_CIPHER_NONE;
+		return MCU_CIPHER_NONE;
 	}
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.h
index d76cf8f8dfdf..de3c091f6736 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.h
@@ -199,7 +199,8 @@ struct sta_rec_sec {
 } __packed;
 
 enum mcu_cipher_type {
-	MCU_CIPHER_WEP40 = 1,
+	MCU_CIPHER_NONE = 0,
+	MCU_CIPHER_WEP40,
 	MCU_CIPHER_WEP104,
 	MCU_CIPHER_WEP128,
 	MCU_CIPHER_TKIP,
-- 
2.29.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F103FAD9D
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 20:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235548AbhH2SGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 14:06:03 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:53932
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230010AbhH2SGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 14:06:00 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 51ABC3F101;
        Sun, 29 Aug 2021 18:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1630260306;
        bh=5xRSsNwOwnDTizm0g7YvHUz989lGjI0HmFERSykg4No=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=icGu6xT/3v5EVTU5eqCoiS/SUT+GBzzk8C4C9vrqV61fCfSUuUGGYZnyuqjGXIXAa
         4ZRGqPTwazDTaFZy1rGaSRECho8HDeHCu2RuyjgrzI69ai6oME51A+l2rgNUhseVHi
         rnNgiYgJ/zorLayPh/KZcnBida0W/Sld/xz8xm1qBXNpDYbIFj6em5lEyXmnUHYNY8
         ZurntEBcQjn9D/ipmZjUlJ1fV6RXqEzyYuFn+fF7rXoTqpENEun7YCB93e+lRCvs6l
         g//5nexOWoZXT5YYRQhHU5f5/84ExrlUqsf6J/BH+20dBbGToMErhg7RJKHTSfBsrB
         irryICpIp5aLQ==
From:   Colin King <colin.king@canonical.com>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] rtlwifi: rtl8192de: Fix uninitialized variable place
Date:   Sun, 29 Aug 2021 19:05:03 +0100
Message-Id: <20210829180503.533934-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

In the case where chnl <= 14 variable place is not initialized and
the function returns an uninitialized value. This fixes an earlier
cleanup where I introduced this bug. My bad.

Addresses-Coverity: ("Uninitialized scalar variable")
Fixes: 369956ae5720 ("rtlwifi: rtl8192de: Remove redundant variable initializations")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
index 8ae69d914312..b32fa7a75f17 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
@@ -896,7 +896,7 @@ static void _rtl92d_ccxpower_index_check(struct ieee80211_hw *hw,
 
 static u8 _rtl92c_phy_get_rightchnlplace(u8 chnl)
 {
-	u8 place;
+	u8 place = chnl;
 
 	if (chnl > 14) {
 		for (place = 14; place < sizeof(channel5g); place++) {
-- 
2.32.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD3B41B8E70
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 11:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgDZJmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 05:42:01 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:39862 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726162AbgDZJmB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Apr 2020 05:42:01 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 973BDE765C8766C2211B;
        Sun, 26 Apr 2020 17:41:59 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Sun, 26 Apr 2020
 17:41:49 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] rtlwifi: use true,false for bool variable in rtl_init_rfkill()
Date:   Sun, 26 Apr 2020 17:41:15 +0800
Message-ID: <20200426094115.23294-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'blocked' is a bool variable, and '==' expression itself is bool
too. So no need to convert it to 0/1.

This fixes the following coccicheck warning:

drivers/net/wireless/realtek/rtlwifi/base.c:508:13-41: WARNING:
Comparison of 0/1 to bool variable

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index c75192c4447f..a4489b9302d4 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -505,7 +505,7 @@ void rtl_init_rfkill(struct ieee80211_hw *hw)
 
 		rtlpriv->rfkill.rfkill_state = radio_state;
 
-		blocked = (rtlpriv->rfkill.rfkill_state == 1) ? 0 : 1;
+		blocked = rtlpriv->rfkill.rfkill_state != 1;
 		wiphy_rfkill_set_hw_state(hw->wiphy, blocked);
 	}
 
-- 
2.21.1


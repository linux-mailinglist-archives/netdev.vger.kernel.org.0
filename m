Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 529BD1DDE4B
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 05:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbgEVDsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 23:48:05 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:44102 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727836AbgEVDsF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 23:48:05 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 3F11374CB98CDB456CAC;
        Fri, 22 May 2020 11:48:01 +0800 (CST)
Received: from localhost (10.166.215.154) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Fri, 22 May 2020
 11:47:53 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <nbd@nbd.name>, <lorenzo.bianconi83@gmail.com>,
        <ryder.lee@mediatek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <matthias.bgg@gmail.com>,
        <shayne.chen@mediatek.com>, <chih-min.chen@mediatek.com>,
        <yf.luo@mediatek.com>, <yiwei.chung@mediatek.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] mt76: mt7915: Fix build error
Date:   Fri, 22 May 2020 11:45:33 +0800
Message-ID: <20200522034533.61716-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.166.215.154]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In file included from ./include/linux/firmware.h:6:0,
                 from drivers/net/wireless/mediatek/mt76/mt7915/mcu.c:4:
In function ‘__mt7915_mcu_msg_send’,
    inlined from ‘mt7915_mcu_send_message’ at drivers/net/wireless/mediatek/mt76/mt7915/mcu.c:370:6:
./include/linux/compiler.h:396:38: error: call to ‘__compiletime_assert_545’ declared with attribute error: BUILD_BUG_ON failed: cmd == MCU_EXT_CMD_EFUSE_ACCESS && mcu_txd->set_query != MCU_Q_QUERY
  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
                                      ^
./include/linux/compiler.h:377:4: note: in definition of macro ‘__compiletime_assert’
    prefix ## suffix();    \
    ^~~~~~
./include/linux/compiler.h:396:2: note: in expansion of macro ‘_compiletime_assert’
  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
  ^~~~~~~~~~~~~~~~~~~
./include/linux/build_bug.h:39:37: note: in expansion of macro ‘compiletime_assert’
 #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                     ^~~~~~~~~~~~~~~~~~
./include/linux/build_bug.h:50:2: note: in expansion of macro ‘BUILD_BUG_ON_MSG’
  BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
  ^~~~~~~~~~~~~~~~
drivers/net/wireless/mediatek/mt76/mt7915/mcu.c:280:2: note: in expansion of macro ‘BUILD_BUG_ON’
  BUILD_BUG_ON(cmd == MCU_EXT_CMD_EFUSE_ACCESS &&
  ^~~~~~~~~~~~

BUILD_BUG_ON is meaningless here, chang it to WARN_ON.

Fixes: e57b7901469f ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index f00ad2b66761..99eeea42478f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -277,8 +277,8 @@ static int __mt7915_mcu_msg_send(struct mt7915_dev *dev, struct sk_buff *skb,
 	}
 
 	mcu_txd->s2d_index = MCU_S2D_H2N;
-	BUILD_BUG_ON(cmd == MCU_EXT_CMD_EFUSE_ACCESS &&
-		     mcu_txd->set_query != MCU_Q_QUERY);
+	WARN_ON(cmd == MCU_EXT_CMD_EFUSE_ACCESS &&
+		mcu_txd->set_query != MCU_Q_QUERY);
 
 exit:
 	if (wait_seq)
-- 
2.17.1



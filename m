Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 418102B8BEE
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 08:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726274AbgKSHEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 02:04:13 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7701 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgKSHEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 02:04:13 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Cc9dJ4LcPzkbZl;
        Thu, 19 Nov 2020 15:03:48 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Thu, 19 Nov 2020 15:03:59 +0800
From:   Qinglang Miao <miaoqinglang@huawei.com>
To:     Solomon Peachy <pizza@shaftnet.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Qinglang Miao <miaoqinglang@huawei.com>
Subject: [PATCH] net: cw1200: fix missing destroy_workqueue() on error in cw1200_init_common
Date:   Thu, 19 Nov 2020 15:08:42 +0800
Message-ID: <20201119070842.1011-1-miaoqinglang@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the missing destroy_workqueue() before return from
cw1200_init_common in the error handling case.

Fixes:a910e4a94f69 ("cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
---
 drivers/net/wireless/st/cw1200/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/st/cw1200/main.c b/drivers/net/wireless/st/cw1200/main.c
index f7fe56aff..326b1cc1d 100644
--- a/drivers/net/wireless/st/cw1200/main.c
+++ b/drivers/net/wireless/st/cw1200/main.c
@@ -381,6 +381,7 @@ static struct ieee80211_hw *cw1200_init_common(const u8 *macaddr,
 				    CW1200_LINK_ID_MAX,
 				    cw1200_skb_dtor,
 				    priv)) {
+		destroy_workqueue(priv->workqueue);
 		ieee80211_free_hw(hw);
 		return NULL;
 	}
@@ -392,6 +393,7 @@ static struct ieee80211_hw *cw1200_init_common(const u8 *macaddr,
 			for (; i > 0; i--)
 				cw1200_queue_deinit(&priv->tx_queue[i - 1]);
 			cw1200_queue_stats_deinit(&priv->tx_queue_stats);
+			destroy_workqueue(priv->workqueue);
 			ieee80211_free_hw(hw);
 			return NULL;
 		}
-- 
2.23.0


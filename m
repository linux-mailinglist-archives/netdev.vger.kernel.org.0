Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1D36101120
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 03:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbfKSCKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 21:10:39 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:43920 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726761AbfKSCKi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 21:10:38 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 205AC7CEF21CBFBB844E;
        Tue, 19 Nov 2019 10:10:36 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Tue, 19 Nov 2019
 10:10:25 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <Jes.Sorensen@gmail.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH -next] rtl8xxxu: Remove set but not used variable 'vif','dev','len'
Date:   Tue, 19 Nov 2019 10:17:43 +0800
Message-ID: <1574129863-121223-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c: In function rtl8xxxu_c2hcmd_callback:
drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:5396:24: warning: variable vif set but not used [-Wunused-but-set-variable]
drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c: In function rtl8xxxu_c2hcmd_callback:
drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:5397:17: warning: variable dev set but not used [-Wunused-but-set-variable]
drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c: In function rtl8xxxu_c2hcmd_callback:
drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:5400:6: warning: variable len set but not used [-Wunused-but-set-variable]

It is introduced by commit e542e66b7c2e ("rtl8xxxu:
add bluetooth co-existence support for single antenna"), but never used,
so remove it.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 1d94cab..aa2bb2a 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5393,18 +5393,13 @@ static void rtl8xxxu_c2hcmd_callback(struct work_struct *work)
 {
 	struct rtl8xxxu_priv *priv;
 	struct rtl8723bu_c2h *c2h;
-	struct ieee80211_vif *vif;
-	struct device *dev;
 	struct sk_buff *skb = NULL;
 	unsigned long flags;
-	int len;
 	u8 bt_info = 0;
 	struct rtl8xxxu_btcoex *btcoex;

 	priv = container_of(work, struct rtl8xxxu_priv, c2hcmd_work);
-	vif = priv->vif;
 	btcoex = &priv->bt_coex;
-	dev = &priv->udev->dev;

 	if (priv->rf_paths > 1)
 		goto out;
@@ -5415,7 +5410,6 @@ static void rtl8xxxu_c2hcmd_callback(struct work_struct *work)
 		spin_unlock_irqrestore(&priv->c2hcmd_lock, flags);

 		c2h = (struct rtl8723bu_c2h *)skb->data;
-		len = skb->len - 2;

 		switch (c2h->id) {
 		case C2H_8723B_BT_INFO:
--
2.7.4


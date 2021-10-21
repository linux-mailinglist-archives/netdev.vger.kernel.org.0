Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3182435D1B
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 10:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231397AbhJUIoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 04:44:11 -0400
Received: from mx24.baidu.com ([111.206.215.185]:45398 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231406AbhJUIoK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 04:44:10 -0400
Received: from BC-Mail-Ex10.internal.baidu.com (unknown [172.31.51.50])
        by Forcepoint Email with ESMTPS id 3E3446DF737E714A94FD;
        Thu, 21 Oct 2021 16:41:53 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-Ex10.internal.baidu.com (172.31.51.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Thu, 21 Oct 2021 16:41:52 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Thu, 21 Oct 2021 16:41:52 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <caihuoqing@baidu.com>
CC:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        "Kalle Valo" <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] mt76: Make use of the helper macro kthread_run()
Date:   Thu, 21 Oct 2021 16:41:49 +0800
Message-ID: <20211021084150.2130-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-EX02.internal.baidu.com (172.31.51.42) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Repalce kthread_create/wake_up_process() with kthread_run()
to simplify the code.

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/net/wireless/mediatek/mt76/util.h | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/util.h b/drivers/net/wireless/mediatek/mt76/util.h
index 1c363ea9ab9c..49c52d781f40 100644
--- a/drivers/net/wireless/mediatek/mt76/util.h
+++ b/drivers/net/wireless/mediatek/mt76/util.h
@@ -70,17 +70,15 @@ mt76_worker_setup(struct ieee80211_hw *hw, struct mt76_worker *w,
 
 	if (fn)
 		w->fn = fn;
-	w->task = kthread_create(__mt76_worker_fn, w, "mt76-%s %s",
-				 name, dev_name);
+	w->task = kthread_run(__mt76_worker_fn, w,
+			      "mt76-%s %s", name, dev_name);
 
-	ret = PTR_ERR_OR_ZERO(w->task);
-	if (ret) {
+	if (IS_ERR(w->task)) {
+		ret = PTR_ERR(w->task);
 		w->task = NULL;
 		return ret;
 	}
 
-	wake_up_process(w->task);
-
 	return 0;
 }
 
-- 
2.25.1


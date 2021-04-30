Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7D436FCDB
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 16:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233473AbhD3Os2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 10:48:28 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:3349 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233274AbhD3OsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 10:48:10 -0400
Received: from dggeml710-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FWw8l3Krzz19K95;
        Fri, 30 Apr 2021 22:43:19 +0800 (CST)
Received: from dggpemm500008.china.huawei.com (7.185.36.136) by
 dggeml710-chm.china.huawei.com (10.3.17.140) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 30 Apr 2021 22:47:19 +0800
Received: from localhost (10.174.242.151) by dggpemm500008.china.huawei.com
 (7.185.36.136) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 30 Apr
 2021 22:47:18 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>
CC:     <amitkarwar@gmail.com>, <siva8118@gmail.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <dingxiaoxiong@huawei.com>, Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH net] rsi: Add a NULL check in rsi_core_xmit
Date:   Fri, 30 Apr 2021 22:46:56 +0800
Message-ID: <1619794016-27348-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.242.151]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500008.china.huawei.com (7.185.36.136)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunjian Wang <wangyunjian@huawei.com>

The skb may be NULL in rsi_core_xmit(). Add a check to avoid
dereferencing null pointer.

Addresses-Coverity: ("Dereference after null check")
Fixes: dad0d04fa7ba ("rsi: Add RS9113 wireless driver")
Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
---
 drivers/net/wireless/rsi/rsi_91x_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_core.c b/drivers/net/wireless/rsi/rsi_91x_core.c
index a48e616e0fb9..436e7b30d159 100644
--- a/drivers/net/wireless/rsi/rsi_91x_core.c
+++ b/drivers/net/wireless/rsi/rsi_91x_core.c
@@ -492,5 +492,6 @@ void rsi_core_xmit(struct rsi_common *common, struct sk_buff *skb)
 xmit_fail:
 	rsi_dbg(ERR_ZONE, "%s: Failed to queue packet\n", __func__);
 	/* Dropping pkt here */
-	ieee80211_free_txskb(common->priv->hw, skb);
+	if (skb)
+		ieee80211_free_txskb(common->priv->hw, skb);
 }
-- 
2.19.1


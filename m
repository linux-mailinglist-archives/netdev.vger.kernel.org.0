Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8679A3A1073
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 12:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238258AbhFIJp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 05:45:28 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:5466 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234148AbhFIJp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 05:45:26 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G0MXn5gg6zZfXZ;
        Wed,  9 Jun 2021 17:40:25 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 9 Jun 2021 17:43:04 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 9 Jun 2021 17:43:04 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 3/9] net: lapbether: move out assignment in if condition
Date:   Wed, 9 Jun 2021 17:39:49 +0800
Message-ID: <1623231595-33851-4-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1623231595-33851-1-git-send-email-huangguangbin2@huawei.com>
References: <1623231595-33851-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

Should not use assignment in if condition.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/lapbether.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index b6aef7b..e5ae043 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -116,7 +116,8 @@ static int lapbeth_rcv(struct sk_buff *skb, struct net_device *dev, struct packe
 	if (dev_net(dev) != &init_net)
 		goto drop;
 
-	if ((skb = skb_share_check(skb, GFP_ATOMIC)) == NULL)
+	skb = skb_share_check(skb, GFP_ATOMIC);
+	if (!skb)
 		return NET_RX_DROP;
 
 	if (!pskb_may_pull(skb, 2))
@@ -137,7 +138,8 @@ static int lapbeth_rcv(struct sk_buff *skb, struct net_device *dev, struct packe
 	skb_pull(skb, 2);	/* Remove the length bytes */
 	skb_trim(skb, len);	/* Set the length of the data */
 
-	if ((err = lapb_data_received(lapbeth->axdev, skb)) != LAPB_OK) {
+	err = lapb_data_received(lapbeth->axdev, skb);
+	if (err != LAPB_OK) {
 		printk(KERN_DEBUG "lapbether: lapb_data_received err - %d\n", err);
 		goto drop_unlock;
 	}
@@ -219,7 +221,8 @@ static netdev_tx_t lapbeth_xmit(struct sk_buff *skb,
 
 	skb_pull(skb, 1);
 
-	if ((err = lapb_data_request(dev, skb)) != LAPB_OK) {
+	err = lapb_data_request(dev, skb);
+	if (err != LAPB_OK) {
 		pr_err("lapb_data_request error - %d\n", err);
 		goto drop;
 	}
@@ -327,7 +330,8 @@ static int lapbeth_open(struct net_device *dev)
 
 	napi_enable(&lapbeth->napi);
 
-	if ((err = lapb_register(dev, &lapbeth_callbacks)) != LAPB_OK) {
+	err = lapb_register(dev, &lapbeth_callbacks);
+	if (err != LAPB_OK) {
 		pr_err("lapb_register error: %d\n", err);
 		return -ENODEV;
 	}
@@ -348,7 +352,8 @@ static int lapbeth_close(struct net_device *dev)
 	lapbeth->up = false;
 	spin_unlock_bh(&lapbeth->up_lock);
 
-	if ((err = lapb_unregister(dev)) != LAPB_OK)
+	err = lapb_unregister(dev);
+	if (err != LAPB_OK)
 		pr_err("lapb_unregister error: %d\n", err);
 
 	napi_disable(&lapbeth->napi);
-- 
2.8.1


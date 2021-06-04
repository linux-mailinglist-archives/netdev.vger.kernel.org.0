Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43E6D39B3FF
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 09:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbhFDHhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 03:37:08 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3424 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbhFDHhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 03:37:06 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FxDxG6KFdz6vGn;
        Fri,  4 Jun 2021 15:32:18 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 4 Jun 2021 15:35:18 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 4 Jun 2021 15:35:17 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 3/6] net: hdlc_x25: move out assignment in if condition
Date:   Fri, 4 Jun 2021 15:32:09 +0800
Message-ID: <1622791932-49876-4-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1622791932-49876-1-git-send-email-huangguangbin2@huawei.com>
References: <1622791932-49876-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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
 drivers/net/wan/hdlc_x25.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wan/hdlc_x25.c b/drivers/net/wan/hdlc_x25.c
index 525eb42..24fdb6c 100644
--- a/drivers/net/wan/hdlc_x25.c
+++ b/drivers/net/wan/hdlc_x25.c
@@ -137,13 +137,15 @@ static netdev_tx_t x25_xmit(struct sk_buff *skb, struct net_device *dev)
 	switch (skb->data[0]) {
 	case X25_IFACE_DATA:	/* Data to be transmitted */
 		skb_pull(skb, 1);
-		if ((result = lapb_data_request(dev, skb)) != LAPB_OK)
+		result = lapb_data_request(dev, skb);
+		if (result != LAPB_OK)
 			dev_kfree_skb(skb);
 		spin_unlock_bh(&x25st->up_lock);
 		return NETDEV_TX_OK;
 
 	case X25_IFACE_CONNECT:
-		if ((result = lapb_connect_request(dev))!= LAPB_OK) {
+		result = lapb_connect_request(dev);
+		if (result != LAPB_OK) {
 			if (result == LAPB_CONNECTED)
 				/* Send connect confirm. msg to level 3 */
 				x25_connected(dev, 0);
@@ -154,7 +156,8 @@ static netdev_tx_t x25_xmit(struct sk_buff *skb, struct net_device *dev)
 		break;
 
 	case X25_IFACE_DISCONNECT:
-		if ((result = lapb_disconnect_request(dev)) != LAPB_OK) {
+		result = lapb_disconnect_request(dev);
+		if (result != LAPB_OK) {
 			if (result == LAPB_NOTCONNECTED)
 				/* Send disconnect confirm. msg to level 3 */
 				x25_disconnected(dev, 0);
@@ -237,7 +240,8 @@ static int x25_rx(struct sk_buff *skb)
 	hdlc_device *hdlc = dev_to_hdlc(dev);
 	struct x25_state *x25st = state(hdlc);
 
-	if ((skb = skb_share_check(skb, GFP_ATOMIC)) == NULL) {
+	skb = skb_share_check(skb, GFP_ATOMIC);
+	if (!skb) {
 		dev->stats.rx_dropped++;
 		return NET_RX_DROP;
 	}
@@ -333,8 +337,9 @@ static int x25_ioctl(struct net_device *dev, struct ifreq *ifr)
 		if (result)
 			return result;
 
-		if ((result = attach_hdlc_protocol(dev, &proto,
-						   sizeof(struct x25_state))))
+		result = attach_hdlc_protocol(dev, &proto,
+					      sizeof(struct x25_state));
+		if (result)
 			return result;
 
 		memcpy(&state(hdlc)->settings, &new_settings, size);
-- 
2.8.1


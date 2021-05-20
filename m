Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BACDB38AD0A
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 13:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242590AbhETLwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 07:52:23 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4556 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241814AbhETLtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 07:49:00 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Fm7FW68yszqV26;
        Thu, 20 May 2021 19:44:47 +0800 (CST)
Received: from dggpeml500012.china.huawei.com (7.185.36.15) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 19:47:34 +0800
Received: from huawei.com (10.67.165.24) by dggpeml500012.china.huawei.com
 (7.185.36.15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 20 May
 2021 19:47:34 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <yekai13@huawei.com>
Subject: [PATCH 05/12] net/Bluetooth/6lowpan - use the correct print format
Date:   Thu, 20 May 2021 19:44:26 +0800
Message-ID: <1621511073-47766-6-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621511073-47766-1-git-send-email-yekai13@huawei.com>
References: <1621511073-47766-1-git-send-email-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500012.china.huawei.com (7.185.36.15)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to Documentation/core-api/printk-formats.rst,
Use the correct print format. Printing an unsigned int value should use %u
instead of %d. Otherwise printk() might end up displaying negative numbers.

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 net/bluetooth/6lowpan.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index cff4944..8de7876 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -195,7 +195,7 @@ static inline struct lowpan_peer *peer_lookup_dst(struct lowpan_btle_dev *dev,
 	rcu_read_lock();
 
 	list_for_each_entry_rcu(peer, &dev->peers, list) {
-		BT_DBG("dst addr %pMR dst type %d ip %pI6c",
+		BT_DBG("dst addr %pMR dst type %u ip %pI6c",
 		       &peer->chan->dst, peer->chan->dst_type,
 		       &peer->peer_addr);
 
@@ -507,7 +507,7 @@ static int send_mcast_pkt(struct sk_buff *skb, struct net_device *netdev)
 
 			local_skb = skb_clone(skb, GFP_ATOMIC);
 
-			BT_DBG("xmit %s to %pMR type %d IP %pI6c chan %p",
+			BT_DBG("xmit %s to %pMR type %u IP %pI6c chan %p",
 			       netdev->name,
 			       &pentry->chan->dst, pentry->chan->dst_type,
 			       &pentry->peer_addr, pentry->chan);
@@ -550,7 +550,7 @@ static netdev_tx_t bt_xmit(struct sk_buff *skb, struct net_device *netdev)
 
 	if (err) {
 		if (lowpan_cb(skb)->chan) {
-			BT_DBG("xmit %s to %pMR type %d IP %pI6c chan %p",
+			BT_DBG("xmit %s to %pMR type %u IP %pI6c chan %p",
 			       netdev->name, &addr, addr_type,
 			       &lowpan_cb(skb)->addr, lowpan_cb(skb)->chan);
 			err = send_pkt(lowpan_cb(skb)->chan, skb, netdev);
@@ -819,7 +819,7 @@ static void chan_close_cb(struct l2cap_chan *chan)
 
 			BT_DBG("dev %p removing %speer %p", dev,
 			       last ? "last " : "1 ", peer);
-			BT_DBG("chan %p orig refcnt %d", chan,
+			BT_DBG("chan %p orig refcnt %u", chan,
 			       kref_read(&chan->kref));
 
 			l2cap_chan_put(chan);
@@ -943,7 +943,7 @@ static int bt_6lowpan_disconnect(struct l2cap_conn *conn, u8 dst_type)
 {
 	struct lowpan_peer *peer;
 
-	BT_DBG("conn %p dst type %d", conn, dst_type);
+	BT_DBG("conn %p dst type %u", conn, dst_type);
 
 	peer = lookup_peer(conn);
 	if (!peer)
@@ -975,7 +975,7 @@ static struct l2cap_chan *bt_6lowpan_listen(void)
 
 	atomic_set(&chan->nesting, L2CAP_NESTING_PARENT);
 
-	BT_DBG("chan %p src type %d", chan, chan->src_type);
+	BT_DBG("chan %p src type %u", chan, chan->src_type);
 
 	err = l2cap_add_psm(chan, addr, cpu_to_le16(L2CAP_PSM_IPSP));
 	if (err) {
@@ -1016,7 +1016,7 @@ static int get_l2cap_conn(char *buf, bdaddr_t *addr, u8 *addr_type,
 
 	*conn = (struct l2cap_conn *)hcon->l2cap_data;
 
-	BT_DBG("conn %p dst %pMR type %d", *conn, &hcon->dst, hcon->dst_type);
+	BT_DBG("conn %p dst %pMR type %u", *conn, &hcon->dst, hcon->dst_type);
 
 	return 0;
 }
@@ -1158,7 +1158,7 @@ static ssize_t lowpan_control_write(struct file *fp,
 				return -EALREADY;
 			}
 
-			BT_DBG("conn %p dst %pMR type %d user %d", conn,
+			BT_DBG("conn %p dst %pMR type %d user %u", conn,
 			       &conn->hcon->dst, conn->hcon->dst_type,
 			       addr_type);
 		}
-- 
2.8.1


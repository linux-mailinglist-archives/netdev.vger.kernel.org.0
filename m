Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4A03354CEF
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 08:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244018AbhDFG3v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 02:29:51 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15603 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244029AbhDFG3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 02:29:10 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FDyGz5pjqz18HSL;
        Tue,  6 Apr 2021 14:26:51 +0800 (CST)
Received: from huawei.com (10.67.165.24) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.498.0; Tue, 6 Apr 2021
 14:28:56 +0800
From:   Kai Ye <yekai13@huawei.com>
To:     <marcel@holtmann.org>, <johan.hedberg@gmail.com>,
        <luiz.dentz@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-bluetooth@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] net/Bluetooth - use the correct print format
Date:   Tue, 6 Apr 2021 14:26:24 +0800
Message-ID: <1617690384-48272-1-git-send-email-yekai13@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the correct print format. Printing an unsigned int value should use %u
instead of %d. For details, please read document:
Documentation/core-api/printk-formats.rst

Signed-off-by: Kai Ye <yekai13@huawei.com>
---
 net/bluetooth/l2cap_core.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 7641fdf..2ed074d 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -492,14 +492,14 @@ static void l2cap_chan_destroy(struct kref *kref)
 
 void l2cap_chan_hold(struct l2cap_chan *c)
 {
-	BT_DBG("chan %p orig refcnt %d", c, kref_read(&c->kref));
+	BT_DBG("chan %p orig refcnt %u", c, kref_read(&c->kref));
 
 	kref_get(&c->kref);
 }
 
 void l2cap_chan_put(struct l2cap_chan *c)
 {
-	BT_DBG("chan %p orig refcnt %d", c, kref_read(&c->kref));
+	BT_DBG("chan %p orig refcnt %u", c, kref_read(&c->kref));
 
 	kref_put(&c->kref, l2cap_chan_destroy);
 }
@@ -7263,7 +7263,7 @@ static int l2cap_stream_rx(struct l2cap_chan *chan, struct l2cap_ctrl *control,
 	    L2CAP_TXSEQ_EXPECTED) {
 		l2cap_pass_to_tx(chan, control);
 
-		BT_DBG("buffer_seq %d->%d", chan->buffer_seq,
+		BT_DBG("buffer_seq %u->%u", chan->buffer_seq,
 		       __next_seq(chan, chan->buffer_seq));
 
 		chan->buffer_seq = __next_seq(chan, chan->buffer_seq);
@@ -8366,7 +8366,7 @@ void l2cap_recv_acldata(struct hci_conn *hcon, struct sk_buff *skb, u16 flags)
 	if (!conn)
 		goto drop;
 
-	BT_DBG("conn %p len %d flags 0x%x", conn, skb->len, flags);
+	BT_DBG("conn %p len %u flags 0x%x", conn, skb->len, flags);
 
 	switch (flags) {
 	case ACL_START:
@@ -8396,10 +8396,10 @@ void l2cap_recv_acldata(struct hci_conn *hcon, struct sk_buff *skb, u16 flags)
 			return;
 		}
 
-		BT_DBG("Start: total len %d, frag len %d", len, skb->len);
+		BT_DBG("Start: total len %d, frag len %u", len, skb->len);
 
 		if (skb->len > len) {
-			BT_ERR("Frame is too long (len %d, expected len %d)",
+			BT_ERR("Frame is too long (len %u, expected len %d)",
 			       skb->len, len);
 			l2cap_conn_unreliable(conn, ECOMM);
 			goto drop;
@@ -8412,7 +8412,7 @@ void l2cap_recv_acldata(struct hci_conn *hcon, struct sk_buff *skb, u16 flags)
 		break;
 
 	case ACL_CONT:
-		BT_DBG("Cont: frag len %d (expecting %d)", skb->len, conn->rx_len);
+		BT_DBG("Cont: frag len %u (expecting %u)", skb->len, conn->rx_len);
 
 		if (!conn->rx_skb) {
 			BT_ERR("Unexpected continuation frame (len %d)", skb->len);
@@ -8433,7 +8433,7 @@ void l2cap_recv_acldata(struct hci_conn *hcon, struct sk_buff *skb, u16 flags)
 		}
 
 		if (skb->len > conn->rx_len) {
-			BT_ERR("Fragment is too long (len %d, expected %d)",
+			BT_ERR("Fragment is too long (len %u, expected %u)",
 			       skb->len, conn->rx_len);
 			l2cap_recv_reset(conn);
 			l2cap_conn_unreliable(conn, ECOMM);
-- 
2.8.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 105F423C421
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 05:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgHEDu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 23:50:58 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:9333 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726233AbgHEDu4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Aug 2020 23:50:56 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id BF35688112AD7C521FA6;
        Wed,  5 Aug 2020 11:50:53 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Wed, 5 Aug 2020 11:50:48 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <robin@protonic.nl>, <linux@rempel-privat.de>,
        <kernel@pengutronix.de>, <socketcan@hartkopp.net>,
        <mkl@pengutronix.de>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net 1/4] can: j1939: fix support for multipacket broadcast message
Date:   Wed, 5 Aug 2020 11:50:22 +0800
Message-ID: <1596599425-5534-2-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1596599425-5534-1-git-send-email-zhangchangzhong@huawei.com>
References: <1596599425-5534-1-git-send-email-zhangchangzhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently j1939_tp_im_involved_anydir() in j1939_tp_recv() check the
previously set flags J1939_ECU_LOCAL_DST and J1939_ECU_LOCAL_SRC of
incoming skb, thus multipacket broadcast message was aborted by
receive side because it may come from remote ECUs and have no exact
dst address. Similarly, j1939_tp_cmd_recv() and j1939_xtp_rx_dat()
didn't process broadcast message.

So fix it by checking and process broadcast message in j1939_tp_recv(),
j1939_tp_cmd_recv() and j1939_xtp_rx_dat().

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 net/can/j1939/transport.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index 9f99af5..e5188ac 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1651,8 +1651,12 @@ static void j1939_xtp_rx_rts(struct j1939_priv *priv, struct sk_buff *skb,
 			return;
 		}
 		session = j1939_xtp_rx_rts_session_new(priv, skb);
-		if (!session)
+		if (!session) {
+			if (cmd == J1939_TP_CMD_BAM && j1939_sk_recv_match(priv, skcb))
+				netdev_info(priv->ndev, "%s: failed to create TP BAM session\n",
+					    __func__);
 			return;
+		}
 	} else {
 		if (j1939_xtp_rx_rts_session_active(session, skb)) {
 			j1939_session_put(session);
@@ -1829,6 +1833,13 @@ static void j1939_xtp_rx_dat(struct j1939_priv *priv, struct sk_buff *skb)
 		else
 			j1939_xtp_rx_dat_one(session, skb);
 	}
+
+	if (j1939_cb_is_broadcast(skcb)) {
+		session = j1939_session_get_by_addr(priv, &skcb->addr, false,
+						    false);
+		if (session)
+			j1939_xtp_rx_dat_one(session, skb);
+	}
 }
 
 /* j1939 main intf */
@@ -1920,7 +1931,7 @@ static void j1939_tp_cmd_recv(struct j1939_priv *priv, struct sk_buff *skb)
 		if (j1939_tp_im_transmitter(skcb))
 			j1939_xtp_rx_rts(priv, skb, true);
 
-		if (j1939_tp_im_receiver(skcb))
+		if (j1939_tp_im_receiver(skcb) || j1939_cb_is_broadcast(skcb))
 			j1939_xtp_rx_rts(priv, skb, false);
 
 		break;
@@ -1984,7 +1995,7 @@ int j1939_tp_recv(struct j1939_priv *priv, struct sk_buff *skb)
 {
 	struct j1939_sk_buff_cb *skcb = j1939_skb_to_cb(skb);
 
-	if (!j1939_tp_im_involved_anydir(skcb))
+	if (!j1939_tp_im_involved_anydir(skcb) && !j1939_cb_is_broadcast(skcb))
 		return 0;
 
 	switch (skcb->addr.pgn) {
-- 
2.9.5


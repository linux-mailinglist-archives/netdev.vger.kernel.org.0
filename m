Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90DE1FADB7
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 10:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727598AbfKMJ4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 04:56:04 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:57193 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727524AbfKMJ4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 04:56:00 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1iUpNW-0006Nh-Pg; Wed, 13 Nov 2019 10:55:58 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oleksij Rempel <o.rempel@pengutronix.de>,
        syzbot+ca172a0ac477ac90f045@syzkaller.appspotmail.com,
        syzbot+07ca5bce8530070a5650@syzkaller.appspotmail.com,
        syzbot+a47537d3964ef6c874e1@syzkaller.appspotmail.com
Subject: [PATCH 8/9] can: j1939: j1939_can_recv(): add priv refcounting
Date:   Wed, 13 Nov 2019 10:55:49 +0100
Message-Id: <20191113095550.26527-9-mkl@pengutronix.de>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191113095550.26527-1-mkl@pengutronix.de>
References: <20191113095550.26527-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

j1939_can_recv() can be called in parallel with socket release. In this
case sk_release and sk_destruct can be done earlier than
j1939_can_recv() is processed.

Reported-by: syzbot+ca172a0ac477ac90f045@syzkaller.appspotmail.com
Reported-by: syzbot+07ca5bce8530070a5650@syzkaller.appspotmail.com
Reported-by: syzbot+a47537d3964ef6c874e1@syzkaller.appspotmail.com
Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 net/can/j1939/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/can/j1939/main.c b/net/can/j1939/main.c
index 8dc935dc2e54..2afcf27c72c8 100644
--- a/net/can/j1939/main.c
+++ b/net/can/j1939/main.c
@@ -51,6 +51,7 @@ static void j1939_can_recv(struct sk_buff *iskb, void *data)
 	if (!skb)
 		return;
 
+	j1939_priv_get(priv);
 	can_skb_set_owner(skb, iskb->sk);
 
 	/* get a pointer to the header of the skb
@@ -104,6 +105,7 @@ static void j1939_can_recv(struct sk_buff *iskb, void *data)
 	j1939_simple_recv(priv, skb);
 	j1939_sk_recv(priv, skb);
  done:
+	j1939_priv_put(priv);
 	kfree_skb(skb);
 }
 
-- 
2.24.0


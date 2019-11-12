Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 050DFF8DC8
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 12:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbfKLLQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 06:16:11 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:51073 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbfKLLQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 06:16:10 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iUU9U-0003FE-2E; Tue, 12 Nov 2019 12:16:04 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iUU9S-0004zM-Fu; Tue, 12 Nov 2019 12:16:02 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     dev.kurt@vandijck-laurijssen.be, mkl@pengutronix.de,
        wg@grandegger.com
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        syzbot+ca172a0ac477ac90f045@syzkaller.appspotmail.com,
        syzbot+07ca5bce8530070a5650@syzkaller.appspotmail.com,
        syzbot+a47537d3964ef6c874e1@syzkaller.appspotmail.com,
        kernel@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v1 8/9] can: j1939: j1939_can_recv(): add priv refcounting
Date:   Tue, 12 Nov 2019 12:15:59 +0100
Message-Id: <20191112111600.18719-9-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.24.0.rc1
In-Reply-To: <20191112111600.18719-1-o.rempel@pengutronix.de>
References: <20191112111600.18719-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
2.24.0.rc1


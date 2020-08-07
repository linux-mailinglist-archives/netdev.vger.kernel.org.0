Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0077D23EBF3
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 13:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbgHGLKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 07:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726987AbgHGKxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 06:53:37 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA83C06179F
        for <netdev@vger.kernel.org>; Fri,  7 Aug 2020 03:52:10 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1k3zym-0004nA-8h; Fri, 07 Aug 2020 12:52:04 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1k3zyk-0007HD-3v; Fri, 07 Aug 2020 12:52:02 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     dev.kurt@vandijck-laurijssen.be, mkl@pengutronix.de,
        wg@grandegger.com
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        David Jander <david@protonic.nl>
Subject: [PATCH v1 1/5] can: j1939: transport: j1939_simple_recv(): ignore local J1939 messages send not by J1939 stack
Date:   Fri,  7 Aug 2020 12:51:56 +0200
Message-Id: <20200807105200.26441-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200807105200.26441-1-o.rempel@pengutronix.de>
References: <20200807105200.26441-1-o.rempel@pengutronix.de>
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

In current J1939 stack implementation, we process all locally send
messages as own messages. Even if it was send by CAN_RAW socket.

To reproduce it use following commands:
testj1939 -P -r can0:0x80 &
cansend can0 18238040#0123

This step will trigger false positive not critical warning:
j1939_simple_recv: Received already invalidated message

With this patch we add additional check to make sure, related skb is own
echo message.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 net/can/j1939/socket.c    | 1 +
 net/can/j1939/transport.c | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index f7587428febd..b9a17c2ee16f 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -398,6 +398,7 @@ static int j1939_sk_init(struct sock *sk)
 	spin_lock_init(&jsk->sk_session_queue_lock);
 	INIT_LIST_HEAD(&jsk->sk_session_queue);
 	sk->sk_destruct = j1939_sk_sock_destruct;
+	sk->sk_protocol = CAN_J1939;
 
 	return 0;
 }
diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index 9f99af5b0b11..b135c5e2a86e 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -2017,6 +2017,10 @@ void j1939_simple_recv(struct j1939_priv *priv, struct sk_buff *skb)
 	if (!skb->sk)
 		return;
 
+	if (skb->sk->sk_family != AF_CAN ||
+	    skb->sk->sk_protocol != CAN_J1939)
+		return;
+
 	j1939_session_list_lock(priv);
 	session = j1939_session_get_simple(priv, skb);
 	j1939_session_list_unlock(priv);
-- 
2.28.0


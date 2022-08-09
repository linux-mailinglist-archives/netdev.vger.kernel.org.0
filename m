Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE8DF58D4F5
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 09:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239681AbiHIHyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 03:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240157AbiHIHyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 03:54:49 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A3721809
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 00:54:48 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oLK4c-0000UT-EN
        for netdev@vger.kernel.org; Tue, 09 Aug 2022 09:54:46 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id AA64AC558C
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 07:53:21 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id E7E73C556B;
        Tue,  9 Aug 2022 07:53:20 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 24fe071f;
        Tue, 9 Aug 2022 07:53:19 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Fedor Pchelkin <pchelkin@ispras.ru>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 2/4] can: j1939: j1939_session_destroy(): fix memory leak of skbs
Date:   Tue,  9 Aug 2022 09:53:15 +0200
Message-Id: <20220809075317.1549323-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220809075317.1549323-1-mkl@pengutronix.de>
References: <20220809075317.1549323-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fedor Pchelkin <pchelkin@ispras.ru>

We need to drop skb references taken in j1939_session_skb_queue() when
destroying a session in j1939_session_destroy(). Otherwise those skbs
would be lost.

Link to Syzkaller info and repro: https://forge.ispras.ru/issues/11743.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

V1: https://lore.kernel.org/all/20220708175949.539064-1-pchelkin@ispras.ru

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Suggested-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/all/20220805150216.66313-1-pchelkin@ispras.ru
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/j1939/transport.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index 307ee1174a6e..d7d86c944d76 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -260,6 +260,8 @@ static void __j1939_session_drop(struct j1939_session *session)
 
 static void j1939_session_destroy(struct j1939_session *session)
 {
+	struct sk_buff *skb;
+
 	if (session->transmission) {
 		if (session->err)
 			j1939_sk_errqueue(session, J1939_ERRQUEUE_TX_ABORT);
@@ -274,7 +276,11 @@ static void j1939_session_destroy(struct j1939_session *session)
 	WARN_ON_ONCE(!list_empty(&session->sk_session_queue_entry));
 	WARN_ON_ONCE(!list_empty(&session->active_session_list_entry));
 
-	skb_queue_purge(&session->skb_queue);
+	while ((skb = skb_dequeue(&session->skb_queue)) != NULL) {
+		/* drop ref taken in j1939_session_skb_queue() */
+		skb_unref(skb);
+		kfree_skb(skb);
+	}
 	__j1939_session_drop(session);
 	j1939_priv_put(session->priv);
 	kfree(session);
-- 
2.35.1



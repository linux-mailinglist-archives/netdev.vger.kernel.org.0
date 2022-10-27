Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02DAE60F66F
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 13:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235239AbiJ0LoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 07:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235264AbiJ0LoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 07:44:07 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 082FD120EF9
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 04:44:04 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oo1Ip-0000gY-Al
        for netdev@vger.kernel.org; Thu, 27 Oct 2022 13:44:03 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 7CE5410B244
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 11:44:02 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 4028F10B229;
        Thu, 27 Oct 2022 11:44:00 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id af969fe1;
        Thu, 27 Oct 2022 11:43:57 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Yang Yingliang <yangyingliang@huawei.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 4/4] can: j1939: transport: j1939_session_skb_drop_old(): spin_unlock_irqrestore() before kfree_skb()
Date:   Thu, 27 Oct 2022 13:43:56 +0200
Message-Id: <20221027114356.1939821-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221027114356.1939821-1-mkl@pengutronix.de>
References: <20221027114356.1939821-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

It is not allowed to call kfree_skb() from hardware interrupt context
or with interrupts being disabled. The skb is unlinked from the queue,
so it can be freed after spin_unlock_irqrestore().

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/all/20221027091237.2290111-1-yangyingliang@huawei.com
Cc: stable@vger.kernel.org
[mkl: adjust subject]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/j1939/transport.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index d7d86c944d76..55f29c9f9e08 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -342,10 +342,12 @@ static void j1939_session_skb_drop_old(struct j1939_session *session)
 		__skb_unlink(do_skb, &session->skb_queue);
 		/* drop ref taken in j1939_session_skb_queue() */
 		skb_unref(do_skb);
+		spin_unlock_irqrestore(&session->skb_queue.lock, flags);
 
 		kfree_skb(do_skb);
+	} else {
+		spin_unlock_irqrestore(&session->skb_queue.lock, flags);
 	}
-	spin_unlock_irqrestore(&session->skb_queue.lock, flags);
 }
 
 void j1939_session_skb_queue(struct j1939_session *session,
-- 
2.35.1



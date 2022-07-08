Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7795656BEC9
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238969AbiGHSAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 14:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238493AbiGHSAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 14:00:21 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2FEB237C3;
        Fri,  8 Jul 2022 11:00:19 -0700 (PDT)
Received: from localhost.localdomain (unknown [176.59.170.159])
        by mail.ispras.ru (Postfix) with ESMTPSA id D068440D403E;
        Fri,  8 Jul 2022 18:00:08 +0000 (UTC)
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>, kernel@pengutronix.de,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: [PATCH] can: j1939: fix memory leak of skbs
Date:   Fri,  8 Jul 2022 20:59:49 +0300
Message-Id: <20220708175949.539064-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzkaller reported memory leak of skbs introduced with the commit
2030043e616c ("can: j1939: fix Use-after-Free, hold skb ref while in use").

Link to Syzkaller info and repro: https://forge.ispras.ru/issues/11743

The suggested solution was tested on the new memory-leak Syzkaller repro
and on the old use-after-free repro (that use-after-free bug was solved
with aforementioned commit). Although there can probably be another
situations when the numbers of skb_get() and skb_unref() calls don't match
and I don't see it in right way.

Moreover, skb_unref() call can be harmlessly removed from line 338 in
j1939_session_skb_drop_old() (/net/can/j1939/transport.c). But then I
assume this removal ruins the whole reference counts logic...

Overall, there is definitely something not clear in skb reference counts
management with skb_get() and skb_unref(). The solution we suggested fixes
the leaks and use-after-free's induced by Syzkaller but perhaps the origin
of the problem can be somewhere else.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 net/can/j1939/transport.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index 307ee1174a6e..9600b339cbf8 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -356,7 +356,6 @@ void j1939_session_skb_queue(struct j1939_session *session,
 
 	skcb->flags |= J1939_ECU_LOCAL_SRC;
 
-	skb_get(skb);
 	skb_queue_tail(&session->skb_queue, skb);
 }
 
-- 
2.25.1


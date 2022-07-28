Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90E1158443C
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 18:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbiG1QfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 12:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiG1QfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 12:35:02 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8034054ADC;
        Thu, 28 Jul 2022 09:35:01 -0700 (PDT)
Received: from localhost.localdomain (unknown [83.149.199.65])
        by mail.ispras.ru (Postfix) with ESMTPSA id 8828E40755E1;
        Thu, 28 Jul 2022 16:34:59 +0000 (UTC)
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>, kernel@pengutronix.de,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        Bastian Stender <bst@pengutronix.de>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        ldv-project@linuxtesting.org
Subject: [PATCH] can: j1939: Replace WARN_ON_ONCE with pr_warn_once() in j1939_sk_queue_activate_next_locked()
Date:   Thu, 28 Jul 2022 19:34:29 +0300
Message-Id: <20220728163429.214758-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <7ea40c0e-e696-3537-c2a4-a8eccf4695d0@ispras.ru>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We should warn user-space that it is doing something wrong when trying to
activate sessions with identical parameters but WARN_ON_ONCE macro can not
be used here as it serves a different purpose.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 net/can/j1939/socket.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index f5ecfdcf57b2..67e8b50b8bc1 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -178,7 +178,8 @@ static void j1939_sk_queue_activate_next_locked(struct j1939_session *session)
 	if (!first)
 		return;
 
-	if (WARN_ON_ONCE(j1939_session_activate(first))) {
+	if (j1939_session_activate(first)) {
+		pr_warn_once("can: j1939: Identical session is already activated.\n");
 		first->err = -EBUSY;
 		goto activate_next;
 	} else {
-- 
2.25.1


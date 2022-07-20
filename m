Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 375A457B515
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 13:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiGTLHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 07:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiGTLHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 07:07:11 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D1D4B0D7;
        Wed, 20 Jul 2022 04:07:09 -0700 (PDT)
Received: from localhost.localdomain (unknown [46.242.14.200])
        by mail.ispras.ru (Postfix) with ESMTPSA id 08A0D40737AC;
        Wed, 20 Jul 2022 11:07:06 +0000 (UTC)
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Elenita Hinds <ecathinds@gmail.com>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: [PATCH] can: j1939: Remove unnecessary WARN_ON_ONCE in j1939_sk_queue_activate_next_locked()
Date:   Wed, 20 Jul 2022 14:06:45 +0300
Message-Id: <20220720110645.519601-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The purpose of WARN_ON_ONCE if the session with the same parameters
has already been activated and is currently in active_session_list is
not very clear. Is this warning implemented to indicate that userspace
is doing something wrong?

As far as I can see, there are two lists: active_session_list (which
is for the whole device) and sk_session_queue (which is unique for
each j1939_sock), and the situation when we have two sessions with
the same type, addresses and destinations in two different
sk_session_queues (owned by two different sockets) is actually highly
probable - one is active and the other is willing to become active
but the j1939_session_activate() does not let that happen. It is
correct behaviour as I assume.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 net/can/j1939/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index f5ecfdcf57b2..be4b73afa16c 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -178,7 +178,7 @@ static void j1939_sk_queue_activate_next_locked(struct j1939_session *session)
 	if (!first)
 		return;
 
-	if (WARN_ON_ONCE(j1939_session_activate(first))) {
+	if (j1939_session_activate(first)) {
 		first->err = -EBUSY;
 		goto activate_next;
 	} else {
-- 
2.25.1


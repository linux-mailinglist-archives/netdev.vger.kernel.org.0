Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0983AB447
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 15:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbhFQNIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 09:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbhFQNIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 09:08:43 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737C2C061574
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 06:06:35 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ltriz-0007KN-Sv; Thu, 17 Jun 2021 15:06:25 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ltriy-0003KK-8Y; Thu, 17 Jun 2021 15:06:24 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     mkl@pengutronix.de, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Robin van der Gracht <robin@protonic.nl>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        syzbot+bdf710cfc41c186fdff3@syzkaller.appspotmail.com,
        kernel@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1] can: j1939: j1939_sk_init(): set SOCK_RCU_FREE to call sk_destruct() after RCU is done
Date:   Thu, 17 Jun 2021 15:06:23 +0200
Message-Id: <20210617130623.12705-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set SOCK_RCU_FREE to let RCU to call sk_destruct() on completion.
Without this patch, we will run in to j1939_can_recv() after priv was
freed by j1939_sk_release()->j1939_sk_sock_destruct()

Reported-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Reported-by: syzbot+bdf710cfc41c186fdff3@syzkaller.appspotmail.com
Fixes: 25fe97cb7620 ("can: j1939: move j1939_priv_put() into sk_destruct callback")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 net/can/j1939/socket.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index 56aa66147d5a..c7c1b4d4c0fb 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -398,6 +398,9 @@ static int j1939_sk_init(struct sock *sk)
 	atomic_set(&jsk->skb_pending, 0);
 	spin_lock_init(&jsk->sk_session_queue_lock);
 	INIT_LIST_HEAD(&jsk->sk_session_queue);
+
+	sock_set_flag(sk, SOCK_RCU_FREE);
+	/* j1939_sk_sock_destruct() depends on SOCK_RCU_FREE flag */
 	sk->sk_destruct = j1939_sk_sock_destruct;
 	sk->sk_protocol = CAN_J1939;
 
-- 
2.29.2


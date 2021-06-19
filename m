Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 108A03ADAD6
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 18:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234727AbhFSQVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 12:21:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57506 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232640AbhFSQVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 12:21:34 -0400
Received: from 1.general.cascardo.us.vpn ([10.172.70.58] helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <cascardo@canonical.com>)
        id 1ludgn-0006fD-1c; Sat, 19 Jun 2021 16:19:21 +0000
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     linux-can@vger.kernel.org
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        syzbot+0f7e7e5e2f4f40fa89c0@syzkaller.appspotmail.com,
        Norbert Slusarek <nslusarek@gmx.net>
Subject: [PATCH] can: bcm: delay release of struct bcm_op after synchronize_rcu
Date:   Sat, 19 Jun 2021 13:18:13 -0300
Message-Id: <20210619161813.2098382-1-cascardo@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

can_rx_register callbacks may be called concurrently to the call to
can_rx_unregister. The callbacks and callback data, though, are protected by
RCU and the struct sock reference count.

So the callback data is really attached to the life of sk, meaning that it
should be released on sk_destruct. However, bcm_remove_op calls tasklet_kill,
and RCU callbacks may be called under RCU softirq, so that cannot be used on
kernels before the introduction of HRTIMER_MODE_SOFT.

However, bcm_rx_handler is called under RCU protection, so after calling
can_rx_unregister, we may call synchronize_rcu in order to wait for any RCU
read-side critical sections to finish. That is, bcm_rx_handler won't be called
anymore for those ops. So, we only free them, after we do that synchronize_rcu.

Reported-by: syzbot+0f7e7e5e2f4f40fa89c0@syzkaller.appspotmail.com
Reported-by: Norbert Slusarek <nslusarek@gmx.net>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
---
 net/can/bcm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/can/bcm.c b/net/can/bcm.c
index f3e4d9528fa3..c67916020e63 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -785,6 +785,7 @@ static int bcm_delete_rx_op(struct list_head *ops, struct bcm_msg_head *mh,
 						  bcm_rx_handler, op);
 
 			list_del(&op->list);
+			synchronize_rcu();
 			bcm_remove_op(op);
 			return 1; /* done */
 		}
@@ -1533,6 +1534,11 @@ static int bcm_release(struct socket *sock)
 					  REGMASK(op->can_id),
 					  bcm_rx_handler, op);
 
+	}
+
+	synchronize_rcu();
+
+	list_for_each_entry_safe(op, next, &bo->rx_ops, list) {
 		bcm_remove_op(op);
 	}
 
-- 
2.30.2


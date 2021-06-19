Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C198E3ADBEC
	for <lists+netdev@lfdr.de>; Sun, 20 Jun 2021 00:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbhFSWDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 18:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbhFSWDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 18:03:38 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF2BC061574
        for <netdev@vger.kernel.org>; Sat, 19 Jun 2021 15:01:27 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1luj1p-0005XB-L1
        for netdev@vger.kernel.org; Sun, 20 Jun 2021 00:01:25 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 328C063F80F
        for <netdev@vger.kernel.org>; Sat, 19 Jun 2021 22:01:22 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id E0DD563F7E3;
        Sat, 19 Jun 2021 22:01:18 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 65d533c4;
        Sat, 19 Jun 2021 22:01:18 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        linux-stable <stable@vger.kernel.org>,
        syzbot+0f7e7e5e2f4f40fa89c0@syzkaller.appspotmail.com,
        Norbert Slusarek <nslusarek@gmx.net>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 1/5] can: bcm: delay release of struct bcm_op after synchronize_rcu()
Date:   Sun, 20 Jun 2021 00:01:11 +0200
Message-Id: <20210619220115.2830761-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210619220115.2830761-1-mkl@pengutronix.de>
References: <20210619220115.2830761-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

can_rx_register() callbacks may be called concurrently to the call to
can_rx_unregister(). The callbacks and callback data, though, are
protected by RCU and the struct sock reference count.

So the callback data is really attached to the life of sk, meaning
that it should be released on sk_destruct. However, bcm_remove_op()
calls tasklet_kill(), and RCU callbacks may be called under RCU
softirq, so that cannot be used on kernels before the introduction of
HRTIMER_MODE_SOFT.

However, bcm_rx_handler() is called under RCU protection, so after
calling can_rx_unregister(), we may call synchronize_rcu() in order to
wait for any RCU read-side critical sections to finish. That is,
bcm_rx_handler() won't be called anymore for those ops. So, we only
free them, after we do that synchronize_rcu().

Fixes: ffd980f976e7 ("[CAN]: Add broadcast manager (bcm) protocol")
Link: https://lore.kernel.org/r/20210619161813.2098382-1-cascardo@canonical.com
Cc: linux-stable <stable@vger.kernel.org>
Reported-by: syzbot+0f7e7e5e2f4f40fa89c0@syzkaller.appspotmail.com
Reported-by: Norbert Slusarek <nslusarek@gmx.net>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/bcm.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/can/bcm.c b/net/can/bcm.c
index f3e4d9528fa3..0928a39c4423 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -785,6 +785,7 @@ static int bcm_delete_rx_op(struct list_head *ops, struct bcm_msg_head *mh,
 						  bcm_rx_handler, op);
 
 			list_del(&op->list);
+			synchronize_rcu();
 			bcm_remove_op(op);
 			return 1; /* done */
 		}
@@ -1533,9 +1534,13 @@ static int bcm_release(struct socket *sock)
 					  REGMASK(op->can_id),
 					  bcm_rx_handler, op);
 
-		bcm_remove_op(op);
 	}
 
+	synchronize_rcu();
+
+	list_for_each_entry_safe(op, next, &bo->rx_ops, list)
+		bcm_remove_op(op);
+
 #if IS_ENABLED(CONFIG_PROC_FS)
 	/* remove procfs entry */
 	if (net->can.bcmproc_dir && bo->bcm_proc_read)

base-commit: dda2626b86c2c1813b7bfdd10d2fdd849611fc97
-- 
2.30.2



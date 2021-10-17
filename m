Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67C12430C27
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 23:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344615AbhJQVEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 17:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344613AbhJQVEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 17:04:05 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07917C061769
        for <netdev@vger.kernel.org>; Sun, 17 Oct 2021 14:01:55 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mcDI1-0000Fx-8c
        for netdev@vger.kernel.org; Sun, 17 Oct 2021 23:01:53 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id F2B06695EED
        for <netdev@vger.kernel.org>; Sun, 17 Oct 2021 21:01:47 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 91AAB695EAF;
        Sun, 17 Oct 2021 21:01:44 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 6e17d583;
        Sun, 17 Oct 2021 21:01:43 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Ziyang Xuan <william.xuanziyang@huawei.com>,
        stable@vger.kernel.org,
        syzbot+85d9878b19c94f9019ad@syzkaller.appspotmail.com,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 02/11] can: j1939: j1939_netdev_start(): fix UAF for rx_kref of j1939_priv
Date:   Sun, 17 Oct 2021 23:01:33 +0200
Message-Id: <20211017210142.2108610-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211017210142.2108610-1-mkl@pengutronix.de>
References: <20211017210142.2108610-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ziyang Xuan <william.xuanziyang@huawei.com>

It will trigger UAF for rx_kref of j1939_priv as following.

        cpu0                                    cpu1
j1939_sk_bind(socket0, ndev0, ...)
j1939_netdev_start
                                        j1939_sk_bind(socket1, ndev0, ...)
                                        j1939_netdev_start
j1939_priv_set
                                        j1939_priv_get_by_ndev_locked
j1939_jsk_add
.....
j1939_netdev_stop
kref_put_lock(&priv->rx_kref, ...)
                                        kref_get(&priv->rx_kref, ...)
                                        REFCOUNT_WARN("addition on 0;...")

====================================================
refcount_t: addition on 0; use-after-free.
WARNING: CPU: 1 PID: 20874 at lib/refcount.c:25 refcount_warn_saturate+0x169/0x1e0
RIP: 0010:refcount_warn_saturate+0x169/0x1e0
Call Trace:
 j1939_netdev_start+0x68b/0x920
 j1939_sk_bind+0x426/0xeb0
 ? security_socket_bind+0x83/0xb0

The rx_kref's kref_get() and kref_put() should use j1939_netdev_lock to
protect.

Fixes: 9d71dd0c70099 ("can: add support of SAE J1939 protocol")
Link: https://lore.kernel.org/all/20210926104757.2021540-1-william.xuanziyang@huawei.com
Cc: stable@vger.kernel.org
Reported-by: syzbot+85d9878b19c94f9019ad@syzkaller.appspotmail.com
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/j1939/main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/can/j1939/main.c b/net/can/j1939/main.c
index 08c8606cfd9c..9bc55ecb37f9 100644
--- a/net/can/j1939/main.c
+++ b/net/can/j1939/main.c
@@ -249,11 +249,14 @@ struct j1939_priv *j1939_netdev_start(struct net_device *ndev)
 	struct j1939_priv *priv, *priv_new;
 	int ret;
 
-	priv = j1939_priv_get_by_ndev(ndev);
+	spin_lock(&j1939_netdev_lock);
+	priv = j1939_priv_get_by_ndev_locked(ndev);
 	if (priv) {
 		kref_get(&priv->rx_kref);
+		spin_unlock(&j1939_netdev_lock);
 		return priv;
 	}
+	spin_unlock(&j1939_netdev_lock);
 
 	priv = j1939_priv_create(ndev);
 	if (!priv)
@@ -269,10 +272,10 @@ struct j1939_priv *j1939_netdev_start(struct net_device *ndev)
 		/* Someone was faster than us, use their priv and roll
 		 * back our's.
 		 */
+		kref_get(&priv_new->rx_kref);
 		spin_unlock(&j1939_netdev_lock);
 		dev_put(ndev);
 		kfree(priv);
-		kref_get(&priv_new->rx_kref);
 		return priv_new;
 	}
 	j1939_priv_set(ndev, priv);
-- 
2.33.0



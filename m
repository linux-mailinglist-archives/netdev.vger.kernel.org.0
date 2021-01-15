Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93D8F2F7E3D
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 15:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732208AbhAOOb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 09:31:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbhAOOb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 09:31:28 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 778D6C0613D3
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 06:30:47 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1l0Q7b-0002jd-LQ; Fri, 15 Jan 2021 15:30:39 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1l0Q7Z-00089T-K2; Fri, 15 Jan 2021 15:30:37 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     mkl@pengutronix.de, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Robin van der Gracht <robin@protonic.nl>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net 2/2] net: can: j1939: fix check for valid CAN devices
Date:   Fri, 15 Jan 2021 15:30:36 +0100
Message-Id: <20210115143036.31275-2-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115143036.31275-1-o.rempel@pengutronix.de>
References: <20210115143036.31275-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the last patch a dedicated struct can_ml pointer was added to the
struct netdevice to store CAN stack related private data. The data is
only allocated and the pointer is only set by CAN devices.

Now we use a NULL pointer check on ndev->can to check for real CAN
devices. Only checking the ARPHRD via ndev->type is not sufficient,
since it can be set by user space to an arbitrary value for tun/tap
devices.

Since the ndev->type and ndev->can are now checked early, this patch
removes obsolete checks further down the call stacks.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 net/can/j1939/main.c   | 12 +++---------
 net/can/j1939/socket.c |  2 +-
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/net/can/j1939/main.c b/net/can/j1939/main.c
index 62088074230d..fbc0d25046e2 100644
--- a/net/can/j1939/main.c
+++ b/net/can/j1939/main.c
@@ -213,9 +213,6 @@ static inline struct j1939_priv *j1939_ndev_to_priv(struct net_device *ndev)
 {
 	struct can_ml_priv *can_ml_priv = ndev->can;
 
-	if (!can_ml_priv)
-		return NULL;
-
 	return can_ml_priv->j1939_priv;
 }
 
@@ -225,9 +222,6 @@ static struct j1939_priv *j1939_priv_get_by_ndev_locked(struct net_device *ndev)
 
 	lockdep_assert_held(&j1939_netdev_lock);
 
-	if (ndev->type != ARPHRD_CAN)
-		return NULL;
-
 	priv = j1939_ndev_to_priv(ndev);
 	if (priv)
 		j1939_priv_get(priv);
@@ -350,13 +344,13 @@ static int j1939_netdev_notify(struct notifier_block *nb,
 	struct net_device *ndev = netdev_notifier_info_to_dev(data);
 	struct j1939_priv *priv;
 
+	if (ndev->type != ARPHRD_CAN || !ndev->can)
+		goto notify_put;
+
 	priv = j1939_priv_get_by_ndev(ndev);
 	if (!priv)
 		goto notify_done;
 
-	if (ndev->type != ARPHRD_CAN)
-		goto notify_put;
-
 	switch (msg) {
 	case NETDEV_DOWN:
 		j1939_cancel_active_session(priv, NULL);
diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index 8010fbc8bd29..61732e558980 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -461,7 +461,7 @@ static int j1939_sk_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 			goto out_release_sock;
 		}
 
-		if (ndev->type != ARPHRD_CAN) {
+		if (ndev->type != ARPHRD_CAN || !ndev->can) {
 			dev_put(ndev);
 			ret = -ENODEV;
 			goto out_release_sock;
-- 
2.30.0


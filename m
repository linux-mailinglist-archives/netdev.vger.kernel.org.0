Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 835EF4854E5
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241039AbiAEOoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:44:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241028AbiAEOoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 09:44:22 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6399C061784
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 06:44:22 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1n57WW-0004KJ-W1
        for netdev@vger.kernel.org; Wed, 05 Jan 2022 15:44:21 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 3975E6D1B28
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 14:44:11 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id BBC3B6D1AD8;
        Wed,  5 Jan 2022 14:44:06 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 25a46bd5;
        Wed, 5 Jan 2022 14:44:04 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 12/15] can: dev: replace can_priv::ctrlmode_static by can_get_static_ctrlmode()
Date:   Wed,  5 Jan 2022 15:43:59 +0100
Message-Id: <20220105144402.1174191-13-mkl@pengutronix.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220105144402.1174191-1-mkl@pengutronix.de>
References: <20220105144402.1174191-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

The statically enabled features of a CAN controller can be retrieved
using below formula:

| u32 ctrlmode_static = priv->ctrlmode & ~priv->ctrlmode_supported;

As such, there is no need to store this information. This patch remove
the field ctrlmode_static of struct can_priv and provides, in
replacement, the inline function can_get_static_ctrlmode() which
returns the same value.

Link: https://lore.kernel.org/all/20211213160226.56219-2-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev/dev.c     | 5 +++--
 drivers/net/can/dev/netlink.c | 2 +-
 include/linux/can/dev.h       | 7 +++++--
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/dev/dev.c b/drivers/net/can/dev/dev.c
index 4845ae6456e1..c192f25f9695 100644
--- a/drivers/net/can/dev/dev.c
+++ b/drivers/net/can/dev/dev.c
@@ -296,6 +296,7 @@ EXPORT_SYMBOL_GPL(free_candev);
 int can_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct can_priv *priv = netdev_priv(dev);
+	u32 ctrlmode_static = can_get_static_ctrlmode(priv);
 
 	/* Do not allow changing the MTU while running */
 	if (dev->flags & IFF_UP)
@@ -305,7 +306,7 @@ int can_change_mtu(struct net_device *dev, int new_mtu)
 	switch (new_mtu) {
 	case CAN_MTU:
 		/* 'CANFD-only' controllers can not switch to CAN_MTU */
-		if (priv->ctrlmode_static & CAN_CTRLMODE_FD)
+		if (ctrlmode_static & CAN_CTRLMODE_FD)
 			return -EINVAL;
 
 		priv->ctrlmode &= ~CAN_CTRLMODE_FD;
@@ -314,7 +315,7 @@ int can_change_mtu(struct net_device *dev, int new_mtu)
 	case CANFD_MTU:
 		/* check for potential CANFD ability */
 		if (!(priv->ctrlmode_supported & CAN_CTRLMODE_FD) &&
-		    !(priv->ctrlmode_static & CAN_CTRLMODE_FD))
+		    !(ctrlmode_static & CAN_CTRLMODE_FD))
 			return -EINVAL;
 
 		priv->ctrlmode |= CAN_CTRLMODE_FD;
diff --git a/drivers/net/can/dev/netlink.c b/drivers/net/can/dev/netlink.c
index 95cca4e5251f..26c336808be5 100644
--- a/drivers/net/can/dev/netlink.c
+++ b/drivers/net/can/dev/netlink.c
@@ -211,7 +211,7 @@ static int can_changelink(struct net_device *dev, struct nlattr *tb[],
 		if (dev->flags & IFF_UP)
 			return -EBUSY;
 		cm = nla_data(data[IFLA_CAN_CTRLMODE]);
-		ctrlstatic = priv->ctrlmode_static;
+		ctrlstatic = can_get_static_ctrlmode(priv);
 		maskedflags = cm->flags & cm->mask;
 
 		/* check whether provided bits are allowed to be passed */
diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
index 45f19d9db5ca..92e2d69462f0 100644
--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -69,7 +69,6 @@ struct can_priv {
 	/* CAN controller features - see include/uapi/linux/can/netlink.h */
 	u32 ctrlmode;		/* current options setting */
 	u32 ctrlmode_supported;	/* options that can be modified by netlink */
-	u32 ctrlmode_static;	/* static enabled options for driver/hardware */
 
 	int restart_ms;
 	struct delayed_work restart_work;
@@ -139,13 +138,17 @@ static inline void can_set_static_ctrlmode(struct net_device *dev,
 
 	/* alloc_candev() succeeded => netdev_priv() is valid at this point */
 	priv->ctrlmode = static_mode;
-	priv->ctrlmode_static = static_mode;
 
 	/* override MTU which was set by default in can_setup()? */
 	if (static_mode & CAN_CTRLMODE_FD)
 		dev->mtu = CANFD_MTU;
 }
 
+static inline u32 can_get_static_ctrlmode(struct can_priv *priv)
+{
+	return priv->ctrlmode & ~priv->ctrlmode_supported;
+}
+
 void can_setup(struct net_device *dev);
 
 struct net_device *alloc_candev_mqs(int sizeof_priv, unsigned int echo_skb_max,
-- 
2.34.1



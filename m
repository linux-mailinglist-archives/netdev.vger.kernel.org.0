Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8B6427A7D
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 15:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233451AbhJINP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 09:15:28 -0400
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:51497 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233022AbhJINPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 09:15:21 -0400
Received: from tomoyo.flets-east.jp ([114.149.34.46])
        by smtp.orange.fr with ESMTPA
        id ZC9zmoEn4UGqlZCADm2ie4; Sat, 09 Oct 2021 15:13:24 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: MDU0YmViZGZmMDIzYiBlMiM2NTczNTRjNWZkZTMwOGRiOGQ4ODf3NWI1ZTMyMzdiODlhOQ==
X-ME-Date: Sat, 09 Oct 2021 15:13:24 +0200
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v2 1/3] can: dev: replace can_priv::ctrlmode_static by can_get_static_ctrlmode()
Date:   Sat,  9 Oct 2021 22:13:02 +0900
Message-Id: <20211009131304.19729-2-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211009131304.19729-1-mailhol.vincent@wanadoo.fr>
References: <20211009131304.19729-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The statically enabled features of a CAN controller can be retrieved
using below formula:

| u32 ctrlmode_static = priv->ctrlmode & ~priv->ctrlmode_supported;

As such, there is no need to store this information. This patch remove
the field ctrlmode_static of struct can_priv and provides, in
replacement, the inline function can_get_static_ctrlmode() which
returns the same value.

A condition sine qua non for this to work is that the controller
static modes should never be set in can_priv::ctrlmode_supported. This
is already the case for existing drivers, however, we added a warning
message in can_set_static_ctrlmode() to check that.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/dev/dev.c     |  5 +++--
 drivers/net/can/dev/netlink.c |  2 +-
 include/linux/can/dev.h       | 12 ++++++++++--
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/dev/dev.c b/drivers/net/can/dev/dev.c
index e3d840b81357..59c79f92fccc 100644
--- a/drivers/net/can/dev/dev.c
+++ b/drivers/net/can/dev/dev.c
@@ -300,6 +300,7 @@ EXPORT_SYMBOL_GPL(free_candev);
 int can_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct can_priv *priv = netdev_priv(dev);
+	u32 ctrlmode_static = can_get_static_ctrlmode(priv);
 
 	/* Do not allow changing the MTU while running */
 	if (dev->flags & IFF_UP)
@@ -309,7 +310,7 @@ int can_change_mtu(struct net_device *dev, int new_mtu)
 	switch (new_mtu) {
 	case CAN_MTU:
 		/* 'CANFD-only' controllers can not switch to CAN_MTU */
-		if (priv->ctrlmode_static & CAN_CTRLMODE_FD)
+		if (ctrlmode_static & CAN_CTRLMODE_FD)
 			return -EINVAL;
 
 		priv->ctrlmode &= ~CAN_CTRLMODE_FD;
@@ -318,7 +319,7 @@ int can_change_mtu(struct net_device *dev, int new_mtu)
 	case CANFD_MTU:
 		/* check for potential CANFD ability */
 		if (!(priv->ctrlmode_supported & CAN_CTRLMODE_FD) &&
-		    !(priv->ctrlmode_static & CAN_CTRLMODE_FD))
+		    !(ctrlmode_static & CAN_CTRLMODE_FD))
 			return -EINVAL;
 
 		priv->ctrlmode |= CAN_CTRLMODE_FD;
diff --git a/drivers/net/can/dev/netlink.c b/drivers/net/can/dev/netlink.c
index 80425636049d..6c9906e8040c 100644
--- a/drivers/net/can/dev/netlink.c
+++ b/drivers/net/can/dev/netlink.c
@@ -112,7 +112,7 @@ static int can_changelink(struct net_device *dev, struct nlattr *tb[],
 		if (dev->flags & IFF_UP)
 			return -EBUSY;
 		cm = nla_data(data[IFLA_CAN_CTRLMODE]);
-		ctrlstatic = priv->ctrlmode_static;
+		ctrlstatic = can_get_static_ctrlmode(priv);
 		maskedflags = cm->flags & cm->mask;
 
 		/* check whether provided bits are allowed to be passed */
diff --git a/include/linux/can/dev.h b/include/linux/can/dev.h
index 2413253e54c7..2381ad9e0814 100644
--- a/include/linux/can/dev.h
+++ b/include/linux/can/dev.h
@@ -69,7 +69,6 @@ struct can_priv {
 	/* CAN controller features - see include/uapi/linux/can/netlink.h */
 	u32 ctrlmode;		/* current options setting */
 	u32 ctrlmode_supported;	/* options that can be modified by netlink */
-	u32 ctrlmode_static;	/* static enabled options for driver/hardware */
 
 	int restart_ms;
 	struct delayed_work restart_work;
@@ -104,14 +103,23 @@ static inline void can_set_static_ctrlmode(struct net_device *dev,
 	struct can_priv *priv = netdev_priv(dev);
 
 	/* alloc_candev() succeeded => netdev_priv() is valid at this point */
+	if (priv->ctrlmode_supported & static_mode) {
+		netdev_warn(dev,
+			    "Controller features can not be supported and static at the same time\n");
+		return;
+	}
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
2.32.0


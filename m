Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8B8401E06
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 18:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243866AbhIFQFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 12:05:08 -0400
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:33718 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S243841AbhIFQFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 12:05:07 -0400
Received: from localhost.localdomain ([114.149.34.46])
        by mwinf5d79 with ME
        id qg3U2500Z0zjR6y03g3z7v; Mon, 06 Sep 2021 18:04:01 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Mon, 06 Sep 2021 18:04:01 +0200
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v3 2/2] can: bittiming: change can_calc_tdco()'s prototype to not directly modify priv
Date:   Tue,  7 Sep 2021 01:03:10 +0900
Message-Id: <20210906160310.54831-3-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210906160310.54831-1-mailhol.vincent@wanadoo.fr>
References: <20210906160310.54831-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In previous commit, we introduced a temporary priv variable in
can_changelink(), wrote the changes to it and committed all changes at
the very end of the function.

However, the function can_calc_tdco() directly retrieves can_priv from
the net_device and directly modifies it. We change the prototype so
that it instead writes its changes to a struct can_priv that is passed
as an argument. This way, can_changelink() can pass the newly
introduced temporary priv variable.


Fixes: c25cc7993243 ("can: bittiming: add calculation for CAN FD Transmitter Delay Compensation (TDC)")
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/dev/bittiming.c | 8 ++------
 drivers/net/can/dev/netlink.c   | 2 +-
 include/linux/can/bittiming.h   | 7 +++++--
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/can/dev/bittiming.c b/drivers/net/can/dev/bittiming.c
index f49170eadd54..bddd93e2e439 100644
--- a/drivers/net/can/dev/bittiming.c
+++ b/drivers/net/can/dev/bittiming.c
@@ -175,13 +175,9 @@ int can_calc_bittiming(struct net_device *dev, struct can_bittiming *bt,
 	return 0;
 }
 
-void can_calc_tdco(struct net_device *dev)
+void can_calc_tdco(struct can_tdc *tdc, const struct can_tdc_const *tdc_const,
+		   const struct can_bittiming *dbt)
 {
-	struct can_priv *priv = netdev_priv(dev);
-	const struct can_bittiming *dbt = &priv->data_bittiming;
-	struct can_tdc *tdc = &priv->tdc;
-	const struct can_tdc_const *tdc_const = priv->tdc_const;
-
 	if (!tdc_const)
 		return;
 
diff --git a/drivers/net/can/dev/netlink.c b/drivers/net/can/dev/netlink.c
index 21b76ca8cb22..66815ea6046e 100644
--- a/drivers/net/can/dev/netlink.c
+++ b/drivers/net/can/dev/netlink.c
@@ -190,7 +190,7 @@ static int can_changelink(struct net_device *dev, struct nlattr *tb[],
 			return -EINVAL;
 		}
 
-		can_calc_tdco(dev);
+		can_calc_tdco(&priv->tdc, priv->tdc_const, &priv->data_bittiming);
 
 		if (priv->do_set_data_bittiming) {
 			/* Finally, set the bit-timing registers */
diff --git a/include/linux/can/bittiming.h b/include/linux/can/bittiming.h
index 9de6e9053e34..b3c1711ee0f0 100644
--- a/include/linux/can/bittiming.h
+++ b/include/linux/can/bittiming.h
@@ -87,7 +87,8 @@ struct can_tdc_const {
 int can_calc_bittiming(struct net_device *dev, struct can_bittiming *bt,
 		       const struct can_bittiming_const *btc);
 
-void can_calc_tdco(struct net_device *dev);
+void can_calc_tdco(struct can_tdc *tdc, const struct can_tdc_const *tdc_const,
+		   const struct can_bittiming *dbt);
 #else /* !CONFIG_CAN_CALC_BITTIMING */
 static inline int
 can_calc_bittiming(struct net_device *dev, struct can_bittiming *bt,
@@ -97,7 +98,9 @@ can_calc_bittiming(struct net_device *dev, struct can_bittiming *bt,
 	return -EINVAL;
 }
 
-static inline void can_calc_tdco(struct net_device *dev)
+static inline void
+can_calc_tdco(struct can_tdc *tdc, const struct can_tdc_const *tdc_const,
+	      const struct can_bittiming *dbt)
 {
 }
 #endif /* CONFIG_CAN_CALC_BITTIMING */
-- 
2.32.0


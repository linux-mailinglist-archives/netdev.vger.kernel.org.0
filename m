Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC0B4105C9
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 11:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244754AbhIRJ7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Sep 2021 05:59:15 -0400
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:50048 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244345AbhIRJ7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Sep 2021 05:59:02 -0400
Received: from tomoyo.flets-east.jp ([114.149.34.46])
        by smtp.orange.fr with ESMTPA
        id RX5Zmuh4X1yYBRX6Gm0kHR; Sat, 18 Sep 2021 11:57:38 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: MDU0YmViZGZmMDIzYiBlMiM2NTczNTRjNWZkZTMwOGRiOGQ4ODf3NWI1ZTMyMzdiODlhOQ==
X-ME-Date: Sat, 18 Sep 2021 11:57:38 +0200
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Stefan=20M=C3=A4tje?= <Stefan.Maetje@esd.eu>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v6 3/6] can: bittiming: change can_calc_tdco()'s prototype to not directly modify priv
Date:   Sat, 18 Sep 2021 18:56:34 +0900
Message-Id: <20210918095637.20108-4-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210918095637.20108-1-mailhol.vincent@wanadoo.fr>
References: <20210918095637.20108-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function can_calc_tdco() directly retrieves can_priv from the
net_device and directly modifies it.

This is annoying for the upcoming patch. In
drivers/net/can/dev/netlink.c:can_changelink(), the data bittiming are
written to a temporary structure and memcpyed to can_priv only after
everything succeeded. In the next patch, where we will introduce the
netlink interface for TDC parameters, we will add a new TDC block
which can potentially fail. For this reason, the data bittiming
temporary structure has to be copied after that to-be-introduced TDC
block. However, TDC also needs to access data bittiming information.

We change the prototype so that the data bittiming structure is passed
to can_calc_tdco() as an argument instead of retrieving it from
priv. This way can_calc_tdco() can access the data bittiming before it
gets memcpyed to priv.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/dev/bittiming.c | 17 +++++++----------
 drivers/net/can/dev/netlink.c   |  3 ++-
 include/linux/can/bittiming.h   |  9 +++++++--
 3 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/net/can/dev/bittiming.c b/drivers/net/can/dev/bittiming.c
index 582463bc15f7..d439ea676e6e 100644
--- a/drivers/net/can/dev/bittiming.c
+++ b/drivers/net/can/dev/bittiming.c
@@ -175,18 +175,15 @@ int can_calc_bittiming(struct net_device *dev, struct can_bittiming *bt,
 	return 0;
 }
 
-void can_calc_tdco(struct net_device *dev)
-{
-	struct can_priv *priv = netdev_priv(dev);
-	const struct can_bittiming *dbt = &priv->data_bittiming;
-	struct can_tdc *tdc = &priv->tdc;
-	const struct can_tdc_const *tdc_const = priv->tdc_const;
+void can_calc_tdco(struct can_tdc *tdc, const struct can_tdc_const *tdc_const,
+		   const struct can_bittiming *dbt,
+		   u32 *ctrlmode, u32 ctrlmode_supported)
 
-	if (!tdc_const ||
-	    !(priv->ctrlmode_supported & CAN_CTRLMODE_TDC_AUTO))
+{
+	if (!tdc_const || !(ctrlmode_supported & CAN_CTRLMODE_TDC_AUTO))
 		return;
 
-	priv->ctrlmode &= ~CAN_CTRLMODE_TDC_MASK;
+	*ctrlmode &= ~CAN_CTRLMODE_TDC_MASK;
 
 	/* As specified in ISO 11898-1 section 11.3.3 "Transmitter
 	 * delay compensation" (TDC) is only applicable if data BRP is
@@ -200,7 +197,7 @@ void can_calc_tdco(struct net_device *dev)
 		if (sample_point_in_tc < tdc_const->tdco_min)
 			return;
 		tdc->tdco = min(sample_point_in_tc, tdc_const->tdco_max);
-		priv->ctrlmode |= CAN_CTRLMODE_TDC_AUTO;
+		*ctrlmode |= CAN_CTRLMODE_TDC_AUTO;
 	}
 }
 #endif /* CONFIG_CAN_CALC_BITTIMING */
diff --git a/drivers/net/can/dev/netlink.c b/drivers/net/can/dev/netlink.c
index 80425636049d..e79c9a2ffbfc 100644
--- a/drivers/net/can/dev/netlink.c
+++ b/drivers/net/can/dev/netlink.c
@@ -189,7 +189,8 @@ static int can_changelink(struct net_device *dev, struct nlattr *tb[],
 
 		memcpy(&priv->data_bittiming, &dbt, sizeof(dbt));
 
-		can_calc_tdco(dev);
+		can_calc_tdco(&priv->tdc, priv->tdc_const, &priv->data_bittiming,
+			      &priv->ctrlmode, priv->ctrlmode_supported);
 
 		if (priv->do_set_data_bittiming) {
 			/* Finally, set the bit-timing registers */
diff --git a/include/linux/can/bittiming.h b/include/linux/can/bittiming.h
index aebbe65dab7e..20b50baf3a02 100644
--- a/include/linux/can/bittiming.h
+++ b/include/linux/can/bittiming.h
@@ -123,7 +123,9 @@ struct can_tdc_const {
 int can_calc_bittiming(struct net_device *dev, struct can_bittiming *bt,
 		       const struct can_bittiming_const *btc);
 
-void can_calc_tdco(struct net_device *dev);
+void can_calc_tdco(struct can_tdc *tdc, const struct can_tdc_const *tdc_const,
+		   const struct can_bittiming *dbt,
+		   u32 *ctrlmode, u32 ctrlmode_supported);
 #else /* !CONFIG_CAN_CALC_BITTIMING */
 static inline int
 can_calc_bittiming(struct net_device *dev, struct can_bittiming *bt,
@@ -133,7 +135,10 @@ can_calc_bittiming(struct net_device *dev, struct can_bittiming *bt,
 	return -EINVAL;
 }
 
-static inline void can_calc_tdco(struct net_device *dev)
+static inline void
+can_calc_tdco(struct can_tdc *tdc, const struct can_tdc_const *tdc_const,
+	      const struct can_bittiming *dbt,
+	      u32 *ctrlmode, u32 ctrlmode_supported)
 {
 }
 #endif /* CONFIG_CAN_CALC_BITTIMING */
-- 
2.32.0


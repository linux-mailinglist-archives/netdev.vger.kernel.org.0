Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74961438BF2
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 22:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbhJXUrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 16:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232002AbhJXUrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 16:47:19 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B7CC061243
        for <netdev@vger.kernel.org>; Sun, 24 Oct 2021 13:44:57 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mekMR-0006PK-PY
        for netdev@vger.kernel.org; Sun, 24 Oct 2021 22:44:55 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id C9ECF69C5C3
        for <netdev@vger.kernel.org>; Sun, 24 Oct 2021 20:43:32 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id C1CD169C55E;
        Sun, 24 Oct 2021 20:43:29 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id b13f206f;
        Sun, 24 Oct 2021 20:43:27 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 05/15] can: bittiming: change can_calc_tdco()'s prototype to not directly modify priv
Date:   Sun, 24 Oct 2021 22:43:15 +0200
Message-Id: <20211024204325.3293425-6-mkl@pengutronix.de>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211024204325.3293425-1-mkl@pengutronix.de>
References: <20211024204325.3293425-1-mkl@pengutronix.de>
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

Link: https://lore.kernel.org/all/20210918095637.20108-4-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev/bittiming.c | 17 +++++++----------
 drivers/net/can/dev/netlink.c   |  3 ++-
 include/linux/can/bittiming.h   |  9 +++++++--
 3 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/net/can/dev/bittiming.c b/drivers/net/can/dev/bittiming.c
index 0ccf982ca301..0509625c3082 100644
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
2.33.0



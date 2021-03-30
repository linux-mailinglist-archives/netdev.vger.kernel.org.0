Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B55234E692
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 13:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbhC3Lq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 07:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231922AbhC3LqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 07:46:24 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8427C061762
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 04:46:20 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lRCp9-0005yO-I9
        for netdev@vger.kernel.org; Tue, 30 Mar 2021 13:46:19 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 5C225603E24
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 11:46:11 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 532BA603DDB;
        Tue, 30 Mar 2021 11:46:03 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 5be43907;
        Tue, 30 Mar 2021 11:46:00 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 09/39] can: bittiming: add calculation for CAN FD Transmitter Delay Compensation (TDC)
Date:   Tue, 30 Mar 2021 13:45:29 +0200
Message-Id: <20210330114559.1114855-10-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330114559.1114855-1-mkl@pengutronix.de>
References: <20210330114559.1114855-1-mkl@pengutronix.de>
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

The logic for the tdco calculation is to just reuse the normal sample
point: tdco = sp. Because the sample point is expressed in tenth of
percent and the tdco is expressed in time quanta, a conversion is
needed.

At the end,
     ssp = tdcv + tdco
         = tdcv + sp.

Another popular method is to set tdco to the middle of the bit:
     tdc->tdco = can_bit_time(dbt) / 2
During benchmark tests, we could not find a clear advantages for one
of the two methods.

The tdco calculation is triggered each time the data_bittiming is
changed so that users relying on automated calculation can use the
netlink interface the exact same way without need of new parameters.
For example, a command such as:
	ip link set canX type can bitrate 500000 dbitrate 4000000 fd on
would trigger the calculation.

The user using CONFIG_CAN_CALC_BITTIMING who does not want automated
calculation needs to manually set tdco to zero.
For example with:
	ip link set canX type can tdco 0 bitrate 500000 dbitrate 4000000 fd on
(if the tdco parameter is provided in a previous command, it will be
overwritten).

If tdcv is set to zero (default), it is automatically calculated by
the transiver for each frame. As such, there is no code in the kernel
to calculate it.

tdcf has no automated calculation functions because we could not
figure out a formula for this parameter.

Link: https://lore.kernel.org/r/20210224002008.4158-6-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev/bittiming.c | 24 ++++++++++++++++++++++++
 drivers/net/can/dev/netlink.c   |  2 ++
 include/linux/can/bittiming.h   |  6 ++++++
 3 files changed, 32 insertions(+)

diff --git a/drivers/net/can/dev/bittiming.c b/drivers/net/can/dev/bittiming.c
index f7fe226bb395..2907e60c9a57 100644
--- a/drivers/net/can/dev/bittiming.c
+++ b/drivers/net/can/dev/bittiming.c
@@ -174,6 +174,30 @@ int can_calc_bittiming(struct net_device *dev, struct can_bittiming *bt,
 
 	return 0;
 }
+
+void can_calc_tdco(struct net_device *dev)
+{
+	struct can_priv *priv = netdev_priv(dev);
+	const struct can_bittiming *dbt = &priv->data_bittiming;
+	struct can_tdc *tdc = &priv->tdc;
+	const struct can_tdc_const *tdc_const = priv->tdc_const;
+
+	if (!tdc_const)
+		return;
+
+	/* As specified in ISO 11898-1 section 11.3.3 "Transmitter
+	 * delay compensation" (TDC) is only applicable if data BRP is
+	 * one or two.
+	 */
+	if (dbt->brp == 1 || dbt->brp == 2) {
+		/* Reuse "normal" sample point and convert it to time quanta */
+		u32 sample_point_in_tq = can_bit_time(dbt) * dbt->sample_point / 1000;
+
+		tdc->tdco = min(sample_point_in_tq, tdc_const->tdco_max);
+	} else {
+		tdc->tdco = 0;
+	}
+}
 #endif /* CONFIG_CAN_CALC_BITTIMING */
 
 /* Checks the validity of the specified bit-timing parameters prop_seg,
diff --git a/drivers/net/can/dev/netlink.c b/drivers/net/can/dev/netlink.c
index 8443480a703d..e38c2566aff4 100644
--- a/drivers/net/can/dev/netlink.c
+++ b/drivers/net/can/dev/netlink.c
@@ -186,6 +186,8 @@ static int can_changelink(struct net_device *dev, struct nlattr *tb[],
 
 		memcpy(&priv->data_bittiming, &dbt, sizeof(dbt));
 
+		can_calc_tdco(dev);
+
 		if (priv->do_set_data_bittiming) {
 			/* Finally, set the bit-timing registers */
 			err = priv->do_set_data_bittiming(dev);
diff --git a/include/linux/can/bittiming.h b/include/linux/can/bittiming.h
index b31a49f19b47..3c4cad7b52c0 100644
--- a/include/linux/can/bittiming.h
+++ b/include/linux/can/bittiming.h
@@ -78,6 +78,8 @@ struct can_tdc_const {
 #ifdef CONFIG_CAN_CALC_BITTIMING
 int can_calc_bittiming(struct net_device *dev, struct can_bittiming *bt,
 		       const struct can_bittiming_const *btc);
+
+void can_calc_tdco(struct net_device *dev);
 #else /* !CONFIG_CAN_CALC_BITTIMING */
 static inline int
 can_calc_bittiming(struct net_device *dev, struct can_bittiming *bt,
@@ -86,6 +88,10 @@ can_calc_bittiming(struct net_device *dev, struct can_bittiming *bt,
 	netdev_err(dev, "bit-timing calculation not available\n");
 	return -EINVAL;
 }
+
+static inline void can_calc_tdco(struct net_device *dev)
+{
+}
 #endif /* CONFIG_CAN_CALC_BITTIMING */
 
 int can_get_bittiming(struct net_device *dev, struct can_bittiming *bt,
-- 
2.30.2



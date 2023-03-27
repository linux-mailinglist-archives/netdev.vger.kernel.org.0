Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A38286C9C1B
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 09:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232552AbjC0HeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 03:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232550AbjC0HeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 03:34:07 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6267649F3
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 00:34:02 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pghMe-0000HX-Pw
        for netdev@vger.kernel.org; Mon, 27 Mar 2023 09:34:00 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 04B6719CDD6
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 07:33:59 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 8680D19CDC0;
        Mon, 27 Mar 2023 07:33:57 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 3ce3c1d5;
        Mon, 27 Mar 2023 07:33:55 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <simon.horman@corigine.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 01/11] can: rcar_canfd: Add transceiver support
Date:   Mon, 27 Mar 2023 09:33:44 +0200
Message-Id: <20230327073354.1003134-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230327073354.1003134-1-mkl@pengutronix.de>
References: <20230327073354.1003134-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

Add support for CAN transceivers described as PHYs.

While simple CAN transceivers can do without, this is needed for CAN
transceivers like NXP TJR1443 that need a configuration step (like
pulling standby or enable lines), and/or impose a bitrate limit.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/all/1ce907572ac1d4e1733fa6ea7712250f2229cfcb.1679414936.git.geert+renesas@glider.be
[mkl: squash error message update from patch 2]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/rcar/rcar_canfd.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index ef4e1b9a9e1e..d8fbc3fca475 100644
--- a/drivers/net/can/rcar/rcar_canfd.c
+++ b/drivers/net/can/rcar/rcar_canfd.c
@@ -35,6 +35,7 @@
 #include <linux/netdevice.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/phy/phy.h>
 #include <linux/platform_device.h>
 #include <linux/reset.h>
 #include <linux/types.h>
@@ -530,6 +531,7 @@ struct rcar_canfd_channel {
 	struct net_device *ndev;
 	struct rcar_canfd_global *gpriv;	/* Controller reference */
 	void __iomem *base;			/* Register base address */
+	struct phy *transceiver;		/* Optional transceiver */
 	struct napi_struct napi;
 	u32 tx_head;				/* Incremented on xmit */
 	u32 tx_tail;				/* Incremented on xmit done */
@@ -1413,11 +1415,17 @@ static int rcar_canfd_open(struct net_device *ndev)
 	struct rcar_canfd_global *gpriv = priv->gpriv;
 	int err;
 
+	err = phy_power_on(priv->transceiver);
+	if (err) {
+		netdev_err(ndev, "failed to power on PHY: %pe\n", ERR_PTR(err));
+		return err;
+	}
+
 	/* Peripheral clock is already enabled in probe */
 	err = clk_prepare_enable(gpriv->can_clk);
 	if (err) {
 		netdev_err(ndev, "failed to enable CAN clock, error %d\n", err);
-		goto out_clock;
+		goto out_phy;
 	}
 
 	err = open_candev(ndev);
@@ -1437,7 +1445,8 @@ static int rcar_canfd_open(struct net_device *ndev)
 	close_candev(ndev);
 out_can_clock:
 	clk_disable_unprepare(gpriv->can_clk);
-out_clock:
+out_phy:
+	phy_power_off(priv->transceiver);
 	return err;
 }
 
@@ -1480,6 +1489,7 @@ static int rcar_canfd_close(struct net_device *ndev)
 	napi_disable(&priv->napi);
 	clk_disable_unprepare(gpriv->can_clk);
 	close_candev(ndev);
+	phy_power_off(priv->transceiver);
 	return 0;
 }
 
@@ -1711,7 +1721,7 @@ static const struct ethtool_ops rcar_canfd_ethtool_ops = {
 };
 
 static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
-				    u32 fcan_freq)
+				    u32 fcan_freq, struct phy *transceiver)
 {
 	const struct rcar_canfd_hw_info *info = gpriv->info;
 	struct platform_device *pdev = gpriv->pdev;
@@ -1732,8 +1742,11 @@ static int rcar_canfd_channel_probe(struct rcar_canfd_global *gpriv, u32 ch,
 	ndev->flags |= IFF_ECHO;
 	priv->ndev = ndev;
 	priv->base = gpriv->base;
+	priv->transceiver = transceiver;
 	priv->channel = ch;
 	priv->gpriv = gpriv;
+	if (transceiver)
+		priv->can.bitrate_max = transceiver->attrs.max_link_rate;
 	priv->can.clock.freq = fcan_freq;
 	dev_info(dev, "can_clk rate is %u\n", priv->can.clock.freq);
 
@@ -1836,6 +1849,7 @@ static void rcar_canfd_channel_remove(struct rcar_canfd_global *gpriv, u32 ch)
 
 static int rcar_canfd_probe(struct platform_device *pdev)
 {
+	struct phy *transceivers[RCANFD_NUM_CHANNELS] = { 0, };
 	const struct rcar_canfd_hw_info *info;
 	struct device *dev = &pdev->dev;
 	void __iomem *addr;
@@ -1857,9 +1871,14 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	for (i = 0; i < info->max_channels; ++i) {
 		name[7] = '0' + i;
 		of_child = of_get_child_by_name(dev->of_node, name);
-		if (of_child && of_device_is_available(of_child))
+		if (of_child && of_device_is_available(of_child)) {
 			channels_mask |= BIT(i);
+			transceivers[i] = devm_of_phy_optional_get(dev,
+							of_child, NULL);
+		}
 		of_node_put(of_child);
+		if (IS_ERR(transceivers[i]))
+			return PTR_ERR(transceivers[i]);
 	}
 
 	if (info->shared_global_irqs) {
@@ -2035,7 +2054,8 @@ static int rcar_canfd_probe(struct platform_device *pdev)
 	}
 
 	for_each_set_bit(ch, &gpriv->channels_mask, info->max_channels) {
-		err = rcar_canfd_channel_probe(gpriv, ch, fcan_freq);
+		err = rcar_canfd_channel_probe(gpriv, ch, fcan_freq,
+					       transceivers[ch]);
 		if (err)
 			goto fail_channel;
 	}

base-commit: 323fe43cf9aef79159ba8937218a3f076bf505af
-- 
2.39.2



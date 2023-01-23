Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D176678593
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 19:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232942AbjAWS5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 13:57:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232678AbjAWS4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 13:56:36 -0500
Received: from albert.telenet-ops.be (albert.telenet-ops.be [IPv6:2a02:1800:110:4::f00:1a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FBF732E62
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 10:56:29 -0800 (PST)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed50:6083:1fd7:ba05:ea8d])
        by albert.telenet-ops.be with bizsmtp
        id CJwJ2900g4604Ck06JwJts; Mon, 23 Jan 2023 19:56:21 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtp (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1pK1zG-0076Kq-Nt;
        Mon, 23 Jan 2023 19:56:18 +0100
Received: from geert by rox.of.borg with local (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1pK1zO-00Ekhs-L8;
        Mon, 23 Jan 2023 19:56:18 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        Ulrich Hecht <uli+renesas@fpond.eu>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 12/12] can: rcar_canfd: Add transceiver support
Date:   Mon, 23 Jan 2023 19:56:14 +0100
Message-Id: <e825b50a843ffe40e33f34e4d858c07c1b2ff259.1674499048.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1674499048.git.geert+renesas@glider.be>
References: <cover.1674499048.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for CAN transceivers described as PHYs.

While simple CAN transceivers can do without, this is needed for CAN
transceivers like NXP TJR1443 that need a configuration step (like
pulling standby or enable lines), and/or impose a bitrate limit.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
This depends on "[PATCH 1/7] phy: Add devm_of_phy_optional_get() helper".
https://lore.kernel.org/all/f53a1bcca637ceeafb04ce3540a605532d3bc34a.1674036164.git.geert+renesas@glider.be
---
 drivers/net/can/rcar/rcar_canfd.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_canfd.c b/drivers/net/can/rcar/rcar_canfd.c
index ef4e1b9a9e1ee280..6df9a259e5e4f92c 100644
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
+		netdev_err(ndev, "failed to power on PHY, error %d\n", err);
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
-- 
2.34.1


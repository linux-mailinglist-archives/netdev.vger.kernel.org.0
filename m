Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6D867FD6B
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 17:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732033AbfHBPWT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 11:22:19 -0400
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:60521 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731684AbfHBPWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 11:22:19 -0400
X-Originating-IP: 86.250.200.211
Received: from bootlin.com (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 41557FF806;
        Fri,  2 Aug 2019 15:22:16 +0000 (UTC)
Date:   Fri, 2 Aug 2019 17:22:26 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Matt Pelland <mpelland@starry.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        antoine.tenart@bootlin.com
Subject: Re: [PATCH 2/2] net: mvpp2: support multiple comphy lanes
Message-ID: <20190802172226.307fd56b@bootlin.com>
In-Reply-To: <20190801204523.26454-3-mpelland@starry.com>
References: <20190801204523.26454-1-mpelland@starry.com>
        <20190801204523.26454-3-mpelland@starry.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Matt,

On Thu,  1 Aug 2019 16:45:23 -0400
Matt Pelland <mpelland@starry.com> wrote:

>mvpp 2.2 supports RXAUI which requires a pair of serdes lanes instead of
>the usual single lane required by other interface modes. This patch
>expands the number of lanes that can be associated to a port so that
>both lanes are correctly configured at the appropriate times when RXAUI
>is in use.

Thanks for the patch, it's nice to see RXAUI support moving forward.

I'll give your patches a test on my setup, although I never really got
something stable, it might simply be due to the particular hardware I
have access to.

I do have some comments below :

>Signed-off-by: Matt Pelland <mpelland@starry.com>
>---
> drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |  7 +-
> .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 66 +++++++++++++------
> 2 files changed, 53 insertions(+), 20 deletions(-)
>
>diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
>index 256e7c796631..9ae2b3d9d0c7 100644
>--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
>+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
>@@ -655,6 +655,11 @@
> #define MVPP2_F_LOOPBACK		BIT(0)
> #define MVPP2_F_DT_COMPAT		BIT(1)
> 
>+/* MVPP22 supports RXAUI which requires two comphy lanes, all other modes
>+ * require one.
>+ */
>+#define MVPP22_MAX_COMPHYS		2

This driver is "supposed" to support XAUI too, at least it appears in
the list of modes we handle. XAUI uses 4 lanes, maybe we could bump the
max number of lanes to 4.

> /* Marvell tag types */
> enum mvpp2_tag_type {
> 	MVPP2_TAG_TYPE_NONE = 0,
>@@ -935,7 +940,7 @@ struct mvpp2_port {
> 	phy_interface_t phy_interface;
> 	struct phylink *phylink;
> 	struct phylink_config phylink_config;
>-	struct phy *comphy;
>+	struct phy *comphys[MVPP22_MAX_COMPHYS];
> 
> 	struct mvpp2_bm_pool *pool_long;
> 	struct mvpp2_bm_pool *pool_short;
>diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
>index 8b633af4a684..97dfe2e71b03 100644
>--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
>+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
>@@ -1186,17 +1186,40 @@ static void mvpp22_gop_setup_irq(struct mvpp2_port *port)
>  */
> static int mvpp22_comphy_init(struct mvpp2_port *port)
> {
>-	int ret;
>+	int i, ret;
> 
>-	if (!port->comphy)
>-		return 0;
>+	for (i = 0; i < ARRAY_SIZE(port->comphys); i++) {
>+		if (!port->comphys[i])
>+			return 0;
> 
>-	ret = phy_set_mode_ext(port->comphy, PHY_MODE_ETHERNET,
>-			       port->phy_interface);
>-	if (ret)
>-		return ret;
>+		ret = phy_set_mode_ext(port->comphys[i],
>+				       PHY_MODE_ETHERNET,
>+				       port->phy_interface);
>+		if (ret)
>+			return ret;
> 
>-	return phy_power_on(port->comphy);
>+		ret = phy_power_on(port->comphys[i]);
>+		if (ret)
>+			return ret;
>+	}
>+
>+	return 0;
>+}

It could be good to add some sanity check, to make sure we do have 2
comphy lanes available when configuring RXAUI mode (and 4 for XAUI).

>+static int mvpp22_comphy_deinit(struct mvpp2_port *port)
>+{
>+	int i, ret;
>+
>+	for (i = 0; i < ARRAY_SIZE(port->comphys); i++) {
>+		if (!port->comphys[i])
>+			return 0;
>+
>+		ret = phy_power_off(port->comphys[i]);
>+		if (ret)
>+			return ret;
>+	}
>+
>+	return 0;
> }
> 
> static void mvpp2_port_enable(struct mvpp2_port *port)
>@@ -3375,7 +3398,9 @@ static void mvpp2_stop_dev(struct mvpp2_port *port)
> 
> 	if (port->phylink)
> 		phylink_stop(port->phylink);
>-	phy_power_off(port->comphy);
>+
>+	if (port->priv->hw_version == MVPP22)
>+		mvpp22_comphy_deinit(port);
> }
> 
> static int mvpp2_check_ringparam_valid(struct net_device *dev,
>@@ -4947,7 +4972,7 @@ static void mvpp2_mac_config(struct phylink_config *config, unsigned int mode,
> 		port->phy_interface = state->interface;
> 
> 		/* Reconfigure the serdes lanes */
>-		phy_power_off(port->comphy);
>+		mvpp22_comphy_deinit(port);
> 		mvpp22_mode_reconfigure(port);
> 	}
> 
>@@ -5038,7 +5063,6 @@ static int mvpp2_port_probe(struct platform_device *pdev,
> 			    struct fwnode_handle *port_fwnode,
> 			    struct mvpp2 *priv)
> {
>-	struct phy *comphy = NULL;
> 	struct mvpp2_port *port;
> 	struct mvpp2_port_pcpu *port_pcpu;
> 	struct device_node *port_node = to_of_node(port_fwnode);
>@@ -5085,14 +5109,20 @@ static int mvpp2_port_probe(struct platform_device *pdev,
> 		goto err_free_netdev;
> 	}
> 
>+	port = netdev_priv(dev);
>+
> 	if (port_node) {
>-		comphy = devm_of_phy_get(&pdev->dev, port_node, NULL);
>-		if (IS_ERR(comphy)) {
>-			if (PTR_ERR(comphy) == -EPROBE_DEFER) {
>-				err = -EPROBE_DEFER;
>-				goto err_free_netdev;
>+		for (i = 0; i < ARRAY_SIZE(port->comphys); i++) {
>+			port->comphys[i] = devm_of_phy_get_by_index(&pdev->dev,
>+								    port_node,
>+								    i);
>+			if (IS_ERR(port->comphys[i])) {
>+				err = PTR_ERR(port->comphys[i]);
>+				port->comphys[i] = NULL;
>+				if (err == -EPROBE_DEFER)
>+					goto err_free_netdev;
>+				err = 0;
> 			}
>-			comphy = NULL;
> 		}
> 	}
> 
>@@ -5107,7 +5137,6 @@ static int mvpp2_port_probe(struct platform_device *pdev,
> 	dev->netdev_ops = &mvpp2_netdev_ops;
> 	dev->ethtool_ops = &mvpp2_eth_tool_ops;
> 
>-	port = netdev_priv(dev);
> 	port->dev = dev;
> 	port->fwnode = port_fwnode;
> 	port->has_phy = !!of_find_property(port_node, "phy", NULL);
>@@ -5144,7 +5173,6 @@ static int mvpp2_port_probe(struct platform_device *pdev,
> 
> 	port->of_node = port_node;
> 	port->phy_interface = phy_mode;
>-	port->comphy = comphy;
> 
> 	if (priv->hw_version == MVPP21) {
> 		port->base = devm_platform_ioremap_resource(pdev, 2 + id);



-- 
Maxime Chevallier, Bootlin
Embedded Linux and kernel engineering
https://bootlin.com

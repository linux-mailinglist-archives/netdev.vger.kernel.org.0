Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26B116B0A5F
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 15:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232076AbjCHOCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 09:02:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231788AbjCHOBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 09:01:30 -0500
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38106567B7;
        Wed,  8 Mar 2023 06:00:38 -0800 (PST)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id A7E7F1C001B;
        Wed,  8 Mar 2023 14:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1678284037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZkezqfSVIqRLfpbJoE+hx/1UCsqNMqn17crrczW4LZM=;
        b=ezkxuiPBuWOkKdMV246ocix4cgUAQsSe0VCnFpEBVOcTPDD+D5RBWSCiKA9c2jhFmR0CuQ
        4lIOtbRhPRDjgQcBQWY1RlZLp4KQe3coboAQPbYr7OPYSmP0eXtkLotqFFXdXCtPTJ11Gq
        g638NyRU1N0ZB+hQf6WqYlX7WWjywhNQwErAIkU8LbWIwWAy1JX5NHTAMLF4CgDbP7DcG3
        9zl/cDeZ8psiVWJgcBPbAxXebPj8XpZFxtwQw1tkb8MGDJp2ldm6cL/OFiIOqoERMMCSDm
        BOacQQiWrmHA8rJlTUQ9Img7ycltXvxSDAjn2+wBfaLRBrbbMkz6IY07RbmLSA==
From:   =?UTF-8?q?K=C3=B6ry=20Maincent?= <kory.maincent@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-omap@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Kory Maincent <kory.maincent@bootlin.com>,
        thomas.petazzoni@bootlin.com, Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Jie Wang <wangjie125@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Marco Bonelli <marco@mebeim.net>,
        Maxim Korotkov <korotkov.maxim.s@gmail.com>
Subject: [PATCH v3 4/5] net: fix up drivers WRT phy time stamping
Date:   Wed,  8 Mar 2023 14:59:28 +0100
Message-Id: <20230308135936.761794-5-kory.maincent@bootlin.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230308135936.761794-1-kory.maincent@bootlin.com>
References: <20230308135936.761794-1-kory.maincent@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Richard Cochran <richardcochran@gmail.com>

For "git bisect" correctness, this patch should be squashed in to the
previous one, but it is broken out here for the purpose of review.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 23 +++++++++-----------
 drivers/net/ethernet/mscc/ocelot_net.c    | 21 +++++++++---------
 drivers/net/ethernet/ti/cpsw_priv.c       | 12 +++++------
 drivers/net/ethernet/ti/netcp_ethss.c     | 26 +++++------------------
 4 files changed, 31 insertions(+), 51 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index f250b0df27fb..b98119551e6a 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3058,22 +3058,19 @@ static int fec_enet_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd)
 	if (!netif_running(ndev))
 		return -EINVAL;
 
+	switch (cmd) {
+	case SIOCSHWTSTAMP:
+		return fep->bufdesc_ex ? fec_ptp_set(ndev, rq) :
+		-EOPNOTSUPP;
+
+	case SIOCGHWTSTAMP:
+		return fep->bufdesc_ex ? fec_ptp_get(ndev, rq) :
+		-EOPNOTSUPP;
+	}
+
 	if (!phydev)
 		return -ENODEV;
 
-	if (fep->bufdesc_ex) {
-		bool use_fec_hwts = !phy_has_hwtstamp(phydev);
-
-		if (cmd == SIOCSHWTSTAMP) {
-			if (use_fec_hwts)
-				return fec_ptp_set(ndev, rq);
-			fec_ptp_disable_hwts(ndev);
-		} else if (cmd == SIOCGHWTSTAMP) {
-			if (use_fec_hwts)
-				return fec_ptp_get(ndev, rq);
-		}
-	}
-
 	return phy_mii_ioctl(phydev, rq, cmd);
 }
 
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 50858cc10fef..8c37db28a93d 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -882,18 +882,19 @@ static int ocelot_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	struct ocelot *ocelot = priv->port.ocelot;
 	int port = priv->port.index;
 
-	/* If the attached PHY device isn't capable of timestamping operations,
-	 * use our own (when possible).
-	 */
-	if (!phy_has_hwtstamp(dev->phydev) && ocelot->ptp) {
-		switch (cmd) {
-		case SIOCSHWTSTAMP:
-			return ocelot_hwstamp_set(ocelot, port, ifr);
-		case SIOCGHWTSTAMP:
-			return ocelot_hwstamp_get(ocelot, port, ifr);
-		}
+	switch (cmd) {
+	case SIOCSHWTSTAMP:
+		return ocelot->ptp ? ocelot_hwstamp_set(ocelot, port, ifr) :
+		-EOPNOTSUPP;
+
+	case SIOCGHWTSTAMP:
+		return ocelot->ptp ? ocelot_hwstamp_get(ocelot, port, ifr) :
+		-EOPNOTSUPP;
 	}
 
+	if (!dev->phydev)
+		return -ENODEV;
+
 	return phy_mii_ioctl(dev->phydev, ifr, cmd);
 }
 
diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
index 758295c898ac..b15b83bb269a 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -714,13 +714,11 @@ int cpsw_ndo_ioctl(struct net_device *dev, struct ifreq *req, int cmd)
 
 	phy = cpsw->slaves[slave_no].phy;
 
-	if (!phy_has_hwtstamp(phy)) {
-		switch (cmd) {
-		case SIOCSHWTSTAMP:
-			return cpsw_hwtstamp_set(dev, req);
-		case SIOCGHWTSTAMP:
-			return cpsw_hwtstamp_get(dev, req);
-		}
+	switch (cmd) {
+	case SIOCSHWTSTAMP:
+		return cpsw_hwtstamp_set(dev, req);
+	case SIOCGHWTSTAMP:
+		return cpsw_hwtstamp_get(dev, req);
 	}
 
 	if (phy)
diff --git a/drivers/net/ethernet/ti/netcp_ethss.c b/drivers/net/ethernet/ti/netcp_ethss.c
index 751fb0bc65c5..36ce80f8bd6b 100644
--- a/drivers/net/ethernet/ti/netcp_ethss.c
+++ b/drivers/net/ethernet/ti/netcp_ethss.c
@@ -2557,15 +2557,6 @@ static int gbe_txtstamp_mark_pkt(struct gbe_intf *gbe_intf,
 	    !gbe_dev->tx_ts_enabled)
 		return 0;
 
-	/* If phy has the txtstamp api, assume it will do it.
-	 * We mark it here because skb_tx_timestamp() is called
-	 * after all the txhooks are called.
-	 */
-	if (phy_has_txtstamp(phydev)) {
-		skb_shinfo(p_info->skb)->tx_flags |= SKBTX_IN_PROGRESS;
-		return 0;
-	}
-
 	if (gbe_need_txtstamp(gbe_intf, p_info)) {
 		p_info->txtstamp = gbe_txtstamp;
 		p_info->ts_context = (void *)gbe_intf;
@@ -2583,11 +2574,6 @@ static int gbe_rxtstamp(struct gbe_intf *gbe_intf, struct netcp_packet *p_info)
 	if (p_info->rxtstamp_complete)
 		return 0;
 
-	if (phy_has_rxtstamp(phydev)) {
-		p_info->rxtstamp_complete = true;
-		return 0;
-	}
-
 	if (gbe_dev->rx_ts_enabled)
 		cpts_rx_timestamp(gbe_dev->cpts, p_info->skb);
 
@@ -2821,13 +2807,11 @@ static int gbe_ioctl(void *intf_priv, struct ifreq *req, int cmd)
 	struct gbe_intf *gbe_intf = intf_priv;
 	struct phy_device *phy = gbe_intf->slave->phy;
 
-	if (!phy_has_hwtstamp(phy)) {
-		switch (cmd) {
-		case SIOCGHWTSTAMP:
-			return gbe_hwtstamp_get(gbe_intf, req);
-		case SIOCSHWTSTAMP:
-			return gbe_hwtstamp_set(gbe_intf, req);
-		}
+	switch (cmd) {
+	case SIOCGHWTSTAMP:
+		return gbe_hwtstamp_get(gbe_intf, req);
+	case SIOCSHWTSTAMP:
+		return gbe_hwtstamp_set(gbe_intf, req);
 	}
 
 	if (phy)
-- 
2.25.1


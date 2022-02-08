Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAFD4ADC19
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 16:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379534AbiBHPMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 10:12:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379533AbiBHPML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 10:12:11 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30662C0613C9
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 07:12:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=jP/psZSnRyjKy8Z5ZE+HEdFZtLnfntK3y5ORMXKOA34=; b=tlISSOWE2gK8qHuyH9eEVo3kEk
        QGuzJqKQ+mADGBT2fFbGRkdUxUNX0Fx6+4GnavXiSjXjDEnpZhQme/nd8sNKcZIVAdYkelieDooqB
        fi91FcoA5GdnA4HfNB9BdvnLr85ynxEYhvY/8OPKLl5rIf1lIOHP0pup0RNyAG0Y4ShCmRGqrFz8o
        ol2rN/7yGT1HEWi+ymGIQuXL7Sb/RD8t5W0uEVROMZeNEKfsEUUXfOsrHIkcDrB9YpTxwZrwMTpFC
        KG2Kqk9+2096YnrWn6BlrtE2CiLKt+ywnE4CxR1xx4fnRxAMFiiqkjoPAq68DDr6AxHdfsCFjBYoP
        mCMdvmmA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:38408 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nHSA2-0003Ik-OP; Tue, 08 Feb 2022 15:12:06 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nHSA2-0070ZT-4p; Tue, 08 Feb 2022 15:12:06 +0000
In-Reply-To: <YgKIIq2baq4yERS5@shell.armlinux.org.uk>
References: <YgKIIq2baq4yERS5@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH CFT net-next 4/6] net: dsa: qca8k: convert to use phylink_pcs
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nHSA2-0070ZT-4p@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 08 Feb 2022 15:12:06 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the qca8k driver to use the phylink_pcs support to talk to the
SGMII PCS.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/qca8k.c | 85 +++++++++++++++++++++++++++++++++++------
 drivers/net/dsa/qca8k.h |  8 ++++
 2 files changed, 81 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index fb052d6eae52..230411181379 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1673,6 +1673,34 @@ qca8k_mac_config_setup_internal_delay(struct qca8k_priv *priv, int cpu_port_inde
 			cpu_port_index == QCA8K_CPU_PORT0 ? 0 : 6);
 }
 
+static struct phylink_pcs *
+qca8k_phylink_mac_select_pcs(struct dsa_switch *ds, int port,
+			     phy_interface_t interface)
+{
+	struct qca8k_priv *priv = ds->priv;
+	struct phylink_pcs *pcs = NULL;
+
+	switch (interface) {
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_1000BASEX:
+		switch (port) {
+		case 0:
+			pcs = &priv->pcs_port_0.pcs;
+			break;
+
+		case 6:
+			pcs = &priv->pcs_port_6.pcs;
+			break;
+		}
+		break;
+
+	default:
+		break;
+	}
+
+	return pcs;
+}
+
 static void
 qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 			 const struct phylink_link_state *state)
@@ -1902,17 +1930,24 @@ qca8k_phylink_mac_link_up(struct dsa_switch *ds, int port, unsigned int mode,
 	qca8k_write(priv, QCA8K_REG_PORT_STATUS(port), reg);
 }
 
-static int
-qca8k_phylink_mac_link_state(struct dsa_switch *ds, int port,
-			     struct phylink_link_state *state)
+static struct qca8k_pcs *pcs_to_qca8k_pcs(struct phylink_pcs *pcs)
 {
-	struct qca8k_priv *priv = ds->priv;
+	return container_of(pcs, struct qca8k_pcs, pcs);
+}
+
+static void qca8k_pcs_get_state(struct phylink_pcs *pcs,
+				struct phylink_link_state *state)
+{
+	struct qca8k_priv *priv = pcs_to_qca8k_pcs(pcs)->priv;
+	int port = pcs_to_qca8k_pcs(pcs)->port;
 	u32 reg;
 	int ret;
 
 	ret = qca8k_read(priv, QCA8K_REG_PORT_STATUS(port), &reg);
-	if (ret < 0)
-		return ret;
+	if (ret < 0) {
+		state->link = false;
+		return;
+	}
 
 	state->link = !!(reg & QCA8K_PORT_STATUS_LINK_UP);
 	state->an_complete = state->link;
@@ -1935,13 +1970,39 @@ qca8k_phylink_mac_link_state(struct dsa_switch *ds, int port,
 		break;
 	}
 
-	state->pause = MLO_PAUSE_NONE;
 	if (reg & QCA8K_PORT_STATUS_RXFLOW)
 		state->pause |= MLO_PAUSE_RX;
 	if (reg & QCA8K_PORT_STATUS_TXFLOW)
 		state->pause |= MLO_PAUSE_TX;
+}
 
-	return 1;
+static int qca8k_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
+			    phy_interface_t interface,
+			    const unsigned long *advertising,
+			    bool permit_pause_to_mac)
+{
+	return 0;
+}
+
+static void qca8k_pcs_an_restart(struct phylink_pcs *pcs)
+{
+}
+
+static const struct phylink_pcs_ops qca8k_pcs_ops = {
+	.pcs_get_state = qca8k_pcs_get_state,
+	.pcs_config = qca8k_pcs_config,
+	.pcs_an_restart = qca8k_pcs_an_restart,
+};
+
+static void qca8k_setup_pcs(struct qca8k_priv *priv, struct qca8k_pcs *qpcs,
+			    int port)
+{
+	qpcs->pcs.ops = &qca8k_pcs_ops;
+
+	/* We don't have interrupts for link changes, so we need to poll */
+	qpcs->pcs.poll = true;
+	qpcs->priv = priv;
+	qpcs->port = port;
 }
 
 static void
@@ -2806,6 +2867,9 @@ qca8k_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
+	qca8k_setup_pcs(priv, &priv->pcs_port_0, 0);
+	qca8k_setup_pcs(priv, &priv->pcs_port_6, 6);
+
 	/* Make sure MAC06 is disabled */
 	ret = regmap_clear_bits(priv->regmap, QCA8K_REG_PORT0_PAD_CTRL,
 				QCA8K_PORT0_PAD_MAC06_EXCHANGE_EN);
@@ -2977,9 +3041,6 @@ qca8k_setup(struct dsa_switch *ds)
 	/* Flush the FDB table */
 	qca8k_fdb_flush(priv);
 
-	/* We don't have interrupts for link changes, so we need to poll */
-	ds->pcs_poll = true;
-
 	/* Set min a max ageing value supported */
 	ds->ageing_time_min = 7000;
 	ds->ageing_time_max = 458745000;
@@ -3018,7 +3079,7 @@ static const struct dsa_switch_ops qca8k_switch_ops = {
 	.port_vlan_add		= qca8k_port_vlan_add,
 	.port_vlan_del		= qca8k_port_vlan_del,
 	.phylink_get_caps	= qca8k_phylink_get_caps,
-	.phylink_mac_link_state	= qca8k_phylink_mac_link_state,
+	.phylink_mac_select_pcs	= qca8k_phylink_mac_select_pcs,
 	.phylink_mac_config	= qca8k_phylink_mac_config,
 	.phylink_mac_link_down	= qca8k_phylink_mac_link_down,
 	.phylink_mac_link_up	= qca8k_phylink_mac_link_up,
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index c3d3c2269b1d..f375627174c8 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -376,6 +376,12 @@ struct qca8k_mdio_cache {
 	u16 hi;
 };
 
+struct qca8k_pcs {
+	struct phylink_pcs pcs;
+	struct qca8k_priv *priv;
+	int port;
+};
+
 struct qca8k_priv {
 	u8 switch_id;
 	u8 switch_revision;
@@ -397,6 +403,8 @@ struct qca8k_priv {
 	struct qca8k_mgmt_eth_data mgmt_eth_data;
 	struct qca8k_mib_eth_data mib_eth_data;
 	struct qca8k_mdio_cache mdio_cache;
+	struct qca8k_pcs pcs_port_0;
+	struct qca8k_pcs pcs_port_6;
 };
 
 struct qca8k_mib_desc {
-- 
2.30.2


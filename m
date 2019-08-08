Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF7786D9E
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 01:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404450AbfHHXGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 19:06:32 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:43433 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbfHHXGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 19:06:32 -0400
Received: by mail-qt1-f194.google.com with SMTP id w17so13404015qto.10
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 16:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=starry.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oUYeQ2M5iP7ALktOb7yhSxrEGZueqoXs6BdEzkwxgBw=;
        b=iKzCHyp34usjipyOs4YD45fAoGdabpk63rFpLAJDromR/vPbM/kcOaQoqh5NEg/ZIE
         +Zi0aVJjKisLwyJbmrprz+jIuisQgsNtpzeUarGNofyhC+4E9/RUeB5j03Dxt0rit1wU
         TkUifXObkd+og1R9WByFPWgxWOopvUTyhvSEI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oUYeQ2M5iP7ALktOb7yhSxrEGZueqoXs6BdEzkwxgBw=;
        b=jWCVWz1/hr88xSkAT4P7apBxrgWjHMz7h1VvnKh2wg+lkQZBtB6ahhRsZGlA93RDVB
         WwujmUsJegm1q0ZPBb6mWtnwTDeYs+6PxxMvlf7jKsNww1aDnVgOWqxs3HfREOha34mg
         c/6us3+E8SG83llyVQtTw5etubWKulabPE1SOtOgTQF85Se7OrIU72izkrY36X3U+sRv
         yFjArmHrrODrba1e+UsVPDKHDckxSdR+P2wSaWnBp1PLa7T8ySWI6N4FaOi2aAqD2etE
         VJdQLpk3QQFkHg9ExF/Dg6ZRxrd33gjHSK4qmsmaeRxJpM5eImk+GhqTFoVVulDvwAE6
         p+hQ==
X-Gm-Message-State: APjAAAVTxQdgbJXgN0NTCKYnu+YeWj5YlzZScNk2yioqWsqqBI+N7WWf
        WhnSyyU3FJ4+x75POiavUB7E0ZNfpqWCcA==
X-Google-Smtp-Source: APXvYqy4G4jGosC6WXAfXG3xGgBq00izNbRVynMdKOAty7tvVCSfiX5aiX9kLH1hmsPVzgiLPrRfJg==
X-Received: by 2002:aed:3ac5:: with SMTP id o63mr15051475qte.309.1565305590937;
        Thu, 08 Aug 2019 16:06:30 -0700 (PDT)
Received: from localhost.localdomain (205-201-16-55.starry-inc.net. [205.201.16.55])
        by smtp.gmail.com with ESMTPSA id u1sm51299554qth.21.2019.08.08.16.06.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 16:06:30 -0700 (PDT)
From:   Matt Pelland <mpelland@starry.com>
To:     netdev@vger.kernel.org
Cc:     Matt Pelland <mpelland@starry.com>, davem@davemloft.com,
        maxime.chevallier@bootlin.com, antoine.tenart@bootlin.com
Subject: [PATCH v2 net-next 2/2] net: mvpp2: support multiple comphy lanes
Date:   Thu,  8 Aug 2019 19:06:06 -0400
Message-Id: <20190808230606.7900-3-mpelland@starry.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190808230606.7900-1-mpelland@starry.com>
References: <20190808230606.7900-1-mpelland@starry.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mvpp 2.2 supports RXAUI, which requires two serdes lanes, and XAUI which
requires four serdes lanes instead of the usual single lane required by other
interface modes. This patch expands the number of lanes that can be associated
to a port so that all relevant serdes lanes are correctly configured at the
appropriate times when either RXAUI or XAUI is in use.

Signed-off-by: Matt Pelland <mpelland@starry.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |  7 +-
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 97 ++++++++++++++-----
 2 files changed, 77 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index 256e7c796631..d74f458ca099 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -655,6 +655,11 @@
 #define MVPP2_F_LOOPBACK		BIT(0)
 #define MVPP2_F_DT_COMPAT		BIT(1)
 
+/* MVPP22 supports RXAUI which requires two comphy lanes and XAUI which
+ * requires four comphy lanes. All other modes require one.
+ */
+#define MVPP22_MAX_COMPHYS		4
+
 /* Marvell tag types */
 enum mvpp2_tag_type {
 	MVPP2_TAG_TYPE_NONE = 0,
@@ -935,7 +940,7 @@ struct mvpp2_port {
 	phy_interface_t phy_interface;
 	struct phylink *phylink;
 	struct phylink_config phylink_config;
-	struct phy *comphy;
+	struct phy *comphys[MVPP22_MAX_COMPHYS];
 
 	struct mvpp2_bm_pool *pool_long;
 	struct mvpp2_bm_pool *pool_short;
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 1a5037a398fc..100972703f60 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1200,17 +1200,40 @@ static void mvpp22_gop_setup_irq(struct mvpp2_port *port)
  */
 static int mvpp22_comphy_init(struct mvpp2_port *port)
 {
-	int ret;
+	int i, ret;
 
-	if (!port->comphy)
-		return 0;
+	for (i = 0; i < ARRAY_SIZE(port->comphys); i++) {
+		if (!port->comphys[i])
+			return 0;
 
-	ret = phy_set_mode_ext(port->comphy, PHY_MODE_ETHERNET,
-			       port->phy_interface);
-	if (ret)
-		return ret;
+		ret = phy_set_mode_ext(port->comphys[i],
+				       PHY_MODE_ETHERNET,
+				       port->phy_interface);
+		if (ret)
+			return ret;
+
+		ret = phy_power_on(port->comphys[i]);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int mvpp22_comphy_deinit(struct mvpp2_port *port)
+{
+	int i, ret;
+
+	for (i = 0; i < ARRAY_SIZE(port->comphys); i++) {
+		if (!port->comphys[i])
+			return 0;
+
+		ret = phy_power_off(port->comphys[i]);
+		if (ret)
+			return ret;
+	}
 
-	return phy_power_on(port->comphy);
+	return 0;
 }
 
 static void mvpp2_port_enable(struct mvpp2_port *port)
@@ -3389,7 +3412,9 @@ static void mvpp2_stop_dev(struct mvpp2_port *port)
 
 	if (port->phylink)
 		phylink_stop(port->phylink);
-	phy_power_off(port->comphy);
+
+	if (port->priv->hw_version == MVPP22)
+		mvpp22_comphy_deinit(port);
 }
 
 static int mvpp2_check_ringparam_valid(struct net_device *dev,
@@ -4946,7 +4971,7 @@ static void mvpp2_mac_config(struct phylink_config *config, unsigned int mode,
 		port->phy_interface = state->interface;
 
 		/* Reconfigure the serdes lanes */
-		phy_power_off(port->comphy);
+		mvpp22_comphy_deinit(port);
 		mvpp22_mode_reconfigure(port);
 	}
 
@@ -5037,20 +5062,18 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 			    struct fwnode_handle *port_fwnode,
 			    struct mvpp2 *priv)
 {
-	struct phy *comphy = NULL;
-	struct mvpp2_port *port;
-	struct mvpp2_port_pcpu *port_pcpu;
+	unsigned int ntxqs, nrxqs, ncomphys, nrequired_comphys, thread;
 	struct device_node *port_node = to_of_node(port_fwnode);
+	struct mvpp2_port_pcpu *port_pcpu;
 	netdev_features_t features;
-	struct net_device *dev;
 	struct phylink *phylink;
-	char *mac_from = "";
-	unsigned int ntxqs, nrxqs, thread;
+	struct mvpp2_port *port;
 	unsigned long flags = 0;
+	struct net_device *dev;
+	int err, i, phy_mode;
+	char *mac_from = "";
 	bool has_tx_irqs;
 	u32 id;
-	int phy_mode;
-	int err, i;
 
 	has_tx_irqs = mvpp2_port_has_irqs(priv, port_node, &flags);
 	if (!has_tx_irqs && queue_mode == MVPP2_QDIST_MULTI_MODE) {
@@ -5084,14 +5107,38 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 		goto err_free_netdev;
 	}
 
+	port = netdev_priv(dev);
+
 	if (port_node) {
-		comphy = devm_of_phy_get(&pdev->dev, port_node, NULL);
-		if (IS_ERR(comphy)) {
-			if (PTR_ERR(comphy) == -EPROBE_DEFER) {
-				err = -EPROBE_DEFER;
-				goto err_free_netdev;
+		for (i = 0, ncomphys = 0; i < ARRAY_SIZE(port->comphys); i++) {
+			port->comphys[i] = devm_of_phy_get_by_index(&pdev->dev,
+								    port_node,
+								    i);
+			if (IS_ERR(port->comphys[i])) {
+				err = PTR_ERR(port->comphys[i]);
+				port->comphys[i] = NULL;
+				if (err == -EPROBE_DEFER)
+					goto err_free_netdev;
+				err = 0;
+				break;
 			}
-			comphy = NULL;
+
+			++ncomphys;
+		}
+
+		if (phy_mode == PHY_INTERFACE_MODE_XAUI)
+			nrequired_comphys = 4;
+		else if (phy_mode == PHY_INTERFACE_MODE_RXAUI)
+			nrequired_comphys = 2;
+		else
+			nrequired_comphys = 1;
+
+		if (ncomphys < nrequired_comphys) {
+			dev_err(&pdev->dev,
+				"not enough comphys to support %s\n",
+				phy_modes(phy_mode));
+			err = -EINVAL;
+			goto err_free_netdev;
 		}
 	}
 
@@ -5106,7 +5153,6 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 	dev->netdev_ops = &mvpp2_netdev_ops;
 	dev->ethtool_ops = &mvpp2_eth_tool_ops;
 
-	port = netdev_priv(dev);
 	port->dev = dev;
 	port->fwnode = port_fwnode;
 	port->has_phy = !!of_find_property(port_node, "phy", NULL);
@@ -5143,7 +5189,6 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 
 	port->of_node = port_node;
 	port->phy_interface = phy_mode;
-	port->comphy = comphy;
 
 	if (priv->hw_version == MVPP21) {
 		port->base = devm_platform_ioremap_resource(pdev, 2 + id);
-- 
2.21.0


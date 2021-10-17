Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF7234309E5
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 16:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343929AbhJQO7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 10:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237361AbhJQO7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 10:59:14 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE5FC06161C;
        Sun, 17 Oct 2021 07:57:05 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id y12so61680655eda.4;
        Sun, 17 Oct 2021 07:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T4LRxAmbFnflH89t7OJtpK+BQEdtR46vgXDNxjLPMWU=;
        b=L6vA3FQb7zolRyEUIfUjm6u25FgAitb0QxbhRTSEvaUyOyiPKm9rxwA0y0bSu3tjVS
         +XBqFaLZcvD8fUq/WvfCMCYHsaD26zAypkx46iOiLxJJ9hkk1ScKPY7x7xcfyX7MyesP
         sBN/n3M2TEpnwf7+z/pOYaAg0ddqKWwd6LyGyGBVjSri3L48FUaUI2mpnaOTKIQpwouT
         Adyzl9aChu1/QcdqBNdBNjmeqAmUhfmwo/++imsDyLlWnv/SUEEKSW7sJkSu91Pmek/d
         2d1jKPhkywFrC5EJt4JwgAyDVN/ZPT4HH4xmtM3wjP4V8vnzTw4xznxTVl2lX2q6OvLp
         exUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T4LRxAmbFnflH89t7OJtpK+BQEdtR46vgXDNxjLPMWU=;
        b=caV2Bj+j7QmojI5B5cmEzRF4wpl7XxqIag/W21Fj6JOYa8tmgP4rRUPwINcU+n3gIw
         /et8yxiZjUliOVuSxhArcgEFSY4WtPNbhF1DV0KRYCkrg5wpjOXgNg3srzsSSP0oOKYP
         iLzMtsd0dOpew5oZkxI7+WCOw5ZyXUZ6rq1GBeycSl6pZc6XDxW1T57WyikUKWpLsJDP
         5pTIH5z651XtdOVRIxjtsruhz0k9ssgy/TVrItbMjhayXLoDAplv47f++UuOhDBhWMvQ
         bbKGlBVPfkTA3guUn/onWQbirNBaYCzAt0B2XA/dGc6hh61aqIVFfW9M2UQxRjWKfUeo
         RzrQ==
X-Gm-Message-State: AOAM533mHaODj/x7ebfNB1UgN/iyZKmWGWd6bvlpAc3p3A1VeT3wPdk8
        BLDeAwID4DLjc30YQlg4pJo=
X-Google-Smtp-Source: ABdhPJwYCNlEvBEkkTj3iKPOsE4/Anni1LNw7T2On9ggGKxdftOg0nUXf6U3GwW3waUFMBy5Gi5uKg==
X-Received: by 2002:a17:907:6d8b:: with SMTP id sb11mr4029063ejc.332.1634482623357;
        Sun, 17 Oct 2021 07:57:03 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id o15sm7631100ejj.10.2021.10.17.07.57.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Oct 2021 07:57:02 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next RESEND PATCH 1/2] net: dsa: qca8k: tidy for loop in setup and add cpu port check
Date:   Sun, 17 Oct 2021 16:56:45 +0200
Message-Id: <20211017145646.56-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tidy and organize qca8k setup function from multiple for loop.
Change for loop in bridge leave/join to scan all port and skip cpu port.
No functional change intended.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 74 ++++++++++++++++++++++++-----------------
 1 file changed, 44 insertions(+), 30 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 2b0aadb0114c..ba0411d4c5ae 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1122,28 +1122,34 @@ qca8k_setup(struct dsa_switch *ds)
 	if (ret)
 		dev_warn(priv->dev, "mib init failed");
 
-	/* Enable QCA header mode on the cpu port */
-	ret = qca8k_write(priv, QCA8K_REG_PORT_HDR_CTRL(cpu_port),
-			  QCA8K_PORT_HDR_CTRL_ALL << QCA8K_PORT_HDR_CTRL_TX_S |
-			  QCA8K_PORT_HDR_CTRL_ALL << QCA8K_PORT_HDR_CTRL_RX_S);
-	if (ret) {
-		dev_err(priv->dev, "failed enabling QCA header mode");
-		return ret;
-	}
-
-	/* Disable forwarding by default on all ports */
+	/* Initial setup of all ports */
 	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
+		/* Disable forwarding by default on all ports */
 		ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
 				QCA8K_PORT_LOOKUP_MEMBER, 0);
 		if (ret)
 			return ret;
-	}
 
-	/* Disable MAC by default on all ports */
-	for (i = 1; i < QCA8K_NUM_PORTS; i++)
-		qca8k_port_set_status(priv, i, 0);
+		/* Enable QCA header mode on all cpu ports */
+		if (dsa_is_cpu_port(ds, i)) {
+			ret = qca8k_write(priv, QCA8K_REG_PORT_HDR_CTRL(i),
+					  QCA8K_PORT_HDR_CTRL_ALL << QCA8K_PORT_HDR_CTRL_TX_S |
+					  QCA8K_PORT_HDR_CTRL_ALL << QCA8K_PORT_HDR_CTRL_RX_S);
+			if (ret) {
+				dev_err(priv->dev, "failed enabling QCA header mode");
+				return ret;
+			}
+		}
 
-	/* Forward all unknown frames to CPU port for Linux processing */
+		/* Disable MAC by default on all user ports */
+		if (dsa_is_user_port(ds, i))
+			qca8k_port_set_status(priv, i, 0);
+	}
+
+	/* Forward all unknown frames to CPU port for Linux processing
+	 * Notice that in multi-cpu config only one port should be set
+	 * for igmp, unknown, multicast and broadcast packet
+	 */
 	ret = qca8k_write(priv, QCA8K_REG_GLOBAL_FW_CTRL1,
 			  BIT(cpu_port) << QCA8K_GLOBAL_FW_CTRL1_IGMP_DP_S |
 			  BIT(cpu_port) << QCA8K_GLOBAL_FW_CTRL1_BC_DP_S |
@@ -1152,11 +1158,13 @@ qca8k_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
-	/* Setup connection between CPU port & user ports */
+	/* Setup connection between CPU port & user ports
+	 * Configure specific switch configuration for ports
+	 */
 	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
 		/* CPU port gets connected to all user ports of the switch */
 		if (dsa_is_cpu_port(ds, i)) {
-			ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(cpu_port),
+			ret = qca8k_rmw(priv, QCA8K_PORT_LOOKUP_CTRL(i),
 					QCA8K_PORT_LOOKUP_MEMBER, dsa_user_ports(ds));
 			if (ret)
 				return ret;
@@ -1193,16 +1201,14 @@ qca8k_setup(struct dsa_switch *ds)
 			if (ret)
 				return ret;
 		}
-	}
 
-	/* The port 5 of the qca8337 have some problem in flood condition. The
-	 * original legacy driver had some specific buffer and priority settings
-	 * for the different port suggested by the QCA switch team. Add this
-	 * missing settings to improve switch stability under load condition.
-	 * This problem is limited to qca8337 and other qca8k switch are not affected.
-	 */
-	if (priv->switch_id == QCA8K_ID_QCA8337) {
-		for (i = 0; i < QCA8K_NUM_PORTS; i++) {
+		/* The port 5 of the qca8337 have some problem in flood condition. The
+		 * original legacy driver had some specific buffer and priority settings
+		 * for the different port suggested by the QCA switch team. Add this
+		 * missing settings to improve switch stability under load condition.
+		 * This problem is limited to qca8337 and other qca8k switch are not affected.
+		 */
+		if (priv->switch_id == QCA8K_ID_QCA8337) {
 			switch (i) {
 			/* The 2 CPU port and port 5 requires some different
 			 * priority than any other ports.
@@ -1238,6 +1244,12 @@ qca8k_setup(struct dsa_switch *ds)
 				  QCA8K_PORT_HOL_CTRL1_WRED_EN,
 				  mask);
 		}
+
+		/* Set initial MTU for every port.
+		 * We have only have a general MTU setting. So track
+		 * every port and set the max across all port.
+		 */
+		priv->port_mtu[i] = ETH_FRAME_LEN + ETH_FCS_LEN;
 	}
 
 	/* Special GLOBAL_FC_THRESH value are needed for ar8327 switch */
@@ -1251,8 +1263,6 @@ qca8k_setup(struct dsa_switch *ds)
 	}
 
 	/* Setup our port MTUs to match power on defaults */
-	for (i = 0; i < QCA8K_NUM_PORTS; i++)
-		priv->port_mtu[i] = ETH_FRAME_LEN + ETH_FCS_LEN;
 	ret = qca8k_write(priv, QCA8K_MAX_FRAME_SIZE, ETH_FRAME_LEN + ETH_FCS_LEN);
 	if (ret)
 		dev_warn(priv->dev, "failed setting MTU settings");
@@ -1728,7 +1738,9 @@ qca8k_port_bridge_join(struct dsa_switch *ds, int port, struct net_device *br)
 	cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
 	port_mask = BIT(cpu_port);
 
-	for (i = 1; i < QCA8K_NUM_PORTS; i++) {
+	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
+		if (dsa_is_cpu_port(ds, i))
+			continue;
 		if (dsa_to_port(ds, i)->bridge_dev != br)
 			continue;
 		/* Add this port to the portvlan mask of the other ports
@@ -1758,7 +1770,9 @@ qca8k_port_bridge_leave(struct dsa_switch *ds, int port, struct net_device *br)
 
 	cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
 
-	for (i = 1; i < QCA8K_NUM_PORTS; i++) {
+	for (i = 0; i < QCA8K_NUM_PORTS; i++) {
+		if (dsa_is_cpu_port(ds, i))
+			continue;
 		if (dsa_to_port(ds, i)->bridge_dev != br)
 			continue;
 		/* Remove this port to the portvlan mask of the other ports
-- 
2.32.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874B5432B12
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 02:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbhJSALd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 20:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233858AbhJSALb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 20:11:31 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 303B0C06161C;
        Mon, 18 Oct 2021 17:09:19 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id r18so5865562edv.12;
        Mon, 18 Oct 2021 17:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mFRV+Z2ejlZzoB8iARQzKAUQllpo6cIev7FmLucsS6s=;
        b=UZcy1XYROfP4ToVnJaqy2egHYHat1YfSbrgCOWgc5jT71EJ0ojrpCk8hZ/jEMBMtUo
         67RlBPKfznhKo7LABUfdmmkSmUT8od2jhngJGfT9G7AbifSJdmAATa88CKdo+peG41hh
         2Qb/EqlUcdzNfRDO5vQnq1PmBgGtPlATSVku/eritx62N7gJZnJuxB8EDcbaVw8+y7iK
         kKEVosz8WyowmRyFe3qr5HmjXlsAR90zvbU7JU/G+Z7UuVp0pIcj/z1EhZpT5X0HjjHl
         VdPPbKn7Rg39OLeAQMjwrrRRpaH0ByoXcpjCJyUbfu3BiHvBVVe7zCdzCvV8K/8ZtRg2
         YLTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mFRV+Z2ejlZzoB8iARQzKAUQllpo6cIev7FmLucsS6s=;
        b=bus8LdtGcVzGSvBYDb2A+kc+5FWZFVWUJeXIhdU+1oLdAGEBh98CuboFbyMEjkUHez
         CBneALPgK9FaVas4TirA3IL++oygxC2bm5Bxq6DYdjUeIbrS3BatoXvkOJQ26mGeZqAC
         sZp5nFXOdAPi12AfPWenBDNUKemzTJnGid6Y3947dbOFDOtIehGi0egGcFphA3tgqtDf
         CG/lXWxq27Ix1hujMat1TpKciisL8p86bl7y6vNEZvdKJLOdmVYeKFLMRXy5ZqC+e6et
         P0BNdaTO/lOY3qiTSH2af/nLvHGqMKyn/mFmu7BKrqr5EeTQ2kUERRAUOj7XSbPlWCn1
         AJYg==
X-Gm-Message-State: AOAM530QoD0QpiAGeGmY/NQPv5W3zOntOYt80Nl6a9Uve2dVv8dOUyZ8
        VdrisNijSLtN/jmMPM0SDGE=
X-Google-Smtp-Source: ABdhPJyZzNTIPypMbD8F0I3Ar4LNEHLidUSdeiEvJUXLrTSbCS1GmeDUbKQAjuxxmT84milKF1gZUQ==
X-Received: by 2002:a17:906:9241:: with SMTP id c1mr34295167ejx.125.1634602157539;
        Mon, 18 Oct 2021 17:09:17 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id q9sm9436509ejf.70.2021.10.18.17.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 17:09:17 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v2] net: dsa: qca8k: tidy for loop in setup and add cpu port check
Date:   Tue, 19 Oct 2021 02:08:50 +0200
Message-Id: <20211019000850.14235-1-ansuelsmth@gmail.com>
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
index 0992790da6b6..ea7f12778922 100644
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


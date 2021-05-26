Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAAC3391947
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 15:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234469AbhEZN5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 09:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234235AbhEZN5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 09:57:30 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A59C06175F
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 06:55:58 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id z16so1988692ejr.4
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 06:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nm1QpAvByWjEIfYQyVaJjbBeCpCNrxlaB33JNLFGKIc=;
        b=NlWspq1OGO/tHMSHR5FARl9jzz7IAmYcWohDzLI53vrhXIWXuAhU7vfSonffgttfb5
         JygQ0vAPJ33J4iUyDGQ3QSgGb1Bx/Y8v3aQdmqVspl8LDUGSxVfjSRAl2nrANJsQQKRO
         Lua33TQESQwaPZyLRyF/yge0Zp6FqCGeOQbonaSEzEHYZsT0dIpHCthGbdH6mt0LYOaX
         Jg9T7jlViEmtLjXE1qpsUanu1t3dnGlAJCcMq8o2vXoqVUrEKu8QpFlVmcjbnOfMNZJt
         9NZDxPdhS2cj+PitCXcSIyTTCGUQsbf3ZJ4pEyc60ptn4Qb6ndRfITCTIf38lAlErWEC
         KvPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nm1QpAvByWjEIfYQyVaJjbBeCpCNrxlaB33JNLFGKIc=;
        b=mPNKNSoIxJ9HA06eAc1o8iAQHeQooZJXjHYPyHGL122ATxArc7YjRxlL1f4EGVxdNq
         7JsBiTRDOYkq0uSntQDhOyWtSI3vncg9fdkIr6cqWCJQCApl7sfOB2MsWpLA5CQrzQXc
         wuzz+SP+mzdE0fZU4EVzrbT4UQgjtK0lmThZPQL6YRWz+sTubO2npvLarSeSsaLBFJSA
         AREFq87lMFvsNmRbMRr/Q/m/T3hetAmNewOtP2LiQG2TLYxCWQtfFu6TRlv+QbkUSmiU
         K5DBRXvTfyjmV+AWy7TGKSm9u0eTJyD21NL2rAEznZb4y2l3/vMjhHZdxE1ZO9spLkKp
         bYGQ==
X-Gm-Message-State: AOAM531TFEbF9MR6M9LdhNfHvr/2n3WQXFCZgW7DuAja+VNdkqIValKx
        dyErepgrWLDZUzAcjFbKzQXlBbnETHY=
X-Google-Smtp-Source: ABdhPJx1L5rfNESmnb+O64nAiMoPm4ei0zl4zI4fuMK6jYdzJEzVBwD3FSpFI2VSBMtPPXlwe3ptKw==
X-Received: by 2002:a17:906:b74f:: with SMTP id fx15mr34109261ejb.85.1622037356004;
        Wed, 26 May 2021 06:55:56 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id k11sm10508476ejc.94.2021.05.26.06.55.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 06:55:55 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
X-Google-Original-From: Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [RFC PATCH v2 linux-next 04/14] net: dsa: sja1105: cache the phy-mode port property
Date:   Wed, 26 May 2021 16:55:25 +0300
Message-Id: <20210526135535.2515123-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210526135535.2515123-1-vladimir.oltean@nxp.com>
References: <20210526135535.2515123-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So far we've succeeded in operating without keeping a copy of the
phy-mode in the driver, since we already have the static config and we
can look at the xMII Mode Parameters Table which already holds that
information.

But with the SJA1110, we cannot make the distinction between sgmii and
2500base-x, because to the hardware's static config, it's all SGMII.
So add a phy_mode property per port inside struct sja1105_private.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:
None.

 drivers/net/dsa/sja1105/sja1105.h      |  1 +
 drivers/net/dsa/sja1105/sja1105_main.c | 24 +++---------------------
 2 files changed, 4 insertions(+), 21 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 830ea5ca359f..d5c0217b1f65 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -210,6 +210,7 @@ struct sja1105_private {
 	struct sja1105_static_config static_config;
 	bool rgmii_rx_delay[SJA1105_MAX_NUM_PORTS];
 	bool rgmii_tx_delay[SJA1105_MAX_NUM_PORTS];
+	phy_interface_t phy_mode[SJA1105_MAX_NUM_PORTS];
 	bool best_effort_vlan_filtering;
 	unsigned long learn_ena;
 	unsigned long ucast_egress_floods;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 292490a2ea0e..f33c23074bb5 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -871,6 +871,8 @@ static int sja1105_parse_ports_node(struct sja1105_private *priv,
 			ports[index].role = XMII_MAC;
 		else if (of_property_read_bool(child, "sja1105,role-phy"))
 			ports[index].role = XMII_PHY;
+
+		priv->phy_mode[index] = phy_mode;
 	}
 
 	return 0;
@@ -1081,27 +1083,7 @@ static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
 static bool sja1105_phy_mode_mismatch(struct sja1105_private *priv, int port,
 				      phy_interface_t interface)
 {
-	struct sja1105_xmii_params_entry *mii;
-	sja1105_phy_interface_t phy_mode;
-
-	mii = priv->static_config.tables[BLK_IDX_XMII_PARAMS].entries;
-	phy_mode = mii->xmii_mode[port];
-
-	switch (interface) {
-	case PHY_INTERFACE_MODE_MII:
-		return (phy_mode != XMII_MODE_MII);
-	case PHY_INTERFACE_MODE_RMII:
-		return (phy_mode != XMII_MODE_RMII);
-	case PHY_INTERFACE_MODE_RGMII:
-	case PHY_INTERFACE_MODE_RGMII_ID:
-	case PHY_INTERFACE_MODE_RGMII_RXID:
-	case PHY_INTERFACE_MODE_RGMII_TXID:
-		return (phy_mode != XMII_MODE_RGMII);
-	case PHY_INTERFACE_MODE_SGMII:
-		return (phy_mode != XMII_MODE_SGMII);
-	default:
-		return true;
-	}
+	return priv->phy_mode[port] != interface;
 }
 
 static void sja1105_mac_config(struct dsa_switch *ds, int port,
-- 
2.25.1


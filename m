Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36348395350
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 01:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbhE3XBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 19:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbhE3XBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 19:01:33 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE72C06174A
        for <netdev@vger.kernel.org>; Sun, 30 May 2021 15:59:53 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id df21so11360603edb.3
        for <netdev@vger.kernel.org>; Sun, 30 May 2021 15:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sEYZwQwKRAcGo0HP4idQ4bX+Dp8jsmR4SWn1JE0MSe0=;
        b=e+fNNNGaPKAqBB36Xy2dyLsqbtJg5iZt4KYuBqe5ygXV5aFkVff2UzVLWdPn2MypdY
         2wySJ2LzF6Ub3OuCexw06h9Mo/Ir698DEaK7KF/2PM05e7KzdoAy6WtXanKUPQuMDJ4S
         9BrRXC07rxMvdGLhiN58vs4m3pjBt0HecQQrSR+fizg4mhCSqt9EUFt86+Kx3O4ts08t
         bkMk/pV8sijKy/EiRWUAkGXwmUg9r36CQUfoWpec2u0nKz0dwLp7lejmBEF/K7yD8ufk
         9xhJ3igbAO37g8B3KI7Z+rMdhXWaxU99uKg1txL0nvMq+awIA07Nsy2i7toJ8CfCgqsN
         J9YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sEYZwQwKRAcGo0HP4idQ4bX+Dp8jsmR4SWn1JE0MSe0=;
        b=dJFdR0VvTl4nRy9dAu0Yp+HwBwVcxzd5Eky9IykR459c85U3N2okJFlCQa7Qc1OZzG
         20f+jdBbvvJ8UE2pr3zZbyS85UcjfKn4tbTvZQPjK/VpubKLTDkNmt38DdlvAUaqgzQG
         TnaNpNHtcQqlBfV03GvwXtt+wemTXsWZYzHaW5l1DIi1Il+DZcb+EZocmRlbABW1lYOU
         PMVka+bFIoiBuDFP9k6R7GwwjEeegFo09nC9xGGEuksXKCUf5ic7ujyOHcFeotKwzBc7
         qtoVmaGVjdSM89RFQNFAfnT3gsYn1WSHUOQ4hpUw70hUF2WIwykdVt4L+OS3YSKI7Ptu
         cJ6g==
X-Gm-Message-State: AOAM533PmZL3trsiIxU1ZlzttaISj4cbd6+4j0wSncvGzK2KcRbjtoza
        NdH+97PAJhU4eSVlk4snjug=
X-Google-Smtp-Source: ABdhPJyZlSGA7okcSOvcGdvac1DjTBx4HFB6k6jazGBxrlE09lVQ23h4L0ZjAq4JmLnl5eD8FnTE2w==
X-Received: by 2002:a50:9fe5:: with SMTP id c92mr14760797edf.93.1622415591755;
        Sun, 30 May 2021 15:59:51 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id c6sm5135120eje.9.2021.05.30.15.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 May 2021 15:59:51 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 4/8] net: dsa: sja1105: cache the phy-mode port property
Date:   Mon, 31 May 2021 01:59:35 +0300
Message-Id: <20210530225939.772553-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210530225939.772553-1-olteanv@gmail.com>
References: <20210530225939.772553-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

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
Changes in v3:
None.

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
index c8d93d810421..e4932243d0d3 100644
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


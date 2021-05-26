Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 766BD39194A
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 15:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234413AbhEZN5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 09:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234428AbhEZN5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 09:57:32 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 145BCC061574
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 06:56:00 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id jt22so2606436ejb.7
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 06:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NREUawkbiSlhUvL4cnznGX+NA58sFaz3tm5HmS+R9d0=;
        b=UvHooha3EZMXP8Da4KEyBZVqB2/Ka+5WB81Qk+bctkA5Gch1dUI+mBX3KhQPchbirM
         D1wTquyXx0zJPFiu0Z41WfDoUAxo0KKe7QWF1RDp7vGubAzYBXi7wUkWEpnzK0KMiGYu
         pJnDoIYAFbP42Z3+E5CnVEB7NMvwqylkvnJRabKyIKGeLl3vuAd/QFeFjWgCIDyARSkX
         Z4kDQIkEGFElIoW2B6mIyS6gROd/MM6Q2gw0ydZj4ZD3J7PBC3b+BeKsEyuoJRJyJYZy
         rKmylcOb4ocNwE7UpHJM5fZ02FUop4B8+BMPsB2oCHGoqitVNU1h+rrMGc+KrEUiwmSs
         HD5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NREUawkbiSlhUvL4cnznGX+NA58sFaz3tm5HmS+R9d0=;
        b=C8HiRKnc+f3WN9tC2+7KTB3uZbGX5EcmrU6SjZumnAI5snXS01+CeIH6VoVLU7XgQo
         wYyHtweIUyedn0lWE32Bc1XWlRYAFzK5trnf5Zv+sqhXwwz1l1+TaiQEbiQZwZaflyn4
         eSmHUelT2WQz1GBSBY5MDKy3YeZxwwBFd+mSMZPhX1qMB2cjX8FQk2yyNdJmG2UpqBeb
         O48ulZyW1VVxqHqz90/R88hN2z2SjhBi0L1I6eEl7l3sDF+P+Ft/MWtKVpRpZ4yFvLla
         wglgw/okzS2rFQIXJ0x68slUi+/glX1SrIxLQ3fnRfTYPhe/cY1aWQWGEVEmE51ejcie
         cHYA==
X-Gm-Message-State: AOAM530EvRVEcspjy7UBGKZDETwIAth437Wiks0hGSqn5Vkw0NswR0CE
        vPrSdYIsS1NJhllPqowTasE=
X-Google-Smtp-Source: ABdhPJwfnqyKZ5VT1B7VIL+EVbm63VrTgZxPT28lhTrhcRspPFP4sZ3tmKPJx7m24MEdm+Zt0+eJBw==
X-Received: by 2002:a17:906:6b92:: with SMTP id l18mr34588388ejr.367.1622037358558;
        Wed, 26 May 2021 06:55:58 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id k11sm10508476ejc.94.2021.05.26.06.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 06:55:58 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
X-Google-Original-From: Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [RFC PATCH v2 linux-next 07/14] net: dsa: sja1105: always keep RGMII ports in the MAC role
Date:   Wed, 26 May 2021 16:55:28 +0300
Message-Id: <20210526135535.2515123-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210526135535.2515123-1-vladimir.oltean@nxp.com>
References: <20210526135535.2515123-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In SJA1105, the xMII Mode Parameters Table field called PHY_MAC denotes
the 'role' of the port, be it a PHY or a MAC. This makes a difference in
the MII and RMII protocols, but RGMII is symmetric, so either PHY or MAC
settings result in the same hardware behavior.

The SJA1110 is different, and the RGMII ports only work when configured
in MAC mode, so keep the port roles in MAC mode unconditionally.

Why we had an RGMII port in the PHY role in the first place was because
we wanted to have a way in the driver to denote whether RGMII delays
should be applied based on the phy-mode property or not. This is already
done in sja1105_parse_rgmii_delays() based on an intermediary
struct sja1105_dt_port (which contains the port role). So it is a
logical fallacy to use the hardware configuration as a scratchpad for
driver data, it isn't necessary.

We can also remove the gating condition for applying RGMII delays only
for ports in the PHY role. The .setup_rgmii_delay() method looks at
the priv->rgmii_rx_delay[port] and priv->rgmii_tx_delay[port] properties
which are already populated properly (in the case of a port in the MAC
role they are false). Removing this condition generates a few more SPI
writes for these ports (clearing the RGMII delays) which are perhaps
useless for SJA1105P/Q/R/S, where we know that the delays are disabled
by default. But for SJA1110, the firmware on the embedded microcontroller
might have done something funny, so it's always a good idea to clear the
RGMII delays if that's what Linux expects.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_clocking.c | 7 +------
 drivers/net/dsa/sja1105/sja1105_main.c     | 8 +++++++-
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_clocking.c b/drivers/net/dsa/sja1105/sja1105_clocking.c
index 03173397d950..ae297648611f 100644
--- a/drivers/net/dsa/sja1105/sja1105_clocking.c
+++ b/drivers/net/dsa/sja1105/sja1105_clocking.c
@@ -566,14 +566,9 @@ static int sja1105_rgmii_clocking_setup(struct sja1105_private *priv, int port,
 		dev_err(dev, "Failed to configure Tx pad registers\n");
 		return rc;
 	}
+
 	if (!priv->info->setup_rgmii_delay)
 		return 0;
-	/* The role has no hardware effect for RGMII. However we use it as
-	 * a proxy for this interface being a MAC-to-MAC connection, with
-	 * the RGMII internal delays needing to be applied by us.
-	 */
-	if (role == XMII_MAC)
-		return 0;
 
 	return priv->info->setup_rgmii_delay(priv, port);
 }
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index d3aa14d3a5c6..04af644bf656 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -218,8 +218,14 @@ static int sja1105_init_mii_settings(struct sja1105_private *priv,
 		/* Even though the SerDes port is able to drive SGMII autoneg
 		 * like a PHY would, from the perspective of the XMII tables,
 		 * the SGMII port should always be put in MAC mode.
+		 * Similarly, RGMII is a symmetric protocol electrically
+		 * speaking, and the 'RGMII PHY' role does not mean anything to
+		 * hardware. Just keep the 'PHY role' notation relevant to the
+		 * driver to mean 'the switch port should apply RGMII delays',
+		 * but unconditionally put the port in the MAC role.
 		 */
-		if (ports[i].phy_mode == PHY_INTERFACE_MODE_SGMII)
+		if (ports[i].phy_mode == PHY_INTERFACE_MODE_SGMII ||
+		    phy_interface_mode_is_rgmii(ports[i].phy_mode))
 			mii->phy_mac[i] = XMII_MAC;
 		else
 			mii->phy_mac[i] = ports[i].role;
-- 
2.25.1


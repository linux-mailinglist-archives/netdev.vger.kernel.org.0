Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C912D395354
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 01:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbhE3XBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 19:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbhE3XBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 19:01:35 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBBADC06174A
        for <netdev@vger.kernel.org>; Sun, 30 May 2021 15:59:55 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id r23so11379291edw.1
        for <netdev@vger.kernel.org>; Sun, 30 May 2021 15:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jkmsADSejieZ+7jwy+cH2F5yph3lP260Y2ixi8T39o4=;
        b=mtDXhYKaXxxN945pOnyQpDM3uzQZgFBa9K1DS7aCgdaNaQMTTDukPqLyRMJ5fSiR+Q
         yYGEX2tP7VLyY8c/8iMswm1JG6+PJJPCu0FcwoAP05DqEfBpbf9IyVjzTSRqyH9zwtBf
         X2IziRq41PTlJWAhmu7SHdadRYr0RKRJM0xcxaxCnbfI71d4JvWs42YyznnmeckYReva
         TB7gCFEB2J8KW/5b1wd0R35RRoT8wiN52LrmTaMEJ2kMjmLpeOZpvE03vAEFlljqVqkL
         8Cwpucx2kK5qlsjSQhcUW1aQsvFkQpgYSeFMC5LSmgQlP7NG9nTgM6LZtUrzh6nMN56z
         QYaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jkmsADSejieZ+7jwy+cH2F5yph3lP260Y2ixi8T39o4=;
        b=OCQtVHFunabQKCe5mi7tecRKdzWHeDceVbnvOiOCCG916FpoDAo8JMrVDwQvamKlBC
         hWIkWiUvRkHsmfSeXJ8VAtYYutcBS2x1aDeoNtNzIoyC3eX0nYTjX/wJcf/cNRAm2rbK
         xVz/G31RJEOZvEiCWFtnLtlCuT65904otAqS4xnaaYGkyDzCVRRAf7boQPzAwHI92b85
         PffRNaq75IK1nuXEktqO/MaR2x6/3tObGqC24BVSnQMlOu2SRb2iyUnzOxN+Cu+FgoUF
         lTiFIpBQFMkURNN9EJh+EUcDIGhbADJoGfc+2iIUqWxYRHxRj725qa8v8yIqEm9plJPK
         9cQA==
X-Gm-Message-State: AOAM532C7L1cClq0N6R328bSe4AZXuIrlBwkXC4lnviZTRtG11BxZZRN
        dac9XLWXj88pBKEyK3WqMak=
X-Google-Smtp-Source: ABdhPJxqTg06bFDq3e/V8ywz5rhdCT8nBRcxNUKG5xJgMCl4irkPjvFkMsS+E0LTAFqysGN0zzCUMA==
X-Received: by 2002:a05:6402:12d8:: with SMTP id k24mr12003997edx.47.1622415594312;
        Sun, 30 May 2021 15:59:54 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id c6sm5135120eje.9.2021.05.30.15.59.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 May 2021 15:59:54 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 7/8] net: dsa: sja1105: always keep RGMII ports in the MAC role
Date:   Mon, 31 May 2021 01:59:38 +0300
Message-Id: <20210530225939.772553-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210530225939.772553-1-olteanv@gmail.com>
References: <20210530225939.772553-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

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
Changes in v3:
None.

Changes in v2:
None.

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
index 5beafe003268..84edd054781b 100644
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


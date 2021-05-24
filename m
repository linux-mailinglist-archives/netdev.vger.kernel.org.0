Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3665A38F631
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 01:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbhEXXYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 19:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbhEXXYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 19:24:05 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A62C06138A
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 16:22:36 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id l1so44289693ejb.6
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 16:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H7Tg023BC4h4XJWaiu/4LLHG4/2IbMFn1RJWmtmHcCI=;
        b=OVZM4/CQrOK/ZME8SvgDR7rXOfn0kBbH7AwtwAHgj7aHJLNmxVbxktovyjfQ4AqPxG
         bM7E4t+TLATWLxF+g1SC7iTSLW3SJRi13UAWJh6+JnNMSNgtsMpFUp+qvzfiQuUIBCmM
         99KFBjmpn7GGXIdkC+K+N2V13nWn+TodcvC3jNHKFf94abLa2gRRoMNQ9S8kn1SBmdYi
         i1r/555GwsW9JqNTqSGRGl24LasYpQxwrKE0MqGMaCJX5TfQEQTya1St80qkzFOzISg3
         onkkJ3Dd9OZDy/l9d03d2Xw7GfMhlys6y+Hm1Twmev7wa8UR755UcQeTCTqKJl72ubt+
         9EmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H7Tg023BC4h4XJWaiu/4LLHG4/2IbMFn1RJWmtmHcCI=;
        b=MrTEliYUYz8kkDSoSMJfGvrvHVFWNB4CU/mDgHVw+SWrURpFcDC58WzDGOYqUTR2kI
         N7EKUwcEdSb9fQXT9T1a4JEOz6E7MEjl2z4jGPQ3oI1rgjz5LX6u1jJOzvK847MYchWE
         3XR0DA1srdnAgItlGA2vyE/YYul+fSjwmXSBgPPS9YDd8Qx+crnJCxNPOVklA0vGNXyE
         +261NzRQkTQUGubuZljDxh/UBSs/gTf90jNt8XjklG3tKER8gj+TpD0gOJ7k/fOpwY5F
         +ovBHQqlo0bS8JgN7Js7RjykZz8VYG6qT7kEFNuVhpaxiBYOrUGKJlzxInQNhM5cmaU0
         Fk3g==
X-Gm-Message-State: AOAM532j/zU1BgULh+gAe5fsjA45KxFoxmpI8LSqgHlVHKRPcT3fbteI
        JtypX4LRuHwbglbSkCWIupI=
X-Google-Smtp-Source: ABdhPJxDybDc73bCW9rdSn5M1VEeRD3xLh8C8VGuGoFG/JlhasSR258jk/zZ5RBosL9pA90izxZlzQ==
X-Received: by 2002:a17:906:68da:: with SMTP id y26mr10885268ejr.514.1621898554686;
        Mon, 24 May 2021 16:22:34 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id di7sm9922746edb.34.2021.05.24.16.22.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 16:22:34 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 07/13] net: dsa: sja1105: always keep RGMII ports in the MAC role
Date:   Tue, 25 May 2021 02:22:08 +0300
Message-Id: <20210524232214.1378937-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210524232214.1378937-1-olteanv@gmail.com>
References: <20210524232214.1378937-1-olteanv@gmail.com>
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


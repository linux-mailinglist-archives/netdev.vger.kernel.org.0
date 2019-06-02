Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF401325A3
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 01:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfFBXbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 19:31:46 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34100 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfFBXbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 19:31:46 -0400
Received: by mail-wr1-f66.google.com with SMTP id e16so1866280wrn.1
        for <netdev@vger.kernel.org>; Sun, 02 Jun 2019 16:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=T7wkRLIv1vr7+h2mJXm6cb/iDeROyc1IClzygOY9Nxg=;
        b=E+ZuQHyDWx+tSC2zBCBbx/MC+kpK9DtyLp6PSqiM4sstq6v06rItEqkj4U9+Ahp7mA
         RKy26DcjxsnyUUmstpd6gxhjC/9r5hgfN9pudbuF5ucjYDEwMB0RnozVvL2FfMnumO5b
         ceW75utX7MTdJXPtJ3baTyCe7pV6XxfUhR4geqXdGnRJxAQl5igg/0UPB9PJwKUpsFq2
         jlN2VFEB+hWrDoTxyamFo9yUNceUREFXb+PsysIs6pbA84bfkbkVh8OJbgt67KjfKCfd
         x3C6YJNOW440w4VsvjexqYETNmGks4bfN2vmLu/7Pn4neynuEF6Esf+UDifgsHcakHPY
         4xdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=T7wkRLIv1vr7+h2mJXm6cb/iDeROyc1IClzygOY9Nxg=;
        b=hQ7qyW0CcMEhITjnp2XtYHsTevm9VwZeV5yixEOTUAGZ16iEv/WNTbzGRhxVRg/xBB
         FOcFb1q+/8+gV5frvdOukg2UxQ11O60e4JoWaJ9tqvoAECKaG5PtX2mio+ISkiaC3IhM
         Z8qA3B3I4kCxey1l7ESePCd8ZCn4ITIwRy7ce/OVd7WPDzhlXXMQygf6fCYFcjxYBcC6
         xVz1c+//fSO3uWvVpOPBSzOV4pZ0HDpNSDXqD4sqm++HmtMmvRmSUP/n6QMJvgZ1FxgL
         8ghlviYb+mYvvaI3fpW85d5xgCKvWQVkTvpWecLlHo5PMCzczkWEn+VMD2xHvEUKH8uu
         KeqA==
X-Gm-Message-State: APjAAAUt5n68TPvfs6yL4mWgHzSrSHVB2dqaH8OSbP3IxMlYKYGnf6pN
        lY5/B1Z7PAKM2/N4D8WzFlY=
X-Google-Smtp-Source: APXvYqxoHbXhOUrT3TIEWj7bNNt6hWtRGrGmhFoITWs0kyF1UZ7YZQIPzY4QIKiBonBf7qolqxmEAA==
X-Received: by 2002:a5d:694c:: with SMTP id r12mr334192wrw.214.1559518304326;
        Sun, 02 Jun 2019 16:31:44 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id 32sm39414631wra.35.2019.06.02.16.31.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Jun 2019 16:31:43 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net 1/1] net: dsa: sja1105: Fix link speed not working at 100 Mbps and below
Date:   Mon,  3 Jun 2019 02:31:37 +0300
Message-Id: <20190602233137.17930-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190602233137.17930-1-olteanv@gmail.com>
References: <20190602233137.17930-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hardware values for link speed are held in the sja1105_speed_t enum.
However they do not increase in the order that sja1105_get_speed_cfg was
iterating over them (basically from SJA1105_SPEED_AUTO - 0 - to
SJA1105_SPEED_1000MBPS - 1 - skipping the other two).

Another bug is that the code in sja1105_adjust_port_config relies on the
fact that an invalid link speed is detected by sja1105_get_speed_cfg and
returned as -EINVAL.  However storing this into an enum that only has
positive members will cast it into an unsigned value, and it will miss
the negative check.

So take the simplest approach and remove the sja1105_get_speed_cfg
function and replace it with a simple switch-case statement.

Fixes: 8aa9ebccae87 ("net: dsa: Introduce driver for NXP SJA1105 5-port L2 switch")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Suggested-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 32 +++++++++++++-------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 5412c3551bcc..25bb64ce0432 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -710,16 +710,6 @@ static int sja1105_speed[] = {
 	[SJA1105_SPEED_1000MBPS] = 1000,
 };
 
-static sja1105_speed_t sja1105_get_speed_cfg(unsigned int speed_mbps)
-{
-	int i;
-
-	for (i = SJA1105_SPEED_AUTO; i <= SJA1105_SPEED_1000MBPS; i++)
-		if (sja1105_speed[i] == speed_mbps)
-			return i;
-	return -EINVAL;
-}
-
 /* Set link speed and enable/disable traffic I/O in the MAC configuration
  * for a specific port.
  *
@@ -742,8 +732,21 @@ static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
 	mii = priv->static_config.tables[BLK_IDX_XMII_PARAMS].entries;
 	mac = priv->static_config.tables[BLK_IDX_MAC_CONFIG].entries;
 
-	speed = sja1105_get_speed_cfg(speed_mbps);
-	if (speed_mbps && speed < 0) {
+	switch (speed_mbps) {
+	case 0:
+		/* No speed update requested */
+		speed = SJA1105_SPEED_AUTO;
+		break;
+	case 10:
+		speed = SJA1105_SPEED_10MBPS;
+		break;
+	case 100:
+		speed = SJA1105_SPEED_100MBPS;
+		break;
+	case 1000:
+		speed = SJA1105_SPEED_1000MBPS;
+		break;
+	default:
 		dev_err(dev, "Invalid speed %iMbps\n", speed_mbps);
 		return -EINVAL;
 	}
@@ -753,10 +756,7 @@ static int sja1105_adjust_port_config(struct sja1105_private *priv, int port,
 	 * and we no longer need to store it in the static config (already told
 	 * hardware we want auto during upload phase).
 	 */
-	if (speed_mbps)
-		mac[port].speed = speed;
-	else
-		mac[port].speed = SJA1105_SPEED_AUTO;
+	mac[port].speed = speed;
 
 	/* On P/Q/R/S, one can read from the device via the MAC reconfiguration
 	 * tables. On E/T, MAC reconfig tables are not readable, only writable.
-- 
2.17.1


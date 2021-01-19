Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA3F22FC47B
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 00:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728562AbhASXJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 18:09:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbhASXIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 18:08:47 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A42A0C0613D3
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 15:08:06 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id l9so25195385ejx.3
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 15:08:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Oci+XcNQZUIsVNYEJgvOjhWRF37YAlsRe2zEuUxbVNk=;
        b=PgwvhOaNg9AVnFk/ey5r7/qnqtUN81PRhq/9dbhh3GnC0ZeR/Ldf99qP+rZcyKLs4N
         OUrZCglF7XX3kvUJN1gVae99A+v0Jc+yDL5WGggh9l/MxhUQAPl+rVIJbbGwUx9ru894
         3gLLKHUpiL+661+PMrioLlV3KctPMh/5PyuR1cFEYxbtTMpqyqcZzmP2nZG/IOsE3Pfp
         ipP94TCWjYKDo54GUzcy7dOk68NxOgoLTD8+lJ+0HpT4nKA5VgXD5WBGi44fts0eaTru
         09XLhd3qFLBTSOzYpggKf51E3qFe50cbzgMKKLlJXTzvvhjqt117cDp5dPwlYbu3CKrN
         58mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Oci+XcNQZUIsVNYEJgvOjhWRF37YAlsRe2zEuUxbVNk=;
        b=Q30EZL6Zk5GVItXUWgluHnticNiYciJMFs/4LrIlgfViM9M9D2g1d/Z0qtDHnzQbg7
         9rOLalOQWm17k3qgjP/beLhncNzpexwoK967uBN5heGJe6K/5NYQijUjcGzpP1Upkf8Y
         XU/2ZrrxCOMnflzZQ5sOW2eM7kQpCy+XGGQW7A0aaSu/GemNsz9Q0NO7Vk6AcdlRI0/g
         08j3++HQxz+dor+CMRvADazD4b+2cR4FJqWchwMZGZSeyXh5LrjQSPIOhteBu2Dyn9yX
         +IaN6iYxmxUT6IWHI0blroXEpsJCY096VsVMzJLmZ3Yw6zCDD78kVz0USCkW6tNRfZvw
         rcYg==
X-Gm-Message-State: AOAM532LGTOMa6sqQBRaLp0xvtxgFjvE/dPBE/WSTnoaRusQ7C4Mtn+u
        /kVG2hfydIjuXXaDGtHu9yc=
X-Google-Smtp-Source: ABdhPJyMZU3MJQGa3WAcvvasOhGi4GEqUFh4fa02kr11CUjx6I7GFLxDQB+MpURW4vFOTv7A7OaadQ==
X-Received: by 2002:a17:906:1f45:: with SMTP id d5mr4527547ejk.76.1611097685439;
        Tue, 19 Jan 2021 15:08:05 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id lh26sm94197ejb.119.2021.01.19.15.08.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 15:08:04 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>, UNGLinuxDriver@microchip.com
Subject: [PATCH v4 net-next 04/16] net: mscc: ocelot: reapply bridge forwarding mask on bonding join/leave
Date:   Wed, 20 Jan 2021 01:07:37 +0200
Message-Id: <20210119230749.1178874-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210119230749.1178874-1-olteanv@gmail.com>
References: <20210119230749.1178874-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Applying the bridge forwarding mask currently is done only on the STP
state changes for any port. But it depends on both STP state changes,
and bonding interface state changes. Export the bit that recalculates
the forwarding mask so that it could be reused, and call it when a port
starts and stops offloading a bonding interface.

Now that the logic is split into a separate function, we can rename "p"
into "port", since the "port" variable was already taken in
ocelot_bridge_stp_state_set. Also, we can rename "i" into "lag", to make
it more clear what is it that we're iterating through.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
---
Changes in v4:
Patch is carried over from the "LAG offload for Ocelot DSA switches"
series:
https://patchwork.kernel.org/project/netdevbpf/patch/20210116005943.219479-10-olteanv@gmail.com/
I need it here because it refactors ocelot_apply_bridge_fwd_mask into a
separate function which I also need to call from felix now.

 drivers/net/ethernet/mscc/ocelot.c | 63 +++++++++++++++++-------------
 1 file changed, 36 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index a560d6be2a44..42d92a5b475d 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -876,10 +876,42 @@ int ocelot_get_ts_info(struct ocelot *ocelot, int port,
 }
 EXPORT_SYMBOL(ocelot_get_ts_info);
 
+static void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot)
+{
+	int port;
+
+	/* Apply FWD mask. The loop is needed to add/remove the current port as
+	 * a source for the other ports.
+	 */
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		if (ocelot->bridge_fwd_mask & BIT(port)) {
+			unsigned long mask = ocelot->bridge_fwd_mask & ~BIT(port);
+			int lag;
+
+			for (lag = 0; lag < ocelot->num_phys_ports; lag++) {
+				unsigned long bond_mask = ocelot->lags[lag];
+
+				if (!bond_mask)
+					continue;
+
+				if (bond_mask & BIT(port)) {
+					mask &= ~bond_mask;
+					break;
+				}
+			}
+
+			ocelot_write_rix(ocelot, mask,
+					 ANA_PGID_PGID, PGID_SRC + port);
+		} else {
+			ocelot_write_rix(ocelot, 0,
+					 ANA_PGID_PGID, PGID_SRC + port);
+		}
+	}
+}
+
 void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
 {
 	u32 port_cfg;
-	int p, i;
 
 	if (!(BIT(port) & ocelot->bridge_mask))
 		return;
@@ -902,32 +934,7 @@ void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
 
 	ocelot_write_gix(ocelot, port_cfg, ANA_PORT_PORT_CFG, port);
 
-	/* Apply FWD mask. The loop is needed to add/remove the current port as
-	 * a source for the other ports.
-	 */
-	for (p = 0; p < ocelot->num_phys_ports; p++) {
-		if (ocelot->bridge_fwd_mask & BIT(p)) {
-			unsigned long mask = ocelot->bridge_fwd_mask & ~BIT(p);
-
-			for (i = 0; i < ocelot->num_phys_ports; i++) {
-				unsigned long bond_mask = ocelot->lags[i];
-
-				if (!bond_mask)
-					continue;
-
-				if (bond_mask & BIT(p)) {
-					mask &= ~bond_mask;
-					break;
-				}
-			}
-
-			ocelot_write_rix(ocelot, mask,
-					 ANA_PGID_PGID, PGID_SRC + p);
-		} else {
-			ocelot_write_rix(ocelot, 0,
-					 ANA_PGID_PGID, PGID_SRC + p);
-		}
-	}
+	ocelot_apply_bridge_fwd_mask(ocelot);
 }
 EXPORT_SYMBOL(ocelot_bridge_stp_state_set);
 
@@ -1284,6 +1291,7 @@ int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 	}
 
 	ocelot_setup_lag(ocelot, lag);
+	ocelot_apply_bridge_fwd_mask(ocelot);
 	ocelot_set_aggr_pgids(ocelot);
 
 	return 0;
@@ -1317,6 +1325,7 @@ void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 	ocelot_write_gix(ocelot, port_cfg | ANA_PORT_PORT_CFG_PORTID_VAL(port),
 			 ANA_PORT_PORT_CFG, port);
 
+	ocelot_apply_bridge_fwd_mask(ocelot);
 	ocelot_set_aggr_pgids(ocelot);
 }
 EXPORT_SYMBOL(ocelot_port_lag_leave);
-- 
2.25.1


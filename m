Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87BB53082D1
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 02:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbhA2BCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 20:02:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbhA2BBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 20:01:33 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EABF4C0613ED
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 17:00:35 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id hs11so10589726ejc.1
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 17:00:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N7BAS3bJWQ8YHNdJT4muFg9eD1DjtAchhAU+ZDi8oEk=;
        b=Lr2txc2xVUqb006tiw6gbakJTSp1/4J+002dtCcOOJMem219K1IxN7EmuEPxvpe9au
         vFJiSxAxePcj3GhQHAf7t1QAd25omi0INcohP0qB8MHTabQKR3wGlMarjEr1womd+r9d
         ah8Qt/NWpr42AlVqMhOplSZIxoHOmbp3eBLSgWCtWlNs/p+GLRxveaqeK7sLmb9C16Ns
         ShPKT8f2cF1a96wsNI4qOTtmjp4hOAdEUsGGJAUvFmiw1sUsP4QZ2vGB4OxAzK5g1pdu
         eIalKeWuiJ9zb5okpNID19JjRzx8tgaUm9XPEBLuja5xFpBWLpfiPW9EDtGI6q0r7GJy
         7QNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N7BAS3bJWQ8YHNdJT4muFg9eD1DjtAchhAU+ZDi8oEk=;
        b=SL6oSff1YPa08TCbm7DhMkjGM1FMkDoy4lbiSQ6tPdD7t7fDdyt139syA8/jA0hN2q
         1zszrOH5iWKK7kRT9DeukYluF8Ib4lUtLbOkxK/0LXe3v21DwIsm6eJLm4jdExCAJ0n0
         Jjigx05yMUIG7S/9ICxuKnH4xF9qKJyTiTHxH20V/AhjnnCvmVmoC3PWBKomugKyJeDY
         qle5ZuPYtxAuHBE21/jPbQgVnFVm2Lrse11MiwGAAPc90z7miXmMiRCdFaEkOw4AOWtr
         lGxBSnT0ybCvGlqZeoftRbvY32EQBgcRlQTzYgVf5UWKsxr19XbWsIGu6nIW4QpdVyH4
         u/lg==
X-Gm-Message-State: AOAM532JQpYuWjPTYMCc3kYLsPr0Qh/VgvTCZU2ivADmeRXnQh23VNtC
        tyW1lnp5Kdq3dZCgBW1Z4Bk=
X-Google-Smtp-Source: ABdhPJwUqF0DRw6EU9BN7IDFYhzzgnSy1s+hWMe4QgVC6MhPEzbA5+JT4NgYdQ7pGl+8R9oG+2vgOg==
X-Received: by 2002:a17:906:2898:: with SMTP id o24mr2132636ejd.215.1611882034651;
        Thu, 28 Jan 2021 17:00:34 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id f22sm3049256eje.34.2021.01.28.17.00.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 17:00:34 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v8 net-next 04/11] net: mscc: ocelot: reapply bridge forwarding mask on bonding join/leave
Date:   Fri, 29 Jan 2021 03:00:02 +0200
Message-Id: <20210129010009.3959398-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210129010009.3959398-1-olteanv@gmail.com>
References: <20210129010009.3959398-1-olteanv@gmail.com>
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v8:
None.

Changes in v7:
None.

Changes in v6:
None.
Jakub, just FYI: ./scripts/get_maintainer.pl parses the "bpf" string
from the patchwork instance name, and wants me to CC the BPF maintainers
because of that.

Changes in v5:
None.

Changes in v4:
Patch is carried over from the "LAG offload for Ocelot DSA switches"
series:
https://patchwork.kernel.org/project/netdevbpf/patch/20210116005943.219479-10-olteanv@gmail.com/
I need it here because it refactors ocelot_apply_bridge_fwd_mask into a
separate function which I also need to call from felix now.

 drivers/net/ethernet/mscc/ocelot.c | 63 +++++++++++++++++-------------
 1 file changed, 36 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 5b2c0cea49ea..7352f58f9bc2 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -889,10 +889,42 @@ int ocelot_get_ts_info(struct ocelot *ocelot, int port,
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
@@ -915,32 +947,7 @@ void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state)
 
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
 
@@ -1297,6 +1304,7 @@ int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 	}
 
 	ocelot_setup_lag(ocelot, lag);
+	ocelot_apply_bridge_fwd_mask(ocelot);
 	ocelot_set_aggr_pgids(ocelot);
 
 	return 0;
@@ -1330,6 +1338,7 @@ void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 	ocelot_write_gix(ocelot, port_cfg | ANA_PORT_PORT_CFG_PORTID_VAL(port),
 			 ANA_PORT_PORT_CFG, port);
 
+	ocelot_apply_bridge_fwd_mask(ocelot);
 	ocelot_set_aggr_pgids(ocelot);
 }
 EXPORT_SYMBOL(ocelot_port_lag_leave);
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B800302EA4
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 23:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733178AbhAYWGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 17:06:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732134AbhAYWFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 17:05:10 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75756C0613D6
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 14:04:30 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id w1so20201442ejf.11
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 14:04:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YCg9KlHjU+4+nj9DXghx0cPGR0Hm3/1sRcbbBPFiAX4=;
        b=mryobeBgPMPvHF02VOYwHB5ngSBENb5dXj+Sk/ilyFBe5AdHQvfCND7HOp9NcYEIIp
         wBZrQcifcS4sdX8BaYVcmWuljGe/421sux1+SzUBl2/MGTX5YDsNKCcPV+VkOq1CJtEA
         zWtNmi7qxqoiZcwrF+oZCV8WYaXOI++rO04lu0vl8FQCQLog31HEz9zsFQJzn1G3+MhX
         FkD40AlsL2YZeLwIPH2UfMz0ZC1XmnmeI9KbP5CksYI+2bQREYscyG2p1tQkh9d81TPo
         9n9+vbDn71El5sdYWq5l0kt4PmY1vjGx8faQAjvXDFx9V9AfgpDe6mS6YuA41F+84mtF
         8pNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YCg9KlHjU+4+nj9DXghx0cPGR0Hm3/1sRcbbBPFiAX4=;
        b=eacNnY4jwCv2Jm4z6JrQE8ngYTs0fmCWryyqCWuBBc1mvYQcKugR+2JOzwpcCTltsJ
         aEAq6M3mnYSMfPxi6t1HjxNkX8VJzat52ZpKQyTau+uNZPe35xQnS47D4tH6Tno0PP/U
         T0wFiDVwGCcmJFV0XNWaPmdJ4AU2ctvdFzks1zFrUkoaSX1u522X8qeATxpLLrPNK1kW
         yMiCNGGkI2L6Q+efe6ars07z4ZIbhlXwsDibCt/ldXSd7bbsr/988kXEJ2NpGRyUoRBL
         wFBUmim4BryFsYvodMFm27+lP6CgVq9WnpgrL3mZdu00xeNtmPpk6pa+sNOjzmPQhIj7
         l9vw==
X-Gm-Message-State: AOAM5334bbrKY3hzmuAP5AhNGbPl2fz3XsU5EAjS5X57fiE8VKjbXbT8
        CctI/Z6ANR2GakAPcvcyQrE=
X-Google-Smtp-Source: ABdhPJwGmhf3bIax6TwYrxe2jMNx3w2/QbrZhW6vyu3io3s3RPC7CqYoxNCmcsBPzSJF0lj+DT1eCw==
X-Received: by 2002:a17:906:358f:: with SMTP id o15mr1645769ejb.369.1611612269202;
        Mon, 25 Jan 2021 14:04:29 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id s13sm1760555edi.92.2021.01.25.14.04.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 14:04:28 -0800 (PST)
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
Subject: [PATCH v7 net-next 04/11] net: mscc: ocelot: reapply bridge forwarding mask on bonding join/leave
Date:   Tue, 26 Jan 2021 00:03:26 +0200
Message-Id: <20210125220333.1004365-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210125220333.1004365-1-olteanv@gmail.com>
References: <20210125220333.1004365-1-olteanv@gmail.com>
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


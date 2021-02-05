Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF6F33118F4
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 03:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbhBFCvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 21:51:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231325AbhBFCmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:42:47 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3310CC061225
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 14:03:20 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id w1so14373016ejf.11
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 14:03:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QS13JTR37VVKTmmDq1xl6ePKRk/6k5ELZv5cGdZhKOs=;
        b=shYm/sM8+sl/nHdExgz2IvOl6LL0o37qTZckhZ3ACb65I+jBSvgX4LFRO2vQiH8KoG
         8WeLuWjs8OmgdIxkZH7DWWzZeJFPg1jVQmR3JUN56JSCaIoDi7B7HKLfExjVbEfJhfVP
         35cbzC2/3e5Xzg1apwkx+DIsPmG/KYmQzi23s/GXgj1/k4MnekCDsBOJ4yF6L2NftqQC
         HGEz+p0X208dgGN99iaAmmRMpk1V0gqfks3xPkiCSrU/debWqzy9Dv17KbxYDsLA6Alc
         +RFBoo9RHRq/YUgn3aeiQ6nQKNS6Ufjv+jfQ+M9GpN5vstPThDTKoiGQgtDUSN4YbqDX
         79Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QS13JTR37VVKTmmDq1xl6ePKRk/6k5ELZv5cGdZhKOs=;
        b=GY3TuQMJqObwwQ0mOvdMkw9bU7Zxw4zBY04R3dWaiDv6QHzRAKkIdSCmGFc4Bj++cs
         uJvaXYM0mlMjXbZcESdvoctXM3zPRiWnYaS0V41eBycmTaWrP6aQKjRontO8ptXNHTQ/
         yz9U7/YWTMYJbyOnQSsz6ZSYaNyS3C6zvZYHZS//Rdx35bfy34oxv6absMl6XLM6SLtN
         PHvOvNreegKuZJq9Obzqqi4k2oDtO9rUnAP4XixHsnYbOxar7KRocya9Bi+XCbTThlIA
         TPt3lHKumeVHXj1hpi6AoaSBGiMP4qzJwBlligXrMsHNjQxjj/7RVG3nSInuKxL/UfWM
         A80w==
X-Gm-Message-State: AOAM533JeSg9Nfs24F7I/+tJwAQxt20cu6w3oCcss22Mc7z0uSnYjMMb
        S7K2PuK9itWAcK3ljpMfdzU=
X-Google-Smtp-Source: ABdhPJyCTLdiR1SaI0md1QKXwHZXit///NQPUbGkH9Xa/3NbX2Oa2/los6JiUMoFTQYfx/+DBkfprg==
X-Received: by 2002:a17:906:eb88:: with SMTP id mh8mr5913704ejb.150.1612562598887;
        Fri, 05 Feb 2021 14:03:18 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id t16sm4969909edi.60.2021.02.05.14.03.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 14:03:18 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH RESEND v3 net-next 07/12] net: mscc: ocelot: set up logical port IDs centrally
Date:   Sat,  6 Feb 2021 00:02:16 +0200
Message-Id: <20210205220221.255646-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210205220221.255646-1-olteanv@gmail.com>
References: <20210205220221.255646-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The setup of logical port IDs is done in two places: from the inconclusively
named ocelot_setup_lag and from ocelot_port_lag_leave, a function that
also calls ocelot_setup_lag (which apparently does an incomplete setup
of the LAG).

To improve this situation, we can rename ocelot_setup_lag into
ocelot_setup_logical_port_ids, and drop the "lag" argument. It will now
set up the logical port IDs of all switch ports, which may be just
slightly more inefficient but more maintainable.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
None.

Changes in v2:
None.

 drivers/net/ethernet/mscc/ocelot.c | 47 ++++++++++++++++++------------
 1 file changed, 28 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 7f6fb872f588..5d765245c6d3 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1316,20 +1316,36 @@ static void ocelot_set_aggr_pgids(struct ocelot *ocelot)
 	}
 }
 
-static void ocelot_setup_lag(struct ocelot *ocelot, int lag)
+/* When offloading a bonding interface, the switch ports configured under the
+ * same bond must have the same logical port ID, equal to the physical port ID
+ * of the lowest numbered physical port in that bond. Otherwise, in standalone/
+ * bridged mode, each port has a logical port ID equal to its physical port ID.
+ */
+static void ocelot_setup_logical_port_ids(struct ocelot *ocelot)
 {
-	unsigned long bond_mask = ocelot->lags[lag];
-	unsigned int p;
+	int port;
 
-	for_each_set_bit(p, &bond_mask, ocelot->num_phys_ports) {
-		u32 port_cfg = ocelot_read_gix(ocelot, ANA_PORT_PORT_CFG, p);
+	for (port = 0; port < ocelot->num_phys_ports; port++) {
+		struct ocelot_port *ocelot_port = ocelot->ports[port];
+		struct net_device *bond;
+
+		if (!ocelot_port)
+			continue;
 
-		port_cfg &= ~ANA_PORT_PORT_CFG_PORTID_VAL_M;
+		bond = ocelot_port->bond;
+		if (bond) {
+			int lag = __ffs(ocelot_get_bond_mask(ocelot, bond));
 
-		/* Use lag port as logical port for port i */
-		ocelot_write_gix(ocelot, port_cfg |
-				 ANA_PORT_PORT_CFG_PORTID_VAL(lag),
-				 ANA_PORT_PORT_CFG, p);
+			ocelot_rmw_gix(ocelot,
+				       ANA_PORT_PORT_CFG_PORTID_VAL(lag),
+				       ANA_PORT_PORT_CFG_PORTID_VAL_M,
+				       ANA_PORT_PORT_CFG, port);
+		} else {
+			ocelot_rmw_gix(ocelot,
+				       ANA_PORT_PORT_CFG_PORTID_VAL(port),
+				       ANA_PORT_PORT_CFG_PORTID_VAL_M,
+				       ANA_PORT_PORT_CFG, port);
+		}
 	}
 }
 
@@ -1361,7 +1377,7 @@ int ocelot_port_lag_join(struct ocelot *ocelot, int port,
 		ocelot->lags[lag] |= BIT(port);
 	}
 
-	ocelot_setup_lag(ocelot, lag);
+	ocelot_setup_logical_port_ids(ocelot);
 	ocelot_apply_bridge_fwd_mask(ocelot);
 	ocelot_set_aggr_pgids(ocelot);
 
@@ -1372,7 +1388,6 @@ EXPORT_SYMBOL(ocelot_port_lag_join);
 void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 			   struct net_device *bond)
 {
-	u32 port_cfg;
 	int i;
 
 	ocelot->ports[port]->bond = NULL;
@@ -1389,15 +1404,9 @@ void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 
 		ocelot->lags[n] = ocelot->lags[port];
 		ocelot->lags[port] = 0;
-
-		ocelot_setup_lag(ocelot, n);
 	}
 
-	port_cfg = ocelot_read_gix(ocelot, ANA_PORT_PORT_CFG, port);
-	port_cfg &= ~ANA_PORT_PORT_CFG_PORTID_VAL_M;
-	ocelot_write_gix(ocelot, port_cfg | ANA_PORT_PORT_CFG_PORTID_VAL(port),
-			 ANA_PORT_PORT_CFG, port);
-
+	ocelot_setup_logical_port_ids(ocelot);
 	ocelot_apply_bridge_fwd_mask(ocelot);
 	ocelot_set_aggr_pgids(ocelot);
 }
-- 
2.25.1


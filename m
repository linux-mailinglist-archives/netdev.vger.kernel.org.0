Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02BAC33DE76
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 21:16:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhCPUPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 16:15:37 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:33859 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbhCPUPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 16:15:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615925715; x=1647461715;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J1N2yaQPlWCiNsXBiqFpgtGeAPdiuEVucgbGCiZ229k=;
  b=vvqnxiPEYPyPr91h08pNh/tLF5CitX1VySs10YRfBgzvsCyMTI0izuub
   5jJSqqhnvIIztRenoUozy2yFxpjLLpptfWQ+f5FJYLSDEaxENtQYfBE6H
   rz0qPF24JeAilsSHcsrAW3qe3qpvM5bZa6I5Axxlg16hjVuPPhxPG6apW
   Swb8WHYWcOGuC3Ygvmx0bURD0TAMYSgNpy6uznJuJ/btO+y9Db9GXHI6A
   Xb4TMYq+qVp9cu6CYqxVzKJvEJgskT7c6QUeEslMODiIoD2k0SzwIWcRB
   0WdM3C4tjCBtnzbFAqVb5Y3lBVgBsEdAg3f+3z6Ve2yEg1tr4qlQTcDOw
   w==;
IronPort-SDR: 3weuBSqY9V8Vl1qmDiy3oPS5WBxrVcEy01tpesFW/RAAgLJ+X6tikl9vXCEVQ42Iu9BdoazNzh
 K9M7h2DhLPpKMDWUC9HGLu07o6Q8gQOEungHlQoaBXbbGQgH+VUCBYKRXCXRxnnSoqwIdy4Rq4
 x9FUa+kPCIoCY2R+HUgmVEHt+jDvf380xZPY/WVA+K1Cl0MzqPnLhX1p0XJqb274kzjihGyVdX
 dUjf9HOr7O78XTPWa7bjsmZNBWlQo3xkogVY1038PSPD0kT/wjGtKDMYzqIWuO7FY+MVlIVK2Q
 7Ms=
X-IronPort-AV: E=Sophos;i="5.81,254,1610434800"; 
   d="scan'208";a="112990707"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Mar 2021 13:15:13 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 16 Mar 2021 13:15:10 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Tue, 16 Mar 2021 13:15:07 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <vladimir.oltean@nxp.com>, <claudiu.manoil@nxp.com>,
        <alexandre.belloni@bootlin.com>, <andrew@lunn.ch>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>
CC:     <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 1/3] net: ocelot: Add PGID_BLACKHOLE
Date:   Tue, 16 Mar 2021 21:10:17 +0100
Message-ID: <20210316201019.3081237-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210316201019.3081237-1-horatiu.vultur@microchip.com>
References: <20210316201019.3081237-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new PGID that is used not to forward frames anywhere. It is used
by MRP to make sure that MRP Test frames will not reach CPU port.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 3 +++
 include/soc/mscc/ocelot.h          | 4 +++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 46e5c9136bac..f74d7cf002a5 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2051,6 +2051,9 @@ int ocelot_init(struct ocelot *ocelot)
 
 		ocelot_write_rix(ocelot, val, ANA_PGID_PGID, i);
 	}
+
+	ocelot_write_rix(ocelot, 0, ANA_PGID_PGID, PGID_BLACKHOLE);
+
 	/* Allow broadcast and unknown L2 multicast to the CPU. */
 	ocelot_rmw_rix(ocelot, ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports)),
 		       ANA_PGID_PGID_PGID(BIT(ocelot->num_phys_ports)),
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 425ff29d9389..4d10ccc8e7b5 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -51,6 +51,7 @@
  */
 
 /* Reserve some destination PGIDs at the end of the range:
+ * PGID_BLACKHOLE: used for not forwarding the frames
  * PGID_CPU: used for whitelisting certain MAC addresses, such as the addresses
  *           of the switch port net devices, towards the CPU port module.
  * PGID_UC: the flooding destinations for unknown unicast traffic.
@@ -59,6 +60,7 @@
  * PGID_MCIPV6: the flooding destinations for IPv6 multicast traffic.
  * PGID_BC: the flooding destinations for broadcast traffic.
  */
+#define PGID_BLACKHOLE			57
 #define PGID_CPU			58
 #define PGID_UC				59
 #define PGID_MC				60
@@ -73,7 +75,7 @@
 
 #define for_each_nonreserved_multicast_dest_pgid(ocelot, pgid)	\
 	for ((pgid) = (ocelot)->num_phys_ports + 1;		\
-	     (pgid) < PGID_CPU;					\
+	     (pgid) < PGID_BLACKHOLE;				\
 	     (pgid)++)
 
 #define for_each_aggr_pgid(ocelot, pgid)			\
-- 
2.30.1


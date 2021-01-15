Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC422F706C
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 03:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731974AbhAOCNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 21:13:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731910AbhAOCNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 21:13:11 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E255C061794
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 18:11:59 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id b2so7894382edm.3
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 18:11:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jDENi7HpH/M1pc+URxEC2bNvFNxdfuK/6ayvslhZVAI=;
        b=rEZaQZBgskhhMaSHKHw0Y4pilV+VwwrY9Q4FqOLm8LaIqgChgUjc0pZigqcnCp4exn
         8Ptoiw71tiC+Iqw+DBnCgTmbJ3auggvns6zD+JENvXj/TWJLWt1UsYCFVRKWNb/cYcYP
         BmEEH0kLlJYqwTtBLw6+JESidhQzBGU3mLDT0O63LrrjbJoTsFonD0gpOfYSQLbqcMx7
         MGXA80j1mhfxvG/XFIWuIK3UYA6ORdqljN1CHnRDeDw/xoVjFQg068rZifMnmiG2qKno
         cmBqagOtAmy4WoaUw8LGkUupXoTHuaMRf+5fPbeplz534eHh2Zm/v3FvTlX8RIv7aqbG
         QyxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jDENi7HpH/M1pc+URxEC2bNvFNxdfuK/6ayvslhZVAI=;
        b=TEkARzj/GvmWfu7H8O1UvZXuMP6xMnjGhcYrMwiKYmve2S1bhhlWO156ei0bu3f5bK
         YtiO152Rx63w4eO76JtjVwxxZFAhqyFJJ+nB+FCV85HLZsdGEvH028x+5gSjmXE/GjwH
         S7rKCWrTqiQdyjf7kXBl/ISYDNxJxlER+vXuFRK8k5u9RXbHafpY51AZaSm4GFziXHcd
         mUXTWqecdZOeJUYilZiM5/cDK0kk0DKV5+RFU/UP1UFGHAA+elOBvn9uzEJKlsdkeqgH
         DsEOqIWUFavZcFGAZsaiqCoPgFGgqYS49lbfdx7fkzdEAWUHWU1cY9U1Fj48yOh0F2P0
         V8eA==
X-Gm-Message-State: AOAM530s+sy484NAE6FeTlhyXbLo6UW9kIUuMeu9JMiQWwFYXm0KD4UC
        Gpb+ymHNNtx9l5HdCmsNTOw=
X-Google-Smtp-Source: ABdhPJwQKFawS6kQvAEdRKmAP/ePCvGjhcZthMR01U732rkAI93OiaU0H+PnsmNawGu+LmDf+IiZGg==
X-Received: by 2002:aa7:d9c3:: with SMTP id v3mr379241eds.133.1610676717773;
        Thu, 14 Jan 2021 18:11:57 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id oq27sm2596494ejb.108.2021.01.14.18.11.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 18:11:57 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH v6 net-next 09/10] net: mscc: ocelot: initialize watermarks to sane defaults
Date:   Fri, 15 Jan 2021 04:11:19 +0200
Message-Id: <20210115021120.3055988-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210115021120.3055988-1-olteanv@gmail.com>
References: <20210115021120.3055988-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This is meant to be a gentle introduction into the world of watermarks
on ocelot. The code is placed in ocelot_devlink.c because it will be
integrated with devlink, even if it isn't right now.

My first step was intended to be to replicate the default configuration
of the congestion watermarks programatically, since they are now going
to be tuned by the user.

But after studying and understanding through trial and error how they
work, I now believe that the configuration used out of reset does not do
justice to the word "reservation", since the sum of all reservations
exceeds the total amount of resources (otherwise said, all reservations
cannot be fulfilled at the same time, which means that, contrary to the
reference manual, they don't guarantee anything).

As an example, here's a dump of the reservation watermarks for frame
buffers, for port 0 (for brevity, the ports 1-6 were omitted, but they
have the same configuration):

BUF_Q_RSRV_I(port 0, prio 0) = max 3000 bytes
BUF_Q_RSRV_I(port 0, prio 1) = max 3000 bytes
BUF_Q_RSRV_I(port 0, prio 2) = max 3000 bytes
BUF_Q_RSRV_I(port 0, prio 3) = max 3000 bytes
BUF_Q_RSRV_I(port 0, prio 4) = max 3000 bytes
BUF_Q_RSRV_I(port 0, prio 5) = max 3000 bytes
BUF_Q_RSRV_I(port 0, prio 6) = max 3000 bytes
BUF_Q_RSRV_I(port 0, prio 7) = max 3000 bytes

Otherwise said, every port-tc has an ingress reservation of 3000 bytes,
and there are 7 ports in VSC9959 Felix (6 user ports and 1 CPU port).
Concentrating only on the ingress reservations, there are, in total,
8 [traffic classes] x 7 [ports] x 3000 [bytes] = 168,000 bytes of memory
reserved on ingress.
But, surprise, Felix only has 128 KB of packet buffer in total...
A similar thing happens with Seville, which has a larger packet buffer,
but also more ports, and the default configuration is also overcommitted.

This patch disables the (apparently) bogus reservations and moves all
resources to the shared area. This way, real reservations can be set up
by the user, using devlink-sb.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v6:
None.

Changes in v5:
None.

Changes in v4:
None.

Changes in v3:
None.

Changes in v2:
None.

 drivers/net/ethernet/mscc/Makefile         |   3 +-
 drivers/net/ethernet/mscc/ocelot.c         |   1 +
 drivers/net/ethernet/mscc/ocelot.h         |   1 +
 drivers/net/ethernet/mscc/ocelot_devlink.c | 442 +++++++++++++++++++++
 4 files changed, 446 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/mscc/ocelot_devlink.c

diff --git a/drivers/net/ethernet/mscc/Makefile b/drivers/net/ethernet/mscc/Makefile
index 58f94c3d80f9..346bba2730ad 100644
--- a/drivers/net/ethernet/mscc/Makefile
+++ b/drivers/net/ethernet/mscc/Makefile
@@ -6,7 +6,8 @@ mscc_ocelot_switch_lib-y := \
 	ocelot_police.o \
 	ocelot_vcap.o \
 	ocelot_flower.o \
-	ocelot_ptp.o
+	ocelot_ptp.o \
+	ocelot_devlink.o
 obj-$(CONFIG_MSCC_OCELOT_SWITCH) += mscc_ocelot.o
 mscc_ocelot-y := \
 	ocelot_vsc7514.o \
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 3af8e607c8a9..474ea5e59f89 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1624,6 +1624,7 @@ int ocelot_init(struct ocelot *ocelot)
 	INIT_DELAYED_WORK(&ocelot->stats_work, ocelot_check_stats_work);
 	queue_delayed_work(ocelot->stats_queue, &ocelot->stats_work,
 			   OCELOT_STATS_CHECK_DELAY);
+	ocelot_watermark_init(ocelot);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index e8621dbc14f7..48faa4dc893c 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -126,6 +126,7 @@ void ocelot_devlink_teardown(struct ocelot *ocelot);
 int ocelot_port_devlink_init(struct ocelot *ocelot, int port,
 			     enum devlink_port_flavour flavour);
 void ocelot_port_devlink_teardown(struct ocelot *ocelot, int port);
+void ocelot_watermark_init(struct ocelot *ocelot);
 
 extern struct notifier_block ocelot_netdevice_nb;
 extern struct notifier_block ocelot_switchdev_nb;
diff --git a/drivers/net/ethernet/mscc/ocelot_devlink.c b/drivers/net/ethernet/mscc/ocelot_devlink.c
new file mode 100644
index 000000000000..c58315b62841
--- /dev/null
+++ b/drivers/net/ethernet/mscc/ocelot_devlink.c
@@ -0,0 +1,442 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/* Copyright 2020-2021 NXP Semiconductors
+ */
+#include <net/devlink.h>
+#include "ocelot.h"
+
+/* The queue system tracks four resource consumptions:
+ * Resource 0: Memory tracked per source port
+ * Resource 1: Frame references tracked per source port
+ * Resource 2: Memory tracked per destination port
+ * Resource 3: Frame references tracked per destination port
+ */
+#define OCELOT_RESOURCE_SZ		256
+#define OCELOT_NUM_RESOURCES		4
+
+#define BUF_xxxx_I			(0 * OCELOT_RESOURCE_SZ)
+#define REF_xxxx_I			(1 * OCELOT_RESOURCE_SZ)
+#define BUF_xxxx_E			(2 * OCELOT_RESOURCE_SZ)
+#define REF_xxxx_E			(3 * OCELOT_RESOURCE_SZ)
+
+/* For each resource type there are 4 types of watermarks:
+ * Q_RSRV: reservation per QoS class per port
+ * PRIO_SHR: sharing watermark per QoS class across all ports
+ * P_RSRV: reservation per port
+ * COL_SHR: sharing watermark per color (drop precedence) across all ports
+ */
+#define xxx_Q_RSRV_x			0
+#define xxx_PRIO_SHR_x			216
+#define xxx_P_RSRV_x			224
+#define xxx_COL_SHR_x			254
+
+/* Reservation Watermarks
+ * ----------------------
+ *
+ * For setting up the reserved areas, egress watermarks exist per port and per
+ * QoS class for both ingress and egress.
+ */
+
+/*  Amount of packet buffer
+ *  |  per QoS class
+ *  |  |  reserved
+ *  |  |  |   per egress port
+ *  |  |  |   |
+ *  V  V  v   v
+ * BUF_Q_RSRV_E
+ */
+#define BUF_Q_RSRV_E(port, prio) \
+	(BUF_xxxx_E + xxx_Q_RSRV_x + OCELOT_NUM_TC * (port) + (prio))
+
+/*  Amount of packet buffer
+ *  |  for all port's traffic classes
+ *  |  |  reserved
+ *  |  |  |   per egress port
+ *  |  |  |   |
+ *  V  V  v   v
+ * BUF_P_RSRV_E
+ */
+#define BUF_P_RSRV_E(port) \
+	(BUF_xxxx_E + xxx_P_RSRV_x + (port))
+
+/*  Amount of packet buffer
+ *  |  per QoS class
+ *  |  |  reserved
+ *  |  |  |   per ingress port
+ *  |  |  |   |
+ *  V  V  v   v
+ * BUF_Q_RSRV_I
+ */
+#define BUF_Q_RSRV_I(port, prio) \
+	(BUF_xxxx_I + xxx_Q_RSRV_x + OCELOT_NUM_TC * (port) + (prio))
+
+/*  Amount of packet buffer
+ *  |  for all port's traffic classes
+ *  |  |  reserved
+ *  |  |  |   per ingress port
+ *  |  |  |   |
+ *  V  V  v   v
+ * BUF_P_RSRV_I
+ */
+#define BUF_P_RSRV_I(port) \
+	(BUF_xxxx_I + xxx_P_RSRV_x + (port))
+
+/*  Amount of frame references
+ *  |  per QoS class
+ *  |  |  reserved
+ *  |  |  |   per egress port
+ *  |  |  |   |
+ *  V  V  v   v
+ * REF_Q_RSRV_E
+ */
+#define REF_Q_RSRV_E(port, prio) \
+	(REF_xxxx_E + xxx_Q_RSRV_x + OCELOT_NUM_TC * (port) + (prio))
+
+/*  Amount of frame references
+ *  |  for all port's traffic classes
+ *  |  |  reserved
+ *  |  |  |   per egress port
+ *  |  |  |   |
+ *  V  V  v   v
+ * REF_P_RSRV_E
+ */
+#define REF_P_RSRV_E(port) \
+	(REF_xxxx_E + xxx_P_RSRV_x + (port))
+
+/*  Amount of frame references
+ *  |  per QoS class
+ *  |  |  reserved
+ *  |  |  |   per ingress port
+ *  |  |  |   |
+ *  V  V  v   v
+ * REF_Q_RSRV_I
+ */
+#define REF_Q_RSRV_I(port, prio) \
+	(REF_xxxx_I + xxx_Q_RSRV_x + OCELOT_NUM_TC * (port) + (prio))
+
+/*  Amount of frame references
+ *  |  for all port's traffic classes
+ *  |  |  reserved
+ *  |  |  |   per ingress port
+ *  |  |  |   |
+ *  V  V  v   v
+ * REF_P_RSRV_I
+ */
+#define REF_P_RSRV_I(port) \
+	(REF_xxxx_I + xxx_P_RSRV_x + (port))
+
+/* Sharing Watermarks
+ * ------------------
+ *
+ * The shared memory area is shared between all ports.
+ */
+
+/* Amount of buffer
+ *  |   per QoS class
+ *  |   |    from the shared memory area
+ *  |   |    |  for egress traffic
+ *  |   |    |  |
+ *  V   V    v  v
+ * BUF_PRIO_SHR_E
+ */
+#define BUF_PRIO_SHR_E(prio) \
+	(BUF_xxxx_E + xxx_PRIO_SHR_x + (prio))
+
+/* Amount of buffer
+ *  |   per color (drop precedence level)
+ *  |   |   from the shared memory area
+ *  |   |   |  for egress traffic
+ *  |   |   |  |
+ *  V   V   v  v
+ * BUF_COL_SHR_E
+ */
+#define BUF_COL_SHR_E(dp) \
+	(BUF_xxxx_E + xxx_COL_SHR_x + (1 - (dp)))
+
+/* Amount of buffer
+ *  |   per QoS class
+ *  |   |    from the shared memory area
+ *  |   |    |  for ingress traffic
+ *  |   |    |  |
+ *  V   V    v  v
+ * BUF_PRIO_SHR_I
+ */
+#define BUF_PRIO_SHR_I(prio) \
+	(BUF_xxxx_I + xxx_PRIO_SHR_x + (prio))
+
+/* Amount of buffer
+ *  |   per color (drop precedence level)
+ *  |   |   from the shared memory area
+ *  |   |   |  for ingress traffic
+ *  |   |   |  |
+ *  V   V   v  v
+ * BUF_COL_SHR_I
+ */
+#define BUF_COL_SHR_I(dp) \
+	(BUF_xxxx_I + xxx_COL_SHR_x + (1 - (dp)))
+
+/* Amount of frame references
+ *  |   per QoS class
+ *  |   |    from the shared area
+ *  |   |    |  for egress traffic
+ *  |   |    |  |
+ *  V   V    v  v
+ * REF_PRIO_SHR_E
+ */
+#define REF_PRIO_SHR_E(prio) \
+	(REF_xxxx_E + xxx_PRIO_SHR_x + (prio))
+
+/* Amount of frame references
+ *  |   per color (drop precedence level)
+ *  |   |   from the shared area
+ *  |   |   |  for egress traffic
+ *  |   |   |  |
+ *  V   V   v  v
+ * REF_COL_SHR_E
+ */
+#define REF_COL_SHR_E(dp) \
+	(REF_xxxx_E + xxx_COL_SHR_x + (1 - (dp)))
+
+/* Amount of frame references
+ *  |   per QoS class
+ *  |   |    from the shared area
+ *  |   |    |  for ingress traffic
+ *  |   |    |  |
+ *  V   V    v  v
+ * REF_PRIO_SHR_I
+ */
+#define REF_PRIO_SHR_I(prio) \
+	(REF_xxxx_I + xxx_PRIO_SHR_x + (prio))
+
+/* Amount of frame references
+ *  |   per color (drop precedence level)
+ *  |   |   from the shared area
+ *  |   |   |  for ingress traffic
+ *  |   |   |  |
+ *  V   V   v  v
+ * REF_COL_SHR_I
+ */
+#define REF_COL_SHR_I(dp) \
+	(REF_xxxx_I + xxx_COL_SHR_x + (1 - (dp)))
+
+static u32 ocelot_wm_read(struct ocelot *ocelot, int index)
+{
+	int wm = ocelot_read_gix(ocelot, QSYS_RES_CFG, index);
+
+	return ocelot->ops->wm_dec(wm);
+}
+
+static void ocelot_wm_write(struct ocelot *ocelot, int index, u32 val)
+{
+	u32 wm = ocelot->ops->wm_enc(val);
+
+	ocelot_write_gix(ocelot, wm, QSYS_RES_CFG, index);
+}
+
+/* The hardware comes out of reset with strange defaults: the sum of all
+ * reservations for frame memory is larger than the total buffer size.
+ * One has to wonder how can the reservation watermarks still guarantee
+ * anything under congestion.
+ * Bring some sense into the hardware by changing the defaults to disable all
+ * reservations and rely only on the sharing watermark for frames with drop
+ * precedence 0. The user can still explicitly request reservations per port
+ * and per port-tc through devlink-sb.
+ */
+static void ocelot_disable_reservation_watermarks(struct ocelot *ocelot,
+						  int port)
+{
+	int prio;
+
+	for (prio = 0; prio < OCELOT_NUM_TC; prio++) {
+		ocelot_wm_write(ocelot, BUF_Q_RSRV_I(port, prio), 0);
+		ocelot_wm_write(ocelot, BUF_Q_RSRV_E(port, prio), 0);
+		ocelot_wm_write(ocelot, REF_Q_RSRV_I(port, prio), 0);
+		ocelot_wm_write(ocelot, REF_Q_RSRV_E(port, prio), 0);
+	}
+
+	ocelot_wm_write(ocelot, BUF_P_RSRV_I(port), 0);
+	ocelot_wm_write(ocelot, BUF_P_RSRV_E(port), 0);
+	ocelot_wm_write(ocelot, REF_P_RSRV_I(port), 0);
+	ocelot_wm_write(ocelot, REF_P_RSRV_E(port), 0);
+}
+
+/* We want the sharing watermarks to consume all nonreserved resources, for
+ * efficient resource utilization (a single traffic flow should be able to use
+ * up the entire buffer space and frame resources as long as there's no
+ * interference).
+ * The switch has 10 sharing watermarks per lookup: 8 per traffic class and 2
+ * per color (drop precedence).
+ * The trouble with configuring these sharing watermarks is that:
+ * (1) There's a risk that we overcommit the resources if we configure
+ *     (a) all 8 per-TC sharing watermarks to the max
+ *     (b) all 2 per-color sharing watermarks to the max
+ * (2) There's a risk that we undercommit the resources if we configure
+ *     (a) all 8 per-TC sharing watermarks to "max / 8"
+ *     (b) all 2 per-color sharing watermarks to "max / 2"
+ * So for Linux, let's just disable the sharing watermarks per traffic class
+ * (setting them to 0 will make them always exceeded), and rely only on the
+ * sharing watermark for drop priority 0. So frames with drop priority set to 1
+ * by QoS classification or policing will still be allowed, but only as long as
+ * the port and port-TC reservations are not exceeded.
+ */
+static void ocelot_disable_tc_sharing_watermarks(struct ocelot *ocelot)
+{
+	int prio;
+
+	for (prio = 0; prio < OCELOT_NUM_TC; prio++) {
+		ocelot_wm_write(ocelot, BUF_PRIO_SHR_I(prio), 0);
+		ocelot_wm_write(ocelot, BUF_PRIO_SHR_E(prio), 0);
+		ocelot_wm_write(ocelot, REF_PRIO_SHR_I(prio), 0);
+		ocelot_wm_write(ocelot, REF_PRIO_SHR_E(prio), 0);
+	}
+}
+
+static void ocelot_get_buf_rsrv(struct ocelot *ocelot, u32 *buf_rsrv_i,
+				u32 *buf_rsrv_e)
+{
+	int port, prio;
+
+	*buf_rsrv_i = 0;
+	*buf_rsrv_e = 0;
+
+	for (port = 0; port <= ocelot->num_phys_ports; port++) {
+		for (prio = 0; prio < OCELOT_NUM_TC; prio++) {
+			*buf_rsrv_i += ocelot_wm_read(ocelot,
+						      BUF_Q_RSRV_I(port, prio));
+			*buf_rsrv_e += ocelot_wm_read(ocelot,
+						      BUF_Q_RSRV_E(port, prio));
+		}
+
+		*buf_rsrv_i += ocelot_wm_read(ocelot, BUF_P_RSRV_I(port));
+		*buf_rsrv_e += ocelot_wm_read(ocelot, BUF_P_RSRV_E(port));
+	}
+
+	*buf_rsrv_i *= OCELOT_BUFFER_CELL_SZ;
+	*buf_rsrv_e *= OCELOT_BUFFER_CELL_SZ;
+}
+
+static void ocelot_get_ref_rsrv(struct ocelot *ocelot, u32 *ref_rsrv_i,
+				u32 *ref_rsrv_e)
+{
+	int port, prio;
+
+	*ref_rsrv_i = 0;
+	*ref_rsrv_e = 0;
+
+	for (port = 0; port <= ocelot->num_phys_ports; port++) {
+		for (prio = 0; prio < OCELOT_NUM_TC; prio++) {
+			*ref_rsrv_i += ocelot_wm_read(ocelot,
+						      REF_Q_RSRV_I(port, prio));
+			*ref_rsrv_e += ocelot_wm_read(ocelot,
+						      REF_Q_RSRV_E(port, prio));
+		}
+
+		*ref_rsrv_i += ocelot_wm_read(ocelot, REF_P_RSRV_I(port));
+		*ref_rsrv_e += ocelot_wm_read(ocelot, REF_P_RSRV_E(port));
+	}
+}
+
+/* Calculate all reservations, then set up the sharing watermark for DP=0 to
+ * consume the remaining resources up to the pool's configured size.
+ */
+static void ocelot_setup_sharing_watermarks(struct ocelot *ocelot)
+{
+	u32 buf_rsrv_i, buf_rsrv_e;
+	u32 ref_rsrv_i, ref_rsrv_e;
+	u32 buf_shr_i, buf_shr_e;
+	u32 ref_shr_i, ref_shr_e;
+
+	ocelot_get_buf_rsrv(ocelot, &buf_rsrv_i, &buf_rsrv_e);
+	ocelot_get_ref_rsrv(ocelot, &ref_rsrv_i, &ref_rsrv_e);
+
+	buf_shr_i = ocelot->packet_buffer_size - buf_rsrv_i;
+	buf_shr_e = ocelot->packet_buffer_size - buf_rsrv_e;
+	ref_shr_i = ocelot->num_frame_refs - ref_rsrv_i;
+	ref_shr_e = ocelot->num_frame_refs - ref_rsrv_e;
+
+	buf_shr_i /= OCELOT_BUFFER_CELL_SZ;
+	buf_shr_e /= OCELOT_BUFFER_CELL_SZ;
+
+	ocelot_wm_write(ocelot, BUF_COL_SHR_I(0), buf_shr_i);
+	ocelot_wm_write(ocelot, BUF_COL_SHR_E(0), buf_shr_e);
+	ocelot_wm_write(ocelot, REF_COL_SHR_E(0), ref_shr_e);
+	ocelot_wm_write(ocelot, REF_COL_SHR_I(0), ref_shr_i);
+	ocelot_wm_write(ocelot, BUF_COL_SHR_I(1), 0);
+	ocelot_wm_write(ocelot, BUF_COL_SHR_E(1), 0);
+	ocelot_wm_write(ocelot, REF_COL_SHR_E(1), 0);
+	ocelot_wm_write(ocelot, REF_COL_SHR_I(1), 0);
+}
+
+/* The hardware works like this:
+ *
+ *                         Frame forwarding decision taken
+ *                                       |
+ *                                       v
+ *       +--------------------+--------------------+--------------------+
+ *       |                    |                    |                    |
+ *       v                    v                    v                    v
+ * Ingress memory       Egress memory        Ingress frame        Egress frame
+ *     check                check           reference check      reference check
+ *       |                    |                    |                    |
+ *       v                    v                    v                    v
+ *  BUF_Q_RSRV_I   ok    BUF_Q_RSRV_E   ok    REF_Q_RSRV_I   ok     REF_Q_RSRV_E   ok
+ *(src port, prio) -+  (dst port, prio) -+  (src port, prio) -+   (dst port, prio) -+
+ *       |          |         |          |         |          |         |           |
+ *       |exceeded  |         |exceeded  |         |exceeded  |         |exceeded   |
+ *       v          |         v          |         v          |         v           |
+ *  BUF_P_RSRV_I  ok|    BUF_P_RSRV_E  ok|    REF_P_RSRV_I  ok|    REF_P_RSRV_E   ok|
+ *   (src port) ----+     (dst port) ----+     (src port) ----+     (dst port) -----+
+ *       |          |         |          |         |          |         |           |
+ *       |exceeded  |         |exceeded  |         |exceeded  |         |exceeded   |
+ *       v          |         v          |         v          |         v           |
+ * BUF_PRIO_SHR_I ok|   BUF_PRIO_SHR_E ok|   REF_PRIO_SHR_I ok|   REF_PRIO_SHR_E  ok|
+ *     (prio) ------+       (prio) ------+       (prio) ------+       (prio) -------+
+ *       |          |         |          |         |          |         |           |
+ *       |exceeded  |         |exceeded  |         |exceeded  |         |exceeded   |
+ *       v          |         v          |         v          |         v           |
+ * BUF_COL_SHR_I  ok|   BUF_COL_SHR_E  ok|   REF_COL_SHR_I  ok|   REF_COL_SHR_E   ok|
+ *      (dp) -------+        (dp) -------+        (dp) -------+        (dp) --------+
+ *       |          |         |          |         |          |         |           |
+ *       |exceeded  |         |exceeded  |         |exceeded  |         |exceeded   |
+ *       v          v         v          v         v          v         v           v
+ *      fail     success     fail     success     fail     success     fail      success
+ *       |          |         |          |         |          |         |           |
+ *       v          v         v          v         v          v         v           v
+ *       +-----+----+         +-----+----+         +-----+----+         +-----+-----+
+ *             |                    |                    |                    |
+ *             +-------> OR <-------+                    +-------> OR <-------+
+ *                        |                                        |
+ *                        v                                        v
+ *                        +----------------> AND <-----------------+
+ *                                            |
+ *                                            v
+ *                                    FIFO drop / accept
+ *
+ * We are modeling each of the 4 parallel lookups as a devlink-sb pool.
+ * At least one (ingress or egress) memory pool and one (ingress or egress)
+ * frame reference pool need to have resources for frame acceptance to succeed.
+ *
+ * The following watermarks are controlled explicitly through devlink-sb:
+ * BUF_Q_RSRV_I, BUF_Q_RSRV_E, REF_Q_RSRV_I, REF_Q_RSRV_E
+ * BUF_P_RSRV_I, BUF_P_RSRV_E, REF_P_RSRV_I, REF_P_RSRV_E
+ * The following watermarks are controlled implicitly through devlink-sb:
+ * BUF_COL_SHR_I, BUF_COL_SHR_E, REF_COL_SHR_I, REF_COL_SHR_E
+ * The following watermarks are unused and disabled:
+ * BUF_PRIO_SHR_I, BUF_PRIO_SHR_E, REF_PRIO_SHR_I, REF_PRIO_SHR_E
+ *
+ * This function overrides the hardware defaults with more sane ones (no
+ * reservations by default, let sharing use all resources) and disables the
+ * unused watermarks.
+ */
+void ocelot_watermark_init(struct ocelot *ocelot)
+{
+	int all_tcs = GENMASK(OCELOT_NUM_TC - 1, 0);
+	int port;
+
+	ocelot_write(ocelot, all_tcs, QSYS_RES_QOS_MODE);
+
+	for (port = 0; port <= ocelot->num_phys_ports; port++)
+		ocelot_disable_reservation_watermarks(ocelot, port);
+
+	ocelot_disable_tc_sharing_watermarks(ocelot);
+	ocelot_setup_sharing_watermarks(ocelot);
+}
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC923196A71
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 01:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727907AbgC2AxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 20:53:10 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40421 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727848AbgC2AxJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 20:53:09 -0400
Received: by mail-wm1-f65.google.com with SMTP id a81so17165996wmf.5;
        Sat, 28 Mar 2020 17:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vnWprFzkK4xaIJG1JaKx5Z1U1u6aWn1Vmi7W7qDzbi4=;
        b=rqyz3pSR1flqOdNiBwvuxi7H3HwiA/B6uciI/acBKAbPWkr1YF6ENpfOHasuHnM/yf
         7mPwnPovbJcnqmKTDPvPTFNXaLV5Q0fQld0xnnfkOGuEYs/cLRgQb+aSvBME/f63h2Rd
         65Pbu3h/rTtzhJpBa8ASs0QDmIr3rNPYyZE8IL7PWd1OA8p9D81bRKFnZLZ3Z1Bm0xO1
         OwgJutxTgcIdHmezSll5zjlpMOT0pz2t/BSjt+fXXmAy7FbKE9VhD8JPPOruOCcp7Xnh
         MVaaGFrQAywIdLxMkh1WiDKvndy1zfxQNdKcjijhxxyRLfDzayrVFV0e2rYyV508ssSn
         EG5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vnWprFzkK4xaIJG1JaKx5Z1U1u6aWn1Vmi7W7qDzbi4=;
        b=gLsxqWVC5Dp+lUPRSS9wYmnpVZDw86VWXyfbPpmzlkV8zWr6vBSfuELr8fZirS12C3
         4yShrQ0fa0g5KQOyIGgLG2d9u0jTEbW14vciPPy0PUtecFDMte8FBXbih4m70KCkzGWs
         N+X24+QEXrb2qcAURyQGrc1ye55lsgRB8Y8UzxfesA25MbTb2+2LqheLfLCGNUHtC4KX
         N9HyWXuBgBHTrZDZ/Fi4Na4KEHS/VlTx+vzPyEbcqMCPw3b01KTGulNsd3z0Ho2O+DEu
         ZnXbx4ZK42tTHYI88zqrRZpkecBzqbuErRXIcf7eVkPmzCr7bNaqwbrcX0QgajMNd+VM
         C1cw==
X-Gm-Message-State: ANhLgQ2Pg85lVg6HgJFK66dIHR2aLb9+dLdaqJ4+L5A6yGEvV4MgPGkV
        PfXWUnLxG4sKvg8aKgtXoQU=
X-Google-Smtp-Source: ADFU+vsPWKapCy3MNkfB/BIzs6m1Dq23TLWu2pXOAhb3JhJ+2OX3bzanv+mnIouNIWhXYLyOhy8lcw==
X-Received: by 2002:a1c:3105:: with SMTP id x5mr6277153wmx.51.1585443186905;
        Sat, 28 Mar 2020 17:53:06 -0700 (PDT)
Received: from localhost.localdomain (5-12-96-237.residential.rdsnet.ro. [5.12.96.237])
        by smtp.gmail.com with ESMTPSA id l1sm8292652wme.14.2020.03.28.17.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2020 17:53:06 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        netdev@vger.kernel.org, xiaoliang.yang_1@nxp.com,
        linux-kernel@vger.kernel.org, horatiu.vultur@microchip.com,
        alexandre.belloni@bootlin.com, allan.nielsen@microchip.com,
        joergen.andreasen@microchip.com, UNGLinuxDriver@microchip.com,
        yangbo.lu@nxp.com, alexandru.marginean@nxp.com, po.liu@nxp.com,
        claudiu.manoil@nxp.com, leoyang.li@nxp.com
Subject: [PATCH net-next 4/6] net: dsa: felix: add port policers
Date:   Sun, 29 Mar 2020 02:52:00 +0200
Message-Id: <20200329005202.17926-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200329005202.17926-1-olteanv@gmail.com>
References: <20200329005202.17926-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This patch is a trivial passthrough towards the ocelot library, which
support port policers since commit 2c1d029a017f ("net: mscc: ocelot:
Implement port policers via tc command").

Some data structure conversion between the DSA core and the Ocelot
library is necessary, for policer parameters.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c            | 24 +++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_police.c |  3 +++
 drivers/net/ethernet/mscc/ocelot_police.h | 10 ----------
 drivers/net/ethernet/mscc/ocelot_tc.c     |  2 +-
 include/soc/mscc/ocelot.h                 |  8 ++++++++
 5 files changed, 36 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index eef9fa812a3c..7f7dd6736051 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -14,6 +14,7 @@
 #include <linux/of_net.h>
 #include <linux/pci.h>
 #include <linux/of.h>
+#include <net/pkt_sched.h>
 #include <net/dsa.h>
 #include "felix.h"
 
@@ -651,6 +652,27 @@ static int felix_cls_flower_stats(struct dsa_switch *ds, int port,
 	return ocelot_cls_flower_stats(ocelot, port, cls, ingress);
 }
 
+static int felix_port_policer_add(struct dsa_switch *ds, int port,
+				  struct dsa_mall_policer_tc_entry *policer)
+{
+	struct ocelot *ocelot = ds->priv;
+	struct ocelot_policer pol = {
+		.rate = div_u64(policer->rate_bytes_per_sec, 1000) * 8,
+		.burst = div_u64(policer->rate_bytes_per_sec *
+				 PSCHED_NS2TICKS(policer->burst),
+				 PSCHED_TICKS_PER_SEC),
+	};
+
+	return ocelot_port_policer_add(ocelot, port, &pol);
+}
+
+static void felix_port_policer_del(struct dsa_switch *ds, int port)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	ocelot_port_policer_del(ocelot, port);
+}
+
 static const struct dsa_switch_ops felix_switch_ops = {
 	.get_tag_protocol	= felix_get_tag_protocol,
 	.setup			= felix_setup,
@@ -684,6 +706,8 @@ static const struct dsa_switch_ops felix_switch_ops = {
 	.port_txtstamp		= felix_txtstamp,
 	.port_change_mtu	= felix_change_mtu,
 	.port_max_mtu		= felix_get_max_mtu,
+	.port_policer_add	= felix_port_policer_add,
+	.port_policer_del	= felix_port_policer_del,
 	.cls_flower_add		= felix_cls_flower_add,
 	.cls_flower_del		= felix_cls_flower_del,
 	.cls_flower_stats	= felix_cls_flower_stats,
diff --git a/drivers/net/ethernet/mscc/ocelot_police.c b/drivers/net/ethernet/mscc/ocelot_police.c
index 8d25b2706ff0..2e1d8e187332 100644
--- a/drivers/net/ethernet/mscc/ocelot_police.c
+++ b/drivers/net/ethernet/mscc/ocelot_police.c
@@ -4,6 +4,7 @@
  * Copyright (c) 2019 Microsemi Corporation
  */
 
+#include <soc/mscc/ocelot.h>
 #include "ocelot_police.h"
 
 enum mscc_qos_rate_mode {
@@ -203,6 +204,7 @@ int ocelot_port_policer_add(struct ocelot *ocelot, int port,
 
 	return 0;
 }
+EXPORT_SYMBOL(ocelot_port_policer_add);
 
 int ocelot_port_policer_del(struct ocelot *ocelot, int port)
 {
@@ -225,6 +227,7 @@ int ocelot_port_policer_del(struct ocelot *ocelot, int port)
 
 	return 0;
 }
+EXPORT_SYMBOL(ocelot_port_policer_del);
 
 int ocelot_ace_policer_add(struct ocelot *ocelot, u32 pol_ix,
 			   struct ocelot_policer *pol)
diff --git a/drivers/net/ethernet/mscc/ocelot_police.h b/drivers/net/ethernet/mscc/ocelot_police.h
index 22025cce0a6a..792abd28010a 100644
--- a/drivers/net/ethernet/mscc/ocelot_police.h
+++ b/drivers/net/ethernet/mscc/ocelot_police.h
@@ -9,16 +9,6 @@
 
 #include "ocelot.h"
 
-struct ocelot_policer {
-	u32 rate; /* kilobit per second */
-	u32 burst; /* bytes */
-};
-
-int ocelot_port_policer_add(struct ocelot *ocelot, int port,
-			    struct ocelot_policer *pol);
-
-int ocelot_port_policer_del(struct ocelot *ocelot, int port);
-
 int ocelot_ace_policer_add(struct ocelot *ocelot, u32 pol_ix,
 			   struct ocelot_policer *pol);
 
diff --git a/drivers/net/ethernet/mscc/ocelot_tc.c b/drivers/net/ethernet/mscc/ocelot_tc.c
index 3ff5ef41eccf..d326e231f0ad 100644
--- a/drivers/net/ethernet/mscc/ocelot_tc.c
+++ b/drivers/net/ethernet/mscc/ocelot_tc.c
@@ -4,8 +4,8 @@
  * Copyright (c) 2019 Microsemi Corporation
  */
 
+#include <soc/mscc/ocelot.h>
 #include "ocelot_tc.h"
-#include "ocelot_police.h"
 #include "ocelot_ace.h"
 #include <net/pkt_cls.h>
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 3db66638a3b2..ca49f7a114de 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -555,6 +555,11 @@ struct ocelot {
 	struct ptp_pin_desc		ptp_pins[OCELOT_PTP_PINS_NUM];
 };
 
+struct ocelot_policer {
+	u32 rate; /* kilobit per second */
+	u32 burst; /* bytes */
+};
+
 #define ocelot_read_ix(ocelot, reg, gi, ri) __ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
 #define ocelot_read_gix(ocelot, reg, gi) __ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi))
 #define ocelot_read_rix(ocelot, reg, ri) __ocelot_read_ix(ocelot, reg, reg##_RSZ * (ri))
@@ -624,6 +629,9 @@ int ocelot_port_add_txtstamp_skb(struct ocelot_port *ocelot_port,
 void ocelot_get_txtstamp(struct ocelot *ocelot);
 void ocelot_port_set_maxlen(struct ocelot *ocelot, int port, size_t sdu);
 int ocelot_get_max_mtu(struct ocelot *ocelot, int port);
+int ocelot_port_policer_add(struct ocelot *ocelot, int port,
+			    struct ocelot_policer *pol);
+int ocelot_port_policer_del(struct ocelot *ocelot, int port);
 int ocelot_cls_flower_replace(struct ocelot *ocelot, int port,
 			      struct flow_cls_offload *f, bool ingress);
 int ocelot_cls_flower_destroy(struct ocelot *ocelot, int port,
-- 
2.17.1


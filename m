Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB457196D1E
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 13:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbgC2Lw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 07:52:27 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46978 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728190AbgC2LwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 07:52:24 -0400
Received: by mail-wr1-f67.google.com with SMTP id j17so17434749wru.13;
        Sun, 29 Mar 2020 04:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+lpEOLjy9h66TxZTO0z5l0tqijaZvVY+fO4cZTa25Xs=;
        b=qESiwjhQ/kuvvzWrQPo/5C7exn71KcSn3fskOlnxn23HYfG38wh1nvX55hqCNxDBGc
         ES1bSGsxrPFuD0NJ2oqR2zIibFAYVuyD4L+7oNXNpciS2H4LTChYkNn6CMcv2HD6fSzz
         KbSb/v5oXF2Jfs8yLENp2qNhl8t897AuC4QqBZEpBBxEFxu70E3XQFI+YHIRl/jCoDYp
         VafI6Djed4cC8EocY1SdjZ+zxFHrbptwvya9mgtGX4XcCL4IzwN+mvXCsckSQhhxNnT4
         0Dp4iTo8kJ9BnDAOCxT5UkmUdzoFgqN3ru4DkyJKkdNiTfMQroYnerMvxOmu4sVfk7l3
         splg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+lpEOLjy9h66TxZTO0z5l0tqijaZvVY+fO4cZTa25Xs=;
        b=YgOe/HgWk3LM2ARY9/Yp7zWmJ+Q+p4Zw56O3/B237WJT7L8S2StIFNhmqEU6vDAXZc
         BPbo67XDotlWSGLr7rmeF8ji8dkdqtSUUSdh9pmNh47qdu9FXaEWI9EpV8ntedXWZutd
         /ww2R1NmRJiXDnDD8gvT2PAYSa5jlF7BYe0Jlj+GJuTlx3ITyRVNDbJMIwIwhNjjwcJK
         ezBgdr21EjYEX4iAeiOK0Zx6MmplAFfIwzPZCJfAZ6uBxqSv9VxfaI0c5B+wyXbpX0H6
         sU9sccbG58KqVUcZzKEolh62mc/Jz2O8QppQg1Mz3cMgTwGc8WqF0lWauyzBwmh04dzo
         iYaA==
X-Gm-Message-State: ANhLgQ2DGURXIYQBKpxtCe6GNOw0QGRJ7fZieHn1fK9+kIMgyzgIl2Oh
        C1xbfIggVgJ7Dy7JOkW6R7A=
X-Google-Smtp-Source: ADFU+vvqk7CAVk7GYzNNPZsaNyZaWlsNrGAlqHSK1qdMhDPkd/SLEMSahIol7iDw8PUAFk4L5wlZlA==
X-Received: by 2002:adf:91c3:: with SMTP id 61mr9391952wri.384.1585482742680;
        Sun, 29 Mar 2020 04:52:22 -0700 (PDT)
Received: from localhost.localdomain (5-12-96-237.residential.rdsnet.ro. [5.12.96.237])
        by smtp.gmail.com with ESMTPSA id 5sm14424108wrs.20.2020.03.29.04.52.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2020 04:52:22 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        netdev@vger.kernel.org, xiaoliang.yang_1@nxp.com,
        linux-kernel@vger.kernel.org, horatiu.vultur@microchip.com,
        alexandre.belloni@bootlin.com, allan.nielsen@microchip.com,
        joergen.andreasen@microchip.com, UNGLinuxDriver@microchip.com,
        yangbo.lu@nxp.com, alexandru.marginean@nxp.com, po.liu@nxp.com,
        claudiu.manoil@nxp.com, leoyang.li@nxp.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com
Subject: [PATCH v2 net-next 4/6] net: dsa: felix: add port policers
Date:   Sun, 29 Mar 2020 14:52:00 +0300
Message-Id: <20200329115202.16348-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200329115202.16348-1-olteanv@gmail.com>
References: <20200329115202.16348-1-olteanv@gmail.com>
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
Changes in v2:
Rebased on top of real net-next (I had a downstream patch causing
conflicts in this patch's context).

 drivers/net/dsa/ocelot/felix.c            | 24 +++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_police.c |  3 +++
 drivers/net/ethernet/mscc/ocelot_police.h | 10 ----------
 drivers/net/ethernet/mscc/ocelot_tc.c     |  2 +-
 include/soc/mscc/ocelot.h                 |  8 ++++++++
 5 files changed, 36 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index e2effeaa685e..79ca3aadb864 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -13,6 +13,7 @@
 #include <linux/of_net.h>
 #include <linux/pci.h>
 #include <linux/of.h>
+#include <net/pkt_sched.h>
 #include <net/dsa.h>
 #include "felix.h"
 
@@ -650,6 +651,27 @@ static int felix_cls_flower_stats(struct dsa_switch *ds, int port,
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
@@ -683,6 +705,8 @@ static const struct dsa_switch_ops felix_switch_ops = {
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
index b5d61af9f743..ebffcb36a7e3 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -549,6 +549,11 @@ struct ocelot {
 	spinlock_t			ptp_clock_lock;
 };
 
+struct ocelot_policer {
+	u32 rate; /* kilobit per second */
+	u32 burst; /* bytes */
+};
+
 #define ocelot_read_ix(ocelot, reg, gi, ri) __ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
 #define ocelot_read_gix(ocelot, reg, gi) __ocelot_read_ix(ocelot, reg, reg##_GSZ * (gi))
 #define ocelot_read_rix(ocelot, reg, ri) __ocelot_read_ix(ocelot, reg, reg##_RSZ * (ri))
@@ -619,6 +624,9 @@ int ocelot_port_add_txtstamp_skb(struct ocelot_port *ocelot_port,
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


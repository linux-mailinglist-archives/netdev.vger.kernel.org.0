Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E768321DE07
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 18:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730132AbgGMQ7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 12:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730000AbgGMQ66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 12:58:58 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30471C061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 09:58:58 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id dp18so18009738ejc.8
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 09:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DKAslmIb+Cb31EoG8ENNk8xfrUVjfPS4CwWKf7KQDZA=;
        b=p23pAfU5b6MG28p1EFxm/ZH6MX9oQzESlmoBzhmiu3N0E7cHHxGNbL4U4C8ghbbL6V
         ov6QgoSAqr0rucKvhu4ZYkJKMjCG2M9koicmIKuMjzA26xq91zTHmtNIYdEsxgXwSbsR
         jP4T+f96TAsW1IKryqMP3C5cEE00GuVfoslKm/aWry1uloEKBDnahnmZuMpO++0EO0L/
         iSDqo2og7gC43zaGAj2aSHu/pzjd3oiC8XvEx+q2qpryhjVq4lbI92RAi/ivxLRm2q6P
         TmYhLgfItF875D/Sc5dhcx3/nA+UfbLwEYwpo1VFOr1UqqscG1b6KtfcR60mallp/1us
         96kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DKAslmIb+Cb31EoG8ENNk8xfrUVjfPS4CwWKf7KQDZA=;
        b=Kvnv/u0KjUlJ+wHOvAZUtWOv7ZV6zRgnhSfug3y/+FJHiFBJ1yWg3B48X84TNIvAFp
         g8RZ7kzad0ewQfhoozFj3LBCxoOhEf63NzDiFySGnOtPJU+RzLKz1beK16vCQqSqnDwu
         T4VnnGQlhlUuxLoZsMHZ7cy+v2B6rDyRGWtN/1NIEVdOwFvR7mPqU3jgB5aX5W+6JFof
         xvvBBv6eP+KtdV4T7qS781ypgL8qrZEGzVrV4wFyntr7ZAZi1IioQPSHFzpjeDMSZ8JU
         15KpxerH6I8cu6fukkHnwkFu27E/3QdlVkQa1ISuqCzOzslAs4Jo+w9kAkaULnT0LHOG
         8D1w==
X-Gm-Message-State: AOAM5307d124buJjXLEtQjxoy0AHs8wThVv9xP/mVtJORDE1+Pir372s
        hTQBmbgbkBzg8A9aBd26EhA=
X-Google-Smtp-Source: ABdhPJyTQkxr2w8KdJNiLUQcDqK+qnc5nTEEKneeSMVPITQvsp6G009q30n45TfrkKgy4NGcxcCUsg==
X-Received: by 2002:a17:906:cecf:: with SMTP id si15mr621983ejb.508.1594659536789;
        Mon, 13 Jul 2020 09:58:56 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id y1sm12986732ede.7.2020.07.13.09.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 09:58:56 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        madalin.bucur@oss.nxp.com, radu-andrei.bulie@nxp.com,
        fido_max@inbox.ru
Subject: [PATCH v4 net-next 03/11] net: mscc: ocelot: convert QSYS_SWITCH_PORT_MODE and SYS_PORT_MODE to regfields
Date:   Mon, 13 Jul 2020 19:57:03 +0300
Message-Id: <20200713165711.2518150-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713165711.2518150-1-olteanv@gmail.com>
References: <20200713165711.2518150-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Currently Felix and Ocelot share the same bit layout in these per-port
registers, but Seville does not. So we need reg_fields for that.

Actually since these are per-port registers, we need to also specify the
number of ports, and register size per port, and use the regmap API for
multiple ports.

There's a more subtle point to be made about the other 2 register
fields:
- QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG
- QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE
which we are not writing any longer, for 2 reasons:
- Using the previous API (ocelot_write_rix), we were only writing 1 for
  Felix and Ocelot, which was their hardware-default value, and which
  there wasn't any intention in changing.
- In the case of SCH_NEXT_CFG, in fact Seville does not have this
  register field at all, and therefore, if we want to have common code
  we would be required to not write to it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v4:
- Rebased on top of patch "net: mscc: ocelot: move ocelot_regs.c into
  ocelot_vsc7514.c" which was merged since last submission.
- Actually stopped doing any more extraneous writes to anything except
  QSYS_SWITCH_PORT_MODE_PORT_ENA.

Changes in v3:
Clarified in the commit message why we're no longer writing to the
QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG register field.

Changes in v2:
None.

 drivers/net/dsa/ocelot/felix.c             |  9 ++----
 drivers/net/dsa/ocelot/felix_vsc9959.c     | 11 +++++++
 drivers/net/ethernet/mscc/ocelot.c         | 36 +++++++++-------------
 drivers/net/ethernet/mscc/ocelot.h         |  6 ----
 drivers/net/ethernet/mscc/ocelot_io.c      |  2 ++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 11 +++++++
 include/soc/mscc/ocelot.h                  | 15 +++++++++
 include/soc/mscc/ocelot_qsys.h             | 13 --------
 include/soc/mscc/ocelot_sys.h              | 13 --------
 9 files changed, 56 insertions(+), 60 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index bf0bd5c7b12c..4b255ed614e4 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -249,8 +249,7 @@ static void felix_phylink_mac_link_down(struct dsa_switch *ds, int port,
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 
 	ocelot_port_writel(ocelot_port, 0, DEV_MAC_ENA_CFG);
-	ocelot_rmw_rix(ocelot, 0, QSYS_SWITCH_PORT_MODE_PORT_ENA,
-		       QSYS_SWITCH_PORT_MODE, port);
+	ocelot_fields_write(ocelot, port, QSYS_SWITCH_PORT_MODE_PORT_ENA, 0);
 }
 
 static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
@@ -326,10 +325,8 @@ static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
 			 ANA_PORT_PORT_CFG, port);
 
 	/* Core: Enable port for frame transfer */
-	ocelot_write_rix(ocelot, QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE |
-			 QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG(1) |
-			 QSYS_SWITCH_PORT_MODE_PORT_ENA,
-			 QSYS_SWITCH_PORT_MODE, port);
+	ocelot_fields_write(ocelot, port,
+			    QSYS_SWITCH_PORT_MODE_PORT_ENA, 1);
 
 	if (felix->info->pcs_link_up)
 		felix->info->pcs_link_up(ocelot, port, link_an_mode, interface,
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index b97c12a783eb..efbfbdccb2b6 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -503,6 +503,17 @@ static const struct reg_field vsc9959_regfields[REGFIELD_MAX] = {
 	[ANA_TABLES_MACTINDX_M_INDEX] = REG_FIELD(ANA_TABLES_MACTINDX, 0, 10),
 	[SYS_RESET_CFG_CORE_ENA] = REG_FIELD(SYS_RESET_CFG, 0, 0),
 	[GCB_SOFT_RST_SWC_RST] = REG_FIELD(GCB_SOFT_RST, 0, 0),
+	/* Replicated per number of ports (7), register size 4 per port */
+	[QSYS_SWITCH_PORT_MODE_PORT_ENA] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 14, 14, 7, 4),
+	[QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 11, 13, 7, 4),
+	[QSYS_SWITCH_PORT_MODE_YEL_RSRVD] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 10, 10, 7, 4),
+	[QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 9, 9, 7, 4),
+	[QSYS_SWITCH_PORT_MODE_TX_PFC_ENA] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 1, 8, 7, 4),
+	[QSYS_SWITCH_PORT_MODE_TX_PFC_MODE] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 0, 0, 7, 4),
+	[SYS_PORT_MODE_DATA_WO_TS] = REG_FIELD_ID(SYS_PORT_MODE, 5, 6, 7, 4),
+	[SYS_PORT_MODE_INCL_INJ_HDR] = REG_FIELD_ID(SYS_PORT_MODE, 3, 4, 7, 4),
+	[SYS_PORT_MODE_INCL_XTR_HDR] = REG_FIELD_ID(SYS_PORT_MODE, 1, 2, 7, 4),
+	[SYS_PORT_MODE_INCL_HDR_ERR] = REG_FIELD_ID(SYS_PORT_MODE, 0, 0, 7, 4),
 };
 
 static const struct ocelot_stat_layout vsc9959_stats_layout[] = {
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index e815aad8d85e..36986fccedf4 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -389,10 +389,8 @@ void ocelot_adjust_link(struct ocelot *ocelot, int port,
 			 ANA_PFC_PFC_CFG, port);
 
 	/* Core: Enable port for frame transfer */
-	ocelot_write_rix(ocelot, QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE |
-			 QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG(1) |
-			 QSYS_SWITCH_PORT_MODE_PORT_ENA,
-			 QSYS_SWITCH_PORT_MODE, port);
+	ocelot_fields_write(ocelot, port,
+			    QSYS_SWITCH_PORT_MODE_PORT_ENA, 1);
 
 	/* Flow control */
 	ocelot_write_rix(ocelot, SYS_MAC_FC_CFG_PAUSE_VAL_CFG(0xffff) |
@@ -423,8 +421,7 @@ void ocelot_port_disable(struct ocelot *ocelot, int port)
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
 
 	ocelot_port_writel(ocelot_port, 0, DEV_MAC_ENA_CFG);
-	ocelot_rmw_rix(ocelot, 0, QSYS_SWITCH_PORT_MODE_PORT_ENA,
-		       QSYS_SWITCH_PORT_MODE, port);
+	ocelot_fields_write(ocelot, port, QSYS_SWITCH_PORT_MODE_PORT_ENA, 0);
 }
 EXPORT_SYMBOL(ocelot_port_disable);
 
@@ -1392,27 +1389,22 @@ void ocelot_configure_cpu(struct ocelot *ocelot, int npi,
 			     QSYS_EXT_CPU_CFG);
 
 		/* Enable NPI port */
-		ocelot_write_rix(ocelot,
-				 QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE |
-				 QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG(1) |
-				 QSYS_SWITCH_PORT_MODE_PORT_ENA,
-				 QSYS_SWITCH_PORT_MODE, npi);
+		ocelot_fields_write(ocelot, npi,
+				    QSYS_SWITCH_PORT_MODE_PORT_ENA, 1);
 		/* NPI port Injection/Extraction configuration */
-		ocelot_write_rix(ocelot,
-				 SYS_PORT_MODE_INCL_XTR_HDR(extraction) |
-				 SYS_PORT_MODE_INCL_INJ_HDR(injection),
-				 SYS_PORT_MODE, npi);
+		ocelot_fields_write(ocelot, npi, SYS_PORT_MODE_INCL_XTR_HDR,
+				    extraction);
+		ocelot_fields_write(ocelot, npi, SYS_PORT_MODE_INCL_INJ_HDR,
+				    injection);
 	}
 
 	/* Enable CPU port module */
-	ocelot_write_rix(ocelot, QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE |
-			 QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG(1) |
-			 QSYS_SWITCH_PORT_MODE_PORT_ENA,
-			 QSYS_SWITCH_PORT_MODE, cpu);
+	ocelot_fields_write(ocelot, cpu, QSYS_SWITCH_PORT_MODE_PORT_ENA, 1);
 	/* CPU port Injection/Extraction configuration */
-	ocelot_write_rix(ocelot, SYS_PORT_MODE_INCL_XTR_HDR(extraction) |
-			 SYS_PORT_MODE_INCL_INJ_HDR(injection),
-			 SYS_PORT_MODE, cpu);
+	ocelot_fields_write(ocelot, cpu, SYS_PORT_MODE_INCL_XTR_HDR,
+			    extraction);
+	ocelot_fields_write(ocelot, cpu, SYS_PORT_MODE_INCL_INJ_HDR,
+			    injection);
 
 	/* Configure the CPU port to be VLAN aware */
 	ocelot_write_gix(ocelot, ANA_PORT_VLAN_CFG_VLAN_VID(0) |
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index 814b09dd2c11..dc29e05103a1 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -102,9 +102,6 @@ void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
 u32 ocelot_port_readl(struct ocelot_port *port, u32 reg);
 void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg);
 
-#define ocelot_field_write(ocelot, reg, val) regmap_field_write((ocelot)->regfields[(reg)], (val))
-#define ocelot_field_read(ocelot, reg, val) regmap_field_read((ocelot)->regfields[(reg)], (val))
-
 int ocelot_probe_port(struct ocelot *ocelot, int port, struct regmap *target,
 		      struct phy_device *phy);
 
@@ -116,7 +113,4 @@ extern struct notifier_block ocelot_netdevice_nb;
 extern struct notifier_block ocelot_switchdev_nb;
 extern struct notifier_block ocelot_switchdev_blocking_nb;
 
-#define ocelot_field_write(ocelot, reg, val) regmap_field_write((ocelot)->regfields[(reg)], (val))
-#define ocelot_field_read(ocelot, reg, val) regmap_field_read((ocelot)->regfields[(reg)], (val))
-
 #endif
diff --git a/drivers/net/ethernet/mscc/ocelot_io.c b/drivers/net/ethernet/mscc/ocelot_io.c
index 741f653bc85b..d22711282183 100644
--- a/drivers/net/ethernet/mscc/ocelot_io.c
+++ b/drivers/net/ethernet/mscc/ocelot_io.c
@@ -89,6 +89,8 @@ int ocelot_regfields_init(struct ocelot *ocelot,
 		regfield.reg = ocelot->map[target][reg & REG_MASK];
 		regfield.lsb = regfields[i].lsb;
 		regfield.msb = regfields[i].msb;
+		regfield.id_size = regfields[i].id_size;
+		regfield.id_offset = regfields[i].id_offset;
 
 		ocelot->regfields[i] =
 		devm_regmap_field_alloc(ocelot->dev,
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 83c17c689641..9c6a9d44871d 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -358,6 +358,17 @@ static const struct reg_field ocelot_regfields[REGFIELD_MAX] = {
 	[SYS_RESET_CFG_CORE_ENA] = REG_FIELD(SYS_RESET_CFG, 2, 2),
 	[SYS_RESET_CFG_MEM_ENA] = REG_FIELD(SYS_RESET_CFG, 1, 1),
 	[SYS_RESET_CFG_MEM_INIT] = REG_FIELD(SYS_RESET_CFG, 0, 0),
+	/* Replicated per number of ports (11), register size 4 per port */
+	[QSYS_SWITCH_PORT_MODE_PORT_ENA] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 14, 14, 11, 4),
+	[QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 11, 13, 11, 4),
+	[QSYS_SWITCH_PORT_MODE_YEL_RSRVD] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 10, 10, 11, 4),
+	[QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 9, 9, 11, 4),
+	[QSYS_SWITCH_PORT_MODE_TX_PFC_ENA] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 1, 8, 11, 4),
+	[QSYS_SWITCH_PORT_MODE_TX_PFC_MODE] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 0, 0, 11, 4),
+	[SYS_PORT_MODE_DATA_WO_TS] = REG_FIELD_ID(SYS_PORT_MODE, 5, 6, 11, 4),
+	[SYS_PORT_MODE_INCL_INJ_HDR] = REG_FIELD_ID(SYS_PORT_MODE, 3, 4, 11, 4),
+	[SYS_PORT_MODE_INCL_XTR_HDR] = REG_FIELD_ID(SYS_PORT_MODE, 1, 2, 11, 4),
+	[SYS_PORT_MODE_INCL_HDR_ERR] = REG_FIELD_ID(SYS_PORT_MODE, 0, 0, 11, 4),
 };
 
 static const struct ocelot_stat_layout ocelot_stats_layout[] = {
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 348fa26a349c..19d97585345a 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -490,11 +490,21 @@ enum ocelot_regfield {
 	ANA_TABLES_MACACCESS_B_DOM,
 	ANA_TABLES_MACTINDX_BUCKET,
 	ANA_TABLES_MACTINDX_M_INDEX,
+	QSYS_SWITCH_PORT_MODE_PORT_ENA,
+	QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG,
+	QSYS_SWITCH_PORT_MODE_YEL_RSRVD,
+	QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE,
+	QSYS_SWITCH_PORT_MODE_TX_PFC_ENA,
+	QSYS_SWITCH_PORT_MODE_TX_PFC_MODE,
 	QSYS_TIMED_FRAME_ENTRY_TFRM_VLD,
 	QSYS_TIMED_FRAME_ENTRY_TFRM_FP,
 	QSYS_TIMED_FRAME_ENTRY_TFRM_PORTNO,
 	QSYS_TIMED_FRAME_ENTRY_TFRM_TM_SEL,
 	QSYS_TIMED_FRAME_ENTRY_TFRM_TM_T,
+	SYS_PORT_MODE_DATA_WO_TS,
+	SYS_PORT_MODE_INCL_INJ_HDR,
+	SYS_PORT_MODE_INCL_XTR_HDR,
+	SYS_PORT_MODE_INCL_HDR_ERR,
 	SYS_RESET_CFG_CORE_ENA,
 	SYS_RESET_CFG_MEM_ENA,
 	SYS_RESET_CFG_MEM_INIT,
@@ -638,6 +648,11 @@ struct ocelot_policer {
 #define ocelot_rmw_rix(ocelot, val, m, reg, ri) __ocelot_rmw_ix(ocelot, val, m, reg, reg##_RSZ * (ri))
 #define ocelot_rmw(ocelot, val, m, reg) __ocelot_rmw_ix(ocelot, val, m, reg, 0)
 
+#define ocelot_field_write(ocelot, reg, val) regmap_field_write((ocelot)->regfields[(reg)], (val))
+#define ocelot_field_read(ocelot, reg, val) regmap_field_read((ocelot)->regfields[(reg)], (val))
+#define ocelot_fields_write(ocelot, id, reg, val) regmap_fields_write((ocelot)->regfields[(reg)], (id), (val))
+#define ocelot_fields_read(ocelot, id, reg, val) regmap_fields_read((ocelot)->regfields[(reg)], (id), (val))
+
 /* I/O */
 u32 ocelot_port_readl(struct ocelot_port *port, u32 reg);
 void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg);
diff --git a/include/soc/mscc/ocelot_qsys.h b/include/soc/mscc/ocelot_qsys.h
index d8c63aa761be..a814bc2017d8 100644
--- a/include/soc/mscc/ocelot_qsys.h
+++ b/include/soc/mscc/ocelot_qsys.h
@@ -13,19 +13,6 @@
 #define QSYS_PORT_MODE_DEQUEUE_DIS                        BIT(1)
 #define QSYS_PORT_MODE_DEQUEUE_LATE                       BIT(0)
 
-#define QSYS_SWITCH_PORT_MODE_RSZ                         0x4
-
-#define QSYS_SWITCH_PORT_MODE_PORT_ENA                    BIT(14)
-#define QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG(x)             (((x) << 11) & GENMASK(13, 11))
-#define QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG_M              GENMASK(13, 11)
-#define QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG_X(x)           (((x) & GENMASK(13, 11)) >> 11)
-#define QSYS_SWITCH_PORT_MODE_YEL_RSRVD                   BIT(10)
-#define QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE           BIT(9)
-#define QSYS_SWITCH_PORT_MODE_TX_PFC_ENA(x)               (((x) << 1) & GENMASK(8, 1))
-#define QSYS_SWITCH_PORT_MODE_TX_PFC_ENA_M                GENMASK(8, 1)
-#define QSYS_SWITCH_PORT_MODE_TX_PFC_ENA_X(x)             (((x) & GENMASK(8, 1)) >> 1)
-#define QSYS_SWITCH_PORT_MODE_TX_PFC_MODE                 BIT(0)
-
 #define QSYS_STAT_CNT_CFG_TX_GREEN_CNT_MODE               BIT(5)
 #define QSYS_STAT_CNT_CFG_TX_YELLOW_CNT_MODE              BIT(4)
 #define QSYS_STAT_CNT_CFG_DROP_GREEN_CNT_MODE             BIT(3)
diff --git a/include/soc/mscc/ocelot_sys.h b/include/soc/mscc/ocelot_sys.h
index 16f91e172bcb..8a95fc93fde5 100644
--- a/include/soc/mscc/ocelot_sys.h
+++ b/include/soc/mscc/ocelot_sys.h
@@ -12,19 +12,6 @@
 
 #define SYS_COUNT_TX_OCTETS_RSZ                           0x4
 
-#define SYS_PORT_MODE_RSZ                                 0x4
-
-#define SYS_PORT_MODE_DATA_WO_TS(x)                       (((x) << 5) & GENMASK(6, 5))
-#define SYS_PORT_MODE_DATA_WO_TS_M                        GENMASK(6, 5)
-#define SYS_PORT_MODE_DATA_WO_TS_X(x)                     (((x) & GENMASK(6, 5)) >> 5)
-#define SYS_PORT_MODE_INCL_INJ_HDR(x)                     (((x) << 3) & GENMASK(4, 3))
-#define SYS_PORT_MODE_INCL_INJ_HDR_M                      GENMASK(4, 3)
-#define SYS_PORT_MODE_INCL_INJ_HDR_X(x)                   (((x) & GENMASK(4, 3)) >> 3)
-#define SYS_PORT_MODE_INCL_XTR_HDR(x)                     (((x) << 1) & GENMASK(2, 1))
-#define SYS_PORT_MODE_INCL_XTR_HDR_M                      GENMASK(2, 1)
-#define SYS_PORT_MODE_INCL_XTR_HDR_X(x)                   (((x) & GENMASK(2, 1)) >> 1)
-#define SYS_PORT_MODE_INJ_HDR_ERR                         BIT(0)
-
 #define SYS_FRONT_PORT_MODE_RSZ                           0x4
 
 #define SYS_FRONT_PORT_MODE_HDX_MODE                      BIT(0)
-- 
2.25.1


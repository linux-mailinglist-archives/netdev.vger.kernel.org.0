Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD4B21EB51B
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 07:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgFBFYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 01:24:02 -0400
Received: from inva021.nxp.com ([92.121.34.21]:40390 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726012AbgFBFYB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 01:24:01 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 169A4200944;
        Tue,  2 Jun 2020 07:23:59 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 5F595200948;
        Tue,  2 Jun 2020 07:23:49 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id C586D4030C;
        Tue,  2 Jun 2020 13:23:37 +0800 (SGT)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     xiaoliang.yang_1@nxp.com, po.liu@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, mingkai.hu@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jiri@resnulli.us, idosch@idosch.org,
        kuba@kernel.org, vinicius.gomes@intel.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com, joergen.andreasen@microchip.com,
        UNGLinuxDriver@microchip.com, linux-devel@linux.nxdi.nxp.com
Subject: [PATCH v2 net-next 01/10] net: mscc: ocelot: introduce a new ocelot_target_{read,write} API
Date:   Tue,  2 Jun 2020 13:18:19 +0800
Message-Id: <20200602051828.5734-2-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200602051828.5734-1-xiaoliang.yang_1@nxp.com>
References: <20200602051828.5734-1-xiaoliang.yang_1@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

There are some targets (register blocks) in the Ocelot switch that are
instantiated more than once. For example, the VCAP IS1, IS2 and ES0
blocks all share the same register layout for interacting with the cache
for the TCAM and the action RAM.

For the VCAPs, the procedure for servicing them is actually common. We
just need an API specifying which VCAP we are talking to, and we do that
via these raw ocelot_target_read and ocelot_target_write accessors.

In plain ocelot_read, the target is encoded into the register enum
itself:

	u16 target = reg >> TARGET_OFFSET;

For the VCAPs, the registers are currently defined like this:

	enum ocelot_reg {
	[...]
		S2_CORE_UPDATE_CTRL = S2 << TARGET_OFFSET,
		S2_CORE_MV_CFG,
		S2_CACHE_ENTRY_DAT,
		S2_CACHE_MASK_DAT,
		S2_CACHE_ACTION_DAT,
		S2_CACHE_CNT_DAT,
		S2_CACHE_TG_DAT,
	[...]
	};

which is precisely what we want to avoid, because we'd have to duplicate
the same register map for S1 and for S0, and then figure out how to pass
VCAP instance-specific registers to the ocelot_read calls (basically
another lookup table that undoes the effect of shifting with
TARGET_OFFSET).

So for some targets, propose a more raw API, similar to what is
currently done with ocelot_port_readl and ocelot_port_writel. Those
targets can only be accessed with ocelot_target_{read,write} and not
with ocelot_{read,write} after the conversion, which is fine.

The VCAP registers are not actually modified to use this new API as of
this patch. They will be modified in the next one.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_io.c | 17 +++++++++++++++++
 include/soc/mscc/ocelot.h             | 14 ++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_io.c b/drivers/net/ethernet/mscc/ocelot_io.c
index b229b1cb68ef..9b52d82f5399 100644
--- a/drivers/net/ethernet/mscc/ocelot_io.c
+++ b/drivers/net/ethernet/mscc/ocelot_io.c
@@ -59,6 +59,23 @@ void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg)
 }
 EXPORT_SYMBOL(ocelot_port_writel);
 
+u32 __ocelot_target_read_ix(struct ocelot *ocelot, enum ocelot_target target,
+			    u32 reg, u32 offset)
+{
+	u32 val;
+
+	regmap_read(ocelot->targets[target],
+		    ocelot->map[target][reg] + offset, &val);
+	return val;
+}
+
+void __ocelot_target_write_ix(struct ocelot *ocelot, enum ocelot_target target,
+			      u32 val, u32 reg, u32 offset)
+{
+	regmap_write(ocelot->targets[target],
+		     ocelot->map[target][reg] + offset, val);
+}
+
 int ocelot_regfields_init(struct ocelot *ocelot,
 			  const struct reg_field *const regfields)
 {
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 4953e9994df3..2ac08f3b8f68 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -578,6 +578,16 @@ struct ocelot_policer {
 #define ocelot_rmw_rix(ocelot, val, m, reg, ri) __ocelot_rmw_ix(ocelot, val, m, reg, reg##_RSZ * (ri))
 #define ocelot_rmw(ocelot, val, m, reg) __ocelot_rmw_ix(ocelot, val, m, reg, 0)
 
+#define ocelot_target_read_ix(ocelot, target, reg, gi, ri) __ocelot_target_read_ix(ocelot, target, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
+#define ocelot_target_read_gix(ocelot, target, reg, gi) __ocelot_target_read_ix(ocelot, target, reg, reg##_GSZ * (gi))
+#define ocelot_target_read_rix(ocelot, target, reg, ri) __ocelot_target_read_ix(ocelot, target, reg, reg##_RSZ * (ri))
+#define ocelot_target_read(ocelot, target, reg) __ocelot_target_read_ix(ocelot, target, reg, 0)
+
+#define ocelot_target_write_ix(ocelot, target, val, reg, gi, ri) __ocelot_target_write_ix(ocelot, target, val, reg, reg##_GSZ * (gi) + reg##_RSZ * (ri))
+#define ocelot_target_write_gix(ocelot, target, val, reg, gi) __ocelot_target_write_ix(ocelot, target, val, reg, reg##_GSZ * (gi))
+#define ocelot_target_write_rix(ocelot, target, val, reg, ri) __ocelot_target_write_ix(ocelot, target, val, reg, reg##_RSZ * (ri))
+#define ocelot_target_write(ocelot, target, val, reg) __ocelot_target_write_ix(ocelot, target, val, reg, 0)
+
 /* I/O */
 u32 ocelot_port_readl(struct ocelot_port *port, u32 reg);
 void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg);
@@ -585,6 +595,10 @@ u32 __ocelot_read_ix(struct ocelot *ocelot, u32 reg, u32 offset);
 void __ocelot_write_ix(struct ocelot *ocelot, u32 val, u32 reg, u32 offset);
 void __ocelot_rmw_ix(struct ocelot *ocelot, u32 val, u32 mask, u32 reg,
 		     u32 offset);
+u32 __ocelot_target_read_ix(struct ocelot *ocelot, enum ocelot_target target,
+			    u32 reg, u32 offset);
+void __ocelot_target_write_ix(struct ocelot *ocelot, enum ocelot_target target,
+			      u32 val, u32 reg, u32 offset);
 
 /* Hardware initialization */
 int ocelot_regfields_init(struct ocelot *ocelot,
-- 
2.17.1


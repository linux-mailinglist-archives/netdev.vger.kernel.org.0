Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBDC01D04E9
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 04:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbgEMCaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 22:30:18 -0400
Received: from inva020.nxp.com ([92.121.34.13]:41266 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728685AbgEMCaR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 22:30:17 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id A12DD1A12EB;
        Wed, 13 May 2020 04:30:15 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 06EE21A1329;
        Wed, 13 May 2020 04:30:06 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 7BF09402BE;
        Wed, 13 May 2020 10:29:53 +0800 (SGT)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     xiaoliang.yang_1@nxp.com, po.liu@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, mingkai.hu@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jiri@resnulli.us, idosch@idosch.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, horatiu.vultur@microchip.com,
        alexandre.belloni@bootlin.com, allan.nielsen@microchip.com,
        joergen.andreasen@microchip.com, UNGLinuxDriver@microchip.com,
        vinicius.gomes@intel.com, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, linux-devel@linux.nxdi.nxp.com
Subject: [PATCH v2 net-next 3/3] net: dsa: felix: add support Credit Based Shaper(CBS) for hardware offload
Date:   Wed, 13 May 2020 10:25:10 +0800
Message-Id: <20200513022510.18457-4-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200513022510.18457-1-xiaoliang.yang_1@nxp.com>
References: <20200513022510.18457-1-xiaoliang.yang_1@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VSC9959 hardware support the Credit Based Shaper(CBS) which part
of the IEEE-802.1Qav. This patch support sch_cbs set for VSC9959.

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 50 +++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index efdcc547e0c9..df4498c0e864 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -207,7 +207,7 @@ static const u32 vsc9959_qsys_regmap[] = {
 	REG(QSYS_QMAXSDU_CFG_6,			0x00f62c),
 	REG(QSYS_QMAXSDU_CFG_7,			0x00f648),
 	REG(QSYS_PREEMPTION_CFG,		0x00f664),
-	REG_RESERVED(QSYS_CIR_CFG),
+	REG(QSYS_CIR_CFG,			0x000000),
 	REG(QSYS_EIR_CFG,			0x000004),
 	REG(QSYS_SE_CFG,			0x000008),
 	REG(QSYS_SE_DWRR_CFG,			0x00000c),
@@ -1332,6 +1332,52 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
 	return ret;
 }
 
+static int vsc9959_qos_port_cbs_set(struct dsa_switch *ds, int port,
+				    struct tc_cbs_qopt_offload *cbs_qopt)
+{
+	struct ocelot *ocelot = ds->priv;
+	int port_ix = port * 8 + cbs_qopt->queue;
+	u32 rate, burst;
+
+	if (cbs_qopt->queue >= ds->num_tx_queues)
+		return -EINVAL;
+
+	if (!cbs_qopt->enable) {
+		ocelot_write_gix(ocelot, QSYS_CIR_CFG_CIR_RATE(0) |
+				 QSYS_CIR_CFG_CIR_BURST(0),
+				 QSYS_CIR_CFG, port_ix);
+
+		ocelot_rmw_gix(ocelot, 0, QSYS_SE_CFG_SE_AVB_ENA,
+			       QSYS_SE_CFG, port_ix);
+
+		return 0;
+	}
+
+	/* Rate unit is 100 kbps */
+	rate = DIV_ROUND_UP(cbs_qopt->idleslope, 100);
+	/* Avoid using zero rate */
+	rate = clamp_t(u32, rate, 1, GENMASK(14, 0));
+	/* Burst unit is 4kB */
+	burst = DIV_ROUND_UP(cbs_qopt->hicredit, 4096);
+	/* Avoid using zero burst size */
+	burst = clamp_t(u32, rate, 1, GENMASK(5, 0));
+	ocelot_write_gix(ocelot,
+			 QSYS_CIR_CFG_CIR_RATE(rate) |
+			 QSYS_CIR_CFG_CIR_BURST(burst),
+			 QSYS_CIR_CFG,
+			 port_ix);
+
+	ocelot_rmw_gix(ocelot,
+		       QSYS_SE_CFG_SE_FRM_MODE(0) |
+		       QSYS_SE_CFG_SE_AVB_ENA,
+		       QSYS_SE_CFG_SE_AVB_ENA |
+		       QSYS_SE_CFG_SE_FRM_MODE_M,
+		       QSYS_SE_CFG,
+		       port_ix);
+
+	return 0;
+}
+
 static int vsc9959_port_setup_tc(struct dsa_switch *ds, int port,
 				 enum tc_setup_type type,
 				 void *type_data)
@@ -1341,6 +1387,8 @@ static int vsc9959_port_setup_tc(struct dsa_switch *ds, int port,
 	switch (type) {
 	case TC_SETUP_QDISC_TAPRIO:
 		return vsc9959_qos_port_tas_set(ocelot, port, type_data);
+	case TC_SETUP_QDISC_CBS:
+		return vsc9959_qos_port_cbs_set(ds, port, type_data);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.17.1


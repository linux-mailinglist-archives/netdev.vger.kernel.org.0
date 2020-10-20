Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22352933D3
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 06:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391386AbgJTEOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 00:14:17 -0400
Received: from inva021.nxp.com ([92.121.34.21]:37688 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390069AbgJTEOO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 00:14:14 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 29160200477;
        Tue, 20 Oct 2020 06:14:12 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 9CDBA2006AC;
        Tue, 20 Oct 2020 06:14:04 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id CDBD0402FC;
        Tue, 20 Oct 2020 06:13:55 +0200 (CEST)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     vinicius.gomes@intel.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kuba@kernel.org,
        Jose.Abreu@synopsys.com, allan.nielsen@microchip.com,
        joergen.andreasen@microchip.com, UNGLinuxDriver@microchip.com,
        xiaoliang.yang_1@nxp.com, po.liu@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, mingkai.hu@nxp.com
Subject: [RFC, net-next 2/3] net: dsa: felix: add preempt queues set support for vsc9959
Date:   Tue, 20 Oct 2020 12:04:57 +0800
Message-Id: <20201020040458.39794-3-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201020040458.39794-1-xiaoliang.yang_1@nxp.com>
References: <20201020040458.39794-1-xiaoliang.yang_1@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VSC9959 support preempt queues according to 802.1qbu and 802.3br. This
patch add ethtool preempt set to configure preemption.

In user space, it can be set like this:
	ethtool --set-frame-preemption swp0 enable min-frag-size 0

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c         | 26 ++++++++++++++
 drivers/net/dsa/ocelot/felix.h         |  4 +++
 drivers/net/dsa/ocelot/felix_vsc9959.c | 49 ++++++++++++++++++++++++++
 include/soc/mscc/ocelot.h              | 11 ++++++
 include/soc/mscc/ocelot_dev.h          | 23 ++++++++++++
 5 files changed, 113 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index f791860d495f..e08effbeb6bf 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -350,6 +350,30 @@ static int felix_get_ts_info(struct dsa_switch *ds, int port,
 	return ocelot_get_ts_info(ocelot, port, info);
 }
 
+static int felix_set_preempt(struct dsa_switch *ds, int port,
+			     struct ethtool_fp *fpcmd)
+{
+	struct ocelot *ocelot = ds->priv;
+	struct felix *felix = ocelot_to_felix(ocelot);
+
+	if (felix->info->port_set_preempt)
+		return felix->info->port_set_preempt(ocelot, port, fpcmd);
+
+	return -EOPNOTSUPP;
+}
+
+static int felix_get_preempt(struct dsa_switch *ds, int port,
+			     struct ethtool_fp *fpcmd)
+{
+	struct ocelot *ocelot = ds->priv;
+	struct felix *felix = ocelot_to_felix(ocelot);
+
+	if (felix->info->port_get_preempt)
+		return felix->info->port_get_preempt(ocelot, port, fpcmd);
+
+	return -EOPNOTSUPP;
+}
+
 static int felix_parse_ports_node(struct felix *felix,
 				  struct device_node *ports_node,
 				  phy_interface_t *port_phy_modes)
@@ -777,6 +801,8 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.get_ethtool_stats	= felix_get_ethtool_stats,
 	.get_sset_count		= felix_get_sset_count,
 	.get_ts_info		= felix_get_ts_info,
+	.set_preempt		= felix_set_preempt,
+	.get_preempt		= felix_get_preempt,
 	.phylink_validate	= felix_phylink_validate,
 	.phylink_mac_config	= felix_phylink_mac_config,
 	.phylink_mac_link_down	= felix_phylink_mac_link_down,
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 4c717324ac2f..e0c93d4a351d 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -37,6 +37,10 @@ struct felix_info {
 	void	(*port_sched_speed_set)(struct ocelot *ocelot, int port,
 					u32 speed);
 	void	(*xmit_template_populate)(struct ocelot *ocelot, int port);
+	int	(*port_set_preempt)(struct ocelot *ocelot, int port,
+				    struct ethtool_fp *fpcmd);
+	int	(*port_get_preempt)(struct ocelot *ocelot, int port,
+				    struct ethtool_fp *fpcmd);
 };
 
 extern const struct dsa_switch_ops felix_switch_ops;
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 3e925b8d5306..c0e41d499639 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -5,6 +5,7 @@
 #include <linux/fsl/enetc_mdio.h>
 #include <soc/mscc/ocelot_qsys.h>
 #include <soc/mscc/ocelot_vcap.h>
+#include <soc/mscc/ocelot_dev.h>
 #include <soc/mscc/ocelot_ptp.h>
 #include <soc/mscc/ocelot_sys.h>
 #include <soc/mscc/ocelot.h>
@@ -340,6 +341,10 @@ static const u32 vsc9959_dev_gmii_regmap[] = {
 	REG(DEV_MAC_FC_MAC_LOW_CFG,		0x3c),
 	REG(DEV_MAC_FC_MAC_HIGH_CFG,		0x40),
 	REG(DEV_MAC_STICKY,			0x44),
+	REG(DEV_MM_ENABLE_CONFIG,		0x48),
+	REG(DEV_MM_VERIF_CONFIG,		0x4c),
+	REG(DEV_MM_STATUS,			0x50),
+
 	REG_RESERVED(PCS1G_CFG),
 	REG_RESERVED(PCS1G_MODE_CFG),
 	REG_RESERVED(PCS1G_SD_CFG),
@@ -1321,6 +1326,48 @@ static int vsc9959_port_setup_tc(struct dsa_switch *ds, int port,
 	}
 }
 
+static int vsc9959_port_set_preempt(struct ocelot *ocelot, int port,
+				    struct ethtool_fp *fpcmd)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	int mm_fragsize = fpcmd->min_frag_size_mult;
+
+	if (mm_fragsize > 3)
+		return -EINVAL;
+
+	ocelot_port_rmwl(ocelot_port,
+			 (fpcmd->enabled ?
+			  (DEV_MM_CONFIG_ENABLE_CONFIG_MM_RX_ENA |
+			   DEV_MM_CONFIG_ENABLE_CONFIG_MM_TX_ENA) : 0),
+			 DEV_MM_CONFIG_ENABLE_CONFIG_MM_RX_ENA |
+			 DEV_MM_CONFIG_ENABLE_CONFIG_MM_TX_ENA,
+			 DEV_MM_ENABLE_CONFIG);
+
+	ocelot_rmw_rix(ocelot,
+		       QSYS_PREEMPTION_CFG_MM_ADD_FRAG_SIZE(mm_fragsize),
+		       QSYS_PREEMPTION_CFG_MM_ADD_FRAG_SIZE_M,
+		       QSYS_PREEMPTION_CFG,
+		       port);
+
+	return 0;
+}
+
+static int vsc9959_port_get_preempt(struct ocelot *ocelot, int port,
+				    struct ethtool_fp *fpcmd)
+{
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	u32 val;
+
+	val = ocelot_port_readl(ocelot_port, DEV_MM_VERIF_CONFIG);
+	val &= DEV_MM_CONFIG_VERIF_CONFIG_PRM_VERIFY_DIS;
+	fpcmd->enabled = (val ? 0 : 1);
+
+	val = ocelot_read(ocelot, QSYS_PREEMPTION_CFG);
+	fpcmd->min_frag_size_mult = QSYS_PREEMPTION_CFG_MM_ADD_FRAG_SIZE_X(val);
+
+	return 0;
+}
+
 static void vsc9959_xmit_template_populate(struct ocelot *ocelot, int port)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
@@ -1369,6 +1416,8 @@ static const struct felix_info felix_info_vsc9959 = {
 	.prevalidate_phy_mode	= vsc9959_prevalidate_phy_mode,
 	.port_setup_tc		= vsc9959_port_setup_tc,
 	.port_sched_speed_set	= vsc9959_sched_speed_set,
+	.port_set_preempt	= vsc9959_port_set_preempt,
+	.port_get_preempt	= vsc9959_port_get_preempt,
 	.xmit_template_populate	= vsc9959_xmit_template_populate,
 };
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 1e9db9577441..5ccfbf193ed9 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -426,6 +426,9 @@ enum ocelot_reg {
 	DEV_MAC_FC_MAC_LOW_CFG,
 	DEV_MAC_FC_MAC_HIGH_CFG,
 	DEV_MAC_STICKY,
+	DEV_MM_ENABLE_CONFIG,
+	DEV_MM_VERIF_CONFIG,
+	DEV_MM_STATUS,
 	PCS1G_CFG,
 	PCS1G_MODE_CFG,
 	PCS1G_SD_CFG,
@@ -709,6 +712,14 @@ u32 __ocelot_target_read_ix(struct ocelot *ocelot, enum ocelot_target target,
 void __ocelot_target_write_ix(struct ocelot *ocelot, enum ocelot_target target,
 			      u32 val, u32 reg, u32 offset);
 
+static inline void ocelot_port_rmwl(struct ocelot_port *port, u32 val,
+				    u32 mask, u32 reg)
+{
+	u32 cur = ocelot_port_readl(port, reg);
+
+	ocelot_port_writel(port, (cur & (~mask)) | val, reg);
+};
+
 /* Hardware initialization */
 int ocelot_regfields_init(struct ocelot *ocelot,
 			  const struct reg_field *const regfields);
diff --git a/include/soc/mscc/ocelot_dev.h b/include/soc/mscc/ocelot_dev.h
index 0c6021f02fee..cb1d8f5a62ee 100644
--- a/include/soc/mscc/ocelot_dev.h
+++ b/include/soc/mscc/ocelot_dev.h
@@ -93,6 +93,29 @@
 #define DEV_MAC_STICKY_TX_FRM_LEN_OVR_STICKY              BIT(1)
 #define DEV_MAC_STICKY_TX_ABORT_STICKY                    BIT(0)
 
+#define DEV_MM_CONFIG_ENABLE_CONFIG_MM_RX_ENA        BIT(0)
+#define DEV_MM_CONFIG_ENABLE_CONFIG_MM_TX_ENA        BIT(4)
+#define DEV_MM_CONFIG_ENABLE_CONFIG_KEEP_S_AFTER_D   BIT(8)
+
+#define DEV_MM_CONFIG_VERIF_CONFIG_PRM_VERIFY_DIS    BIT(0)
+#define DEV_MM_CONFIG_VERIF_CONFIG_PRM_VERIFY_TIME(x) (((x) << 4) & GENMASK(11, 4))
+#define DEV_MM_CONFIG_VERIF_CONFIG_PRM_VERIFY_TIME_M GENMASK(11, 4)
+#define DEV_MM_CONFIG_VERIF_CONFIG_PRM_VERIFY_TIME_X(x) (((x) & GENMASK(11, 4)) >> 4)
+#define DEV_MM_CONFIG_VERIF_CONFIG_VERIF_TIMER_UNITS(x) (((x) << 12) & GENMASK(13, 12))
+#define DEV_MM_CONFIG_VERIF_CONFIG_VERIF_TIMER_UNITS_M GENMASK(13, 12)
+#define DEV_MM_CONFIG_VERIF_CONFIG_VERIF_TIMER_UNITS_X(x) (((x) & GENMASK(13, 12)) >> 12)
+
+#define DEV_MM_STATISTICS_MM_STATUS_PRMPT_ACTIVE_STATUS BIT(0)
+#define DEV_MM_STATISTICS_MM_STATUS_PRMPT_ACTIVE_STICKY BIT(4)
+#define DEV_MM_STATISTICS_MM_STATUS_PRMPT_VERIFY_STATE(x) (((x) << 8) & GENMASK(10, 8))
+#define DEV_MM_STATISTICS_MM_STATUS_PRMPT_VERIFY_STATE_M GENMASK(10, 8)
+#define DEV_MM_STATISTICS_MM_STATUS_PRMPT_VERIFY_STATE_X(x) (((x) & GENMASK(10, 8)) >> 8)
+#define DEV_MM_STATISTICS_MM_STATUS_UNEXP_RX_PFRM_STICKY BIT(12)
+#define DEV_MM_STATISTICS_MM_STATUS_UNEXP_TX_PFRM_STICKY BIT(16)
+#define DEV_MM_STATISTICS_MM_STATUS_MM_RX_FRAME_STATUS BIT(20)
+#define DEV_MM_STATISTICS_MM_STATUS_MM_TX_FRAME_STATUS BIT(24)
+#define DEV_MM_STATISTICS_MM_STATUS_MM_TX_PRMPT_STATUS BIT(28)
+
 #define PCS1G_CFG_LINK_STATUS_TYPE                        BIT(4)
 #define PCS1G_CFG_AN_LINK_CTRL_ENA                        BIT(1)
 #define PCS1G_CFG_PCS_ENA                                 BIT(0)
-- 
2.18.4


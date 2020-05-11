Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 503301CD166
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 07:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbgEKFsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 01:48:37 -0400
Received: from inva020.nxp.com ([92.121.34.13]:40282 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728365AbgEKFsg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 01:48:36 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 1371E1A0AA6;
        Mon, 11 May 2020 07:48:33 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 5708C1A0A8D;
        Mon, 11 May 2020 07:48:23 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 89C804028F;
        Mon, 11 May 2020 13:48:10 +0800 (SGT)
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
Subject: [PATCH v1 net-next 2/3] net: dsa: felix: Configure Time-Aware Scheduler via taprio offload
Date:   Mon, 11 May 2020 13:43:31 +0800
Message-Id: <20200511054332.37690-3-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200511054332.37690-1-xiaoliang.yang_1@nxp.com>
References: <20200511054332.37690-1-xiaoliang.yang_1@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ocelot VSC9959 switch supports time-based egress shaping in hardware
according to IEEE 802.1Qbv. This patch add support for TAS configuration
on egress port of VSC9959 switch.

Felix driver is an instance of Ocelot family, with a DSA front-end. The
patch uses tc taprio hardware offload to setup TAS set function on felix
driver.

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c         |  10 +-
 drivers/net/dsa/ocelot/felix.h         |   5 +
 drivers/net/dsa/ocelot/felix_vsc9959.c | 140 +++++++++++++++++++++++++
 3 files changed, 154 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 0afdc6fc3f57..edd693d59b8e 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -237,6 +237,10 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
 
 	if (felix->info->pcs_init)
 		felix->info->pcs_init(ocelot, port, link_an_mode, state);
+
+	if (felix->info->port_sched_speed_set)
+		felix->info->port_sched_speed_set(ocelot, port,
+						  state->speed);
 }
 
 static void felix_phylink_mac_an_restart(struct dsa_switch *ds, int port)
@@ -710,7 +714,7 @@ static void felix_port_policer_del(struct dsa_switch *ds, int port)
 	ocelot_port_policer_del(ocelot, port);
 }
 
-static const struct dsa_switch_ops felix_switch_ops = {
+static struct dsa_switch_ops felix_switch_ops = {
 	.get_tag_protocol	= felix_get_tag_protocol,
 	.setup			= felix_setup,
 	.teardown		= felix_teardown,
@@ -827,6 +831,9 @@ static int felix_pci_probe(struct pci_dev *pdev,
 
 	ocelot->ptp = 1;
 
+	if (felix->info->port_setup_tc)
+		felix_switch_ops.port_setup_tc = felix->info->port_setup_tc;
+
 	ds = kzalloc(sizeof(struct dsa_switch), GFP_KERNEL);
 	if (!ds) {
 		err = -ENOMEM;
@@ -836,6 +843,7 @@ static int felix_pci_probe(struct pci_dev *pdev,
 
 	ds->dev = &pdev->dev;
 	ds->num_ports = felix->info->num_ports;
+	ds->num_tx_queues = felix->info->num_tx_queues;
 	ds->ops = &felix_switch_ops;
 	ds->priv = ocelot;
 	felix->ds = ds;
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 0d4ec34309c7..24b13526fcf2 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -20,6 +20,7 @@ struct felix_info {
 	const struct ocelot_stat_layout	*stats_layout;
 	unsigned int			num_stats;
 	int				num_ports;
+	int                             num_tx_queues;
 	struct vcap_field		*vcap_is2_keys;
 	struct vcap_field		*vcap_is2_actions;
 	const struct vcap_props		*vcap;
@@ -36,6 +37,10 @@ struct felix_info {
 	int	(*prevalidate_phy_mode)(struct ocelot *ocelot, int port,
 					phy_interface_t phy_mode);
 	void	(*port_qos_map_init)(struct ocelot *ocelot, int port);
+	int	(*port_setup_tc)(struct dsa_switch *ds, int port,
+				 enum tc_setup_type type, void *type_data);
+	void	(*port_sched_speed_set)(struct ocelot *ocelot, int port,
+					u32 speed);
 };
 
 extern struct felix_info		felix_info_vsc9959;
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 5c931fb3e4cd..ccbd875c7a47 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -3,10 +3,13 @@
  * Copyright 2018-2019 NXP Semiconductors
  */
 #include <linux/fsl/enetc_mdio.h>
+#include <soc/mscc/ocelot_qsys.h>
 #include <soc/mscc/ocelot_vcap.h>
 #include <soc/mscc/ocelot_ana.h>
+#include <soc/mscc/ocelot_ptp.h>
 #include <soc/mscc/ocelot_sys.h>
 #include <soc/mscc/ocelot.h>
+#include <net/pkt_sched.h>
 #include <linux/iopoll.h>
 #include <linux/pci.h>
 #include "felix.h"
@@ -28,6 +31,8 @@
 #define USXGMII_LPA_DUPLEX(lpa)		(((lpa) & GENMASK(12, 12)) >> 12)
 #define USXGMII_LPA_SPEED(lpa)		(((lpa) & GENMASK(11, 9)) >> 9)
 
+#define VSC9959_TAS_GCL_ENTRY_MAX	63
+
 enum usxgmii_speed {
 	USXGMII_SPEED_10	= 0,
 	USXGMII_SPEED_100	= 1,
@@ -1231,6 +1236,138 @@ static void vsc9959_port_qos_map_init(struct ocelot *ocelot, int port)
 	}
 }
 
+static void vsc9959_sched_speed_set(struct ocelot *ocelot, int port,
+				    u32 speed)
+{
+	ocelot_rmw_rix(ocelot,
+		       QSYS_TAG_CONFIG_LINK_SPEED(speed),
+		       QSYS_TAG_CONFIG_LINK_SPEED_M,
+		       QSYS_TAG_CONFIG, port);
+}
+
+static void vsc9959_new_base_time(struct ocelot *ocelot, ktime_t base_time,
+				  u64 cycle_time,
+				  struct timespec64 *new_base_ts)
+{
+	struct timespec64 ts;
+	ktime_t new_base_time;
+	ktime_t current_time;
+
+	ocelot_ptp_gettime64(&ocelot->ptp_info, &ts);
+	current_time = timespec64_to_ktime(ts);
+	new_base_time = base_time;
+
+	if (base_time < current_time) {
+		u64 nr_of_cycles = current_time - base_time;
+
+		do_div(nr_of_cycles, cycle_time);
+		new_base_time += cycle_time * (nr_of_cycles + 1);
+	}
+
+	*new_base_ts = ktime_to_timespec64(new_base_time);
+}
+
+static u32 vsc9959_tas_read_cfg_status(struct ocelot *ocelot)
+{
+	return ocelot_read(ocelot, QSYS_TAS_PARAM_CFG_CTRL);
+}
+
+static void vsc9959_tas_gcl_set(struct ocelot *ocelot, const u32 gcl_ix,
+				struct tc_taprio_sched_entry *entry)
+{
+	ocelot_write(ocelot,
+		     QSYS_GCL_CFG_REG_1_GCL_ENTRY_NUM(gcl_ix) |
+		     QSYS_GCL_CFG_REG_1_GATE_STATE(entry->gate_mask),
+		     QSYS_GCL_CFG_REG_1);
+	ocelot_write(ocelot, entry->interval, QSYS_GCL_CFG_REG_2);
+}
+
+static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
+				    struct tc_taprio_qopt_offload *taprio)
+{
+	struct timespec64 base_ts;
+	int ret, i;
+	u32 val;
+
+	if (!taprio->enable) {
+		ocelot_rmw_rix(ocelot,
+			       QSYS_TAG_CONFIG_INIT_GATE_STATE(0xFF),
+			       QSYS_TAG_CONFIG_ENABLE |
+			       QSYS_TAG_CONFIG_INIT_GATE_STATE_M,
+			       QSYS_TAG_CONFIG, port);
+
+		return 0;
+	}
+
+	if (taprio->cycle_time > NSEC_PER_SEC ||
+	    taprio->cycle_time_extension >= NSEC_PER_SEC)
+		return -EINVAL;
+
+	if (taprio->num_entries > VSC9959_TAS_GCL_ENTRY_MAX)
+		return -ERANGE;
+
+	ocelot_rmw(ocelot, QSYS_TAS_PARAM_CFG_CTRL_PORT_NUM(port) |
+		   QSYS_TAS_PARAM_CFG_CTRL_ALWAYS_GUARD_BAND_SCH_Q,
+		   QSYS_TAS_PARAM_CFG_CTRL_PORT_NUM_M |
+		   QSYS_TAS_PARAM_CFG_CTRL_ALWAYS_GUARD_BAND_SCH_Q,
+		   QSYS_TAS_PARAM_CFG_CTRL);
+
+	/* Hardware errata -  Admin config could not be overwritten if
+	 * config is pending, need reset the TAS module
+	 */
+	val = ocelot_read(ocelot, QSYS_PARAM_STATUS_REG_8);
+	if (val & QSYS_PARAM_STATUS_REG_8_CONFIG_PENDING)
+		return  -EBUSY;
+
+	ocelot_rmw_rix(ocelot,
+		       QSYS_TAG_CONFIG_ENABLE |
+		       QSYS_TAG_CONFIG_INIT_GATE_STATE(0xFF) |
+		       QSYS_TAG_CONFIG_SCH_TRAFFIC_QUEUES(0xFF),
+		       QSYS_TAG_CONFIG_ENABLE |
+		       QSYS_TAG_CONFIG_INIT_GATE_STATE_M |
+		       QSYS_TAG_CONFIG_SCH_TRAFFIC_QUEUES_M,
+		       QSYS_TAG_CONFIG, port);
+
+	vsc9959_new_base_time(ocelot, taprio->base_time,
+			      taprio->cycle_time, &base_ts);
+	ocelot_write(ocelot, base_ts.tv_nsec, QSYS_PARAM_CFG_REG_1);
+	ocelot_write(ocelot, lower_32_bits(base_ts.tv_sec), QSYS_PARAM_CFG_REG_2);
+	val = upper_32_bits(base_ts.tv_sec);
+	ocelot_write(ocelot,
+		     QSYS_PARAM_CFG_REG_3_BASE_TIME_SEC_MSB(val) |
+		     QSYS_PARAM_CFG_REG_3_LIST_LENGTH(taprio->num_entries),
+		     QSYS_PARAM_CFG_REG_3);
+	ocelot_write(ocelot, taprio->cycle_time, QSYS_PARAM_CFG_REG_4);
+	ocelot_write(ocelot, taprio->cycle_time_extension, QSYS_PARAM_CFG_REG_5);
+
+	for (i = 0; i < taprio->num_entries; i++)
+		vsc9959_tas_gcl_set(ocelot, i, &taprio->entries[i]);
+
+	ocelot_rmw(ocelot, QSYS_TAS_PARAM_CFG_CTRL_CONFIG_CHANGE,
+		   QSYS_TAS_PARAM_CFG_CTRL_CONFIG_CHANGE,
+		   QSYS_TAS_PARAM_CFG_CTRL);
+
+	ret = readx_poll_timeout(vsc9959_tas_read_cfg_status, ocelot, val,
+				 !(val & QSYS_TAS_PARAM_CFG_CTRL_CONFIG_CHANGE),
+				 10, 100000);
+
+	return ret;
+}
+
+static int vsc9959_port_setup_tc(struct dsa_switch *ds, int port,
+				 enum tc_setup_type type,
+				 void *type_data)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	switch (type) {
+	case TC_SETUP_QDISC_TAPRIO:
+		return vsc9959_qos_port_tas_set(ocelot, port, type_data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 struct felix_info felix_info_vsc9959 = {
 	.target_io_res		= vsc9959_target_io_res,
 	.port_io_res		= vsc9959_port_io_res,
@@ -1246,6 +1383,7 @@ struct felix_info felix_info_vsc9959 = {
 	.shared_queue_sz	= 128 * 1024,
 	.num_mact_rows		= 2048,
 	.num_ports		= 6,
+	.num_tx_queues		= FELIX_NUM_TC,
 	.switch_pci_bar		= 4,
 	.imdio_pci_bar		= 0,
 	.mdio_bus_alloc		= vsc9959_mdio_bus_alloc,
@@ -1255,4 +1393,6 @@ struct felix_info felix_info_vsc9959 = {
 	.pcs_link_state		= vsc9959_pcs_link_state,
 	.prevalidate_phy_mode	= vsc9959_prevalidate_phy_mode,
 	.port_qos_map_init	= vsc9959_port_qos_map_init,
+	.port_setup_tc          = vsc9959_port_setup_tc,
+	.port_sched_speed_set   = vsc9959_sched_speed_set,
 };
-- 
2.17.1


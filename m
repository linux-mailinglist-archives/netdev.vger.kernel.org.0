Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AEAF1CD164
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 07:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728562AbgEKFse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 01:48:34 -0400
Received: from inva021.nxp.com ([92.121.34.21]:33622 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728301AbgEKFsc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 01:48:32 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 04A5C200AC9;
        Mon, 11 May 2020 07:48:30 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 38E63200AC2;
        Mon, 11 May 2020 07:48:20 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id B91BD402D3;
        Mon, 11 May 2020 13:48:06 +0800 (SGT)
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
Subject: [PATCH v1 net-next 1/3] net: dsa: felix: qos classified based on pcp
Date:   Mon, 11 May 2020 13:43:30 +0800
Message-Id: <20200511054332.37690-2-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200511054332.37690-1-xiaoliang.yang_1@nxp.com>
References: <20200511054332.37690-1-xiaoliang.yang_1@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set the default QoS Classification based on PCP and DEI of vlan tag,
after that, frames can be Classified to different Qos based on PCP tag.
If there is no vlan tag or vlan ignored, use port default Qos.

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c         |  6 ++++++
 drivers/net/dsa/ocelot/felix.h         |  1 +
 drivers/net/dsa/ocelot/felix_vsc9959.c | 23 +++++++++++++++++++++++
 3 files changed, 30 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index a2dfd73f8a1a..0afdc6fc3f57 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -547,6 +547,12 @@ static int felix_setup(struct dsa_switch *ds)
 			ocelot_configure_cpu(ocelot, port,
 					     OCELOT_TAG_PREFIX_NONE,
 					     OCELOT_TAG_PREFIX_LONG);
+
+		/* Set the default QoS Classification based on PCP and DEI
+		 * bits of vlan tag.
+		 */
+		if (felix->info->port_qos_map_init)
+			felix->info->port_qos_map_init(ocelot, port);
 	}
 
 	/* Include the CPU port module in the forwarding mask for unknown
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index b94386fa8d63..0d4ec34309c7 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -35,6 +35,7 @@ struct felix_info {
 				  struct phylink_link_state *state);
 	int	(*prevalidate_phy_mode)(struct ocelot *ocelot, int port,
 					phy_interface_t phy_mode);
+	void	(*port_qos_map_init)(struct ocelot *ocelot, int port);
 };
 
 extern struct felix_info		felix_info_vsc9959;
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 1c56568d5aca..5c931fb3e4cd 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -4,6 +4,7 @@
  */
 #include <linux/fsl/enetc_mdio.h>
 #include <soc/mscc/ocelot_vcap.h>
+#include <soc/mscc/ocelot_ana.h>
 #include <soc/mscc/ocelot_sys.h>
 #include <soc/mscc/ocelot.h>
 #include <linux/iopoll.h>
@@ -1209,6 +1210,27 @@ static void vsc9959_mdio_bus_free(struct ocelot *ocelot)
 	mdiobus_unregister(felix->imdio);
 }
 
+static void vsc9959_port_qos_map_init(struct ocelot *ocelot, int port)
+{
+	int i;
+
+	ocelot_rmw_gix(ocelot,
+		       ANA_PORT_QOS_CFG_QOS_PCP_ENA,
+		       ANA_PORT_QOS_CFG_QOS_PCP_ENA,
+		       ANA_PORT_QOS_CFG,
+		       port);
+
+	for (i = 0; i < FELIX_NUM_TC * 2; i++) {
+		ocelot_rmw_ix(ocelot,
+			      (ANA_PORT_PCP_DEI_MAP_DP_PCP_DEI_VAL & i) |
+			      ANA_PORT_PCP_DEI_MAP_QOS_PCP_DEI_VAL(i),
+			      ANA_PORT_PCP_DEI_MAP_DP_PCP_DEI_VAL |
+			      ANA_PORT_PCP_DEI_MAP_QOS_PCP_DEI_VAL_M,
+			      ANA_PORT_PCP_DEI_MAP,
+			      port, i);
+	}
+}
+
 struct felix_info felix_info_vsc9959 = {
 	.target_io_res		= vsc9959_target_io_res,
 	.port_io_res		= vsc9959_port_io_res,
@@ -1232,4 +1254,5 @@ struct felix_info felix_info_vsc9959 = {
 	.pcs_an_restart		= vsc9959_pcs_an_restart,
 	.pcs_link_state		= vsc9959_pcs_link_state,
 	.prevalidate_phy_mode	= vsc9959_prevalidate_phy_mode,
+	.port_qos_map_init	= vsc9959_port_qos_map_init,
 };
-- 
2.17.1


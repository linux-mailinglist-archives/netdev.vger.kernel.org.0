Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF4121D04EB
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 04:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728693AbgEMCaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 22:30:16 -0400
Received: from inva020.nxp.com ([92.121.34.13]:40920 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728590AbgEMCaM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 May 2020 22:30:12 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 3A9E31A130A;
        Wed, 13 May 2020 04:30:10 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id AC9491A132C;
        Wed, 13 May 2020 04:30:00 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 4054F402BC;
        Wed, 13 May 2020 10:29:48 +0800 (SGT)
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
Subject: [PATCH v2 net-next 1/3] net: dsa: felix: qos classified based on pcp
Date:   Wed, 13 May 2020 10:25:08 +0800
Message-Id: <20200513022510.18457-2-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200513022510.18457-1-xiaoliang.yang_1@nxp.com>
References: <20200513022510.18457-1-xiaoliang.yang_1@nxp.com>
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
 drivers/net/dsa/ocelot/felix.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index a2dfd73f8a1a..58d6b0f454e5 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -289,6 +289,27 @@ static void felix_phylink_mac_link_up(struct dsa_switch *ds, int port,
 			 QSYS_SWITCH_PORT_MODE, port);
 }
 
+static void felix_port_qos_map_init(struct ocelot *ocelot, int port)
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
 static void felix_get_strings(struct dsa_switch *ds, int port,
 			      u32 stringset, u8 *data)
 {
@@ -547,6 +568,11 @@ static int felix_setup(struct dsa_switch *ds)
 			ocelot_configure_cpu(ocelot, port,
 					     OCELOT_TAG_PREFIX_NONE,
 					     OCELOT_TAG_PREFIX_LONG);
+
+		/* Set the default QoS Classification based on PCP and DEI
+		 * bits of vlan tag.
+		 */
+		felix_port_qos_map_init(ocelot, port);
 	}
 
 	/* Include the CPU port module in the forwarding mask for unknown
-- 
2.17.1


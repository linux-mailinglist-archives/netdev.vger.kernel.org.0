Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C23F276634
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 04:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbgIXCGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 22:06:10 -0400
Received: from inva020.nxp.com ([92.121.34.13]:36340 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725208AbgIXCGK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 22:06:10 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id B85551A0489;
        Thu, 24 Sep 2020 04:06:08 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id E42D11A0CD5;
        Thu, 24 Sep 2020 04:06:03 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id B8A4D4029A;
        Thu, 24 Sep 2020 04:05:57 +0200 (CEST)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     xiaoliang.yang_1@nxp.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        allan.nielsen@microchip.com, joergen.andreasen@microchip.com,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        po.liu@nxp.com, claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com
Subject: [net] net: dsa: felix: convert TAS link speed based on phylink speed
Date:   Thu, 24 Sep 2020 09:57:46 +0800
Message-Id: <20200924015746.7994-1-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

state->speed holds a value of 10, 100, 1000 or 2500, but
QSYS_TAG_CONFIG_LINK_SPEED expects a value of 0, 1, 2, 3. So convert the
speed to a proper value.

Fixes: de143c0e274b ("net: dsa: felix: Configure Time-Aware Scheduler via taprio offload")
Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 6855c94256f8..36db631a55e6 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1284,8 +1284,28 @@ void vsc9959_mdio_bus_free(struct ocelot *ocelot)
 static void vsc9959_sched_speed_set(struct ocelot *ocelot, int port,
 				    u32 speed)
 {
+	u8 tas_speed;
+
+	switch (speed) {
+	case SPEED_10:
+		tas_speed = OCELOT_SPEED_10;
+		break;
+	case SPEED_100:
+		tas_speed = OCELOT_SPEED_100;
+		break;
+	case SPEED_1000:
+		tas_speed = OCELOT_SPEED_1000;
+		break;
+	case SPEED_2500:
+		tas_speed = OCELOT_SPEED_2500;
+		break;
+	default:
+		tas_speed = OCELOT_SPEED_1000;
+		break;
+	}
+
 	ocelot_rmw_rix(ocelot,
-		       QSYS_TAG_CONFIG_LINK_SPEED(speed),
+		       QSYS_TAG_CONFIG_LINK_SPEED(tas_speed),
 		       QSYS_TAG_CONFIG_LINK_SPEED_M,
 		       QSYS_TAG_CONFIG, port);
 }
-- 
2.17.1


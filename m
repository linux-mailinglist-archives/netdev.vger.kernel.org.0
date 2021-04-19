Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0126363F6F
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 12:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232563AbhDSKVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 06:21:30 -0400
Received: from inva020.nxp.com ([92.121.34.13]:35950 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238459AbhDSKVB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 06:21:01 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 2B2A01A16AC;
        Mon, 19 Apr 2021 12:19:24 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id DAFC21A1308;
        Mon, 19 Apr 2021 12:19:14 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 0D9BB40291;
        Mon, 19 Apr 2021 12:19:02 +0200 (CEST)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     xiaoliang.yang_1@nxp.com, Arvid.Brodin@xdin.com,
        m-karicheri2@ti.com, vinicius.gomes@intel.com,
        michael.chan@broadcom.com, vishal@chelsio.com, saeedm@mellanox.com,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        ivan.khoronzhuk@linaro.org, andre.guedes@linux.intel.com,
        yuehaibing@huawei.com, allan.nielsen@microchip.com,
        joergen.andreasen@microchip.com, colin.king@canonical.com,
        po.liu@nxp.com, mingkai.hu@nxp.com, claudiu.manoil@nxp.com,
        vladimir.oltean@nxp.com, leoyang.li@nxp.com
Subject: [net-next] net: dsa: felix: disable always guard band bit for TAS config
Date:   Mon, 19 Apr 2021 18:25:30 +0800
Message-Id: <20210419102530.20361-1-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ALWAYS_GUARD_BAND_SCH_Q bit in TAS config register is descripted as
this:
	0: Guard band is implemented for nonschedule queues to schedule
	   queues transition.
	1: Guard band is implemented for any queue to schedule queue
	   transition.

The driver set guard band be implemented for any queue to schedule queue
transition before, which will make each GCL time slot reserve a guard
band time that can pass the max SDU frame. Because guard band time could
not be set in tc-taprio now, it will use about 12000ns to pass 1500B max
SDU. This limits each GCL time interval to be more than 12000ns.

This patch change the guard band to be only implemented for nonschedule
queues to schedule queues transition, so that there is no need to reserve
guard band on each GCL. Users can manually add guard band time for each
schedule queues in their configuration if they want.

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 789fe08cae50..2473bebe48e6 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1227,8 +1227,12 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
 	if (taprio->num_entries > VSC9959_TAS_GCL_ENTRY_MAX)
 		return -ERANGE;
 
-	ocelot_rmw(ocelot, QSYS_TAS_PARAM_CFG_CTRL_PORT_NUM(port) |
-		   QSYS_TAS_PARAM_CFG_CTRL_ALWAYS_GUARD_BAND_SCH_Q,
+	/* Set port num and disable ALWAYS_GUARD_BAND_SCH_Q, which means set
+	 * guard band to be implemented for nonschedule queues to schedule
+	 * queues transition.
+	 */
+	ocelot_rmw(ocelot,
+		   QSYS_TAS_PARAM_CFG_CTRL_PORT_NUM(port),
 		   QSYS_TAS_PARAM_CFG_CTRL_PORT_NUM_M |
 		   QSYS_TAS_PARAM_CFG_CTRL_ALWAYS_GUARD_BAND_SCH_Q,
 		   QSYS_TAS_PARAM_CFG_CTRL);
-- 
2.17.1


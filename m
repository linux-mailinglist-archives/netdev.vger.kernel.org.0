Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEEBF2933D5
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 06:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391409AbgJTEOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 00:14:25 -0400
Received: from inva021.nxp.com ([92.121.34.21]:37728 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391367AbgJTEOP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 00:14:15 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 8892420048B;
        Tue, 20 Oct 2020 06:14:13 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 5C8C020051C;
        Tue, 20 Oct 2020 06:14:06 +0200 (CEST)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 88CCD40243;
        Tue, 20 Oct 2020 06:13:57 +0200 (CEST)
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
Subject: [RFC, net-next 3/3] net: dsa: felix: tc-taprio preempt set support
Date:   Tue, 20 Oct 2020 12:04:58 +0800
Message-Id: <20201020040458.39794-4-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201020040458.39794-1-xiaoliang.yang_1@nxp.com>
References: <20201020040458.39794-1-xiaoliang.yang_1@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After using ethtool to enable and configure frame preemption on
vsc9959, use tc-taprio preempt set to mark the preempt queues and
express queueus.

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index c0e41d499639..f2b9a5ee1ff5 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1310,6 +1310,20 @@ static int vsc9959_qos_port_cbs_set(struct dsa_switch *ds, int port,
 	return 0;
 }
 
+static int vsc9959_port_preempt_queues(struct ocelot *ocelot, int port,
+				       struct tc_preempt_qopt_offload *qopt)
+{
+	u8 p_queues = qopt->preemptible_queues;
+
+	ocelot_rmw_rix(ocelot,
+		       QSYS_PREEMPTION_CFG_P_QUEUES(p_queues),
+		       QSYS_PREEMPTION_CFG_P_QUEUES_M,
+		       QSYS_PREEMPTION_CFG,
+		       port);
+
+	return 0;
+}
+
 static int vsc9959_port_setup_tc(struct dsa_switch *ds, int port,
 				 enum tc_setup_type type,
 				 void *type_data)
@@ -1321,6 +1335,8 @@ static int vsc9959_port_setup_tc(struct dsa_switch *ds, int port,
 		return vsc9959_qos_port_tas_set(ocelot, port, type_data);
 	case TC_SETUP_QDISC_CBS:
 		return vsc9959_qos_port_cbs_set(ds, port, type_data);
+	case TC_SETUP_PREEMPT:
+		return vsc9959_port_preempt_queues(ocelot, port, type_data);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.18.4


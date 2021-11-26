Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 478B245EC86
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 12:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346423AbhKZL0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 06:26:17 -0500
Received: from relay11.mail.gandi.net ([217.70.178.231]:57147 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239120AbhKZLYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 06:24:16 -0500
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id D3A5810000D;
        Fri, 26 Nov 2021 11:21:01 +0000 (UTC)
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, gregory.clement@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 1/4] net: mvneta: Use struct tc_mqprio_qopt_offload for MQPrio configuration
Date:   Fri, 26 Nov 2021 12:20:53 +0100
Message-Id: <20211126112056.849123-2-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20211126112056.849123-1-maxime.chevallier@bootlin.com>
References: <20211126112056.849123-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The struct tc_mqprio_qopt_offload is a container for struct tc_mqprio_qopt,
that allows passing extra parameters, such as traffic shaping. This commit
converts the current mqprio code to that new struct.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
V2 : No changes

 drivers/net/ethernet/marvell/mvneta.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 80e4b500695e..46b7604805f7 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -38,6 +38,7 @@
 #include <net/ipv6.h>
 #include <net/tso.h>
 #include <net/page_pool.h>
+#include <net/pkt_cls.h>
 #include <linux/bpf_trace.h>
 
 /* Registers */
@@ -4908,14 +4909,14 @@ static void mvneta_setup_rx_prio_map(struct mvneta_port *pp)
 }
 
 static int mvneta_setup_mqprio(struct net_device *dev,
-			       struct tc_mqprio_qopt *qopt)
+			       struct tc_mqprio_qopt_offload *mqprio)
 {
 	struct mvneta_port *pp = netdev_priv(dev);
 	u8 num_tc;
 	int i;
 
-	qopt->hw = TC_MQPRIO_HW_OFFLOAD_TCS;
-	num_tc = qopt->num_tc;
+	mqprio->qopt.hw = TC_MQPRIO_HW_OFFLOAD_TCS;
+	num_tc = mqprio->qopt.num_tc;
 
 	if (num_tc > rxq_number)
 		return -EINVAL;
@@ -4926,13 +4927,15 @@ static int mvneta_setup_mqprio(struct net_device *dev,
 		return 0;
 	}
 
-	memcpy(pp->prio_tc_map, qopt->prio_tc_map, sizeof(pp->prio_tc_map));
+	memcpy(pp->prio_tc_map, mqprio->qopt.prio_tc_map,
+	       sizeof(pp->prio_tc_map));
 
 	mvneta_setup_rx_prio_map(pp);
 
-	netdev_set_num_tc(dev, qopt->num_tc);
-	for (i = 0; i < qopt->num_tc; i++)
-		netdev_set_tc_queue(dev, i, qopt->count[i], qopt->offset[i]);
+	netdev_set_num_tc(dev, mqprio->qopt.num_tc);
+	for (i = 0; i < mqprio->qopt.num_tc; i++)
+		netdev_set_tc_queue(dev, i, mqprio->qopt.count[i],
+				    mqprio->qopt.offset[i]);
 
 	return 0;
 }
-- 
2.25.4


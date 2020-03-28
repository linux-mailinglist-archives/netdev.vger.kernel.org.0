Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAFBB1962D6
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 02:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgC1BRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 21:17:52 -0400
Received: from inva021.nxp.com ([92.121.34.21]:53570 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726212AbgC1BRv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 21:17:51 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 9BF112003B9;
        Sat, 28 Mar 2020 02:17:49 +0100 (CET)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 73854200069;
        Sat, 28 Mar 2020 02:17:43 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 316B94028F;
        Sat, 28 Mar 2020 09:17:36 +0800 (SGT)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     xiaoliang.yang_1@nxp.com, Jose.Abreu@synopsys.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, olteanv@gmail.com,
        ivan.khoronzhuk@linaro.org, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, po.liu@nxp.com,
        leoyang.li@nxp.com
Subject: [net-next,v1] net: stmmac: support for tc mqprio offload
Date:   Sat, 28 Mar 2020 09:14:14 +0800
Message-Id: <20200328011414.42401-1-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add support for tc mqprio offload to configure multiple
prioritized TX traffic classes with mqprio.

Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c   | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 0e8c80f23557..b9dcd109a282 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4214,6 +4214,21 @@ static int stmmac_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 
 static LIST_HEAD(stmmac_block_cb_list);
 
+static int stmmac_tc_setup_mqprio(struct net_device *ndev, void *type_data)
+{
+	struct tc_mqprio_qopt *mqprio = type_data;
+	u8 num_tc;
+	int i;
+
+	num_tc = mqprio->num_tc;
+	netif_set_real_num_tx_queues(ndev, num_tc);
+	netdev_set_num_tc(ndev, num_tc);
+	for (i = 0; i < num_tc; i++)
+		netdev_set_tc_queue(ndev, i, 1, i);
+
+	return 0;
+}
+
 static int stmmac_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 			   void *type_data)
 {
@@ -4229,6 +4244,8 @@ static int stmmac_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 		return stmmac_tc_setup_cbs(priv, priv, type_data);
 	case TC_SETUP_QDISC_TAPRIO:
 		return stmmac_tc_setup_taprio(priv, priv, type_data);
+	case TC_SETUP_QDISC_MQPRIO:
+		return stmmac_tc_setup_mqprio(ndev, type_data);
 	case TC_SETUP_QDISC_ETF:
 		return stmmac_tc_setup_etf(priv, priv, type_data);
 	default:
-- 
2.17.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF8B2285E7
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 18:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730411AbgGUQih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 12:38:37 -0400
Received: from inva020.nxp.com ([92.121.34.13]:57314 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728042AbgGUQie (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 12:38:34 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 5719A1A0717;
        Tue, 21 Jul 2020 18:38:32 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 432631A0713;
        Tue, 21 Jul 2020 18:38:32 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 12F62202A9;
        Tue, 21 Jul 2020 18:38:32 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 1/3] dpaa2-eth: move the mqprio setup into a separate function
Date:   Tue, 21 Jul 2020 19:38:23 +0300
Message-Id: <20200721163825.9462-2-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721163825.9462-1-ioana.ciornei@nxp.com>
References: <20200721163825.9462-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the setup done for MQPRIO into a separate function so that
with the addition of another offload we do not crowd
dpaa2_eth_setup_tc(). After this restructuring it's easier to see what
is supported in terms of Qdisc offloading.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index d0cc1dc49aaa..18e0c00074ff 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -2213,17 +2213,13 @@ static int update_xps(struct dpaa2_eth_priv *priv)
 	return err;
 }
 
-static int dpaa2_eth_setup_tc(struct net_device *net_dev,
-			      enum tc_setup_type type, void *type_data)
+static int dpaa2_eth_setup_mqprio(struct net_device *net_dev,
+				  struct tc_mqprio_qopt *mqprio)
 {
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
-	struct tc_mqprio_qopt *mqprio = type_data;
 	u8 num_tc, num_queues;
 	int i;
 
-	if (type != TC_SETUP_QDISC_MQPRIO)
-		return -EOPNOTSUPP;
-
 	mqprio->hw = TC_MQPRIO_HW_OFFLOAD_TCS;
 	num_queues = dpaa2_eth_queue_count(priv);
 	num_tc = mqprio->num_tc;
@@ -2255,6 +2251,17 @@ static int dpaa2_eth_setup_tc(struct net_device *net_dev,
 	return 0;
 }
 
+static int dpaa2_eth_setup_tc(struct net_device *net_dev,
+			      enum tc_setup_type type, void *type_data)
+{
+	switch (type) {
+	case TC_SETUP_QDISC_MQPRIO:
+		return dpaa2_eth_setup_mqprio(net_dev, type_data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static const struct net_device_ops dpaa2_eth_ops = {
 	.ndo_open = dpaa2_eth_open,
 	.ndo_start_xmit = dpaa2_eth_tx,
-- 
2.25.1


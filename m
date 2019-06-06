Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F49836F1C
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 10:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbfFFIue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 04:50:34 -0400
Received: from inva020.nxp.com ([92.121.34.13]:50244 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727420AbfFFIuc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 04:50:32 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 19C341A0A7D;
        Thu,  6 Jun 2019 10:50:31 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 0DECC1A0A64;
        Thu,  6 Jun 2019 10:50:31 +0200 (CEST)
Received: from fsr-ub1664-019.ea.freescale.net (fsr-ub1664-019.ea.freescale.net [10.171.71.230])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id CA2EA205C7;
        Thu,  6 Jun 2019 10:50:30 +0200 (CEST)
From:   Ioana Radulescu <ruxandra.radulescu@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     ioana.ciornei@nxp.com
Subject: [PATCH net-next v2 3/3] dpaa2-eth: Add mqprio support
Date:   Thu,  6 Jun 2019 11:50:29 +0300
Message-Id: <1559811029-28002-4-git-send-email-ruxandra.radulescu@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559811029-28002-1-git-send-email-ruxandra.radulescu@nxp.com>
References: <1559811029-28002-1-git-send-email-ruxandra.radulescu@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement mqprio qdisc support by mapping traffic classes to
different hardware enqueue priorities. The maximum number of
supported traffic classes is an attribute of each DPNI object.

The traffic classes map to hardware priorities from highest (0)
to lowest (highest prio number). The driver assigns num_queues
to each traffic class, for a total of num_queues x num_tcs
hardware frame queues.

Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Signed-off-by: Bogdan Purcareata <bogdan.purcareata@nxp.com>
---
v2: no changes

 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 43 ++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 98de092..6f69422 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1915,6 +1915,48 @@ static int update_xps(struct dpaa2_eth_priv *priv)
 	return err;
 }
 
+static int dpaa2_eth_setup_tc(struct net_device *net_dev,
+			      enum tc_setup_type type, void *type_data)
+{
+	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
+	struct tc_mqprio_qopt *mqprio = type_data;
+	u8 num_tc, num_queues;
+	int i;
+
+	if (type != TC_SETUP_QDISC_MQPRIO)
+		return -EINVAL;
+
+	mqprio->hw = TC_MQPRIO_HW_OFFLOAD_TCS;
+	num_queues = dpaa2_eth_queue_count(priv);
+	num_tc = mqprio->num_tc;
+
+	if (num_tc == net_dev->num_tc)
+		return 0;
+
+	if (num_tc  > dpaa2_eth_tc_count(priv)) {
+		netdev_err(net_dev, "Max %d traffic classes supported\n",
+			   dpaa2_eth_tc_count(priv));
+		return -EINVAL;
+	}
+
+	if (!num_tc) {
+		netdev_reset_tc(net_dev);
+		netif_set_real_num_tx_queues(net_dev, num_queues);
+		goto out;
+	}
+
+	netdev_set_num_tc(net_dev, num_tc);
+	netif_set_real_num_tx_queues(net_dev, num_tc * num_queues);
+
+	for (i = 0; i < num_tc; i++)
+		netdev_set_tc_queue(net_dev, i, num_queues, i * num_queues);
+
+out:
+	update_xps(priv);
+
+	return 0;
+}
+
 static const struct net_device_ops dpaa2_eth_ops = {
 	.ndo_open = dpaa2_eth_open,
 	.ndo_start_xmit = dpaa2_eth_tx,
@@ -1927,6 +1969,7 @@ static const struct net_device_ops dpaa2_eth_ops = {
 	.ndo_change_mtu = dpaa2_eth_change_mtu,
 	.ndo_bpf = dpaa2_eth_xdp,
 	.ndo_xdp_xmit = dpaa2_eth_xdp_xmit,
+	.ndo_setup_tc = dpaa2_eth_setup_tc,
 };
 
 static void cdan_cb(struct dpaa2_io_notification_ctx *ctx)
-- 
2.7.4


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 963BC31BC45
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 16:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbhBOPZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 10:25:18 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:52868 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229913AbhBOPZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 10:25:05 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11FFACfO000562;
        Mon, 15 Feb 2021 07:24:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=4iie+V1xfY+VZRTEiy5o7821jbpszkWL42bxdFjOfNw=;
 b=jTjq1IG70BDpYXmrdU3B8qwRFxuvHegoZtE4BmLX4p535aLVjGuWQ3ZjuTzoiq3KQFbJ
 9Afkw0L5rqJOagwKtEo66LSJJoKf0Ntpbe/d4xhECzqbcEUBb90NYwP2+kh+BJ7YKInY
 FZ7dA3SvZ1hhIyQGEWCs1S6V8EHZsNIcmFp7wSmuVlkCDibvXDSgATG+qI+4sYIddwHG
 /oEI4QERucSoHqO1FmJInfTJZUCHTC8QYk2UD/vvcSFXTclHxdHUtyZYa5t3yTZJWtmb
 u8lp7l6YCzhZlLpGlTml6Plk3E5N4KMLfijbdGK2yLWmbIOUqlqzcZFMSiDmy0n23N4x 0g== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 36pf5tv58v-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 15 Feb 2021 07:24:04 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 15 Feb
 2021 07:24:02 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 15 Feb 2021 07:24:02 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 024D13F7040;
        Mon, 15 Feb 2021 07:23:59 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [net-next] net: mvpp2: Add TX flow control support for jumbo frames
Date:   Mon, 15 Feb 2021 17:23:42 +0200
Message-ID: <1613402622-11451-1-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-15_11:2021-02-12,2021-02-15 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

With MTU less than 1500B on all ports, the driver uses per CPU pool mode.
If one of the ports set to jumbo frame MTU size, all ports move
to shared pools mode.
Here, buffer manager TX Flow Control reconfigured on all ports.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 26 ++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 222e9a3..10c17d1 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -924,6 +924,25 @@ static void mvpp2_bm_pool_update_fc(struct mvpp2_port *port,
 	spin_unlock_irqrestore(&port->priv->mss_spinlock, flags);
 }
 
+/* disable/enable flow control for BM pool on all ports */
+static void mvpp2_bm_pool_update_priv_fc(struct mvpp2 *priv, bool en)
+{
+	struct mvpp2_port *port;
+	int i;
+
+	for (i = 0; i < priv->port_count; i++) {
+		port = priv->port_list[i];
+		if (port->priv->percpu_pools) {
+			for (i = 0; i < port->nrxqs; i++)
+				mvpp2_bm_pool_update_fc(port, &port->priv->bm_pools[i],
+							port->tx_fc & en);
+		} else {
+			mvpp2_bm_pool_update_fc(port, port->pool_long, port->tx_fc & en);
+			mvpp2_bm_pool_update_fc(port, port->pool_short, port->tx_fc & en);
+		}
+	}
+}
+
 static int mvpp2_enable_global_fc(struct mvpp2 *priv)
 {
 	int val, timeout = 0;
@@ -4913,6 +4932,7 @@ static int mvpp2_set_mac_address(struct net_device *dev, void *p)
  */
 static int mvpp2_bm_switch_buffers(struct mvpp2 *priv, bool percpu)
 {
+	bool change_percpu = (percpu != priv->percpu_pools);
 	int numbufs = MVPP2_BM_POOLS_NUM, i;
 	struct mvpp2_port *port = NULL;
 	bool status[MVPP2_MAX_PORTS];
@@ -4928,6 +4948,9 @@ static int mvpp2_bm_switch_buffers(struct mvpp2 *priv, bool percpu)
 	if (priv->percpu_pools)
 		numbufs = port->nrxqs * 2;
 
+	if (change_percpu)
+		mvpp2_bm_pool_update_priv_fc(priv, false);
+
 	for (i = 0; i < numbufs; i++)
 		mvpp2_bm_pool_destroy(port->dev->dev.parent, priv, &priv->bm_pools[i]);
 
@@ -4942,6 +4965,9 @@ static int mvpp2_bm_switch_buffers(struct mvpp2 *priv, bool percpu)
 			mvpp2_open(port->dev);
 	}
 
+	if (change_percpu)
+		mvpp2_bm_pool_update_priv_fc(priv, true);
+
 	return 0;
 }
 
-- 
1.9.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0892D31EAA2
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 15:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbhBRN5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 08:57:38 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:31890 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232924AbhBRNDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 08:03:11 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11ICgG7R025222;
        Thu, 18 Feb 2021 04:42:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=Wf9nGNGlZL5D6f89oSJlh1oCwj93RrSrls7xCKsb+tw=;
 b=bukrhnGZJ5rxS96hDwJbFi4lPtIo5U8XREfvYy81ODeJcSoOkKlJ3FpiXwqZOO6zEzMj
 fRtJmldTP1YX/+aMlaw2wSsjUUUv3lOWMA+3iHN3ga9YJJMbCWKuOxJtrLuvFioY/Bmy
 uribQXoIZPQiotngIrvz0roaGSjfCZhyp1W8q5isAR5T6sbEj0nPtcL5Nsbiol4Vkp04
 3v9J9yP53G+LD/sqOkUaiAkG2L6kFIVixnQFarVueYnC6xNwZS6EoyQ3kZpbaRjei88m
 N8ZieuEvLq7nuw5s/kwNJQ6GsVbZ7v2uHlIzt/piV3iKopKQLVB1MXbCja8k7yJ13iqD ow== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36sesvsjn4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 18 Feb 2021 04:42:16 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 18 Feb
 2021 04:42:14 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 18 Feb
 2021 04:42:14 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 18 Feb 2021 04:42:14 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 706663F7040;
        Thu, 18 Feb 2021 04:42:11 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [net-next] net: mvpp2: skip RSS configurations on loopback port
Date:   Thu, 18 Feb 2021 14:42:03 +0200
Message-ID: <1613652123-19021-1-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-18_05:2021-02-18,2021-02-18 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

PPv2 loopback port doesn't support RSS, so we should
skip RSS configurations for this port.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 25 +++++++++++---------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 10c17d1..d415447 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -4699,9 +4699,10 @@ static void mvpp2_irqs_deinit(struct mvpp2_port *port)
 	}
 }
 
-static bool mvpp22_rss_is_supported(void)
+static bool mvpp22_rss_is_supported(struct mvpp2_port *port)
 {
-	return queue_mode == MVPP2_QDIST_MULTI_MODE;
+	return (queue_mode == MVPP2_QDIST_MULTI_MODE) &&
+		!(port->flags & MVPP2_F_LOOPBACK);
 }
 
 static int mvpp2_open(struct net_device *dev)
@@ -5513,7 +5514,7 @@ static int mvpp2_ethtool_get_rxnfc(struct net_device *dev,
 	struct mvpp2_port *port = netdev_priv(dev);
 	int ret = 0, i, loc = 0;
 
-	if (!mvpp22_rss_is_supported())
+	if (!mvpp22_rss_is_supported(port))
 		return -EOPNOTSUPP;
 
 	switch (info->cmd) {
@@ -5548,7 +5549,7 @@ static int mvpp2_ethtool_set_rxnfc(struct net_device *dev,
 	struct mvpp2_port *port = netdev_priv(dev);
 	int ret = 0;
 
-	if (!mvpp22_rss_is_supported())
+	if (!mvpp22_rss_is_supported(port))
 		return -EOPNOTSUPP;
 
 	switch (info->cmd) {
@@ -5569,7 +5570,9 @@ static int mvpp2_ethtool_set_rxnfc(struct net_device *dev,
 
 static u32 mvpp2_ethtool_get_rxfh_indir_size(struct net_device *dev)
 {
-	return mvpp22_rss_is_supported() ? MVPP22_RSS_TABLE_ENTRIES : 0;
+	struct mvpp2_port *port = netdev_priv(dev);
+
+	return mvpp22_rss_is_supported(port) ? MVPP22_RSS_TABLE_ENTRIES : 0;
 }
 
 static int mvpp2_ethtool_get_rxfh(struct net_device *dev, u32 *indir, u8 *key,
@@ -5578,7 +5581,7 @@ static int mvpp2_ethtool_get_rxfh(struct net_device *dev, u32 *indir, u8 *key,
 	struct mvpp2_port *port = netdev_priv(dev);
 	int ret = 0;
 
-	if (!mvpp22_rss_is_supported())
+	if (!mvpp22_rss_is_supported(port))
 		return -EOPNOTSUPP;
 
 	if (indir)
@@ -5596,7 +5599,7 @@ static int mvpp2_ethtool_set_rxfh(struct net_device *dev, const u32 *indir,
 	struct mvpp2_port *port = netdev_priv(dev);
 	int ret = 0;
 
-	if (!mvpp22_rss_is_supported())
+	if (!mvpp22_rss_is_supported(port))
 		return -EOPNOTSUPP;
 
 	if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != ETH_RSS_HASH_CRC32)
@@ -5617,7 +5620,7 @@ static int mvpp2_ethtool_get_rxfh_context(struct net_device *dev, u32 *indir,
 	struct mvpp2_port *port = netdev_priv(dev);
 	int ret = 0;
 
-	if (!mvpp22_rss_is_supported())
+	if (!mvpp22_rss_is_supported(port))
 		return -EOPNOTSUPP;
 	if (rss_context >= MVPP22_N_RSS_TABLES)
 		return -EINVAL;
@@ -5639,7 +5642,7 @@ static int mvpp2_ethtool_set_rxfh_context(struct net_device *dev,
 	struct mvpp2_port *port = netdev_priv(dev);
 	int ret;
 
-	if (!mvpp22_rss_is_supported())
+	if (!mvpp22_rss_is_supported(port))
 		return -EOPNOTSUPP;
 
 	if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != ETH_RSS_HASH_CRC32)
@@ -5956,7 +5959,7 @@ static int mvpp2_port_init(struct mvpp2_port *port)
 	mvpp2_cls_oversize_rxq_set(port);
 	mvpp2_cls_port_config(port);
 
-	if (mvpp22_rss_is_supported())
+	if (mvpp22_rss_is_supported(port))
 		mvpp22_port_rss_init(port);
 
 	/* Provide an initial Rx packet size */
@@ -6861,7 +6864,7 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 	dev->hw_features |= features | NETIF_F_RXCSUM | NETIF_F_GRO |
 			    NETIF_F_HW_VLAN_CTAG_FILTER;
 
-	if (mvpp22_rss_is_supported()) {
+	if (mvpp22_rss_is_supported(port)) {
 		dev->hw_features |= NETIF_F_RXHASH;
 		dev->features |= NETIF_F_NTUPLE;
 	}
-- 
1.9.1


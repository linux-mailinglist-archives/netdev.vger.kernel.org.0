Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5733D2F0820
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 16:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbhAJPfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 10:35:12 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:32076 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727270AbhAJPew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 10:34:52 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10AFPKpF022742;
        Sun, 10 Jan 2021 07:32:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=y+cFmHotVndgeh7cseVowHDsdSFiHJpQBaSBYrPxPPc=;
 b=G907rWZfOH8Rvufe70fM8U2rRTVUJ2SVMFV8469aVA1DgI78N9zT1lziprclSyzICsAR
 mXF56nbTT/2RQ+OeMYlSwCn/zhsPPZdaY6FBOeBFjnG9RjPFn16V8gaaByW/J8x6Klsr
 UQqrkCfq24ZcShdtuw/y3gzBDksOAp97yHbe/mPY9ufOqCmbGPg5JeJCIHee/zYdi0c6
 gFvXYy4gPMe7CSVm4dn/4Tdb1cMSD8LVuwtIp12Zp0EQdwyRYAvKPoHe0qCSI4Ad5VFi
 IGnMBo6NfqoIFG/NvLXFLrYAhL3YpqRknMV6PZdJtOqdrCR6BZnNdEVIOHjENq3/B+vY tA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 35ycvphvex-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 10 Jan 2021 07:32:06 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 10 Jan
 2021 07:32:05 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 10 Jan
 2021 07:32:05 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 10 Jan 2021 07:32:04 -0800
Received: from stefan-pc.marvell.com (stefan-pc.marvell.com [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 90DA83F7040;
        Sun, 10 Jan 2021 07:32:01 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>,
        <atenart@kernel.org>
Subject: [PATCH RFC net-next  18/19] net: mvpp2: add ring size validation before enabling FC
Date:   Sun, 10 Jan 2021 17:30:22 +0200
Message-ID: <1610292623-15564-19-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
References: <1610292623-15564-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-09_13:2021-01-07,2021-01-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

This patch add ring size validation before enabling FC.
1. Flow control cannot be enabled if ring size is below start
threshold.
2. Flow control disabled if ring size set below start
threshold.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 06e1000..3607382 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5372,6 +5372,15 @@ static int mvpp2_ethtool_set_ringparam(struct net_device *dev,
 	if (err)
 		return err;
 
+	if (ring->rx_pending < MSS_THRESHOLD_START && port->tx_fc) {
+		netdev_warn(dev, "TX FC disabled. Ring size is less than %d\n",
+			    MSS_THRESHOLD_START);
+		port->tx_fc = false;
+		mvpp2_rxq_disable_fc(port);
+		if (port->priv->hw_version == MVPP23)
+			mvpp23_rx_fifo_fc_en(port->priv, port->id, false);
+	}
+
 	if (!netif_running(dev)) {
 		port->rx_ring_size = ring->rx_pending;
 		port->tx_ring_size = ring->tx_pending;
@@ -5439,6 +5448,13 @@ static int mvpp2_ethtool_set_pause_param(struct net_device *dev,
 
 	if (pause->tx_pause && port->priv->global_tx_fc &&
 	    bm_underrun_protect) {
+		if (port->rx_ring_size < MSS_THRESHOLD_START) {
+			netdev_err(dev, "TX FC cannot be supported.");
+			netdev_err(dev, "Ring size is less than %d\n",
+				   MSS_THRESHOLD_START);
+			return -EINVAL;
+		}
+
 		port->tx_fc = true;
 		mvpp2_rxq_enable_fc(port);
 		if (port->priv->percpu_pools) {
-- 
1.9.1


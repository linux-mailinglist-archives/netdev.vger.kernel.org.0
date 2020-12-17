Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04B022DCE9C
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 10:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727632AbgLQJnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 04:43:11 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:55282 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726580AbgLQJnI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 04:43:08 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BH9ZiOc008430;
        Thu, 17 Dec 2020 01:40:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=kzVNG9l2wMsHpkgpX4GfYITXE8UzXLYNc9dS0IWK3gM=;
 b=ASa7COd2kRBXR+LuTtRrJsykOMjNUgaivErYq3Z4qK8WLKxQiW4Ortp2tdxs3KjkWKpq
 ZuR1/z5EZxXZOkQZwVIVWjFuaI7fzvILpZfD0WzqiCGmFY48oWW3ZG58Cr67Xu5wM+hU
 tAM5yCOSZwv/Zt6NB6tr/npn3cucNeZqHGTb0Cb7aZBx6aUeoE6c9QyLHcgjftVKf75U
 trKeJM1ZEGmDNhx5oBCjGlri8jE1P1pzWk87rGoVAJcYEJoBR4pkqXYCSlRw8hO9twN2
 DMceeWdNRKUlnhLfhQ89qH7WomagX9fD/kbIhLekPK2WqRNa/PJdHI1GSFQ5yDMeVc9E 8g== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 35g4rp018j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 01:40:20 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 17 Dec
 2020 01:40:19 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 17 Dec 2020 01:40:19 -0800
Received: from stefan-pc.marvell.com (unknown [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id B0B753F7041;
        Thu, 17 Dec 2020 01:40:16 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net v2 2/2] net: mvpp2: disable force link UP during port init procedure
Date:   Thu, 17 Dec 2020 11:40:07 +0200
Message-ID: <1608198007-10143-2-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1608198007-10143-1-git-send-email-stefanc@marvell.com>
References: <1608198007-10143-1-git-send-email-stefanc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-17_07:2020-12-15,2020-12-17 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

Force link UP can be enabled by bootloader during tftpboot
and breaks NFS support.
Force link UP disabled during port init procedure.

Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index d2b0506..0ad3177 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5479,7 +5479,7 @@ static int mvpp2_port_init(struct mvpp2_port *port)
 	struct mvpp2 *priv = port->priv;
 	struct mvpp2_txq_pcpu *txq_pcpu;
 	unsigned int thread;
-	int queue, err;
+	int queue, err, val;
 
 	/* Checks for hardware constraints */
 	if (port->first_rxq + port->nrxqs >
@@ -5493,6 +5493,18 @@ static int mvpp2_port_init(struct mvpp2_port *port)
 	mvpp2_egress_disable(port);
 	mvpp2_port_disable(port);
 
+	if (mvpp2_is_xlg(port->phy_interface)) {
+		val = readl(port->base + MVPP22_XLG_CTRL0_REG);
+		val &= ~MVPP22_XLG_CTRL0_FORCE_LINK_PASS;
+		val |= MVPP22_XLG_CTRL0_FORCE_LINK_DOWN;
+		writel(val, port->base + MVPP22_XLG_CTRL0_REG);
+	} else {
+		val = readl(port->base + MVPP2_GMAC_AUTONEG_CONFIG);
+		val &= ~MVPP2_GMAC_FORCE_LINK_PASS;
+		val |= MVPP2_GMAC_FORCE_LINK_DOWN;
+		writel(val, port->base + MVPP2_GMAC_AUTONEG_CONFIG);
+	}
+
 	port->tx_time_coal = MVPP2_TXDONE_COAL_USEC;
 
 	port->txqs = devm_kcalloc(dev, port->ntxqs, sizeof(*port->txqs),
-- 
1.9.1


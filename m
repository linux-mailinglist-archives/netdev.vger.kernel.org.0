Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD902DD358
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 15:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbgLQOz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 09:55:28 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:36348 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726569AbgLQOz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 09:55:28 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BHEqAOf007500;
        Thu, 17 Dec 2020 06:52:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=LHVXFgY28iTMTpgbMNDvqeDEq5m7ESsAw4UScbAYjD0=;
 b=HSnpnyS1bdRJ2L3DjLPNohkh3UbQHVN6CL7St5Fsa3B49tVO2LKzF1CI3g+HrZppCWF0
 QyCEjvWC3lb8iPTZvMEw+PDB6U+jdrdXtdaOEp+1gkZ4aE6fENNh/hSBKKEf+vAqRDRy
 hIImxSiInEE+c+SN+FY24o9fJELcWf9gBcoJ3tWMTMmysWjRkGrMGWAdQaMsOe+lXYFQ
 MoLRjRc3gYW6vMJHw2HKVyEJwpni671hyaNun8BRsgo45OQfnjLZcNED4WnyUHfhTFAD
 z83R7MnYE1mE1kV9lOHnrHG7+5YiZMtjBkpgRp3xlUYELKEyVS9VNn9txoE4yzl31WUC 0w== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 35g4rp0sfv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 06:52:35 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 17 Dec
 2020 06:52:34 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 17 Dec 2020 06:52:34 -0800
Received: from stefan-pc.marvell.com (unknown [10.5.25.21])
        by maili.marvell.com (Postfix) with ESMTP id 9A1E73F703F;
        Thu, 17 Dec 2020 06:52:31 -0800 (PST)
From:   <stefanc@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <nadavh@marvell.com>, <ymarkman@marvell.com>,
        <linux-kernel@vger.kernel.org>, <stefanc@marvell.com>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>, <mw@semihalf.com>,
        <andrew@lunn.ch>, <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net v3] net: mvpp2: disable force link UP during port init procedure
Date:   Thu, 17 Dec 2020 16:52:15 +0200
Message-ID: <1608216735-14501-1-git-send-email-stefanc@marvell.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-17_10:2020-12-15,2020-12-17 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Chulski <stefanc@marvell.com>

Force link UP can be enabled by bootloader during tftpboot
and breaks NFS support.
Force link UP disabled during port init procedure.

Fixes: f84bf386f395 ("net: mvpp2: initialize the GoP")
Signed-off-by: Stefan Chulski <stefanc@marvell.com>
---

Changes in v3:
- Added Fixes tag.
Changes in v2:
- No changes.

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


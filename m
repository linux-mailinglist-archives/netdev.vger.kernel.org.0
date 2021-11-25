Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AFB145D341
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 03:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237267AbhKYCwD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 21:52:03 -0500
Received: from twspam01.aspeedtech.com ([211.20.114.71]:30296 "EHLO
        twspam01.aspeedtech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbhKYCuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 21:50:02 -0500
Received: from mail.aspeedtech.com ([192.168.0.24])
        by twspam01.aspeedtech.com with ESMTP id 1AP2JVcS073363;
        Thu, 25 Nov 2021 10:19:31 +0800 (GMT-8)
        (envelope-from dylan_hung@aspeedtech.com)
Received: from DylanHung-PC.aspeed.com (192.168.2.216) by TWMBX02.aspeed.com
 (192.168.0.24) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 25 Nov
 2021 10:43:41 +0800
From:   Dylan Hung <dylan_hung@aspeedtech.com>
To:     <linux-kernel@vger.kernel.org>, <linux-aspeed@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <andrew@aj.id.au>, <joel@jms.id.au>, <kuba@kernel.org>,
        <davem@davemloft.net>, <linux@armlinux.org.uk>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>
CC:     <BMC-SW@aspeedtech.com>, <stable@vger.kernel.org>
Subject: [PATCH v2] mdio: aspeed: Fix "Link is Down" issue
Date:   Thu, 25 Nov 2021 10:44:32 +0800
Message-ID: <20211125024432.15809-1-dylan_hung@aspeedtech.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.2.216]
X-ClientProxiedBy: TWMBX02.aspeed.com (192.168.0.24) To TWMBX02.aspeed.com
 (192.168.0.24)
X-DNSRBL: 
X-MAIL: twspam01.aspeedtech.com 1AP2JVcS073363
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The issue happened randomly in runtime.  The message "Link is Down" is
popped but soon it recovered to "Link is Up".

The "Link is Down" results from the incorrect read data for reading the
PHY register via MDIO bus.  The correct sequence for reading the data
shall be:
1. fire the command
2. wait for command done (this step was missing)
3. wait for data idle
4. read data from data register

Fixes: f160e99462c6 ("net: phy: Add mdio-aspeed")
Cc: stable@vger.kernel.org
Reviewed-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>
---
v2: revise commit message

 drivers/net/mdio/mdio-aspeed.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/mdio/mdio-aspeed.c b/drivers/net/mdio/mdio-aspeed.c
index cad820568f75..966c3b4ad59d 100644
--- a/drivers/net/mdio/mdio-aspeed.c
+++ b/drivers/net/mdio/mdio-aspeed.c
@@ -61,6 +61,13 @@ static int aspeed_mdio_read(struct mii_bus *bus, int addr, int regnum)
 
 	iowrite32(ctrl, ctx->base + ASPEED_MDIO_CTRL);
 
+	rc = readl_poll_timeout(ctx->base + ASPEED_MDIO_CTRL, ctrl,
+				!(ctrl & ASPEED_MDIO_CTRL_FIRE),
+				ASPEED_MDIO_INTERVAL_US,
+				ASPEED_MDIO_TIMEOUT_US);
+	if (rc < 0)
+		return rc;
+
 	rc = readl_poll_timeout(ctx->base + ASPEED_MDIO_DATA, data,
 				data & ASPEED_MDIO_DATA_IDLE,
 				ASPEED_MDIO_INTERVAL_US,
-- 
2.25.1


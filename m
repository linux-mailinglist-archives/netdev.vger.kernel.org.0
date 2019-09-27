Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8BCC0080
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 09:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbfI0H6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 03:58:54 -0400
Received: from smtp.cellavision.se ([84.19.140.14]:34725 "EHLO
        smtp.cellavision.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfI0H6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 03:58:53 -0400
Received: from DRCELLEX03.cellavision.se (172.16.169.12) by
 DRCELLEX03.cellavision.se (172.16.169.12) with Microsoft SMTP Server (TLS) id
 15.0.1044.25; Fri, 27 Sep 2019 09:58:50 +0200
Received: from ITG-CEL-24768.cellavision.se (10.230.0.148) by
 DRCELLEX03.cellavision.se (172.16.169.12) with Microsoft SMTP Server id
 15.0.1044.25 via Frontend Transport; Fri, 27 Sep 2019 09:58:50 +0200
From:   Hans Andersson <haan@cellavision.se>
To:     <andrew@lunn.ch>
CC:     <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <antoine.tenart@bootlin.com>,
        Hans Andersson <hans.andersson@cellavision.se>
Subject: [PATCH v2] net: phy: micrel: add Asym Pause workaround for KSZ9021
Date:   Fri, 27 Sep 2019 09:58:02 +0200
Message-ID: <20190927075802.10376-1-haan@cellavision.se>
X-Mailer: git-send-email 2.21.0.windows.1
In-Reply-To: <20190926120922.GD1864@lunn.ch>
References: <20190926120922.GD1864@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hans Andersson <hans.andersson@cellavision.se>

The Micrel KSZ9031 PHY may fail to establish a link when the Asymmetric
Pause capability is set. This issue is described in a Silicon Errata
(DS80000691D or DS80000692D), which advises to always disable the
capability.

Micrel KSZ9021 has no errata, but has the same issue with Asymmetric Pause.
This patch apply the same workaround as the one for KSZ9031.

Fixes: 3aed3e2a143c ("net: phy: micrel: add Asym Pause workaround")
Signed-off-by: Hans Andersson <hans.andersson@cellavision.se>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/micrel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 3c8186f269f9..2fea5541c35a 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -763,6 +763,8 @@ static int ksz9031_get_features(struct phy_device *phydev)
 	 * Whenever the device's Asymmetric Pause capability is set to 1,
 	 * link-up may fail after a link-up to link-down transition.
 	 *
+	 * The Errata Sheet is for ksz9031, but ksz9021 has the same issue
+	 *
 	 * Workaround:
 	 * Do not enable the Asymmetric Pause capability bit.
 	 */
@@ -1076,6 +1078,7 @@ static struct phy_driver ksphy_driver[] = {
 	/* PHY_GBIT_FEATURES */
 	.driver_data	= &ksz9021_type,
 	.probe		= kszphy_probe,
+	.get_features	= ksz9031_get_features,
 	.config_init	= ksz9021_config_init,
 	.ack_interrupt	= kszphy_ack_interrupt,
 	.config_intr	= kszphy_config_intr,
-- 
2.21.0.windows.1


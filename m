Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 563281230CC
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 16:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbfLQPrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 10:47:47 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:58432 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727572AbfLQPrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 10:47:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=BV2t1egUN0MNp7m9A5C9Kmp49BJW8JwAGMgxJxDJKHI=; b=bhDVrUDaIWuG6O1+XRvc/6aVyC
        mROzSmAgRU++X+xhDIwcsAyP2SUAB+B9Da8KoQA7rJn/mPu/PR4DVS3DmOLYVk5INKHNJtf4mPPZU
        YWAIsCk8IYIbOzqNy22LAMA6vT12qmaIHHbu2/gY+GiZioel/8iqawMIjge1QaQpoM1XAc+TQqAok
        WHZge3QWlwvr9TyUK+JmoehEKbaZf986M+jOpmm8pZJKdxutYArsDXRwPvQzOi1drtWO5PmLKQyV/
        hmXfFOmMEj+PrZQJW0//bC6ByiJcLi7plx4vHuSb6sgU5nLPYEwrpj109HFW6wNLB3S6tQeDgkDf2
        O5IJwOOw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:36032 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ihF4S-0006rv-QA; Tue, 17 Dec 2019 15:47:36 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1ihF4S-0000gt-1B; Tue, 17 Dec 2019 15:47:36 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Antoine Tenart <antoine.tenart@bootlin.com>,
        maxime.chevallier@bootlin.com
Cc:     Willy Tarreau <w@1wt.eu>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
Subject: [PATCH net-next] net: mvpp2: cycle comphy to power it down
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1ihF4S-0000gt-1B@rmk-PC.armlinux.org.uk>
Date:   Tue, 17 Dec 2019 15:47:36 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Presently, at boot time, the comphys are enabled. For firmware
compatibility reasons, the comphy driver does not power down the
comphys at boot. Consequently, the ethernet comphys are left active
until the network interfaces are brought through an up/down cycle.

If the port is never used, the port wastes power needlessly. Arrange
for the ethernet comphys to be cycled by the mvpp2 driver as if the
interface went through an up/down cycle during driver probe, thereby
powering them down.

This saves:
  270mW per 10G SFP+ port on the Macchiatobin Single Shot (eth0/eth1)
  370mW per 10G PHY port on the Macchiatobin Double Shot (eth0/eth1)
  160mW on the SFP port on either Macchiatobin flavour (eth3)

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index c17b6cafef07..88a475606f19 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5546,6 +5546,16 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 		port->phylink = NULL;
 	}
 
+	/* Cycle the comphy to power it down, saving 270mW per port -
+	 * don't worry about an error powering it up. When the comphy
+	 * driver does this, we can remove this code.
+	 */
+	if (port->comphy) {
+		err = mvpp22_comphy_init(port);
+		if (err == 0)
+			phy_power_off(port->comphy);
+	}
+
 	err = register_netdev(dev);
 	if (err < 0) {
 		dev_err(&pdev->dev, "failed to register netdev\n");
-- 
2.20.1


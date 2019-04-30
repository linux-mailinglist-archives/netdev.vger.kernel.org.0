Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C58C10241
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 00:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbfD3WMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 18:12:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50601 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726048AbfD3WMw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 18:12:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version
        :Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=My7jehS3q31G66MLxVuxb7SE05cYGDtZmhw1/cHMnzU=; b=GeaciIYcS9d8zI6N7y+46jIC4I
        2QSujjLnJPequrBQO47+kc9YVtwlt7LTNolBMtfsW++CdnIO/sHnLP/vfYzy6eKS/h4NLSnnmIB0a
        gRvZ+upy7S/F6ezRcHBWsk00EMRY0XW2bA7kGg2CspARfCPFIgSFInMQ3Vx9cJCXldT4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hLaxk-00059C-HN; Wed, 01 May 2019 00:10:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next] net: dsa: mv88e6xxx: Pass interrupt number in platform data
Date:   Wed,  1 May 2019 00:10:50 +0200
Message-Id: <20190430221050.19749-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow an interrupt number to be passed in the platform data. The
driver will then use it if not zero, otherwise it will poll for
interrupts.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.c        | 13 +++++++++----
 include/linux/platform_data/mv88e6xxx.h |  1 +
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 46020fe1b5e7..bad30be699bf 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -4894,12 +4894,17 @@ static int mv88e6xxx_probe(struct mdio_device *mdiodev)
 	if (err)
 		goto out;
 
-	chip->irq = of_irq_get(np, 0);
-	if (chip->irq == -EPROBE_DEFER) {
-		err = chip->irq;
-		goto out;
+	if (np) {
+		chip->irq = of_irq_get(np, 0);
+		if (chip->irq == -EPROBE_DEFER) {
+			err = chip->irq;
+			goto out;
+		}
 	}
 
+	if (pdata)
+		chip->irq = pdata->irq;
+
 	/* Has to be performed before the MDIO bus is created, because
 	 * the PHYs will link their interrupts to these interrupt
 	 * controllers
diff --git a/include/linux/platform_data/mv88e6xxx.h b/include/linux/platform_data/mv88e6xxx.h
index 963730b44aea..21452a9365e1 100644
--- a/include/linux/platform_data/mv88e6xxx.h
+++ b/include/linux/platform_data/mv88e6xxx.h
@@ -13,6 +13,7 @@ struct dsa_mv88e6xxx_pdata {
 	unsigned int enabled_ports;
 	struct net_device *netdev;
 	u32 eeprom_len;
+	int irq;
 };
 
 #endif
-- 
2.20.1


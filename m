Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D82A75B2F
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 01:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbfGYXTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 19:19:41 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36032 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbfGYXTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 19:19:41 -0400
Received: by mail-wr1-f68.google.com with SMTP id n4so52490746wrs.3
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 16:19:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K3wHkemLb3xaCpDEOIj/woHJAbVwLsLkHjzsKdx3mpc=;
        b=SD6DSoItTq5akUiJ2iYDNETzSl8LJ1KbzFIRDRF7sOEmD0eEvC5fVna/X33KM67Uaw
         r17KpBe0dzql+me+YEvuwMm/rU2sCsu5t6WQFp4BRGB3J8qEWvYbh7PKuu3uvy2PlMWL
         j1107gzC2SH9fN8/58s8E55t4oZq6KsUdILUZ4c0lIcMD4jQh9KZndkYsOVkNWNuoSJo
         f+jXD6++Ib4AqHSbGt+QeSiqyWymHK4dsbtrcXRkn2McgnM6ICO7erkzGgwJE6A6qaGj
         4eDZG/3izUg3futZ9ilcmQ34F1/wsU5nvEZu3gE+nW0M+qPoDbGZnrS3nQg1zKw62gWB
         og+w==
X-Gm-Message-State: APjAAAVg5t9/xYeH3OrZVEn0w2YIrhWT4R91xN8Wm7I1BBoFLhm3FPoe
        yI7fBzhgjljSXaMr56v7IR1++KPm83s=
X-Google-Smtp-Source: APXvYqzjWT4ow6D0N4ysM5JtU6bPrYkvp6eH3dlpaBKFdVmxlLFewHnONQ5vX0oLS8HYmV85Lf7nuA==
X-Received: by 2002:a05:6000:1203:: with SMTP id e3mr20306951wrx.300.1564096779690;
        Thu, 25 Jul 2019 16:19:39 -0700 (PDT)
Received: from mcroce-redhat.homenet.telecomitalia.it (host21-50-dynamic.21-87-r.retail.telecomitalia.it. [87.21.50.21])
        by smtp.gmail.com with ESMTPSA id y1sm38206717wma.32.2019.07.25.16.19.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 25 Jul 2019 16:19:38 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Stefan Chulski <stefanc@marvell.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH net] mvpp2: refactor MTU change code
Date:   Fri, 26 Jul 2019 01:19:31 +0200
Message-Id: <20190725231931.24073-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MTU change code can call napi_disable() with the device already down,
leading to a deadlock. Also, lot of code is duplicated unnecessarily.

Rework mvpp2_change_mtu() to avoid the deadlock and remove duplicated code.

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 41 ++++++-------------
 1 file changed, 13 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 2f7286bd203b..60eb98f99571 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3612,6 +3612,7 @@ static int mvpp2_set_mac_address(struct net_device *dev, void *p)
 static int mvpp2_change_mtu(struct net_device *dev, int mtu)
 {
 	struct mvpp2_port *port = netdev_priv(dev);
+	bool running = netif_running(dev);
 	int err;
 
 	if (!IS_ALIGNED(MVPP2_RX_PKT_SIZE(mtu), 8)) {
@@ -3620,40 +3621,24 @@ static int mvpp2_change_mtu(struct net_device *dev, int mtu)
 		mtu = ALIGN(MVPP2_RX_PKT_SIZE(mtu), 8);
 	}
 
-	if (!netif_running(dev)) {
-		err = mvpp2_bm_update_mtu(dev, mtu);
-		if (!err) {
-			port->pkt_size =  MVPP2_RX_PKT_SIZE(mtu);
-			return 0;
-		}
-
-		/* Reconfigure BM to the original MTU */
-		err = mvpp2_bm_update_mtu(dev, dev->mtu);
-		if (err)
-			goto log_error;
-	}
-
-	mvpp2_stop_dev(port);
+	if (running)
+		mvpp2_stop_dev(port);
 
 	err = mvpp2_bm_update_mtu(dev, mtu);
-	if (!err) {
+	if (err) {
+		netdev_err(dev, "failed to change MTU\n");
+		/* Reconfigure BM to the original MTU */
+		mvpp2_bm_update_mtu(dev, dev->mtu);
+	} else {
 		port->pkt_size =  MVPP2_RX_PKT_SIZE(mtu);
-		goto out_start;
 	}
 
-	/* Reconfigure BM to the original MTU */
-	err = mvpp2_bm_update_mtu(dev, dev->mtu);
-	if (err)
-		goto log_error;
-
-out_start:
-	mvpp2_start_dev(port);
-	mvpp2_egress_enable(port);
-	mvpp2_ingress_enable(port);
+	if (running) {
+		mvpp2_start_dev(port);
+		mvpp2_egress_enable(port);
+		mvpp2_ingress_enable(port);
+	}
 
-	return 0;
-log_error:
-	netdev_err(dev, "failed to change MTU\n");
 	return err;
 }
 
-- 
2.21.0


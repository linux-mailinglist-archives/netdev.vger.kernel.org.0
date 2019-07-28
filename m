Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85D0B77C91
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 02:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729068AbfG1Aqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 20:46:54 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36973 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729050AbfG1Aqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 20:46:54 -0400
Received: by mail-wr1-f65.google.com with SMTP id n9so32953979wrr.4
        for <netdev@vger.kernel.org>; Sat, 27 Jul 2019 17:46:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KXyE9LPRaOuTKOHClToahKsRCSGxQwG4CXkWHAKu3XM=;
        b=CeEOoPzXmmoHMlI9sn4ydJTF7EywoW+EUgw2mGHOY6+IEels5EnRm72r0pQnVTfs6L
         CYEyUt/OYTKSVBqBFD6nrG3vEhBneeFzroA6FvJNI9zm2H+KfMfOipLuGCpmFuelOko8
         FTof0mGUUENCrWmThcgFHaGfKHb/ltNiNZlwzZn5F88Th9wiVfBe/XKZb/eiCPq2J/5n
         pqah+IqEjWi2KlPEVPXyKPnQBeAecjUA71qMBTVehIWBF8sLC5y6YQmgJMBnoHoFB+q7
         wtzFtj9/tnuT5uF7b5473hZa1HAuravcviEKxPrG9quXjsOCCRkjOpcPjakfye1Fri1U
         +roA==
X-Gm-Message-State: APjAAAWhXkeoHgZ5B1fDw0/04v5f8SySluW6qVAYhTnARppQHDrF6Ecl
        cFZfZO8GBM4nVRAH+2tP1ODuser731oByw==
X-Google-Smtp-Source: APXvYqwKQ3rjvtjRN/4Fgr2SU7y9XKuuP/USg2g9WzMgrZt+YhRI2UASj7oK9nUOFacrpfow4kxSUQ==
X-Received: by 2002:a5d:4403:: with SMTP id z3mr28870350wrq.29.1564274811763;
        Sat, 27 Jul 2019 17:46:51 -0700 (PDT)
Received: from mcroce-redhat.homenet.telecomitalia.it (host221-208-dynamic.27-79-r.retail.telecomitalia.it. [79.27.208.221])
        by smtp.gmail.com with ESMTPSA id n9sm100731131wrp.54.2019.07.27.17.46.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 27 Jul 2019 17:46:50 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Stefan Chulski <stefanc@marvell.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: [PATCH net v2] mvpp2: refactor MTU change code
Date:   Sun, 28 Jul 2019 02:46:45 +0200
Message-Id: <20190728004645.4807-1-mcroce@redhat.com>
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

Fixes: 3f518509dedc ("ethernet: Add new driver for Marvell Armada 375 network unit")
Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 41 ++++++-------------
 1 file changed, 13 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index b6591ea0c6d6..68fa2d563f0d 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -3700,6 +3700,7 @@ static int mvpp2_set_mac_address(struct net_device *dev, void *p)
 static int mvpp2_change_mtu(struct net_device *dev, int mtu)
 {
 	struct mvpp2_port *port = netdev_priv(dev);
+	bool running = netif_running(dev);
 	int err;
 
 	if (!IS_ALIGNED(MVPP2_RX_PKT_SIZE(mtu), 8)) {
@@ -3708,40 +3709,24 @@ static int mvpp2_change_mtu(struct net_device *dev, int mtu)
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


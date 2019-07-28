Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC3D0780BF
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 19:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbfG1Rf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 13:35:57 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39953 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbfG1Rf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jul 2019 13:35:57 -0400
Received: by mail-wr1-f66.google.com with SMTP id r1so59335856wrl.7
        for <netdev@vger.kernel.org>; Sun, 28 Jul 2019 10:35:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b2zuiNV9z+FTezAi/VZPRSNLA8E7gVpLhLnn8tmOsl8=;
        b=lDccMtkKsh+0eA5sF2W4toWln1qzrMgLWmW2ryFN0Zia3xIf4G9ibfXfuz+rXJ1Lny
         uk1HBsQAMZo9HIC8L0gCt5qnYRU3yUpYmjEdxxeubUAEAkezt8ew/vd+RU5vm+xOcoAV
         HaCvg0GyrQjFoTEE2/SJ4QzElcGh2JBYMelKHWlZE0hElpWKvHHvtSPMD/lUNkZ8CmiZ
         ch7KTg83eVY4ALtSQIkTlV+AMvuRgw7p7qxE5vq6T0VE8Pi/wH8Wjl0LRqGeFPh6I2Qv
         h7wKnbI6fNcFqZSYYgPvEg8t7hbQuWH8Hw/2dfaOlYWTHrbWWnDtDP2ftYTxItwn+0Pl
         oiRg==
X-Gm-Message-State: APjAAAXBIm1Bnm7626sR9XAx+gzS4UvZIOaTXlp4HlgchZskjnFq/S7/
        RfUgTYkTCC2MPta/otJYimuvpG5jLCc=
X-Google-Smtp-Source: APXvYqzmHrUH5DR1DuabwII6AeoWJ1witAV6rclFFLf5pp1RWkQsEUhAKHdon+uwsXhFoDu6Hpk5ww==
X-Received: by 2002:a5d:67cd:: with SMTP id n13mr41178123wrw.138.1564335355423;
        Sun, 28 Jul 2019 10:35:55 -0700 (PDT)
Received: from mcroce-redhat.redhat.com (host221-208-dynamic.27-79-r.retail.telecomitalia.it. [79.27.208.221])
        by smtp.gmail.com with ESMTPSA id x20sm134505614wrg.10.2019.07.28.10.35.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 28 Jul 2019 10:35:54 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Stefan Chulski <stefanc@marvell.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: [PATCH net v2] mvpp2: refactor the HW checksum setup
Date:   Sun, 28 Jul 2019 19:35:49 +0200
Message-Id: <20190728173549.32034-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hardware can only offload checksum calculation on first port due to
the Tx FIFO size limitation, and has a maximum L3 offset of 128 bytes.
Document this in a comment and move duplicated code in a function.

Fixes: 576193f2d579 ("net: mvpp2: jumbo frames support")
Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 35 ++++++++++++-------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 937e4b928b94..a99405135046 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -811,6 +811,26 @@ static int mvpp2_swf_bm_pool_init(struct mvpp2_port *port)
 	return 0;
 }
 
+static void mvpp2_set_hw_csum(struct mvpp2_port *port,
+			      enum mvpp2_bm_pool_log_num new_long_pool)
+{
+	const netdev_features_t csums = NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+
+	/* Update L4 checksum when jumbo enable/disable on port.
+	 * Only port 0 supports hardware checksum offload due to
+	 * the Tx FIFO size limitation.
+	 * Also, don't set NETIF_F_HW_CSUM because L3_offset in TX descriptor
+	 * has 7 bits, so the maximum L3 offset is 128.
+	 */
+	if (new_long_pool == MVPP2_BM_JUMBO && port->id != 0) {
+		port->dev->features &= ~csums;
+		port->dev->hw_features &= ~csums;
+	} else {
+		port->dev->features |= csums;
+		port->dev->hw_features |= csums;
+	}
+}
+
 static int mvpp2_bm_update_mtu(struct net_device *dev, int mtu)
 {
 	struct mvpp2_port *port = netdev_priv(dev);
@@ -843,15 +863,7 @@ static int mvpp2_bm_update_mtu(struct net_device *dev, int mtu)
 		/* Add port to new short & long pool */
 		mvpp2_swf_bm_pool_init(port);
 
-		/* Update L4 checksum when jumbo enable/disable on port */
-		if (new_long_pool == MVPP2_BM_JUMBO && port->id != 0) {
-			dev->features &= ~(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM);
-			dev->hw_features &= ~(NETIF_F_IP_CSUM |
-					      NETIF_F_IPV6_CSUM);
-		} else {
-			dev->features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
-			dev->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
-		}
+		mvpp2_set_hw_csum(port, new_long_pool);
 	}
 
 	dev->mtu = mtu;
@@ -5209,10 +5221,7 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 		dev->features |= NETIF_F_NTUPLE;
 	}
 
-	if (port->pool_long->id == MVPP2_BM_JUMBO && port->id != 0) {
-		dev->features &= ~(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM);
-		dev->hw_features &= ~(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM);
-	}
+	mvpp2_set_hw_csum(port, port->pool_long->id);
 
 	dev->vlan_features |= features;
 	dev->gso_max_segs = MVPP2_MAX_TSO_SEGS;
-- 
2.21.0


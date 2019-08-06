Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF3C8323E
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 15:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730188AbfHFNGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 09:06:37 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:35745 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbfHFNGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 09:06:37 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 462vzG5BB8z1sBS7;
        Tue,  6 Aug 2019 15:06:34 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 462vzG1Rvcz1qqkS;
        Tue,  6 Aug 2019 15:06:34 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id 75oNkHNVYBx3; Tue,  6 Aug 2019 15:06:31 +0200 (CEST)
X-Auth-Info: U/PWEmtbCMH3xC5ETjhLyjbJKKyTejS4fvaKaeHMfbg=
Received: from localhost.localdomain (cst-prg-69-96.cust.vodafone.cz [46.135.69.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue,  6 Aug 2019 15:06:31 +0200 (CEST)
From:   Marek Vasut <marex@denx.de>
To:     netdev@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: [PATCH 1/3] net: dsa: ksz: Remove dead code and fix warnings
Date:   Tue,  6 Aug 2019 15:06:07 +0200
Message-Id: <20190806130609.29686-1-marex@denx.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove ksz_port_cleanup(), which is unused. Add missing include
"ksz_common.h", which fixes the following warning when built with
make ... W=1

drivers/net/dsa/microchip/ksz_common.c:23:6: warning: no previous prototype for ‘...’ [-Wmissing-prototypes]

Note that the order of the headers cannot be swapped, as that would
trigger missing forward declaration errors, which would indicate the
way forward is to merge the two headers into one.

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: David S. Miller <davem@davemloft.net>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Tristram Ha <Tristram.Ha@microchip.com>
Cc: Vivien Didelot <vivien.didelot@gmail.com>
Cc: Woojung Huh <woojung.huh@microchip.com>
---
 drivers/net/dsa/microchip/ksz_common.c | 11 +----------
 drivers/net/dsa/microchip/ksz_common.h |  1 -
 2 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index ce20cc90f9ef..a1e6e560fde8 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -19,16 +19,7 @@
 #include <net/switchdev.h>
 
 #include "ksz_priv.h"
-
-void ksz_port_cleanup(struct ksz_device *dev, int port)
-{
-	/* Common code for port cleanup. */
-	mutex_lock(&dev->dev_mutex);
-	dev->on_ports &= ~(1 << port);
-	dev->live_ports &= ~(1 << port);
-	mutex_unlock(&dev->dev_mutex);
-}
-EXPORT_SYMBOL_GPL(ksz_port_cleanup);
+#include "ksz_common.h"
 
 void ksz_update_port_member(struct ksz_device *dev, int port)
 {
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 84fed4a2578b..9f9ff0fb3b53 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -9,7 +9,6 @@
 
 #include <linux/regmap.h>
 
-void ksz_port_cleanup(struct ksz_device *dev, int port);
 void ksz_update_port_member(struct ksz_device *dev, int port);
 void ksz_init_mib_timer(struct ksz_device *dev);
 
-- 
2.20.1


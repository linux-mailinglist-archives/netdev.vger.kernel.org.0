Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6248B4716DC
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 22:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbhLKVnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 16:43:12 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:3152 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbhLKVnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 16:43:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639258992; x=1670794992;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=duHVJqEHLRTSeXn8k5byUzvbaZ9BWdUr6/MSxxYjdTw=;
  b=qFKZudr16XZ6rfs5Sp2fGqZOdE0qqpm3TxeW0tl4YMSdJGVZY5ihOyCw
   nVIay5I53qmGs5jEEi4KTniwJfO1ahtGlSJC0L4jd97bG5JGla2qieAdz
   Dwgc4lTYj0P1716I0xgog4K3ReFcCI/RCERAQYgn1oecYxBN7Ro/nSQyI
   0pRi/q/p/HY/+WMc+kfUJwBi74qp8oIcCmNPE8R6tbqxCIHsbZi5PXmuN
   rF8iOJoTwij0LaZxPmfQSj+rlFQUh8L88mpOEZ1e3NZqHyvLB2TKAD91d
   dYluZCIikH5KDxKTZwUP8N5TA7fXx/5Cf92USwWud575S5+iPLZwdArMP
   A==;
IronPort-SDR: caX+W4Jn8lmqc96Flnla7Y22iyWs5rjPhkloQnj86FOhIg1ZHoKCrA6u7TyrUPYGNRdLGQSYHh
 9CB7UB1ZSiC8H1tfRXuxDeJ4Ho7QmRDIEfJ1baePn/VfI1S+LF1ifjblB5fTVd55y8aWLKyrIj
 JkQ9fRsvQXOGOhU5edigzip5f0flgz3PgBPMz/tW6wa+rxIqI7c7cBaoj6X4fEdy12I/ZyleCs
 wI0uJaiTJ4s/auflJnPJ0iMewQqiZriaDtybH45LiIGbqqXjPNjjz1Fq2TL2ZhU+gI+AeQ06v9
 zwmaM0xfC8Qxv4YUtn/rWJZ0
X-IronPort-AV: E=Sophos;i="5.88,199,1635231600"; 
   d="scan'208";a="155153470"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Dec 2021 14:43:11 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sat, 11 Dec 2021 14:43:11 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Sat, 11 Dec 2021 14:43:09 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <linux@armlinux.org.uk>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next] net: lan966x: Fix the configuration of the pcs
Date:   Sat, 11 Dec 2021 22:44:20 +0100
Message-ID: <20211211214420.1283938-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When inserting a SFP that runs at 2.5G, then the Serdes was still
configured to run at 1G. Because the config->speed was 0, and then the
speed of the serdes was not configured at all, it was using the default
value which is 1G. This patch stop calling the serdes function set_speed
and allow the serdes to figure out the speed based on the interface
type.

Fixes: d28d6d2e37d10d ("net: lan966x: add port module support")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_port.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_port.c b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
index 2ddb20585d40..237555845a52 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_port.c
@@ -331,7 +331,6 @@ int lan966x_port_pcs_set(struct lan966x_port *port,
 	struct lan966x *lan966x = port->lan966x;
 	bool inband_aneg = false;
 	bool outband;
-	int err;
 
 	if (config->inband) {
 		if (config->portmode == PHY_INTERFACE_MODE_SGMII ||
@@ -341,11 +340,6 @@ int lan966x_port_pcs_set(struct lan966x_port *port,
 			 config->autoneg)
 			inband_aneg = true; /* Clause-37 in-band-aneg */
 
-		if (config->speed > 0) {
-			err = phy_set_speed(port->serdes, config->speed);
-			if (err)
-				return err;
-		}
 		outband = false;
 	} else {
 		outband = true;
-- 
2.33.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6ED1C1661
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731806AbgEANri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 09:47:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59409 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731613AbgEANnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 09:43:18 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1jUVwd-00067j-4A; Fri, 01 May 2020 13:43:11 +0000
From:   Colin King <colin.king@canonical.com>
To:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-kernel@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] net: dsa: sja1105: fix speed setting for 10 MBPS
Date:   Fri,  1 May 2020 14:43:10 +0100
Message-Id: <20200501134310.289561-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The current logic for speed checking will never set the speed to 10 MBPS
because bmcr & BMCR_SPEED10 is always 0 since BMCR_SPEED10 is 0. Also
the erroneous setting where BMCR_SPEED1000 and BMCR_SPEED100 are both
set causes the speed to be 1000 MBS.  Fix this by masking bps and checking
for just the expected settings of BMCR_SPEED1000, BMCR_SPEED100 and
BMCR_SPEED10 and defaulting to the unknown speed otherwise.

Addresses-Coverity: ("Logically dead code")
Fixes: ffe10e679cec ("net: dsa: sja1105: Add support for the SGMII port")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 472f4eb20c49..59a9038cdc4e 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1600,6 +1600,7 @@ static const char * const sja1105_reset_reasons[] = {
 int sja1105_static_config_reload(struct sja1105_private *priv,
 				 enum sja1105_reset_reason reason)
 {
+	const int mask = (BMCR_SPEED1000 | BMCR_SPEED100 | BMCR_SPEED10);
 	struct ptp_system_timestamp ptp_sts_before;
 	struct ptp_system_timestamp ptp_sts_after;
 	struct sja1105_mac_config_entry *mac;
@@ -1684,14 +1685,16 @@ int sja1105_static_config_reload(struct sja1105_private *priv,
 		sja1105_sgmii_pcs_config(priv, an_enabled, false);
 
 		if (!an_enabled) {
-			int speed = SPEED_UNKNOWN;
+			int speed;
 
-			if (bmcr & BMCR_SPEED1000)
+			if ((bmcr & mask) == BMCR_SPEED1000)
 				speed = SPEED_1000;
-			else if (bmcr & BMCR_SPEED100)
+			else if ((bmcr & mask) == BMCR_SPEED100)
 				speed = SPEED_100;
-			else if (bmcr & BMCR_SPEED10)
+			else if ((bmcr & mask) == BMCR_SPEED10)
 				speed = SPEED_10;
+			else
+				speed = SPEED_UNKNOWN;
 
 			sja1105_sgmii_pcs_force_speed(priv, speed);
 		}
-- 
2.25.1


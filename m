Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 944AD17AA3
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 15:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbfEHNap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 09:30:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42613 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725778AbfEHNap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 09:30:45 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hOMef-00032b-UV; Wed, 08 May 2019 13:30:42 +0000
From:   Colin King <colin.king@canonical.com>
To:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH][V3] net: dsa: sja1105: fix check on while loop exit
Date:   Wed,  8 May 2019 14:30:41 +0100
Message-Id: <20190508133041.14435-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The while-loop exit condition check is not correct; the
loop should continue if the returns from the function calls are
negative or the CRC status returns are invalid.  Currently it
is ignoring the returns from the function calls.  Fix this by
removing the status return checks and only break from the loop
at the very end when we know that all the success condtions have
been met.

Kudos to Dan Carpenter for describing the correct fix and
Vladimir Oltean for noting the change to the check on the number
of retries.

Addresses-Coverity: ("Uninitialized scalar variable")
Fixes: 8aa9ebccae87 ("net: dsa: Introduce driver for NXP SJA1105 5-port L2 switch")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Tested-by: Vladimir Oltean <olteanv@gmail.com>
---

V2: Discard my broken origina fix. Use correct fix as described by
    Dan Carpenter.
V3: Remove empty line and check for retries != RETRIES fix.
---
 drivers/net/dsa/sja1105/sja1105_spi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 244a94ccfc18..49c5252a8dc6 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -466,14 +466,15 @@ int sja1105_static_config_upload(struct sja1105_private *priv)
 				"invalid, retrying...\n");
 			continue;
 		}
-	} while (--retries && (status.crcchkl == 1 || status.crcchkg == 1 ||
-		 status.configs == 0 || status.ids == 1));
+		/* Success! */
+		break;
+	} while (--retries);
 
 	if (!retries) {
 		rc = -EIO;
 		dev_err(dev, "Failed to upload config to device, giving up\n");
 		goto out;
-	} else if (retries != RETRIES - 1) {
+	} else if (retries != RETRIES) {
 		dev_info(dev, "Succeeded after %d tried\n", RETRIES - retries);
 	}
 
-- 
2.20.1


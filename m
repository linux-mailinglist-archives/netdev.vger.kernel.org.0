Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 833BF1616B
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 11:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726972AbfEGJug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 05:50:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38321 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbfEGJug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 05:50:36 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hNwk6-00071R-8o; Tue, 07 May 2019 09:50:34 +0000
From:   Colin King <colin.king@canonical.com>
To:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH][next] net: dsa: sja1105: fix check on while loop exit
Date:   Tue,  7 May 2019 10:50:33 +0100
Message-Id: <20190507095033.25396-1-colin.king@canonical.com>
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

Kudos to Dan Carpenter for describing the correct fix.

Addresses-Coverity: ("Uninitialized scalar variable")
Fixes: 8aa9ebccae87 ("net: dsa: Introduce driver for NXP SJA1105 5-port L2 switch")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---

V2: Discard my broken origina fix. Use correct fix as described by
    Dan Carpenter.
---
 drivers/net/dsa/sja1105/sja1105_spi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 244a94ccfc18..40ac696adf63 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -465,9 +465,11 @@ int sja1105_static_config_upload(struct sja1105_private *priv)
 			dev_err(dev, "Switch reported that configuration is "
 				"invalid, retrying...\n");
 			continue;
+
 		}
-	} while (--retries && (status.crcchkl == 1 || status.crcchkg == 1 ||
-		 status.configs == 0 || status.ids == 1));
+		/* Success! */
+		break;
+	} while (--retries);
 
 	if (!retries) {
 		rc = -EIO;
-- 
2.20.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2C615FAE
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 10:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbfEGIpC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 04:45:02 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36938 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbfEGIpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 04:45:02 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hNvic-0002y0-KP; Tue, 07 May 2019 08:44:58 +0000
From:   Colin King <colin.king@canonical.com>
To:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH][next] net: dsa: sja1105: fix comparisons against uninitialized status fields
Date:   Tue,  7 May 2019 09:44:58 +0100
Message-Id: <20190507084458.22520-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The call to sja1105_status_get to set various fields in the status
structure can potentially be skipped in a while-loop because of a couple
of prior continuation jump paths. This can potientially lead to checking
be checking against an uninitialized fields in the structure which may
lead to unexpected results.  Fix this by ensuring all the fields in status
are initialized to zero to be safe.

Addresses-Coverity: ("Uninitialized scalar variable")
Fixes: 8aa9ebccae87 ("net: dsa: Introduce driver for NXP SJA1105 5-port L2 switch")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/dsa/sja1105/sja1105_spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 244a94ccfc18..76f6a51e10d9 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -394,7 +394,7 @@ int sja1105_static_config_upload(struct sja1105_private *priv)
 	struct sja1105_static_config *config = &priv->static_config;
 	const struct sja1105_regs *regs = priv->info->regs;
 	struct device *dev = &priv->spidev->dev;
-	struct sja1105_status status;
+	struct sja1105_status status = {};
 	int rc, retries = RETRIES;
 	u8 *config_buf;
 	int buf_len;
-- 
2.20.1


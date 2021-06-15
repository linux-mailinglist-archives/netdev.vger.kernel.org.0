Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F03D23A7EFD
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 15:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbhFONSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 09:18:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60025 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229951AbhFONSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 09:18:14 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1lt8vC-0006S3-5o; Tue, 15 Jun 2021 13:16:02 +0000
From:   Colin King <colin.king@canonical.com>
To:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net: pcs: xpcs: Fix a less than zero u16 comparision error
Date:   Tue, 15 Jun 2021 14:16:01 +0100
Message-Id: <20210615131601.57900-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the check for the u16 variable val being less than zero is
always false because val is unsigned. Fix this by using the int
variable for the assignment and less than zero check.

Addresses-Coverity: ("Unsigned compared against 0")
Fixes: f7380bba42fd ("net: pcs: xpcs: add support for NXP SJA1110")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/pcs/pcs-xpcs-nxp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/pcs/pcs-xpcs-nxp.c b/drivers/net/pcs/pcs-xpcs-nxp.c
index de99c37cf2ae..80430ca94fbf 100644
--- a/drivers/net/pcs/pcs-xpcs-nxp.c
+++ b/drivers/net/pcs/pcs-xpcs-nxp.c
@@ -152,11 +152,11 @@ static int nxp_sja1110_pma_config(struct dw_xpcs *xpcs,
 	/* Enable TX and RX PLLs and circuits.
 	 * Release reset of PMA to enable data flow to/from PCS.
 	 */
-	val = xpcs_read(xpcs, MDIO_MMD_VEND2, SJA1110_POWERDOWN_ENABLE);
-	if (val < 0)
-		return val;
+	ret = xpcs_read(xpcs, MDIO_MMD_VEND2, SJA1110_POWERDOWN_ENABLE);
+	if (ret < 0)
+		return ret;
 
-	val &= ~(SJA1110_TXPLL_PD | SJA1110_TXPD | SJA1110_RXCH_PD |
+	val = ret & ~(SJA1110_TXPLL_PD | SJA1110_TXPD | SJA1110_RXCH_PD |
 		 SJA1110_RXBIAS_PD | SJA1110_RESET_SER_EN |
 		 SJA1110_RESET_SER | SJA1110_RESET_DES);
 	val |= SJA1110_RXPKDETEN | SJA1110_RCVEN;
-- 
2.31.1


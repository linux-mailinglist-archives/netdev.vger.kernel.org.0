Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0576713F7E7
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732407AbgAPQzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 11:55:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:41550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733095AbgAPQzw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:55:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3041322525;
        Thu, 16 Jan 2020 16:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193751;
        bh=GvVhxyid/xTcOoRUgor5PfjdDI/SM2qk5G0sLRGQlQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vL+IIm1syc9uBVwLwaoYA94SjNFXutGbGP+AsnFLmuyu4XMI4mI+Ea+qrzxW+fN6+
         Yrrs3C6QDOiWElu1dZ1LBKmd8qeZxKqzyxLUfCj+aOckDzAS6VF6yLHQth1rPkhNsN
         9OjXApHYBfduX0uM3meh8bVjVqKzt9zs1bwS5DUY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masahisa Kojima <masahisa.kojima@linaro.org>,
        Yoshitoyo Osaki <osaki.yoshitoyo@socionext.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 040/671] net: socionext: Add dummy PHY register read in phy_write()
Date:   Thu, 16 Jan 2020 11:44:31 -0500
Message-Id: <20200116165502.8838-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Masahisa Kojima <masahisa.kojima@linaro.org>

[ Upstream commit a3241a91de6429051a211b5ce04d6946157caec7 ]

There is a compatibility issue between RTL8211E implemented
in Developerbox and netsec ethernet controller IP.

Our MDIO controller stops MDC clock right after the write
access, but RTL8211E expects MDC clock must be kept toggling
for several clock cycle with MDIO high before entering
the IDLE state. Without keeping clock after write access,
write access is not correctly handled and register is not
updated.

To meet this requirement, netsec driver needs to issue dummy
read(e.g. read PHYID1(offset 0x2) register) right after write
access, to keep MDC clock.

We think this compatibility issue is a problem specific to
our MDIO controller and RTL8211E.

Fixes: 533dd11a12f6 ("net: socionext: Add Synquacer NetSec driver")
Signed-off-by: Masahisa Kojima <masahisa.kojima@linaro.org>
Signed-off-by: Yoshitoyo Osaki <osaki.yoshitoyo@socionext.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/socionext/netsec.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 28d582c18afb..d9d0d03e4ce7 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -432,9 +432,12 @@ static int netsec_mac_update_to_phy_state(struct netsec_priv *priv)
 	return 0;
 }
 
+static int netsec_phy_read(struct mii_bus *bus, int phy_addr, int reg_addr);
+
 static int netsec_phy_write(struct mii_bus *bus,
 			    int phy_addr, int reg, u16 val)
 {
+	int status;
 	struct netsec_priv *priv = bus->priv;
 
 	if (netsec_mac_write(priv, GMAC_REG_GDR, val))
@@ -447,8 +450,19 @@ static int netsec_phy_write(struct mii_bus *bus,
 			      GMAC_REG_SHIFT_CR_GAR)))
 		return -ETIMEDOUT;
 
-	return netsec_mac_wait_while_busy(priv, GMAC_REG_GAR,
-					  NETSEC_GMAC_GAR_REG_GB);
+	status = netsec_mac_wait_while_busy(priv, GMAC_REG_GAR,
+					    NETSEC_GMAC_GAR_REG_GB);
+
+	/* Developerbox implements RTL8211E PHY and there is
+	 * a compatibility problem with F_GMAC4.
+	 * RTL8211E expects MDC clock must be kept toggling for several
+	 * clock cycle with MDIO high before entering the IDLE state.
+	 * To meet this requirement, netsec driver needs to issue dummy
+	 * read(e.g. read PHYID1(offset 0x2) register) right after write.
+	 */
+	netsec_phy_read(bus, phy_addr, MII_PHYSID1);
+
+	return status;
 }
 
 static int netsec_phy_read(struct mii_bus *bus, int phy_addr, int reg_addr)
-- 
2.20.1


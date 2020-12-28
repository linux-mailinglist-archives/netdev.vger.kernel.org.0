Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 838EF2E6883
	for <lists+netdev@lfdr.de>; Mon, 28 Dec 2020 17:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729807AbgL1NBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 08:01:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729791AbgL1NB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 08:01:29 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99801C061796;
        Mon, 28 Dec 2020 05:00:48 -0800 (PST)
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id A94D323E59;
        Mon, 28 Dec 2020 14:00:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1609160444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZwC4/2xHp6OXJruH8P3nrBhWVIYJhBQqf8GOmQ4Kr5E=;
        b=lSYAC2u+zLwTZZO2GQFRKGljamC/JV4fVZlQqJfQiSBYS2Ty8MHb3kMYKFEpgOy28O8p4o
        w3rCeyHdpz1igNT7f5UEHkbQCC07wJeKk/M7a0Y6NgaU1Ssp4J2VG6gmkgxkK1RWb6pfU+
        UT+0YMV9/DCTqYjliP99+gEIRgm/mE8=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Michael Walle <michael@walle.cc>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH RESEND net-next 2/4] enetc: don't use macro magic for the readx_poll_timeout() callback
Date:   Mon, 28 Dec 2020 14:00:32 +0100
Message-Id: <20201228130034.21577-3-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201228130034.21577-1-michael@walle.cc>
References: <20201228130034.21577-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The macro enetc_mdio_rd_reg() is just used in that particular case and
has a hardcoded parameter name "mdio_priv". Define a specific function
to use for readx_poll_timeout() instead. Also drop the TIMEOUT macro
since it is used just once.

Signed-off-by: Michael Walle <michael@walle.cc>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_mdio.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_mdio.c b/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
index 94fcc76dc590..665f7a0c71cb 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
@@ -25,8 +25,6 @@ static inline void enetc_mdio_wr(struct enetc_mdio_priv *mdio_priv, int off,
 	enetc_port_wr_mdio(mdio_priv->hw, mdio_priv->mdio_base + off, val);
 }
 
-#define enetc_mdio_rd_reg(off)	enetc_mdio_rd(mdio_priv, off)
-
 #define MDIO_CFG_CLKDIV(x)	((((x) >> 1) & 0xff) << 8)
 #define MDIO_CFG_BSY		BIT(0)
 #define MDIO_CFG_RD_ER		BIT(1)
@@ -45,13 +43,17 @@ static inline void enetc_mdio_wr(struct enetc_mdio_priv *mdio_priv, int off,
 #define MDIO_CTL_READ		BIT(15)
 #define MDIO_DATA(x)		((x) & 0xffff)
 
-#define TIMEOUT	1000
+static bool enetc_mdio_is_busy(struct enetc_mdio_priv *mdio_priv)
+{
+	return enetc_mdio_rd(mdio_priv, ENETC_MDIO_CFG) & MDIO_CFG_BSY;
+}
+
 static int enetc_mdio_wait_complete(struct enetc_mdio_priv *mdio_priv)
 {
-	u32 val;
+	bool is_busy;
 
-	return readx_poll_timeout(enetc_mdio_rd_reg, ENETC_MDIO_CFG, val,
-				  !(val & MDIO_CFG_BSY), 10, 10 * TIMEOUT);
+	return readx_poll_timeout(enetc_mdio_is_busy, mdio_priv,
+				  is_busy, !is_busy, 10, 10 * 1000);
 }
 
 int enetc_mdio_write(struct mii_bus *bus, int phy_id, int regnum, u16 value)
-- 
2.20.1


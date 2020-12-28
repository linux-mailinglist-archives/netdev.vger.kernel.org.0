Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3B0C2E6890
	for <lists+netdev@lfdr.de>; Mon, 28 Dec 2020 17:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442141AbgL1Qh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 11:37:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729574AbgL1NB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 08:01:29 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934EFC061795;
        Mon, 28 Dec 2020 05:00:48 -0800 (PST)
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 105B123E5D;
        Mon, 28 Dec 2020 14:00:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1609160445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f/gTlQDl/FoQaerYzhVdNmycQ6bHEHM1Kxh7tH5lH7o=;
        b=M34NbkJ5wWnoIkIlPswBPoYonMRCaS6WeHLUsa423+CnZ8tvkJABM0MFy3r6a0m0fo9tBc
        yciItO302qkU6jm0x5YE0CIk62uu3C+xwieY5pYQblnjAsvTsY2LWMMvuswhbQ8nFd7DfC
        kVldc9O+4MFCDGAMLZL25JWJAEKqAVA=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Michael Walle <michael@walle.cc>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH RESEND net-next 3/4] enetc: drop MDIO_DATA() macro
Date:   Mon, 28 Dec 2020 14:00:33 +0100
Message-Id: <20201228130034.21577-4-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201228130034.21577-1-michael@walle.cc>
References: <20201228130034.21577-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

value is u16, masking with 0xffff is a nop. Drop it.

Signed-off-by: Michael Walle <michael@walle.cc>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_mdio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_mdio.c b/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
index 665f7a0c71cb..591b16f01507 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_mdio.c
@@ -41,7 +41,6 @@ static inline void enetc_mdio_wr(struct enetc_mdio_priv *mdio_priv, int off,
 #define MDIO_CTL_DEV_ADDR(x)	((x) & 0x1f)
 #define MDIO_CTL_PORT_ADDR(x)	(((x) & 0x1f) << 5)
 #define MDIO_CTL_READ		BIT(15)
-#define MDIO_DATA(x)		((x) & 0xffff)
 
 static bool enetc_mdio_is_busy(struct enetc_mdio_priv *mdio_priv)
 {
@@ -93,7 +92,7 @@ int enetc_mdio_write(struct mii_bus *bus, int phy_id, int regnum, u16 value)
 	}
 
 	/* write the value */
-	enetc_mdio_wr(mdio_priv, ENETC_MDIO_DATA, MDIO_DATA(value));
+	enetc_mdio_wr(mdio_priv, ENETC_MDIO_DATA, value);
 
 	ret = enetc_mdio_wait_complete(mdio_priv);
 	if (ret)
-- 
2.20.1


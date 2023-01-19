Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADA1673985
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 14:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbjASNI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 08:08:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbjASNIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 08:08:05 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57AD2613C1;
        Thu, 19 Jan 2023 05:08:01 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 17FA41A00;
        Thu, 19 Jan 2023 14:07:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1674133679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8ucNqQrBv58FmJgsbqN8x3M/G1cfrpq7tqtLwGp8Zts=;
        b=BO/W7ryvR8JDotAf4gWdeS8Dhl59cGsFoi2/VnxatK00UV12d84+KVEVwGfDL8trZQBnc+
        49hLDoUSNcQCQtN4ZVeOAI0dyEb+tNHVH1L8GNuYlK+07FEsRD3IRwEQZ5B/adTcnrzazY
        HmDIqU/fUL97iMbwdSjzRRA0kOypKtd15rrc/7qZAdyJRUQumxYBxBGm6d53iZtp4z6V3n
        HwP+BjH8gf176YsJHMPazgLiq1kx4TNoXJTop86c7QkTOAueyZsuTW7tzMcpeJRYRRXmkH
        RV1t7L68Q23HalVppN3uKO0DLIapfih8QyyqhJ5svBPlhCLRnlxVS4vNivCqiQ==
From:   Michael Walle <michael@walle.cc>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Wells Lu <wellslutw@gmail.com>,
        Jiawen Wu <jiawenwu@trustnetic.com>,
        Mengyuan Lou <mengyuanlou@net-swift.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Tobias Waldekranz <tobias@waldekranz.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-actions@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Michael Walle <michael@walle.cc>
Subject: [PATCH RESEND net-next 2/4] net: ngbe: Drop mdiobus_c45_regad()
Date:   Thu, 19 Jan 2023 14:06:58 +0100
Message-Id: <20230119130700.440601-3-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230119130700.440601-1-michael@walle.cc>
References: <20230119130700.440601-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the new C45 MDIO access API, there is no encoding of the register
number anymore and thus the masking isn't necessary anymore. Remove it.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.c
index ba33a57b42c2..c9ddbbc3fa4f 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.c
@@ -92,7 +92,7 @@ static int ngbe_phy_read_reg_mdi_c45(struct mii_bus *bus, int phy_addr, int devn
 
 	wr32(wx, NGBE_MDIO_CLAUSE_SELECT, 0x0);
 	/* setup and write the address cycle command */
-	command = NGBE_MSCA_RA(mdiobus_c45_regad(regnum)) |
+	command = NGBE_MSCA_RA(regnum) |
 		  NGBE_MSCA_PA(phy_addr) |
 		  NGBE_MSCA_DA(devnum);
 	wr32(wx, NGBE_MSCA, command);
@@ -121,7 +121,7 @@ static int ngbe_phy_write_reg_mdi_c45(struct mii_bus *bus, int phy_addr,
 
 	wr32(wx, NGBE_MDIO_CLAUSE_SELECT, 0x0);
 	/* setup and write the address cycle command */
-	command = NGBE_MSCA_RA(mdiobus_c45_regad(regnum)) |
+	command = NGBE_MSCA_RA(regnum) |
 		  NGBE_MSCA_PA(phy_addr) |
 		  NGBE_MSCA_DA(devnum);
 	wr32(wx, NGBE_MSCA, command);
-- 
2.30.2


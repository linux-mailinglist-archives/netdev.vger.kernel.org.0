Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B833662A0F
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 16:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237330AbjAIPcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 10:32:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237225AbjAIPbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 10:31:45 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 594D79598;
        Mon,  9 Jan 2023 07:30:57 -0800 (PST)
Received: from mwalle01.sab.local (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 0282E1654;
        Mon,  9 Jan 2023 16:30:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1673278255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cwldWyFf7CaFTxQBOBymigKCBxPFmfPQFSYXECFA1MQ=;
        b=oBe/wDiEGzYu9Fc30RDGqfOtePnx+5N67Jc8XWAwViJATJbP5JciHihYt08LZ2CPnqoGXm
        uZArpFXb8LGFjfjAjXXX7S79M2PS+79KJbqSZO69qsWKd3bzRrrLYAYIXYg6ql+KNj6eYf
        QFLV/7qysP76I17N9ZXUkpM8Co/fADHz8zTv8pRK0+sadsWUa23hOO8F8/TFqbhkDxEDNV
        Kh4IJzK9xvXaw84ecISSaMUBh90vtEkIuwjqMygFfeNX7aQTRJKU3bGSi62Qh3a0YIRJXQ
        PD2iEEB36IH2lBcrduXuSgnBMlXDpiUEHLj2BemVjPRj+aiM8jY7HGIZ/J1pvg==
From:   Michael Walle <michael@walle.cc>
Date:   Mon, 09 Jan 2023 16:30:44 +0100
Subject: [PATCH net-next v3 04/11] net: mdio: C22 is now optional, EOPNOTSUPP
 if not provided
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221227-v6-2-rc1-c45-seperation-v3-4-ade1deb438da@walle.cc>
References: <20221227-v6-2-rc1-c45-seperation-v3-0-ade1deb438da@walle.cc>
In-Reply-To: <20221227-v6-2-rc1-c45-seperation-v3-0-ade1deb438da@walle.cc>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Michael Walle <michael@walle.cc>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
X-Mailer: b4 0.11.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

When performing a C22 operation, check that the bus driver actually
provides the methods, and return -EOPNOTSUPP if not. C45 only busses
do exist, and in future their C22 methods will be NULL.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/mdio_bus.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index c992a9fd8b01..f71ba6ab85a7 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -766,7 +766,10 @@ int __mdiobus_read(struct mii_bus *bus, int addr, u32 regnum)
 
 	lockdep_assert_held_once(&bus->mdio_lock);
 
-	retval = bus->read(bus, addr, regnum);
+	if (bus->read)
+		retval = bus->read(bus, addr, regnum);
+	else
+		retval = -EOPNOTSUPP;
 
 	trace_mdio_access(bus, 1, addr, regnum, retval, retval);
 	mdiobus_stats_acct(&bus->stats[addr], true, retval);
@@ -792,7 +795,10 @@ int __mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val)
 
 	lockdep_assert_held_once(&bus->mdio_lock);
 
-	err = bus->write(bus, addr, regnum, val);
+	if (bus->write)
+		err = bus->write(bus, addr, regnum, val);
+	else
+		err = -EOPNOTSUPP;
 
 	trace_mdio_access(bus, 0, addr, regnum, val, err);
 	mdiobus_stats_acct(&bus->stats[addr], false, err);

-- 
2.30.2

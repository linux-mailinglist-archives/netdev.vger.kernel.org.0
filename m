Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E76CA6570C8
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 00:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbiL0XIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 18:08:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232120AbiL0XHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 18:07:43 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34AE8EAE;
        Tue, 27 Dec 2022 15:07:27 -0800 (PST)
Received: from mwalle01.sab.local (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 7D1BB4E;
        Wed, 28 Dec 2022 00:07:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1672182444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=TRJcRR333rwL5PCfo8eZYRyTNn3aczY+GklZvIg5sSY=;
        b=vJobZ7uDgnBqcNJVTD+NPckdxu2oXipLrsPAfDHIbxJVB7iXrJ+CCWCM2NW4C8aSNqcrze
        F8wDuIHwX3neVjiVJNlstpEHQKiE8URJHm/R55y7XiUwSEWFAgqRFGbXiwF9Pc88e5spVy
        Dq4tXerL6Ow30zNemsGELDLpeCwlrzTyRFzmBHz/RJA6erZC8YsOXeoXslP65xPEcKgxSQ
        PqwetYkhuKiDfzBhImFPYs4hkccDs2X3vxrv4NiUyh/vtFp69bvyn72JJ2ib9HH9oAIqMh
        LNR+6019sVyujch6Kn+bs3fEJKJJhp+aPSQNj++BQOBQbEtXiq+WsgKW7TqS8g==
From:   Michael Walle <michael@walle.cc>
Subject: [PATCH RFC net-next v2 00/12] net: mdio: Start separating C22 and C45
Date:   Wed, 28 Dec 2022 00:07:17 +0100
Message-Id: <20221227-v6-2-rc1-c45-seperation-v2-0-ddb37710e5a7@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKV6q2MC/x2NQQrCMBBFr1Jm7UAzpi24FTyAW3ExjVObhbHMh
 FIovbuJy/c+j7+DiUYxuDQ7qKzR4jcVoFMDYeb0FoyvwkAtkSMacO2RUIPD4Ds0WUQ5lwa78zT0
 5H3L7KDUI5vgqJzCXPsPWxatw6Iyxe1/+YD77VpdkoxJtgzP4/gBxbsN8ZMAAAA=
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
        Michael Walle <michael@walle.cc>
X-Mailer: b4 0.11.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've picked this older series from Andrew up and rebased it onto
v6.2-rc1.

This patch set starts the separation of C22 and C45 MDIO bus
transactions at the API level to the MDIO Bus drivers. C45 read and
write ops are added to the MDIO bus driver structure, and the MDIO
core will try to use these ops if requested to perform a C45
transfer. If not available a fallback to the older API is made, to
allow backwards compatibility until all drivers are converted.

A few drivers are then converted to this new API.

Link to v1: https://lore.kernel.org/netdev/20220508153049.427227-1-andrew@lunn.ch/

To: Heiner Kallweit <hkallweit1@gmail.com>
To: Russell King <linux@armlinux.org.uk>
To: "David S. Miller" <davem@davemloft.net>
To: Eric Dumazet <edumazet@google.com>
To: Jakub Kicinski <kuba@kernel.org>
To: Paolo Abeni <pabeni@redhat.com>
To: Jose Abreu <Jose.Abreu@synopsys.com>
To: Sergey Shtylyov <s.shtylyov@omp.ru>
To: Wei Fang <wei.fang@nxp.com>
To: Shenwei Wang <shenwei.wang@nxp.com>
To: Clark Wang <xiaoning.wang@nxp.com>
To: NXP Linux Team <linux-imx@nxp.com>
To: Sean Wang <sean.wang@mediatek.com>
To: Landen Chao <Landen.Chao@mediatek.com>
To: DENG Qingfang <dqfext@gmail.com>
To: Florian Fainelli <f.fainelli@gmail.com>
To: Vladimir Oltean <olteanv@gmail.com>
To: Matthias Brugger <matthias.bgg@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-mediatek@lists.infradead.org
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>

---
Andrew Lunn (12):
      net: mdio: Add dedicated C45 API to MDIO bus drivers
      net: pcs: pcs-xpcs: Use C45 MDIO API
      net: mdio: mdiobus_register: update validation test
      net: mdio: C22 is now optional, EOPNOTSUPP if not provided
      net: mdio: Move mdiobus_c45_addr() next to users
      net: mdio: mdio-bitbang: Separate C22 and C45 transactions
      net: mdio: mvmdio: Convert XSMI bus to new API
      net: ethernet: freescale: xgmac: Separate C22 and C45 transactions for xgmac
      net: ethernet: freescale: fec: Separate C22 and C45 transactions for xgmac
      net: mdio: add mdiobus_c45_read/write_nested helpers
      net: dsa: Separate C22 and C45 MDIO bus transaction methods
      net: dsa: mv88e6xxx: Separate C22 and C45 transactions

 drivers/net/dsa/mt7530.c                    |  87 ++++-----
 drivers/net/dsa/mt7530.h                    |  15 +-
 drivers/net/dsa/mv88e6xxx/chip.c            | 175 +++++++++++++-----
 drivers/net/dsa/mv88e6xxx/chip.h            |   7 +
 drivers/net/dsa/mv88e6xxx/global2.c         |  66 ++++---
 drivers/net/dsa/mv88e6xxx/global2.h         |  18 +-
 drivers/net/dsa/mv88e6xxx/phy.c             |  32 ++++
 drivers/net/dsa/mv88e6xxx/phy.h             |   4 +
 drivers/net/dsa/mv88e6xxx/serdes.c          |   8 +-
 drivers/net/ethernet/freescale/fec_main.c   | 153 +++++++++++-----
 drivers/net/ethernet/freescale/xgmac_mdio.c | 150 +++++++++++----
 drivers/net/ethernet/marvell/mvmdio.c       |  24 +--
 drivers/net/ethernet/renesas/sh_eth.c       |  37 +++-
 drivers/net/mdio/mdio-bitbang.c             |  77 +++++---
 drivers/net/pcs/pcs-xpcs.c                  |   4 +-
 drivers/net/phy/mdio_bus.c                  | 273 +++++++++++++++++++++++++++-
 include/linux/mdio-bitbang.h                |   6 +-
 include/linux/mdio.h                        |  48 ++---
 include/linux/phy.h                         |   5 +
 include/net/dsa.h                           |   2 +-
 20 files changed, 891 insertions(+), 300 deletions(-)
---
base-commit: 1b929c02afd37871d5afb9d498426f83432e71c2
change-id: 20221227-v6-2-rc1-c45-seperation-53f762440aa1

Best regards,
-- 
Michael Walle <michael@walle.cc>

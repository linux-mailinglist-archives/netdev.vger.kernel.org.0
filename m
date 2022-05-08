Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7F251EEB2
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 17:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234882AbiEHPfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 11:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234869AbiEHPfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 11:35:11 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F528E039
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 08:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=LUHM54y0+uM3Eth280wbRhYMnwxCDQQU0Ij6IDgnG80=; b=Ls2q8fvaFM+jJZPDMmlnUBJQvN
        Bh5q8mkewP7X29oLviVYIM0sCMZ2N8MjeF4oAtL6pOMryEZf5cEGuFDF6IEYkGiL06Z7Cm8k2Mssq
        Rz82Yo5c/H9ukvWROttBLd85VSDAifT6hmKm3sPWjtIB2A/rVN3e6Y6PaSTIfXmOyL0U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nnisJ-001n9k-58; Sun, 08 May 2022 17:31:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Markus Koch <markus@notsyncing.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Hao Chen <chenhao288@hisilicon.com>
Subject: [PATCH net-next 04/10] net: mdio: Move mdiobus_c45_addr() next to users
Date:   Sun,  8 May 2022 17:30:43 +0200
Message-Id: <20220508153049.427227-5-andrew@lunn.ch>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220508153049.427227-1-andrew@lunn.ch>
References: <20220508153049.427227-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that mdiobus_c45_addr() is only used within the MDIO code during
fallback, move the function next to its only users. This function
should not be used any more in drivers, the c45 helpers should be used
in its place, so hiding it away will prevent any new users from being
added.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/mdio_bus.c | 5 +++++
 include/linux/mdio.h       | 5 -----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 4638ae3e13e3..46cc7b77620e 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -840,6 +840,11 @@ int __mdiobus_modify_changed(struct mii_bus *bus, int addr, u32 regnum,
 }
 EXPORT_SYMBOL_GPL(__mdiobus_modify_changed);
 
+static u32 mdiobus_c45_addr(int devad, u16 regnum)
+{
+	return MII_ADDR_C45 | devad << MII_DEVADDR_C45_SHIFT | regnum;
+}
+
 /**
  * __mdiobus_c45_read - Unlocked version of the mdiobus_c45_read function
  * @bus: the mii_bus struct
diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index d89b0879692e..ed91e2329df7 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -456,11 +456,6 @@ static inline int mdiodev_modify_changed(struct mdio_device *mdiodev,
 				      mask, set);
 }
 
-static inline u32 mdiobus_c45_addr(int devad, u16 regnum)
-{
-	return MII_ADDR_C45 | devad << MII_DEVADDR_C45_SHIFT | regnum;
-}
-
 static inline u16 mdiobus_c45_regad(u32 regnum)
 {
 	return FIELD_GET(MII_REGADDR_C45_MASK, regnum);
-- 
2.36.0


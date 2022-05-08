Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C61451EEB3
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 17:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234993AbiEHPfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 11:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234925AbiEHPfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 11:35:24 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B06D3E091
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 08:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Wub2o2o5opWSk2owkpZC7OOd9FIctYGP1nAZJ6u1f1Q=; b=jigMk5ME09Qawsc2Mgf3vz4wQb
        MAY5usYAazbwUwvitmym0poE+7FQ1yd++5ciefDk3+fA7/4ifN77SI71JEFwsXrWZM80+7hv//pL2
        H7XDDHY2NqVJcXKnXUvkoRLg2JgxriC9lh/U9BnKZmiBGGuikittJFMuacDebvqqHoOg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nnisJ-001n9g-2d; Sun, 08 May 2022 17:31:11 +0200
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
Subject: [PATCH net-next 02/10] net: mdio: mdiobus_register: Update validation test
Date:   Sun,  8 May 2022 17:30:41 +0200
Message-Id: <20220508153049.427227-3-andrew@lunn.ch>
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

Now that C45 uses its own read/write methods, the validation performed
when a bus is registers needs updating. All combinations of C22 and
C45 are supported, but both read and write methods must be provided,
read only busses are not supported etc.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/mdio_bus.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 46a03c0b45e3..818d22fb3cb5 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -526,8 +526,16 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 	int i, err;
 	struct gpio_desc *gpiod;
 
-	if (NULL == bus || NULL == bus->name ||
-	    NULL == bus->read || NULL == bus->write)
+	if (NULL == bus || NULL == bus->name)
+		return -EINVAL;
+
+	if (!bus->read != !bus->write)
+		return -EINVAL;
+
+	if (!bus->read_c45 != !bus->write_c45)
+		return -EINVAL;
+
+	if (!bus->read && !bus->read_c45)
 		return -EINVAL;
 
 	if (bus->parent && bus->parent->of_node)
-- 
2.36.0


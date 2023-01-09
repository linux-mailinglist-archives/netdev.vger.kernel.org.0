Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 351C66629F9
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 16:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237304AbjAIPcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 10:32:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237187AbjAIPbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 10:31:44 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB5065E2;
        Mon,  9 Jan 2023 07:30:56 -0800 (PST)
Received: from mwalle01.sab.local (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id C9F2F15CC;
        Mon,  9 Jan 2023 16:30:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1673278254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+RDMkazwnleO/fGtNxWpy8pqhwNMPSCM9ZW84mCDuiE=;
        b=qsEmH9XrJ/gPd9gPF8FJEUHIsI9UnJrp3l36osJeyr5oepbAa3ovWzx7gV/qU4HMWRci8U
        G1I9V6M8urFgukeuwTORqczyc6U9Ic/PTud2II3GFgmc5ThFpqtcKcCTRcb8dErgLn59tg
        WTXjhEWPmGx9QPab7pkiuizzC+FjF5ZuWh0E0RB4EObTB5cRsKzho6b2rUzrKXqPxOxVxI
        SdJrapc0y/QC5wAozScgIg7p46KjnnVdFjh0lm3vlM26VHD7Q8c8T4OSBk2dHzrTHo8aTF
        Xh6xjXJ0MtBzryAvymHpaw/ZHJwCrgAtzXhNeSxOXFcTQ2taolyLB7+mYZkwWA==
From:   Michael Walle <michael@walle.cc>
Date:   Mon, 09 Jan 2023 16:30:42 +0100
Subject: [PATCH net-next v3 02/11] net: pcs: pcs-xpcs: Use C45 MDIO API
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221227-v6-2-rc1-c45-seperation-v3-2-ade1deb438da@walle.cc>
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

Convert the PCS-XPCS driver to make use of the C45 MDIO bus API for
modify_change().

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michael Walle <michael@walle.cc>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2:
 - [al] new patch
---
 drivers/net/pcs/pcs-xpcs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index f6a038a1d51e..bc428a816719 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -199,9 +199,7 @@ int xpcs_write(struct dw_xpcs *xpcs, int dev, u32 reg, u16 val)
 static int xpcs_modify_changed(struct dw_xpcs *xpcs, int dev, u32 reg,
 			       u16 mask, u16 set)
 {
-	u32 reg_addr = mdiobus_c45_addr(dev, reg);
-
-	return mdiodev_modify_changed(xpcs->mdiodev, reg_addr, mask, set);
+	return mdiodev_c45_modify_changed(xpcs->mdiodev, dev, reg, mask, set);
 }
 
 static int xpcs_read_vendor(struct dw_xpcs *xpcs, int dev, u32 reg)

-- 
2.30.2

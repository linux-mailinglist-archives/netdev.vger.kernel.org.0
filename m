Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFAB966D354
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 00:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235028AbjAPXwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 18:52:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234347AbjAPXwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 18:52:49 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B192F22A05;
        Mon, 16 Jan 2023 15:52:48 -0800 (PST)
Received: from mwalle01.sab.local (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 520EB168F;
        Tue, 17 Jan 2023 00:52:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1673913166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=//jZFF/GKZSX23gW4WXwNqIqRriY0jkw/xc8m4eElhk=;
        b=n+unXMBKmVQ6lkMZJUho3EF4QaA/MqsEgo/LrLZTw7btUrypYoJdg1HHeP55rJlFRxboNT
        0vZiIZ2s1pbZZlpJy1qGoXqOGT67Xco90tEx+VIHUc6GGJN1fAlEbctLk/Xqf4l5Bm7pVE
        2HY9bKMXwdfXZHQR5AAfVI9bKmwTBIyCXAo0A/lBpN4dcZLCGS1CXnzzNDWdjEPgBkp6W/
        nhj3kcgGLDZDP1IBnrjHNVr2XP1TStjM5NOZSVmLWlrwbUFbFJeFitySL9i99nYWiYp0Xp
        8p0TRzCxpz0jELJdAxVgbtLiwrH7HzRUBRXyBwnzYAHJ5uv8164vnFiJep+eNw==
From:   Michael Walle <michael@walle.cc>
Date:   Tue, 17 Jan 2023 00:52:19 +0100
Subject: [PATCH net-next 04/12] net: macb: Separate C22 and C45 transactions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230116-net-next-c45-seperation-part-3-v1-4-0c53afa56aad@walle.cc>
References: <20230116-net-next-c45-seperation-part-3-v1-0-0c53afa56aad@walle.cc>
In-Reply-To: <20230116-net-next-c45-seperation-part-3-v1-0-0c53afa56aad@walle.cc>
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Byungho An <bh74.an@samsung.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org,
        linux-renesas-soc@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
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

From: Andrew Lunn <andrew@lunn.ch>

The macb MDIO bus driver can perform both C22 and C45 transfers.
Create separate functions for each and register the C45 versions using
the new API calls where appropriate.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/ethernet/cadence/macb_main.c | 161 +++++++++++++++++++++----------
 1 file changed, 108 insertions(+), 53 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 95667b979fab..f2d08a2dadf9 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -334,7 +334,7 @@ static int macb_mdio_wait_for_idle(struct macb *bp)
 				  1, MACB_MDIO_TIMEOUT);
 }
 
-static int macb_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
+static int macb_mdio_read_c22(struct mii_bus *bus, int mii_id, int regnum)
 {
 	struct macb *bp = bus->priv;
 	int status;
@@ -347,31 +347,58 @@ static int macb_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
 	if (status < 0)
 		goto mdio_read_exit;
 
-	if (regnum & MII_ADDR_C45) {
-		macb_writel(bp, MAN, (MACB_BF(SOF, MACB_MAN_C45_SOF)
-			    | MACB_BF(RW, MACB_MAN_C45_ADDR)
-			    | MACB_BF(PHYA, mii_id)
-			    | MACB_BF(REGA, (regnum >> 16) & 0x1F)
-			    | MACB_BF(DATA, regnum & 0xFFFF)
-			    | MACB_BF(CODE, MACB_MAN_C45_CODE)));
-
-		status = macb_mdio_wait_for_idle(bp);
-		if (status < 0)
-			goto mdio_read_exit;
-
-		macb_writel(bp, MAN, (MACB_BF(SOF, MACB_MAN_C45_SOF)
-			    | MACB_BF(RW, MACB_MAN_C45_READ)
-			    | MACB_BF(PHYA, mii_id)
-			    | MACB_BF(REGA, (regnum >> 16) & 0x1F)
-			    | MACB_BF(CODE, MACB_MAN_C45_CODE)));
-	} else {
-		macb_writel(bp, MAN, (MACB_BF(SOF, MACB_MAN_C22_SOF)
-				| MACB_BF(RW, MACB_MAN_C22_READ)
-				| MACB_BF(PHYA, mii_id)
-				| MACB_BF(REGA, regnum)
-				| MACB_BF(CODE, MACB_MAN_C22_CODE)));
+	macb_writel(bp, MAN, (MACB_BF(SOF, MACB_MAN_C22_SOF)
+			      | MACB_BF(RW, MACB_MAN_C22_READ)
+			      | MACB_BF(PHYA, mii_id)
+			      | MACB_BF(REGA, regnum)
+			      | MACB_BF(CODE, MACB_MAN_C22_CODE)));
+
+	status = macb_mdio_wait_for_idle(bp);
+	if (status < 0)
+		goto mdio_read_exit;
+
+	status = MACB_BFEXT(DATA, macb_readl(bp, MAN));
+
+mdio_read_exit:
+	pm_runtime_mark_last_busy(&bp->pdev->dev);
+	pm_runtime_put_autosuspend(&bp->pdev->dev);
+mdio_pm_exit:
+	return status;
+}
+
+static int macb_mdio_read_c45(struct mii_bus *bus, int mii_id, int devad,
+			      int regnum)
+{
+	struct macb *bp = bus->priv;
+	int status;
+
+	status = pm_runtime_get_sync(&bp->pdev->dev);
+	if (status < 0) {
+		pm_runtime_put_noidle(&bp->pdev->dev);
+		goto mdio_pm_exit;
 	}
 
+	status = macb_mdio_wait_for_idle(bp);
+	if (status < 0)
+		goto mdio_read_exit;
+
+	macb_writel(bp, MAN, (MACB_BF(SOF, MACB_MAN_C45_SOF)
+			      | MACB_BF(RW, MACB_MAN_C45_ADDR)
+			      | MACB_BF(PHYA, mii_id)
+			      | MACB_BF(REGA, devad & 0x1F)
+			      | MACB_BF(DATA, regnum & 0xFFFF)
+			      | MACB_BF(CODE, MACB_MAN_C45_CODE)));
+
+	status = macb_mdio_wait_for_idle(bp);
+	if (status < 0)
+		goto mdio_read_exit;
+
+	macb_writel(bp, MAN, (MACB_BF(SOF, MACB_MAN_C45_SOF)
+			      | MACB_BF(RW, MACB_MAN_C45_READ)
+			      | MACB_BF(PHYA, mii_id)
+			      | MACB_BF(REGA, devad & 0x1F)
+			      | MACB_BF(CODE, MACB_MAN_C45_CODE)));
+
 	status = macb_mdio_wait_for_idle(bp);
 	if (status < 0)
 		goto mdio_read_exit;
@@ -385,8 +412,8 @@ static int macb_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
 	return status;
 }
 
-static int macb_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
-			   u16 value)
+static int macb_mdio_write_c22(struct mii_bus *bus, int mii_id, int regnum,
+			       u16 value)
 {
 	struct macb *bp = bus->priv;
 	int status;
@@ -399,37 +426,63 @@ static int macb_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
 	if (status < 0)
 		goto mdio_write_exit;
 
-	if (regnum & MII_ADDR_C45) {
-		macb_writel(bp, MAN, (MACB_BF(SOF, MACB_MAN_C45_SOF)
-			    | MACB_BF(RW, MACB_MAN_C45_ADDR)
-			    | MACB_BF(PHYA, mii_id)
-			    | MACB_BF(REGA, (regnum >> 16) & 0x1F)
-			    | MACB_BF(DATA, regnum & 0xFFFF)
-			    | MACB_BF(CODE, MACB_MAN_C45_CODE)));
-
-		status = macb_mdio_wait_for_idle(bp);
-		if (status < 0)
-			goto mdio_write_exit;
-
-		macb_writel(bp, MAN, (MACB_BF(SOF, MACB_MAN_C45_SOF)
-			    | MACB_BF(RW, MACB_MAN_C45_WRITE)
-			    | MACB_BF(PHYA, mii_id)
-			    | MACB_BF(REGA, (regnum >> 16) & 0x1F)
-			    | MACB_BF(CODE, MACB_MAN_C45_CODE)
-			    | MACB_BF(DATA, value)));
-	} else {
-		macb_writel(bp, MAN, (MACB_BF(SOF, MACB_MAN_C22_SOF)
-				| MACB_BF(RW, MACB_MAN_C22_WRITE)
-				| MACB_BF(PHYA, mii_id)
-				| MACB_BF(REGA, regnum)
-				| MACB_BF(CODE, MACB_MAN_C22_CODE)
-				| MACB_BF(DATA, value)));
+	macb_writel(bp, MAN, (MACB_BF(SOF, MACB_MAN_C22_SOF)
+			      | MACB_BF(RW, MACB_MAN_C22_WRITE)
+			      | MACB_BF(PHYA, mii_id)
+			      | MACB_BF(REGA, regnum)
+			      | MACB_BF(CODE, MACB_MAN_C22_CODE)
+			      | MACB_BF(DATA, value)));
+
+	status = macb_mdio_wait_for_idle(bp);
+	if (status < 0)
+		goto mdio_write_exit;
+
+mdio_write_exit:
+	pm_runtime_mark_last_busy(&bp->pdev->dev);
+	pm_runtime_put_autosuspend(&bp->pdev->dev);
+mdio_pm_exit:
+	return status;
+}
+
+static int macb_mdio_write_c45(struct mii_bus *bus, int mii_id,
+			       int devad, int regnum,
+			       u16 value)
+{
+	struct macb *bp = bus->priv;
+	int status;
+
+	status = pm_runtime_get_sync(&bp->pdev->dev);
+	if (status < 0) {
+		pm_runtime_put_noidle(&bp->pdev->dev);
+		goto mdio_pm_exit;
 	}
 
 	status = macb_mdio_wait_for_idle(bp);
 	if (status < 0)
 		goto mdio_write_exit;
 
+	macb_writel(bp, MAN, (MACB_BF(SOF, MACB_MAN_C45_SOF)
+			      | MACB_BF(RW, MACB_MAN_C45_ADDR)
+			      | MACB_BF(PHYA, mii_id)
+			      | MACB_BF(REGA, devad & 0x1F)
+			      | MACB_BF(DATA, regnum & 0xFFFF)
+			      | MACB_BF(CODE, MACB_MAN_C45_CODE)));
+
+	status = macb_mdio_wait_for_idle(bp);
+	if (status < 0)
+		goto mdio_write_exit;
+
+	macb_writel(bp, MAN, (MACB_BF(SOF, MACB_MAN_C45_SOF)
+			      | MACB_BF(RW, MACB_MAN_C45_WRITE)
+			      | MACB_BF(PHYA, mii_id)
+			      | MACB_BF(REGA, devad & 0x1F)
+			      | MACB_BF(CODE, MACB_MAN_C45_CODE)
+			      | MACB_BF(DATA, value)));
+
+	status = macb_mdio_wait_for_idle(bp);
+	if (status < 0)
+		goto mdio_write_exit;
+
 mdio_write_exit:
 	pm_runtime_mark_last_busy(&bp->pdev->dev);
 	pm_runtime_put_autosuspend(&bp->pdev->dev);
@@ -902,8 +955,10 @@ static int macb_mii_init(struct macb *bp)
 	}
 
 	bp->mii_bus->name = "MACB_mii_bus";
-	bp->mii_bus->read = &macb_mdio_read;
-	bp->mii_bus->write = &macb_mdio_write;
+	bp->mii_bus->read = &macb_mdio_read_c22;
+	bp->mii_bus->write = &macb_mdio_write_c22;
+	bp->mii_bus->read_c45 = &macb_mdio_read_c45;
+	bp->mii_bus->write_c45 = &macb_mdio_write_c45;
 	snprintf(bp->mii_bus->id, MII_BUS_ID_SIZE, "%s-%x",
 		 bp->pdev->name, bp->pdev->id);
 	bp->mii_bus->priv = bp;

-- 
2.30.2

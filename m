Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81D716570DB
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 00:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbiL0XIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 18:08:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbiL0XHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 18:07:46 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23833B4A4;
        Tue, 27 Dec 2022 15:07:31 -0800 (PST)
Received: from mwalle01.sab.local (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 72ABA16E8;
        Wed, 28 Dec 2022 00:07:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1672182449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EtKt42zATBVdhhVN4u6oBH/TSlZiEUvG2BWKEVPzk14=;
        b=M1YZBVs+yYhVfmD6UjKZ3McECNIVJ3SEJVo6ydAZ32tQCQ0kDa+hGXdGCA4dAfWqcARxEp
        iX8bcz+n5JLsKvT+2Q8nVcDNThws6ry+orAe+sxuI+FPO74hEqxB9jADPdUTU0zllGtX2P
        S2Ye89/BMwzc8RRfohTn1QI8i9cjlCYIkTfmXRpYiey4CNEdJFEJlYBF40CC7D/eHFsxK/
        6dsGWInxYFW08fOjEEv1OjLhJGIV2c1uGCeFwaIlh3jnzyKiel9O6EjNdM+r/2/JGer+K0
        jOJF1FQREQC8C3edQNM3CeViZD/HOWDjGkDrUdXXP2cXux1i7vebt91+lrCH3g==
From:   Michael Walle <michael@walle.cc>
Date:   Wed, 28 Dec 2022 00:07:25 +0100
Subject: [PATCH RFC net-next v2 09/12] net: ethernet: freescale: fec: Separate
 C22 and C45 transactions for xgmac
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221227-v6-2-rc1-c45-seperation-v2-9-ddb37710e5a7@walle.cc>
References: <20221227-v6-2-rc1-c45-seperation-v2-0-ddb37710e5a7@walle.cc>
In-Reply-To: <20221227-v6-2-rc1-c45-seperation-v2-0-ddb37710e5a7@walle.cc>
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

From: Andrew Lunn <andrew@lunn.ch>

The fec MDIO bus driver can perform both C22 and C45 transfers.
Create separate functions for each and register the C45 versions using
the new API calls where appropriate.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michael Walle <michael@walle.cc>
---
v2:
 - [al] Fixup some indentation
---
 drivers/net/ethernet/freescale/fec_main.c | 153 ++++++++++++++++++++----------
 1 file changed, 103 insertions(+), 50 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 644f3c963730..e6238e53940d 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1987,47 +1987,74 @@ static int fec_enet_mdio_wait(struct fec_enet_private *fep)
 	return ret;
 }
 
-static int fec_enet_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
+static int fec_enet_mdio_read_c22(struct mii_bus *bus, int mii_id, int regnum)
 {
 	struct fec_enet_private *fep = bus->priv;
 	struct device *dev = &fep->pdev->dev;
 	int ret = 0, frame_start, frame_addr, frame_op;
-	bool is_c45 = !!(regnum & MII_ADDR_C45);
 
 	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0)
 		return ret;
 
-	if (is_c45) {
-		frame_start = FEC_MMFR_ST_C45;
+	/* C22 read */
+	frame_op = FEC_MMFR_OP_READ;
+	frame_start = FEC_MMFR_ST;
+	frame_addr = regnum;
 
-		/* write address */
-		frame_addr = (regnum >> 16);
-		writel(frame_start | FEC_MMFR_OP_ADDR_WRITE |
-		       FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(frame_addr) |
-		       FEC_MMFR_TA | (regnum & 0xFFFF),
-		       fep->hwp + FEC_MII_DATA);
+	/* start a read op */
+	writel(frame_start | frame_op |
+	       FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(frame_addr) |
+	       FEC_MMFR_TA, fep->hwp + FEC_MII_DATA);
 
-		/* wait for end of transfer */
-		ret = fec_enet_mdio_wait(fep);
-		if (ret) {
-			netdev_err(fep->netdev, "MDIO address write timeout\n");
-			goto out;
-		}
+	/* wait for end of transfer */
+	ret = fec_enet_mdio_wait(fep);
+	if (ret) {
+		netdev_err(fep->netdev, "MDIO read timeout\n");
+		goto out;
+	}
 
-		frame_op = FEC_MMFR_OP_READ_C45;
+	ret = FEC_MMFR_DATA(readl(fep->hwp + FEC_MII_DATA));
 
-	} else {
-		/* C22 read */
-		frame_op = FEC_MMFR_OP_READ;
-		frame_start = FEC_MMFR_ST;
-		frame_addr = regnum;
+out:
+	pm_runtime_mark_last_busy(dev);
+	pm_runtime_put_autosuspend(dev);
+
+	return ret;
+}
+
+static int fec_enet_mdio_read_c45(struct mii_bus *bus, int mii_id,
+				  int devad, int regnum)
+{
+	struct fec_enet_private *fep = bus->priv;
+	struct device *dev = &fep->pdev->dev;
+	int ret = 0, frame_start, frame_op;
+
+	ret = pm_runtime_resume_and_get(dev);
+	if (ret < 0)
+		return ret;
+
+	frame_start = FEC_MMFR_ST_C45;
+
+	/* write address */
+	writel(frame_start | FEC_MMFR_OP_ADDR_WRITE |
+	       FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(devad) |
+	       FEC_MMFR_TA | (regnum & 0xFFFF),
+	       fep->hwp + FEC_MII_DATA);
+
+	/* wait for end of transfer */
+	ret = fec_enet_mdio_wait(fep);
+	if (ret) {
+		netdev_err(fep->netdev, "MDIO address write timeout\n");
+		goto out;
 	}
 
+	frame_op = FEC_MMFR_OP_READ_C45;
+
 	/* start a read op */
 	writel(frame_start | frame_op |
-		FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(frame_addr) |
-		FEC_MMFR_TA, fep->hwp + FEC_MII_DATA);
+	       FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(devad) |
+	       FEC_MMFR_TA, fep->hwp + FEC_MII_DATA);
 
 	/* wait for end of transfer */
 	ret = fec_enet_mdio_wait(fep);
@@ -2045,45 +2072,69 @@ static int fec_enet_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
 	return ret;
 }
 
-static int fec_enet_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
-			   u16 value)
+static int fec_enet_mdio_write_c22(struct mii_bus *bus, int mii_id, int regnum,
+				   u16 value)
 {
 	struct fec_enet_private *fep = bus->priv;
 	struct device *dev = &fep->pdev->dev;
 	int ret, frame_start, frame_addr;
-	bool is_c45 = !!(regnum & MII_ADDR_C45);
 
 	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0)
 		return ret;
 
-	if (is_c45) {
-		frame_start = FEC_MMFR_ST_C45;
+	/* C22 write */
+	frame_start = FEC_MMFR_ST;
+	frame_addr = regnum;
 
-		/* write address */
-		frame_addr = (regnum >> 16);
-		writel(frame_start | FEC_MMFR_OP_ADDR_WRITE |
-		       FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(frame_addr) |
-		       FEC_MMFR_TA | (regnum & 0xFFFF),
-		       fep->hwp + FEC_MII_DATA);
+	/* start a write op */
+	writel(frame_start | FEC_MMFR_OP_WRITE |
+	       FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(frame_addr) |
+	       FEC_MMFR_TA | FEC_MMFR_DATA(value),
+	       fep->hwp + FEC_MII_DATA);
 
-		/* wait for end of transfer */
-		ret = fec_enet_mdio_wait(fep);
-		if (ret) {
-			netdev_err(fep->netdev, "MDIO address write timeout\n");
-			goto out;
-		}
-	} else {
-		/* C22 write */
-		frame_start = FEC_MMFR_ST;
-		frame_addr = regnum;
+	/* wait for end of transfer */
+	ret = fec_enet_mdio_wait(fep);
+	if (ret)
+		netdev_err(fep->netdev, "MDIO write timeout\n");
+
+	pm_runtime_mark_last_busy(dev);
+	pm_runtime_put_autosuspend(dev);
+
+	return ret;
+}
+
+static int fec_enet_mdio_write_c45(struct mii_bus *bus, int mii_id,
+				   int devad, int regnum, u16 value)
+{
+	struct fec_enet_private *fep = bus->priv;
+	struct device *dev = &fep->pdev->dev;
+	int ret, frame_start;
+
+	ret = pm_runtime_resume_and_get(dev);
+	if (ret < 0)
+		return ret;
+
+	frame_start = FEC_MMFR_ST_C45;
+
+	/* write address */
+	writel(frame_start | FEC_MMFR_OP_ADDR_WRITE |
+	       FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(devad) |
+	       FEC_MMFR_TA | (regnum & 0xFFFF),
+	       fep->hwp + FEC_MII_DATA);
+
+	/* wait for end of transfer */
+	ret = fec_enet_mdio_wait(fep);
+	if (ret) {
+		netdev_err(fep->netdev, "MDIO address write timeout\n");
+		goto out;
 	}
 
 	/* start a write op */
 	writel(frame_start | FEC_MMFR_OP_WRITE |
-		FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(frame_addr) |
-		FEC_MMFR_TA | FEC_MMFR_DATA(value),
-		fep->hwp + FEC_MII_DATA);
+	       FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(devad) |
+	       FEC_MMFR_TA | FEC_MMFR_DATA(value),
+	       fep->hwp + FEC_MII_DATA);
 
 	/* wait for end of transfer */
 	ret = fec_enet_mdio_wait(fep);
@@ -2381,8 +2432,10 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 	}
 
 	fep->mii_bus->name = "fec_enet_mii_bus";
-	fep->mii_bus->read = fec_enet_mdio_read;
-	fep->mii_bus->write = fec_enet_mdio_write;
+	fep->mii_bus->read = fec_enet_mdio_read_c22;
+	fep->mii_bus->write = fec_enet_mdio_write_c22;
+	fep->mii_bus->read_c45 = fec_enet_mdio_read_c45;
+	fep->mii_bus->write_c45 = fec_enet_mdio_write_c45;
 	snprintf(fep->mii_bus->id, MII_BUS_ID_SIZE, "%s-%x",
 		pdev->name, fep->dev_id + 1);
 	fep->mii_bus->priv = fep;

-- 
2.30.2

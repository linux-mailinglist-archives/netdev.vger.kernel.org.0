Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC35662A0D
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 16:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236993AbjAIPcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 10:32:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237161AbjAIPbu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 10:31:50 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C3AF1EC69;
        Mon,  9 Jan 2023 07:31:08 -0800 (PST)
Received: from mwalle01.sab.local (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 9A08118F4;
        Mon,  9 Jan 2023 16:30:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1673278257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6a41x9xkDddn0pKN675NFehAFfkJd5FOLk73tfVYXAs=;
        b=Z1otKrDv2SQDrlxMVXMdZ+1hmiRsJovlAtyCffdDyrk6DoX/tSjVMtAFL8MymE2O8CdF8C
        9Bq51R898qZ8Xo5H0OB2147Oiy6w50KIRVkhRayrgNUfNV6OA3cYkc/FyCsZUr0s516Nch
        JvupojR10HYlL0Mr4GuXArtVFYmouFz6P3fX2BhC0rxum6JjoE+CQbbVnT5lVLiOP0z8u2
        CmBNE5roIjSoVyAj0/jLwktY4p0PFruSq6zRF6BH+lM38TlxhwkyyhZFW37bRmFvm9F3QU
        5Tj/ncMnsM5tuAOwRRwry/mrAZozMWSdj4QwjDprvLjFVqpmQCyCKCmPs9ZyEw==
From:   Michael Walle <michael@walle.cc>
Date:   Mon, 09 Jan 2023 16:30:49 +0100
Subject: [PATCH net-next v3 09/11] net: fec: Separate C22 and C45 transactions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221227-v6-2-rc1-c45-seperation-v3-9-ade1deb438da@walle.cc>
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

The fec MDIO bus driver can perform both C22 and C45 transfers.
Create separate functions for each and register the C45 versions using
the new API calls where appropriate.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michael Walle <michael@walle.cc>
Reviewed-by: Wei Fang <wei.fang@nxp.com>
---
v2:
 - [al] Fixup some indentation
v3:
 - [mw] More concise subject
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

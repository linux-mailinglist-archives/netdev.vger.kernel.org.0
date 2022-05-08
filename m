Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1060551EEAC
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 17:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234921AbiEHPfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 11:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234893AbiEHPfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 11:35:13 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC128E039
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 08:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=woGTwKeb21z6IeJRflMKCb2CzQi7wrLh4Swk7vvI5wQ=; b=LiGFe+UPZzSI7m3bc8BB/sZ27y
        X+QpLtIOzrrtuZxIXRl7GbADYwcTq5L89UqmsXRizFXv20x0FLqHN8ruw1yaHJ9TnVvuHJS67skyL
        oTspj2NsGXyd+tIFAk+ZZbNbZBJOYqaCxZS2FMaBpR+CUV0Pv31veqzq7bN6RJiyUvfg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nnisJ-001n9s-B9; Sun, 08 May 2022 17:31:11 +0200
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
Subject: [PATCH net-next 08/10] net: ethernet: freescale: fec: Separate C22 and C45 transactions for xgmac
Date:   Sun,  8 May 2022 17:30:47 +0200
Message-Id: <20220508153049.427227-9-andrew@lunn.ch>
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

The fec MDIO bus driver can perform both C22 and C45 transfers.
Create separate functions for each and register the C45 versions using
the new API calls where appropriate.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/freescale/fec_main.c | 149 +++++++++++++++-------
 1 file changed, 101 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 9f33ec838b52..6f749387b5c5 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1860,47 +1860,74 @@ static int fec_enet_mdio_wait(struct fec_enet_private *fep)
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
+		FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(frame_addr) |
+		FEC_MMFR_TA, fep->hwp + FEC_MII_DATA);
 
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
@@ -1918,43 +1945,67 @@ static int fec_enet_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
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
+		FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(frame_addr) |
+		FEC_MMFR_TA | FEC_MMFR_DATA(value),
+		fep->hwp + FEC_MII_DATA);
 
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
+		FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(devad) |
 		FEC_MMFR_TA | FEC_MMFR_DATA(value),
 		fep->hwp + FEC_MII_DATA);
 
@@ -2254,8 +2305,10 @@ static int fec_enet_mii_init(struct platform_device *pdev)
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
2.36.0


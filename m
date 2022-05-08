Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27E6B51EEA0
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 17:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234918AbiEHPfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 11:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234883AbiEHPfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 11:35:13 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5855DE03D
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 08:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=x49Tx9T4Kz+jsuJEr2NQtVEupIGURCl2PitJGZh3AMw=; b=Th0vNiJmgDFNbqrBL3TTm5ghPW
        gAFew+YZ2CCvhy+sKPsc7KWgtk8x/NOXUb5kAx+mlZtgA7KHOVa30NS9N8B7XPYquhtLUruUddKOy
        CeDRQoGnJ2+iXNqhiZQu84Cxovl0RpSW/t6Zbd+OKLUnCP2jRHxZ7dA8/E/Jrca1vkGw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nnisJ-001n9o-84; Sun, 08 May 2022 17:31:11 +0200
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
Subject: [PATCH net-next 06/10] net: mdio: mvmdio: Convert XSMI bus to new API
Date:   Sun,  8 May 2022 17:30:45 +0200
Message-Id: <20220508153049.427227-7-andrew@lunn.ch>
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

The marvell MDIO driver supports two different hardware blocks. The
XSMI block is C45 only. Convert this block to the new API, and only
populate the c45 calls in the bus structure.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/marvell/mvmdio.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvmdio.c b/drivers/net/ethernet/marvell/mvmdio.c
index ef878973b859..2d654a40af13 100644
--- a/drivers/net/ethernet/marvell/mvmdio.c
+++ b/drivers/net/ethernet/marvell/mvmdio.c
@@ -204,21 +204,17 @@ static const struct orion_mdio_ops orion_mdio_xsmi_ops = {
 	.poll_interval_max = MVMDIO_XSMI_POLL_INTERVAL_MAX,
 };
 
-static int orion_mdio_xsmi_read(struct mii_bus *bus, int mii_id,
-				int regnum)
+static int orion_mdio_xsmi_read_c45(struct mii_bus *bus, int mii_id,
+				    int dev_addr, int regnum)
 {
 	struct orion_mdio_dev *dev = bus->priv;
-	u16 dev_addr = (regnum >> 16) & GENMASK(4, 0);
 	int ret;
 
-	if (!(regnum & MII_ADDR_C45))
-		return -EOPNOTSUPP;
-
 	ret = orion_mdio_wait_ready(&orion_mdio_xsmi_ops, bus);
 	if (ret < 0)
 		return ret;
 
-	writel(regnum & GENMASK(15, 0), dev->regs + MVMDIO_XSMI_ADDR_REG);
+	writel(regnum, dev->regs + MVMDIO_XSMI_ADDR_REG);
 	writel((mii_id << MVMDIO_XSMI_PHYADDR_SHIFT) |
 	       (dev_addr << MVMDIO_XSMI_DEVADDR_SHIFT) |
 	       MVMDIO_XSMI_READ_OPERATION,
@@ -237,21 +233,17 @@ static int orion_mdio_xsmi_read(struct mii_bus *bus, int mii_id,
 	return readl(dev->regs + MVMDIO_XSMI_MGNT_REG) & GENMASK(15, 0);
 }
 
-static int orion_mdio_xsmi_write(struct mii_bus *bus, int mii_id,
-				int regnum, u16 value)
+static int orion_mdio_xsmi_write_c45(struct mii_bus *bus, int mii_id,
+				     int dev_addr, int regnum, u16 value)
 {
 	struct orion_mdio_dev *dev = bus->priv;
-	u16 dev_addr = (regnum >> 16) & GENMASK(4, 0);
 	int ret;
 
-	if (!(regnum & MII_ADDR_C45))
-		return -EOPNOTSUPP;
-
 	ret = orion_mdio_wait_ready(&orion_mdio_xsmi_ops, bus);
 	if (ret < 0)
 		return ret;
 
-	writel(regnum & GENMASK(15, 0), dev->regs + MVMDIO_XSMI_ADDR_REG);
+	writel(regnum, dev->regs + MVMDIO_XSMI_ADDR_REG);
 	writel((mii_id << MVMDIO_XSMI_PHYADDR_SHIFT) |
 	       (dev_addr << MVMDIO_XSMI_DEVADDR_SHIFT) |
 	       MVMDIO_XSMI_WRITE_OPERATION | value,
@@ -302,8 +294,8 @@ static int orion_mdio_probe(struct platform_device *pdev)
 		bus->write = orion_mdio_smi_write;
 		break;
 	case BUS_TYPE_XSMI:
-		bus->read = orion_mdio_xsmi_read;
-		bus->write = orion_mdio_xsmi_write;
+		bus->read_c45 = orion_mdio_xsmi_read_c45;
+		bus->write_c45 = orion_mdio_xsmi_write_c45;
 		break;
 	}
 
-- 
2.36.0


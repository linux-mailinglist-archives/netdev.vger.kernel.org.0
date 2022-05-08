Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6740B51EE9B
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 17:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234914AbiEHPfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 11:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234879AbiEHPfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 11:35:13 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96937E030
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 08:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=RZCn+oMG+GzMyfBRYVYCf2DFlrP8BsqtoUEFojJydVc=; b=JkK8kHIEiOEog9lElqi9s1Tbll
        rQH2W4bV5AeHNCN796PpZu0LwmLF3YZbFocSy/w/8GMCf4DREt96su7yLhhnsWu3hxOpCndMdM11f
        6UrZYSPqxFb8YV50EavsNBGWwG0sdSSSyWztRBOYGEIiUZKBwDsQoGsST7FaHRNlf904=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nnisJ-001n9m-6X; Sun, 08 May 2022 17:31:11 +0200
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
Subject: [PATCH net-next 05/10] net: mdio: mdio-bitbang: Separate C22 and C45 transactions
Date:   Sun,  8 May 2022 17:30:44 +0200
Message-Id: <20220508153049.427227-6-andrew@lunn.ch>
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

The bitbbanging bus driver can perform both C22 and C45 transfers.
Create separate functions for each and register the C45 versions using
the new driver API calls.

The SH Ethernet driver places wrappers around these functions. In
order to not break boards which might be using C45, add similar
wrappers for C45 operations.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/renesas/sh_eth.c | 37 ++++++++++---
 drivers/net/mdio/mdio-bitbang.c       | 77 ++++++++++++++++++---------
 include/linux/mdio-bitbang.h          |  6 ++-
 3 files changed, 87 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 67ade78fb767..3d0b80144dc5 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -3042,23 +3042,46 @@ static int sh_mdio_release(struct sh_eth_private *mdp)
 	return 0;
 }
 
-static int sh_mdiobb_read(struct mii_bus *bus, int phy, int reg)
+static int sh_mdiobb_read_c22(struct mii_bus *bus, int phy, int reg)
 {
 	int res;
 
 	pm_runtime_get_sync(bus->parent);
-	res = mdiobb_read(bus, phy, reg);
+	res = mdiobb_read_c22(bus, phy, reg);
 	pm_runtime_put(bus->parent);
 
 	return res;
 }
 
-static int sh_mdiobb_write(struct mii_bus *bus, int phy, int reg, u16 val)
+static int sh_mdiobb_write_c22(struct mii_bus *bus, int phy, int reg, u16 val)
 {
 	int res;
 
 	pm_runtime_get_sync(bus->parent);
-	res = mdiobb_write(bus, phy, reg, val);
+	res = mdiobb_write_c22(bus, phy, reg, val);
+	pm_runtime_put(bus->parent);
+
+	return res;
+}
+
+static int sh_mdiobb_read_c45(struct mii_bus *bus, int phy, int devad, int reg)
+{
+	int res;
+
+	pm_runtime_get_sync(bus->parent);
+	res = mdiobb_read_c45(bus, phy, devad, reg);
+	pm_runtime_put(bus->parent);
+
+	return res;
+}
+
+static int sh_mdiobb_write_c45(struct mii_bus *bus, int phy, int devad,
+			       int reg, u16 val)
+{
+	int res;
+
+	pm_runtime_get_sync(bus->parent);
+	res = mdiobb_write_c45(bus, phy, devad, reg, val);
 	pm_runtime_put(bus->parent);
 
 	return res;
@@ -3089,8 +3112,10 @@ static int sh_mdio_init(struct sh_eth_private *mdp,
 		return -ENOMEM;
 
 	/* Wrap accessors with Runtime PM-aware ops */
-	mdp->mii_bus->read = sh_mdiobb_read;
-	mdp->mii_bus->write = sh_mdiobb_write;
+	mdp->mii_bus->read = sh_mdiobb_read_c22;
+	mdp->mii_bus->write = sh_mdiobb_write_c22;
+	mdp->mii_bus->read_c45 = sh_mdiobb_read_c45;
+	mdp->mii_bus->write_c45 = sh_mdiobb_write_c45;
 
 	/* Hook up MII support for ethtool */
 	mdp->mii_bus->name = "sh_mii";
diff --git a/drivers/net/mdio/mdio-bitbang.c b/drivers/net/mdio/mdio-bitbang.c
index 07609114a26b..b83932562be2 100644
--- a/drivers/net/mdio/mdio-bitbang.c
+++ b/drivers/net/mdio/mdio-bitbang.c
@@ -127,14 +127,12 @@ static void mdiobb_cmd(struct mdiobb_ctrl *ctrl, int op, u8 phy, u8 reg)
 
 /* In clause 45 mode all commands are prefixed by MDIO_ADDR to specify the
    lower 16 bits of the 21 bit address. This transfer is done identically to a
-   MDIO_WRITE except for a different code. To enable clause 45 mode or
-   MII_ADDR_C45 into the address. Theoretically clause 45 and normal devices
-   can exist on the same bus. Normal devices should ignore the MDIO_ADDR
+   MDIO_WRITE except for a different code. Theoretically clause 45 and normal
+   devices can exist on the same bus. Normal devices should ignore the MDIO_ADDR
    phase. */
-static int mdiobb_cmd_addr(struct mdiobb_ctrl *ctrl, int phy, u32 addr)
+static void mdiobb_cmd_addr(struct mdiobb_ctrl *ctrl, int phy, int dev_addr,
+			    int reg)
 {
-	unsigned int dev_addr = (addr >> 16) & 0x1F;
-	unsigned int reg = addr & 0xFFFF;
 	mdiobb_cmd(ctrl, MDIO_C45_ADDR, phy, dev_addr);
 
 	/* send the turnaround (10) */
@@ -145,21 +143,13 @@ static int mdiobb_cmd_addr(struct mdiobb_ctrl *ctrl, int phy, u32 addr)
 
 	ctrl->ops->set_mdio_dir(ctrl, 0);
 	mdiobb_get_bit(ctrl);
-
-	return dev_addr;
 }
 
-int mdiobb_read(struct mii_bus *bus, int phy, int reg)
+static int mdiobb_read_common(struct mii_bus *bus, int phy)
 {
 	struct mdiobb_ctrl *ctrl = bus->priv;
 	int ret, i;
 
-	if (reg & MII_ADDR_C45) {
-		reg = mdiobb_cmd_addr(ctrl, phy, reg);
-		mdiobb_cmd(ctrl, MDIO_C45_READ, phy, reg);
-	} else
-		mdiobb_cmd(ctrl, ctrl->op_c22_read, phy, reg);
-
 	ctrl->ops->set_mdio_dir(ctrl, 0);
 
 	/* check the turnaround bit: the PHY should be driving it to zero, if this
@@ -180,17 +170,31 @@ int mdiobb_read(struct mii_bus *bus, int phy, int reg)
 	mdiobb_get_bit(ctrl);
 	return ret;
 }
-EXPORT_SYMBOL(mdiobb_read);
 
-int mdiobb_write(struct mii_bus *bus, int phy, int reg, u16 val)
+int mdiobb_read_c22(struct mii_bus *bus, int phy, int reg)
 {
 	struct mdiobb_ctrl *ctrl = bus->priv;
 
-	if (reg & MII_ADDR_C45) {
-		reg = mdiobb_cmd_addr(ctrl, phy, reg);
-		mdiobb_cmd(ctrl, MDIO_C45_WRITE, phy, reg);
-	} else
-		mdiobb_cmd(ctrl, ctrl->op_c22_write, phy, reg);
+	mdiobb_cmd(ctrl, ctrl->op_c22_read, phy, reg);
+
+	return mdiobb_read_common(bus, phy);
+}
+EXPORT_SYMBOL(mdiobb_read_c22);
+
+int mdiobb_read_c45(struct mii_bus *bus, int phy, int devad, int reg)
+{
+	struct mdiobb_ctrl *ctrl = bus->priv;
+
+	mdiobb_cmd_addr(ctrl, phy, devad, reg);
+	mdiobb_cmd(ctrl, MDIO_C45_READ, phy, reg);
+
+	return mdiobb_read_common(bus, phy);
+}
+EXPORT_SYMBOL(mdiobb_read_c45);
+
+static int mdiobb_write_common(struct mii_bus *bus, u16 val)
+{
+	struct mdiobb_ctrl *ctrl = bus->priv;
 
 	/* send the turnaround (10) */
 	mdiobb_send_bit(ctrl, 1);
@@ -202,7 +206,27 @@ int mdiobb_write(struct mii_bus *bus, int phy, int reg, u16 val)
 	mdiobb_get_bit(ctrl);
 	return 0;
 }
-EXPORT_SYMBOL(mdiobb_write);
+
+int mdiobb_write_c22(struct mii_bus *bus, int phy, int reg, u16 val)
+{
+	struct mdiobb_ctrl *ctrl = bus->priv;
+
+	mdiobb_cmd(ctrl, ctrl->op_c22_write, phy, reg);
+
+	return mdiobb_write_common(bus, val);
+}
+EXPORT_SYMBOL(mdiobb_write_c22);
+
+int mdiobb_write_c45(struct mii_bus *bus, int phy, int devad, int reg, u16 val)
+{
+	struct mdiobb_ctrl *ctrl = bus->priv;
+
+	mdiobb_cmd_addr(ctrl, phy, devad, reg);
+	mdiobb_cmd(ctrl, MDIO_C45_WRITE, phy, reg);
+
+	return mdiobb_write_common(bus, val);
+}
+EXPORT_SYMBOL(mdiobb_write_c45);
 
 struct mii_bus *alloc_mdio_bitbang(struct mdiobb_ctrl *ctrl)
 {
@@ -214,8 +238,11 @@ struct mii_bus *alloc_mdio_bitbang(struct mdiobb_ctrl *ctrl)
 
 	__module_get(ctrl->ops->owner);
 
-	bus->read = mdiobb_read;
-	bus->write = mdiobb_write;
+	bus->read = mdiobb_read_c22;
+	bus->write = mdiobb_write_c22;
+	bus->read_c45 = mdiobb_read_c45;
+	bus->write_c45 = mdiobb_write_c45;
+
 	bus->priv = ctrl;
 	if (!ctrl->override_op_c22) {
 		ctrl->op_c22_read = MDIO_READ;
diff --git a/include/linux/mdio-bitbang.h b/include/linux/mdio-bitbang.h
index 373630fe5c28..cffabdbce075 100644
--- a/include/linux/mdio-bitbang.h
+++ b/include/linux/mdio-bitbang.h
@@ -38,8 +38,10 @@ struct mdiobb_ctrl {
 	u8 op_c22_write;
 };
 
-int mdiobb_read(struct mii_bus *bus, int phy, int reg);
-int mdiobb_write(struct mii_bus *bus, int phy, int reg, u16 val);
+int mdiobb_read_c22(struct mii_bus *bus, int phy, int reg);
+int mdiobb_write_c22(struct mii_bus *bus, int phy, int reg, u16 val);
+int mdiobb_read_c45(struct mii_bus *bus, int devad, int phy, int reg);
+int mdiobb_write_c45(struct mii_bus *bus, int devad, int phy, int reg, u16 val);
 
 /* The returned bus is not yet registered with the phy layer. */
 struct mii_bus *alloc_mdio_bitbang(struct mdiobb_ctrl *ctrl);
-- 
2.36.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDDC966D368
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 00:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235420AbjAPXxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 18:53:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232684AbjAPXww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 18:52:52 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FB222A1C;
        Mon, 16 Jan 2023 15:52:51 -0800 (PST)
Received: from mwalle01.sab.local (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 1ADD719AC;
        Tue, 17 Jan 2023 00:52:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1673913169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0dass3X/H3O9IpfBuJUCk6sEtL29z8uf5viM4VBJ0Jw=;
        b=1ls1tfDPJa9hUc9j6lnczXgUpmoRJaEtfaktOu/Vj7xSjhcWW+BHawDplZMCUn0jwDBcXK
        8GbZ2tEUFti1RddNsH3yfMcPp0sKOy3gyHcdCxlPpPoQzz7C0lprWPE3PcXw9cqDhGQ6Ib
        wFqTZoLFZPCUCDjO1uVpCnSjH1Kf8D7jTiUcFfOX1yVc5rFjI5WioUky2T+Uld5svvSrLV
        Wv/4X5mH6idhEpW9FhEu03dkChT7nxExoZTEFXj29VntE4x1ztwqENFriI2bZvIp3LEDDm
        lgACv/uOnGp7wRKCiiRJxr8eJNHp7XQFLEVNrY3yutSrQOFlvnI/7dteeuhiYQ==
From:   Michael Walle <michael@walle.cc>
Date:   Tue, 17 Jan 2023 00:52:23 +0100
Subject: [PATCH net-next 08/12] amd-xgbe: Separate C22 and C45 transactions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230116-net-next-c45-seperation-part-3-v1-8-0c53afa56aad@walle.cc>
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

The xgbe MDIO bus driver can perform both C22 and C45 transfers, when
using its MDIO bus hardware. The SFP I2C mdio bus driver only supports
C22. Create separate functions for each and register the C45 versions
using the new API calls where appropriate.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c    |  75 ++++++++++++++---
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 120 +++++++++++++++++++++-------
 drivers/net/ethernet/amd/xgbe/xgbe.h        |   7 +-
 3 files changed, 158 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-dev.c b/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
index 255ea6dc1377..aafa02fb3fdf 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-dev.c
@@ -1294,11 +1294,20 @@ static void xgbe_write_mmd_regs(struct xgbe_prv_data *pdata, int prtad,
 	}
 }
 
-static unsigned int xgbe_create_mdio_sca(int port, int reg)
+static unsigned int xgbe_create_mdio_sca_c22(int port, int reg)
 {
-	unsigned int mdio_sca, da;
+	unsigned int mdio_sca;
 
-	da = (reg & MII_ADDR_C45) ? reg >> 16 : 0;
+	mdio_sca = 0;
+	XGMAC_SET_BITS(mdio_sca, MAC_MDIOSCAR, RA, reg);
+	XGMAC_SET_BITS(mdio_sca, MAC_MDIOSCAR, PA, port);
+
+	return mdio_sca;
+}
+
+static unsigned int xgbe_create_mdio_sca_c45(int port, unsigned int da, int reg)
+{
+	unsigned int mdio_sca;
 
 	mdio_sca = 0;
 	XGMAC_SET_BITS(mdio_sca, MAC_MDIOSCAR, RA, reg);
@@ -1308,14 +1317,13 @@ static unsigned int xgbe_create_mdio_sca(int port, int reg)
 	return mdio_sca;
 }
 
-static int xgbe_write_ext_mii_regs(struct xgbe_prv_data *pdata, int addr,
-				   int reg, u16 val)
+static int xgbe_write_ext_mii_regs(struct xgbe_prv_data *pdata,
+				   unsigned int mdio_sca, u16 val)
 {
-	unsigned int mdio_sca, mdio_sccd;
+	unsigned int mdio_sccd;
 
 	reinit_completion(&pdata->mdio_complete);
 
-	mdio_sca = xgbe_create_mdio_sca(addr, reg);
 	XGMAC_IOWRITE(pdata, MAC_MDIOSCAR, mdio_sca);
 
 	mdio_sccd = 0;
@@ -1332,14 +1340,33 @@ static int xgbe_write_ext_mii_regs(struct xgbe_prv_data *pdata, int addr,
 	return 0;
 }
 
-static int xgbe_read_ext_mii_regs(struct xgbe_prv_data *pdata, int addr,
-				  int reg)
+static int xgbe_write_ext_mii_regs_c22(struct xgbe_prv_data *pdata, int addr,
+				       int reg, u16 val)
+{
+	unsigned int mdio_sca;
+
+	mdio_sca = xgbe_create_mdio_sca_c22(addr, reg);
+
+	return xgbe_write_ext_mii_regs(pdata, mdio_sca, val);
+}
+
+static int xgbe_write_ext_mii_regs_c45(struct xgbe_prv_data *pdata, int addr,
+				       int devad, int reg, u16 val)
+{
+	unsigned int mdio_sca;
+
+	mdio_sca = xgbe_create_mdio_sca_c45(addr, devad, reg);
+
+	return xgbe_write_ext_mii_regs(pdata, mdio_sca, val);
+}
+
+static int xgbe_read_ext_mii_regs(struct xgbe_prv_data *pdata,
+				  unsigned int mdio_sca)
 {
-	unsigned int mdio_sca, mdio_sccd;
+	unsigned int mdio_sccd;
 
 	reinit_completion(&pdata->mdio_complete);
 
-	mdio_sca = xgbe_create_mdio_sca(addr, reg);
 	XGMAC_IOWRITE(pdata, MAC_MDIOSCAR, mdio_sca);
 
 	mdio_sccd = 0;
@@ -1355,6 +1382,26 @@ static int xgbe_read_ext_mii_regs(struct xgbe_prv_data *pdata, int addr,
 	return XGMAC_IOREAD_BITS(pdata, MAC_MDIOSCCDR, DATA);
 }
 
+static int xgbe_read_ext_mii_regs_c22(struct xgbe_prv_data *pdata, int addr,
+				      int reg)
+{
+	unsigned int mdio_sca;
+
+	mdio_sca = xgbe_create_mdio_sca_c22(addr, reg);
+
+	return xgbe_read_ext_mii_regs(pdata, mdio_sca);
+}
+
+static int xgbe_read_ext_mii_regs_c45(struct xgbe_prv_data *pdata, int addr,
+				      int devad, int reg)
+{
+	unsigned int mdio_sca;
+
+	mdio_sca = xgbe_create_mdio_sca_c45(addr, devad, reg);
+
+	return xgbe_read_ext_mii_regs(pdata, mdio_sca);
+}
+
 static int xgbe_set_ext_mii_mode(struct xgbe_prv_data *pdata, unsigned int port,
 				 enum xgbe_mdio_mode mode)
 {
@@ -3568,8 +3615,10 @@ void xgbe_init_function_ptrs_dev(struct xgbe_hw_if *hw_if)
 	hw_if->set_speed = xgbe_set_speed;
 
 	hw_if->set_ext_mii_mode = xgbe_set_ext_mii_mode;
-	hw_if->read_ext_mii_regs = xgbe_read_ext_mii_regs;
-	hw_if->write_ext_mii_regs = xgbe_write_ext_mii_regs;
+	hw_if->read_ext_mii_regs_c22 = xgbe_read_ext_mii_regs_c22;
+	hw_if->write_ext_mii_regs_c22 = xgbe_write_ext_mii_regs_c22;
+	hw_if->read_ext_mii_regs_c45 = xgbe_read_ext_mii_regs_c45;
+	hw_if->write_ext_mii_regs_c45 = xgbe_write_ext_mii_regs_c45;
 
 	hw_if->set_gpio = xgbe_set_gpio;
 	hw_if->clr_gpio = xgbe_clr_gpio;
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
index de7118cb10b8..f4683d53e58c 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
@@ -600,20 +600,27 @@ static int xgbe_phy_get_comm_ownership(struct xgbe_prv_data *pdata)
 	return -ETIMEDOUT;
 }
 
-static int xgbe_phy_mdio_mii_write(struct xgbe_prv_data *pdata, int addr,
-				   int reg, u16 val)
+static int xgbe_phy_mdio_mii_write_c22(struct xgbe_prv_data *pdata, int addr,
+				       int reg, u16 val)
 {
 	struct xgbe_phy_data *phy_data = pdata->phy_data;
 
-	if (reg & MII_ADDR_C45) {
-		if (phy_data->phydev_mode != XGBE_MDIO_MODE_CL45)
-			return -ENOTSUPP;
-	} else {
-		if (phy_data->phydev_mode != XGBE_MDIO_MODE_CL22)
-			return -ENOTSUPP;
-	}
+	if (phy_data->phydev_mode != XGBE_MDIO_MODE_CL22)
+		return -EOPNOTSUPP;
+
+	return pdata->hw_if.write_ext_mii_regs_c22(pdata, addr, reg, val);
+}
+
+static int xgbe_phy_mdio_mii_write_c45(struct xgbe_prv_data *pdata, int addr,
+				       int devad, int reg, u16 val)
+{
+	struct xgbe_phy_data *phy_data = pdata->phy_data;
 
-	return pdata->hw_if.write_ext_mii_regs(pdata, addr, reg, val);
+	if (phy_data->phydev_mode != XGBE_MDIO_MODE_CL45)
+		return -EOPNOTSUPP;
+
+	return pdata->hw_if.write_ext_mii_regs_c45(pdata, addr, devad,
+						   reg, val);
 }
 
 static int xgbe_phy_i2c_mii_write(struct xgbe_prv_data *pdata, int reg, u16 val)
@@ -638,7 +645,8 @@ static int xgbe_phy_i2c_mii_write(struct xgbe_prv_data *pdata, int reg, u16 val)
 	return ret;
 }
 
-static int xgbe_phy_mii_write(struct mii_bus *mii, int addr, int reg, u16 val)
+static int xgbe_phy_mii_write_c22(struct mii_bus *mii, int addr, int reg,
+				  u16 val)
 {
 	struct xgbe_prv_data *pdata = mii->priv;
 	struct xgbe_phy_data *phy_data = pdata->phy_data;
@@ -651,29 +659,58 @@ static int xgbe_phy_mii_write(struct mii_bus *mii, int addr, int reg, u16 val)
 	if (phy_data->conn_type == XGBE_CONN_TYPE_SFP)
 		ret = xgbe_phy_i2c_mii_write(pdata, reg, val);
 	else if (phy_data->conn_type & XGBE_CONN_TYPE_MDIO)
-		ret = xgbe_phy_mdio_mii_write(pdata, addr, reg, val);
+		ret = xgbe_phy_mdio_mii_write_c22(pdata, addr, reg, val);
 	else
-		ret = -ENOTSUPP;
+		ret = -EOPNOTSUPP;
 
 	xgbe_phy_put_comm_ownership(pdata);
 
 	return ret;
 }
 
-static int xgbe_phy_mdio_mii_read(struct xgbe_prv_data *pdata, int addr,
-				  int reg)
+static int xgbe_phy_mii_write_c45(struct mii_bus *mii, int addr, int devad,
+				  int reg, u16 val)
 {
+	struct xgbe_prv_data *pdata = mii->priv;
 	struct xgbe_phy_data *phy_data = pdata->phy_data;
+	int ret;
 
-	if (reg & MII_ADDR_C45) {
-		if (phy_data->phydev_mode != XGBE_MDIO_MODE_CL45)
-			return -ENOTSUPP;
-	} else {
-		if (phy_data->phydev_mode != XGBE_MDIO_MODE_CL22)
-			return -ENOTSUPP;
-	}
+	ret = xgbe_phy_get_comm_ownership(pdata);
+	if (ret)
+		return ret;
 
-	return pdata->hw_if.read_ext_mii_regs(pdata, addr, reg);
+	if (phy_data->conn_type == XGBE_CONN_TYPE_SFP)
+		ret = -EOPNOTSUPP;
+	else if (phy_data->conn_type & XGBE_CONN_TYPE_MDIO)
+		ret = xgbe_phy_mdio_mii_write_c45(pdata, addr, devad, reg, val);
+	else
+		ret = -EOPNOTSUPP;
+
+	xgbe_phy_put_comm_ownership(pdata);
+
+	return ret;
+}
+
+static int xgbe_phy_mdio_mii_read_c22(struct xgbe_prv_data *pdata, int addr,
+				      int reg)
+{
+	struct xgbe_phy_data *phy_data = pdata->phy_data;
+
+	if (phy_data->phydev_mode != XGBE_MDIO_MODE_CL22)
+		return -EOPNOTSUPP;
+
+	return pdata->hw_if.read_ext_mii_regs_c22(pdata, addr, reg);
+}
+
+static int xgbe_phy_mdio_mii_read_c45(struct xgbe_prv_data *pdata, int addr,
+				      int devad, int reg)
+{
+	struct xgbe_phy_data *phy_data = pdata->phy_data;
+
+	if (phy_data->phydev_mode != XGBE_MDIO_MODE_CL45)
+		return -EOPNOTSUPP;
+
+	return pdata->hw_if.read_ext_mii_regs_c45(pdata, addr, devad, reg);
 }
 
 static int xgbe_phy_i2c_mii_read(struct xgbe_prv_data *pdata, int reg)
@@ -698,7 +735,7 @@ static int xgbe_phy_i2c_mii_read(struct xgbe_prv_data *pdata, int reg)
 	return ret;
 }
 
-static int xgbe_phy_mii_read(struct mii_bus *mii, int addr, int reg)
+static int xgbe_phy_mii_read_c22(struct mii_bus *mii, int addr, int reg)
 {
 	struct xgbe_prv_data *pdata = mii->priv;
 	struct xgbe_phy_data *phy_data = pdata->phy_data;
@@ -711,7 +748,30 @@ static int xgbe_phy_mii_read(struct mii_bus *mii, int addr, int reg)
 	if (phy_data->conn_type == XGBE_CONN_TYPE_SFP)
 		ret = xgbe_phy_i2c_mii_read(pdata, reg);
 	else if (phy_data->conn_type & XGBE_CONN_TYPE_MDIO)
-		ret = xgbe_phy_mdio_mii_read(pdata, addr, reg);
+		ret = xgbe_phy_mdio_mii_read_c22(pdata, addr, reg);
+	else
+		ret = -EOPNOTSUPP;
+
+	xgbe_phy_put_comm_ownership(pdata);
+
+	return ret;
+}
+
+static int xgbe_phy_mii_read_c45(struct mii_bus *mii, int addr, int devad,
+				 int reg)
+{
+	struct xgbe_prv_data *pdata = mii->priv;
+	struct xgbe_phy_data *phy_data = pdata->phy_data;
+	int ret;
+
+	ret = xgbe_phy_get_comm_ownership(pdata);
+	if (ret)
+		return ret;
+
+	if (phy_data->conn_type == XGBE_CONN_TYPE_SFP)
+		ret = -EOPNOTSUPP;
+	else if (phy_data->conn_type & XGBE_CONN_TYPE_MDIO)
+		ret = xgbe_phy_mdio_mii_read_c45(pdata, addr, devad, reg);
 	else
 		ret = -ENOTSUPP;
 
@@ -1929,8 +1989,8 @@ static int xgbe_phy_set_redrv_mode_mdio(struct xgbe_prv_data *pdata,
 	redrv_reg = XGBE_PHY_REDRV_MODE_REG + (phy_data->redrv_lane * 0x1000);
 	redrv_val = (u16)mode;
 
-	return pdata->hw_if.write_ext_mii_regs(pdata, phy_data->redrv_addr,
-					       redrv_reg, redrv_val);
+	return pdata->hw_if.write_ext_mii_regs_c22(pdata, phy_data->redrv_addr,
+						   redrv_reg, redrv_val);
 }
 
 static int xgbe_phy_set_redrv_mode_i2c(struct xgbe_prv_data *pdata,
@@ -3502,8 +3562,10 @@ static int xgbe_phy_init(struct xgbe_prv_data *pdata)
 
 	mii->priv = pdata;
 	mii->name = "amd-xgbe-mii";
-	mii->read = xgbe_phy_mii_read;
-	mii->write = xgbe_phy_mii_write;
+	mii->read = xgbe_phy_mii_read_c22;
+	mii->write = xgbe_phy_mii_write_c22;
+	mii->read_c45 = xgbe_phy_mii_read_c45;
+	mii->write_c45 = xgbe_phy_mii_write_c45;
 	mii->parent = pdata->dev;
 	mii->phy_mask = ~0;
 	snprintf(mii->id, sizeof(mii->id), "%s", dev_name(pdata->dev));
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe.h b/drivers/net/ethernet/amd/xgbe/xgbe.h
index 4ae19a6f1704..16e73df3e9b9 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe.h
+++ b/drivers/net/ethernet/amd/xgbe/xgbe.h
@@ -776,8 +776,11 @@ struct xgbe_hw_if {
 
 	int (*set_ext_mii_mode)(struct xgbe_prv_data *, unsigned int,
 				enum xgbe_mdio_mode);
-	int (*read_ext_mii_regs)(struct xgbe_prv_data *, int, int);
-	int (*write_ext_mii_regs)(struct xgbe_prv_data *, int, int, u16);
+	int (*read_ext_mii_regs_c22)(struct xgbe_prv_data *, int, int);
+	int (*write_ext_mii_regs_c22)(struct xgbe_prv_data *, int, int, u16);
+	int (*read_ext_mii_regs_c45)(struct xgbe_prv_data *, int, int, int);
+	int (*write_ext_mii_regs_c45)(struct xgbe_prv_data *, int, int, int,
+				      u16);
 
 	int (*set_gpio)(struct xgbe_prv_data *, unsigned int);
 	int (*clr_gpio)(struct xgbe_prv_data *, unsigned int);

-- 
2.30.2

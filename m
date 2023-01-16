Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AAB966D361
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 00:53:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235335AbjAPXxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 18:53:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235011AbjAPXwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 18:52:51 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 735DF22A05;
        Mon, 16 Jan 2023 15:52:50 -0800 (PST)
Received: from mwalle01.sab.local (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 4B4EA16EE;
        Tue, 17 Jan 2023 00:52:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1673913168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FP6Dfe7S3M3hCeaRI1q2BDnXh3eLy37Yd4LAgViRJ1k=;
        b=akUvi4nTSTzYmjPbkFEuJoTMNw3gVMOk55vUK+WTdFBQ1CFr0QJ3R0Fn6gIvD+XvMBSGHG
        PFVed9eFfifdqML3SzPqMUHI2GAbwUGpsu0w5XIf7hha1qRWeE+j9Qmjhq1c6Ctkr31s/Z
        2saNhC1zyEOAL+EvKzmlJ4KFjgVGAwG9yDZvdviRHqoqJEvHw5/t8QzNCa21zofLwUknJE
        xRR1i1edEj2+Xvw6d6FHRFQ6Ss/w/PoyMntuAWMCD/qIJlN6ow4zO3U/hbfzGvqQcoMOGJ
        +msggqphhalz1CJ/DTMKRCae/4/jYeE9ciSgUgIjdal5n9iLthQx2T3KXcC0LA==
From:   Michael Walle <michael@walle.cc>
Date:   Tue, 17 Jan 2023 00:52:22 +0100
Subject: [PATCH net-next 07/12] net: hns: Separate C22 and C45 transactions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230116-net-next-c45-seperation-part-3-v1-7-0c53afa56aad@walle.cc>
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

The hns MDIO bus driver can perform both C22 and C45 transfers.
Create separate functions for each and register the C45 versions using
the new API calls where appropriate.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/ethernet/hisilicon/hns_mdio.c | 192 +++++++++++++++++++++---------
 1 file changed, 135 insertions(+), 57 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns_mdio.c b/drivers/net/ethernet/hisilicon/hns_mdio.c
index c2ae1b4f9a5f..9232caaf0bdc 100644
--- a/drivers/net/ethernet/hisilicon/hns_mdio.c
+++ b/drivers/net/ethernet/hisilicon/hns_mdio.c
@@ -206,7 +206,7 @@ static void hns_mdio_cmd_write(struct hns_mdio_device *mdio_dev,
 }
 
 /**
- * hns_mdio_write - access phy register
+ * hns_mdio_write_c22 - access phy register
  * @bus: mdio bus
  * @phy_id: phy id
  * @regnum: register num
@@ -214,21 +214,19 @@ static void hns_mdio_cmd_write(struct hns_mdio_device *mdio_dev,
  *
  * Return 0 on success, negative on failure
  */
-static int hns_mdio_write(struct mii_bus *bus,
-			  int phy_id, int regnum, u16 data)
+static int hns_mdio_write_c22(struct mii_bus *bus,
+			      int phy_id, int regnum, u16 data)
 {
-	int ret;
 	struct hns_mdio_device *mdio_dev = (struct hns_mdio_device *)bus->priv;
-	u8 devad = ((regnum >> 16) & 0x1f);
-	u8 is_c45 = !!(regnum & MII_ADDR_C45);
 	u16 reg = (u16)(regnum & 0xffff);
-	u8 op;
 	u16 cmd_reg_cfg;
+	int ret;
+	u8 op;
 
 	dev_dbg(&bus->dev, "mdio write %s,base is %p\n",
 		bus->id, mdio_dev->vbase);
-	dev_dbg(&bus->dev, "phy id=%d, is_c45=%d, devad=%d, reg=%#x, write data=%d\n",
-		phy_id, is_c45, devad, reg, data);
+	dev_dbg(&bus->dev, "phy id=%d, reg=%#x, write data=%d\n",
+		phy_id, reg, data);
 
 	/* wait for ready */
 	ret = hns_mdio_wait_ready(bus);
@@ -237,58 +235,91 @@ static int hns_mdio_write(struct mii_bus *bus,
 		return ret;
 	}
 
-	if (!is_c45) {
-		cmd_reg_cfg = reg;
-		op = MDIO_C22_WRITE;
-	} else {
-		/* config the cmd-reg to write addr*/
-		MDIO_SET_REG_FIELD(mdio_dev, MDIO_ADDR_REG, MDIO_ADDR_DATA_M,
-				   MDIO_ADDR_DATA_S, reg);
+	cmd_reg_cfg = reg;
+	op = MDIO_C22_WRITE;
 
-		hns_mdio_cmd_write(mdio_dev, is_c45,
-				   MDIO_C45_WRITE_ADDR, phy_id, devad);
+	MDIO_SET_REG_FIELD(mdio_dev, MDIO_WDATA_REG, MDIO_WDATA_DATA_M,
+			   MDIO_WDATA_DATA_S, data);
 
-		/* check for read or write opt is finished */
-		ret = hns_mdio_wait_ready(bus);
-		if (ret) {
-			dev_err(&bus->dev, "MDIO bus is busy\n");
-			return ret;
-		}
+	hns_mdio_cmd_write(mdio_dev, false, op, phy_id, cmd_reg_cfg);
+
+	return 0;
+}
+
+/**
+ * hns_mdio_write_c45 - access phy register
+ * @bus: mdio bus
+ * @phy_id: phy id
+ * @devad: device address to read
+ * @regnum: register num
+ * @data: register value
+ *
+ * Return 0 on success, negative on failure
+ */
+static int hns_mdio_write_c45(struct mii_bus *bus, int phy_id, int devad,
+			      int regnum, u16 data)
+{
+	struct hns_mdio_device *mdio_dev = (struct hns_mdio_device *)bus->priv;
+	u16 reg = (u16)(regnum & 0xffff);
+	u16 cmd_reg_cfg;
+	int ret;
+	u8 op;
+
+	dev_dbg(&bus->dev, "mdio write %s,base is %p\n",
+		bus->id, mdio_dev->vbase);
+	dev_dbg(&bus->dev, "phy id=%d, devad=%d, reg=%#x, write data=%d\n",
+		phy_id, devad, reg, data);
+
+	/* wait for ready */
+	ret = hns_mdio_wait_ready(bus);
+	if (ret) {
+		dev_err(&bus->dev, "MDIO bus is busy\n");
+		return ret;
+	}
+
+	/* config the cmd-reg to write addr*/
+	MDIO_SET_REG_FIELD(mdio_dev, MDIO_ADDR_REG, MDIO_ADDR_DATA_M,
+			   MDIO_ADDR_DATA_S, reg);
 
-		/* config the data needed writing */
-		cmd_reg_cfg = devad;
-		op = MDIO_C45_WRITE_DATA;
+	hns_mdio_cmd_write(mdio_dev, true, MDIO_C45_WRITE_ADDR, phy_id, devad);
+
+	/* check for read or write opt is finished */
+	ret = hns_mdio_wait_ready(bus);
+	if (ret) {
+		dev_err(&bus->dev, "MDIO bus is busy\n");
+		return ret;
 	}
 
+	/* config the data needed writing */
+	cmd_reg_cfg = devad;
+	op = MDIO_C45_WRITE_DATA;
+
 	MDIO_SET_REG_FIELD(mdio_dev, MDIO_WDATA_REG, MDIO_WDATA_DATA_M,
 			   MDIO_WDATA_DATA_S, data);
 
-	hns_mdio_cmd_write(mdio_dev, is_c45, op, phy_id, cmd_reg_cfg);
+	hns_mdio_cmd_write(mdio_dev, true, op, phy_id, cmd_reg_cfg);
 
 	return 0;
 }
 
 /**
- * hns_mdio_read - access phy register
+ * hns_mdio_read_c22 - access phy register
  * @bus: mdio bus
  * @phy_id: phy id
  * @regnum: register num
  *
  * Return phy register value
  */
-static int hns_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
+static int hns_mdio_read_c22(struct mii_bus *bus, int phy_id, int regnum)
 {
-	int ret;
-	u16 reg_val;
-	u8 devad = ((regnum >> 16) & 0x1f);
-	u8 is_c45 = !!(regnum & MII_ADDR_C45);
-	u16 reg = (u16)(regnum & 0xffff);
 	struct hns_mdio_device *mdio_dev = (struct hns_mdio_device *)bus->priv;
+	u16 reg = (u16)(regnum & 0xffff);
+	u16 reg_val;
+	int ret;
 
 	dev_dbg(&bus->dev, "mdio read %s,base is %p\n",
 		bus->id, mdio_dev->vbase);
-	dev_dbg(&bus->dev, "phy id=%d, is_c45=%d, devad=%d, reg=%#x!\n",
-		phy_id, is_c45, devad, reg);
+	dev_dbg(&bus->dev, "phy id=%d, reg=%#x!\n", phy_id, reg);
 
 	/* Step 1: wait for ready */
 	ret = hns_mdio_wait_ready(bus);
@@ -297,29 +328,74 @@ static int hns_mdio_read(struct mii_bus *bus, int phy_id, int regnum)
 		return ret;
 	}
 
-	if (!is_c45) {
-		hns_mdio_cmd_write(mdio_dev, is_c45,
-				   MDIO_C22_READ, phy_id, reg);
-	} else {
-		MDIO_SET_REG_FIELD(mdio_dev, MDIO_ADDR_REG, MDIO_ADDR_DATA_M,
-				   MDIO_ADDR_DATA_S, reg);
+	hns_mdio_cmd_write(mdio_dev, false, MDIO_C22_READ, phy_id, reg);
 
-		/* Step 2; config the cmd-reg to write addr*/
-		hns_mdio_cmd_write(mdio_dev, is_c45,
-				   MDIO_C45_WRITE_ADDR, phy_id, devad);
+	/* Step 2: waiting for MDIO_COMMAND_REG 's mdio_start==0,*/
+	/* check for read or write opt is finished */
+	ret = hns_mdio_wait_ready(bus);
+	if (ret) {
+		dev_err(&bus->dev, "MDIO bus is busy\n");
+		return ret;
+	}
 
-		/* Step 3: check for read or write opt is finished */
-		ret = hns_mdio_wait_ready(bus);
-		if (ret) {
-			dev_err(&bus->dev, "MDIO bus is busy\n");
-			return ret;
-		}
+	reg_val = MDIO_GET_REG_BIT(mdio_dev, MDIO_STA_REG, MDIO_STATE_STA_B);
+	if (reg_val) {
+		dev_err(&bus->dev, " ERROR! MDIO Read failed!\n");
+		return -EBUSY;
+	}
 
-		hns_mdio_cmd_write(mdio_dev, is_c45,
-				   MDIO_C45_READ, phy_id, devad);
+	/* Step 3; get out data*/
+	reg_val = (u16)MDIO_GET_REG_FIELD(mdio_dev, MDIO_RDATA_REG,
+					  MDIO_RDATA_DATA_M, MDIO_RDATA_DATA_S);
+
+	return reg_val;
+}
+
+/**
+ * hns_mdio_read_c45 - access phy register
+ * @bus: mdio bus
+ * @phy_id: phy id
+ * @devad: device address to read
+ * @regnum: register num
+ *
+ * Return phy register value
+ */
+static int hns_mdio_read_c45(struct mii_bus *bus, int phy_id, int devad,
+			     int regnum)
+{
+	struct hns_mdio_device *mdio_dev = (struct hns_mdio_device *)bus->priv;
+	u16 reg = (u16)(regnum & 0xffff);
+	u16 reg_val;
+	int ret;
+
+	dev_dbg(&bus->dev, "mdio read %s,base is %p\n",
+		bus->id, mdio_dev->vbase);
+	dev_dbg(&bus->dev, "phy id=%d, devad=%d, reg=%#x!\n",
+		phy_id, devad, reg);
+
+	/* Step 1: wait for ready */
+	ret = hns_mdio_wait_ready(bus);
+	if (ret) {
+		dev_err(&bus->dev, "MDIO bus is busy\n");
+		return ret;
+	}
+
+	MDIO_SET_REG_FIELD(mdio_dev, MDIO_ADDR_REG, MDIO_ADDR_DATA_M,
+			   MDIO_ADDR_DATA_S, reg);
+
+	/* Step 2; config the cmd-reg to write addr*/
+	hns_mdio_cmd_write(mdio_dev, true, MDIO_C45_WRITE_ADDR, phy_id, devad);
+
+	/* Step 3: check for read or write opt is finished */
+	ret = hns_mdio_wait_ready(bus);
+	if (ret) {
+		dev_err(&bus->dev, "MDIO bus is busy\n");
+		return ret;
 	}
 
-	/* Step 5: waiting for MDIO_COMMAND_REG's mdio_start==0,*/
+	hns_mdio_cmd_write(mdio_dev, true, MDIO_C45_READ, phy_id, devad);
+
+	/* Step 5: waiting for MDIO_COMMAND_REG 's mdio_start==0,*/
 	/* check for read or write opt is finished */
 	ret = hns_mdio_wait_ready(bus);
 	if (ret) {
@@ -438,8 +514,10 @@ static int hns_mdio_probe(struct platform_device *pdev)
 	}
 
 	new_bus->name = MDIO_BUS_NAME;
-	new_bus->read = hns_mdio_read;
-	new_bus->write = hns_mdio_write;
+	new_bus->read = hns_mdio_read_c22;
+	new_bus->write = hns_mdio_write_c22;
+	new_bus->read_c45 = hns_mdio_read_c45;
+	new_bus->write_c45 = hns_mdio_write_c45;
 	new_bus->reset = hns_mdio_reset;
 	new_bus->priv = mdio_dev;
 	new_bus->parent = &pdev->dev;

-- 
2.30.2

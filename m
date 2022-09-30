Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 431485F0D73
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 16:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbiI3OW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 10:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231955AbiI3OV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 10:21:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A01871A6E85
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 07:21:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 380A46236C
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 14:21:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3432FC43142;
        Fri, 30 Sep 2022 14:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664547695;
        bh=9cZCQuvU/DLoEFC5i6FbwDoripTi1tnICs3hzDL4fgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ty+X+/NCEtxW1F7RhwA5e29uaYI2YPW3877xk4klJ2yJ81riL9MRqiEpIvAcxy+Dn
         pWlLxHFEfhWusP92bc2gfnC8iA3VUw6yVcd33EmNXnqUk0NFTL3y+mAP9iNCFsksXA
         1gIJyHv7w5tfunk3wf6MmBh4Nct3JESua3jIo4ItbJsQlZOkwGllDhc/b85RctSsyQ
         7HVeDFgc99JxsAytZyQJpiJ4VNFnj44jwD9PHcNbir6JRNlmtKZKpwzV6Vy5PU9MUo
         L17aqEwNcjBzlMdHVXtVawXuwVCifBB2Tf8QCSaKhfcetSNAB66r+t2EA4vjaKj/1v
         Firn2b4W7gyIQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 11/12] net: phy: mdio-i2c: support I2C MDIO protocol for RollBall SFP modules
Date:   Fri, 30 Sep 2022 16:21:09 +0200
Message-Id: <20220930142110.15372-12-kabel@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220930142110.15372-1-kabel@kernel.org>
References: <20220930142110.15372-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some multigig SFPs from RollBall and Hilink do not expose functional
MDIO access to the internal PHY of the SFP via I2C address 0x56
(although there seems to be read-only clause 22 access on this address).

Instead these SFPs PHY can be accessed via I2C via the SFP Enhanced
Digital Diagnostic Interface - I2C address 0x51. The SFP_PAGE has to be
selected to 3 and the password must be filled with 0xff bytes for this
PHY communication to work.

This extends the mdio-i2c driver to support this protocol by adding a
special parameter to mdio_i2c_alloc function via which this RollBall
protocol can be selected.

Signed-off-by: Marek Behún <kabel@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/mdio/mdio-i2c.c   | 310 +++++++++++++++++++++++++++++++++-
 drivers/net/phy/sfp.c         |   6 +-
 include/linux/mdio/mdio-i2c.h |   4 +-
 3 files changed, 313 insertions(+), 7 deletions(-)

diff --git a/drivers/net/mdio/mdio-i2c.c b/drivers/net/mdio/mdio-i2c.c
index 09200a70b315..bf8bf5e20faf 100644
--- a/drivers/net/mdio/mdio-i2c.c
+++ b/drivers/net/mdio/mdio-i2c.c
@@ -3,6 +3,7 @@
  * MDIO I2C bridge
  *
  * Copyright (C) 2015-2016 Russell King
+ * Copyright (C) 2021 Marek Behun
  *
  * Network PHYs can appear on I2C buses when they are part of SFP module.
  * This driver exposes these PHYs to the networking PHY code, allowing
@@ -12,6 +13,7 @@
 #include <linux/i2c.h>
 #include <linux/mdio/mdio-i2c.h>
 #include <linux/phy.h>
+#include <linux/sfp.h>
 
 /*
  * I2C bus addresses 0x50 and 0x51 are normally an EEPROM, which is
@@ -28,7 +30,7 @@ static unsigned int i2c_mii_phy_addr(int phy_id)
 	return phy_id + 0x40;
 }
 
-static int i2c_mii_read(struct mii_bus *bus, int phy_id, int reg)
+static int i2c_mii_read_default(struct mii_bus *bus, int phy_id, int reg)
 {
 	struct i2c_adapter *i2c = bus->priv;
 	struct i2c_msg msgs[2];
@@ -62,7 +64,8 @@ static int i2c_mii_read(struct mii_bus *bus, int phy_id, int reg)
 	return data[0] << 8 | data[1];
 }
 
-static int i2c_mii_write(struct mii_bus *bus, int phy_id, int reg, u16 val)
+static int i2c_mii_write_default(struct mii_bus *bus, int phy_id, int reg,
+				 u16 val)
 {
 	struct i2c_adapter *i2c = bus->priv;
 	struct i2c_msg msg;
@@ -91,9 +94,288 @@ static int i2c_mii_write(struct mii_bus *bus, int phy_id, int reg, u16 val)
 	return ret < 0 ? ret : 0;
 }
 
-struct mii_bus *mdio_i2c_alloc(struct device *parent, struct i2c_adapter *i2c)
+/* RollBall SFPs do not access internal PHY via I2C address 0x56, but
+ * instead via address 0x51, when SFP page is set to 0x03 and password to
+ * 0xffffffff.
+ *
+ * address  size  contents  description
+ * -------  ----  --------  -----------
+ * 0x80     1     CMD       0x01/0x02/0x04 for write/read/done
+ * 0x81     1     DEV       Clause 45 device
+ * 0x82     2     REG       Clause 45 register
+ * 0x84     2     VAL       Register value
+ */
+#define ROLLBALL_PHY_I2C_ADDR		0x51
+
+#define ROLLBALL_PASSWORD		(SFP_VSL + 3)
+
+#define ROLLBALL_CMD_ADDR		0x80
+#define ROLLBALL_DATA_ADDR		0x81
+
+#define ROLLBALL_CMD_WRITE		0x01
+#define ROLLBALL_CMD_READ		0x02
+#define ROLLBALL_CMD_DONE		0x04
+
+#define SFP_PAGE_ROLLBALL_MDIO		3
+
+static int __i2c_transfer_err(struct i2c_adapter *i2c, struct i2c_msg *msgs,
+			      int num)
+{
+	int ret;
+
+	ret = __i2c_transfer(i2c, msgs, num);
+	if (ret < 0)
+		return ret;
+	else if (ret != num)
+		return -EIO;
+	else
+		return 0;
+}
+
+static int __i2c_rollball_get_page(struct i2c_adapter *i2c, int bus_addr,
+				   u8 *page)
+{
+	struct i2c_msg msgs[2];
+	u8 addr = SFP_PAGE;
+
+	msgs[0].addr = bus_addr;
+	msgs[0].flags = 0;
+	msgs[0].len = 1;
+	msgs[0].buf = &addr;
+
+	msgs[1].addr = bus_addr;
+	msgs[1].flags = I2C_M_RD;
+	msgs[1].len = 1;
+	msgs[1].buf = page;
+
+	return __i2c_transfer_err(i2c, msgs, 2);
+}
+
+static int __i2c_rollball_set_page(struct i2c_adapter *i2c, int bus_addr,
+				   u8 page)
+{
+	struct i2c_msg msg;
+	u8 buf[2];
+
+	buf[0] = SFP_PAGE;
+	buf[1] = page;
+
+	msg.addr = bus_addr;
+	msg.flags = 0;
+	msg.len = 2;
+	msg.buf = buf;
+
+	return __i2c_transfer_err(i2c, &msg, 1);
+}
+
+/* In order to not interfere with other SFP code (which possibly may manipulate
+ * SFP_PAGE), for every transfer we do this:
+ *   1. lock the bus
+ *   2. save content of SFP_PAGE
+ *   3. set SFP_PAGE to 3
+ *   4. do the transfer
+ *   5. restore original SFP_PAGE
+ *   6. unlock the bus
+ * Note that one might think that steps 2 to 5 could be theoretically done all
+ * in one call to i2c_transfer (by constructing msgs array in such a way), but
+ * unfortunately tests show that this does not work :-( Changed SFP_PAGE does
+ * not take into account until i2c_transfer() is done.
+ */
+static int i2c_transfer_rollball(struct i2c_adapter *i2c,
+				 struct i2c_msg *msgs, int num)
+{
+	int ret, main_err = 0;
+	u8 saved_page;
+
+	i2c_lock_bus(i2c, I2C_LOCK_SEGMENT);
+
+	/* save original page */
+	ret = __i2c_rollball_get_page(i2c, msgs->addr, &saved_page);
+	if (ret)
+		goto unlock;
+
+	/* change to RollBall MDIO page */
+	ret = __i2c_rollball_set_page(i2c, msgs->addr, SFP_PAGE_ROLLBALL_MDIO);
+	if (ret)
+		goto unlock;
+
+	/* do the transfer; we try to restore original page if this fails */
+	ret = __i2c_transfer_err(i2c, msgs, num);
+	if (ret)
+		main_err = ret;
+
+	/* restore original page */
+	ret = __i2c_rollball_set_page(i2c, msgs->addr, saved_page);
+
+unlock:
+	i2c_unlock_bus(i2c, I2C_LOCK_SEGMENT);
+
+	return main_err ? : ret;
+}
+
+static int i2c_rollball_mii_poll(struct mii_bus *bus, int bus_addr, u8 *buf,
+				 size_t len)
+{
+	struct i2c_adapter *i2c = bus->priv;
+	struct i2c_msg msgs[2];
+	u8 cmd_addr, tmp, *res;
+	int i, ret;
+
+	cmd_addr = ROLLBALL_CMD_ADDR;
+
+	res = buf ? buf : &tmp;
+	len = buf ? len : 1;
+
+	msgs[0].addr = bus_addr;
+	msgs[0].flags = 0;
+	msgs[0].len = 1;
+	msgs[0].buf = &cmd_addr;
+
+	msgs[1].addr = bus_addr;
+	msgs[1].flags = I2C_M_RD;
+	msgs[1].len = len;
+	msgs[1].buf = res;
+
+	/* By experiment it takes up to 70 ms to access a register for these
+	 * SFPs. Sleep 20ms between iterations and try 10 times.
+	 */
+	i = 10;
+	do {
+		msleep(20);
+
+		ret = i2c_transfer_rollball(i2c, msgs, ARRAY_SIZE(msgs));
+		if (ret)
+			return ret;
+
+		if (*res == ROLLBALL_CMD_DONE)
+			return 0;
+	} while (i-- > 0);
+
+	dev_dbg(&bus->dev, "poll timed out\n");
+
+	return -ETIMEDOUT;
+}
+
+static int i2c_rollball_mii_cmd(struct mii_bus *bus, int bus_addr, u8 cmd,
+				u8 *data, size_t len)
+{
+	struct i2c_adapter *i2c = bus->priv;
+	struct i2c_msg msgs[2];
+	u8 cmdbuf[2];
+
+	cmdbuf[0] = ROLLBALL_CMD_ADDR;
+	cmdbuf[1] = cmd;
+
+	msgs[0].addr = bus_addr;
+	msgs[0].flags = 0;
+	msgs[0].len = len;
+	msgs[0].buf = data;
+
+	msgs[1].addr = bus_addr;
+	msgs[1].flags = 0;
+	msgs[1].len = sizeof(cmdbuf);
+	msgs[1].buf = cmdbuf;
+
+	return i2c_transfer_rollball(i2c, msgs, ARRAY_SIZE(msgs));
+}
+
+static int i2c_mii_read_rollball(struct mii_bus *bus, int phy_id, int reg)
+{
+	u8 buf[4], res[6];
+	int bus_addr, ret;
+	u16 val;
+
+	if (!(reg & MII_ADDR_C45))
+		return -EOPNOTSUPP;
+
+	bus_addr = i2c_mii_phy_addr(phy_id);
+	if (bus_addr != ROLLBALL_PHY_I2C_ADDR)
+		return 0xffff;
+
+	buf[0] = ROLLBALL_DATA_ADDR;
+	buf[1] = (reg >> 16) & 0x1f;
+	buf[2] = (reg >> 8) & 0xff;
+	buf[3] = reg & 0xff;
+
+	ret = i2c_rollball_mii_cmd(bus, bus_addr, ROLLBALL_CMD_READ, buf,
+				   sizeof(buf));
+	if (ret < 0)
+		return ret;
+
+	ret = i2c_rollball_mii_poll(bus, bus_addr, res, sizeof(res));
+	if (ret == -ETIMEDOUT)
+		return 0xffff;
+	else if (ret < 0)
+		return ret;
+
+	val = res[4] << 8 | res[5];
+
+	return val;
+}
+
+static int i2c_mii_write_rollball(struct mii_bus *bus, int phy_id, int reg,
+				  u16 val)
+{
+	int bus_addr, ret;
+	u8 buf[6];
+
+	if (!(reg & MII_ADDR_C45))
+		return -EOPNOTSUPP;
+
+	bus_addr = i2c_mii_phy_addr(phy_id);
+	if (bus_addr != ROLLBALL_PHY_I2C_ADDR)
+		return 0;
+
+	buf[0] = ROLLBALL_DATA_ADDR;
+	buf[1] = (reg >> 16) & 0x1f;
+	buf[2] = (reg >> 8) & 0xff;
+	buf[3] = reg & 0xff;
+	buf[4] = val >> 8;
+	buf[5] = val & 0xff;
+
+	ret = i2c_rollball_mii_cmd(bus, bus_addr, ROLLBALL_CMD_WRITE, buf,
+				   sizeof(buf));
+	if (ret < 0)
+		return ret;
+
+	ret = i2c_rollball_mii_poll(bus, bus_addr, NULL, 0);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int i2c_mii_init_rollball(struct i2c_adapter *i2c)
+{
+	struct i2c_msg msg;
+	u8 pw[5];
+	int ret;
+
+	pw[0] = ROLLBALL_PASSWORD;
+	pw[1] = 0xff;
+	pw[2] = 0xff;
+	pw[3] = 0xff;
+	pw[4] = 0xff;
+
+	msg.addr = ROLLBALL_PHY_I2C_ADDR;
+	msg.flags = 0;
+	msg.len = sizeof(pw);
+	msg.buf = pw;
+
+	ret = i2c_transfer(i2c, &msg, 1);
+	if (ret < 0)
+		return ret;
+	else if (ret != 1)
+		return -EIO;
+	else
+		return 0;
+}
+
+struct mii_bus *mdio_i2c_alloc(struct device *parent, struct i2c_adapter *i2c,
+			       enum mdio_i2c_proto protocol)
 {
 	struct mii_bus *mii;
+	int ret;
 
 	if (!i2c_check_functionality(i2c, I2C_FUNC_I2C))
 		return ERR_PTR(-EINVAL);
@@ -104,10 +386,28 @@ struct mii_bus *mdio_i2c_alloc(struct device *parent, struct i2c_adapter *i2c)
 
 	snprintf(mii->id, MII_BUS_ID_SIZE, "i2c:%s", dev_name(parent));
 	mii->parent = parent;
-	mii->read = i2c_mii_read;
-	mii->write = i2c_mii_write;
 	mii->priv = i2c;
 
+	switch (protocol) {
+	case MDIO_I2C_ROLLBALL:
+		ret = i2c_mii_init_rollball(i2c);
+		if (ret < 0) {
+			dev_err(parent,
+				"Cannot initialize RollBall MDIO I2C protocol: %d\n",
+				ret);
+			mdiobus_free(mii);
+			return ERR_PTR(ret);
+		}
+
+		mii->read = i2c_mii_read_rollball;
+		mii->write = i2c_mii_write_rollball;
+		break;
+	default:
+		mii->read = i2c_mii_read_default;
+		mii->write = i2c_mii_write_default;
+		break;
+	}
+
 	return mii;
 }
 EXPORT_SYMBOL_GPL(mdio_i2c_alloc);
diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index ccd7710685f2..20f48464a06a 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -546,7 +546,7 @@ static int sfp_i2c_mdiobus_create(struct sfp *sfp)
 	struct mii_bus *i2c_mii;
 	int ret;
 
-	i2c_mii = mdio_i2c_alloc(sfp->dev, sfp->i2c);
+	i2c_mii = mdio_i2c_alloc(sfp->dev, sfp->i2c, sfp->mdio_protocol);
 	if (IS_ERR(i2c_mii))
 		return PTR_ERR(i2c_mii);
 
@@ -1720,6 +1720,10 @@ static int sfp_sm_probe_for_phy(struct sfp *sfp)
 	case MDIO_I2C_C45:
 		err = sfp_sm_probe_phy(sfp, true);
 		break;
+
+	case MDIO_I2C_ROLLBALL:
+		err = -EOPNOTSUPP;
+		break;
 	}
 
 	return err;
diff --git a/include/linux/mdio/mdio-i2c.h b/include/linux/mdio/mdio-i2c.h
index 3bde1a555a49..65b550a6fc32 100644
--- a/include/linux/mdio/mdio-i2c.h
+++ b/include/linux/mdio/mdio-i2c.h
@@ -15,8 +15,10 @@ enum mdio_i2c_proto {
 	MDIO_I2C_NONE,
 	MDIO_I2C_MARVELL_C22,
 	MDIO_I2C_C45,
+	MDIO_I2C_ROLLBALL,
 };
 
-struct mii_bus *mdio_i2c_alloc(struct device *parent, struct i2c_adapter *i2c);
+struct mii_bus *mdio_i2c_alloc(struct device *parent, struct i2c_adapter *i2c,
+			       enum mdio_i2c_proto protocol);
 
 #endif
-- 
2.35.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFCA36570DD
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 00:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbiL0XIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 18:08:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232151AbiL0XHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 18:07:46 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90847B4A5;
        Tue, 27 Dec 2022 15:07:31 -0800 (PST)
Received: from mwalle01.sab.local (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id BD82D16EA;
        Wed, 28 Dec 2022 00:07:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1672182450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hfJorQnKMERmz+LiqP1dBLwXqwSIibWbImpZkqwPLDw=;
        b=IidzJcgxLAGi5gJlWjd90IjWinbkMgOZwpbubUi/VSuvXFVFjARyi0ZrAHJQA1HFwHs4RU
        SNfggwd9pRguuIP1RE71gz8cQIe+Mg0PtUkDctemXSF+OyHaQ8vhNeJb4RiPf9zoXm2uik
        lHA4RJkDGy9oOK42rpNQqgk/eBhwsnXfBtePO/vBY2CKZVq8kjtyfu6KSkqhVXztDYjYrq
        gSp70TmhKgf8MBdImYt1wB83ysnUxMIA5tLZl1GhxQva6MZQ0c5Mx34WDlvyV3sfmcRRej
        kAjzsoPX0XBaNj09csgFcdn2LYOPrnyhs6mcIuRobQrk91o4FpqR78qa5Jmi4g==
From:   Michael Walle <michael@walle.cc>
Date:   Wed, 28 Dec 2022 00:07:26 +0100
Subject: [PATCH RFC net-next v2 10/12] net: mdio: add
 mdiobus_c45_read/write_nested helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221227-v6-2-rc1-c45-seperation-v2-10-ddb37710e5a7@walle.cc>
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

Some DSA devices pass through PHY access to the MDIO bus the switch is
on. Add C45 versions of the current C22 helpers for nested accesses to
MDIO busses, so that C22 and C45 can be separated in these DSA
drivers.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michael Walle <michael@walle.cc>
---
v2:
 - [al] new patch
---
 drivers/net/phy/mdio_bus.c | 55 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mdio.h       |  4 ++++
 2 files changed, 59 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 0b04ce3766c8..7f6b12b65f0d 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -1011,6 +1011,33 @@ int mdiobus_c45_read(struct mii_bus *bus, int addr, int devad, u32 regnum)
 }
 EXPORT_SYMBOL(mdiobus_c45_read);
 
+/**
+ * mdiobus_c45_read_nested - Nested version of the mdiobus_c45_read function
+ * @bus: the mii_bus struct
+ * @addr: the phy address
+ * @devad: device address to read
+ * @regnum: register number to read
+ *
+ * In case of nested MDIO bus access avoid lockdep false positives by
+ * using mutex_lock_nested().
+ *
+ * NOTE: MUST NOT be called from interrupt context,
+ * because the bus read/write functions may wait for an interrupt
+ * to conclude the operation.
+ */
+int mdiobus_c45_read_nested(struct mii_bus *bus, int addr, int devad,
+			    u32 regnum)
+{
+	int retval;
+
+	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
+	retval = __mdiobus_c45_read(bus, addr, devad, regnum);
+	mutex_unlock(&bus->mdio_lock);
+
+	return retval;
+}
+EXPORT_SYMBOL(mdiobus_c45_read_nested);
+
 /**
  * mdiobus_write_nested - Nested version of the mdiobus_write function
  * @bus: the mii_bus struct
@@ -1085,6 +1112,34 @@ int mdiobus_c45_write(struct mii_bus *bus, int addr, int devad, u32 regnum,
 }
 EXPORT_SYMBOL(mdiobus_c45_write);
 
+/**
+ * mdiobus_c45_write_nested - Nested version of the mdiobus_c45_write function
+ * @bus: the mii_bus struct
+ * @addr: the phy address
+ * @devad: device address to read
+ * @regnum: register number to write
+ * @val: value to write to @regnum
+ *
+ * In case of nested MDIO bus access avoid lockdep false positives by
+ * using mutex_lock_nested().
+ *
+ * NOTE: MUST NOT be called from interrupt context,
+ * because the bus read/write functions may wait for an interrupt
+ * to conclude the operation.
+ */
+int mdiobus_c45_write_nested(struct mii_bus *bus, int addr, int devad,
+			     u32 regnum, u16 val)
+{
+	int err;
+
+	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
+	err = __mdiobus_c45_write(bus, addr, devad, regnum, val);
+	mutex_unlock(&bus->mdio_lock);
+
+	return err;
+}
+EXPORT_SYMBOL(mdiobus_c45_write_nested);
+
 /**
  * mdiobus_modify - Convenience function for modifying a given mdio device
  *	register
diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index 97b49765e8b5..220f3ca8702d 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -425,10 +425,14 @@ int mdiobus_modify_changed(struct mii_bus *bus, int addr, u32 regnum,
 			   u16 mask, u16 set);
 int __mdiobus_c45_read(struct mii_bus *bus, int addr, int devad, u32 regnum);
 int mdiobus_c45_read(struct mii_bus *bus, int addr, int devad, u32 regnum);
+int mdiobus_c45_read_nested(struct mii_bus *bus, int addr, int devad,
+			     u32 regnum);
 int __mdiobus_c45_write(struct mii_bus *bus, int addr,  int devad, u32 regnum,
 			u16 val);
 int mdiobus_c45_write(struct mii_bus *bus, int addr,  int devad, u32 regnum,
 		      u16 val);
+int mdiobus_c45_write_nested(struct mii_bus *bus, int addr,  int devad,
+			     u32 regnum, u16 val);
 int mdiobus_c45_modify(struct mii_bus *bus, int addr, int devad, u32 regnum,
 		       u16 mask, u16 set);
 

-- 
2.30.2

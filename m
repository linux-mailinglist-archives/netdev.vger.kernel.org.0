Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88CBE662A1E
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 16:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237205AbjAIPct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 10:32:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237250AbjAIPbu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 10:31:50 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2E61EC60;
        Mon,  9 Jan 2023 07:31:07 -0800 (PST)
Received: from mwalle01.sab.local (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 4327319AC;
        Mon,  9 Jan 2023 16:30:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1673278258;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZKZX4lcj+SRBIVWCBH17m7wfPVkw0M5gZtlyN0DyHu8=;
        b=fCSsUcMXDlZzixTku/Y+ymZofQlKNafLyq8JmlrNVkLWLAFDn3XTwVw51vWElJJug1k+ZF
        ogtfq1axpzXT0hqcrnwCHvgMMPNP6WaRhHDKAifUTLBQ9/xzr0f3e9ZG7OIot1HTsrmSgF
        E5JPalqR23Z7h5hF6Y8X91w8h5uzm0ilszAFTB8nCKi7399/rjeup3ijl+Ln9olwa8mlLz
        G8eav1lUQCAxySB/z8ynkAfTL1UOMuJwT0g37B+DPElKUBlcNAwinuITOjgZ5iTqKJBH5O
        yYTauzwB5otYjzxH9nQbr9EYkoIuNFAC7oQyhruz9v/Fha75yrSS1p/xWID3jA==
From:   Michael Walle <michael@walle.cc>
Date:   Mon, 09 Jan 2023 16:30:50 +0100
Subject: [PATCH net-next v3 10/11] net: mdio: add
 mdiobus_c45_read/write_nested helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221227-v6-2-rc1-c45-seperation-v3-10-ade1deb438da@walle.cc>
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
index 522cbe6a0b23..902e1c88ef58 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -1008,6 +1008,33 @@ int mdiobus_c45_read(struct mii_bus *bus, int addr, int devad, u32 regnum)
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
@@ -1082,6 +1109,34 @@ int mdiobus_c45_write(struct mii_bus *bus, int addr, int devad, u32 regnum,
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

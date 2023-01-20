Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 719B6676044
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 23:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjATWk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 17:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjATWkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 17:40:24 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC787C873;
        Fri, 20 Jan 2023 14:40:22 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id C6DFF1692;
        Fri, 20 Jan 2023 23:40:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1674254421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BDVuKXh0Kd5QNrze0FujuDJa3AT6+b9OQz14bZfixL4=;
        b=tgAxm0nUOZazHv5XPuvTMF39YrBySknoyWVd6o/fYI1adapxtfqWEeaySA5Z5vGPdvro4f
        O1VL1SWycmgdTT8feGCYXPc5l8SMD+kBNb04YNSZFAbvjzdOgBmQ9DfnT8DweXA282C52J
        IfJ37nPZENgCOrcDGNDgRIRxiSCwjnmbchADTc/T4pZJLOkmkpGEH1DQdNTX/ipfYoQFNs
        WUkyaQVHfMjZl5Qmr+P4+CLCFsnk2rjS1KTXFLIS5ygpWA1tZh665g+IBq4WCtspBJqsP+
        L93zd9bxDXLUb68CZuStHpwZGRV8fSXOfsO/TmJWYpR6uXYrTWdY4stHl571fw==
From:   Michael Walle <michael@walle.cc>
To:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Xu Liang <lxu@maxlinear.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 2/5] net: phy: support indirect c45 access in get_phy_c45_ids()
Date:   Fri, 20 Jan 2023 23:40:08 +0100
Message-Id: <20230120224011.796097-3-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230120224011.796097-1-michael@walle.cc>
References: <20230120224011.796097-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some PHYs, namely the Maxlinear GPY215, whose driver is
explicitly supporting C45-over-C22 access. At least that was the
intention. In practice, it cannot work because get_phy_c45_ids()
will always issue c45 register accesses.

There is another issue at hand: the Microchip LAN8814, which is
a c22 only quad PHY, has issues with c45 accesses on the same bus
and its address decoder will find a match in the middle of another
c45 transaction. This will lead to spurious reads and writes. The
reads will corrupt the c45 in flight. The write will lead to random
writes to the LAN8814 registers. As a workaround for PHYs which
support C45-over-C22 register accesses, we can make the MDIO bus
c22-only.

For both reasons, extend the register accesses in get_phy_c45_ids()
to allow indirect C45 accesses over the C22 registers.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/phy_device.c | 32 +++++++++++++++++++++++++++-----
 1 file changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 9ba8f973f26f..9777a7fd180a 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -698,6 +698,28 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 }
 EXPORT_SYMBOL(phy_device_create);
 
+static int mdiobus_probe_mmd_read(struct mii_bus *bus, int prtad, int devad,
+				  u16 regnum)
+{
+	int ret;
+
+	if (bus->read_c45)
+		return mdiobus_c45_read(bus, prtad, devad, regnum);
+
+	mutex_lock(&bus->mdio_lock);
+
+	ret = __phy_mmd_indirect(bus, prtad, devad, regnum);
+	if (ret)
+		goto out;
+
+	ret = __mdiobus_read(bus, prtad, MII_MMD_DATA);
+
+out:
+	mutex_unlock(&bus->mdio_lock);
+
+	return ret;
+}
+
 /* phy_c45_probe_present - checks to see if a MMD is present in the package
  * @bus: the target MII bus
  * @prtad: PHY package address on the MII bus
@@ -713,7 +735,7 @@ static int phy_c45_probe_present(struct mii_bus *bus, int prtad, int devad)
 {
 	int stat2;
 
-	stat2 = mdiobus_c45_read(bus, prtad, devad, MDIO_STAT2);
+	stat2 = mdiobus_probe_mmd_read(bus, prtad, devad, MDIO_STAT2);
 	if (stat2 < 0)
 		return stat2;
 
@@ -736,12 +758,12 @@ static int get_phy_c45_devs_in_pkg(struct mii_bus *bus, int addr, int dev_addr,
 {
 	int phy_reg;
 
-	phy_reg = mdiobus_c45_read(bus, addr, dev_addr, MDIO_DEVS2);
+	phy_reg = mdiobus_probe_mmd_read(bus, addr, dev_addr, MDIO_DEVS2);
 	if (phy_reg < 0)
 		return -EIO;
 	*devices_in_package = phy_reg << 16;
 
-	phy_reg = mdiobus_c45_read(bus, addr, dev_addr, MDIO_DEVS1);
+	phy_reg = mdiobus_probe_mmd_read(bus, addr, dev_addr, MDIO_DEVS1);
 	if (phy_reg < 0)
 		return -EIO;
 	*devices_in_package |= phy_reg;
@@ -825,12 +847,12 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr,
 				continue;
 		}
 
-		phy_reg = mdiobus_c45_read(bus, addr, i, MII_PHYSID1);
+		phy_reg = mdiobus_probe_mmd_read(bus, addr, i, MII_PHYSID1);
 		if (phy_reg < 0)
 			return -EIO;
 		c45_ids->device_ids[i] = phy_reg << 16;
 
-		phy_reg = mdiobus_c45_read(bus, addr, i, MII_PHYSID2);
+		phy_reg = mdiobus_probe_mmd_read(bus, addr, i, MII_PHYSID2);
 		if (phy_reg < 0)
 			return -EIO;
 		c45_ids->device_ids[i] |= phy_reg;
-- 
2.30.2


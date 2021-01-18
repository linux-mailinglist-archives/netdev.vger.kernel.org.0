Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C72F62FA89B
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 19:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436825AbhARSVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 13:21:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390836AbhARPHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 10:07:46 -0500
Received: from albert.telenet-ops.be (albert.telenet-ops.be [IPv6:2a02:1800:110:4::f00:1a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13BDBC061575
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 07:07:03 -0800 (PST)
Received: from ramsan.of.borg ([84.195.186.194])
        by albert.telenet-ops.be with bizsmtp
        id JF6y2400a4C55Sk06F6yM1; Mon, 18 Jan 2021 16:07:02 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1l1W7O-004cpZ-6t; Mon, 18 Jan 2021 16:06:58 +0100
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1l1W7N-003LEz-KG; Mon, 18 Jan 2021 16:06:57 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH net v2 1/2] mdio-bitbang: Export mdiobb_{read,write}()
Date:   Mon, 18 Jan 2021 16:06:55 +0100
Message-Id: <20210118150656.796584-2-geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210118150656.796584-1-geert+renesas@glider.be>
References: <20210118150656.796584-1-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Export mdiobb_read() and mdiobb_write(), so Ethernet controller drivers
can call them from their MDIO read/write wrappers.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
v2:
  - New.
---
 drivers/net/mdio/mdio-bitbang.c | 6 ++++--
 include/linux/mdio-bitbang.h    | 3 +++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/mdio/mdio-bitbang.c b/drivers/net/mdio/mdio-bitbang.c
index 5136275c8e7399fb..d3915f83185430e9 100644
--- a/drivers/net/mdio/mdio-bitbang.c
+++ b/drivers/net/mdio/mdio-bitbang.c
@@ -149,7 +149,7 @@ static int mdiobb_cmd_addr(struct mdiobb_ctrl *ctrl, int phy, u32 addr)
 	return dev_addr;
 }
 
-static int mdiobb_read(struct mii_bus *bus, int phy, int reg)
+int mdiobb_read(struct mii_bus *bus, int phy, int reg)
 {
 	struct mdiobb_ctrl *ctrl = bus->priv;
 	int ret, i;
@@ -180,8 +180,9 @@ static int mdiobb_read(struct mii_bus *bus, int phy, int reg)
 	mdiobb_get_bit(ctrl);
 	return ret;
 }
+EXPORT_SYMBOL(mdiobb_read);
 
-static int mdiobb_write(struct mii_bus *bus, int phy, int reg, u16 val)
+int mdiobb_write(struct mii_bus *bus, int phy, int reg, u16 val)
 {
 	struct mdiobb_ctrl *ctrl = bus->priv;
 
@@ -201,6 +202,7 @@ static int mdiobb_write(struct mii_bus *bus, int phy, int reg, u16 val)
 	mdiobb_get_bit(ctrl);
 	return 0;
 }
+EXPORT_SYMBOL(mdiobb_write);
 
 struct mii_bus *alloc_mdio_bitbang(struct mdiobb_ctrl *ctrl)
 {
diff --git a/include/linux/mdio-bitbang.h b/include/linux/mdio-bitbang.h
index 5d71e8a8500f5ed1..aca4dc037b70b728 100644
--- a/include/linux/mdio-bitbang.h
+++ b/include/linux/mdio-bitbang.h
@@ -35,6 +35,9 @@ struct mdiobb_ctrl {
 	const struct mdiobb_ops *ops;
 };
 
+int mdiobb_read(struct mii_bus *bus, int phy, int reg);
+int mdiobb_write(struct mii_bus *bus, int phy, int reg, u16 val);
+
 /* The returned bus is not yet registered with the phy layer. */
 struct mii_bus *alloc_mdio_bitbang(struct mdiobb_ctrl *ctrl);
 
-- 
2.25.1


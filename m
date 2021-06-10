Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96BBF3A32DA
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 20:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbhFJSRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 14:17:48 -0400
Received: from mail-ed1-f51.google.com ([209.85.208.51]:39445 "EHLO
        mail-ed1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbhFJSRr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 14:17:47 -0400
Received: by mail-ed1-f51.google.com with SMTP id dj8so34150530edb.6
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 11:15:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T51QAb17lLcUbitgMmqu7KHHjqlv1lEOE5bu2kjwsi8=;
        b=HONRRWYojls9P7VtjWmLDz/W9KICLDnjzWHWrV81K+ZIcVEK5Zt9D24fPCoezkh+pB
         wEGFQQ61yTHzPXzF4jeXE5IVm2sl5QT2BZp3BMuPm1qXJF4HSNv/xuE4VUgweE4GMFpi
         blrWrZW44CVs4xp+R8WJR3BnCWDNPKi575YZ9lmEsibel+9bV0OBQWynWR0mt6P+gq6C
         WH02zkYqqva2u5hu450UnOw511WAxbeohet9lr/KjI1eGZLvNoVsra1cUffginoTryD1
         UahtDF/qgPa0llX2B51vlcOVh25lmgZz0Jz7FbDdhbX+ZXThwYtpWjUXaqkPtxLx5NdE
         o7zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T51QAb17lLcUbitgMmqu7KHHjqlv1lEOE5bu2kjwsi8=;
        b=NG4AXTfOVP0AfGqWjNomK/X07V3tS2vsk/D2CrjqrFv8JbuyLhpqoAViC2KvtHDGas
         o8dF9pR3mjLRjjIRPyd6ZJCRvBIuYDV58eJGylJuOq5ZzVIvcI5ubdrBcmTmbCuylf2v
         h4fCb7X+lRq0H2w0pgoUCSNIAvp4KvuZ8bIAdNjFpsvOSyQp16A9yuocxC9aLakbHybz
         MVMCCprSFwS4bvbzKj9fz2mNlbzxJmy/tVl+LZMKILbYt2e7HkUCg8x16DTGge9vo64K
         NIpqcTa85mMo+uQ0889cMLi13iWGrAhkbr3/0IIwHUNWdDU7+rvng/8OKKU6+ro2pZhz
         CQQw==
X-Gm-Message-State: AOAM531ZbT5GZCY8jLoNybyOqynccsI4yBVhcN1MLULIlg98s0IrBo52
        58fKoR4mpdsuvxMoaTiSK9ZxBWmLdM0=
X-Google-Smtp-Source: ABdhPJzbCVIEpes8mkMc6S/mAlYuHHgGX1JxfkafPxHDTz2HeUsqyI2ykQeCbIgErAQCjJT8h1VymQ==
X-Received: by 2002:aa7:cf0f:: with SMTP id a15mr741153edy.313.1623348890552;
        Thu, 10 Jun 2021 11:14:50 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id dh18sm1705660edb.92.2021.06.10.11.14.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 11:14:49 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 11/13] net: dsa: sja1105: register the PCS MDIO bus for SJA1110
Date:   Thu, 10 Jun 2021 21:14:08 +0300
Message-Id: <20210610181410.1886658-12-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210610181410.1886658-1-olteanv@gmail.com>
References: <20210610181410.1886658-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

On the SJA1110, the PCS of each SERDES-capable port is accessed through
a different memory window which is 0x100 bytes in size, denoted by
"pcs_base".

In each PCS register access window, the XPCS MMDs are accessed in an
indirect way: in pages/banks of up to 0x100 addresses each. Changing the
page/bank is done by writing to a special register at the end of the
access window.

The MDIO register map accessed indirectly through the indirect banked
method described above is similar to what SJA1105 has: upper 5 bits are
the MMD, lower 16 bits are the MDIO address within that MMD.

Since the PHY ID reported by the XPCS inside SJA1110 is also all zeroes
(like SJA1105), we need to trap those reads and return a fake PHY ID so
that the xpcs driver can apply some specific fixups for our integration.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/dsa/sja1105/sja1105.h      |  3 +
 drivers/net/dsa/sja1105/sja1105_mdio.c | 95 ++++++++++++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_spi.c  | 11 +++
 3 files changed, 109 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 67d22517a5dc..03750e9f5a4e 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -69,6 +69,7 @@ struct sja1105_regs {
 	u64 stats[__MAX_SJA1105_STATS_AREA][SJA1105_MAX_NUM_PORTS];
 	u64 mdio_100base_tx;
 	u64 mdio_100base_t1;
+	u64 pcs_base[SJA1105_MAX_NUM_PORTS];
 };
 
 struct sja1105_mdio_private {
@@ -299,6 +300,8 @@ int sja1105_mdiobus_register(struct dsa_switch *ds);
 void sja1105_mdiobus_unregister(struct dsa_switch *ds);
 int sja1105_pcs_mdio_read(struct mii_bus *bus, int phy, int reg);
 int sja1105_pcs_mdio_write(struct mii_bus *bus, int phy, int reg, u16 val);
+int sja1110_pcs_mdio_read(struct mii_bus *bus, int phy, int reg);
+int sja1110_pcs_mdio_write(struct mii_bus *bus, int phy, int reg, u16 val);
 
 /* From sja1105_devlink.c */
 int sja1105_devlink_setup(struct dsa_switch *ds);
diff --git a/drivers/net/dsa/sja1105/sja1105_mdio.c b/drivers/net/dsa/sja1105/sja1105_mdio.c
index fc0c94ba5d3b..9f894efa6604 100644
--- a/drivers/net/dsa/sja1105/sja1105_mdio.c
+++ b/drivers/net/dsa/sja1105/sja1105_mdio.c
@@ -5,6 +5,8 @@
 #include <linux/of_mdio.h>
 #include "sja1105.h"
 
+#define SJA1110_PCS_BANK_REG		SJA1110_SPI_ADDR(0x3fc)
+
 int sja1105_pcs_mdio_read(struct mii_bus *bus, int phy, int reg)
 {
 	struct sja1105_mdio_private *mdio_priv = bus->priv;
@@ -56,6 +58,99 @@ int sja1105_pcs_mdio_write(struct mii_bus *bus, int phy, int reg, u16 val)
 	return sja1105_xfer_u32(priv, SPI_WRITE, addr, &tmp, NULL);
 }
 
+int sja1110_pcs_mdio_read(struct mii_bus *bus, int phy, int reg)
+{
+	struct sja1105_mdio_private *mdio_priv = bus->priv;
+	struct sja1105_private *priv = mdio_priv->priv;
+	const struct sja1105_regs *regs = priv->info->regs;
+	int offset, bank;
+	u64 addr;
+	u32 tmp;
+	u16 mmd;
+	int rc;
+
+	if (!(reg & MII_ADDR_C45))
+		return -EINVAL;
+
+	if (regs->pcs_base[phy] == SJA1105_RSV_ADDR)
+		return -ENODEV;
+
+	mmd = (reg >> MII_DEVADDR_C45_SHIFT) & 0x1f;
+	addr = (mmd << 16) | (reg & GENMASK(15, 0));
+
+	if (mmd == MDIO_MMD_VEND2 && (reg & GENMASK(15, 0)) == MII_PHYSID1)
+		return NXP_SJA1110_XPCS_ID >> 16;
+	if (mmd == MDIO_MMD_VEND2 && (reg & GENMASK(15, 0)) == MII_PHYSID2)
+		return NXP_SJA1110_XPCS_ID & GENMASK(15, 0);
+
+	bank = addr >> 8;
+	offset = addr & GENMASK(7, 0);
+
+	/* This addressing scheme reserves register 0xff for the bank address
+	 * register, so that can never be addressed.
+	 */
+	if (WARN_ON(offset == 0xff))
+		return -ENODEV;
+
+	tmp = bank;
+
+	rc = sja1105_xfer_u32(priv, SPI_WRITE,
+			      regs->pcs_base[phy] + SJA1110_PCS_BANK_REG,
+			      &tmp, NULL);
+	if (rc < 0)
+		return rc;
+
+	rc = sja1105_xfer_u32(priv, SPI_READ, regs->pcs_base[phy] + offset,
+			      &tmp, NULL);
+	if (rc < 0)
+		return rc;
+
+	return tmp & 0xffff;
+}
+
+int sja1110_pcs_mdio_write(struct mii_bus *bus, int phy, int reg, u16 val)
+{
+	struct sja1105_mdio_private *mdio_priv = bus->priv;
+	struct sja1105_private *priv = mdio_priv->priv;
+	const struct sja1105_regs *regs = priv->info->regs;
+	int offset, bank;
+	u64 addr;
+	u32 tmp;
+	u16 mmd;
+	int rc;
+
+	if (!(reg & MII_ADDR_C45))
+		return -EINVAL;
+
+	if (regs->pcs_base[phy] == SJA1105_RSV_ADDR)
+		return -ENODEV;
+
+	mmd = (reg >> MII_DEVADDR_C45_SHIFT) & 0x1f;
+	addr = (mmd << 16) | (reg & GENMASK(15, 0));
+
+	bank = addr >> 8;
+	offset = addr & GENMASK(7, 0);
+
+	/* This addressing scheme reserves register 0xff for the bank address
+	 * register, so that can never be addressed.
+	 */
+	if (WARN_ON(offset == 0xff))
+		return -ENODEV;
+
+	tmp = bank;
+
+	rc = sja1105_xfer_u32(priv, SPI_WRITE,
+			      regs->pcs_base[phy] + SJA1110_PCS_BANK_REG,
+			      &tmp, NULL);
+	if (rc < 0)
+		return rc;
+
+	tmp = val;
+
+	return sja1105_xfer_u32(priv, SPI_WRITE, regs->pcs_base[phy] + offset,
+				&tmp, NULL);
+}
+
 enum sja1105_mdio_opcode {
 	SJA1105_C45_ADDR = 0,
 	SJA1105_C22 = 1,
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index 8c31f82f3dd4..e6c2cb68fcc4 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -561,6 +561,9 @@ static struct sja1105_regs sja1110_regs = {
 	.ptpsyncts = SJA1110_SPI_ADDR(0x84),
 	.mdio_100base_tx = 0x1c2400,
 	.mdio_100base_t1 = 0x1c1000,
+	.pcs_base = {SJA1105_RSV_ADDR, 0x1c1400, 0x1c1800, 0x1c1c00, 0x1c2000,
+		     SJA1105_RSV_ADDR, SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+		     SJA1105_RSV_ADDR, SJA1105_RSV_ADDR, SJA1105_RSV_ADDR},
 };
 
 const struct sja1105_info sja1105e_info = {
@@ -778,6 +781,8 @@ const struct sja1105_info sja1110a_info = {
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
 	.clocking_setup		= sja1110_clocking_setup,
+	.pcs_mdio_read		= sja1110_pcs_mdio_read,
+	.pcs_mdio_write		= sja1110_pcs_mdio_write,
 	.port_speed		= {
 		[SJA1105_SPEED_AUTO] = 0,
 		[SJA1105_SPEED_10MBPS] = 4,
@@ -823,6 +828,8 @@ const struct sja1105_info sja1110b_info = {
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
 	.clocking_setup		= sja1110_clocking_setup,
+	.pcs_mdio_read		= sja1110_pcs_mdio_read,
+	.pcs_mdio_write		= sja1110_pcs_mdio_write,
 	.port_speed		= {
 		[SJA1105_SPEED_AUTO] = 0,
 		[SJA1105_SPEED_10MBPS] = 4,
@@ -868,6 +875,8 @@ const struct sja1105_info sja1110c_info = {
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
 	.clocking_setup		= sja1110_clocking_setup,
+	.pcs_mdio_read		= sja1110_pcs_mdio_read,
+	.pcs_mdio_write		= sja1110_pcs_mdio_write,
 	.port_speed		= {
 		[SJA1105_SPEED_AUTO] = 0,
 		[SJA1105_SPEED_10MBPS] = 4,
@@ -913,6 +922,8 @@ const struct sja1105_info sja1110d_info = {
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
 	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
 	.clocking_setup		= sja1110_clocking_setup,
+	.pcs_mdio_read		= sja1110_pcs_mdio_read,
+	.pcs_mdio_write		= sja1110_pcs_mdio_write,
 	.port_speed		= {
 		[SJA1105_SPEED_AUTO] = 0,
 		[SJA1105_SPEED_10MBPS] = 4,
-- 
2.25.1


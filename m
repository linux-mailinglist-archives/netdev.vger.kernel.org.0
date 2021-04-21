Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 188B2366A65
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 14:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239498AbhDUMFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 08:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239269AbhDUMFg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 08:05:36 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A34DC06138B
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 05:05:03 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id a25so34122289ljm.11
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 05:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=ivrc+ZgIINCZVu5SYzSGx7/ZivSN1yJOovHUdxjfUKs=;
        b=KGjuHf70HVouJ9HWfSUBB86L/54Bu0cw27SefM4yGEeyYPoXREIPaq8hR8IYjffv8V
         GJBKDJzrL+xOcA0oQefXMP7/Hv6ZAavH7/ouDV3CiUZFz/aMIZk3NctIz5BPS2liQA4k
         qe+u99tYNUogq5IivZtCJy+M93Mn17qvqK1nprWnlRAgGp6MJtmic/3olH/Fw9fjxATX
         Zpc6Db2E8q35o6/UylJQPU+UDmpve9o4EPBlThgAywYkv5RCxyl/TONw3qfyoUtPwSr3
         B1vowmM1/8XrH9clBQvSan0fCIWAhARNy6ZF0oarzV+eNZySQTh0zo4gtFL6Oy0QDaBl
         Knpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=ivrc+ZgIINCZVu5SYzSGx7/ZivSN1yJOovHUdxjfUKs=;
        b=U/iJhf/Ob9dLiVE69auWAKKAmndYPtjaACdMhj8y60eH5kVKCpvtN08apDuiDDOeQs
         xE1yKT8NePPJ3iT2MQcGcNixOzAEO8HxlrixnlyHLl1Hs3l7dOBNVwOI36yUml7Oh0Gx
         w+FEMW2p1ARe7qH+RojqR+NeZohUrTMLCPfhshtMo3/70zkGLnEc27saA67ww5/dpFxQ
         Il29Q4amlGiqvn+owPZTVMol6+0OTprDx0PoWyOHi6mCNLl7S7AhaAPHsN1muWoaezyK
         JCeTTkPnZWC+B8KPNLv4EODA32L+BK9WkWZpntnutOpNKEZw7zaiSXX+aGVAgIRmwsJr
         hFfw==
X-Gm-Message-State: AOAM533Hr63nEPfpxw0vxA7O1wU67JCryDdpkvkN6sBAe6YPci4MBVqx
        SkLAz0lBWIlkyUcFChcqYmTnrA==
X-Google-Smtp-Source: ABdhPJyyhiU91MgLoDy2jg9dMoNIuZo0EN1VGDNBercJXdQMoMiyp8Sr/LKNGUnhgTL75QLrhFcD3w==
X-Received: by 2002:a2e:165d:: with SMTP id 29mr16825392ljw.359.1619006701705;
        Wed, 21 Apr 2021 05:05:01 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id r71sm193430lff.12.2021.04.21.05.05.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 05:05:01 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH net-next 3/3] net: dsa: mv88e6xxx: Export cross-chip PVT as devlink region
Date:   Wed, 21 Apr 2021 14:04:54 +0200
Message-Id: <20210421120454.1541240-4-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210421120454.1541240-1-tobias@waldekranz.com>
References: <20210421120454.1541240-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Export the raw PVT data in a devlink region so that it can be
inspected from userspace and compared to the current bridge
configuration.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/dsa/mv88e6xxx/chip.h    |  3 ++
 drivers/net/dsa/mv88e6xxx/devlink.c | 56 +++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/global2.c | 17 +++++++++
 drivers/net/dsa/mv88e6xxx/global2.h |  2 ++
 4 files changed, 78 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 4f116f73a74b..675b1f3e43b7 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -23,6 +23,8 @@
 /* PVT limits for 4-bit port and 5-bit switch */
 #define MV88E6XXX_MAX_PVT_SWITCHES	32
 #define MV88E6XXX_MAX_PVT_PORTS		16
+#define MV88E6XXX_MAX_PVT_ENTRIES	\
+	(MV88E6XXX_MAX_PVT_SWITCHES * MV88E6XXX_MAX_PVT_PORTS)
 
 #define MV88E6XXX_MAX_GPIO	16
 
@@ -266,6 +268,7 @@ enum mv88e6xxx_region_id {
 	MV88E6XXX_REGION_GLOBAL2,
 	MV88E6XXX_REGION_ATU,
 	MV88E6XXX_REGION_VTU,
+	MV88E6XXX_REGION_PVT,
 
 	_MV88E6XXX_REGION_MAX,
 };
diff --git a/drivers/net/dsa/mv88e6xxx/devlink.c b/drivers/net/dsa/mv88e6xxx/devlink.c
index ada7a38d4d31..0c0f5ea6680c 100644
--- a/drivers/net/dsa/mv88e6xxx/devlink.c
+++ b/drivers/net/dsa/mv88e6xxx/devlink.c
@@ -503,6 +503,44 @@ static int mv88e6xxx_region_vtu_snapshot(struct devlink *dl,
 	return 0;
 }
 
+static int mv88e6xxx_region_pvt_snapshot(struct devlink *dl,
+					 const struct devlink_region_ops *ops,
+					 struct netlink_ext_ack *extack,
+					 u8 **data)
+{
+	struct dsa_switch *ds = dsa_devlink_to_ds(dl);
+	struct mv88e6xxx_chip *chip = ds->priv;
+	int dev, port, err;
+	u16 *pvt, *cur;
+
+	pvt = kcalloc(MV88E6XXX_MAX_PVT_ENTRIES, sizeof(*pvt), GFP_KERNEL);
+	if (!pvt)
+		return -ENOMEM;
+
+	mv88e6xxx_reg_lock(chip);
+
+	cur = pvt;
+	for (dev = 0; dev < MV88E6XXX_MAX_PVT_SWITCHES; dev++) {
+		for (port = 0; port < MV88E6XXX_MAX_PVT_PORTS; port++) {
+			err = mv88e6xxx_g2_pvt_read(chip, dev, port, cur);
+			if (err)
+				break;
+
+			cur++;
+		}
+	}
+
+	mv88e6xxx_reg_unlock(chip);
+
+	if (err) {
+		kfree(pvt);
+		return err;
+	}
+
+	*data = (u8 *)pvt;
+	return 0;
+}
+
 static int mv88e6xxx_region_port_snapshot(struct devlink_port *devlink_port,
 					  const struct devlink_port_region_ops *ops,
 					  struct netlink_ext_ack *extack,
@@ -567,6 +605,12 @@ static struct devlink_region_ops mv88e6xxx_region_vtu_ops = {
 	.destructor = kfree,
 };
 
+static struct devlink_region_ops mv88e6xxx_region_pvt_ops = {
+	.name = "pvt",
+	.snapshot = mv88e6xxx_region_pvt_snapshot,
+	.destructor = kfree,
+};
+
 static const struct devlink_port_region_ops mv88e6xxx_region_port_ops = {
 	.name = "port",
 	.snapshot = mv88e6xxx_region_port_snapshot,
@@ -576,6 +620,8 @@ static const struct devlink_port_region_ops mv88e6xxx_region_port_ops = {
 struct mv88e6xxx_region {
 	struct devlink_region_ops *ops;
 	u64 size;
+
+	bool (*cond)(struct mv88e6xxx_chip *chip);
 };
 
 static struct mv88e6xxx_region mv88e6xxx_regions[] = {
@@ -594,6 +640,11 @@ static struct mv88e6xxx_region mv88e6xxx_regions[] = {
 		.ops = &mv88e6xxx_region_vtu_ops
 	  /* calculated at runtime */
 	},
+	[MV88E6XXX_REGION_PVT] = {
+		.ops = &mv88e6xxx_region_pvt_ops,
+		.size = MV88E6XXX_MAX_PVT_ENTRIES * sizeof(u16),
+		.cond = mv88e6xxx_has_pvt,
+	},
 };
 
 static void
@@ -663,6 +714,7 @@ static int mv88e6xxx_setup_devlink_regions_ports(struct dsa_switch *ds,
 static int mv88e6xxx_setup_devlink_regions_global(struct dsa_switch *ds,
 						  struct mv88e6xxx_chip *chip)
 {
+	bool (*cond)(struct mv88e6xxx_chip *chip);
 	struct devlink_region_ops *ops;
 	struct devlink_region *region;
 	u64 size;
@@ -671,6 +723,10 @@ static int mv88e6xxx_setup_devlink_regions_global(struct dsa_switch *ds,
 	for (i = 0; i < ARRAY_SIZE(mv88e6xxx_regions); i++) {
 		ops = mv88e6xxx_regions[i].ops;
 		size = mv88e6xxx_regions[i].size;
+		cond = mv88e6xxx_regions[i].cond;
+
+		if (cond && !cond(chip))
+			continue;
 
 		switch (i) {
 		case MV88E6XXX_REGION_ATU:
diff --git a/drivers/net/dsa/mv88e6xxx/global2.c b/drivers/net/dsa/mv88e6xxx/global2.c
index da8bac8813e1..fa65ecd9cb85 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.c
+++ b/drivers/net/dsa/mv88e6xxx/global2.c
@@ -239,6 +239,23 @@ static int mv88e6xxx_g2_pvt_op(struct mv88e6xxx_chip *chip, int src_dev,
 	return mv88e6xxx_g2_pvt_op_wait(chip);
 }
 
+int mv88e6xxx_g2_pvt_read(struct mv88e6xxx_chip *chip, int src_dev,
+			  int src_port, u16 *data)
+{
+	int err;
+
+	err = mv88e6xxx_g2_pvt_op_wait(chip);
+	if (err)
+		return err;
+
+	err = mv88e6xxx_g2_pvt_op(chip, src_dev, src_port,
+				  MV88E6XXX_G2_PVT_ADDR_OP_READ);
+	if (err)
+		return err;
+
+	return mv88e6xxx_g2_read(chip, MV88E6XXX_G2_PVT_DATA, data);
+}
+
 int mv88e6xxx_g2_pvt_write(struct mv88e6xxx_chip *chip, int src_dev,
 			   int src_port, u16 data)
 {
diff --git a/drivers/net/dsa/mv88e6xxx/global2.h b/drivers/net/dsa/mv88e6xxx/global2.h
index 8f85c23ec9c7..f3e27573a386 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.h
+++ b/drivers/net/dsa/mv88e6xxx/global2.h
@@ -330,6 +330,8 @@ int mv88e6xxx_g2_get_eeprom16(struct mv88e6xxx_chip *chip,
 int mv88e6xxx_g2_set_eeprom16(struct mv88e6xxx_chip *chip,
 			      struct ethtool_eeprom *eeprom, u8 *data);
 
+int mv88e6xxx_g2_pvt_read(struct mv88e6xxx_chip *chip, int src_dev,
+			  int src_port, u16 *data);
 int mv88e6xxx_g2_pvt_write(struct mv88e6xxx_chip *chip, int src_dev,
 			   int src_port, u16 data);
 int mv88e6xxx_g2_misc_4_bit_port(struct mv88e6xxx_chip *chip);
-- 
2.25.1


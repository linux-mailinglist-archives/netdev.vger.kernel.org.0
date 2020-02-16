Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0614016052D
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 18:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgBPRyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 12:54:54 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48512 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726037AbgBPRyy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Feb 2020 12:54:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ByMIqEERIp/fJYpzlW0Jqhrk5SwyZ8hYiVsi6t4fDxA=; b=Nf+rfAA7GAiEW71O4uexznjONZ
        IN16Jbsd+eE/Gf6fl3dv+bVN32sexZ7zDr6fKucjptsH9gvnC3lPcu1HNG17AKBnQ8eBHq8Qbt8cb
        GApw91f+ekT+dN4hnuGF28oGwvNj63i3wDD2cDZKsk6VOULiEoqSqoCCYgD+jK/aIW5M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j3O7d-0008TD-TS; Sun, 16 Feb 2020 18:54:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 3/3] net: dsa: mv88e6xxx: Add 6390 family PCS registers to ethtool -d
Date:   Sun, 16 Feb 2020 18:54:15 +0100
Message-Id: <20200216175415.32505-4-andrew@lunn.ch>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200216175415.32505-1-andrew@lunn.ch>
References: <20200216175415.32505-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mv88e6390 has upto 8 sets of PCS registers, depending on how ports
9 and 10 are configured. The can be spread over 8 ports. If a port has
a PCS register set, return it along with the port registers. The
register space is sparse, so hard code a list of registers which will
be returned. It can later be extended, if needed, by append to the end
of the list.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.c   | 12 +++++++
 drivers/net/dsa/mv88e6xxx/serdes.c | 54 ++++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/serdes.h |  2 ++
 3 files changed, 68 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index cb284eb505c0..4ec09cc8dcdc 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3861,6 +3861,8 @@ static const struct mv88e6xxx_ops mv88e6190_ops = {
 	.serdes_irq_status = mv88e6390_serdes_irq_status,
 	.serdes_get_strings = mv88e6390_serdes_get_strings,
 	.serdes_get_stats = mv88e6390_serdes_get_stats,
+	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
+	.serdes_get_regs = mv88e6390_serdes_get_regs,
 	.phylink_validate = mv88e6390_phylink_validate,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.phylink_validate = mv88e6390_phylink_validate,
@@ -3915,6 +3917,8 @@ static const struct mv88e6xxx_ops mv88e6190x_ops = {
 	.serdes_irq_status = mv88e6390_serdes_irq_status,
 	.serdes_get_strings = mv88e6390_serdes_get_strings,
 	.serdes_get_stats = mv88e6390_serdes_get_stats,
+	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
+	.serdes_get_regs = mv88e6390_serdes_get_regs,
 	.phylink_validate = mv88e6390_phylink_validate,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.phylink_validate = mv88e6390x_phylink_validate,
@@ -3968,6 +3972,8 @@ static const struct mv88e6xxx_ops mv88e6191_ops = {
 	.serdes_irq_status = mv88e6390_serdes_irq_status,
 	.serdes_get_strings = mv88e6390_serdes_get_strings,
 	.serdes_get_stats = mv88e6390_serdes_get_stats,
+	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
+	.serdes_get_regs = mv88e6390_serdes_get_regs,
 	.phylink_validate = mv88e6390_phylink_validate,
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
@@ -4119,6 +4125,8 @@ static const struct mv88e6xxx_ops mv88e6290_ops = {
 	.serdes_irq_status = mv88e6390_serdes_irq_status,
 	.serdes_get_strings = mv88e6390_serdes_get_strings,
 	.serdes_get_stats = mv88e6390_serdes_get_stats,
+	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
+	.serdes_get_regs = mv88e6390_serdes_get_regs,
 	.phylink_validate = mv88e6390_phylink_validate,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6390_avb_ops,
@@ -4464,6 +4472,8 @@ static const struct mv88e6xxx_ops mv88e6390_ops = {
 	.serdes_get_sset_count = mv88e6390_serdes_get_sset_count,
 	.serdes_get_strings = mv88e6390_serdes_get_strings,
 	.serdes_get_stats = mv88e6390_serdes_get_stats,
+	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
+	.serdes_get_regs = mv88e6390_serdes_get_regs,
 	.phylink_validate = mv88e6390_phylink_validate,
 };
 
@@ -4519,6 +4529,8 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
 	.serdes_get_sset_count = mv88e6390_serdes_get_sset_count,
 	.serdes_get_strings = mv88e6390_serdes_get_strings,
 	.serdes_get_stats = mv88e6390_serdes_get_stats,
+	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
+	.serdes_get_regs = mv88e6390_serdes_get_regs,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 94704af224c8..238219787233 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -675,3 +675,57 @@ unsigned int mv88e6390_serdes_irq_mapping(struct mv88e6xxx_chip *chip, int port)
 {
 	return irq_find_mapping(chip->g2_irq.domain, port);
 }
+
+static const u16 mv88e6390_serdes_regs[] = {
+	/* SERDES common registers */
+	0xf00a, 0xf00b, 0xf00c,
+	0xf010, 0xf011, 0xf012, 0xf013,
+	0xf016, 0xf017, 0xf018,
+	0xf01b, 0xf01c, 0xf01d, 0xf01e, 0xf01f,
+	0xf020, 0xf021, 0xf022, 0xf023, 0xf024, 0xf025, 0xf026, 0xf027,
+	0xf028, 0xf029,
+	0xf030, 0xf031, 0xf032, 0xf033, 0xf034, 0xf035, 0xf036, 0xf037,
+	0xf038, 0xf039,
+	/* SGMII */
+	0x2000, 0x2001, 0x2002, 0x2003, 0x2004, 0x2005, 0x2006, 0x2007,
+	0x2008,
+	0x200f,
+	0xa000, 0xa001, 0xa002, 0xa003,
+	/* 10Gbase-X */
+	0x1000, 0x1001, 0x1002, 0x1003, 0x1004, 0x1005, 0x1006, 0x1007,
+	0x1008,
+	0x100e, 0x100f,
+	0x1018, 0x1019,
+	0x9000, 0x9001, 0x9002, 0x9003, 0x9004,
+	0x9006,
+	0x9010, 0x9011, 0x9012, 0x9013, 0x9014, 0x9015, 0x9016,
+	/* 10Gbase-R */
+	0x1020, 0x1021, 0x1022, 0x1023, 0x1024, 0x1025, 0x1026, 0x1027,
+	0x1028, 0x1029, 0x102a, 0x102b,
+};
+
+int mv88e6390_serdes_get_regs_len(struct mv88e6xxx_chip *chip, int port)
+{
+	if (mv88e6xxx_serdes_get_lane(chip, port) == 0)
+		return 0;
+
+	return ARRAY_SIZE(mv88e6390_serdes_regs) * sizeof(u16);
+}
+
+void mv88e6390_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, void *_p)
+{
+	u16 *p = _p;
+	int lane;
+	u16 reg;
+	int i;
+
+	lane = mv88e6xxx_serdes_get_lane(chip, port);
+	if (lane == 0)
+		return;
+
+	for (i = 0 ; i < ARRAY_SIZE(mv88e6390_serdes_regs); i++) {
+		mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
+				      mv88e6390_serdes_regs[i], &reg);
+		p[i] = reg;
+	}
+}
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index bb06108ca0bc..1906b3ab29c6 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -111,6 +111,8 @@ int mv88e6390_serdes_get_stats(struct mv88e6xxx_chip *chip, int port,
 
 int mv88e6352_serdes_get_regs_len(struct mv88e6xxx_chip *chip, int port);
 void mv88e6352_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, void *_p);
+int mv88e6390_serdes_get_regs_len(struct mv88e6xxx_chip *chip, int port);
+void mv88e6390_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, void *_p);
 
 /* Return the (first) SERDES lane address a port is using, 0 otherwise. */
 static inline u8 mv88e6xxx_serdes_get_lane(struct mv88e6xxx_chip *chip,
-- 
2.25.0


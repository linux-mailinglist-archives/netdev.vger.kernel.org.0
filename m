Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7103D16052E
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 18:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgBPRzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 12:55:01 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48522 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726037AbgBPRzB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Feb 2020 12:55:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=SWYXeQ7Qm+i48ny7Pb92172aLPlzHlbrU2G2NHtpqAA=; b=dtTcniji5xQZDcZAGADSfRc72f
        czXjQ3i8envUJOJQhlNk8KrdiB/IfLjZo+Gis1C9TXRi6ay69YJm1X6chIeYeZY3aF1UdnzmMw+Eq
        lHBvMtJfqzuiLd5bzloAr+lLIuKWF0uN1954aVADB8PrYKGA+gv778NwdKYisvDIBtkk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j3O7d-0008T7-Sa; Sun, 16 Feb 2020 18:54:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 2/3] net: dsa: mv88e6xxx: Add 6352 family PCS registers to ethtool -d
Date:   Sun, 16 Feb 2020 18:54:14 +0100
Message-Id: <20200216175415.32505-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200216175415.32505-1-andrew@lunn.ch>
References: <20200216175415.32505-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mv88e6352 has one PCS which can be used for 1000BaseX or
SGMII. Add the registers to the dump for the port which the PCS is
associated to.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.c   |  8 ++++++++
 drivers/net/dsa/mv88e6xxx/serdes.c | 23 +++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/serdes.h |  3 +++
 3 files changed, 34 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 316758a42a67..cb284eb505c0 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3674,6 +3674,8 @@ static const struct mv88e6xxx_ops mv88e6172_ops = {
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
 	.serdes_get_lane = mv88e6352_serdes_get_lane,
 	.serdes_power = mv88e6352_serdes_power,
+	.serdes_get_regs_len = mv88e6352_serdes_get_regs_len,
+	.serdes_get_regs = mv88e6352_serdes_get_regs,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.phylink_validate = mv88e6352_phylink_validate,
 };
@@ -3768,6 +3770,8 @@ static const struct mv88e6xxx_ops mv88e6176_ops = {
 	.serdes_irq_mapping = mv88e6352_serdes_irq_mapping,
 	.serdes_irq_enable = mv88e6352_serdes_irq_enable,
 	.serdes_irq_status = mv88e6352_serdes_irq_status,
+	.serdes_get_regs_len = mv88e6352_serdes_get_regs_len,
+	.serdes_get_regs = mv88e6352_serdes_get_regs,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.phylink_validate = mv88e6352_phylink_validate,
 };
@@ -4018,6 +4022,8 @@ static const struct mv88e6xxx_ops mv88e6240_ops = {
 	.serdes_irq_mapping = mv88e6352_serdes_irq_mapping,
 	.serdes_irq_enable = mv88e6352_serdes_irq_enable,
 	.serdes_irq_status = mv88e6352_serdes_irq_status,
+	.serdes_get_regs_len = mv88e6352_serdes_get_regs_len,
+	.serdes_get_regs = mv88e6352_serdes_get_regs,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6352_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
@@ -4398,6 +4404,8 @@ static const struct mv88e6xxx_ops mv88e6352_ops = {
 	.serdes_get_sset_count = mv88e6352_serdes_get_sset_count,
 	.serdes_get_strings = mv88e6352_serdes_get_strings,
 	.serdes_get_stats = mv88e6352_serdes_get_stats,
+	.serdes_get_regs_len = mv88e6352_serdes_get_regs_len,
+	.serdes_get_regs = mv88e6352_serdes_get_regs,
 	.phylink_validate = mv88e6352_phylink_validate,
 };
 
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 8d8b3b74aee1..94704af224c8 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -237,6 +237,29 @@ unsigned int mv88e6352_serdes_irq_mapping(struct mv88e6xxx_chip *chip, int port)
 	return irq_find_mapping(chip->g2_irq.domain, MV88E6352_SERDES_IRQ);
 }
 
+int mv88e6352_serdes_get_regs_len(struct mv88e6xxx_chip *chip, int port)
+{
+	if (!mv88e6352_port_has_serdes(chip, port))
+		return 0;
+
+	return 32 * sizeof(u16);
+}
+
+void mv88e6352_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, void *_p)
+{
+	u16 *p = _p;
+	u16 reg;
+	int i;
+
+	if (!mv88e6352_port_has_serdes(chip, port))
+		return;
+
+	for (i = 0 ; i < 32; i++) {
+		mv88e6352_serdes_read(chip, i, &reg);
+		p[i] = reg;
+	}
+}
+
 u8 mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 {
 	u8 cmode = chip->ports[port].cmode;
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index d16ef4da20b0..bb06108ca0bc 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -109,6 +109,9 @@ int mv88e6390_serdes_get_strings(struct mv88e6xxx_chip *chip,
 int mv88e6390_serdes_get_stats(struct mv88e6xxx_chip *chip, int port,
 			       uint64_t *data);
 
+int mv88e6352_serdes_get_regs_len(struct mv88e6xxx_chip *chip, int port);
+void mv88e6352_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, void *_p);
+
 /* Return the (first) SERDES lane address a port is using, 0 otherwise. */
 static inline u8 mv88e6xxx_serdes_get_lane(struct mv88e6xxx_chip *chip,
 					   int port)
-- 
2.25.0


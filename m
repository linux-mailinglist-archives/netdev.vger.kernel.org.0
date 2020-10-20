Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14F3F294118
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 19:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395162AbgJTRJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 13:09:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:47490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390093AbgJTRJV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 13:09:21 -0400
Received: from dellmb.labs.office.nic.cz (nat-1.nic.cz [217.31.205.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A3DF22258;
        Tue, 20 Oct 2020 17:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603213760;
        bh=+ZBKmohARQT1hXHMExd1KMw360nnnMEEcj2jh2oqQc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F6WPLhoDZ4B/eksSK8nVFqsrjgYrGbr+W33FlNxI6Gy1DHNAnj9LN+mQjRkzvzdAf
         Xjou9Kml53mVQgzHgaqVJVqFlXMGGI4b0a5WYUekika/qVOsfvKtHuPabCNhZQuYpc
         OwESk0Qxa093kHOKZPkw5qP6uLbFu37UH5Oe37Y4=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH russell-kings-net-queue 2/2] net: dsa: mv88e6xxx: implement .phylink_get_interfaces operation
Date:   Tue, 20 Oct 2020 19:09:12 +0200
Message-Id: <20201020170912.25959-3-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201020170912.25959-1-kabel@kernel.org>
References: <20201020170912.25959-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the .phylink_get_interfaces method for mv88e6xxx driver.

We are currently only interested in SGMII, 1000base-x and 2500base-x
modes (for the SFP code). USXGMII and 10gbase-r can be added later for
Amethyst. XAUI and RXAUI are irrelevant for SFP (but maybe not for
QSFP?).

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 57 ++++++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/chip.h |  2 ++
 2 files changed, 59 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 545c973fdab3..081222ba46dd 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -659,6 +659,50 @@ static void mv88e6xxx_validate(struct dsa_switch *ds, int port,
 	phylink_helper_basex_speed(state);
 }
 
+static void mv88e6352_phylink_get_interfaces(struct mv88e6xxx_chip *chip,
+					     int port,
+					     unsigned long *supported)
+{
+	if (mv88e6xxx_serdes_get_lane(chip, port)) {
+		/* FIXME: does code for 6352 family support changing between
+		 * SGMII and 1000base-x?
+		 */
+		__set_bit(PHY_INTERFACE_MODE_SGMII, supported);
+		__set_bit(PHY_INTERFACE_MODE_1000BASEX, supported);
+	}
+}
+
+static void mv88e6341_phylink_get_interfaces(struct mv88e6xxx_chip *chip,
+					     int port,
+					     unsigned long *supported)
+{
+	if (port == 5) {
+		__set_bit(PHY_INTERFACE_MODE_SGMII, supported);
+		__set_bit(PHY_INTERFACE_MODE_1000BASEX, supported);
+		__set_bit(PHY_INTERFACE_MODE_2500BASEX, supported);
+	}
+}
+
+static void mv88e6390_phylink_get_interfaces(struct mv88e6xxx_chip *chip,
+					     int port,
+					     unsigned long *supported)
+{
+	if (port == 9 || port == 10) {
+		__set_bit(PHY_INTERFACE_MODE_SGMII, supported);
+		__set_bit(PHY_INTERFACE_MODE_1000BASEX, supported);
+		__set_bit(PHY_INTERFACE_MODE_2500BASEX, supported);
+	}
+}
+
+static void mv88e6xxx_get_interfaces(struct dsa_switch *ds, int port,
+				     unsigned long *supported)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+
+	if (chip->info->ops->phylink_get_interfaces)
+		chip->info->ops->phylink_get_interfaces(chip, port, supported);
+}
+
 static void mv88e6xxx_mac_config(struct dsa_switch *ds, int port,
 				 unsigned int mode,
 				 const struct phylink_link_state *state)
@@ -3664,6 +3708,7 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
 	.serdes_irq_status = mv88e6390_serdes_irq_status,
 	.gpio_ops = &mv88e6352_gpio_ops,
+	.phylink_get_interfaces = mv88e6341_phylink_get_interfaces,
 	.phylink_validate = mv88e6341_phylink_validate,
 };
 
@@ -3832,6 +3877,7 @@ static const struct mv88e6xxx_ops mv88e6172_ops = {
 	.serdes_get_regs_len = mv88e6352_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6352_serdes_get_regs,
 	.gpio_ops = &mv88e6352_gpio_ops,
+	.phylink_get_interfaces = mv88e6352_phylink_get_interfaces,
 	.phylink_validate = mv88e6352_phylink_validate,
 };
 
@@ -3928,6 +3974,7 @@ static const struct mv88e6xxx_ops mv88e6176_ops = {
 	.serdes_get_regs_len = mv88e6352_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6352_serdes_get_regs,
 	.gpio_ops = &mv88e6352_gpio_ops,
+	.phylink_get_interfaces = mv88e6352_phylink_get_interfaces,
 	.phylink_validate = mv88e6352_phylink_validate,
 };
 
@@ -4022,6 +4069,7 @@ static const struct mv88e6xxx_ops mv88e6190_ops = {
 	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6390_serdes_get_regs,
 	.gpio_ops = &mv88e6352_gpio_ops,
+	.phylink_get_interfaces = mv88e6390_phylink_get_interfaces,
 	.phylink_validate = mv88e6390_phylink_validate,
 };
 
@@ -4081,6 +4129,7 @@ static const struct mv88e6xxx_ops mv88e6190x_ops = {
 	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6390_serdes_get_regs,
 	.gpio_ops = &mv88e6352_gpio_ops,
+	.phylink_get_interfaces = mv88e6390_phylink_get_interfaces,
 	.phylink_validate = mv88e6390x_phylink_validate,
 };
 
@@ -4139,6 +4188,7 @@ static const struct mv88e6xxx_ops mv88e6191_ops = {
 	.serdes_get_regs = mv88e6390_serdes_get_regs,
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
+	.phylink_get_interfaces = mv88e6390_phylink_get_interfaces,
 	.phylink_validate = mv88e6390_phylink_validate,
 };
 
@@ -4197,6 +4247,7 @@ static const struct mv88e6xxx_ops mv88e6240_ops = {
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6352_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
+	.phylink_get_interfaces = mv88e6352_phylink_get_interfaces,
 	.phylink_validate = mv88e6352_phylink_validate,
 };
 
@@ -4295,6 +4346,7 @@ static const struct mv88e6xxx_ops mv88e6290_ops = {
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
+	.phylink_get_interfaces = mv88e6390_phylink_get_interfaces,
 	.phylink_validate = mv88e6390_phylink_validate,
 };
 
@@ -4432,6 +4484,7 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
+	.phylink_get_interfaces = mv88e6341_phylink_get_interfaces,
 	.phylink_validate = mv88e6341_phylink_validate,
 };
 
@@ -4575,6 +4628,7 @@ static const struct mv88e6xxx_ops mv88e6352_ops = {
 	.serdes_get_stats = mv88e6352_serdes_get_stats,
 	.serdes_get_regs_len = mv88e6352_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6352_serdes_get_regs,
+	.phylink_get_interfaces = mv88e6352_phylink_get_interfaces,
 	.phylink_validate = mv88e6352_phylink_validate,
 };
 
@@ -4638,6 +4692,7 @@ static const struct mv88e6xxx_ops mv88e6390_ops = {
 	.serdes_get_stats = mv88e6390_serdes_get_stats,
 	.serdes_get_regs_len = mv88e6390_serdes_get_regs_len,
 	.serdes_get_regs = mv88e6390_serdes_get_regs,
+	.phylink_get_interfaces = mv88e6390_phylink_get_interfaces,
 	.phylink_validate = mv88e6390_phylink_validate,
 };
 
@@ -4700,6 +4755,7 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
+	.phylink_get_interfaces = mv88e6390_phylink_get_interfaces,
 	.phylink_validate = mv88e6390x_phylink_validate,
 };
 
@@ -5566,6 +5622,7 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.get_tag_protocol	= mv88e6xxx_get_tag_protocol,
 	.setup			= mv88e6xxx_setup,
 	.teardown		= mv88e6xxx_teardown,
+	.phylink_get_interfaces	= mv88e6xxx_get_interfaces,
 	.phylink_validate	= mv88e6xxx_validate,
 	.phylink_mac_link_state	= mv88e6xxx_serdes_pcs_get_state,
 	.phylink_mac_config	= mv88e6xxx_mac_config,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 823ae89e5fca..648c3b72174e 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -550,6 +550,8 @@ struct mv88e6xxx_ops {
 	const struct mv88e6xxx_ptp_ops *ptp_ops;
 
 	/* Phylink */
+	void (*phylink_get_interfaces)(struct mv88e6xxx_chip *chip, int port,
+				       unsigned long *supported);
 	void (*phylink_validate)(struct mv88e6xxx_chip *chip, int port,
 				 unsigned long *mask,
 				 struct phylink_link_state *state);
-- 
2.26.2


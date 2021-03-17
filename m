Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37B2E33F172
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 14:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbhCQNsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 09:48:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:42032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231391AbhCQNr1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 09:47:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AE0B64F0F;
        Wed, 17 Mar 2021 13:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615988846;
        bh=dzO4IrH3cLVkwltMaHzdb5GufUGrLNVKycxCfj2m7oA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QStXPJVz9ptR7U5+ZHMeRCtaiJtmtSWgrf6DMt3LF9I2FC5l42EhbpVQagqEiVszn
         85Xc7Xfb4SR58T/dOc2ShJHFhPPqBtOLFvmP5hZCLeooIM5CmxQea0kpLHQ92HOkFH
         VHDmtzg/if+Pgm2ObE8msfUW6PEhTOvtUV0nnuf+7ToR5mUnUMpm/QYbKT+KSeaVzr
         7SkpWOeq5meB7DzJDRMAV7Kgi+upcDbDmBzeoUThwm2maZK6ifUH5b+UOusbBvqoYD
         ZChpuuk9DzoLTqDNFZVcr1qsz0YiL4lar8zDIOkN68Zyv6zEN02GBj2TIiCI60L1dS
         DFfgfEbTZlGJA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, pavana.sharma@digi.com,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        olteanv@gmail.com, andrew@lunn.ch, ashkan.boldaji@digi.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, lkp@intel.com,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v17 4/4] net: dsa: mv88e6xxx: implement .port_set_policy for Amethyst
Date:   Wed, 17 Mar 2021 14:46:43 +0100
Message-Id: <20210317134643.24463-5-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210317134643.24463-1-kabel@kernel.org>
References: <20210317134643.24463-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 16-bit Port Policy CTL register from older chips is on 6393x changed
to Port Policy MGMT CTL, which can access more data, but indirectly and
via 8-bit registers.

The original 16-bit value is divided into first two 8-bit register in
the Port Policy MGMT CTL.

We can therefore use the previous code to compute the mask and shift,
and then
- if 0 <= shift < 8, we access register 0 in Port Policy MGMT CTL
- if 8 <= shift < 16, we access register 1 in Port Policy MGMT CTL

There are in fact other possible policy settings for Amethyst which
could be added here, but this can be done in the future.

Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Pavana Sharma <pavana.sharma@digi.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c |   1 +
 drivers/net/dsa/mv88e6xxx/port.c | 122 ++++++++++++++++++++++++-------
 drivers/net/dsa/mv88e6xxx/port.h |   3 +
 3 files changed, 99 insertions(+), 27 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 0ffeb73a4058..f0a9423af85d 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -4627,6 +4627,7 @@ static const struct mv88e6xxx_ops mv88e6393x_ops = {
 	.port_set_speed_duplex = mv88e6393x_port_set_speed_duplex,
 	.port_max_speed_mode = mv88e6393x_port_max_speed_mode,
 	.port_tag_remap = mv88e6390_port_tag_remap,
+	.port_set_policy = mv88e6393x_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
 	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 154541d807df..6a9c45c2127a 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -1325,6 +1325,27 @@ int mv88e6xxx_port_disable_pri_override(struct mv88e6xxx_chip *chip, int port)
 
 /* Offset 0x0E: Policy & MGMT Control Register for FAMILY 6191X 6193X 6393X */
 
+static int mv88e6393x_port_policy_read(struct mv88e6xxx_chip *chip, int port,
+				       u16 pointer, u8 *data)
+{
+	u16 reg;
+	int err;
+
+	err = mv88e6xxx_port_write(chip, port, MV88E6393X_PORT_POLICY_MGMT_CTL,
+				   pointer);
+	if (err)
+		return err;
+
+	err = mv88e6xxx_port_read(chip, port, MV88E6393X_PORT_POLICY_MGMT_CTL,
+				  &reg);
+	if (err)
+		return err;
+
+	*data = reg;
+
+	return 0;
+}
+
 static int mv88e6393x_port_policy_write(struct mv88e6xxx_chip *chip, int port,
 					u16 pointer, u8 data)
 {
@@ -1526,46 +1547,43 @@ int mv88e6390_port_tag_remap(struct mv88e6xxx_chip *chip, int port)
 
 /* Offset 0x0E: Policy Control Register */
 
-int mv88e6352_port_set_policy(struct mv88e6xxx_chip *chip, int port,
-			      enum mv88e6xxx_policy_mapping mapping,
-			      enum mv88e6xxx_policy_action action)
+static int
+mv88e6xxx_port_policy_mapping_get_pos(enum mv88e6xxx_policy_mapping mapping,
+				      enum mv88e6xxx_policy_action action,
+				      u16 *mask, u16 *val, int *shift)
 {
-	u16 reg, mask, val;
-	int shift;
-	int err;
-
 	switch (mapping) {
 	case MV88E6XXX_POLICY_MAPPING_DA:
-		shift = __bf_shf(MV88E6XXX_PORT_POLICY_CTL_DA_MASK);
-		mask = MV88E6XXX_PORT_POLICY_CTL_DA_MASK;
+		*shift = __bf_shf(MV88E6XXX_PORT_POLICY_CTL_DA_MASK);
+		*mask = MV88E6XXX_PORT_POLICY_CTL_DA_MASK;
 		break;
 	case MV88E6XXX_POLICY_MAPPING_SA:
-		shift = __bf_shf(MV88E6XXX_PORT_POLICY_CTL_SA_MASK);
-		mask = MV88E6XXX_PORT_POLICY_CTL_SA_MASK;
+		*shift = __bf_shf(MV88E6XXX_PORT_POLICY_CTL_SA_MASK);
+		*mask = MV88E6XXX_PORT_POLICY_CTL_SA_MASK;
 		break;
 	case MV88E6XXX_POLICY_MAPPING_VTU:
-		shift = __bf_shf(MV88E6XXX_PORT_POLICY_CTL_VTU_MASK);
-		mask = MV88E6XXX_PORT_POLICY_CTL_VTU_MASK;
+		*shift = __bf_shf(MV88E6XXX_PORT_POLICY_CTL_VTU_MASK);
+		*mask = MV88E6XXX_PORT_POLICY_CTL_VTU_MASK;
 		break;
 	case MV88E6XXX_POLICY_MAPPING_ETYPE:
-		shift = __bf_shf(MV88E6XXX_PORT_POLICY_CTL_ETYPE_MASK);
-		mask = MV88E6XXX_PORT_POLICY_CTL_ETYPE_MASK;
+		*shift = __bf_shf(MV88E6XXX_PORT_POLICY_CTL_ETYPE_MASK);
+		*mask = MV88E6XXX_PORT_POLICY_CTL_ETYPE_MASK;
 		break;
 	case MV88E6XXX_POLICY_MAPPING_PPPOE:
-		shift = __bf_shf(MV88E6XXX_PORT_POLICY_CTL_PPPOE_MASK);
-		mask = MV88E6XXX_PORT_POLICY_CTL_PPPOE_MASK;
+		*shift = __bf_shf(MV88E6XXX_PORT_POLICY_CTL_PPPOE_MASK);
+		*mask = MV88E6XXX_PORT_POLICY_CTL_PPPOE_MASK;
 		break;
 	case MV88E6XXX_POLICY_MAPPING_VBAS:
-		shift = __bf_shf(MV88E6XXX_PORT_POLICY_CTL_VBAS_MASK);
-		mask = MV88E6XXX_PORT_POLICY_CTL_VBAS_MASK;
+		*shift = __bf_shf(MV88E6XXX_PORT_POLICY_CTL_VBAS_MASK);
+		*mask = MV88E6XXX_PORT_POLICY_CTL_VBAS_MASK;
 		break;
 	case MV88E6XXX_POLICY_MAPPING_OPT82:
-		shift = __bf_shf(MV88E6XXX_PORT_POLICY_CTL_OPT82_MASK);
-		mask = MV88E6XXX_PORT_POLICY_CTL_OPT82_MASK;
+		*shift = __bf_shf(MV88E6XXX_PORT_POLICY_CTL_OPT82_MASK);
+		*mask = MV88E6XXX_PORT_POLICY_CTL_OPT82_MASK;
 		break;
 	case MV88E6XXX_POLICY_MAPPING_UDP:
-		shift = __bf_shf(MV88E6XXX_PORT_POLICY_CTL_UDP_MASK);
-		mask = MV88E6XXX_PORT_POLICY_CTL_UDP_MASK;
+		*shift = __bf_shf(MV88E6XXX_PORT_POLICY_CTL_UDP_MASK);
+		*mask = MV88E6XXX_PORT_POLICY_CTL_UDP_MASK;
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -1573,21 +1591,37 @@ int mv88e6352_port_set_policy(struct mv88e6xxx_chip *chip, int port,
 
 	switch (action) {
 	case MV88E6XXX_POLICY_ACTION_NORMAL:
-		val = MV88E6XXX_PORT_POLICY_CTL_NORMAL;
+		*val = MV88E6XXX_PORT_POLICY_CTL_NORMAL;
 		break;
 	case MV88E6XXX_POLICY_ACTION_MIRROR:
-		val = MV88E6XXX_PORT_POLICY_CTL_MIRROR;
+		*val = MV88E6XXX_PORT_POLICY_CTL_MIRROR;
 		break;
 	case MV88E6XXX_POLICY_ACTION_TRAP:
-		val = MV88E6XXX_PORT_POLICY_CTL_TRAP;
+		*val = MV88E6XXX_PORT_POLICY_CTL_TRAP;
 		break;
 	case MV88E6XXX_POLICY_ACTION_DISCARD:
-		val = MV88E6XXX_PORT_POLICY_CTL_DISCARD;
+		*val = MV88E6XXX_PORT_POLICY_CTL_DISCARD;
 		break;
 	default:
 		return -EOPNOTSUPP;
 	}
 
+	return 0;
+}
+
+int mv88e6352_port_set_policy(struct mv88e6xxx_chip *chip, int port,
+			      enum mv88e6xxx_policy_mapping mapping,
+			      enum mv88e6xxx_policy_action action)
+{
+	u16 reg, mask, val;
+	int shift;
+	int err;
+
+	err = mv88e6xxx_port_policy_mapping_get_pos(mapping, action, &mask,
+						    &val, &shift);
+	if (err)
+		return err;
+
 	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_POLICY_CTL, &reg);
 	if (err)
 		return err;
@@ -1597,3 +1631,37 @@ int mv88e6352_port_set_policy(struct mv88e6xxx_chip *chip, int port,
 
 	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_POLICY_CTL, reg);
 }
+
+int mv88e6393x_port_set_policy(struct mv88e6xxx_chip *chip, int port,
+			       enum mv88e6xxx_policy_mapping mapping,
+			       enum mv88e6xxx_policy_action action)
+{
+	u16 mask, val;
+	int shift;
+	int err;
+	u16 ptr;
+	u8 reg;
+
+	err = mv88e6xxx_port_policy_mapping_get_pos(mapping, action, &mask,
+						    &val, &shift);
+	if (err)
+		return err;
+
+	/* The 16-bit Port Policy CTL register from older chips is on 6393x
+	 * changed to Port Policy MGMT CTL, which can access more data, but
+	 * indirectly. The original 16-bit value is divided into two 8-bit
+	 * registers.
+	 */
+	ptr = shift / 8;
+	shift %= 8;
+	mask >>= ptr * 8;
+
+	err = mv88e6393x_port_policy_read(chip, port, ptr, &reg);
+	if (err)
+		return err;
+
+	reg &= ~mask;
+	reg |= (val << shift) & mask;
+
+	return mv88e6393x_port_policy_write(chip, port, ptr, reg);
+}
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index 948ba577a159..921d54969dad 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -386,6 +386,9 @@ int mv88e6352_port_set_mcast_flood(struct mv88e6xxx_chip *chip, int port,
 int mv88e6352_port_set_policy(struct mv88e6xxx_chip *chip, int port,
 			      enum mv88e6xxx_policy_mapping mapping,
 			      enum mv88e6xxx_policy_action action);
+int mv88e6393x_port_set_policy(struct mv88e6xxx_chip *chip, int port,
+			       enum mv88e6xxx_policy_mapping mapping,
+			       enum mv88e6xxx_policy_action action);
 int mv88e6351_port_set_ether_type(struct mv88e6xxx_chip *chip, int port,
 				  u16 etype);
 int mv88e6393x_set_egress_port(struct mv88e6xxx_chip *chip,
-- 
2.26.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F31C32F59F6
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 05:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727153AbhANEfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 23:35:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:34458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726532AbhANEfM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 23:35:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73BB82396F;
        Thu, 14 Jan 2021 04:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610598846;
        bh=q7yDg6OkAlNT7PmqjD9gfIVCmgEugOc6iq7rrj+Oh0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hzgazICanTBbQOHxkKhSQZzIh2BDd30kCX/kEid9XktOd7NhIESyAIQR1LU7D85+/
         QkYRfs6P9A1XzvUm2wU7/lXgpz9VREVrLYRN3WoAzx3FpcndjPCSNIVz2lUO2fyf+B
         M7xQsRstv2edl9BPp86X+i+ZgvgvN2uOgrmLOyUi62doVNcdfRvWslGHtsJ7QS3E09
         7x6zF+8F38oy6n8WBMnNubOIVndtnbztu8G+HO/lNYl525pR2BgOoJvTQZgtMx3H3B
         WDIlgDCnkHpbHcUm31t/OocM0gHKL7Q1TMyf8/08n+yjgMG9/ZHk9BfNTFiuVJQkwZ
         9BmPo446QEhDg==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     pavana.sharma@digi.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org, lkp@intel.com,
        davem@davemloft.net, ashkan.boldaji@digi.com, andrew@lunn.ch,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        olteanv@gmail.com,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v16 6/6] net: dsa: mv88e6xxx: implement .port_set_policy for Amethyst
Date:   Thu, 14 Jan 2021 05:33:31 +0100
Message-Id: <20210114043331.4572-7-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210114043331.4572-1-kabel@kernel.org>
References: <20210114043331.4572-1-kabel@kernel.org>
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
index d50b02f76ddb..02a40b5b2200 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -4571,6 +4571,7 @@ static const struct mv88e6xxx_ops mv88e6393x_ops = {
 	.port_set_speed_duplex = mv88e6393x_port_set_speed_duplex,
 	.port_max_speed_mode = mv88e6393x_port_max_speed_mode,
 	.port_tag_remap = mv88e6390_port_tag_remap,
+	.port_set_policy = mv88e6393x_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_egress_floods = mv88e6352_port_set_egress_floods,
 	.port_set_ether_type = mv88e6393x_port_set_ether_type,
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 2ff38357c481..732e43569f80 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -1304,6 +1304,27 @@ int mv88e6xxx_port_disable_pri_override(struct mv88e6xxx_chip *chip, int port)
 
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
@@ -1505,46 +1526,43 @@ int mv88e6390_port_tag_remap(struct mv88e6xxx_chip *chip, int port)
 
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
@@ -1552,21 +1570,37 @@ int mv88e6352_port_set_policy(struct mv88e6xxx_chip *chip, int port,
 
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
@@ -1576,3 +1610,37 @@ int mv88e6352_port_set_policy(struct mv88e6xxx_chip *chip, int port,
 
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
+	 * indirectly. The original 16-bit value is divided into 2 8-bit
+	 * register.
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
index 90830a6dfe11..ec2fdcce4624 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -380,6 +380,9 @@ int mv88e6352_port_set_egress_floods(struct mv88e6xxx_chip *chip, int port,
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA6F2F0ABF
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 02:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727147AbhAKBW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 20:22:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:54514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726049AbhAKBW4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Jan 2021 20:22:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A316722473;
        Mon, 11 Jan 2021 01:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610328135;
        bh=wExltz0JovchRSmB98XUlSjRiO4Sm2cIFfJ2Gq6D+Mk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pmOysSoU3cO/XZtk6NIDO2Itw1xUko5/7AvDWZGp+ipyOAOacDrKg+hptkuVrlCwm
         GrjINl3Z3jhAr08v+ue6pZZUu+vT6yHVJ5WbozfCM/yjfoxpDmsGMQTxomu6Iwq+yj
         N4uhpqty2rmXjUV3E1N2eVjV4fK7l+NFa26mvN2RqJV6pjhE8mChel8uoI08g6kzeL
         wo/dEf9s1UXCrTpaii9MGk+cxDVI2uTclepntj7Iz8AkouldfTF8upeAHCYHvXURa2
         vS5jUUY7unwVs3g6eeDMKSnDLR093U1N/QtzWyvkFXvs3qJYRRgSZGNa5c4JJcbp4u
         i4UtFY5q7U+DQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     pavana.sharma@digi.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org, lkp@intel.com,
        davem@davemloft.net, ashkan.boldaji@digi.com, andrew@lunn.ch,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        olteanv@gmail.com,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v14 4/6] net: dsa: mv88e6xxx: wrap .set_egress_port method
Date:   Mon, 11 Jan 2021 02:21:54 +0100
Message-Id: <20210111012156.27799-5-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210111012156.27799-1-kabel@kernel.org>
References: <20210111012156.27799-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two implementations of the .set_egress_port method, and both
of them, if successful, set chip->*gress_dest_port variable.

To avoid code repetition, wrap this method into
mv88e6xxx_set_egress_port.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c    | 48 ++++++++++++++++++-----------
 drivers/net/dsa/mv88e6xxx/global1.c | 19 ++----------
 2 files changed, 32 insertions(+), 35 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 9bddd70449c6..62bef0759077 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2521,6 +2521,26 @@ static int mv88e6xxx_serdes_power(struct mv88e6xxx_chip *chip, int port,
 	return err;
 }
 
+static int mv88e6xxx_set_egress_port(struct mv88e6xxx_chip *chip,
+				     enum mv88e6xxx_egress_direction direction,
+				     int port)
+{
+	int err = -EOPNOTSUPP;
+
+	if (chip->info->ops->set_egress_port) {
+		err = chip->info->ops->set_egress_port(chip, direction, port);
+		if (err)
+			return err;
+
+		if (direction == MV88E6XXX_EGRESS_DIR_INGRESS)
+			chip->ingress_dest_port = port;
+		else
+			chip->egress_dest_port = port;
+	}
+
+	return err;
+}
+
 static int mv88e6xxx_setup_upstream_port(struct mv88e6xxx_chip *chip, int port)
 {
 	struct dsa_switch *ds = chip->ds;
@@ -2543,19 +2563,17 @@ static int mv88e6xxx_setup_upstream_port(struct mv88e6xxx_chip *chip, int port)
 				return err;
 		}
 
-		if (chip->info->ops->set_egress_port) {
-			err = chip->info->ops->set_egress_port(chip,
+		err = mv88e6xxx_set_egress_port(chip,
 						MV88E6XXX_EGRESS_DIR_INGRESS,
 						upstream_port);
-			if (err)
-				return err;
+		if (err && err != -EOPNOTSUPP)
+			return err;
 
-			err = chip->info->ops->set_egress_port(chip,
+		err = mv88e6xxx_set_egress_port(chip,
 						MV88E6XXX_EGRESS_DIR_EGRESS,
 						upstream_port);
-			if (err)
-				return err;
-		}
+		if (err && err != -EOPNOTSUPP)
+			return err;
 	}
 
 	return 0;
@@ -5297,9 +5315,6 @@ static int mv88e6xxx_port_mirror_add(struct dsa_switch *ds, int port,
 	int i;
 	int err;
 
-	if (!chip->info->ops->set_egress_port)
-		return -EOPNOTSUPP;
-
 	mutex_lock(&chip->reg_lock);
 	if ((ingress ? chip->ingress_dest_port : chip->egress_dest_port) !=
 	    mirror->to_local_port) {
@@ -5314,9 +5329,8 @@ static int mv88e6xxx_port_mirror_add(struct dsa_switch *ds, int port,
 			goto out;
 		}
 
-		err = chip->info->ops->set_egress_port(chip,
-						       direction,
-						       mirror->to_local_port);
+		err = mv88e6xxx_set_egress_port(chip, direction,
+						mirror->to_local_port);
 		if (err)
 			goto out;
 	}
@@ -5349,10 +5363,8 @@ static void mv88e6xxx_port_mirror_del(struct dsa_switch *ds, int port,
 
 	/* Reset egress port when no other mirror is active */
 	if (!other_mirrors) {
-		if (chip->info->ops->set_egress_port(chip,
-						     direction,
-						     dsa_upstream_port(ds,
-								       port)))
+		if (mv88e6xxx_set_egress_port(chip, direction,
+					      dsa_upstream_port(ds, port)))
 			dev_err(ds->dev, "failed to set egress port\n");
 	}
 
diff --git a/drivers/net/dsa/mv88e6xxx/global1.c b/drivers/net/dsa/mv88e6xxx/global1.c
index 33d443a37efc..815b0f681d69 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.c
+++ b/drivers/net/dsa/mv88e6xxx/global1.c
@@ -315,7 +315,6 @@ int mv88e6095_g1_set_egress_port(struct mv88e6xxx_chip *chip,
 				 enum mv88e6xxx_egress_direction direction,
 				 int port)
 {
-	int *dest_port_chip;
 	u16 reg;
 	int err;
 
@@ -325,13 +324,11 @@ int mv88e6095_g1_set_egress_port(struct mv88e6xxx_chip *chip,
 
 	switch (direction) {
 	case MV88E6XXX_EGRESS_DIR_INGRESS:
-		dest_port_chip = &chip->ingress_dest_port;
 		reg &= ~MV88E6185_G1_MONITOR_CTL_INGRESS_DEST_MASK;
 		reg |= port <<
 		       __bf_shf(MV88E6185_G1_MONITOR_CTL_INGRESS_DEST_MASK);
 		break;
 	case MV88E6XXX_EGRESS_DIR_EGRESS:
-		dest_port_chip = &chip->egress_dest_port;
 		reg &= ~MV88E6185_G1_MONITOR_CTL_EGRESS_DEST_MASK;
 		reg |= port <<
 		       __bf_shf(MV88E6185_G1_MONITOR_CTL_EGRESS_DEST_MASK);
@@ -340,11 +337,7 @@ int mv88e6095_g1_set_egress_port(struct mv88e6xxx_chip *chip,
 		return -EINVAL;
 	}
 
-	err = mv88e6xxx_g1_write(chip, MV88E6185_G1_MONITOR_CTL, reg);
-	if (!err)
-		*dest_port_chip = port;
-
-	return err;
+	return mv88e6xxx_g1_write(chip, MV88E6185_G1_MONITOR_CTL, reg);
 }
 
 /* Older generations also call this the ARP destination. It has been
@@ -380,28 +373,20 @@ int mv88e6390_g1_set_egress_port(struct mv88e6xxx_chip *chip,
 				 enum mv88e6xxx_egress_direction direction,
 				 int port)
 {
-	int *dest_port_chip;
 	u16 ptr;
-	int err;
 
 	switch (direction) {
 	case MV88E6XXX_EGRESS_DIR_INGRESS:
-		dest_port_chip = &chip->ingress_dest_port;
 		ptr = MV88E6390_G1_MONITOR_MGMT_CTL_PTR_INGRESS_DEST;
 		break;
 	case MV88E6XXX_EGRESS_DIR_EGRESS:
-		dest_port_chip = &chip->egress_dest_port;
 		ptr = MV88E6390_G1_MONITOR_MGMT_CTL_PTR_EGRESS_DEST;
 		break;
 	default:
 		return -EINVAL;
 	}
 
-	err = mv88e6390_g1_monitor_write(chip, ptr, port);
-	if (!err)
-		*dest_port_chip = port;
-
-	return err;
+	return mv88e6390_g1_monitor_write(chip, ptr, port);
 }
 
 int mv88e6390_g1_set_cpu_port(struct mv88e6xxx_chip *chip, int port)
-- 
2.26.2


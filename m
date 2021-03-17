Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0229233F16F
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 14:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbhCQNr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 09:47:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:41964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231397AbhCQNrV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 09:47:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0BA964F69;
        Wed, 17 Mar 2021 13:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615988840;
        bh=Ewq6nBFYXpTGJhVduh/14kyXLZT+LC9/3SfUWagogrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hVCKMxpfLX0kzYLdIJTRT+hGh012jWYG6j2yj5qfAm1MgFIwYHoYatEmjTaOGbuU+
         zYnO3dgLY1LTar4AHXI1lsgju3oA/vwwQXlykRE1zJvs4JD5iZ6CYxDJyeF5zRNxTK
         zNBSgYorZzFu5a1VuopGEcY3Pv8CGFeqTVeHtJpkG8ku9O8YWoWpRDve1wHSKcMT4l
         bdSD5QiCrY7M8BBCwkBZ/yu0HT6/Ey9XLSlRbR2nGxo1ebgRtdZQDmwLdx+gwpbRGA
         soqykJnulkKcSfCN3L3jIBTgc9SQ0/NWIHEx05pSbZeTe/WlKHahGLGBdGbMSZteyD
         Q7zq9hQZnIZ3A==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org, pavana.sharma@digi.com,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        olteanv@gmail.com, andrew@lunn.ch, ashkan.boldaji@digi.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, lkp@intel.com,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next v17 2/4] net: dsa: mv88e6xxx: wrap .set_egress_port method
Date:   Wed, 17 Mar 2021 14:46:41 +0100
Message-Id: <20210317134643.24463-3-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210317134643.24463-1-kabel@kernel.org>
References: <20210317134643.24463-1-kabel@kernel.org>
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
Reviewed-by: Pavana Sharma <pavana.sharma@digi.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c    | 49 ++++++++++++++++++-----------
 drivers/net/dsa/mv88e6xxx/global1.c | 19 ++---------
 2 files changed, 33 insertions(+), 35 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index cd0c8d1ed905..fc9d3875f099 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2550,6 +2550,27 @@ static int mv88e6xxx_serdes_power(struct mv88e6xxx_chip *chip, int port,
 	return err;
 }
 
+static int mv88e6xxx_set_egress_port(struct mv88e6xxx_chip *chip,
+				     enum mv88e6xxx_egress_direction direction,
+				     int port)
+{
+	int err;
+
+	if (!chip->info->ops->set_egress_port)
+		return -EOPNOTSUPP;
+
+	err = chip->info->ops->set_egress_port(chip, direction, port);
+	if (err)
+		return err;
+
+	if (direction == MV88E6XXX_EGRESS_DIR_INGRESS)
+		chip->ingress_dest_port = port;
+	else
+		chip->egress_dest_port = port;
+
+	return 0;
+}
+
 static int mv88e6xxx_setup_upstream_port(struct mv88e6xxx_chip *chip, int port)
 {
 	struct dsa_switch *ds = chip->ds;
@@ -2572,19 +2593,17 @@ static int mv88e6xxx_setup_upstream_port(struct mv88e6xxx_chip *chip, int port)
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
@@ -5338,9 +5357,6 @@ static int mv88e6xxx_port_mirror_add(struct dsa_switch *ds, int port,
 	int i;
 	int err;
 
-	if (!chip->info->ops->set_egress_port)
-		return -EOPNOTSUPP;
-
 	mutex_lock(&chip->reg_lock);
 	if ((ingress ? chip->ingress_dest_port : chip->egress_dest_port) !=
 	    mirror->to_local_port) {
@@ -5355,9 +5371,8 @@ static int mv88e6xxx_port_mirror_add(struct dsa_switch *ds, int port,
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
@@ -5390,10 +5405,8 @@ static void mv88e6xxx_port_mirror_del(struct dsa_switch *ds, int port,
 
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


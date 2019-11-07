Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF3EF3A42
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 22:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727532AbfKGVOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 16:14:03 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51006 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726912AbfKGVOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 16:14:03 -0500
Received: by mail-wm1-f65.google.com with SMTP id l17so3252101wmh.0
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 13:14:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w2R/Ij1WIF1z5MGvmE97agxDhITvPX3JHZSdodTte3I=;
        b=iR5oQ4b77a/2Rhx+voCt82r+QG8Mn9odQ81C0YJWc4RE7EleYgiUlbft+YL9Rw/A6l
         a40poIh76+3LzYQSc+THHChaMYH5ar49BJfo9AylrwIXu/jvIR4MwCjAptmBf18iFx9d
         Y2GSmFQ2fy4adMPYd5hcDnvIXMahUEjXqggRz8vX5GUU8E2mgVXPmWCB1/q76LCjXEcx
         BF6vc++o3/swTdIrqY5+xiN5nETJUyp4TcrFbAhoz19x5qbyXFfn5gzAm0NDYZEXu6C2
         LnlTRJpIAasp207fm+R43UcN9PS/pFaDOwusIFAEmSF7Tcsx6Itw7sTom5NJu+jO3oNM
         BuhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w2R/Ij1WIF1z5MGvmE97agxDhITvPX3JHZSdodTte3I=;
        b=GweM+i77QrFReGFxSF/hcx1gVo9nP4iGfFT2LUkq0JzudZjyNxdl3Yfzc3WLv10LvT
         PuRSCKlvkjdIfxJEqrHXz67ZgejuzYAguXs5DNI1HAUiU3Wm9bLUbRcTAzVbmytJyxYo
         piPQM3MNU4Ken5p5vH+59O2nt9+wMTyz6b9fZv+9ECHxbfy7nEUASAksZO72jV/VU6RM
         akHcpqrEvZQRGRuUQLCG2qzpZOH8O7F4ph+LQ3oV9PfhgzgpsA61qPZwVLU60TjgQkCW
         sykVH0OQjTXFIfGBj19T2XQ5EWVJHtewrC4cJEQCpjMT/KHDR+8zCZjZv3ERUjh9jT96
         1AQg==
X-Gm-Message-State: APjAAAUDboxAAfOb0EB85sECxFyhfg1QmG7vkS/wAcfrxIXwj3VVpL0t
        KUemLC9SSSo1l7n1AlFKPFru7Te07fw=
X-Google-Smtp-Source: APXvYqxknXUZlW5yuRmCoiEKKPdGefnn8SoD43uSkapuHjyNjBpi9MRH7a6RBPU55mUqSMvop3YWsg==
X-Received: by 2002:a1c:4606:: with SMTP id t6mr4765189wma.73.1573161240360;
        Thu, 07 Nov 2019 13:14:00 -0800 (PST)
Received: from i5wan.lan (214-247-144-85.ftth.glasoperator.nl. [85.144.247.214])
        by smtp.gmail.com with ESMTPSA id l4sm3188596wml.33.2019.11.07.13.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 13:13:59 -0800 (PST)
From:   Iwan R Timmer <irtimmer@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, Iwan R Timmer <irtimmer@gmail.com>
Subject: [PATCH net-next v3 2/2] net: dsa: mv88e6xxx: Add support for port mirroring
Date:   Thu,  7 Nov 2019 22:11:14 +0100
Message-Id: <20191107211114.106310-3-irtimmer@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191107211114.106310-1-irtimmer@gmail.com>
References: <20191107211114.106310-1-irtimmer@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for configuring port mirroring through the cls_matchall
classifier. We do a full ingress and/or egress capture towards a
capture port. It allows setting a different capture port for ingress
and egress traffic.

It keeps track of the mirrored ports and the destination ports to
prevent changes to the capture port while other ports are being
mirrored.

Signed-off-by: Iwan R Timmer <irtimmer@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c    | 76 +++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/chip.h    |  6 +++
 drivers/net/dsa/mv88e6xxx/global1.c | 18 +++++--
 drivers/net/dsa/mv88e6xxx/port.c    | 37 ++++++++++++++
 drivers/net/dsa/mv88e6xxx/port.h    |  3 ++
 5 files changed, 136 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index dfca0ec35145..ce4503b387a8 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5250,6 +5250,80 @@ static int mv88e6xxx_port_mdb_del(struct dsa_switch *ds, int port,
 	return err;
 }
 
+static int mv88e6xxx_port_mirror_add(struct dsa_switch *ds, int port,
+				     struct dsa_mall_mirror_tc_entry *mirror,
+				     bool ingress)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	enum mv88e6xxx_egress_direction direction = ingress ?
+						MV88E6XXX_EGRESS_DIR_INGRESS :
+						MV88E6XXX_EGRESS_DIR_EGRESS;
+	bool other_mirrors = false;
+	int i;
+	int err;
+
+	if (!chip->info->ops->set_egress_port)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&chip->reg_lock);
+	if ((ingress ? chip->ingress_dest_port : chip->egress_dest_port) !=
+	    mirror->to_local_port) {
+		for (i = 0; i < mv88e6xxx_num_ports(chip); i++)
+			other_mirrors |= ingress ?
+					 chip->ports[i].mirror_ingress :
+					 chip->ports[i].mirror_egress;
+
+		/* Can't change egress port when other mirror is active */
+		if (other_mirrors) {
+			err = -EBUSY;
+			goto out;
+		}
+
+		err = chip->info->ops->set_egress_port(chip,
+						       direction,
+						       mirror->to_local_port);
+		if (err)
+			goto out;
+	}
+
+	err = mv88e6xxx_port_set_mirror(chip, port, direction, true);
+out:
+	mutex_unlock(&chip->reg_lock);
+
+	return err;
+}
+
+static void mv88e6xxx_port_mirror_del(struct dsa_switch *ds, int port,
+				      struct dsa_mall_mirror_tc_entry *mirror)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
+	enum mv88e6xxx_egress_direction direction = mirror->ingress ?
+						MV88E6XXX_EGRESS_DIR_INGRESS :
+						MV88E6XXX_EGRESS_DIR_EGRESS;
+	bool other_mirrors = false;
+	int i;
+
+	mutex_lock(&chip->reg_lock);
+	if (mv88e6xxx_port_set_mirror(chip, port, direction, false))
+		dev_err(ds->dev, "p%d: failed to disable mirroring\n", port);
+
+	for (i = 0; i < mv88e6xxx_num_ports(chip); i++)
+		other_mirrors |= mirror->ingress ?
+				 chip->ports[i].mirror_ingress :
+				 chip->ports[i].mirror_egress;
+
+	/* Reset egress port when no other mirror is active */
+	if (!other_mirrors) {
+		if (chip->info->ops->set_egress_port(chip,
+						     direction,
+						     dsa_upstream_port(ds,
+								       port)));
+			dev_err(ds->dev, "failed to set egress port\n");
+	}
+
+	mutex_unlock(&chip->reg_lock);
+}
+
 static int mv88e6xxx_port_egress_floods(struct dsa_switch *ds, int port,
 					 bool unicast, bool multicast)
 {
@@ -5305,6 +5379,8 @@ static const struct dsa_switch_ops mv88e6xxx_switch_ops = {
 	.port_mdb_prepare       = mv88e6xxx_port_mdb_prepare,
 	.port_mdb_add           = mv88e6xxx_port_mdb_add,
 	.port_mdb_del           = mv88e6xxx_port_mdb_del,
+	.port_mirror_add	= mv88e6xxx_port_mirror_add,
+	.port_mirror_del	= mv88e6xxx_port_mirror_del,
 	.crosschip_bridge_join	= mv88e6xxx_crosschip_bridge_join,
 	.crosschip_bridge_leave	= mv88e6xxx_crosschip_bridge_leave,
 	.port_hwtstamp_set	= mv88e6xxx_port_hwtstamp_set,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 9fc93b1a9f74..8a8e38bfb161 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -233,6 +233,8 @@ struct mv88e6xxx_port {
 	u64 vtu_member_violation;
 	u64 vtu_miss_violation;
 	u8 cmode;
+	bool mirror_ingress;
+	bool mirror_egress;
 	unsigned int serdes_irq;
 };
 
@@ -316,6 +318,10 @@ struct mv88e6xxx_chip {
 	u16 evcap_config;
 	u16 enable_count;
 
+	/* Current ingress and egress monitor ports */
+	int egress_dest_port;
+	int ingress_dest_port;
+
 	/* Per-port timestamping resources. */
 	struct mv88e6xxx_port_hwtstamp port_hwtstamp[DSA_MAX_PORTS];
 
diff --git a/drivers/net/dsa/mv88e6xxx/global1.c b/drivers/net/dsa/mv88e6xxx/global1.c
index 36b88db22946..120a65d3e3ef 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.c
+++ b/drivers/net/dsa/mv88e6xxx/global1.c
@@ -267,6 +267,7 @@ int mv88e6095_g1_set_egress_port(struct mv88e6xxx_chip *chip,
 				 enum mv88e6xxx_egress_direction direction,
 				 int port)
 {
+	int *dest_port_chip;
 	u16 reg;
 	int err;
 
@@ -276,11 +277,13 @@ int mv88e6095_g1_set_egress_port(struct mv88e6xxx_chip *chip,
 
 	switch (direction) {
 	case MV88E6XXX_EGRESS_DIR_INGRESS:
+		dest_port_chip = &chip->ingress_dest_port;
 		reg &= MV88E6185_G1_MONITOR_CTL_INGRESS_DEST_MASK;
 		reg |= port <<
 		       __bf_shf(MV88E6185_G1_MONITOR_CTL_INGRESS_DEST_MASK);
 		break;
 	case MV88E6XXX_EGRESS_DIR_EGRESS:
+		dest_port_chip = &chip->egress_dest_port;
 		reg &= MV88E6185_G1_MONITOR_CTL_EGRESS_DEST_MASK;
 		reg |= port <<
 		       __bf_shf(MV88E6185_G1_MONITOR_CTL_EGRESS_DEST_MASK);
@@ -289,7 +292,11 @@ int mv88e6095_g1_set_egress_port(struct mv88e6xxx_chip *chip,
 		return -EINVAL;
 	}
 
-	return mv88e6xxx_g1_write(chip, MV88E6185_G1_MONITOR_CTL, reg);
+	err = mv88e6xxx_g1_write(chip, MV88E6185_G1_MONITOR_CTL, reg);
+	if (!err)
+		*dest_port_chip = port;
+
+	return err;
 }
 
 /* Older generations also call this the ARP destination. It has been
@@ -325,14 +332,17 @@ int mv88e6390_g1_set_egress_port(struct mv88e6xxx_chip *chip,
 				 enum mv88e6xxx_egress_direction direction,
 				 int port)
 {
+	int *dest_port_chip;
 	u16 ptr;
 	int err;
 
 	switch (direction) {
 	case MV88E6XXX_EGRESS_DIR_INGRESS:
+		dest_port_chip = &chip->ingress_dest_port;
 		ptr = MV88E6390_G1_MONITOR_MGMT_CTL_PTR_INGRESS_DEST;
 		break;
 	case MV88E6XXX_EGRESS_DIR_EGRESS:
+		dest_port_chip = &chip->egress_dest_port;
 		ptr = MV88E6390_G1_MONITOR_MGMT_CTL_PTR_EGRESS_DEST;
 		break;
 	default:
@@ -340,10 +350,10 @@ int mv88e6390_g1_set_egress_port(struct mv88e6xxx_chip *chip,
 	}
 
 	err = mv88e6390_g1_monitor_write(chip, ptr, port);
-	if (err)
-		return err;
+	if (!err)
+		*dest_port_chip = port;
 
-	return 0;
+	return err;
 }
 
 int mv88e6390_g1_set_cpu_port(struct mv88e6xxx_chip *chip, int port)
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 15ef81654b67..7fe256c5739d 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -1181,6 +1181,43 @@ int mv88e6095_port_set_upstream_port(struct mv88e6xxx_chip *chip, int port,
 	return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL2, reg);
 }
 
+int mv88e6xxx_port_set_mirror(struct mv88e6xxx_chip *chip, int port,
+			      enum mv88e6xxx_egress_direction direction,
+			      bool mirror)
+{
+	bool *mirror_port;
+	u16 reg;
+	u16 bit;
+	int err;
+
+	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_CTL2, &reg);
+	if (err)
+		return err;
+
+	switch (direction) {
+	case MV88E6XXX_EGRESS_DIR_INGRESS:
+		bit = MV88E6XXX_PORT_CTL2_INGRESS_MONITOR;
+		mirror_port = &chip->ports[port].mirror_ingress;
+		break;
+	case MV88E6XXX_EGRESS_DIR_EGRESS:
+		bit = MV88E6XXX_PORT_CTL2_EGRESS_MONITOR;
+		mirror_port = &chip->ports[port].mirror_egress;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	reg &= ~bit;
+	if (mirror)
+		reg |= bit;
+
+	err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL2, reg);
+	if (!err)
+		*mirror_port = mirror;
+
+	return err;
+}
+
 int mv88e6xxx_port_set_8021q_mode(struct mv88e6xxx_chip *chip, int port,
 				  u16 mode)
 {
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index 03a480cd71b9..0ec4327c2b42 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -368,6 +368,9 @@ int mv88e6352_port_link_state(struct mv88e6xxx_chip *chip, int port,
 int mv88e6xxx_port_set_map_da(struct mv88e6xxx_chip *chip, int port);
 int mv88e6095_port_set_upstream_port(struct mv88e6xxx_chip *chip, int port,
 				     int upstream_port);
+int mv88e6xxx_port_set_mirror(struct mv88e6xxx_chip *chip, int port,
+			      enum mv88e6xxx_egress_direction direction,
+			      bool mirror);
 
 int mv88e6xxx_port_disable_learn_limit(struct mv88e6xxx_chip *chip, int port);
 int mv88e6xxx_port_disable_pri_override(struct mv88e6xxx_chip *chip, int port);
-- 
2.23.0


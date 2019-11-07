Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11C0AF3A40
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 22:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727480AbfKGVOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 16:14:02 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35124 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727359AbfKGVOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 16:14:01 -0500
Received: by mail-wm1-f66.google.com with SMTP id 8so4099189wmo.0
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 13:14:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BUPUykQyXL4zsqBYGUjYgMD0BVZtx5k9rSLMCrFAdqk=;
        b=UF1hBhmfzi9jt7q5VUbWKgum1ovWXZbSqtV6hPeqgM5nhyzW8C9b5yychEB7/s/Mm1
         Gbq1gI0Zyy96O3G5cIULrEggSKUAmUXnZMtWvzWToZFni22NrfRtUwPuGMc8PeGR5Ly5
         G9ykxILbV0RYgKefrTX4H1hwm/SEM3slb05rlNqx6pEVxHMgCsKNjfGBkVo/PeU51tD1
         uBnWkWXeG6Gqgow8/MNGICQIpkXScFtShGnbFZb1nK3PG5BsIpLHgePs7Rf4U4boT70x
         gAqjC0wZdrKrFP9gMfYBdmbaL2Cab7LdEoDXjIqsV0lVUGuWZBKWYevW1pDq21uBTEiS
         St/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BUPUykQyXL4zsqBYGUjYgMD0BVZtx5k9rSLMCrFAdqk=;
        b=n7NfpAsRbOs2ZVc2FJpaJGRSnYEX0sE0Z/8pqzB0aAxoRyWv4T7kZU5oQGsWw7N5RE
         Qt5K3gNCE6jX9goyhOhTvXvyXKszMWEhBaeEHCYfrhoR8FNWit8iY9IeZZTX20O6q2Uw
         GFfNvCL8HIwlDOzMhqNXeDFW+GDXchbojB5QXzzJFIIKjd/j7wahWgZl25bgXYA+8ZKp
         oyvMKcG3Kysk7lkKjp/Z4k1zx51lrb8Dj/Kkpc6+BKbH8gikjpD0kCDGeFzOcF7PCXdm
         pcUULfWTKKQwYDLJF3XxAIhxyHPhIb6OIMFgO/R/uSNCBp8Mz3w4Ga21YYjCmx7hgnEb
         GZsQ==
X-Gm-Message-State: APjAAAVCegY3N8udYgxYxV6UXQbX8dVhduHfcKY2Lh8FabIsMWGlQ2WB
        PJjVF/0zdE49b7coHCoyYB0r17tpkFs=
X-Google-Smtp-Source: APXvYqwjBP3OZdcDbucdxc76kVX4Kg+nbYV0Pg3sPkHiGnKASYNeulfoxsmMXaheZCFhftIObS63gQ==
X-Received: by 2002:a1c:a78b:: with SMTP id q133mr4925226wme.115.1573161239514;
        Thu, 07 Nov 2019 13:13:59 -0800 (PST)
Received: from i5wan.lan (214-247-144-85.ftth.glasoperator.nl. [85.144.247.214])
        by smtp.gmail.com with ESMTPSA id l4sm3188596wml.33.2019.11.07.13.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 13:13:58 -0800 (PST)
From:   Iwan R Timmer <irtimmer@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, Iwan R Timmer <irtimmer@gmail.com>
Subject: [PATCH net-next v3 1/2] net: dsa: mv88e6xxx: Split monitor port configuration
Date:   Thu,  7 Nov 2019 22:11:13 +0100
Message-Id: <20191107211114.106310-2-irtimmer@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191107211114.106310-1-irtimmer@gmail.com>
References: <20191107211114.106310-1-irtimmer@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Separate the configuration of the egress and ingress monitor port.
This allows the port mirror functionality to do ingress and egress
port mirroring to separate ports.

Signed-off-by: Iwan R Timmer <irtimmer@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c    |  9 ++++++-
 drivers/net/dsa/mv88e6xxx/chip.h    |  9 ++++++-
 drivers/net/dsa/mv88e6xxx/global1.c | 42 ++++++++++++++++++++---------
 drivers/net/dsa/mv88e6xxx/global1.h |  8 ++++--
 4 files changed, 52 insertions(+), 16 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 0dbe6c8b9dc0..dfca0ec35145 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2390,7 +2390,14 @@ static int mv88e6xxx_setup_upstream_port(struct mv88e6xxx_chip *chip, int port)
 
 		if (chip->info->ops->set_egress_port) {
 			err = chip->info->ops->set_egress_port(chip,
-							       upstream_port);
+						MV88E6XXX_EGRESS_DIR_INGRESS,
+						upstream_port);
+			if (err)
+				return err;
+
+			err = chip->info->ops->set_egress_port(chip,
+						MV88E6XXX_EGRESS_DIR_EGRESS,
+						upstream_port);
 			if (err)
 				return err;
 		}
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 65ce09bdcbcf..9fc93b1a9f74 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -33,6 +33,11 @@ enum mv88e6xxx_egress_mode {
 	MV88E6XXX_EGRESS_MODE_ETHERTYPE,
 };
 
+enum mv88e6xxx_egress_direction {
+        MV88E6XXX_EGRESS_DIR_INGRESS,
+        MV88E6XXX_EGRESS_DIR_EGRESS,
+};
+
 enum mv88e6xxx_frame_mode {
 	MV88E6XXX_FRAME_MODE_NORMAL,
 	MV88E6XXX_FRAME_MODE_DSA,
@@ -465,7 +470,9 @@ struct mv88e6xxx_ops {
 	int (*stats_get_stats)(struct mv88e6xxx_chip *chip,  int port,
 			       uint64_t *data);
 	int (*set_cpu_port)(struct mv88e6xxx_chip *chip, int port);
-	int (*set_egress_port)(struct mv88e6xxx_chip *chip, int port);
+	int (*set_egress_port)(struct mv88e6xxx_chip *chip,
+			       enum mv88e6xxx_egress_direction direction,
+			       int port);
 
 #define MV88E6XXX_CASCADE_PORT_NONE		0xe
 #define MV88E6XXX_CASCADE_PORT_MULTIPLE		0xf
diff --git a/drivers/net/dsa/mv88e6xxx/global1.c b/drivers/net/dsa/mv88e6xxx/global1.c
index 25ec4c0ac589..36b88db22946 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.c
+++ b/drivers/net/dsa/mv88e6xxx/global1.c
@@ -263,7 +263,9 @@ int mv88e6250_g1_ieee_pri_map(struct mv88e6xxx_chip *chip)
 /* Offset 0x1a: Monitor Control */
 /* Offset 0x1a: Monitor & MGMT Control on some devices */
 
-int mv88e6095_g1_set_egress_port(struct mv88e6xxx_chip *chip, int port)
+int mv88e6095_g1_set_egress_port(struct mv88e6xxx_chip *chip,
+				 enum mv88e6xxx_egress_direction direction,
+				 int port)
 {
 	u16 reg;
 	int err;
@@ -272,11 +274,20 @@ int mv88e6095_g1_set_egress_port(struct mv88e6xxx_chip *chip, int port)
 	if (err)
 		return err;
 
-	reg &= ~(MV88E6185_G1_MONITOR_CTL_INGRESS_DEST_MASK |
-		 MV88E6185_G1_MONITOR_CTL_EGRESS_DEST_MASK);
-
-	reg |= port << __bf_shf(MV88E6185_G1_MONITOR_CTL_INGRESS_DEST_MASK) |
-		port << __bf_shf(MV88E6185_G1_MONITOR_CTL_EGRESS_DEST_MASK);
+	switch (direction) {
+	case MV88E6XXX_EGRESS_DIR_INGRESS:
+		reg &= MV88E6185_G1_MONITOR_CTL_INGRESS_DEST_MASK;
+		reg |= port <<
+		       __bf_shf(MV88E6185_G1_MONITOR_CTL_INGRESS_DEST_MASK);
+		break;
+	case MV88E6XXX_EGRESS_DIR_EGRESS:
+		reg &= MV88E6185_G1_MONITOR_CTL_EGRESS_DEST_MASK;
+		reg |= port <<
+		       __bf_shf(MV88E6185_G1_MONITOR_CTL_EGRESS_DEST_MASK);
+		break;
+	default:
+		return -EINVAL;
+	}
 
 	return mv88e6xxx_g1_write(chip, MV88E6185_G1_MONITOR_CTL, reg);
 }
@@ -310,17 +321,24 @@ static int mv88e6390_g1_monitor_write(struct mv88e6xxx_chip *chip,
 	return mv88e6xxx_g1_write(chip, MV88E6390_G1_MONITOR_MGMT_CTL, reg);
 }
 
-int mv88e6390_g1_set_egress_port(struct mv88e6xxx_chip *chip, int port)
+int mv88e6390_g1_set_egress_port(struct mv88e6xxx_chip *chip,
+				 enum mv88e6xxx_egress_direction direction,
+				 int port)
 {
 	u16 ptr;
 	int err;
 
-	ptr = MV88E6390_G1_MONITOR_MGMT_CTL_PTR_INGRESS_DEST;
-	err = mv88e6390_g1_monitor_write(chip, ptr, port);
-	if (err)
-		return err;
+	switch (direction) {
+	case MV88E6XXX_EGRESS_DIR_INGRESS:
+		ptr = MV88E6390_G1_MONITOR_MGMT_CTL_PTR_INGRESS_DEST;
+		break;
+	case MV88E6XXX_EGRESS_DIR_EGRESS:
+		ptr = MV88E6390_G1_MONITOR_MGMT_CTL_PTR_EGRESS_DEST;
+		break;
+	default:
+		return -EINVAL;
+	}
 
-	ptr = MV88E6390_G1_MONITOR_MGMT_CTL_PTR_EGRESS_DEST;
 	err = mv88e6390_g1_monitor_write(chip, ptr, port);
 	if (err)
 		return err;
diff --git a/drivers/net/dsa/mv88e6xxx/global1.h b/drivers/net/dsa/mv88e6xxx/global1.h
index 342172275841..bc5a6b2bb1e4 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.h
+++ b/drivers/net/dsa/mv88e6xxx/global1.h
@@ -288,8 +288,12 @@ int mv88e6095_g1_stats_set_histogram(struct mv88e6xxx_chip *chip);
 int mv88e6390_g1_stats_set_histogram(struct mv88e6xxx_chip *chip);
 void mv88e6xxx_g1_stats_read(struct mv88e6xxx_chip *chip, int stat, u32 *val);
 int mv88e6xxx_g1_stats_clear(struct mv88e6xxx_chip *chip);
-int mv88e6095_g1_set_egress_port(struct mv88e6xxx_chip *chip, int port);
-int mv88e6390_g1_set_egress_port(struct mv88e6xxx_chip *chip, int port);
+int mv88e6095_g1_set_egress_port(struct mv88e6xxx_chip *chip,
+				 enum mv88e6xxx_egress_direction direction,
+				 int port);
+int mv88e6390_g1_set_egress_port(struct mv88e6xxx_chip *chip,
+				 enum mv88e6xxx_egress_direction direction,
+				 int port);
 int mv88e6095_g1_set_cpu_port(struct mv88e6xxx_chip *chip, int port);
 int mv88e6390_g1_set_cpu_port(struct mv88e6xxx_chip *chip, int port);
 int mv88e6390_g1_mgmt_rsvd2cpu(struct mv88e6xxx_chip *chip);
-- 
2.23.0


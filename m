Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57DB52AB263
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 09:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729442AbgKII3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 03:29:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbgKII3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 03:29:37 -0500
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28607C0613CF
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 00:29:37 -0800 (PST)
Received: by mail-lj1-x244.google.com with SMTP id y16so3177951ljh.0
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 00:29:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:organization;
        bh=sPIAc1RRVZPpO8XEXk9CCuh2pQWpP7LKFtI1bUFq4is=;
        b=su0+LshJGN2GeJWt7+wnclwCeOFN2hOPF+WeHni3ztR4+nQTL7NMwLeEXLzE1iOi1e
         0VPr1ALN34tYSRb6I/OFyOVDzCW8K+cQISJ06GV15f/6F44n6mTO5Whcrr5v2XKuFgrp
         Dx98p28FiG2hlYfj9OQuoOmJFzpzR66Mg+4S/d/+WSgoGTXxd/B3L7J1RSZKTaeA23WH
         IUgJaAp7lKplQ1QcnEZcrgUJaivynQUo7o8QE0cxDm7CdYx1j8JoxmweXIRSc3/iIbiT
         cCCyREQNDUBYqHKuJrV0aHeiI1cQeuXnA/Y3QaMr3fdMUdAYSVE4mNP957E6mH8FtW1D
         /7QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:organization;
        bh=sPIAc1RRVZPpO8XEXk9CCuh2pQWpP7LKFtI1bUFq4is=;
        b=l+vA+IF1gLU+PYiehl8GBUmjh+C1Xg7tPh2r7pM/KsXCiV4hPzi+d1L8ieV8I5wK35
         4a1fZSvZVaXG3VG+fFyTSUba4xP7aiMoJSF0WugZ+aLBxCuVYP3L//ZOASv13yLKue6+
         rWEL0jTEzCH4+PLlYbWvoYaDXashOTmOX2gg7XE4Mpbi387ig92gJ4GO5wIULAtQ39tV
         C12NJ4iCxYJKhtuGsXiFPOQPsBYLo0txFzfzzg6HKYKffUQfT7Cgy51f9bkEwRlwFp5s
         5Wg0ht3XSvoZnoMha1Zr20cSERC9PqWvzJIl5eMPhDRp/ilTGit8XTKqpdPc4hftyW53
         3oEQ==
X-Gm-Message-State: AOAM532ykdfbjmiEF588Fq1LLjAoPL/CbXESmLVe2ioqmcU9VtBnFD88
        UCWy1Zbzlc1O7zFqBjUZpKEjzw==
X-Google-Smtp-Source: ABdhPJwf/pToT9zGDX9z5sCvktldREbeHk2Us2SZ7FOmrDUQzCuD7rAvvrhdM6vFSFJbn2WIfE/93g==
X-Received: by 2002:a2e:9b96:: with SMTP id z22mr5443052lji.163.1604910575580;
        Mon, 09 Nov 2020 00:29:35 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id k21sm2092306ljb.43.2020.11.09.00.29.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 00:29:34 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, netdev@vger.kernel.org
Subject: [PATCH net-next] net: dsa: mv88e6xxx: Export VTU as devlink region
Date:   Mon,  9 Nov 2020 09:29:27 +0100
Message-Id: <20201109082927.8684-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
Organization: Westermo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Export the raw VTU data and related registers in a devlink region so
that it can be inspected from userspace and compared to the current
bridge configuration.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/dsa/mv88e6xxx/chip.h        |   1 +
 drivers/net/dsa/mv88e6xxx/devlink.c     | 105 +++++++++++++++++++++++-
 drivers/net/dsa/mv88e6xxx/global1.h     |   2 +
 drivers/net/dsa/mv88e6xxx/global1_vtu.c |   4 +-
 4 files changed, 109 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 81c244fc0419..fb5b262285ff 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -245,6 +245,7 @@ enum mv88e6xxx_region_id {
 	MV88E6XXX_REGION_GLOBAL1 = 0,
 	MV88E6XXX_REGION_GLOBAL2,
 	MV88E6XXX_REGION_ATU,
+	MV88E6XXX_REGION_VTU,
 
 	_MV88E6XXX_REGION_MAX,
 };
diff --git a/drivers/net/dsa/mv88e6xxx/devlink.c b/drivers/net/dsa/mv88e6xxx/devlink.c
index 10cd1bfd81a0..0fba160a4d36 100644
--- a/drivers/net/dsa/mv88e6xxx/devlink.c
+++ b/drivers/net/dsa/mv88e6xxx/devlink.c
@@ -415,6 +415,92 @@ static int mv88e6xxx_region_atu_snapshot(struct devlink *dl,
 	return err;
 }
 
+/**
+ * struct mv88e6xxx_devlink_vtu_entry - Devlink VTU entry
+ * @fid:   Global1/2:   FID and VLAN policy.
+ * @sid:   Global1/3:   SID, unknown filters and learning.
+ * @op:    Global1/5:   FID (old chipsets).
+ * @vid:   Global1/6:   VID, valid, and page.
+ * @data:  Global1/7-9: Membership data and priority override.
+ * @resvd: Reserved. Also happens to align the size to 16B.
+ *
+ * The VTU entry format varies between chipset generations, the
+ * descriptions above represent the superset of all possible
+ * information, not all fields are valid on all devices. Since this is
+ * a low-level debug interface, copy all data verbatim and defer
+ * parsing to the consumer.
+ */
+struct mv88e6xxx_devlink_vtu_entry {
+	u16 fid;
+	u16 sid;
+	u16 op;
+	u16 vid;
+	u16 data[3];
+	u16 resvd;
+};
+
+static int mv88e6xxx_region_vtu_snapshot(struct devlink *dl,
+					 const struct devlink_region_ops *ops,
+					 struct netlink_ext_ack *extack,
+					 u8 **data)
+{
+	struct mv88e6xxx_devlink_vtu_entry *table, *entry;
+	struct dsa_switch *ds = dsa_devlink_to_ds(dl);
+	struct mv88e6xxx_chip *chip = ds->priv;
+	struct mv88e6xxx_vtu_entry vlan;
+	int err;
+
+	table = kcalloc(chip->info->max_vid + 1,
+			sizeof(struct mv88e6xxx_devlink_vtu_entry),
+			GFP_KERNEL);
+	if (!table)
+		return -ENOMEM;
+
+	entry = table;
+	vlan.vid = chip->info->max_vid;
+	vlan.valid = false;
+
+	mv88e6xxx_reg_lock(chip);
+
+	do {
+		err = mv88e6xxx_g1_vtu_getnext(chip, &vlan);
+		if (err)
+			break;
+
+		if (!vlan.valid)
+			break;
+
+		err = err ? : mv88e6xxx_g1_read(chip, MV88E6352_G1_VTU_FID,
+						&entry->fid);
+		err = err ? : mv88e6xxx_g1_read(chip, MV88E6352_G1_VTU_SID,
+						&entry->sid);
+		err = err ? : mv88e6xxx_g1_read(chip, MV88E6XXX_G1_VTU_OP,
+						&entry->op);
+		err = err ? : mv88e6xxx_g1_read(chip, MV88E6XXX_G1_VTU_VID,
+						&entry->vid);
+		err = err ? : mv88e6xxx_g1_read(chip, MV88E6XXX_G1_VTU_DATA1,
+						&entry->data[0]);
+		err = err ? : mv88e6xxx_g1_read(chip, MV88E6XXX_G1_VTU_DATA2,
+						&entry->data[1]);
+		err = err ? : mv88e6xxx_g1_read(chip, MV88E6XXX_G1_VTU_DATA3,
+						&entry->data[2]);
+		if (err)
+			break;
+
+		entry++;
+	} while (vlan.vid < chip->info->max_vid);
+
+	mv88e6xxx_reg_unlock(chip);
+
+	if (err) {
+		kfree(table);
+		return err;
+	}
+
+	*data = (u8 *)table;
+	return 0;
+}
+
 static int mv88e6xxx_region_port_snapshot(struct devlink_port *devlink_port,
 					  const struct devlink_port_region_ops *ops,
 					  struct netlink_ext_ack *extack,
@@ -473,6 +559,12 @@ static struct devlink_region_ops mv88e6xxx_region_atu_ops = {
 	.destructor = kfree,
 };
 
+static struct devlink_region_ops mv88e6xxx_region_vtu_ops = {
+	.name = "vtu",
+	.snapshot = mv88e6xxx_region_vtu_snapshot,
+	.destructor = kfree,
+};
+
 static const struct devlink_port_region_ops mv88e6xxx_region_port_ops = {
 	.name = "port",
 	.snapshot = mv88e6xxx_region_port_snapshot,
@@ -496,6 +588,10 @@ static struct mv88e6xxx_region mv88e6xxx_regions[] = {
 		.ops = &mv88e6xxx_region_atu_ops
 	  /* calculated at runtime */
 	},
+	[MV88E6XXX_REGION_VTU] = {
+		.ops = &mv88e6xxx_region_vtu_ops
+	  /* calculated at runtime */
+	},
 };
 
 static void
@@ -574,9 +670,16 @@ static int mv88e6xxx_setup_devlink_regions_global(struct dsa_switch *ds,
 		ops = mv88e6xxx_regions[i].ops;
 		size = mv88e6xxx_regions[i].size;
 
-		if (i == MV88E6XXX_REGION_ATU)
+		switch (i) {
+		case MV88E6XXX_REGION_ATU:
 			size = mv88e6xxx_num_databases(chip) *
 				sizeof(struct mv88e6xxx_devlink_atu_entry);
+			break;
+		case MV88E6XXX_REGION_VTU:
+			size = chip->info->max_vid *
+				sizeof(struct mv88e6xxx_devlink_vtu_entry);
+			break;
+		}
 
 		region = dsa_devlink_region_create(ds, ops, 1, size);
 		if (IS_ERR(region))
diff --git a/drivers/net/dsa/mv88e6xxx/global1.h b/drivers/net/dsa/mv88e6xxx/global1.h
index 1e3546f8b072..a4f0c0517772 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.h
+++ b/drivers/net/dsa/mv88e6xxx/global1.h
@@ -329,6 +329,8 @@ void mv88e6xxx_g1_atu_prob_irq_free(struct mv88e6xxx_chip *chip);
 int mv88e6165_g1_atu_get_hash(struct mv88e6xxx_chip *chip, u8 *hash);
 int mv88e6165_g1_atu_set_hash(struct mv88e6xxx_chip *chip, u8 hash);
 
+int mv88e6xxx_g1_vtu_getnext(struct mv88e6xxx_chip *chip,
+			     struct mv88e6xxx_vtu_entry *entry);
 int mv88e6185_g1_vtu_getnext(struct mv88e6xxx_chip *chip,
 			     struct mv88e6xxx_vtu_entry *entry);
 int mv88e6185_g1_vtu_loadpurge(struct mv88e6xxx_chip *chip,
diff --git a/drivers/net/dsa/mv88e6xxx/global1_vtu.c b/drivers/net/dsa/mv88e6xxx/global1_vtu.c
index 48390b7b18ad..f24e01961c09 100644
--- a/drivers/net/dsa/mv88e6xxx/global1_vtu.c
+++ b/drivers/net/dsa/mv88e6xxx/global1_vtu.c
@@ -276,8 +276,8 @@ static int mv88e6xxx_g1_vtu_stu_get(struct mv88e6xxx_chip *chip,
 	return 0;
 }
 
-static int mv88e6xxx_g1_vtu_getnext(struct mv88e6xxx_chip *chip,
-				    struct mv88e6xxx_vtu_entry *entry)
+int mv88e6xxx_g1_vtu_getnext(struct mv88e6xxx_chip *chip,
+			     struct mv88e6xxx_vtu_entry *entry)
 {
 	int err;
 
-- 
2.17.1


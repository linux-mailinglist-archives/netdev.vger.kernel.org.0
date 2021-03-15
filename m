Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C576733C84D
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 22:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbhCOVPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 17:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbhCOVPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 17:15:08 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B0D9C06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 14:15:08 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id 15so17980452ljj.0
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 14:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=13sNGlYWXsP7JyqZBCNf8smPbsLjBihO3000tHNoA2A=;
        b=XL2GsPiO0UQ9d0Y42n827D331XXs0LYgiEykwVs7wKB0vniHPDsm2G1F2V8OD2e+/g
         Vg2mhHgu72b3dtig5WmQDLT932aiB6d5v7tPU8NW++DWUhS81PqLH92bahFsJ37eOF2J
         jaG/d4SX+Y0I8BipT4/TCAx9m1y+iSSNmzIamVjoLJQa/lNAdGEtxKTRuFYXJ95+8+cs
         fVgddgbcwPHpXXz9H/fAvrCjEKZRX6ojGhaghBhCo2HnPsw/RetFygZSWBWzQz/QlpKV
         8XKx03AHvj2bTTC+tJcWlHB3Ta9mZVFWiBCDN/21RbSBllgm8Onx8QR4gRSCxUNa8DSU
         0psA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=13sNGlYWXsP7JyqZBCNf8smPbsLjBihO3000tHNoA2A=;
        b=JUtwjaSSiCnlnGAqlU2JWfOTe3I6bXB7ZEurlkfE6J5opSIuGUJCAQg5+dnvV8rMuH
         3diD/slmSAq6reFigCeCPfz0EnqIvtrEyI7G2PADxco4J4gBLF1A0ykwZYZsKZ+xFJyl
         MwVriaUM9LswMvjKFSFoRIcNeZyzg1uG7UA9o1AT+rVMQ8X2vk6LXzbDSz0oir76C5GF
         BhazNJTBNHrr5rClLCZ9G/Ko/OXEtz3P4h/KPelsVf+Y1M/kjRybZHK8CJjqldEDS+pe
         +y9ZaunvneL4h3Rd2N5qXwiyMpC1xlcVVv1Lmrv7gkOd6CNyPcApPjpmCa6wCSclEEO6
         Mu6g==
X-Gm-Message-State: AOAM533JIS04p/DP6hI81wbCCOWJtC71bkapv+Az391hdcnTNxC1SDOF
        C37FUcebawRODAxX+WkxDlSFuQ==
X-Google-Smtp-Source: ABdhPJyRI8TZTYPOof7uKzOHd8u7t5WNQix9U4MxQH/LfzQVt3NM5FSOyVCWVBZC1F7LDsu1dE4hEA==
X-Received: by 2002:a2e:b88e:: with SMTP id r14mr559770ljp.450.1615842906529;
        Mon, 15 Mar 2021 14:15:06 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id v11sm2975003ljp.63.2021.03.15.14.15.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 14:15:06 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH net-next 1/5] net: dsa: mv88e6xxx: Provide generic VTU iterator
Date:   Mon, 15 Mar 2021 22:13:56 +0100
Message-Id: <20210315211400.2805330-2-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210315211400.2805330-1-tobias@waldekranz.com>
References: <20210315211400.2805330-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the intricacies of correctly iterating over the VTU to a common
implementation.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 100 ++++++++++++++++++++-----------
 1 file changed, 64 insertions(+), 36 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 903d619e08ed..c70d4b7db4f5 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1481,6 +1481,37 @@ static int mv88e6xxx_vtu_getnext(struct mv88e6xxx_chip *chip,
 	return chip->info->ops->vtu_getnext(chip, entry);
 }
 
+static int mv88e6xxx_vtu_walk(struct mv88e6xxx_chip *chip,
+			      int (*cb)(struct mv88e6xxx_chip *chip,
+					const struct mv88e6xxx_vtu_entry *entry,
+					void *priv),
+			      void *priv)
+{
+	struct mv88e6xxx_vtu_entry entry = {
+		.vid = mv88e6xxx_max_vid(chip),
+		.valid = false,
+	};
+	int err;
+
+	if (!chip->info->ops->vtu_getnext)
+		return -EOPNOTSUPP;
+
+	do {
+		err = chip->info->ops->vtu_getnext(chip, &entry);
+		if (err)
+			return err;
+
+		if (!entry.valid)
+			break;
+
+		err = cb(chip, &entry, priv);
+		if (err)
+			return err;
+	} while (entry.vid < mv88e6xxx_max_vid(chip));
+
+	return 0;
+}
+
 static int mv88e6xxx_vtu_loadpurge(struct mv88e6xxx_chip *chip,
 				   struct mv88e6xxx_vtu_entry *entry)
 {
@@ -1490,9 +1521,18 @@ static int mv88e6xxx_vtu_loadpurge(struct mv88e6xxx_chip *chip,
 	return chip->info->ops->vtu_loadpurge(chip, entry);
 }
 
+static int mv88e6xxx_fid_map_vlan(struct mv88e6xxx_chip *chip,
+				  const struct mv88e6xxx_vtu_entry *entry,
+				  void *_fid_bitmap)
+{
+	unsigned long *fid_bitmap = _fid_bitmap;
+
+	set_bit(entry->fid, fid_bitmap);
+	return 0;
+}
+
 int mv88e6xxx_fid_map(struct mv88e6xxx_chip *chip, unsigned long *fid_bitmap)
 {
-	struct mv88e6xxx_vtu_entry vlan;
 	int i, err;
 	u16 fid;
 
@@ -1508,21 +1548,7 @@ int mv88e6xxx_fid_map(struct mv88e6xxx_chip *chip, unsigned long *fid_bitmap)
 	}
 
 	/* Set every FID bit used by the VLAN entries */
-	vlan.vid = mv88e6xxx_max_vid(chip);
-	vlan.valid = false;
-
-	do {
-		err = mv88e6xxx_vtu_getnext(chip, &vlan);
-		if (err)
-			return err;
-
-		if (!vlan.valid)
-			break;
-
-		set_bit(vlan.fid, fid_bitmap);
-	} while (vlan.vid < mv88e6xxx_max_vid(chip));
-
-	return 0;
+	return mv88e6xxx_vtu_walk(chip, mv88e6xxx_fid_map_vlan, fid_bitmap);
 }
 
 static int mv88e6xxx_atu_new(struct mv88e6xxx_chip *chip, u16 *fid)
@@ -2168,10 +2194,30 @@ static int mv88e6xxx_port_db_dump_fid(struct mv88e6xxx_chip *chip,
 	return err;
 }
 
+struct mv88e6xxx_port_db_dump_vlan_ctx {
+	int port;
+	dsa_fdb_dump_cb_t *cb;
+	void *data;
+};
+
+static int mv88e6xxx_port_db_dump_vlan(struct mv88e6xxx_chip *chip,
+				       const struct mv88e6xxx_vtu_entry *entry,
+				       void *_data)
+{
+	struct mv88e6xxx_port_db_dump_vlan_ctx *ctx = _data;
+
+	return mv88e6xxx_port_db_dump_fid(chip, entry->fid, entry->vid,
+					  ctx->port, ctx->cb, ctx->data);
+}
+
 static int mv88e6xxx_port_db_dump(struct mv88e6xxx_chip *chip, int port,
 				  dsa_fdb_dump_cb_t *cb, void *data)
 {
-	struct mv88e6xxx_vtu_entry vlan;
+	struct mv88e6xxx_port_db_dump_vlan_ctx ctx = {
+		.port = port,
+		.cb = cb,
+		.data = data,
+	};
 	u16 fid;
 	int err;
 
@@ -2184,25 +2230,7 @@ static int mv88e6xxx_port_db_dump(struct mv88e6xxx_chip *chip, int port,
 	if (err)
 		return err;
 
-	/* Dump VLANs' Filtering Information Databases */
-	vlan.vid = mv88e6xxx_max_vid(chip);
-	vlan.valid = false;
-
-	do {
-		err = mv88e6xxx_vtu_getnext(chip, &vlan);
-		if (err)
-			return err;
-
-		if (!vlan.valid)
-			break;
-
-		err = mv88e6xxx_port_db_dump_fid(chip, vlan.fid, vlan.vid, port,
-						 cb, data);
-		if (err)
-			return err;
-	} while (vlan.vid < mv88e6xxx_max_vid(chip));
-
-	return err;
+	return mv88e6xxx_vtu_walk(chip, mv88e6xxx_port_db_dump_vlan, &ctx);
 }
 
 static int mv88e6xxx_port_fdb_dump(struct dsa_switch *ds, int port,
-- 
2.25.1


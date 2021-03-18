Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E20A5340E2D
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 20:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232852AbhCRT0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 15:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232680AbhCRTZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 15:25:49 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEEA6C06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 12:25:48 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id e18so6747019wrt.6
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 12:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=DuCZIg5au+dza1dRuyipKrYhx0/Zcv4kfypsdp2xTMU=;
        b=jzJL35Kouy6mqulnRuVeK/bnLuyFAxCiukQWWzg/MhmoO3K9OxAATzl2ZffEBfSAO6
         I2ZFDmQpRMOakJm30UJTUIS9+RWB+dcfJycf/i24ufgMFdaVyCmWWdVlmvFLjQjmzDXQ
         5E3CxhoPcNDVFR35KqS7VKyAYF0vamKRBGbD3yffFahdUqHZT+QWj6Ip91Qzi8Vp2uKe
         OosWug0zzn0qSgKcmENZ714Tm86PMH2++LpTVl5CTaBYpfGP1CLCVerYwPxsOBjnElCB
         q+BrZDSOIRklJasZS2nPn6Wwuz4/rRDHWYw6SyHG6K6wgFhcvCEQRaWrxuhTiBqfBQR4
         G36g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=DuCZIg5au+dza1dRuyipKrYhx0/Zcv4kfypsdp2xTMU=;
        b=eZUq3P3HnsgYrp9nW2EV++sBckYjP4CESmwWUKqAP5dSUNEK29hkaJ6hX+QfRc+HaE
         arQbvgs3ZzGxGQA41BAAM0SMfiSxFwamqjF474cKjS3JAN+iZFNXsj6MB3bgQurqf69m
         yzCQwfNjLYY9HA6MQ0qi2RC8v4m3U8kDYtt6PJy+O0MGP9rI1yk6wvWAQ37A7kCnz0su
         DG80a1Spssj1K3h8rwbz1XkqZVObdlY7eWOF27j2Qt/QhdHt4lfsmbPlKpLMHD0If3ZW
         XmGyULKQiEgkvoemyleBz/VwAymd+/+bS4oHkOYUNHzOzaPSiNWN7EM4y3mugX3m1dML
         tXbA==
X-Gm-Message-State: AOAM533SFKpmypQOKmuvRxM7vg59vDFiEmyOzMEdDzqFdpraFnG9Zs9J
        lv4ELZyvGHOIM0YXRbkHpW0q7A==
X-Google-Smtp-Source: ABdhPJxa+LgDWoUwvWasKEj11uMV84A/OnD4SVg63er049iv1bMWlQ/4zAL2GvRf/72vV7W0WZcTeg==
X-Received: by 2002:adf:f743:: with SMTP id z3mr830676wrp.304.1616095547483;
        Thu, 18 Mar 2021 12:25:47 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id j30sm4576443wrj.62.2021.03.18.12.25.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 12:25:47 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH v3 net-next 3/8] net: dsa: mv88e6xxx: Provide generic VTU iterator
Date:   Thu, 18 Mar 2021 20:25:35 +0100
Message-Id: <20210318192540.895062-4-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210318192540.895062-1-tobias@waldekranz.com>
References: <20210318192540.895062-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the intricacies of correctly iterating over the VTU to a common
implementation.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 100 ++++++++++++++++++++-----------
 1 file changed, 64 insertions(+), 36 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index ed38b4431d74..0a4e467179c9 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1511,6 +1511,37 @@ static int mv88e6xxx_vtu_getnext(struct mv88e6xxx_chip *chip,
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
@@ -1520,9 +1551,18 @@ static int mv88e6xxx_vtu_loadpurge(struct mv88e6xxx_chip *chip,
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
 
@@ -1538,21 +1578,7 @@ int mv88e6xxx_fid_map(struct mv88e6xxx_chip *chip, unsigned long *fid_bitmap)
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
@@ -2198,10 +2224,30 @@ static int mv88e6xxx_port_db_dump_fid(struct mv88e6xxx_chip *chip,
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
 
@@ -2214,25 +2260,7 @@ static int mv88e6xxx_port_db_dump(struct mv88e6xxx_chip *chip, int port,
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


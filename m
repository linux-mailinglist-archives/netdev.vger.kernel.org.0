Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC6CD3407A0
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 15:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbhCROQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 10:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbhCROQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 10:16:16 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53C3C06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 07:16:15 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id b83so4842628lfd.11
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 07:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=btW31yi6BItpxQ7m00h0+TZYQwweUqbbSqt+hYCmyIE=;
        b=eJRQa6Cnu+zBrcLRxjykJugz3MYi/6mD39OlykAs2KSrEIvfKkVAKXrNTXj05mmPkl
         I/qxgSjUt8p3cMR901ilDvsJMsX2/j7x3T7Ae5pYOh81sJTj7hv4pacyWp5UndxwPiJV
         RGiKX8dIq3WmNX6QHtEpNjOGcf9y0awWO5sEslJ6Cd2ekSIt0a3z2zE/csxBc7bvIKHn
         iGOb34KPOm7wTXvz/ivyrncgI6mKzlqJtiee0MqbWE39C/sqsX1jz9HG6zOuMXcKtI6I
         gj6g44xZGyXjv5JjBccAz0P5oX5YeGfBskphH5tkLfP8dk7XgAhl1z8jCI8JVcPAHH8h
         +AXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=btW31yi6BItpxQ7m00h0+TZYQwweUqbbSqt+hYCmyIE=;
        b=jPGrY5+4BnBHXyYmCoukgVoQ/JgKb+JMIRR4RXSgoEqeG6YWpDgmkQrVdWXya6XhDx
         3Rt6BYJ4dWOO0dEkXqUydI4fKRIy2zymgXujdNmdEPIZUtka+Pu87Ax8SfYiTh7in6Bf
         J0j+6aDviT4fdqaH/iP9Mds71DENZt+Ah+E0oUf+VEaNHCfXju9DjGB+JU50/NEDVRGv
         JVrJnmuv45bjP4EwtbSiEF/kRSoBFeOSvXo9IM5E5aqMO6YHeQgbXwTidsooIF/eP0iT
         h4XHWrg8jtrinn3p7gdmpP3zgc21sJ1R7rgmogLyDkgLdHyadSWVUSyXBR0qMd0EDBkR
         jxZw==
X-Gm-Message-State: AOAM53180tE8I7HOJm68dcT6FFXg7VWS6LyC0mZyzvUOAuiMKNBmDDbT
        wv/0MOmrbhkXGG4dPIPgMzniOw==
X-Google-Smtp-Source: ABdhPJw0EsVcE1XGq3cEWR7QqezY2Y6bwwxPQohDakRqu+74tDK56i3aVgW+Ho6zAKIkmDu8Km2y1Q==
X-Received: by 2002:ac2:5052:: with SMTP id a18mr5324091lfm.55.1616076974359;
        Thu, 18 Mar 2021 07:16:14 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id w26sm237382lfr.186.2021.03.18.07.16.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 07:16:14 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 3/8] net: dsa: mv88e6xxx: Provide generic VTU iterator
Date:   Thu, 18 Mar 2021 15:15:45 +0100
Message-Id: <20210318141550.646383-4-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210318141550.646383-1-tobias@waldekranz.com>
References: <20210318141550.646383-1-tobias@waldekranz.com>
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


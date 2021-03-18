Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4790F340E2E
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 20:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbhCRT00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 15:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232699AbhCRTZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 15:25:50 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD7EDC06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 12:25:49 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id j18so6744050wra.2
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 12:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=cizSHENUyeZGqFT7hDUldLiIWX9DfScZjIEGTfDRcWM=;
        b=Orn9ZHxdcm2Wx6ou2sEfH4ntpezmYyMaDYIDb/5Fe6tBA7bed0Amk2VKvEurkUdBwl
         FdmdyDSu5dDp90BFiA72Qt+8epGRZ/8gAB/0I47al26yrpyIAmOyxv8h1iLahx5o1qLk
         3AWroWnJ8znqD6kXverKxMzEkTdk0+h+jVME4QxgHrGtuTKsNHzubFD8gh7bFi6nNQZT
         cqqjLBeqxDNjzxUcBTxSwda3PZGwMEc5K94+7152RbqRYEtN7KeEKd6XuFi68Wc1CRMy
         WlYFmfSl164/+3z65LDFwnwAxOVpD3IME3HlG2PDgHf3HnVEKigGIgiwhW57obPrre2o
         zh1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=cizSHENUyeZGqFT7hDUldLiIWX9DfScZjIEGTfDRcWM=;
        b=ZzYKcnH08nb/vy51qoyEPeddUU2U8Bdb7xIpNvtx6L0D6C2z6mllmaRNWAvHrKd0rg
         sTXxIUlNGgivlWby0X6mA0MMvVPW0S7cOSfsr1ubttyf+xHbvTLUOOIJLJ36mrZz00N6
         /MDZ8xjey4qYPDQtl2aKOlyNoQDwbo82LxJP0t/AQrfl0lSjrlbexY0NFyBLRBpdM4Ti
         5LB9snh3ztRCcHEM6iHE+y6qH6d3Chk+ktLYFTcHy4wBxyJX0r15ScJKrqlcYlIZ/Oc2
         0MpHrENyekNiHP1jMaJdePBNb1drm7QZ+pserdYaWG2PgM4aDQ3VatqV3ZMm9xSMrei8
         LBlQ==
X-Gm-Message-State: AOAM531ntobLt4mvKhrhkNP+F7nOehUwzewrAorMBw/35rFR8RaqWVp/
        mz4++BRwHg8cCphNSwjh3F78c9bY7qeVDCNm
X-Google-Smtp-Source: ABdhPJzc6BoZ/S43pTPtZ2E3brecGFBKnRL9TcCNVJYdiU7b6r3Ck7xSMrYN7aeSeXBsc/EXnhTyGw==
X-Received: by 2002:adf:828e:: with SMTP id 14mr794902wrc.123.1616095548364;
        Thu, 18 Mar 2021 12:25:48 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id j30sm4576443wrj.62.2021.03.18.12.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 12:25:48 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [PATCH v3 net-next 4/8] net: dsa: mv88e6xxx: Remove some bureaucracy around querying the VTU
Date:   Thu, 18 Mar 2021 20:25:36 +0100
Message-Id: <20210318192540.895062-5-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210318192540.895062-1-tobias@waldekranz.com>
References: <20210318192540.895062-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hardware has a somewhat quirky protocol for reading out the VTU
entry for a particular VID. But there is no reason why we cannot
create a better API for ourselves in the driver.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 45 ++++++++++++++------------------
 1 file changed, 20 insertions(+), 25 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 0a4e467179c9..c18c55e1617e 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1502,13 +1502,23 @@ static int mv88e6xxx_vtu_setup(struct mv88e6xxx_chip *chip)
 	return mv88e6xxx_g1_vtu_flush(chip);
 }
 
-static int mv88e6xxx_vtu_getnext(struct mv88e6xxx_chip *chip,
-				 struct mv88e6xxx_vtu_entry *entry)
+static int mv88e6xxx_vtu_get(struct mv88e6xxx_chip *chip, u16 vid,
+			     struct mv88e6xxx_vtu_entry *entry)
 {
+	int err;
+
 	if (!chip->info->ops->vtu_getnext)
 		return -EOPNOTSUPP;
 
-	return chip->info->ops->vtu_getnext(chip, entry);
+	entry->vid = vid ? vid - 1 : mv88e6xxx_max_vid(chip);
+	entry->valid = false;
+
+	err = chip->info->ops->vtu_getnext(chip, entry);
+
+	if (entry->vid != vid)
+		entry->valid = false;
+
+	return err;
 }
 
 static int mv88e6xxx_vtu_walk(struct mv88e6xxx_chip *chip,
@@ -1615,19 +1625,13 @@ static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
 	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
 		return 0;
 
-	vlan.vid = vid - 1;
-	vlan.valid = false;
-
-	err = mv88e6xxx_vtu_getnext(chip, &vlan);
+	err = mv88e6xxx_vtu_get(chip, vid, &vlan);
 	if (err)
 		return err;
 
 	if (!vlan.valid)
 		return 0;
 
-	if (vlan.vid != vid)
-		return 0;
-
 	for (i = 0; i < mv88e6xxx_num_ports(chip); ++i) {
 		if (dsa_is_dsa_port(ds, i) || dsa_is_cpu_port(ds, i))
 			continue;
@@ -1709,15 +1713,12 @@ static int mv88e6xxx_port_db_load_purge(struct mv88e6xxx_chip *chip, int port,
 		if (err)
 			return err;
 	} else {
-		vlan.vid = vid - 1;
-		vlan.valid = false;
-
-		err = mv88e6xxx_vtu_getnext(chip, &vlan);
+		err = mv88e6xxx_vtu_get(chip, vid, &vlan);
 		if (err)
 			return err;
 
 		/* switchdev expects -EOPNOTSUPP to honor software VLANs */
-		if (vlan.vid != vid || !vlan.valid)
+		if (!vlan.valid)
 			return -EOPNOTSUPP;
 
 		fid = vlan.fid;
@@ -1994,14 +1995,11 @@ static int mv88e6xxx_port_vlan_join(struct mv88e6xxx_chip *chip, int port,
 	struct mv88e6xxx_vtu_entry vlan;
 	int i, err;
 
-	vlan.vid = vid - 1;
-	vlan.valid = false;
-
-	err = mv88e6xxx_vtu_getnext(chip, &vlan);
+	err = mv88e6xxx_vtu_get(chip, vid, &vlan);
 	if (err)
 		return err;
 
-	if (vlan.vid != vid || !vlan.valid) {
+	if (!vlan.valid) {
 		memset(&vlan, 0, sizeof(vlan));
 
 		err = mv88e6xxx_atu_new(chip, &vlan.fid);
@@ -2097,17 +2095,14 @@ static int mv88e6xxx_port_vlan_leave(struct mv88e6xxx_chip *chip,
 	if (!vid)
 		return -EOPNOTSUPP;
 
-	vlan.vid = vid - 1;
-	vlan.valid = false;
-
-	err = mv88e6xxx_vtu_getnext(chip, &vlan);
+	err = mv88e6xxx_vtu_get(chip, vid, &vlan);
 	if (err)
 		return err;
 
 	/* If the VLAN doesn't exist in hardware or the port isn't a member,
 	 * tell switchdev that this VLAN is likely handled in software.
 	 */
-	if (vlan.vid != vid || !vlan.valid ||
+	if (!vlan.valid ||
 	    vlan.member[port] == MV88E6XXX_G1_VTU_DATA_MEMBER_TAG_NON_MEMBER)
 		return -EOPNOTSUPP;
 
-- 
2.25.1


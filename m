Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1250149FE05
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 17:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244451AbiA1Q1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 11:27:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239096AbiA1Q06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 11:26:58 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B09C06173B
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 08:26:57 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id b9so12802164lfq.6
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 08:26:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=nz10n5ifCC7jilAgmrhoGezCuubLvVaE9a6SaZb/KRM=;
        b=J4T1axblWo2VjbOpI6MSS/XqleKMuc3xv/oPPvXCdlFRSykfHaHfxOARecbkZdiMK2
         63+9Q16JMLDCtnzlc+prrkyM2CfGJ9C3xcWTLpTrEWTA3jJT+DFY9wgzgCIWd7P9dYrH
         MIDYyiYTjdvnK2TMUMQmgMn9reR/+pMw8E7DBrKKc2zJjP/sk5vH5j3TzoK186s6l+sU
         XHi0/vsNbCPk9Wjx6r48HaX1slR1EenNZc4kPogvbug3Wsf0V4Vkakau9Ahp4kuvfmWg
         Zag0pznXkbJykbzb2/37t7HcWtdGD8jt+YR5hY7rNed4ILEuu4o0GUQThQgNUdd2biTF
         fBMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=nz10n5ifCC7jilAgmrhoGezCuubLvVaE9a6SaZb/KRM=;
        b=z/GWon0zgrmOlgeIND5iv/QbBjSYmdN5wn18RnfukEchG81abFkTZGgfJBWYHYU7Vb
         vM8eeNiB8FIS6oXkisLOTT+gFzi6SD3blErZrd2JnQlXgVjsrGTPQT6clCVdf2OXe8zX
         jQV61WhwfDNha8R93ycAMppnIOdYrprPHvwXo3sDrTauheXi1akRLn4bistYZCeJsBXs
         Z9tSXi/vVrjYSB09F9cGAFq3SnWMyQnK56EluIKegD2rHZjS+0mU4/e2zUu65Yfdv2D2
         UbeTYfkLkN1lQRdHJzuPDNIOm+nX3qVMqHZ2gMmhzjK+UI/JwxB2lb2otLyuH3T8v8Us
         GMgg==
X-Gm-Message-State: AOAM533K8WwasysR9RSPItjmWu2B3Ug4yooZbSTT9bstCr7jS1xhHGXr
        vckB6IUafYj9+t00VhtYhWropw==
X-Google-Smtp-Source: ABdhPJzcbdJrYGxeN2XkmQMIFB/uwv9rfLlwXrQ83Ox458wMfhw4lgxAc6IqSZS58Wzexzuc4q2pQw==
X-Received: by 2002:a05:6512:68a:: with SMTP id t10mr6587439lfe.520.1643387216011;
        Fri, 28 Jan 2022 08:26:56 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id v17sm1954968ljh.5.2022.01.28.08.26.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 08:26:55 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, David.Laight@ACULAB.COM,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 net-next 2/2] net: dsa: mv88e6xxx: Improve indirect addressing performance
Date:   Fri, 28 Jan 2022 17:26:50 +0100
Message-Id: <20220128162650.2510062-3-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220128162650.2510062-1-tobias@waldekranz.com>
References: <20220128162650.2510062-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before this change, both the read and write callback would start out
by asserting that the chip's busy flag was cleared. However, both
callbacks also made sure to wait for the clearing of the busy bit
before returning - making the initial check superfluous. The only
time that would ever have an effect was if the busy bit was initially
set for some reason.

With that in mind, make sure to perform an initial check of the busy
bit, after which both read and write can rely the previous operation
to have waited for the bit to clear.

This cuts the number of operations on the underlying MDIO bus by 25%

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.h |  1 +
 drivers/net/dsa/mv88e6xxx/smi.c  | 24 ++++++++++++++----------
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 8271b8aa7b71..438cee853d07 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -392,6 +392,7 @@ struct mv88e6xxx_chip {
 struct mv88e6xxx_bus_ops {
 	int (*read)(struct mv88e6xxx_chip *chip, int addr, int reg, u16 *val);
 	int (*write)(struct mv88e6xxx_chip *chip, int addr, int reg, u16 val);
+	int (*init)(struct mv88e6xxx_chip *chip);
 };
 
 struct mv88e6xxx_mdio_bus {
diff --git a/drivers/net/dsa/mv88e6xxx/smi.c b/drivers/net/dsa/mv88e6xxx/smi.c
index 728ef3f54ec5..a990271b7482 100644
--- a/drivers/net/dsa/mv88e6xxx/smi.c
+++ b/drivers/net/dsa/mv88e6xxx/smi.c
@@ -111,11 +111,6 @@ static int mv88e6xxx_smi_indirect_read(struct mv88e6xxx_chip *chip,
 {
 	int err;
 
-	err = mv88e6xxx_smi_direct_wait(chip, chip->sw_addr,
-					MV88E6XXX_SMI_CMD, 15, 0);
-	if (err)
-		return err;
-
 	err = mv88e6xxx_smi_direct_write(chip, chip->sw_addr,
 					 MV88E6XXX_SMI_CMD,
 					 MV88E6XXX_SMI_CMD_BUSY |
@@ -139,11 +134,6 @@ static int mv88e6xxx_smi_indirect_write(struct mv88e6xxx_chip *chip,
 {
 	int err;
 
-	err = mv88e6xxx_smi_direct_wait(chip, chip->sw_addr,
-					MV88E6XXX_SMI_CMD, 15, 0);
-	if (err)
-		return err;
-
 	err = mv88e6xxx_smi_direct_write(chip, chip->sw_addr,
 					 MV88E6XXX_SMI_DATA, data);
 	if (err)
@@ -162,9 +152,20 @@ static int mv88e6xxx_smi_indirect_write(struct mv88e6xxx_chip *chip,
 					 MV88E6XXX_SMI_CMD, 15, 0);
 }
 
+static int mv88e6xxx_smi_indirect_init(struct mv88e6xxx_chip *chip)
+{
+	/* Ensure that the chip starts out in the ready state. As both
+	 * reads and writes always ensure this on return, they can
+	 * safely depend on the chip not being busy on entry.
+	 */
+	return mv88e6xxx_smi_direct_wait(chip, chip->sw_addr,
+					 MV88E6XXX_SMI_CMD, 15, 0);
+}
+
 static const struct mv88e6xxx_bus_ops mv88e6xxx_smi_indirect_ops = {
 	.read = mv88e6xxx_smi_indirect_read,
 	.write = mv88e6xxx_smi_indirect_write,
+	.init = mv88e6xxx_smi_indirect_init,
 };
 
 int mv88e6xxx_smi_init(struct mv88e6xxx_chip *chip,
@@ -182,5 +183,8 @@ int mv88e6xxx_smi_init(struct mv88e6xxx_chip *chip,
 	chip->bus = bus;
 	chip->sw_addr = sw_addr;
 
+	if (chip->smi_ops->init)
+		return chip->smi_ops->init(chip);
+
 	return 0;
 }
-- 
2.25.1


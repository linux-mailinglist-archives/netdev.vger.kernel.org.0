Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4D865B80F0
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 07:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiINFa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 01:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbiINFax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 01:30:53 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C84846D95
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 22:30:50 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id a8so23347026lff.13
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 22:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=/OApzMapfMzOLbd6sKsMHZFgaTEweXQQvS5umrNIFN4=;
        b=FMFPFA7Hq/Nvo+qvvjuEt5l6+6cFZfmE6KiWn4+YDMIyj71WUzE9pe2BlW/W1bJtng
         9ErGOKgDzo1MlVqAZJQdhIFI4dAwrqmTn3GSBTKyaGhOWpF/aiCX3EyHKFEdfu7XdJcC
         vex1c7PyAjhEQQAnIb7vssDYMSjp0sItzmYg01CZWJdKsiEoIqXQ+AUvkURu82IfTi2A
         dNEDmsJYSXLHh7yeawo7eUUgtEMGoUjQ+eiD1QhSnPAiQTmk9k+h8fSFQKo5dxmwS7/Y
         4N48awkpJSeG2L09tQM/oL9e68Rk4J7M6Nrq+vjxwjKQAifxRlFhqZ22CqQ/GMafn/Pd
         /ftQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=/OApzMapfMzOLbd6sKsMHZFgaTEweXQQvS5umrNIFN4=;
        b=arbHEOW3bJRe/CYdZVtQG5yhes7ql41wdktLkwaiF0MWTjZBDCkzEYqO3Pw4YYJK+v
         5c3By5/6Ct0tOjSAgdsqwCnQQJab3m/M0mHDnBeXLIepf9lau+rGHqWvuT9JhjMHSKCJ
         B1aUewsG0Am2zb9C/dzYR5TTUXRAHajuJn1VDVGWqbhyysx/K67N/7LFBkW8/YEyNWxK
         71m4nv2HMzGemp83b6T7BCwP+U7xV1I6JfKMtrroewSaLzhhW1n/gnrKg4wWoIK4bzvS
         +tyi2sBZhTDheSY5MzgF8EB/xUgHRU4WB8RoPgoToUPx5KWCuTJQ6JBBlzyKFNjVb2JX
         is7g==
X-Gm-Message-State: ACrzQf3OqY/ZiJP11j5Z7FPXbZAiAaqbEGJKP/QGGP21EfNH6twckie3
        X5B7oYRvtK+OhSsVBPJP7OCpIOLLUtqnDA6h
X-Google-Smtp-Source: AMsMyM4pvxPf57Wxw3YLb2HOseUHyjNeyS5dOFI7WIoz0MwI3ZHyZxr/jIoM4X5ak/2HGo6Q0jrbFQ==
X-Received: by 2002:a05:6512:3e17:b0:49d:9fd5:da61 with SMTP id i23-20020a0565123e1700b0049d9fd5da61mr379050lfv.270.1663133448544;
        Tue, 13 Sep 2022 22:30:48 -0700 (PDT)
Received: from wse-c0089.westermo.com (h-98-128-229-160.NA.cust.bahnhof.se. [98.128.229.160])
        by smtp.gmail.com with ESMTPSA id f16-20020a05651c03d000b0026c297a9e11sm53814ljp.133.2022.09.13.22.30.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 22:30:48 -0700 (PDT)
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux@armlinux.org.uk,
        Mattias Forsblad <mattias.forsblad@gmail.com>
Subject: [PATCH net-next v11 5/6] net: dsa: mv88e6xxx: rmon: Use RMU for reading RMON data
Date:   Wed, 14 Sep 2022 07:30:40 +0200
Message-Id: <20220914053041.1615876-6-mattias.forsblad@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220914053041.1615876-1-mattias.forsblad@gmail.com>
References: <20220914053041.1615876-1-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the Remote Management Unit for efficiently accessing
the RMON data.

Signed-off-by: Mattias Forsblad <mattias.forsblad@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 36 +++++++++++++++++++++++++-------
 drivers/net/dsa/mv88e6xxx/chip.h |  2 ++
 drivers/net/dsa/mv88e6xxx/smi.c  |  3 +++
 3 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 294bf9bbaf3f..c9cfe935715c 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1234,16 +1234,30 @@ static int mv88e6xxx_stats_get_stats(struct mv88e6xxx_chip *chip, int port,
 				     u16 bank1_select, u16 histogram)
 {
 	struct mv88e6xxx_hw_stat *stat;
+	int offset = 0;
+	u64 high;
 	int i, j;
 
 	for (i = 0, j = 0; i < ARRAY_SIZE(mv88e6xxx_hw_stats); i++) {
 		stat = &mv88e6xxx_hw_stats[i];
 		if (stat->type & types) {
-			mv88e6xxx_reg_lock(chip);
-			data[j] = _mv88e6xxx_get_ethtool_stat(chip, stat, port,
-							      bank1_select,
-							      histogram);
-			mv88e6xxx_reg_unlock(chip);
+			if (mv88e6xxx_rmu_available(chip) &&
+			    !(stat->type & STATS_TYPE_PORT)) {
+				if (stat->type & STATS_TYPE_BANK1)
+					offset = 32;
+
+				data[j] = chip->ports[port].rmu_raw_stats[stat->reg + offset];
+				if (stat->size == 8) {
+					high = chip->ports[port].rmu_raw_stats[stat->reg + offset
+							+ 1];
+					data[j] += (high << 32);
+				}
+			} else {
+				mv88e6xxx_reg_lock(chip);
+				data[j] = _mv88e6xxx_get_ethtool_stat(chip, stat, port,
+								      bank1_select, histogram);
+				mv88e6xxx_reg_unlock(chip);
+			}
 
 			j++;
 		}
@@ -1312,10 +1326,9 @@ static void mv88e6xxx_get_stats(struct mv88e6xxx_chip *chip, int port,
 	mv88e6xxx_reg_unlock(chip);
 }
 
-static void mv88e6xxx_get_ethtool_stats(struct dsa_switch *ds, int port,
-					uint64_t *data)
+void mv88e6xxx_get_ethtool_stats_mdio(struct mv88e6xxx_chip *chip, int port,
+				      uint64_t *data)
 {
-	struct mv88e6xxx_chip *chip = ds->priv;
 	int ret;
 
 	mv88e6xxx_reg_lock(chip);
@@ -1327,7 +1340,14 @@ static void mv88e6xxx_get_ethtool_stats(struct dsa_switch *ds, int port,
 		return;
 
 	mv88e6xxx_get_stats(chip, port, data);
+}
+
+static void mv88e6xxx_get_ethtool_stats(struct dsa_switch *ds, int port,
+					uint64_t *data)
+{
+	struct mv88e6xxx_chip *chip = ds->priv;
 
+	chip->smi_ops->get_rmon(chip, port, data);
 }
 
 static int mv88e6xxx_get_regs_len(struct dsa_switch *ds, int port)
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index ea1789feeacf..5459037067e6 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -809,6 +809,8 @@ int mv88e6xxx_wait_mask(struct mv88e6xxx_chip *chip, int addr, int reg,
 int mv88e6xxx_wait_bit(struct mv88e6xxx_chip *chip, int addr, int reg,
 		       int bit, int val);
 struct mii_bus *mv88e6xxx_default_mdio_bus(struct mv88e6xxx_chip *chip);
+void mv88e6xxx_get_ethtool_stats_mdio(struct mv88e6xxx_chip *chip, int port,
+				      uint64_t *data);
 
 static inline void mv88e6xxx_reg_lock(struct mv88e6xxx_chip *chip)
 {
diff --git a/drivers/net/dsa/mv88e6xxx/smi.c b/drivers/net/dsa/mv88e6xxx/smi.c
index a990271b7482..ae805c449b85 100644
--- a/drivers/net/dsa/mv88e6xxx/smi.c
+++ b/drivers/net/dsa/mv88e6xxx/smi.c
@@ -83,6 +83,7 @@ static int mv88e6xxx_smi_direct_wait(struct mv88e6xxx_chip *chip,
 static const struct mv88e6xxx_bus_ops mv88e6xxx_smi_direct_ops = {
 	.read = mv88e6xxx_smi_direct_read,
 	.write = mv88e6xxx_smi_direct_write,
+	.get_rmon = mv88e6xxx_get_ethtool_stats_mdio,
 };
 
 static int mv88e6xxx_smi_dual_direct_read(struct mv88e6xxx_chip *chip,
@@ -100,6 +101,7 @@ static int mv88e6xxx_smi_dual_direct_write(struct mv88e6xxx_chip *chip,
 static const struct mv88e6xxx_bus_ops mv88e6xxx_smi_dual_direct_ops = {
 	.read = mv88e6xxx_smi_dual_direct_read,
 	.write = mv88e6xxx_smi_dual_direct_write,
+	.get_rmon = mv88e6xxx_get_ethtool_stats_mdio,
 };
 
 /* Offset 0x00: SMI Command Register
@@ -166,6 +168,7 @@ static const struct mv88e6xxx_bus_ops mv88e6xxx_smi_indirect_ops = {
 	.read = mv88e6xxx_smi_indirect_read,
 	.write = mv88e6xxx_smi_indirect_write,
 	.init = mv88e6xxx_smi_indirect_init,
+	.get_rmon = mv88e6xxx_get_ethtool_stats_mdio,
 };
 
 int mv88e6xxx_smi_init(struct mv88e6xxx_chip *chip,
-- 
2.25.1


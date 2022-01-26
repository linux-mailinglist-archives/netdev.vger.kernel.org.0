Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34CDC49D600
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 00:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233556AbiAZXNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 18:13:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233419AbiAZXM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 18:12:57 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21352C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 15:12:57 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id c15so1674888ljf.11
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 15:12:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=i2aQuRxQanU334DgDb3mt+uf8YbW8laWJVhEOzT9D7U=;
        b=dPO+BoyqpMxD2b8neCq+HOEnFu087569cqxrYQ5wXOoVRCTvklBqJ9VSfhc8+klYjF
         yQm93n3jYx42JgH0vKyxjWP8BCeKpmAic5IEe4AuuAooDYzplcRWDyD/3WViDr5lobx2
         mz0HdwM+9r/poN4pqlo0zg74RbqV9rYCNkcLxLv0ZJIg7dlm3UVUSfA8v9cdFS3lVLv1
         zKJGypK/N/XkkIIhDfgtXqEiwSIMIZT8N6M0fAoOvILzPsMZkM6aHtLoC/q9ZXx6/HGA
         aGRk3z06rqPe+PvRS3ssl15kS8T4ooSnmY/nsw3JMm0/zF6q8dg43TL6xvbDVlIF7IBd
         XrUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=i2aQuRxQanU334DgDb3mt+uf8YbW8laWJVhEOzT9D7U=;
        b=j4Ojzn1h5NoTvm2ZWDVTI8PglmLi3LZwSEinEryY30OaWv6WnmBDM3efjwVW9czcc8
         8/y/5R7p68ZlE4r7mcRC7sK4e8dH2Ty05Gw5ucvJLAn+Va4AKed2ehbaNs+LDsC/Ziby
         N1lTEhZh4+sJ+jmgqdJMEEmrIk1VBfiYyzf3hLvbK2TlI/est2IaqSK2fpkKk2zDsUya
         vB/MQdI1IxbHwTTsfYXTmp+3ACEvxRqtdsOi9HXki+4rBehjs9UQBk1yd8GiNSLZ9X/x
         OYPujHxzgOO6FyWIf7LbBNFQFkMwI8eChIC2j4Fv5zrIlQhg1BjZmkY+YHEyat/IFig/
         K0HQ==
X-Gm-Message-State: AOAM532p3OsH8yeH9JO6kvLmPsTK7RW717mgmImmPLASBtfgpYLWG/Jt
        C4mlYI93l9oWxEOpwUhlhNcL7g==
X-Google-Smtp-Source: ABdhPJw1huaemcEPtHkuy71ODp6RIuR5de3Z7hh/TSY9xpnGCY67kIY6aMTsiVGH7MbHRPiCt9AHcA==
X-Received: by 2002:a05:651c:1781:: with SMTP id bn1mr1024129ljb.78.1643238775475;
        Wed, 26 Jan 2022 15:12:55 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id p28sm1529335lfo.79.2022.01.26.15.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 15:12:54 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/2] net: dsa: mv88e6xxx: Improve indirect addressing performance
Date:   Thu, 27 Jan 2022 00:12:39 +0100
Message-Id: <20220126231239.1443128-3-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220126231239.1443128-1-tobias@waldekranz.com>
References: <20220126231239.1443128-1-tobias@waldekranz.com>
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
index a59f32243e08..1ebdaa55e710 100644
--- a/drivers/net/dsa/mv88e6xxx/smi.c
+++ b/drivers/net/dsa/mv88e6xxx/smi.c
@@ -104,11 +104,6 @@ static int mv88e6xxx_smi_indirect_read(struct mv88e6xxx_chip *chip,
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
@@ -132,11 +127,6 @@ static int mv88e6xxx_smi_indirect_write(struct mv88e6xxx_chip *chip,
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
@@ -155,9 +145,20 @@ static int mv88e6xxx_smi_indirect_write(struct mv88e6xxx_chip *chip,
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
@@ -175,5 +176,8 @@ int mv88e6xxx_smi_init(struct mv88e6xxx_chip *chip,
 	chip->bus = bus;
 	chip->sw_addr = sw_addr;
 
+	if (chip->smi_ops->init)
+		return chip->smi_ops->init(chip);
+
 	return 0;
 }
-- 
2.25.1


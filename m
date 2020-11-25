Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62FD22C43D0
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 16:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730955AbgKYPhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 10:37:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:55282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730947AbgKYPhM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 10:37:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CCB3221FB;
        Wed, 25 Nov 2020 15:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606318631;
        bh=5NNyRLEct+hm7THH7fiLLwe7wvo/lMM13bbW3N8HnHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dlz2GU2PyfQoSVKwy169JIiXuCzlqB1rfZqs3xMTFOb+k9WrzFzl9kzmxRB2G6PFH
         aejZfATntH8BLANMedMyYpSRjcoCVlhAGCNZr7spdxnpTb/wtGKlPtIwvTLqQRxjfE
         zTCir8oClE692HVMBkPL8EFXUcl5JVY4dPxyjrJo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Ruslan Sushko <rus@sushko.dev>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 23/23] net: dsa: mv88e6xxx: Wait for EEPROM done after HW reset
Date:   Wed, 25 Nov 2020 10:36:38 -0500
Message-Id: <20201125153638.810419-23-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201125153638.810419-1-sashal@kernel.org>
References: <20201125153638.810419-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

[ Upstream commit a3dcb3e7e70c72a68a79b30fc3a3adad5612731c ]

When the switch is hardware reset, it reads the contents of the
EEPROM. This can contain instructions for programming values into
registers and to perform waits between such programming. Reading the
EEPROM can take longer than the 100ms mv88e6xxx_hardware_reset() waits
after deasserting the reset GPIO. So poll the EEPROM done bit to
ensure it is complete.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Ruslan Sushko <rus@sushko.dev>
Link: https://lore.kernel.org/r/20201116164301.977661-1-rus@sushko.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c    |  2 ++
 drivers/net/dsa/mv88e6xxx/global1.c | 31 +++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/global1.h |  1 +
 3 files changed, 34 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 92e4d140df6fa..469b155df4885 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2143,6 +2143,8 @@ static void mv88e6xxx_hardware_reset(struct mv88e6xxx_chip *chip)
 		usleep_range(10000, 20000);
 		gpiod_set_value_cansleep(gpiod, 0);
 		usleep_range(10000, 20000);
+
+		mv88e6xxx_g1_wait_eeprom_done(chip);
 	}
 }
 
diff --git a/drivers/net/dsa/mv88e6xxx/global1.c b/drivers/net/dsa/mv88e6xxx/global1.c
index 8a903624fdd7c..938dd146629f1 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.c
+++ b/drivers/net/dsa/mv88e6xxx/global1.c
@@ -75,6 +75,37 @@ static int mv88e6xxx_g1_wait_init_ready(struct mv88e6xxx_chip *chip)
 	return mv88e6xxx_g1_wait_bit(chip, MV88E6XXX_G1_STS, bit, 1);
 }
 
+void mv88e6xxx_g1_wait_eeprom_done(struct mv88e6xxx_chip *chip)
+{
+	const unsigned long timeout = jiffies + 1 * HZ;
+	u16 val;
+	int err;
+
+	/* Wait up to 1 second for the switch to finish reading the
+	 * EEPROM.
+	 */
+	while (time_before(jiffies, timeout)) {
+		err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_STS, &val);
+		if (err) {
+			dev_err(chip->dev, "Error reading status");
+			return;
+		}
+
+		/* If the switch is still resetting, it may not
+		 * respond on the bus, and so MDIO read returns
+		 * 0xffff. Differentiate between that, and waiting for
+		 * the EEPROM to be done by bit 0 being set.
+		 */
+		if (val != 0xffff &&
+		    val & BIT(MV88E6XXX_G1_STS_IRQ_EEPROM_DONE))
+			return;
+
+		usleep_range(1000, 2000);
+	}
+
+	dev_err(chip->dev, "Timeout waiting for EEPROM done");
+}
+
 /* Offset 0x01: Switch MAC Address Register Bytes 0 & 1
  * Offset 0x02: Switch MAC Address Register Bytes 2 & 3
  * Offset 0x03: Switch MAC Address Register Bytes 4 & 5
diff --git a/drivers/net/dsa/mv88e6xxx/global1.h b/drivers/net/dsa/mv88e6xxx/global1.h
index 0ae96a1e919b6..08d66ef6aace6 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.h
+++ b/drivers/net/dsa/mv88e6xxx/global1.h
@@ -277,6 +277,7 @@ int mv88e6xxx_g1_set_switch_mac(struct mv88e6xxx_chip *chip, u8 *addr);
 int mv88e6185_g1_reset(struct mv88e6xxx_chip *chip);
 int mv88e6352_g1_reset(struct mv88e6xxx_chip *chip);
 int mv88e6250_g1_reset(struct mv88e6xxx_chip *chip);
+void mv88e6xxx_g1_wait_eeprom_done(struct mv88e6xxx_chip *chip);
 
 int mv88e6185_g1_ppu_enable(struct mv88e6xxx_chip *chip);
 int mv88e6185_g1_ppu_disable(struct mv88e6xxx_chip *chip);
-- 
2.27.0


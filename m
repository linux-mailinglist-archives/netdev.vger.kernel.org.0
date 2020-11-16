Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 589B32B4B7F
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 17:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731107AbgKPQnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 11:43:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730328AbgKPQnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 11:43:11 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A675FC0613CF
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 08:43:11 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id 35so4504100ple.12
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 08:43:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sushko-dev.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HudsOf94vnxAw/6eb+6j53HlU/gPKIu092y8St76tRY=;
        b=xSIhzicmZLpFqx44w2KUl1rrEg+EvpW5ZtNruTG6R0raBo32JAQUCeFCGJ9P+gb6WR
         0qgQsb6fE4DAimoH3Kf0iGDfY3w87dgcDYVDNbHRfbof/TZpPiaC27ZqkU74KgHiPWwf
         WglEWjoHoxDc6Ts/RRX6g23OCowyiFhZNdHMLKFCOgbpSr4pDtfR+UWG18R6ugWnNsj8
         VJVElowGiF5s2o1PnoCAUw5rpYYyoKa2FXvvmU6elS9y1DTodoFjbmLHF2kwrbpG7ita
         uREVSV4NTgWf91vXiWk/KTuo9Ou32Npn8ciesgmrnVA6I1WJs3AEY/Zw2K0Nzk8hzx62
         vvNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HudsOf94vnxAw/6eb+6j53HlU/gPKIu092y8St76tRY=;
        b=ZeWgDrXTTrHkTUI41tM/7VKGe8w9KeFweoI8w38uZdfh7hKe1Sq22TXsZSiIhGNmje
         uk7dvMOXdAqTtmO5SPh563rlj9l7Etpm+GQVwzURwnNMqCdW44z2FgoM8paFS45y2BGV
         Y9zVM0xkDkJXAb1Yv347nnZM4qsyjpkOw/oMgusdouLoJ5Pvb7cZFTFszmDZHRiLbhKn
         JK8lkLo+RAfRa07ZH40MQs21G7Wwh841jR3VjJTS0337YjndtU5Z2ZlobqUFtYW/5gPq
         WxfnFPUmxHAUaDpPjdJLrVroVONcAPpbZy/w+BYMNUPNOphky1aQCRyHELNMVgLrOWkL
         Q4bQ==
X-Gm-Message-State: AOAM533/4UFN9nTklx4CPiuV2fL37CM02botzdwq4uZuecRJ0mUXEnYf
        LWgjJVP8TF5UTT1BMkIOS1SoDfdzGPi+Xt7HnRCYu7xL
X-Google-Smtp-Source: ABdhPJwjPAhBV9ot/jDtG9lORvKXYjhTskA8OnzUvyT4nbwX2uwziZTyvNvwuIyjVBk0o3ilrEfocw==
X-Received: by 2002:a17:902:758d:b029:d6:65a6:c70b with SMTP id j13-20020a170902758db02900d665a6c70bmr12858442pll.30.1605544990848;
        Mon, 16 Nov 2020 08:43:10 -0800 (PST)
Received: from torus.ims.dom ([4.14.189.6])
        by smtp.gmail.com with ESMTPSA id j13sm18585245pfd.97.2020.11.16.08.43.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 08:43:09 -0800 (PST)
From:   "Ruslan V. Sushko" <rus@sushko.dev>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Ruslan Sushko <rus@sushko.dev>
Subject: [PATCH] net: dsa: mv88e6xxx: Wait for EEPROM done after HW reset
Date:   Mon, 16 Nov 2020 08:43:01 -0800
Message-Id: <20201116164301.977661-1-rus@sushko.dev>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

When the switch is hardware reset, it reads the contents of the
EEPROM. This can contain instructions for programming values into
registers and to perform waits between such programming. Reading the
EEPROM can take longer than the 100ms mv88e6xxx_hardware_reset() waits
after deasserting the reset GPIO. So poll the EEPROM done bit to
ensure it is complete.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Ruslan Sushko <rus@sushko.dev>
---
 drivers/net/dsa/mv88e6xxx/chip.c    |  2 ++
 drivers/net/dsa/mv88e6xxx/global1.c | 31 +++++++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/global1.h |  1 +
 3 files changed, 34 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index bd297ae7cf9e..34cca0a4b31c 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2297,6 +2297,8 @@ static void mv88e6xxx_hardware_reset(struct mv88e6xxx_chip *chip)
 		usleep_range(10000, 20000);
 		gpiod_set_value_cansleep(gpiod, 0);
 		usleep_range(10000, 20000);
+
+		mv88e6xxx_g1_wait_eeprom_done(chip);
 	}
 }
 
diff --git a/drivers/net/dsa/mv88e6xxx/global1.c b/drivers/net/dsa/mv88e6xxx/global1.c
index f62aa83ca08d..33d443a37efc 100644
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
index 1e3546f8b072..e05abe61fa11 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.h
+++ b/drivers/net/dsa/mv88e6xxx/global1.h
@@ -278,6 +278,7 @@ int mv88e6xxx_g1_set_switch_mac(struct mv88e6xxx_chip *chip, u8 *addr);
 int mv88e6185_g1_reset(struct mv88e6xxx_chip *chip);
 int mv88e6352_g1_reset(struct mv88e6xxx_chip *chip);
 int mv88e6250_g1_reset(struct mv88e6xxx_chip *chip);
+void mv88e6xxx_g1_wait_eeprom_done(struct mv88e6xxx_chip *chip);
 
 int mv88e6185_g1_ppu_enable(struct mv88e6xxx_chip *chip);
 int mv88e6185_g1_ppu_disable(struct mv88e6xxx_chip *chip);
-- 
2.25.4


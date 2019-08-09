Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8D188863D
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 00:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729596AbfHIWu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 18:50:26 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:44510 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729445AbfHIWuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 18:50:23 -0400
Received: by mail-qt1-f194.google.com with SMTP id 44so66332803qtg.11
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 15:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LPFW3+/BP0RVB1XuIQTLpTc1bKHMLFv1MeW+aaDdRcE=;
        b=ooGg3Vxo4GphoxGn0HtCU8y0a3henycYcta1rIyrLEoJGrzYHccMCt0QrE8/Ipv0Yt
         /KxRVwWQoi46N0UDLlO9EnJZn+VpD93J8iNm3WEAiT3WQlpOZjZbCwiP0Hz+o9J5quzC
         A7BpTh8i26menAycup8gTy0AD557WcnqrsBYdLrxfKuy2ZJQ3m/Djh/UEMQyK9ZljI8d
         aYZAjfV7H8mDA9fC9Km4d68GW0sTS4hTU0vkpqtcghIdcg/CO3Hgakpd2AHoxXfVBib4
         Du85xGd8dz628jSgqZT22sqN5c6WI0gEqI8dvINjDFqfeHZfGRf4CJIB2mhCaplk1u/k
         Ag6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LPFW3+/BP0RVB1XuIQTLpTc1bKHMLFv1MeW+aaDdRcE=;
        b=Uwhl5zuY298bukZqzGOyBbt+64hIUYcymawhlIUb6miKDAdHS75sn6AjVb79Em7rwR
         bub6rO9lJwfhJzldt617WJu417TTBcJAteD1OTlRdP1QoFiMWaeDcXD9tYZ4Lc17NVRH
         hFbYUO5DpFJducoUlMAxW9bM3S/HKayn4x7U0yh/wrqfpw/2d7tyq/GUrN88H5qGf09+
         BNnBHeyrqfZOGvl9d0mtGYVOnunurrYa8zK36ZDFLxYybygdGLXeiXD7d8b0bMg/qQF3
         pzbZoPcZ7mKitdwdFHcSXiaDiZey+EByunjTqH5PoVvQzufRuyx7WQ4QZB82tXtm6wNf
         ivww==
X-Gm-Message-State: APjAAAVcelQJHXDbanSw57zjv7h23FcpNs6k6AGc7sLQUv123VttyYvO
        MvUdVgfJSvRqhVpJv8r3My8/tFhh
X-Google-Smtp-Source: APXvYqylARVUMC0syvaBAwM24vigvT6DfCWH+76pDiiITZVPZq5wFXoEaGEzz2YwKmFqu520Fjf2Rw==
X-Received: by 2002:a0c:dd86:: with SMTP id v6mr20498876qvk.176.1565391022415;
        Fri, 09 Aug 2019 15:50:22 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id j61sm43016266qte.47.2019.08.09.15.50.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 15:50:21 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, f.fainelli@gmail.com, andrew@lunn.ch,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 2/7] net: dsa: mv88e6xxx: introduce wait mask routine
Date:   Fri,  9 Aug 2019 18:47:54 -0400
Message-Id: <20190809224759.5743-3-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190809224759.5743-1-vivien.didelot@gmail.com>
References: <20190809224759.5743-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current mv88e6xxx_wait routine is used to wait for a given mask
to be cleared to zero. However in some cases, the driver may have
to wait for a given mask to be of a certain non-zero value.

Thus provide a generic wait mask routine that will be used to implement
the current mv88e6xxx_wait function, and use it to wait for 88E6185
PPU states.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c    | 42 +++++++++++++++-----------
 drivers/net/dsa/mv88e6xxx/chip.h    |  2 ++
 drivers/net/dsa/mv88e6xxx/global1.c | 47 ++++++++---------------------
 drivers/net/dsa/mv88e6xxx/global1.h |  2 ++
 4 files changed, 41 insertions(+), 52 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index d3804ffd3d2a..bd61d0d3a245 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -80,6 +80,29 @@ int mv88e6xxx_write(struct mv88e6xxx_chip *chip, int addr, int reg, u16 val)
 	return 0;
 }
 
+int mv88e6xxx_wait_mask(struct mv88e6xxx_chip *chip, int addr, int reg,
+			u16 mask, u16 val)
+{
+	u16 data;
+	int err;
+	int i;
+
+	/* There's no bus specific operation to wait for a mask */
+	for (i = 0; i < 16; i++) {
+		err = mv88e6xxx_read(chip, addr, reg, &data);
+		if (err)
+			return err;
+
+		if ((data & mask) == val)
+			return 0;
+
+		usleep_range(1000, 2000);
+	}
+
+	dev_err(chip->dev, "Timeout while waiting for switch\n");
+	return -ETIMEDOUT;
+}
+
 struct mii_bus *mv88e6xxx_default_mdio_bus(struct mv88e6xxx_chip *chip)
 {
 	struct mv88e6xxx_mdio_bus *mdio_bus;
@@ -365,24 +388,7 @@ static void mv88e6xxx_irq_poll_free(struct mv88e6xxx_chip *chip)
 
 int mv88e6xxx_wait(struct mv88e6xxx_chip *chip, int addr, int reg, u16 mask)
 {
-	int i;
-
-	for (i = 0; i < 16; i++) {
-		u16 val;
-		int err;
-
-		err = mv88e6xxx_read(chip, addr, reg, &val);
-		if (err)
-			return err;
-
-		if (!(val & mask))
-			return 0;
-
-		usleep_range(1000, 2000);
-	}
-
-	dev_err(chip->dev, "Timeout while waiting for switch\n");
-	return -ETIMEDOUT;
+	return mv88e6xxx_wait_mask(chip, addr, reg, mask, 0x0000);
 }
 
 /* Indirect write to single pointer-data register with an Update bit */
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 8c6d3c906197..95b44532a282 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -588,6 +588,8 @@ static inline bool mv88e6xxx_is_invalid_port(struct mv88e6xxx_chip *chip, int po
 
 int mv88e6xxx_read(struct mv88e6xxx_chip *chip, int addr, int reg, u16 *val);
 int mv88e6xxx_write(struct mv88e6xxx_chip *chip, int addr, int reg, u16 val);
+int mv88e6xxx_wait_mask(struct mv88e6xxx_chip *chip, int addr, int reg,
+			u16 mask, u16 val);
 int mv88e6xxx_update(struct mv88e6xxx_chip *chip, int addr, int reg,
 		     u16 update);
 int mv88e6xxx_wait(struct mv88e6xxx_chip *chip, int addr, int reg, u16 mask);
diff --git a/drivers/net/dsa/mv88e6xxx/global1.c b/drivers/net/dsa/mv88e6xxx/global1.c
index bbd31c9f8b48..482f9f8465af 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.c
+++ b/drivers/net/dsa/mv88e6xxx/global1.c
@@ -32,48 +32,27 @@ int mv88e6xxx_g1_wait(struct mv88e6xxx_chip *chip, int reg, u16 mask)
 	return mv88e6xxx_wait(chip, chip->info->global1_addr, reg, mask);
 }
 
+int mv88e6xxx_g1_wait_mask(struct mv88e6xxx_chip *chip, int reg,
+			   u16 mask, u16 val)
+{
+	return mv88e6xxx_wait_mask(chip, chip->info->global1_addr, reg,
+				   mask, val);
+}
+
 /* Offset 0x00: Switch Global Status Register */
 
 static int mv88e6185_g1_wait_ppu_disabled(struct mv88e6xxx_chip *chip)
 {
-	u16 state;
-	int i, err;
-
-	for (i = 0; i < 16; i++) {
-		err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_STS, &state);
-		if (err)
-			return err;
-
-		/* Check the value of the PPUState bits 15:14 */
-		state &= MV88E6185_G1_STS_PPU_STATE_MASK;
-		if (state == MV88E6185_G1_STS_PPU_STATE_DISABLED)
-			return 0;
-
-		usleep_range(1000, 2000);
-	}
-
-	return -ETIMEDOUT;
+	return mv88e6xxx_g1_wait_mask(chip, MV88E6XXX_G1_STS,
+				      MV88E6185_G1_STS_PPU_STATE_MASK,
+				      MV88E6185_G1_STS_PPU_STATE_DISABLED);
 }
 
 static int mv88e6185_g1_wait_ppu_polling(struct mv88e6xxx_chip *chip)
 {
-	u16 state;
-	int i, err;
-
-	for (i = 0; i < 16; ++i) {
-		err = mv88e6xxx_g1_read(chip, MV88E6XXX_G1_STS, &state);
-		if (err)
-			return err;
-
-		/* Check the value of the PPUState bits 15:14 */
-		state &= MV88E6185_G1_STS_PPU_STATE_MASK;
-		if (state == MV88E6185_G1_STS_PPU_STATE_POLLING)
-			return 0;
-
-		usleep_range(1000, 2000);
-	}
-
-	return -ETIMEDOUT;
+	return mv88e6xxx_g1_wait_mask(chip, MV88E6XXX_G1_STS,
+				      MV88E6185_G1_STS_PPU_STATE_MASK,
+				      MV88E6185_G1_STS_PPU_STATE_POLLING);
 }
 
 static int mv88e6352_g1_wait_ppu_polling(struct mv88e6xxx_chip *chip)
diff --git a/drivers/net/dsa/mv88e6xxx/global1.h b/drivers/net/dsa/mv88e6xxx/global1.h
index d444266f7d78..48869d7984f4 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.h
+++ b/drivers/net/dsa/mv88e6xxx/global1.h
@@ -250,6 +250,8 @@
 int mv88e6xxx_g1_read(struct mv88e6xxx_chip *chip, int reg, u16 *val);
 int mv88e6xxx_g1_write(struct mv88e6xxx_chip *chip, int reg, u16 val);
 int mv88e6xxx_g1_wait(struct mv88e6xxx_chip *chip, int reg, u16 mask);
+int mv88e6xxx_g1_wait_mask(struct mv88e6xxx_chip *chip, int reg,
+			   u16 mask, u16 val);
 
 int mv88e6xxx_g1_set_switch_mac(struct mv88e6xxx_chip *chip, u8 *addr);
 
-- 
2.22.0


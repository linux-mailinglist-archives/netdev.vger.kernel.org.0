Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B13E91864
	for <lists+netdev@lfdr.de>; Sun, 18 Aug 2019 19:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbfHRRgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Aug 2019 13:36:23 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:33268 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726945AbfHRRgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Aug 2019 13:36:20 -0400
Received: by mail-qt1-f193.google.com with SMTP id v38so11697331qtb.0
        for <netdev@vger.kernel.org>; Sun, 18 Aug 2019 10:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oO71kniPK+1M1cROp+mXvyqhfeytILNNMGY0s/SXb68=;
        b=Nuk24iqpJGx7RzEbCB1Vnh3UsqqFswZnB9U06xKDfc3xAiPTMu5rAUFDnfytkm76Mr
         3gLg/kTtzJCcQVtg8ZErcaxsFMWVzi7dU4VshtCerB+GbW4W6q487Fr24RZy0vCiXRlx
         9BCOdMV7jLZbxJumjj4nVuBDzeNWSnnUGk10ACHFd2ZW+tPPD8ezJyKCBjqK/WIQcQcR
         yi2OdS5jF+qjqXzhg+/IZCn6uOutPOzAVcfHUgfWaY81cx9wWb7sfOwqEX6eiSEifxby
         2cXyBU09UlC85I1ZR2f2xWcYNi3tRVUT5VbAudwp73dnYJq40X3BVn5ZIETbw9ttVv7d
         UUIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oO71kniPK+1M1cROp+mXvyqhfeytILNNMGY0s/SXb68=;
        b=iqIOkf9aR0eNuDjkxYIYX3MuXacwmm5iUWR+B2bhLHUW9k1LPD8yBEzYmMpqpCmgpD
         BMgn1T01BckpsMzJwZny3WCtQ4j6MuObAGK9l/SFmSKhVnFl4N7NNLmvAqyjrHkhO3/N
         sWiDpyhQjyJhLB5I6yFYdFIXdTpOGCZFKVzT6fcjXEU50XqQW5m0gIj+Up4T1MlzWmQc
         rMotAKbSQtrnMxUxXIZYGzcfzirJsJR6LjDopy2yNb0HtfTuFP68ydFoOOFJshXiCsAO
         Aw7+3IEHDZA6A84qmTZHBR3tG3Mj49UgtbnD6Sd5UupaADRnEoB19PUCj2QUP3dUOEl+
         2GXA==
X-Gm-Message-State: APjAAAXH9vVnE+pT5vLqAAZt4IqOrXjbR+T4EfXWIwgh2UV3/cFQX2ZP
        IXz7Iu5dFKcZjJiqJpKebAp5ca12
X-Google-Smtp-Source: APXvYqw4Ie3WXa9b1DOt0ti/UVNfZ86Oyqx0VliSYGAKIbsI8c1CMPTHcVVtuCPLPWEhld2LpOqEzg==
X-Received: by 2002:a0c:e28e:: with SMTP id r14mr8216661qvl.32.1566149779592;
        Sun, 18 Aug 2019 10:36:19 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id o34sm7446793qtc.61.2019.08.18.10.36.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Aug 2019 10:36:19 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     marek.behun@nic.cz, davem@davemloft.net, f.fainelli@gmail.com,
        andrew@lunn.ch, Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 6/6] net: dsa: mv88e6xxx: wrap SERDES IRQ in power function
Date:   Sun, 18 Aug 2019 13:35:48 -0400
Message-Id: <20190818173548.19631-7-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190818173548.19631-1-vivien.didelot@gmail.com>
References: <20190818173548.19631-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that mv88e6xxx_serdes_power is only called after driver setup,
we can wrap the SERDES IRQ code directly within it for clarity.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index c72b3db75c54..d0bf98c10b2b 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2057,10 +2057,26 @@ static int mv88e6xxx_setup_egress_floods(struct mv88e6xxx_chip *chip, int port)
 static int mv88e6xxx_serdes_power(struct mv88e6xxx_chip *chip, int port,
 				  bool on)
 {
-	if (chip->info->ops->serdes_power)
-		return chip->info->ops->serdes_power(chip, port, on);
+	int err;
 
-	return 0;
+	if (!chip->info->ops->serdes_power)
+		return 0;
+
+	if (on) {
+		err = chip->info->ops->serdes_power(chip, port, true);
+		if (err)
+			return err;
+
+		if (chip->info->ops->serdes_irq_setup)
+			err = chip->info->ops->serdes_irq_setup(chip, port);
+	} else {
+		if (chip->info->ops->serdes_irq_free)
+			chip->info->ops->serdes_irq_free(chip, port);
+
+		err = chip->info->ops->serdes_power(chip, port, false);
+	}
+
+	return err;
 }
 
 static int mv88e6xxx_setup_upstream_port(struct mv88e6xxx_chip *chip, int port)
@@ -2258,12 +2274,7 @@ static int mv88e6xxx_port_enable(struct dsa_switch *ds, int port,
 	int err;
 
 	mv88e6xxx_reg_lock(chip);
-
 	err = mv88e6xxx_serdes_power(chip, port, true);
-
-	if (!err && chip->info->ops->serdes_irq_setup)
-		err = chip->info->ops->serdes_irq_setup(chip, port);
-
 	mv88e6xxx_reg_unlock(chip);
 
 	return err;
@@ -2274,13 +2285,8 @@ static void mv88e6xxx_port_disable(struct dsa_switch *ds, int port)
 	struct mv88e6xxx_chip *chip = ds->priv;
 
 	mv88e6xxx_reg_lock(chip);
-
-	if (chip->info->ops->serdes_irq_free)
-		chip->info->ops->serdes_irq_free(chip, port);
-
 	if (mv88e6xxx_serdes_power(chip, port, false))
 		dev_err(chip->dev, "failed to power off SERDES\n");
-
 	mv88e6xxx_reg_unlock(chip);
 }
 
-- 
2.22.0


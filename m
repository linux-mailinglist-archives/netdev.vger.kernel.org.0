Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E83B4A4623
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 22:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728634AbfHaUTO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 16:19:14 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:45417 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728609AbfHaUTK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 16:19:10 -0400
Received: by mail-qk1-f196.google.com with SMTP id m2so9187526qki.12
        for <netdev@vger.kernel.org>; Sat, 31 Aug 2019 13:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aeA7vnX+hxk4HIB0o23wd62UAP2S6VqhHb/09ZOMXX4=;
        b=Fp6In2zDJGqRqCnYM+q2AaSccjKMlWxC3Xxz/SN63Jxt2iTiPjNkUh3dPwuYmnUAdO
         /4VLMNOM+0aq/SoG7IXpaa5+LFT2Shlmke7DGs0TgRrVzm1tMvHhW7jYyKtbu6Fe4E6A
         qZ/yNWDYVNrbcAJ+rPBIE4bw/6xLHjW2yrpIa/BTqfcn6xu/xm3ftAGv1ifL+zS059LL
         faeAWqiChf6W/X38mxo9VXi+cZRAuVT+efxc6tSIZOqbCDzK1KoP540XOsTnGkxm9Y+T
         d7n7qHUI8CsNmhi51gNELXJl1OL9Mjqkgtitev8R0Up4sKzGfaVqrLob3kYfP+ewV4kC
         mfVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aeA7vnX+hxk4HIB0o23wd62UAP2S6VqhHb/09ZOMXX4=;
        b=Ii75WweCJB06BUMoXEdm105sVJPjYFJcNl4m2yowv8LnfdwT1px5bbWEBkNsCO5lGm
         tFjCcVPmA+FLICBJdnKlQQWBIniiHUdPf+uJBvr+OTMyI4rqi8g6gKjmmOBrYoAHS4LL
         Ss3gSVka6C8s5fYWcrBt+5WFf7YzVrL/eXsa/74xWMDwF4DywCZ1lny+k9cMM25y7KhS
         fepzXrG7e3py+uBb0MBnS6gYUdzphOvPIa//ACFgLUHTAlLVVZLSzAsTi+HZDcdHilwm
         IAZRyXh7Ju+dDI3NsmS/A6XAODqTpxxNAn0ZlcMIzEqixuhWwXKs2/WEw7xJvN8fk9Uc
         Iq3g==
X-Gm-Message-State: APjAAAUcDAlX576TZPJ4hMFan2B9zGiyYhlvxZ/mnGkYwaXEC5Mpy3Wx
        YU4VsyjrjBF4/9cYfq0OIhWaYZrU
X-Google-Smtp-Source: APXvYqzF15ezhHLmvl7abFQu/7mLfe2pAXFEDr3G1VNtXLdTaFSMzCjn6SmQHJguzg242c7kGEUN1g==
X-Received: by 2002:a37:a702:: with SMTP id q2mr21857596qke.213.1567282748994;
        Sat, 31 Aug 2019 13:19:08 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id 20sm4914185qkg.59.2019.08.31.13.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Aug 2019 13:19:08 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        f.fainelli@gmail.com, andrew@lunn.ch,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 10/10] net: dsa: mv88e6xxx: centralize SERDES IRQ handling
Date:   Sat, 31 Aug 2019 16:18:36 -0400
Message-Id: <20190831201836.19957-11-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190831201836.19957-1-vivien.didelot@gmail.com>
References: <20190831201836.19957-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The .serdes_irq_setup are all following the same steps: get the SERDES
lane, get the IRQ mapping, request the IRQ, then enable it. So do
the .serdes_irq_free implementations: get the SERDES lane, disable
the IRQ, then free it.

This patch removes these operations in favor of generic functions.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c   |  96 +++++++++++++------
 drivers/net/dsa/mv88e6xxx/chip.h   |   2 -
 drivers/net/dsa/mv88e6xxx/serdes.c | 142 -----------------------------
 drivers/net/dsa/mv88e6xxx/serdes.h |   4 -
 4 files changed, 69 insertions(+), 175 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index c2061e20bb32..30365a54c31b 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2054,6 +2054,71 @@ static int mv88e6xxx_setup_egress_floods(struct mv88e6xxx_chip *chip, int port)
 	return 0;
 }
 
+static irqreturn_t mv88e6xxx_serdes_irq_thread_fn(int irq, void *dev_id)
+{
+	struct mv88e6xxx_port *mvp = dev_id;
+	struct mv88e6xxx_chip *chip = mvp->chip;
+	irqreturn_t ret = IRQ_NONE;
+	int port = mvp->port;
+	u8 lane;
+
+	mv88e6xxx_reg_lock(chip);
+	lane = mv88e6xxx_serdes_get_lane(chip, port);
+	if (lane)
+		ret = mv88e6xxx_serdes_irq_status(chip, port, lane);
+	mv88e6xxx_reg_unlock(chip);
+
+	return ret;
+}
+
+static int mv88e6xxx_serdes_irq_request(struct mv88e6xxx_chip *chip, int port,
+					u8 lane)
+{
+	struct mv88e6xxx_port *dev_id = &chip->ports[port];
+	unsigned int irq;
+	int err;
+
+	/* Nothing to request if this SERDES port has no IRQ */
+	irq = mv88e6xxx_serdes_irq_mapping(chip, port);
+	if (!irq)
+		return 0;
+
+	/* Requesting the IRQ will trigger IRQ callbacks, so release the lock */
+	mv88e6xxx_reg_unlock(chip);
+	err = request_threaded_irq(irq, NULL, mv88e6xxx_serdes_irq_thread_fn,
+				   IRQF_ONESHOT, "mv88e6xxx-serdes", dev_id);
+	mv88e6xxx_reg_lock(chip);
+	if (err)
+		return err;
+
+	dev_id->serdes_irq = irq;
+
+	return mv88e6xxx_serdes_irq_enable(chip, port, lane);
+}
+
+static int mv88e6xxx_serdes_irq_free(struct mv88e6xxx_chip *chip, int port,
+				     u8 lane)
+{
+	struct mv88e6xxx_port *dev_id = &chip->ports[port];
+	unsigned int irq = dev_id->serdes_irq;
+	int err;
+
+	/* Nothing to free if no IRQ has been requested */
+	if (!irq)
+		return 0;
+
+	err = mv88e6xxx_serdes_irq_disable(chip, port, lane);
+
+	/* Freeing the IRQ will trigger IRQ callbacks, so release the lock */
+	mv88e6xxx_reg_unlock(chip);
+	free_irq(irq, dev_id);
+	mv88e6xxx_reg_lock(chip);
+
+	dev_id->serdes_irq = 0;
+
+	return err;
+}
+
 static int mv88e6xxx_serdes_power(struct mv88e6xxx_chip *chip, int port,
 				  bool on)
 {
@@ -2069,12 +2134,11 @@ static int mv88e6xxx_serdes_power(struct mv88e6xxx_chip *chip, int port,
 		if (err)
 			return err;
 
-		if (chip->info->ops->serdes_irq_setup)
-			err = chip->info->ops->serdes_irq_setup(chip, port);
+		err = mv88e6xxx_serdes_irq_request(chip, port, lane);
 	} else {
-		if (chip->info->ops->serdes_irq_free &&
-		    chip->ports[port].serdes_irq)
-			chip->info->ops->serdes_irq_free(chip, port);
+		err = mv88e6xxx_serdes_irq_free(chip, port, lane);
+		if (err)
+			return err;
 
 		err = mv88e6xxx_serdes_power_down(chip, port, lane);
 	}
@@ -2936,8 +3000,6 @@ static const struct mv88e6xxx_ops mv88e6141_ops = {
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
 	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
 	.serdes_irq_status = mv88e6390_serdes_irq_status,
-	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
-	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.phylink_validate = mv88e6341_phylink_validate,
 };
@@ -3188,8 +3250,6 @@ static const struct mv88e6xxx_ops mv88e6176_ops = {
 	.serdes_irq_mapping = mv88e6352_serdes_irq_mapping,
 	.serdes_irq_enable = mv88e6352_serdes_irq_enable,
 	.serdes_irq_status = mv88e6352_serdes_irq_status,
-	.serdes_irq_setup = mv88e6352_serdes_irq_setup,
-	.serdes_irq_free = mv88e6352_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.phylink_validate = mv88e6352_phylink_validate,
 };
@@ -3274,8 +3334,6 @@ static const struct mv88e6xxx_ops mv88e6190_ops = {
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
 	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
 	.serdes_irq_status = mv88e6390_serdes_irq_status,
-	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
-	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.phylink_validate = mv88e6390_phylink_validate,
 };
@@ -3324,8 +3382,6 @@ static const struct mv88e6xxx_ops mv88e6190x_ops = {
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
 	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
 	.serdes_irq_status = mv88e6390_serdes_irq_status,
-	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
-	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.phylink_validate = mv88e6390x_phylink_validate,
 };
@@ -3374,8 +3430,6 @@ static const struct mv88e6xxx_ops mv88e6191_ops = {
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
 	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
 	.serdes_irq_status = mv88e6390_serdes_irq_status,
-	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
-	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
 	.phylink_validate = mv88e6390_phylink_validate,
@@ -3426,8 +3480,6 @@ static const struct mv88e6xxx_ops mv88e6240_ops = {
 	.serdes_irq_mapping = mv88e6352_serdes_irq_mapping,
 	.serdes_irq_enable = mv88e6352_serdes_irq_enable,
 	.serdes_irq_status = mv88e6352_serdes_irq_status,
-	.serdes_irq_setup = mv88e6352_serdes_irq_setup,
-	.serdes_irq_free = mv88e6352_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6352_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
@@ -3518,8 +3570,6 @@ static const struct mv88e6xxx_ops mv88e6290_ops = {
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
 	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
 	.serdes_irq_status = mv88e6390_serdes_irq_status,
-	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
-	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
@@ -3658,8 +3708,6 @@ static const struct mv88e6xxx_ops mv88e6341_ops = {
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
 	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
 	.serdes_irq_status = mv88e6390_serdes_irq_status,
-	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
-	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
@@ -3793,8 +3841,6 @@ static const struct mv88e6xxx_ops mv88e6352_ops = {
 	.serdes_irq_mapping = mv88e6352_serdes_irq_mapping,
 	.serdes_irq_enable = mv88e6352_serdes_irq_enable,
 	.serdes_irq_status = mv88e6352_serdes_irq_status,
-	.serdes_irq_setup = mv88e6352_serdes_irq_setup,
-	.serdes_irq_free = mv88e6352_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6352_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
@@ -3850,8 +3896,6 @@ static const struct mv88e6xxx_ops mv88e6390_ops = {
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
 	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
 	.serdes_irq_status = mv88e6390_serdes_irq_status,
-	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
-	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
@@ -3904,8 +3948,6 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
 	.serdes_irq_mapping = mv88e6390_serdes_irq_mapping,
 	.serdes_irq_enable = mv88e6390_serdes_irq_enable,
 	.serdes_irq_status = mv88e6390_serdes_irq_status,
-	.serdes_irq_setup = mv88e6390_serdes_irq_setup,
-	.serdes_irq_free = mv88e6390_serdes_irq_free,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 9a73fd1d643b..6bc0a4e4fe7b 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -450,8 +450,6 @@ struct mv88e6xxx_ops {
 	/* SERDES interrupt handling */
 	unsigned int (*serdes_irq_mapping)(struct mv88e6xxx_chip *chip,
 					   int port);
-	int (*serdes_irq_setup)(struct mv88e6xxx_chip *chip, int port);
-	void (*serdes_irq_free)(struct mv88e6xxx_chip *chip, int port);
 	int (*serdes_irq_enable)(struct mv88e6xxx_chip *chip, int port, u8 lane,
 				 bool enable);
 	irqreturn_t (*serdes_irq_status)(struct mv88e6xxx_chip *chip, int port,
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index d37419ba26ab..902feb398746 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -221,19 +221,6 @@ irqreturn_t mv88e6352_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
 	return ret;
 }
 
-static irqreturn_t mv88e6352_serdes_thread_fn(int irq, void *dev_id)
-{
-	struct mv88e6xxx_port *port = dev_id;
-	struct mv88e6xxx_chip *chip = port->chip;
-	irqreturn_t ret = IRQ_NONE;
-
-	mv88e6xxx_reg_lock(chip);
-	ret = mv88e6xxx_serdes_irq_status(chip, port->port, 0);
-	mv88e6xxx_reg_unlock(chip);
-
-	return ret;
-}
-
 int mv88e6352_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, u8 lane,
 				bool enable)
 {
@@ -250,61 +237,6 @@ unsigned int mv88e6352_serdes_irq_mapping(struct mv88e6xxx_chip *chip, int port)
 	return irq_find_mapping(chip->g2_irq.domain, MV88E6352_SERDES_IRQ);
 }
 
-int mv88e6352_serdes_irq_setup(struct mv88e6xxx_chip *chip, int port)
-{
-	unsigned int irq;
-	u8 lane;
-	int err;
-
-	lane = mv88e6xxx_serdes_get_lane(chip, port);
-	if (!lane)
-		return 0;
-
-	irq = mv88e6xxx_serdes_irq_mapping(chip, port);
-	if (!irq)
-		return 0;
-
-	chip->ports[port].serdes_irq = irq;
-
-	/* Requesting the IRQ will trigger irq callbacks. So we cannot
-	 * hold the reg_lock.
-	 */
-	mv88e6xxx_reg_unlock(chip);
-	err = request_threaded_irq(chip->ports[port].serdes_irq, NULL,
-				   mv88e6352_serdes_thread_fn,
-				   IRQF_ONESHOT, "mv88e6xxx-serdes",
-				   &chip->ports[port]);
-	mv88e6xxx_reg_lock(chip);
-
-	if (err) {
-		dev_err(chip->dev, "Unable to request SERDES interrupt: %d\n",
-			err);
-		return err;
-	}
-
-	return mv88e6xxx_serdes_irq_enable(chip, port, lane);
-}
-
-void mv88e6352_serdes_irq_free(struct mv88e6xxx_chip *chip, int port)
-{
-	u8 lane;
-
-	lane = mv88e6xxx_serdes_get_lane(chip, port);
-	if (!lane)
-		return;
-
-	mv88e6xxx_serdes_irq_disable(chip, port, lane);
-
-	/* Freeing the IRQ will trigger irq callbacks. So we cannot
-	 * hold the reg_lock.
-	 */
-	mv88e6xxx_reg_unlock(chip);
-	free_irq(chip->ports[port].serdes_irq, &chip->ports[port]);
-	mv88e6xxx_reg_lock(chip);
-
-	chip->ports[port].serdes_irq = 0;
-}
-
 u8 mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 {
 	u8 cmode = chip->ports[port].cmode;
@@ -622,81 +554,7 @@ irqreturn_t mv88e6390_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
 	return ret;
 }
 
-static irqreturn_t mv88e6390_serdes_thread_fn(int irq, void *dev_id)
-{
-	struct mv88e6xxx_port *port = dev_id;
-	struct mv88e6xxx_chip *chip = port->chip;
-	irqreturn_t ret = IRQ_NONE;
-	u8 lane;
-
-	mv88e6xxx_reg_lock(chip);
-	lane = mv88e6xxx_serdes_get_lane(chip, port->port);
-	if (!lane)
-		goto out;
-
-	ret = mv88e6xxx_serdes_irq_status(chip, port->port, lane);
-out:
-	mv88e6xxx_reg_unlock(chip);
-
-	return ret;
-}
-
 unsigned int mv88e6390_serdes_irq_mapping(struct mv88e6xxx_chip *chip, int port)
 {
 	return irq_find_mapping(chip->g2_irq.domain, port);
 }
-
-int mv88e6390_serdes_irq_setup(struct mv88e6xxx_chip *chip, int port)
-{
-	unsigned int irq;
-	int err;
-	u8 lane;
-
-	lane = mv88e6xxx_serdes_get_lane(chip, port);
-	if (!lane)
-		return 0;
-
-	irq = mv88e6xxx_serdes_irq_mapping(chip, port);
-	if (!irq)
-		return 0;
-
-	chip->ports[port].serdes_irq = irq;
-
-	/* Requesting the IRQ will trigger irq callbacks. So we cannot
-	 * hold the reg_lock.
-	 */
-	mv88e6xxx_reg_unlock(chip);
-	err = request_threaded_irq(chip->ports[port].serdes_irq, NULL,
-				   mv88e6390_serdes_thread_fn,
-				   IRQF_ONESHOT, "mv88e6xxx-serdes",
-				   &chip->ports[port]);
-	mv88e6xxx_reg_lock(chip);
-
-	if (err) {
-		dev_err(chip->dev, "Unable to request SERDES interrupt: %d\n",
-			err);
-		return err;
-	}
-
-	return mv88e6xxx_serdes_irq_enable(chip, port, lane);
-}
-
-void mv88e6390_serdes_irq_free(struct mv88e6xxx_chip *chip, int port)
-{
-	u8 lane;
-
-	lane = mv88e6xxx_serdes_get_lane(chip, port);
-	if (!lane)
-		return;
-
-	mv88e6xxx_serdes_irq_disable(chip, port, lane);
-
-	/* Freeing the IRQ will trigger irq callbacks. So we cannot
-	 * hold the reg_lock.
-	 */
-	mv88e6xxx_reg_unlock(chip);
-	free_irq(chip->ports[port].serdes_irq, &chip->ports[port]);
-	mv88e6xxx_reg_lock(chip);
-
-	chip->ports[port].serdes_irq = 0;
-}
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index 52f937347a36..bd8df36ab537 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -86,8 +86,6 @@ int mv88e6352_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lane,
 			   bool on);
 int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lane,
 			   bool on);
-int mv88e6390_serdes_irq_setup(struct mv88e6xxx_chip *chip, int port);
-void mv88e6390_serdes_irq_free(struct mv88e6xxx_chip *chip, int port);
 int mv88e6352_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, u8 lane,
 				bool enable);
 int mv88e6390_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, u8 lane,
@@ -101,8 +99,6 @@ int mv88e6352_serdes_get_strings(struct mv88e6xxx_chip *chip,
 				 int port, uint8_t *data);
 int mv88e6352_serdes_get_stats(struct mv88e6xxx_chip *chip, int port,
 			       uint64_t *data);
-int mv88e6352_serdes_irq_setup(struct mv88e6xxx_chip *chip, int port);
-void mv88e6352_serdes_irq_free(struct mv88e6xxx_chip *chip, int port);
 
 /* Return the (first) SERDES lane address a port is using, 0 otherwise. */
 static inline u8 mv88e6xxx_serdes_get_lane(struct mv88e6xxx_chip *chip,
-- 
2.23.0


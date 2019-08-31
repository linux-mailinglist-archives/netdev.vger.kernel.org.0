Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5048A4621
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 22:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbfHaUTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 16:19:10 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:38656 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728571AbfHaUTD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 16:19:03 -0400
Received: by mail-qk1-f194.google.com with SMTP id u190so9257089qkh.5
        for <netdev@vger.kernel.org>; Sat, 31 Aug 2019 13:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3lvvaIIMGfshM9qRKxeReYTC/8NBJeyG8bxN2jd5O4M=;
        b=a7GRQu5I/q4NaYfVsRV4tXTp+f8U0uz4DqCPdxFdgFH+T6ExGv741SNCC8gF82HgLG
         /ebTKF8IIGEPvmieeKXBZwyMqIujfkmKM/sAvhjmx18BefDmPXSL1Y+sjSZxtWq3p7E5
         WDFyXAbmKabBQ7WSws7Hqh585GJ4JSd8nWkE7xyOvUOOWnYNzgaTFGqJk4gwUAkTh9q6
         ur2RkzWixLjjQ4rDY40+ftlfmn58+ZSUCGUNYV7Vwu6xaB4wCQ1bXEAxnskCe6wB+mBZ
         a3OgsQjS3xUlxEI6HbLVcOy6wHSufqWpq/mLI40rpqkb8aF/wlkHUE8tF3BOvwuz3yUS
         ZPWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3lvvaIIMGfshM9qRKxeReYTC/8NBJeyG8bxN2jd5O4M=;
        b=eVL0BEoQiAWKwI9tNmba51s0dVjYJ5ucDC7MzodKyqemblVqB87lKdc41gHD49Dsl3
         1aiiocG+vuwZH8BDwyslCOP9Y4bk74YUHfQamtk7VXZGSq+IjKSL1zegdGsURTQMGsK9
         ODbrdHcwLpS900b1SmnoGQcL/xQwWLh7Fb4wW6oKGplwrxhjcEiyT/yR4PUsbOfHQK0A
         yljZbsTfnFLs1lEVK1YKxFSK6S0v+LY2SsoWGnkbZVAQpfpg/p2090QzqskSZvdAFm3N
         x2drunzgxaXp+R9JBss2wulHgGR4HBsPRTjivYgMN393twGbrkYaY6GByNaaoKi1+iUS
         KnSQ==
X-Gm-Message-State: APjAAAWfwUU2DOl4QwzSkgmYRaoyIUhbuDHGgeeEAcqai7OUkbbdjVLn
        fU2wiJJyVCqNgkkpkIGGiiL6il9z
X-Google-Smtp-Source: APXvYqzJcgVyZTLDGaZZuM/sF1JUh7AR665kCkeaTPTw1dLfzEG58fM/omtTLcP0NsEt1J5irx/HCw==
X-Received: by 2002:a05:620a:5b5:: with SMTP id q21mr9448901qkq.160.1567282742184;
        Sat, 31 Aug 2019 13:19:02 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id z4sm4388759qtd.60.2019.08.31.13.19.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Aug 2019 13:19:01 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        f.fainelli@gmail.com, andrew@lunn.ch,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 05/10] net: dsa: mv88e6xxx: implement mv88e6352_serdes_get_lane
Date:   Sat, 31 Aug 2019 16:18:31 -0400
Message-Id: <20190831201836.19957-6-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190831201836.19957-1-vivien.didelot@gmail.com>
References: <20190831201836.19957-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Even though 88E6352 has no dedicated lane for SERDES interfaces, it
uses a similar code as the other .serdes_get_lane implementations to
check the port's CMODE and ensure that SERDES operations are doable.

For consistency, implement mv88e6352_serdes_get_lane for the 88E6352
and similar switches which simply returns an unused 0xff lane address.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c   |  4 ++++
 drivers/net/dsa/mv88e6xxx/serdes.c | 11 ++++++++++-
 drivers/net/dsa/mv88e6xxx/serdes.h |  1 +
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 0ab4ce86eda7..3962e7368ae5 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3093,6 +3093,7 @@ static const struct mv88e6xxx_ops mv88e6172_ops = {
 	.rmu_disable = mv88e6352_g1_rmu_disable,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
+	.serdes_get_lane = mv88e6352_serdes_get_lane,
 	.serdes_power = mv88e6352_serdes_power,
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.phylink_validate = mv88e6352_phylink_validate,
@@ -3178,6 +3179,7 @@ static const struct mv88e6xxx_ops mv88e6176_ops = {
 	.rmu_disable = mv88e6352_g1_rmu_disable,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
+	.serdes_get_lane = mv88e6352_serdes_get_lane,
 	.serdes_power = mv88e6352_serdes_power,
 	.serdes_irq_mapping = mv88e6352_serdes_irq_mapping,
 	.serdes_irq_setup = mv88e6352_serdes_irq_setup,
@@ -3407,6 +3409,7 @@ static const struct mv88e6xxx_ops mv88e6240_ops = {
 	.rmu_disable = mv88e6352_g1_rmu_disable,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
+	.serdes_get_lane = mv88e6352_serdes_get_lane,
 	.serdes_power = mv88e6352_serdes_power,
 	.serdes_irq_mapping = mv88e6352_serdes_irq_mapping,
 	.serdes_irq_setup = mv88e6352_serdes_irq_setup,
@@ -3767,6 +3770,7 @@ static const struct mv88e6xxx_ops mv88e6352_ops = {
 	.rmu_disable = mv88e6352_g1_rmu_disable,
 	.vtu_getnext = mv88e6352_g1_vtu_getnext,
 	.vtu_loadpurge = mv88e6352_g1_vtu_loadpurge,
+	.serdes_get_lane = mv88e6352_serdes_get_lane,
 	.serdes_power = mv88e6352_serdes_power,
 	.serdes_irq_mapping = mv88e6352_serdes_irq_mapping,
 	.serdes_irq_setup = mv88e6352_serdes_irq_setup,
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index ce6d97e5caf8..9fb2773a3eb5 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -69,13 +69,22 @@ static int mv88e6352_serdes_power_set(struct mv88e6xxx_chip *chip, bool on)
 	return err;
 }
 
-static bool mv88e6352_port_has_serdes(struct mv88e6xxx_chip *chip, int port)
+u8 mv88e6352_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 {
 	u8 cmode = chip->ports[port].cmode;
+	u8 lane = 0;
 
 	if ((cmode == MV88E6XXX_PORT_STS_CMODE_100BASEX) ||
 	    (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASEX) ||
 	    (cmode == MV88E6XXX_PORT_STS_CMODE_SGMII))
+		lane = 0xff; /* Unused */
+
+	return lane;
+}
+
+static bool mv88e6352_port_has_serdes(struct mv88e6xxx_chip *chip, int port)
+{
+	if (mv88e6xxx_serdes_get_lane(chip, port))
 		return true;
 
 	return false;
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index 4718dcca6b3c..7df27a0de9aa 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -75,6 +75,7 @@
 #define MV88E6390_SGMII_PHY_STATUS_LINK		BIT(10)
 
 u8 mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
+u8 mv88e6352_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
 u8 mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
 u8 mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
 unsigned int mv88e6352_serdes_irq_mapping(struct mv88e6xxx_chip *chip,
-- 
2.23.0


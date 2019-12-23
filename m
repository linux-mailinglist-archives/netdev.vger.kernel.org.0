Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3D11291AD
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 06:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbfLWFxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 00:53:35 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53456 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbfLWFxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 00:53:34 -0500
Received: by mail-wm1-f68.google.com with SMTP id m24so14722982wmc.3
        for <netdev@vger.kernel.org>; Sun, 22 Dec 2019 21:53:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MpSSRcI4KCICoqYiT4RU36HXXCG2W7Ox+7BQmFwmRUE=;
        b=CHIMulI0ienLDCxEtjeXe0XgkBoPlbyk5ceWwMHZjrqU92Tarv1EUxp4Ebqm2YB95I
         raAv/JQjMcOqZxnx+Wzz33z5AMvTvMf5rw4E/fjJ4VegPYx9NsoBwqlpQMGe3LwDxt2q
         TWH0L9hYz2PRBUiDeN39S4u1C2eldNc/CayqS2lvzMswkKBDOuHEN0qg+a40hChVQAJA
         B8/CzrVJM8SHZR14d5j28xNLfVhR6Gme43ev+ym/ZVD84eFEZKbYiJs71jziG6VIILuf
         6ihFnzBSv8ndv2Y6/8AqFsZ4ZEUH5xLk89lkbpDRC7s4+EkEsV79/VF1I6cLZ+JVxBG1
         Vqaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MpSSRcI4KCICoqYiT4RU36HXXCG2W7Ox+7BQmFwmRUE=;
        b=lzWTQpWVvtly29uOuE5p9iEkTq9AICIClsJNztRcvj5TH5L7dKoQyA6w3u4gc2U7H+
         qpNueIaAehuNmIEaAkBMnfq/LApFluz30BV9680Zr8578y8Sm+4vtLf2KTsIxQqUb0X4
         8R7+I68qfKYGx6b23UimYGvrROCdEqHtiHm2bW6NlEU1ofNsCqUD5cAAdy6SZK0GVODo
         GT224fxY37ggphagF+G1z6oqbVGr6QkpUWQzsbbWdysurgXZ7hB890WtXEumJ0QhgCmw
         ypQ5O/E2z28gRwMqTCiO556dbPvBLtW5LVHOFw91BFsdkU7Y3AXISiayPkQlOEKGPNNu
         3hrQ==
X-Gm-Message-State: APjAAAVvsj2c+yB6Od7TbrBXoZDKqJNjv+9xspWkA5yN8AaN5vtQ3D8d
        dq6x2n6mXmg3VupkaWP2UrPZsQ==
X-Google-Smtp-Source: APXvYqxHo2pz/vVh2KR2aA778FK2xtwAX0ixNpuEKo520QRL6CVcUC1TxH08h/x2Va1d384eUaorwA==
X-Received: by 2002:a7b:c5d8:: with SMTP id n24mr28395486wmk.124.1577080411239;
        Sun, 22 Dec 2019 21:53:31 -0800 (PST)
Received: from cobook.home (nikaet.starlink.ru. [94.141.168.29])
        by smtp.gmail.com with ESMTPSA id x26sm17619012wmc.30.2019.12.22.21.53.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Dec 2019 21:53:30 -0800 (PST)
From:   Nikita Yushchenko <nikita.yoush@cogentembedded.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Healy <cphealy@gmail.com>,
        Nikita Yushchenko <nikita.yoush@cogentembedded.com>
Subject: [PATCH] mv88e6xxx: Add serdes Rx statistics
Date:   Mon, 23 Dec 2019 08:53:24 +0300
Message-Id: <20191223055324.26396-1-nikita.yoush@cogentembedded.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If packet checker is enabled in the serdes, then Rx counter registers
start working, and no side effects have been detected.

This patch enables packet checker automatically when powering serdes on,
and exposes Rx counter registers via ethtool statistics interface.

Code partially basded by older attempt by Andrew Lunn.

Signed-off-by: Nikita Yushchenko <nikita.yoush@cogentembedded.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c   |  3 +
 drivers/net/dsa/mv88e6xxx/serdes.c | 98 +++++++++++++++++++++++++++++-
 drivers/net/dsa/mv88e6xxx/serdes.h |  9 +++
 3 files changed, 107 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 6787d560e9e3..69813de099c3 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -4115,6 +4115,9 @@ static const struct mv88e6xxx_ops mv88e6390_ops = {
 	.gpio_ops = &mv88e6352_gpio_ops,
 	.avb_ops = &mv88e6390_avb_ops,
 	.ptp_ops = &mv88e6352_ptp_ops,
+	.serdes_get_sset_count = mv88e6390_serdes_get_sset_count,
+	.serdes_get_strings = mv88e6390_serdes_get_strings,
+	.serdes_get_stats = mv88e6390_serdes_get_stats,
 	.phylink_validate = mv88e6390_phylink_validate,
 };
 
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 902feb398746..a9da37d0825d 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -405,22 +405,114 @@ static int mv88e6390_serdes_power_sgmii(struct mv88e6xxx_chip *chip, u8 lane,
 	return err;
 }
 
+struct mv88e6390_serdes_hw_stat {
+	char string[ETH_GSTRING_LEN];
+	int reg;
+};
+
+static struct mv88e6390_serdes_hw_stat mv88e6390_serdes_hw_stats[] = {
+	{ "serdes_rx_pkts", 0xf021 },
+	{ "serdes_rx_bytes", 0xf024 },
+	{ "serdes_rx_pkts_error", 0xf027 },
+};
+
+int mv88e6390_serdes_get_sset_count(struct mv88e6xxx_chip *chip, int port)
+{
+	if (mv88e6390_serdes_get_lane(chip, port) == 0)
+		return 0;
+
+	return ARRAY_SIZE(mv88e6390_serdes_hw_stats);
+}
+
+int mv88e6390_serdes_get_strings(struct mv88e6xxx_chip *chip,
+				 int port, uint8_t *data)
+{
+	struct mv88e6390_serdes_hw_stat *stat;
+	int i;
+
+	if (mv88e6390_serdes_get_lane(chip, port) == 0)
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(mv88e6390_serdes_hw_stats); i++) {
+		stat = &mv88e6390_serdes_hw_stats[i];
+		memcpy(data + i * ETH_GSTRING_LEN, stat->string,
+		       ETH_GSTRING_LEN);
+	}
+	return ARRAY_SIZE(mv88e6390_serdes_hw_stats);
+}
+
+static uint64_t mv88e6390_serdes_get_stat(struct mv88e6xxx_chip *chip, int lane,
+					  struct mv88e6390_serdes_hw_stat *stat)
+{
+	u16 reg[3];
+	int err, i;
+
+	for (i = 0; i < 3; i++) {
+		err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
+					    stat->reg + i, &reg[i]);
+		if (err) {
+			dev_err(chip->dev, "failed to read statistic\n");
+			return 0;
+		}
+	}
+
+	return reg[0] | ((u64)reg[1] << 16) | ((u64)reg[2] << 32);
+}
+
+int mv88e6390_serdes_get_stats(struct mv88e6xxx_chip *chip, int port,
+			       uint64_t *data)
+{
+	struct mv88e6390_serdes_hw_stat *stat;
+	int lane;
+	int i;
+
+	lane = mv88e6390_serdes_get_lane(chip, port);
+	if (lane == 0)
+		return 0;
+
+	for (i = 0; i < ARRAY_SIZE(mv88e6390_serdes_hw_stats); i++) {
+		stat = &mv88e6390_serdes_hw_stats[i];
+		data[i] = mv88e6390_serdes_get_stat(chip, lane, stat);
+	}
+
+	return ARRAY_SIZE(mv88e6390_serdes_hw_stats);
+}
+
+static int mv88e6390_serdes_enable_checker(struct mv88e6xxx_chip *chip, u8 lane)
+{
+	u16 reg;
+	int ret;
+
+	ret = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
+				    MV88E6390_PG_CONTROL, &reg);
+	if (ret)
+		return ret;
+
+	reg |= MV88E6390_PG_CONTROL_ENABLE_PC;
+	return mv88e6390_serdes_write(chip, lane, MDIO_MMD_PHYXS,
+				      MV88E6390_PG_CONTROL, reg);
+}
+
 int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lane,
 			   bool up)
 {
 	u8 cmode = chip->ports[port].cmode;
+	int ret = 0;
 
 	switch (cmode) {
 	case MV88E6XXX_PORT_STS_CMODE_SGMII:
 	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:
 	case MV88E6XXX_PORT_STS_CMODE_2500BASEX:
-		return mv88e6390_serdes_power_sgmii(chip, lane, up);
+		ret = mv88e6390_serdes_power_sgmii(chip, lane, up);
 	case MV88E6XXX_PORT_STS_CMODE_XAUI:
 	case MV88E6XXX_PORT_STS_CMODE_RXAUI:
-		return mv88e6390_serdes_power_10g(chip, lane, up);
+		ret = mv88e6390_serdes_power_10g(chip, lane, up);
 	}
 
-	return 0;
+	if (!ret && up)
+		ret = mv88e6390_serdes_enable_checker(chip, lane);
+
+	return ret;
 }
 
 static void mv88e6390_serdes_irq_link_sgmii(struct mv88e6xxx_chip *chip,
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index bd8df36ab537..d16ef4da20b0 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -74,6 +74,10 @@
 #define MV88E6390_SGMII_PHY_STATUS_SPD_DPL_VALID BIT(11)
 #define MV88E6390_SGMII_PHY_STATUS_LINK		BIT(10)
 
+/* Packet generator pad packet checker */
+#define MV88E6390_PG_CONTROL		0xf010
+#define MV88E6390_PG_CONTROL_ENABLE_PC		BIT(0)
+
 u8 mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
 u8 mv88e6352_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
 u8 mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
@@ -99,6 +103,11 @@ int mv88e6352_serdes_get_strings(struct mv88e6xxx_chip *chip,
 				 int port, uint8_t *data);
 int mv88e6352_serdes_get_stats(struct mv88e6xxx_chip *chip, int port,
 			       uint64_t *data);
+int mv88e6390_serdes_get_sset_count(struct mv88e6xxx_chip *chip, int port);
+int mv88e6390_serdes_get_strings(struct mv88e6xxx_chip *chip,
+				 int port, uint8_t *data);
+int mv88e6390_serdes_get_stats(struct mv88e6xxx_chip *chip, int port,
+			       uint64_t *data);
 
 /* Return the (first) SERDES lane address a port is using, 0 otherwise. */
 static inline u8 mv88e6xxx_serdes_get_lane(struct mv88e6xxx_chip *chip,
-- 
2.20.1


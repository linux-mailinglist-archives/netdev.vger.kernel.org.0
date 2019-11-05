Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDD9EF1B5
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 01:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387479AbfKEANw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 19:13:52 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48930 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387472AbfKEANw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 19:13:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lRJeu4BUwTjG91M73uehl8xMRwFYC93NOrAiJbYW5bs=; b=1xjbhW+pqyOt+jTuzDN8/Gu5TK
        2LQ1lHH5t/Vcz7YvO90WQAVLjL4qcejHdGM/16onjpvQQ84DwHHtwlRexUY1jJyo07qXaWv/3DTry
        8CUY1wBPilkR/IirdqrennHHtghLhMcc6YKZi/v22aPmUl4nCVqYwAXKlF2gd+hFQRqE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iRmTD-0007I0-3W; Tue, 05 Nov 2019 01:13:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>, jiri@mellanox.com,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 3/5] net: dsa: mv88e6xxx: global2: Expose ATU stats register
Date:   Tue,  5 Nov 2019 01:12:59 +0100
Message-Id: <20191105001301.27966-4-andrew@lunn.ch>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191105001301.27966-1-andrew@lunn.ch>
References: <20191105001301.27966-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add helpers to set/get the ATU statistics register.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/global2.c | 20 ++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/global2.h | 24 +++++++++++++++++++++++-
 2 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/global2.c b/drivers/net/dsa/mv88e6xxx/global2.c
index bdbb72fc20ed..14954d92c564 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.c
+++ b/drivers/net/dsa/mv88e6xxx/global2.c
@@ -280,6 +280,26 @@ int mv88e6xxx_g2_set_switch_mac(struct mv88e6xxx_chip *chip, u8 *addr)
 	return err;
 }
 
+/* Offset 0x0E: ATU Statistics */
+
+int mv88e6xxx_g2_atu_stats_set(struct mv88e6xxx_chip *chip, u16 kind, u16 bin)
+{
+	return mv88e6xxx_g2_write(chip, MV88E6XXX_G2_ATU_STATS,
+				  kind | bin);
+}
+
+int mv88e6xxx_g2_atu_stats_get(struct mv88e6xxx_chip *chip)
+{
+	int err;
+	u16 val;
+
+	err = mv88e6xxx_g2_read(chip, MV88E6XXX_G2_ATU_STATS, &val);
+	if (err)
+		return err;
+
+	return val & MV88E6XXX_G2_ATU_STATS_MASK;
+}
+
 /* Offset 0x0F: Priority Override Table */
 
 static int mv88e6xxx_g2_pot_write(struct mv88e6xxx_chip *chip, int pointer,
diff --git a/drivers/net/dsa/mv88e6xxx/global2.h b/drivers/net/dsa/mv88e6xxx/global2.h
index 42da4bca73e8..a308ca7a7da6 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.h
+++ b/drivers/net/dsa/mv88e6xxx/global2.h
@@ -113,7 +113,16 @@
 #define MV88E6XXX_G2_SWITCH_MAC_DATA_MASK	0x00ff
 
 /* Offset 0x0E: ATU Stats Register */
-#define MV88E6XXX_G2_ATU_STATS		0x0e
+#define MV88E6XXX_G2_ATU_STATS				0x0e
+#define MV88E6XXX_G2_ATU_STATS_BIN_0			(0x0 << 14)
+#define MV88E6XXX_G2_ATU_STATS_BIN_1			(0x1 << 14)
+#define MV88E6XXX_G2_ATU_STATS_BIN_2			(0x2 << 14)
+#define MV88E6XXX_G2_ATU_STATS_BIN_3			(0x3 << 14)
+#define MV88E6XXX_G2_ATU_STATS_MODE_ALL			(0x0 << 12)
+#define MV88E6XXX_G2_ATU_STATS_MODE_ALL_DYNAMIC		(0x1 << 12)
+#define MV88E6XXX_G2_ATU_STATS_MODE_FID_ALL		(0x2 << 12)
+#define MV88E6XXX_G2_ATU_STATS_MODE_FID_ALL_DYNAMIC	(0x3 << 12)
+#define MV88E6XXX_G2_ATU_STATS_MASK			0x0fff
 
 /* Offset 0x0F: Priority Override Table */
 #define MV88E6XXX_G2_PRIO_OVERRIDE		0x0f
@@ -353,6 +362,8 @@ extern const struct mv88e6xxx_gpio_ops mv88e6352_gpio_ops;
 
 int mv88e6xxx_g2_scratch_gpio_set_smi(struct mv88e6xxx_chip *chip,
 				      bool external);
+int mv88e6xxx_g2_atu_stats_set(struct mv88e6xxx_chip *chip, u16 kind, u16 bin);
+int mv88e6xxx_g2_atu_stats_get(struct mv88e6xxx_chip *chip);
 
 #else /* !CONFIG_NET_DSA_MV88E6XXX_GLOBAL2 */
 
@@ -515,6 +526,17 @@ static inline int mv88e6xxx_g2_device_mapping_write(struct mv88e6xxx_chip *chip,
 	return -EOPNOTSUPP;
 }
 
+static inline int mv88e6xxx_g2_atu_stats_set(struct mv88e6xxx_chip *chip,
+					     u16 kind, u16 bin)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int mv88e6xxx_g2_atu_stats_get(struct mv88e6xxx_chip *chip)
+{
+	return -EOPNOTSUPP;
+}
+
 #endif /* CONFIG_NET_DSA_MV88E6XXX_GLOBAL2 */
 
 #endif /* _MV88E6XXX_GLOBAL2_H */
-- 
2.23.0


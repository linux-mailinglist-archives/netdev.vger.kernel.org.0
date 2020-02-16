Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22E7816052B
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 18:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgBPRy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 12:54:29 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48492 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726037AbgBPRy3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Feb 2020 12:54:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=x6aNwekvk3qiLOoln+41ZToruqBFoD6RNXznXQIbku8=; b=qxM4kI1KGxtZcQjOPOKaJmdfT2
        0gl6HM2RaUUSmfxsAeDIXy60ncr/CauE9Gc2KzHEcKhzzn7UGAl8UvxbZyVSiqrmT7Aa6ZL5HHvbu
        5u/GSKcgoaCZYGfPIm+L0Lxg0pTli1w8DaEXSSa3jkK99A+JwJDJjvOodesG0RNfyfVw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j3O7d-0008T3-Rj; Sun, 16 Feb 2020 18:54:25 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 1/3] net: dsa: mv88e6xxx: Allow PCS registers to be retrieved via ethtool
Date:   Sun, 16 Feb 2020 18:54:13 +0100
Message-Id: <20200216175415.32505-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200216175415.32505-1-andrew@lunn.ch>
References: <20200216175415.32505-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ethtool provides a generic mechanism for a driver to return the
registers of an ethernet device. DSA uses this to give the port
registers associated with an interfaces. Extend this to allow PCS
registers to also be returned, if the port has a PCS associated to it.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 12 +++++++++++-
 drivers/net/dsa/mv88e6xxx/chip.h |  5 +++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 8c9289549688..316758a42a67 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1018,7 +1018,14 @@ static void mv88e6xxx_get_ethtool_stats(struct dsa_switch *ds, int port,
 
 static int mv88e6xxx_get_regs_len(struct dsa_switch *ds, int port)
 {
-	return 32 * sizeof(u16);
+	struct mv88e6xxx_chip *chip = ds->priv;
+	int len;
+
+	len = 32 * sizeof(u16);
+	if (chip->info->ops->serdes_get_regs_len)
+		len += chip->info->ops->serdes_get_regs_len(chip, port);
+
+	return len;
 }
 
 static void mv88e6xxx_get_regs(struct dsa_switch *ds, int port,
@@ -1043,6 +1050,9 @@ static void mv88e6xxx_get_regs(struct dsa_switch *ds, int port,
 			p[i] = reg;
 	}
 
+	if (chip->info->ops->serdes_get_regs)
+		chip->info->ops->serdes_get_regs(chip, port, &p[i]);
+
 	mv88e6xxx_reg_unlock(chip);
 }
 
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 79cad5e751c6..851686b45414 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -517,6 +517,11 @@ struct mv88e6xxx_ops {
 	int (*serdes_get_stats)(struct mv88e6xxx_chip *chip,  int port,
 				uint64_t *data);
 
+	/* SERDES registers for ethtool */
+	int (*serdes_get_regs_len)(struct mv88e6xxx_chip *chip,  int port);
+	void (*serdes_get_regs)(struct mv88e6xxx_chip *chip, int port,
+				void *_p);
+
 	/* Address Translation Unit operations */
 	int (*atu_get_hash)(struct mv88e6xxx_chip *chip, u8 *hash);
 	int (*atu_set_hash)(struct mv88e6xxx_chip *chip, u8 hash);
-- 
2.25.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFC82EF1B2
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 01:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387443AbfKEAN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 19:13:28 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48894 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387394AbfKEAN2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 19:13:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8Dtf8kOM2ZrSUpzuN3rxoC3SaU3Y5dJipo90ZDU3v3A=; b=ZkM5M3hLHyrQ+f4V7fN/ILN7hk
        h7dDRuAziEtAQ7LTQhNq836WBW2l3T2VV+q6lNOXb+sYdncRrV6Q9Z623ANKHbDVRpbcydc2frRXs
        fshATkLdpSlAbcFnFExDs1rrMZCzq4jC+wgA9sjqvPk6raW47QSrp9b3kFzAjfM9gRL0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iRmTD-0007I5-4H; Tue, 05 Nov 2019 01:13:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>, jiri@mellanox.com,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 4/5] net: dsa: mv88e6xxx: global1_atu: Add helper for get next
Date:   Tue,  5 Nov 2019 01:13:00 +0100
Message-Id: <20191105001301.27966-5-andrew@lunn.ch>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191105001301.27966-1-andrew@lunn.ch>
References: <20191105001301.27966-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When retrieving the ATU statistics, and ATU get next has to be
performed to trigger the ATU to collect the statistics. Export a
helper from global1_atu to perform this.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/global1.h     |  1 +
 drivers/net/dsa/mv88e6xxx/global1_atu.c |  5 +++++
 drivers/net/dsa/mv88e6xxx/global2.c     | 11 ++---------
 drivers/net/dsa/mv88e6xxx/global2.h     |  2 +-
 4 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/global1.h b/drivers/net/dsa/mv88e6xxx/global1.h
index 40fc0e13fc45..342172275841 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.h
+++ b/drivers/net/dsa/mv88e6xxx/global1.h
@@ -341,5 +341,6 @@ int mv88e6390_g1_vtu_loadpurge(struct mv88e6xxx_chip *chip,
 int mv88e6xxx_g1_vtu_flush(struct mv88e6xxx_chip *chip);
 int mv88e6xxx_g1_vtu_prob_irq_setup(struct mv88e6xxx_chip *chip);
 void mv88e6xxx_g1_vtu_prob_irq_free(struct mv88e6xxx_chip *chip);
+int mv88e6xxx_g1_atu_get_next(struct mv88e6xxx_chip *chip, u16 fid);
 
 #endif /* _MV88E6XXX_GLOBAL1_H */
diff --git a/drivers/net/dsa/mv88e6xxx/global1_atu.c b/drivers/net/dsa/mv88e6xxx/global1_atu.c
index d8a03bbba83c..bdcd25560dd2 100644
--- a/drivers/net/dsa/mv88e6xxx/global1_atu.c
+++ b/drivers/net/dsa/mv88e6xxx/global1_atu.c
@@ -154,6 +154,11 @@ static int mv88e6xxx_g1_atu_op(struct mv88e6xxx_chip *chip, u16 fid, u16 op)
 	return mv88e6xxx_g1_atu_op_wait(chip);
 }
 
+int mv88e6xxx_g1_atu_get_next(struct mv88e6xxx_chip *chip, u16 fid)
+{
+	return mv88e6xxx_g1_atu_op(chip, fid, MV88E6XXX_G1_ATU_OP_GET_NEXT_DB);
+}
+
 /* Offset 0x0C: ATU Data Register */
 
 static int mv88e6xxx_g1_atu_data_read(struct mv88e6xxx_chip *chip,
diff --git a/drivers/net/dsa/mv88e6xxx/global2.c b/drivers/net/dsa/mv88e6xxx/global2.c
index 14954d92c564..87bfe7c8c9cd 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.c
+++ b/drivers/net/dsa/mv88e6xxx/global2.c
@@ -288,16 +288,9 @@ int mv88e6xxx_g2_atu_stats_set(struct mv88e6xxx_chip *chip, u16 kind, u16 bin)
 				  kind | bin);
 }
 
-int mv88e6xxx_g2_atu_stats_get(struct mv88e6xxx_chip *chip)
+int mv88e6xxx_g2_atu_stats_get(struct mv88e6xxx_chip *chip, u16 *stats)
 {
-	int err;
-	u16 val;
-
-	err = mv88e6xxx_g2_read(chip, MV88E6XXX_G2_ATU_STATS, &val);
-	if (err)
-		return err;
-
-	return val & MV88E6XXX_G2_ATU_STATS_MASK;
+	return mv88e6xxx_g2_read(chip, MV88E6XXX_G2_ATU_STATS, stats);
 }
 
 /* Offset 0x0F: Priority Override Table */
diff --git a/drivers/net/dsa/mv88e6xxx/global2.h b/drivers/net/dsa/mv88e6xxx/global2.h
index a308ca7a7da6..d80ad203d126 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.h
+++ b/drivers/net/dsa/mv88e6xxx/global2.h
@@ -363,7 +363,7 @@ extern const struct mv88e6xxx_gpio_ops mv88e6352_gpio_ops;
 int mv88e6xxx_g2_scratch_gpio_set_smi(struct mv88e6xxx_chip *chip,
 				      bool external);
 int mv88e6xxx_g2_atu_stats_set(struct mv88e6xxx_chip *chip, u16 kind, u16 bin);
-int mv88e6xxx_g2_atu_stats_get(struct mv88e6xxx_chip *chip);
+int mv88e6xxx_g2_atu_stats_get(struct mv88e6xxx_chip *chip, u16 *stats);
 
 #else /* !CONFIG_NET_DSA_MV88E6XXX_GLOBAL2 */
 
-- 
2.23.0


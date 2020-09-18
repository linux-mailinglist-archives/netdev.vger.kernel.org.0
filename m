Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3272704BD
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 21:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbgIRTLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 15:11:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44194 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726236AbgIRTLa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 15:11:30 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kJLn2-00FH9G-0U; Fri, 18 Sep 2020 21:11:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v4 6/9] net: dsa: mv88e6xxx: Create helper for FIDs in use
Date:   Fri, 18 Sep 2020 21:11:06 +0200
Message-Id: <20200918191109.3640779-7-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200918191109.3640779-1-andrew@lunn.ch>
References: <20200918191109.3640779-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor the code in mv88e6xxx_atu_new() which builds a bitmaps of
FIDs in use into a helper function. This will be reused by the devlink
code when dumping the ATU.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 20 ++++++++++++++++----
 drivers/net/dsa/mv88e6xxx/chip.h |  2 ++
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 984bdcaff1ea..d8bb5e5e8583 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1466,21 +1466,21 @@ static int mv88e6xxx_vtu_loadpurge(struct mv88e6xxx_chip *chip,
 	return chip->info->ops->vtu_loadpurge(chip, entry);
 }
 
-static int mv88e6xxx_atu_new(struct mv88e6xxx_chip *chip, u16 *fid)
+int mv88e6xxx_fid_map(struct mv88e6xxx_chip *chip, unsigned long *fid_bitmap)
 {
-	DECLARE_BITMAP(fid_bitmap, MV88E6XXX_N_FID);
 	struct mv88e6xxx_vtu_entry vlan;
 	int i, err;
+	u16 fid;
 
 	bitmap_zero(fid_bitmap, MV88E6XXX_N_FID);
 
 	/* Set every FID bit used by the (un)bridged ports */
 	for (i = 0; i < mv88e6xxx_num_ports(chip); ++i) {
-		err = mv88e6xxx_port_get_fid(chip, i, fid);
+		err = mv88e6xxx_port_get_fid(chip, i, &fid);
 		if (err)
 			return err;
 
-		set_bit(*fid, fid_bitmap);
+		set_bit(fid, fid_bitmap);
 	}
 
 	/* Set every FID bit used by the VLAN entries */
@@ -1498,6 +1498,18 @@ static int mv88e6xxx_atu_new(struct mv88e6xxx_chip *chip, u16 *fid)
 		set_bit(vlan.fid, fid_bitmap);
 	} while (vlan.vid < chip->info->max_vid);
 
+	return 0;
+}
+
+static int mv88e6xxx_atu_new(struct mv88e6xxx_chip *chip, u16 *fid)
+{
+	DECLARE_BITMAP(fid_bitmap, MV88E6XXX_N_FID);
+	int err;
+
+	err = mv88e6xxx_fid_map(chip, fid_bitmap);
+	if (err)
+		return err;
+
 	/* The reset value 0x000 is used to indicate that multiple address
 	 * databases are not needed. Return the next positive available.
 	 */
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 823ae89e5fca..77d81aa99f37 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -689,4 +689,6 @@ static inline void mv88e6xxx_reg_unlock(struct mv88e6xxx_chip *chip)
 	mutex_unlock(&chip->reg_lock);
 }
 
+int mv88e6xxx_fid_map(struct mv88e6xxx_chip *chip, unsigned long *bitmap);
+
 #endif /* _MV88E6XXX_CHIP_H */
-- 
2.28.0

